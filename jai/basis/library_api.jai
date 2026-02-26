LibraryType :: enum u32 {
    Unknown :: 0;
    NativeDynamicLibrary :: 1;
    WASMClient :: 2;
    WASMServer :: 3;
}

_gLibCppPtr : InteropTypedPtr;

getLibCppPtr :: () -> InteropTypedPtr {
    return _gLibCppPtr;
}

getLibraryType :: () -> LibraryType {
    return LibraryType(_gLibCppPtr.type);
}

//----------------------------------------------------

#program_export
basisInit :: (libCppPtr: InteropTypedPtr) -> s32 #c_call {
    push_context {
        _gLibCppPtr = libCppPtr;

        // Zero means "no basisInit flags". To have the engine bind middleware such as Timbre, Goofy etc.
        // we need to specify their binding flags here. See the Zig code for how to do that.
        return 0;
    }
}

// Player controller:

#program_export
PlayerController_update :: (playerControllerInterfaceIntPtr: IntPtr64, deltaTime: float32) #c_call {
//     var playerControllerInterfacePtr = castIntPtr(PlayerControllerInterface, playerControllerInterfaceIntPtr);
//     playerControllerInterfacePtr.update(deltaTime);
}

#program_export
PlayerController_tick :: (playerControllerInterfaceIntPtr: IntPtr64, tickDeltaTime: float32) #c_call {
//     var playerControllerInterfacePtr = castIntPtr(PlayerControllerInterface, playerControllerInterfaceIntPtr);
//     playerControllerInterfacePtr.tick(tickDeltaTime);
}

#program_export
PlayerController_onMessageReceived :: (playerControllerInterfaceIntPtr: IntPtr64, message: s32, senderNameHash: u32, parametersIntPtr: CppPtr) #c_call {
//     var playerControllerInterfacePtr = castIntPtr(PlayerControllerInterface, playerControllerInterfaceIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     playerControllerInterfacePtr.onMessageReceived(message, senderNameHash, parameters);
}

// Component factory:

#program_export
CFactory_newComponent :: (factoryInterfaceIntPtr: IntPtr64, cppContextPtr: InteropTypedPtr, onClient: bool) -> IntPtr64 #c_call {
    push_context {
        factoryInterfacePtr := cast(*ComponentFactoryInterface)factoryInterfaceIntPtr;
        componentIntPtr := factoryInterfacePtr.newComponent(factoryInterfacePtr, cppContextPtr, onClient);
        return componentIntPtr;
    }
}

#program_export
CFactory_newComponent_WASM :: (factoryInterfaceIntPtr: IntPtr64, cppContextPtr_0: CppPtr, cppContextPtr_1: u32, onClient: bool) -> IntPtr64 #c_call {
//     return CFactory_newComponent(
//         factoryInterfaceIntPtr,
//         InteropTypedPtr{ .ptr = cppContextPtr_0, .type = cppContextPtr_1 },
//         onClient,
//     );
    return 0;
}

#program_export
CFactory_deleteComponent :: (factoryInterfaceIntPtr: IntPtr64, onClient: bool, componentIntPtr: IntPtr64) #c_call {
    push_context {
        factoryInterfacePtr := cast(*ComponentFactoryInterface)factoryInterfaceIntPtr;
        factoryInterfacePtr.deleteComponent(factoryInterfacePtr, onClient, componentIntPtr);
    }
}

#program_export
CFactory_updateComponents :: (factoryInterfaceIntPtr: IntPtr64, onClient: bool, deltaTime: float32) #c_call {
    push_context {
        factoryInterfacePtr := cast(*ComponentFactoryInterface)factoryInterfaceIntPtr;
        factoryInterfacePtr.update(factoryInterfacePtr, onClient, deltaTime);
    }
}

#program_export
CFactory_preTickComponents :: (factoryInterfaceIntPtr: IntPtr64, onClient: bool, tickDeltaTime: float32) #c_call {
    push_context {
        factoryInterfacePtr := cast(*ComponentFactoryInterface)factoryInterfaceIntPtr;
        factoryInterfacePtr.preTick(factoryInterfacePtr, onClient, tickDeltaTime);
    }
}

