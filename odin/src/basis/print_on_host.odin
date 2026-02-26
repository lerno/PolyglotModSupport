package basis

import fmtlib "core:fmt"

printf :: proc(fmt: string, args: ..any) {
    str := fmtlib.aprintf(fmt, ..args)
    interopStr := toInteropString(str)
    _Core_printOnHost(interopStr)
    delete(str)
}
