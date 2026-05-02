//! Protocol for types that carry their own validation logic. Types opt in
//! by declaring `pub fn validate(comptime self: T) void`. The helpers here
//! detect and invoke that declaration via @hasDecl, providing a uniform
//! entry point for validated construction.

/// Checks if a type has a comptime validate declaration.
pub fn hasValidate(comptime T: type) bool {
    return @hasDecl(T, "validate");
}

/// Checks if a type has a comptime generate declaration.
pub fn hasGenerate(comptime T: type) bool {
    return @hasDecl(T, "generate");
}

/// Calls T.validate on the value if the type supports it, then returns the value.
/// If the type has no validate, returns the value unchanged.
pub fn validated(comptime T: type, comptime value: T) T {
    if (hasValidate(T)) {
        T.validate(value);
    }
    return value;
}

/// Calls T.validate on the value if the type supports it.
/// If the type has no validate, does nothing.
pub fn assertValid(comptime T: type, comptime value: T) void {
    if (hasValidate(T)) {
        T.validate(value);
    }
}