#program_export
CFactory_tickComponents :: (factoryInterfaceIntPtr: IntPtr64, onClient: bool, tickDeltaTime: float32) #c_call {
    push_context {
        factoryInterfacePtr := cast(*ComponentFactoryInterface)factoryInterfaceIntPtr;
        factoryInterfacePtr.tick(factoryInterfacePtr, onClient, tickDeltaTime);
    }
}

#program_export
CFactory_createBlueprintProperties :: (factoryInterfaceIntPtr: IntPtr64) -> IntPtr64 #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     const bppPropsIntPtr = factoryInterfacePtr.createBlueprintProperties();
//     return basis.bindings.hostIntPtrFromLib(bppPropsIntPtr);
    return 0;
}

#program_export
CFactory_loadBlueprintPropertiesJSON :: (factoryInterfaceIntPtr: IntPtr64, bpPropsIntPtr: IntPtr64, json: *InteropString) -> s32 #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return if (factoryInterfacePtr.bpPropsLoadJSON(basis.bindings.libIntPtrFromHost(bpPropsIntPtr), json.ptr[0..json.len])) 1 else 0;
    return 0;
}

#program_export
CFactory_loadBlueprintPropertiesJSON_WASM :: (factoryInterfaceIntPtr: IntPtr64, bpPropsIntPtr: IntPtr64, jsonPtr: *u8, jsonLength: u32) -> s32 #c_call {
//     const json = jsonPtr[0..jsonLength];
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return if (factoryInterfacePtr.bpPropsLoadJSON(basis.bindings.libIntPtrFromHost(bpPropsIntPtr), json)) 1 else 0;
    return 0;
}

#program_export
CFactory_setBlueprintProperties :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, bpPropsIntPtr: IntPtr64) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.setBlueprintProperties(
//         basis.bindings.libIntPtrFromHost(componentIntPtr),
//         basis.bindings.libIntPtrFromHost(bpPropsIntPtr),
//     );
}

#program_export
CFactory_readExposedPropertyLayout :: (factoryInterfaceIntPtr: IntPtr64, readerIntPtr: CppPtr) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.readExposedPropertyLayout(readerIntPtr);
}

#program_export
CFactory_readExposedPropertyMeta :: (
    factoryInterfaceIntPtr: IntPtr64,
    metaBuffer: *InteropExposedPropertyMeta,
    metaBufferLength: u32,
    defaultValueBuffer: *InteropBuffer,
    stringBuffer: *InteropBuffer,
) -> u32 #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return factoryInterfacePtr.readExposedPropertyMeta(metaBuffer, metaBufferLength, defaultValueBuffer, stringBuffer);
    return 0;
}

#program_export
CFactory_readExposedPropertyMeta_WASM :: (
    factoryInterfaceIntPtr: IntPtr64,
    metaBufferLength: u32, // In InteropExposedPropertyMeta elements
    metaBufferPtr: *u8,
    metaBufferByteLength: u32,
    defaultValueBufferPtr: *u8,
    defaultValueBufferLength: u32,
    stringBufferPtr: *u8,
    stringBufferLength: u32,
) -> u32 #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);

//     const META_BUFFER_MAX_COUNT = 64;
//     var metaBuffer: [META_BUFFER_MAX_COUNT]basis.bindings.InteropExposedPropertyMeta = undefined;

//     var defaultValueBuffer = basis.bindings.InteropBuffer{
//         .ptr = defaultValueBufferPtr,
//         .capacity = defaultValueBufferLength,
//         .len = 0,
//     };
//     var stringBuffer = basis.bindings.InteropBuffer{
//         .ptr = stringBufferPtr,
//         .capacity = stringBufferLength,
//         .len = 0,
//     };

//     const propertyCount = factoryInterfacePtr.readExposedPropertyMeta(
//         &metaBuffer,
//         @min(metaBufferLength, META_BUFFER_MAX_COUNT),
//         &defaultValueBuffer,
//         &stringBuffer,
//     );

//     if (propertyCount > 0) {
//         const metaBufferSlice = metaBufferPtr[0..metaBufferByteLength];
//         var stream = basis.BinaryWriteStream.init(metaBufferSlice, true);

