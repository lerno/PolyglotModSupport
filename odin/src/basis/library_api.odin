package basis

import "base:runtime"

LibraryType :: enum u32 {
    Unknown = 0,
    NativeDynamicLibrary = 1,
    WASMClient = 2,
    WASMServer = 3,
}

@(private="file")
_gLibCppPtr: InteropTypedPtr

@(private="file")
_gContext: runtime.Context

getLibCppPtr :: proc() -> InteropTypedPtr {
    return _gLibCppPtr
}

getLibraryType :: proc() -> LibraryType {
    return LibraryType(_gLibCppPtr.type)
}

getContext :: proc() -> runtime.Context {
    return _gContext
}

//----------------------------------------------------

@export
basisInit :: proc "c" (libCppPtr: InteropTypedPtr) -> i32
{
    _gLibCppPtr = libCppPtr

    _gContext = runtime.default_context()

    // Zero means "no basisInit flags". To have the engine bind middleware such as Timbre, Goofy etc.
    // we need to specify their binding flags here. See the Zig code for how to do that.
    return 0
}

// Player controller:

@export
PlayerController_update :: proc "c" (playerControllerInterfaceIntPtr: IntPtr64, deltaTime: f32) {
//     var playerControllerInterfacePtr = castIntPtr(PlayerControllerInterface, playerControllerInterfaceIntPtr);
//     playerControllerInterfacePtr.update(deltaTime);
}

@export
PlayerController_tick :: proc "c" (playerControllerInterfaceIntPtr: IntPtr64, tickDeltaTime: f32) {
//     var playerControllerInterfacePtr = castIntPtr(PlayerControllerInterface, playerControllerInterfaceIntPtr);
//     playerControllerInterfacePtr.tick(tickDeltaTime);
}

@export
PlayerController_onMessageReceived :: proc "c" (playerControllerInterfaceIntPtr: IntPtr64, message: i32, senderNameHash: u32, parametersIntPtr: CppPtr) {
//     var playerControllerInterfacePtr = castIntPtr(PlayerControllerInterface, playerControllerInterfaceIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     playerControllerInterfacePtr.onMessageReceived(message, senderNameHash, parameters);
}

// Component factory:

@export
CFactory_newComponent :: proc "c" (factoryInterfaceIntPtr: IntPtr64, cppContextPtr: InteropTypedPtr, onClient: bool) -> IntPtr64 {
    context = _gContext
    factoryInterfacePtr := cast(^ComponentFactoryInterface)uintptr(factoryInterfaceIntPtr)
    componentIntPtr := factoryInterfacePtr.newComponent(factoryInterfacePtr, cppContextPtr, onClient)
    return componentIntPtr
}

@export
CFactory_newComponent_WASM :: proc "c" (factoryInterfaceIntPtr: IntPtr64, cppContextPtr_0: CppPtr, cppContextPtr_1: u32, onClient: bool) -> IntPtr64 {
//     return CFactory_newComponent(
//         factoryInterfaceIntPtr,
//         InteropTypedPtr{ .ptr = cppContextPtr_0, .type = cppContextPtr_1 },
//         onClient,
//     );
    return 0
}

@export
CFactory_deleteComponent :: proc "c" (factoryInterfaceIntPtr: IntPtr64, onClient: bool, componentIntPtr: IntPtr64) {
    context = _gContext
    factoryInterfacePtr := cast(^ComponentFactoryInterface)uintptr(factoryInterfaceIntPtr)
    factoryInterfacePtr.deleteComponent(factoryInterfacePtr, onClient, componentIntPtr)
}

@export
CFactory_updateComponents :: proc "c" (factoryInterfaceIntPtr: IntPtr64, onClient: bool, deltaTime: f32) {
    context = _gContext
    factoryInterfacePtr := cast(^ComponentFactoryInterface)uintptr(factoryInterfaceIntPtr)
    factoryInterfacePtr.update(factoryInterfacePtr, onClient, deltaTime)
}

@export
CFactory_preTickComponents :: proc "c" (factoryInterfaceIntPtr: IntPtr64, onClient: bool, tickDeltaTime: f32) {
    context = _gContext
    factoryInterfacePtr := cast(^ComponentFactoryInterface)uintptr(factoryInterfaceIntPtr)
    factoryInterfacePtr.preTick(factoryInterfacePtr, onClient, tickDeltaTime)
}

@export
CFactory_tickComponents :: proc "c" (factoryInterfaceIntPtr: IntPtr64, onClient: bool, tickDeltaTime: f32) {
    context = _gContext
    factoryInterfacePtr := cast(^ComponentFactoryInterface)uintptr(factoryInterfaceIntPtr)
    factoryInterfacePtr.tick(factoryInterfacePtr, onClient, tickDeltaTime)
}

