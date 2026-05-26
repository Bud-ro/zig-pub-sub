#!/usr/bin/env python3
"""Post-process Zig C backend output for SDCC (mcs51) compatibility.

SDCC for the 8051 cannot pass or return structs by value.  The Zig C
backend emits code that does both extensively.  This script rewrites
function signatures and call sites so that every struct-by-value
parameter becomes a const-pointer parameter, and every struct return
value becomes an output-pointer parameter (prepended as first arg).

Additionally fixes:
  - #include "zig.h" -> #include "zig_sdcc_shim.h"
  - static void const -> static char const
  - zig_static_assert lines removed
  - Empty array initializers {} -> {0}
  - Top-level const on scalar/pointer params stripped (SDCC mismatch)
  - Compound literals replaced with static const locals
  - Labels made unique per function (SDCC duplicate label bug)
"""

import re
import sys


def split_params(params_str):
    """Split function parameters, respecting nested parens (for fn ptr types)."""
    result = []
    depth = 0
    current = []
    for ch in params_str:
        if ch == ',' and depth == 0:
            result.append(''.join(current))
            current = []
        else:
            if ch == '(':
                depth += 1
            elif ch == ')':
                depth -= 1
            current.append(ch)
    if current:
        result.append(''.join(current))
    return result


def is_func_signature_line(line):
    """Check if a line is a function declaration or definition (not a variable)."""
    stripped = line.rstrip()
    if not (stripped.endswith(';') or stripped.endswith('{')):
        return False
    if not (line.startswith('static ') or line.startswith('zig_extern ')
            or line.startswith('zig_cold ') or line.startswith('void ')
            or line.startswith('extern ')):
        return False
    if '(' not in line:
        return False
    # Must not have = before the first (  -- that would be a variable init
    paren_idx = line.index('(')
    if '=' in line[:paren_idx]:
        return False
    # The prefix before ( must end with a valid function name identifier
    prefix = line[:paren_idx].rstrip()
    if not prefix:
        return False
    # Last token should be a C identifier (possibly with leading *)
    last_token = prefix.split()[-1]
    name = last_token.lstrip('*')
    if not re.match(r'^[a-zA-Z_]\w*$', name):
        return False
    return True


def parse_func_signature(line):
    """Parse a function signature line.

    Returns (ret_prefix, returns_ptr, func_name, params_str, suffix) or None.
    """
    stripped = line.rstrip()
    suffix = stripped[-1]  # ';' or '{'

    paren_start = line.index('(')
    paren_end = line.rindex(')')

    prefix = line[:paren_start].rstrip()
    params_str = line[paren_start+1:paren_end].strip()

    tokens = prefix.split()
    if not tokens:
        return None

    func_token = tokens[-1]
    returns_ptr = func_token.startswith('*')
    func_name = func_token.lstrip('*')

    ret_prefix = ' '.join(tokens[:-1])

    return (ret_prefix, returns_ptr, func_name, params_str, suffix)


def identify_functions(lines):
    """Identify functions with struct-by-value params or returns."""
    byval_funcs = {}
    retval_funcs = {}

    for line in lines:
        if not is_func_signature_line(line):
            continue
        parsed = parse_func_signature(line)
        if parsed is None:
            continue

        ret_prefix, returns_ptr, func_name, params_str, suffix = parsed

        # struct return by value (no pointer)
        if 'struct ' in ret_prefix and not returns_ptr:
            m = re.search(r'(struct\s+\S+)', ret_prefix)
            if m:
                retval_funcs[func_name] = m.group(1)

        if params_str in ('void', ''):
            continue

        params = split_params(params_str)
        for i, param in enumerate(params):
            param = param.strip()
            if param.startswith('struct ') and '*' not in param:
                m = re.match(r'(struct\s+\S+)', param)
                if m:
                    if func_name not in byval_funcs:
                        byval_funcs[func_name] = {}
                    byval_funcs[func_name][i] = m.group(1)

    return byval_funcs, retval_funcs