//         // NOTE! If this serialization is changed, the counterpart in C++ in
//         // ZigWamrLibrary::CFactory_readExposedPropertyMeta() also must be changed.

//         // Prepend the data with the number of bytes written to the two other buffers.
//         stream.putInt(u32, defaultValueBuffer.len);
//         stream.putInt(u32, stringBuffer.len);

//         for (0..propertyCount) |i| {
//             stream.putInt(s32, metaBuffer[i].exposedPropertyType);
//             stream.putInt(s32, metaBuffer[i].typeID);
//             stream.putInt(s32, metaBuffer[i].versionAdded);
//             stream.putInt(s32, metaBuffer[i].defaultValueBufferOffset);

//             stream.putInt(u32, metaBuffer[i].nameStartOffset);
//             stream.putInt(u32, metaBuffer[i].nameLength);
//             stream.putInt(u32, metaBuffer[i].optionsStartOffset);
//             stream.putInt(u32, metaBuffer[i].optionsLength);
//         }
//     }

//     return propertyCount;
    return 0;
}

#program_export
CFactory_registerAngelScript :: (factoryInterfaceIntPtr: IntPtr64, componentRegistrationIntPtr: CppPtr) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.registerAngelScript(componentRegistrationIntPtr);
}

#program_export
CFactory_create :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) #c_call {
    push_context {
        factoryInterfacePtr := cast(*ComponentFactoryInterface)factoryInterfaceIntPtr;
        factoryInterfacePtr.create(factoryInterfacePtr, componentIntPtr);
    }
}

#program_export
CFactory_onObjectCreated :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) #c_call {
    push_context {
        factoryInterfacePtr := cast(*ComponentFactoryInterface)factoryInterfaceIntPtr;
        factoryInterfacePtr.onObjectCreated(factoryInterfacePtr, componentIntPtr);
    }
}

#program_export
CFactory_drawEditor :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, selected: bool, hoveredOver: bool) #c_call {
    push_context {
        factoryInterfacePtr := cast(*ComponentFactoryInterface)factoryInterfaceIntPtr;
        factoryInterfacePtr.drawEditor(factoryInterfacePtr, componentIntPtr, selected, hoveredOver);
    }
}

#program_export
CFactory_onMessageReceived :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, message: s32, senderNameHash: u32, parametersIntPtr: CppPtr) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     factoryInterfacePtr.onMessageReceived(basis.bindings.libIntPtrFromHost(componentIntPtr), message, senderNameHash, parameters);
}

#program_export
CFactory_onPipeDataReceived :: (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    pipe: u64,
    data: *u8,
    dataLength: u32) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     const dataSlice: []const u8 = data[0..dataLength];
//     factoryInterfacePtr.onPipeDataReceived(basis.bindings.libIntPtrFromHost(componentIntPtr), pipe, dataSlice);
}

#program_export
CFactory_onBecameClientLocalAvatar :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onBecameClientLocalAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

#program_export
CFactory_onLostClientLocalAvatar :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onLostClientLocalAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

#program_export
CFactory_onBecameServerAvatar :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, hostID: s32) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onBecameServerAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr), hostID);
}

#program_export
CFactory_onLostServerAvatar :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, hostID: s32) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onLostServerAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr), hostID);
}

#program_export
CFactory_syncExposedPropertyValues :: (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    valueBuffer: *InteropBuffer,
    direction: s32,
) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.syncExposedPropertyValues(basis.bindings.libIntPtrFromHost(componentIntPtr), valueBuffer, direction);
}

#program_export
CFactory_exposedPropertyEvent :: (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    propertyName: *InteropString,
    eventType: s32,
 ) -> s32 #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return factoryInterfacePtr.exposedPropertyEvent(basis.bindings.libIntPtrFromHost(componentIntPtr), propertyName, eventType);
    return 0;
}

#program_export
CFactory_exportLevel :: (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    phase: s32,
    dataBlockMgrCppPtr: CppPtr,
) -> s32 #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return factoryInterfacePtr.exportLevel(basis.bindings.libIntPtrFromHost(componentIntPtr), phase, dataBlockMgrCppPtr);
    return 0;
}

#program_export
CFactory_serializeEditorState :: (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    stateData: *InteropBuffer,
) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.serializeEditorState(basis.bindings.libIntPtrFromHost(componentIntPtr), stateData);
}