@export
CFactory_createBlueprintProperties :: proc "c" (factoryInterfaceIntPtr: IntPtr64) -> IntPtr64 {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     const bppPropsIntPtr = factoryInterfacePtr.createBlueprintProperties();
//     return basis.bindings.hostIntPtrFromLib(bppPropsIntPtr);
    return 0
}

@export
CFactory_loadBlueprintPropertiesJSON :: proc "c" (factoryInterfaceIntPtr: IntPtr64, bpPropsIntPtr: IntPtr64, #by_ptr json: InteropString) -> i32 {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return if (factoryInterfacePtr.bpPropsLoadJSON(basis.bindings.libIntPtrFromHost(bpPropsIntPtr), json.ptr[0..json.len])) 1 else 0;
    return 0
}

@export
CFactory_loadBlueprintPropertiesJSON_WASM :: proc "c" (factoryInterfaceIntPtr: IntPtr64, bpPropsIntPtr: IntPtr64, jsonPtr: [^]u8, jsonLength: u32) -> i32 {
//     const json = jsonPtr[0..jsonLength];
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return if (factoryInterfacePtr.bpPropsLoadJSON(basis.bindings.libIntPtrFromHost(bpPropsIntPtr), json)) 1 else 0;
    return 0
}

@export
CFactory_setBlueprintProperties :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, bpPropsIntPtr: IntPtr64) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.setBlueprintProperties(
//         basis.bindings.libIntPtrFromHost(componentIntPtr),
//         basis.bindings.libIntPtrFromHost(bpPropsIntPtr),
//     );
}

@export
CFactory_readExposedPropertyLayout :: proc "c" (factoryInterfaceIntPtr: IntPtr64, readerIntPtr: CppPtr) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.readExposedPropertyLayout(readerIntPtr);
}

@export
CFactory_readExposedPropertyMeta :: proc "c" (
    factoryInterfaceIntPtr: IntPtr64,
    #by_ptr metaBuffer: InteropExposedPropertyMeta,
    metaBufferLength: u32,
    #by_ptr defaultValueBuffer: InteropBuffer,
    #by_ptr stringBuffer: InteropBuffer,
) -> u32 {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return factoryInterfacePtr.readExposedPropertyMeta(metaBuffer, metaBufferLength, defaultValueBuffer, stringBuffer);
    return 0
}

@export
CFactory_readExposedPropertyMeta_WASM :: proc "c" (
    factoryInterfaceIntPtr: IntPtr64,
    metaBufferLength: u32, // In InteropExposedPropertyMeta elements
    metaBufferPtr: [^]u8,
    metaBufferByteLength: u32,
    defaultValueBufferPtr: [^]u8,
    defaultValueBufferLength: u32,
    stringBufferPtr: [^]u8,
    stringBufferLength: u32,
) -> u32 {
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
//             stream.putInt(i32, metaBuffer[i].exposedPropertyType);
//             stream.putInt(i32, metaBuffer[i].typeID);
//             stream.putInt(i32, metaBuffer[i].versionAdded);
//             stream.putInt(i32, metaBuffer[i].defaultValueBufferOffset);

//             stream.putInt(u32, metaBuffer[i].nameStartOffset);
//             stream.putInt(u32, metaBuffer[i].nameLength);
//             stream.putInt(u32, metaBuffer[i].optionsStartOffset);
//             stream.putInt(u32, metaBuffer[i].optionsLength);
//         }
//     }

//     return propertyCount;
    return 0
}

@export
CFactory_registerAngelScript :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentRegistrationIntPtr: CppPtr) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.registerAngelScript(componentRegistrationIntPtr);
}

@export
CFactory_create :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) {
    context = _gContext
    factoryInterfacePtr := cast(^ComponentFactoryInterface)uintptr(factoryInterfaceIntPtr)
    factoryInterfacePtr.create(factoryInterfacePtr, componentIntPtr)
}

@export
CFactory_onObjectCreated :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) {
    context = _gContext
    factoryInterfacePtr := cast(^ComponentFactoryInterface)uintptr(factoryInterfaceIntPtr)
    factoryInterfacePtr.onObjectCreated(factoryInterfacePtr, componentIntPtr)
}

@export
CFactory_drawEditor :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, selected: bool, hoveredOver: bool) {
    context = _gContext
    factoryInterfacePtr := cast(^ComponentFactoryInterface)uintptr(factoryInterfaceIntPtr)
    factoryInterfacePtr.drawEditor(factoryInterfacePtr, componentIntPtr, selected, hoveredOver)
}

@export
CFactory_onMessageReceived :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, message: i32, senderNameHash: u32, parametersIntPtr: CppPtr) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     factoryInterfacePtr.onMessageReceived(basis.bindings.libIntPtrFromHost(componentIntPtr), message, senderNameHash, parameters);
}

