package basis

import "base:runtime"
import "core:mem"

// Mod controller interface. Used when building the library as a mod.

//----------------------------------------------------

@export
Mod_onAppStartup :: proc "c" (modControllerInterfaceIntPtr: IntPtr64) {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onAppStartup();
}

@export
Mod_beforeAppShutdown :: proc "c" (modControllerInterfaceIntPtr: IntPtr64) {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.beforeAppShutdown();
}

@export
Mod_onServerCreated :: proc "c" (modControllerInterfaceIntPtr: IntPtr64) {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onServerCreated();
}

@export
Mod_beforeServerDestroyed :: proc "c" (modControllerInterfaceIntPtr: IntPtr64) {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.beforeServerDestroyed();
}

@export
Mod_clientUpdate :: proc "c" (modControllerInterfaceIntPtr: IntPtr64, deltaTime: f32) {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onClientUpdate(deltaTime);

    // str: string = "Hello world from Odin!";
    // raw := transmute(mem.Raw_String)str
    // is := InteropString{raw.data, u32(len(str))}
    // _Core_printOnHost(is)
}

@export
Mod_serverUpdate :: proc "c" (modControllerInterfaceIntPtr: IntPtr64, deltaTime: f32) {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onServerUpdate(deltaTime);
}

@export
Mod_clientTick :: proc "c" (modControllerInterfaceIntPtr: IntPtr64, tickDeltaTime: f32) {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onClientTick(tickDeltaTime);
}

@export
Mod_serverTick :: proc "c" (modControllerInterfaceIntPtr: IntPtr64, tickDeltaTime: f32) {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onServerTick(tickDeltaTime);
}

@export
Mod_registerAngelScriptTypes :: proc "c" (modControllerInterfaceIntPtr: IntPtr64, regPtr: CppPtr) {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //const reg = angelscript.TypeRegistration.init(regPtr);
    //modControllerInterfacePtr.registerAngelScriptTypes(reg);
}