#program_export
CFactory_deserializeEditorState :: (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    stateData: *InteropString,
) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.deserializeEditorState(basis.bindings.libIntPtrFromHost(componentIntPtr), stateData);
}

#program_export
CFactory_resetEditorState :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.resetEditorState(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

#program_export
CFactory_editorStateModeChanged :: (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, editingEnabled: bool) #c_call {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.editorStateModeChanged(basis.bindings.libIntPtrFromHost(componentIntPtr), editingEnabled);
}

// Propagated value:

#program_export
PV_updateFloat :: (pvPtr: IntPtr64, value: float32, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(float32), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateDouble :: (pvPtr: IntPtr64, value: float64, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(float64), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateInt32 :: (pvPtr: IntPtr64, value: s32, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(s32), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateUint32 :: (pvPtr: IntPtr64, value: u32, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(u32), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateInt16 :: (pvPtr: IntPtr64, value: s16, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(s16), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateUint16 :: (pvPtr: IntPtr64, value: u16, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(u16), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateInt64 :: (pvPtr: IntPtr64, value: s64, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(s64), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateUint64 :: (pvPtr: IntPtr64, value: u64, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(u64), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateInt8 :: (pvPtr: IntPtr64, value: s8, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(s8), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateUint8 :: (pvPtr: IntPtr64, value: u8, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(u8), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateBool :: (pvPtr: IntPtr64, value: bool, localChange: bool, valueTime: float64) #c_call {
//     var pv = castIntPtr(PropagatedValue(bool), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

#program_export
PV_updateVec2 :: (pvPtr: IntPtr64, value: *InteropVec2, localChange: bool, valueTime: float64) #c_call {
//     const v = basis.math.Vec2.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec2), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

#program_export
PV_updateVec2_WASM :: (pvPtr: IntPtr64, x: float32, y: float32, localChange: bool, valueTime: float64) #c_call {
//     const v = basis.math.Vec2.init(x, y);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec2), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

#program_export
PV_updateVec3 :: (pvPtr: IntPtr64, value: *InteropVec3, localChange: bool, valueTime: float64) #c_call {
//     const v = basis.math.Vec3.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec3), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

#program_export
PV_updateVec3_WASM :: (pvPtr: IntPtr64, x: float32, y: float32, z: float32, localChange: bool, valueTime: float64) #c_call {
//     const v = basis.math.Vec3.init(x, y, z);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec3), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

#program_export
PV_updateVec4 :: (pvPtr: IntPtr64, value: *InteropVec4, localChange: bool, valueTime: float64) #c_call {
//     const v = basis.math.Vec4.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec4), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

#program_export
PV_updateVec4_WASM :: (pvPtr: IntPtr64, x: float32, y: float32, z: float32, w: float32, localChange: bool, valueTime: float64) #c_call {
//     const v = basis.math.Vec4.init(x, y, z, w);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec4), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

#program_export
PV_updateQuaternion :: (pvPtr: IntPtr64, value: *InteropQuaternion, localChange: bool, valueTime: float64) #c_call {
//     const q = basis.math.Quaternion.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Quaternion), pvPtr);
//     pv._setPropagated(q, localChange, valueTime);
}

#program_export
PV_updateQuaternion_WASM :: (pvPtr: IntPtr64, w: float32, x: float32, y: float32, z: float32, localChange: bool, valueTime: float64) #c_call {
//     const q = basis.math.Quaternion.init(w, x, y, z);
//     var pv = castIntPtr(PropagatedValue(basis.math.Quaternion), pvPtr);
//     pv._setPropagated(q, localChange, valueTime);
}

#program_export
PV_updateMat43 :: (pvPtr: IntPtr64, value: *InteropMat43, localChange: bool, valueTime: float64) #c_call {
//     const m = basis.math.Mat43.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Mat43), pvPtr);
//     pv._setPropagated(m, localChange, valueTime);
}

#program_export
PA_fire :: (paPtr: IntPtr64, localChange: bool, valueTime: float64) #c_call {
//     var pa = castIntPtr(PropagatedAction, paPtr);
//     pa._firePropagated(localChange, valueTime);
}

// Resource mananger:

#program_export
ResourceManager_resourceWasReloaded :: (resourceCppPtr: CppPtr, callbackID: u32) #c_call {
//     basis.resources.resource_manager._resourceWasReloaded(resourceCppPtr, callbackID);
}

// Flow state:

#program_export
FlowState_deinit :: (flowStateInterfaceIntPtr: IntPtr64) #c_call {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.deinit();
}

#program_export
FlowState_onEnter :: (flowStateInterfaceIntPtr: IntPtr64) #c_call {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.onEnter();
}

#program_export
FlowState_onExit :: (flowStateInterfaceIntPtr: IntPtr64) #c_call {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.onExit();
}

#program_export
FlowState_update :: (flowStateInterfaceIntPtr: IntPtr64, deltaTime: float32) #c_call {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.update(deltaTime);
}

#program_export
FlowState_isLoadingComplete :: (flowStateInterfaceIntPtr: IntPtr64) -> s32 #c_call {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     return if (flowStateInterfacePtr.isLoadingComplete()) 1 else 0;
    return 0;
}