def rewrite_signature_line(line, func_name, byval_params, ret_struct):
    """Rewrite a single function signature line for struct-by-value fixes."""
    parsed = parse_func_signature(line)
    if parsed is None:
        return line

    ret_prefix, returns_ptr, fname, params_str, suffix = parsed

    indent = line[:len(line) - len(line.lstrip())]

    new_ret_prefix = ret_prefix
    if ret_struct and not returns_ptr:
        new_ret_prefix = re.sub(r'struct\s+\S+', 'void', ret_prefix, count=1)

    params = split_params(params_str) if params_str not in ('void', '') else []
    new_params = []

    if ret_struct:
        new_params.append(f'{ret_struct} *__ret')

    for i, param in enumerate(params):
        param = param.strip()
        if i in byval_params:
            m = re.match(r'(struct\s+\S+)\s+(?:const\s+)?(a\d+)', param)
            if m:
                new_params.append(f'{m.group(1)} const *{m.group(2)}')
            else:
                new_params.append(param)
        else:
            new_params.append(param)

    if not new_params:
        new_params = ['void']

    ptr_str = '*' if returns_ptr else ''
    new_line = f'{indent}{new_ret_prefix} {ptr_str}{func_name}({", ".join(new_params)}) {suffix}'
    return new_line


def strip_param_const(text):
    """Strip top-level const from function parameters.

    SDCC treats `void f(int a)` and `void f(int const a)` as different types
    in forward declarations, causing error 98.  In C, top-level const on
    parameters is meaningless for the prototype.  This function strips such
    const qualifiers to make declarations and definitions match.

    We target patterns like:
      TYPE const aX  ->  TYPE aX
      TYPE *const aX  ->  TYPE *aX  (const on the pointer itself)
    inside function signatures.
    """
    # Match function parameter lists and strip const before the param name
    # Pattern: after a comma or opening paren, find `TYPE const aN`
    # This is hard to do precisely. Instead, just remove ` const ` before
    # parameter names `a0` through `a9` at end of tokens.
    # Also remove `const ` right after `*` for pointer params.

    # Strip `TYPE const aX` -> `TYPE aX` (not inside struct definitions)
    # Only in lines that look like function signatures
    lines = text.split('\n')
    result = []
    for line in lines:
        if is_func_signature_line(line):
            # Strip top-level const from params:
            # `uint8_t const a0` -> `uint8_t a0`
            # `struct X *const a0` -> `struct X *a0`
            parsed = parse_func_signature(line)
            if parsed:
                ret_prefix, returns_ptr, func_name, params_str, suffix = parsed
                if params_str not in ('void', ''):
                    params = split_params(params_str)
                    new_params = []
                    for p in params:
                        p = p.strip()
                        # Remove `const` right before the parameter name
                        # Matches: `TYPE const aX` or `TYPE *const aX`
                        p = re.sub(r'\bconst\s+(a\d+)$', r'\1', p)
                        p = re.sub(r'\*const\s+(a\d+)$', r'*\1', p)
                        new_params.append(p)
                    indent = line[:len(line) - len(line.lstrip())]
                    ptr_str = '*' if returns_ptr else ''
                    line = f'{indent}{ret_prefix} {ptr_str}{func_name}({", ".join(new_params)}) {suffix}'
        result.append(line)
    return '\n'.join(result)


def make_labels_unique(text):
    """Make zig_block_N and zig_loop_N labels unique per function.

    SDCC 4.2 appears to report duplicate label errors even though labels
    should be function-scoped.  We prefix each label with the function name
    to make them globally unique.
    """
    lines = text.split('\n')
    result = []
    current_func = ''
    func_counter = 0

    for line in lines:
        # Detect function definition start
        if is_func_signature_line(line) and line.rstrip().endswith('{'):
            parsed = parse_func_signature(line)
            if parsed:
                _, _, func_name, _, _ = parsed
                current_func = f'f{func_counter}_'
                func_counter += 1

        if current_func:
            # Replace label definitions: `zig_block_N:` and `zig_loop_N:`
            line = re.sub(r'\b(zig_(?:block|loop)_\d+)\b',
                          lambda m: current_func + m.group(1), line)

        result.append(line)
    return '\n'.join(result)


