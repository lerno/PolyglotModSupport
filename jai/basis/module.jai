#import "Basic";

IntPtr :: u64;
IntPtr64 :: u64;
CppPtr :: u64;
WasmFuncPtr :: u32;

StringHash :: u32;

#load "bindings.jai";
#load "library_api.jai";
#load "library_api_mod.jai";

#load "generated_bind_types.jai";
#load "generated_bind_function_pointers.jai";
#load "generated_bind_functions.jai";

#load "murmur32.jai";
#load "string_utils.jai";

#load "components.jai";
#load "component_factory.jai";

print :: (format_string: string, args: .. Any) {
    result := tprint(format_string, ..args);

    interopString := InteropString.{result.data, cast(u32) result.count };

    _Core_printOnHost(*interopString);
}

debugTrace :: (format_string: string, args: .. Any) {
    result := tprint(format_string, ..args);

    interopString := InteropString.{result.data, cast(u32) result.count };

    _DebugOverlay_debugTrace(result.data, cast(u32) result.count);
}