@export
CFactory_onPipeDataReceived :: proc "c" (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    pipe: u64,
    data: [^]u8,
    dataLength: u32) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     const dataSlice: []const u8 = data[0..dataLength];
//     factoryInterfacePtr.onPipeDataReceived(basis.bindings.libIntPtrFromHost(componentIntPtr), pipe, dataSlice);
}

@export
CFactory_onBecameClientLocalAvatar :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onBecameClientLocalAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

@export
CFactory_onLostClientLocalAvatar :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onLostClientLocalAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

@export
CFactory_onBecameServerAvatar :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, hostID: i32) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onBecameServerAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr), hostID);
}

@export
CFactory_onLostServerAvatar :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, hostID: i32) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onLostServerAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr), hostID);
}

@export
CFactory_syncExposedPropertyValues :: proc "c" (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    #by_ptr valueBuffer: InteropBuffer,
    direction: i32,
) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.syncExposedPropertyValues(basis.bindings.libIntPtrFromHost(componentIntPtr), valueBuffer, direction);
}

@export
CFactory_exposedPropertyEvent :: proc "c" (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    #by_ptr propertyName: InteropString,
    eventType: i32,
 ) -> i32 {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return factoryInterfacePtr.exposedPropertyEvent(basis.bindings.libIntPtrFromHost(componentIntPtr), propertyName, eventType);
    return 0
}

@export
CFactory_exportLevel :: proc "c" (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    phase: i32,
    dataBlockMgrCppPtr: CppPtr,
) -> i32 {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return factoryInterfacePtr.exportLevel(basis.bindings.libIntPtrFromHost(componentIntPtr), phase, dataBlockMgrCppPtr);
    return 0
}

@export
CFactory_serializeEditorState :: proc "c" (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    #by_ptr stateData: InteropBuffer,
) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.serializeEditorState(basis.bindings.libIntPtrFromHost(componentIntPtr), stateData);
}

@export
CFactory_deserializeEditorState :: proc "c" (
    factoryInterfaceIntPtr: IntPtr64,
    componentIntPtr: IntPtr64,
    #by_ptr stateData: InteropString,
) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.deserializeEditorState(basis.bindings.libIntPtrFromHost(componentIntPtr), stateData);
}