def find_compound_literals_in_line(line):
    """Find all compound literals (struct TYPE){...} in a line.

    Returns list of (start_col, end_col, struct_type, init_content).
    start_col is the position of '(' in (struct TYPE).
    end_col is the position after the closing '}'.
    """
    results = []
    i = 0
    while i < len(line):
        m = re.match(r'\(struct\s+([a-zA-Z0-9_]+)\)', line[i:])
        if m and i + len(m.group(0)) < len(line) and line[i + len(m.group(0))] == '{':
            struct_type = f'struct {m.group(1)}'
            brace_start = i + len(m.group(0))
            depth = 0
            j = brace_start
            while j < len(line):
                if line[j] == '{':
                    depth += 1
                elif line[j] == '}':
                    depth -= 1
                    if depth == 0:
                        break
                j += 1
            if depth == 0:
                init_content = line[brace_start:j+1]
                results.append((i, j+1, struct_type, init_content))
                i = j + 1
                continue
        i += 1
    return results


def fix_compound_literals(text):
    """Replace ALL compound literals with file-scope static consts.

    SDCC does not support compound literals (C99 feature not implemented).
    This handles compound literals in any context:
      - Function arguments: func((struct T){...})
      - Assignments: (*ptr) = (struct T){...}
      - Member access: (struct T){...}.member
    """
    lines = text.split('\n')
    counter = [0]

    # Pass 1: Find function boundaries and ALL compound literals within them
    func_decls = {}  # func_start_idx -> [decl_text, ...]
    replacements = {}  # (line_idx, col_start, col_end) -> name

    in_function = False
    brace_depth = 0
    current_func_start = None

    for idx, line in enumerate(lines):
        if not in_function:
            if is_func_signature_line(line) and line.rstrip().endswith('{'):
                in_function = True
                brace_depth = 1
                current_func_start = idx
        else:
            brace_depth += line.count('{') - line.count('}')
            if brace_depth <= 0:
                in_function = False
                current_func_start = None

        if in_function and '(struct ' in line and '{' in line:
            for col_s, col_e, struct_type, init_content in find_compound_literals_in_line(line):
                name = f'__cl_{counter[0]}'
                counter[0] += 1
                decl = f'static {struct_type} const {name} = {init_content};'
                if current_func_start not in func_decls:
                    func_decls[current_func_start] = []
                func_decls[current_func_start].append(decl)
                replacements[(idx, col_s, col_e)] = name

    # Pass 2: Build output with replacements and inserted declarations
    result = []
    for idx, line in enumerate(lines):
        if idx in func_decls:
            for decl in func_decls[idx]:
                result.append(decl)

        line_replacements = sorted(
            [(col_s, col_e, name) for (lidx, col_s, col_e), name in replacements.items()
             if lidx == idx],
            reverse=True)
        for col_s, col_e, name in line_replacements:
            line = line[:col_s] + name + line[col_e:]

        result.append(line)

    return '\n'.join(result)


def transform_body_for_byval(body_lines, byval_params):
    """Dereference pointer params that used to be by-value."""
    for pidx in byval_params:
        pname = f'a{pidx}'
        for j in range(len(body_lines)):
            # `aX.field` -> `aX->field` (struct member access)
            body_lines[j] = re.sub(
                rf'\b{pname}\.',
                f'{pname}->',
                body_lines[j])
            # ` = aX;` -> ` = *aX;`
            body_lines[j] = re.sub(
                rf'(\s)= {pname};',
                rf'\1= *{pname};',
                body_lines[j])
            # `(void)aX;` -> `(void)*aX;`
            body_lines[j] = re.sub(
                rf'\(void\){pname};',
                f'(void)*{pname};',
                body_lines[j])
            # `)aX` after cast -> `)*aX`
            # But not `->aX` or `.aX`
            body_lines[j] = re.sub(
                rf'(?<![->.])(\)\s*){pname}\b(?!->)',
                rf'\1*{pname}',
                body_lines[j])
    return body_lines


