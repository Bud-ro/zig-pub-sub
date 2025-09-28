//! List of examples that this interface should try to work around

// One possible design:
// Constraints between struct members:
const A = struct {
    a: i8,
    b: i8,

    fn validate(self: *A) bool {
        self.a < self.b;
    }

    // TODO: Is there way to avoid this boiler plate?
    // Probably not, because this is also how you'd implement data memoization.
    // You'd probably also have to pass in an arena or something like that.
    fn generate(comptime a: i8, comptime b: i8) !A {
        const self = A{ .a = a, .b = b };
        if (self.validate()) {
            return self;
        } else {
            return error.ConstraintNotMet;
        }
    }
};

// Cons:
//   - Decent amount of (opt-in) boiler plate
// Pros:
//   - Helps to signal that a user type may be generated
//   - Constraints may be arbitrarily complex, and may reach into lower
//   - User code can `std.debug.assert(arg.validate());` to sanity check the data.
//     This ensures that unit tests are sound, allows integration tests to double check generated data, and incurs no cost in optimized builds.
//   - If there are no constraints, the type is unaffected. @hasDecl can be used to automatically call these.
