
// Mod controller interface. Used when building the library as a mod.

//----------------------------------------------------

#program_export
Mod_onAppStartup :: (modControllerInterfaceIntPtr: IntPtr64) #c_call {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onAppStartup();

    // push_context {
    //     debugTrace("I'm aJAIve!");
    // }
}

#program_export
Mod_beforeAppShutdown :: (modControllerInterfaceIntPtr: IntPtr64) #c_call {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.beforeAppShutdown();
}

#program_export
Mod_onServerCreated :: (modControllerInterfaceIntPtr: IntPtr64) #c_call {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onServerCreated();
}

#program_export
Mod_beforeServerDestroyed :: (modControllerInterfaceIntPtr: IntPtr64) #c_call {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.beforeServerDestroyed();
}

#program_export
Mod_clientUpdate :: (modControllerInterfaceIntPtr: IntPtr64, deltaTime: float32) #c_call {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onClientUpdate(deltaTime);

    // {
    //     iopP0 := InteropVec3.{153.8128, 68.76864, -193.5182};
    //     iopP1 := InteropVec3.{152.0964, 73.9599, -193.4507};
    //     iopP2 := InteropVec3.{152.045, 71.14144, -189.3678};
    //     iopCol0 := InteropColor.{255, 0, 0, 255};
    //     iopCol1 := InteropColor.{0, 255, 0, 255};
    //     iopCol2 := InteropColor.{0, 0, 255, 255};

    //     _DebugDraw_drawTriangle3D(*iopP0, *iopP1, *iopP2, *iopCol0, *iopCol1, *iopCol2);
    // }

    // {
    //     text := "Cool tJAIangle!";
    //     iopStr := InteropString.{text.data, cast(u32) text.count};

    //     iopPos := InteropVec3.{150.1588, 71.24632, -191.8329};
    //     iopCol := InteropColor.{255, 255, 255, 255};

    //     _DebugDraw_drawString(*iopStr, *iopPos, *iopCol);
    // }
}

#program_export
Mod_serverUpdate :: (modControllerInterfaceIntPtr: IntPtr64, deltaTime: float32) #c_call {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onServerUpdate(deltaTime);
}

#program_export
Mod_clientTick :: (modControllerInterfaceIntPtr: IntPtr64, tickDeltaTime: float32) #c_call {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onClientTick(tickDeltaTime);
}

#program_export
Mod_serverTick :: (modControllerInterfaceIntPtr: IntPtr64, tickDeltaTime: float32) #c_call {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //modControllerInterfacePtr.onServerTick(tickDeltaTime);
}

#program_export
Mod_registerAngelScriptTypes :: (modControllerInterfaceIntPtr: IntPtr64, regPtr: CppPtr) #c_call {
    //var modControllerInterfacePtr = castIntPtr(ModControllerInterface, modControllerInterfaceIntPtr);
    //const reg = angelscript.TypeRegistration.init(regPtr);
    //modControllerInterfacePtr.registerAngelScriptTypes(reg);
}