#program_export
FlowState_onMessageReceived :: (flowStateInterfaceIntPtr: IntPtr64, message: s32, senderNameHash: u32, parametersIntPtr: CppPtr) #c_call {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     flowStateInterfacePtr.onMessageReceived(message, senderNameHash, parameters);
}

// Debug overlay:

#program_export
DebugOverlay_runImGuiMenuBarCallbacks :: () #c_call {
//     basis.debug_overlay._runImGuiMenuBarCallbacks();
}

#program_export
DebugOverlay_runImGuiCallbacks :: () #c_call {
//     basis.debug_overlay._runImGuiCallbacks();
}

// Message node:

#program_export
MessageNode_onMessageReceived :: (nodeIntPtr: IntPtr64, message: s32, senderNameHash: u32, parametersIntPtr: CppPtr) #c_call {
//     const node = castIntPtr(MessageNode, nodeIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     if (node.onMessageReceived) |delegate| {
//         delegate.call(message, senderNameHash, parameters);
//     }
}

// Physics:

#program_export
Physics_onTriggerEnterEvent :: (triggerActorIntPtr: CppPtr, otherActorIntPtr: CppPtr, otherActorType: u32) #c_call {
//     basis.physics.physics_trigger._onTriggerEnterEvent(triggerActorIntPtr, otherActorIntPtr, otherActorType);
}

#program_export
Physics_onTriggerExitEvent :: (triggerActorIntPtr: CppPtr, otherActorIntPtr: CppPtr, otherActorType: u32, otherActorRemoved: bool) #c_call {
//     basis.physics.physics_trigger._onTriggerExitEvent(triggerActorIntPtr, otherActorIntPtr, otherActorType, otherActorRemoved);
}

#program_export
Physics_onCollisionCallback :: (sceneIntPtr: CppPtr, interopCollisionData: *InteropCollisionData) #c_call {
//     var collisionData = basis.physics.CollisionData{};

//     collisionData.shape0 = basis.physics.PhysicsShapePtr{ .cppPtr = interopCollisionData.shape0 };
//     collisionData.shape1 = basis.physics.PhysicsShapePtr{ .cppPtr = interopCollisionData.shape1 };

//     collisionData.collisionPoints.len = @intCast(interopCollisionData.collisionPointCount);
//     for (0..interopCollisionData.collisionPointCount) |i| {
//         const src = interopCollisionData.collisionPoints[i];
//         var point: *basis.physics.physics_scene.CollisionPoint = &collisionData.collisionPoints.slice()[i];

//         point.position = basis.math.Vec3.fromInterop(src.position);
//         point.normal = basis.math.Vec3.fromInterop(src.normal);
//         point.impulse = basis.math.Vec3.fromInterop(src.impulse);
//         point.force = src.force;
//         point.material0 = basis.physics.PhysicsMaterialPtr{ .cppPtr = src.material0 };
//         point.material1 = basis.physics.PhysicsMaterialPtr{ .cppPtr = src.material1 };
//     }

//     basis.physics.physics_scene._onCollisionCallback(sceneIntPtr, &collisionData);
}