def transform_body_for_retval(body_lines, ret_struct):
    """Transform `return expr;` to `*__ret = expr; return;`."""
    for j in range(len(body_lines)):
        m = re.match(r'^(\s*)return\s+(.+);', body_lines[j])
        if m:
            indent = m.group(1)
            expr = m.group(2)
            body_lines[j] = f'{indent}*__ret = {expr}; return;'
    return body_lines


def find_call_in_line(line, func_name, start_pos=0):
    """Find a call to func_name in line starting from start_pos."""
    idx = line.find(func_name + '(', start_pos)
    while idx >= 0:
        if idx > 0 and (line[idx-1].isalnum() or line[idx-1] == '_'):
            idx = line.find(func_name + '(', idx + 1)
            continue
        args_start = idx + len(func_name) + 1
        depth = 1
        pos = args_start
        while pos < len(line) and depth > 0:
            if line[pos] == '(':
                depth += 1
            elif line[pos] == ')':
                depth -= 1
            pos += 1
        if depth == 0:
            return (idx, args_start, pos - 1)
        break
    return None


def fix_call_sites_in_line(line, byval_funcs, retval_funcs):
    """Fix function call sites in a single line."""
    for func_name in set(byval_funcs.keys()) | set(retval_funcs.keys()):
        start = 0
        iterations = 0
        while iterations < 20:  # safety limit
            iterations += 1
            result = find_call_in_line(line, func_name, start)
            if result is None:
                break

            call_start, args_start, args_end = result
            args_str = line[args_start:args_end]
            args = split_params(args_str)

            bv_params = byval_funcs.get(func_name, {})
            ret_struct = retval_funcs.get(func_name)

            new_args = []
            for i, arg in enumerate(args):
                arg = arg.strip()
                if i in bv_params:
                    if not arg:
                        new_args.append(arg)
                    else:
                        new_args.append(f'&{arg}')
                else:
                    new_args.append(arg)

            if ret_struct:
                before = line[:call_start]
                after = line[args_end + 1:]
                assign_match = re.search(r'(\S+)\s*=\s*$', before)
                if assign_match:
                    var_name = assign_match.group(1)
                    pre_assign = before[:assign_match.start()]
                    all_args = [f'&{var_name}'] + new_args
                    new_call = f'{func_name}({", ".join(all_args)})'
                    line = f'{pre_assign}{new_call}{after}'
                else:
                    new_call = f'{func_name}({", ".join(new_args)})'
                    line = before + new_call + after
            else:
                before = line[:args_start]
                after = line[args_end:]
                new_call = ', '.join(new_args)
                line = before + new_call + after

            start = call_start + len(func_name) + 1

    return line