@export
CFactory_resetEditorState :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.resetEditorState(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

@export
CFactory_editorStateModeChanged :: proc "c" (factoryInterfaceIntPtr: IntPtr64, componentIntPtr: IntPtr64, editingEnabled: bool) {
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.editorStateModeChanged(basis.bindings.libIntPtrFromHost(componentIntPtr), editingEnabled);
}

// Propagated value:

@export
PV_updateFloat :: proc "c" (pvPtr: IntPtr64, value: f32, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(f32), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateDouble :: proc "c" (pvPtr: IntPtr64, value: f64, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(f64), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateInt32 :: proc "c" (pvPtr: IntPtr64, value: i32, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(i32), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateUint32 :: proc "c" (pvPtr: IntPtr64, value: u32, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(u32), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateInt16 :: proc "c" (pvPtr: IntPtr64, value: i16, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(i16), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateUint16 :: proc "c" (pvPtr: IntPtr64, value: u16, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(u16), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateInt64 :: proc "c" (pvPtr: IntPtr64, value: i64, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(i64), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateUint64 :: proc "c" (pvPtr: IntPtr64, value: u64, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(u64), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateInt8 :: proc "c" (pvPtr: IntPtr64, value: i8, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(i8), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateUint8 :: proc "c" (pvPtr: IntPtr64, value: u8, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(u8), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateBool :: proc "c" (pvPtr: IntPtr64, value: bool, localChange: bool, valueTime: f64) {
//     var pv = castIntPtr(PropagatedValue(bool), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

@export
PV_updateVec2 :: proc "c" (pvPtr: IntPtr64, #by_ptr value: InteropVec2, localChange: bool, valueTime: f64) {
//     const v = basis.math.Vec2.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec2), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

@export
PV_updateVec2_WASM :: proc "c" (pvPtr: IntPtr64, x: f32, y: f32, localChange: bool, valueTime: f64) {
//     const v = basis.math.Vec2.init(x, y);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec2), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

@export
PV_updateVec3 :: proc "c" (pvPtr: IntPtr64, #by_ptr value: InteropVec3, localChange: bool, valueTime: f64) {
//     const v = basis.math.Vec3.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec3), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

@export
PV_updateVec3_WASM :: proc "c" (pvPtr: IntPtr64, x: f32, y: f32, z: f32, localChange: bool, valueTime: f64) {
//     const v = basis.math.Vec3.init(x, y, z);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec3), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

@export
PV_updateVec4 :: proc "c" (pvPtr: IntPtr64, #by_ptr value: InteropVec4, localChange: bool, valueTime: f64) {
//     const v = basis.math.Vec4.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec4), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

@export
PV_updateVec4_WASM :: proc "c" (pvPtr: IntPtr64, x: f32, y: f32, z: f32, w: f32, localChange: bool, valueTime: f64) {
//     const v = basis.math.Vec4.init(x, y, z, w);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec4), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

@export
PV_updateQuaternion :: proc "c" (pvPtr: IntPtr64, #by_ptr value: InteropQuaternion, localChange: bool, valueTime: f64) {
//     const q = basis.math.Quaternion.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Quaternion), pvPtr);
//     pv._setPropagated(q, localChange, valueTime);
}

@export
PV_updateQuaternion_WASM :: proc "c" (pvPtr: IntPtr64, w: f32, x: f32, y: f32, z: f32, localChange: bool, valueTime: f64) {
//     const q = basis.math.Quaternion.init(w, x, y, z);
//     var pv = castIntPtr(PropagatedValue(basis.math.Quaternion), pvPtr);
//     pv._setPropagated(q, localChange, valueTime);
}

@export
PV_updateMat43 :: proc "c" (pvPtr: IntPtr64, #by_ptr value: InteropMat43, localChange: bool, valueTime: f64) {
//     const m = basis.math.Mat43.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Mat43), pvPtr);
//     pv._setPropagated(m, localChange, valueTime);
}

@export
PA_fire :: proc "c" (paPtr: IntPtr64, localChange: bool, valueTime: f64) {
//     var pa = castIntPtr(PropagatedAction, paPtr);
//     pa._firePropagated(localChange, valueTime);
}

// Resource mananger:

@export
ResourceManager_resourceWasReloaded :: proc "c" (resourceCppPtr: CppPtr, callbackID: u32) {
//     basis.resources.resource_manager._resourceWasReloaded(resourceCppPtr, callbackID);
}

// Flow state:

@export
FlowState_deinit :: proc "c" (flowStateInterfaceIntPtr: IntPtr64) {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.deinit();
}

@export
FlowState_onEnter :: proc "c" (flowStateInterfaceIntPtr: IntPtr64) {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.onEnter();
}

@export
FlowState_onExit :: proc "c" (flowStateInterfaceIntPtr: IntPtr64) {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.onExit();
}

@export
FlowState_update :: proc "c" (flowStateInterfaceIntPtr: IntPtr64, deltaTime: f32) {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.update(deltaTime);
}

@export
FlowState_isLoadingComplete :: proc "c" (flowStateInterfaceIntPtr: IntPtr64) -> i32 {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     return if (flowStateInterfacePtr.isLoadingComplete()) 1 else 0;
    return 0
}

@export
FlowState_onMessageReceived :: proc "c" (flowStateInterfaceIntPtr: IntPtr64, message: i32, senderNameHash: u32, parametersIntPtr: CppPtr) {
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     flowStateInterfacePtr.onMessageReceived(message, senderNameHash, parameters);
}

// Debug overlay:

@export
DebugOverlay_runImGuiMenuBarCallbacks :: proc "c" () {
//     basis.debug_overlay._runImGuiMenuBarCallbacks();
}

@export
DebugOverlay_runImGuiCallbacks :: proc "c" () {
//     basis.debug_overlay._runImGuiCallbacks();
}

// Message node:

@export
MessageNode_onMessageReceived :: proc "c" (nodeIntPtr: IntPtr64, message: i32, senderNameHash: u32, parametersIntPtr: CppPtr) {
//     const node = castIntPtr(MessageNode, nodeIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     if (node.onMessageReceived) |delegate| {
//         delegate.call(message, senderNameHash, parameters);
//     }
}

// Physics:

@export
Physics_onTriggerEnterEvent :: proc "c" (triggerActorIntPtr: CppPtr, otherActorIntPtr: CppPtr, otherActorType: u32) {
//     basis.physics.physics_trigger._onTriggerEnterEvent(triggerActorIntPtr, otherActorIntPtr, otherActorType);
}

@export
Physics_onTriggerExitEvent :: proc "c" (triggerActorIntPtr: CppPtr, otherActorIntPtr: CppPtr, otherActorType: u32, otherActorRemoved: bool) {
//     basis.physics.physics_trigger._onTriggerExitEvent(triggerActorIntPtr, otherActorIntPtr, otherActorType, otherActorRemoved);
}

@export
Physics_onCollisionCallback :: proc "c" (sceneIntPtr: CppPtr, #by_ptr interopCollisionData: InteropCollisionData) {
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
