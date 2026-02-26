package basis

import "core:slice"
import "core:strings"
import "core:mem"
import "core:hash"

StringHash :: u32

@(private="file")
HASH_SEED :: 0

makeStringHash :: proc "contextless" (str: string)  -> StringHash {
    raw := transmute(mem.Raw_String)str
    return hash.murmur32(raw.data[0:raw.len], HASH_SEED)
}

toInteropString :: proc "contextless" (str: string) -> InteropString {
    if (len(str) == 0) {
        return InteropString{nil, 0}
    }

    raw := transmute(mem.Raw_String)str
    return InteropString{raw.data, u32(len(str))}
}

fromInteropString :: proc "contextless" (is: InteropString) -> string {
    // This is what strings.string_from_ptr() does, but we don't call it
    // here to avoid having to pass the context.
    return transmute(string)mem.Raw_String{is.ptr, int(is.len)}
}

cloneFromInteropString :: proc (is: InteropString) -> string {
    return strings.clone_from_ptr(is.ptr, int(is.len))
}
