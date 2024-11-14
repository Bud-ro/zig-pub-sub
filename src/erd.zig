// ERDs only need 16 bits. If your system has more than 65535 statically known and named variables, then find god
const ErdHandle = u16;

const Erd = struct {
    erd_handle: ErdHandle,
    T: type,
};