def patch_file(path):
    with open(path, 'r') as f:
        text = f.read()

    # 1. Replace zig.h include
    text = text.replace('#include "zig.h"', '#include "zig_sdcc_shim.h"')

    # 2. Fix static void const
    text = re.sub(r'^static void const ', 'static char const ', text, flags=re.MULTILINE)

    # 3. Remove zig_static_assert lines
    text = re.sub(r'^zig_static_assert\(.*\);\n', '', text, flags=re.MULTILINE)

    # 4. Fix empty array initializers: `= {};` -> `= {0};`
    text = text.replace('= {};', '= {0};')

    # 4b. Remove zero-length zig_errorName array (unused on freestanding)
    text = re.sub(r'^.*zig_errorName\[0\].*$', '/* zig_errorName removed */', text, flags=re.MULTILINE)

    # 4c. Remove designated initializers from aggregate initializers.
    # Designated initializers appear as `{ .name = expr }` or `{ .name = { ... } }`.
    # Only match `.name = ` when preceded by `{`, `,`, or whitespace in an initializer.
    # The pattern `(?<=[{,])\s*\.\w+\s*=\s*` catches `.name = ` after { or ,
    text = re.sub(r'(?<=[{,])\s*\.\w+\s*=\s*', ' ', text)

    # 4d. Remove unused comptime metadata constants.
    # The Zig C backend emits Target, CPU feature, CallingConvention, and
    # bitset constants that are never used at runtime.  These are huge and
    # contain initializers SDCC cannot parse (casts, large arrays, etc.).
    remove_prefixes = (
        'static struct Target_',
        'static struct bit_set_',
        'static struct builtin_CallingConvention_',
        'static struct SemanticVersion_',
        'static enum__Target_',
        'static enum__builtin_CallingConvention_',
        'static enum__builtin_OutputMode_',
        'static enum__builtin_CompilerBackend_',
        'static enum__builtin_Endian_',
        'static uintptr_t const bit_set_',
    )
    lines_tmp = text.split('\n')
    text = '\n'.join(
        line if not any(line.startswith(p) for p in remove_prefixes)
        else f'/* removed: {line[:60]}... */'
        for line in lines_tmp
    )

    # 4e. Simplify pointer cast chains in static const initializers.
    # SDCC does not accept `(uint8_t const *)((struct X const *)&var)` as
    # a constant expression.  Simplify to `(uint8_t const *)&var`.
    text = re.sub(
        r'\(\(uint8_t const \*\)\(\(struct \S+ const \*\)(&\w+)\)\)',
        r'(uint8_t const *)\1',
        text)

    # 4f. Replace GCC inline asm with SDCC inline asm.
    # `__asm volatile(""::);` -> `__asm nop __endasm;`
    text = re.sub(
        r'__asm\s+volatile\s*\(\s*""[^)]*\)\s*;',
        '__asm nop __endasm;',
        text)

    # 5. Strip top-level const from function parameters
    text = strip_param_const(text)

    # 6. Replace compound literals with static const variables
    text = fix_compound_literals(text)

    # 7. Make labels unique per function
    text = make_labels_unique(text)

    lines = text.split('\n')

    # Phase 1: Identify functions needing struct-by-value fixes
    byval_funcs, retval_funcs = identify_functions(lines)

    # Phase 2: Rewrite function signatures and bodies
    result_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        handled = False

        if is_func_signature_line(line):
            parsed = parse_func_signature(line)
            if parsed:
                _, _, func_name, _, suffix = parsed
                bv = byval_funcs.get(func_name, {})
                rv = retval_funcs.get(func_name)

                if bv or rv:
                    new_line = rewrite_signature_line(line, func_name, bv, rv)
                    result_lines.append(new_line)
                    handled = True

                    if suffix == '{':
                        body_lines = []
                        brace_depth = 1
                        i += 1
                        while i < len(lines) and brace_depth > 0:
                            brace_depth += lines[i].count('{') - lines[i].count('}')
                            body_lines.append(lines[i])
                            i += 1

                        if bv:
                            body_lines = transform_body_for_byval(body_lines, bv)
                        if rv:
                            body_lines = transform_body_for_retval(body_lines, rv)

                        for j in range(len(body_lines)):
                            body_lines[j] = fix_call_sites_in_line(
                                body_lines[j], byval_funcs, retval_funcs)

                        result_lines.extend(body_lines)
                        continue

        if not handled:
            line = fix_call_sites_in_line(line, byval_funcs, retval_funcs)
            result_lines.append(line)

        i += 1

    text = '\n'.join(result_lines)

    with open(path, 'w') as f:
        f.write(text)


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f'Usage: {sys.argv[0]} <firmware.c>', file=sys.stderr)
        sys.exit(1)
    patch_file(sys.argv[1])
