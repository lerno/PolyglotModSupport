module basis;

// Mod controller interface. Used when building the library as a mod.

//----------------------------------------------------

fn void mod_onAppStartup(IntPtr64 modControllerInterfaceIntPtr) @export("Mod_onAppStartup")
{
    // var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    // modControllerInterfacePtr.onAppStartup();
}

fn void mod_beforeAppShutdown(IntPtr64 modControllerInterfaceIntPtr) @export("Mod_beforeAppShutdown")
{
    // var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    // modControllerInterfacePtr.beforeAppShutdown();
}

fn void mod_onServerCreated(IntPtr64 modControllerInterfaceIntPtr) @export("Mod_onServerCreated")
{
    // var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    // modControllerInterfacePtr.onServerCreated();
}

fn void mod_beforeServerDestroyed(IntPtr64 modControllerInterfaceIntPtr) @export("Mod_beforeServerDestroyed")
{
    // var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    // modControllerInterfacePtr.beforeServerDestroyed();
}

fn void mod_clientUpdate(IntPtr64 modControllerInterfaceIntPtr, float deltaTime) @export("Mod_clientUpdate")
{
    // var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    // modControllerInterfacePtr.onClientUpdate(deltaTime);
}

fn void mod_serverUpdate(IntPtr64 modControllerInterfaceIntPtr, float deltaTime) @export("Mod_serverUpdate")
{
    // var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    // modControllerInterfacePtr.onServerUpdate(deltaTime);
}

fn void mod_clientTick(IntPtr64 modControllerInterfaceIntPtr, float tickDeltaTime) @export("Mod_clientTick")
{
    // var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    // modControllerInterfacePtr.onClientTick(tickDeltaTime);
}

fn void mod_serverTick(IntPtr64 modControllerInterfaceIntPtr, float tickDeltaTime) @export("Mod_serverTick")
{
    // var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    // modControllerInterfacePtr.onServerTick(tickDeltaTime);
}

fn void mod_registerAngelScriptTypes(IntPtr64 modControllerInterfaceIntPtr, CppPtr regPtr) @export("Mod_registerAngelScriptTypes")
{
    // var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    // const reg = basis.angelscript.TypeRegistration.init(regPtr);
    // modControllerInterfacePtr.registerAngelScriptTypes(reg);
}
