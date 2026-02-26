module basis;

// Note! Keep this in sync with the C++ side.
enum LibraryType : const uint
{
    UNKNOWN = 0,
    NATIVE_DYNAMIC_LIBRARY = 1,
    WASM_CLIENT = 2,
    WASM_SERVER = 3,
}

// Note! Keep this in sync with the C++ side.
enum BasisInitFlags : const uint
{
    NONE = 0,
    BIND_GOOFY = (1 << 0),
    BIND_TIMBRE = (1 << 1),
    BIND_NEMO = (1 << 2),
    BIND_MERLIN = (1 << 3),
    BIND_TRAMPOLINE = (1 << 4),
}

InteropTypedPtr _gLibCppPtr = { .ptr = 0, .type = 0 };

fn InteropTypedPtr getLibCppPtr()
{
    return _gLibCppPtr;
}

fn LibraryType getZigLibraryType()
{
	LibraryType type = (LibraryType)_gLibCppPtr.type;
	return type;
}

//----------------------------------------------------

// Exported engine C-api:

fn uint basisInit(InteropTypedPtr libCppPtr) @export("basisInit")
{
    _gLibCppPtr = libCppPtr;

    uint flags = 0;

    // By default we bind everything.
    // TODO: Make this adjustable, eg. using zig build system options.
    // flags |= (uint)BasisInitFlags.BIND_GOOFY;
    // flags |= (uint)BasisInitFlags.BIND_TIMBRE;
    // flags |= (uint)BasisInitFlags.BIND_NEMO;
    // flags |= (uint)BasisInitFlags.BIND_MERLIN;
    // flags |= (uint)BasisInitFlags.BIND_TRAMPOLINE;

    return flags;
}

// fn uint basisInit_WASM(char* buffer, uint bufferLength) @export("basisInit_WASM")
// {
//     basis.assert(@src(), bufferLength == @sizeOf(InteropTypedPtr));

//     // We can do either...
//     const zigLibCppPtr: InteropTypedPtr = @bitCast(buffer[0..@sizeOf(InteropTypedPtr)].*);
//     //------
//     // ...or...
//     //------
//     //var zigLibCppPtr: InteropTypedPtr = undefined;
//     //const addr = std.mem.asBytes(&zigLibCppPtr);
//     //@memcpy(addr[0..bufferLength], buffer[0..bufferLength]);
//     //------
//     // ...to create the structured data out of the buffer.
//     return basisInit(zigLibCppPtr);
// }

// export fn basisDeinit() void {
//     // Any cleanup to do?
// }

// App / Mod controller:

// comptime {
//     // The library API looks a bit different depending on whether we are building
//     // the app or a mod, so import the correct functions here.
//     _ = if (basis.build_options.buildAsMod)
//         @import("library_api_mod.zig")
//     else
//         @import("library_api_app.zig");
// }

// Player controller:

fn void playerController_update(IntPtr64 playerControllerInterfaceIntPtr, float deltaTime) @export("PlayerController_update")
{
    // var playerControllerInterfacePtr = castIntPtr(PlayerControllerInterface, playerControllerInterfaceIntPtr);
    // playerControllerInterfacePtr.update(deltaTime);
}

fn void playerController_tick(IntPtr64 playerControllerInterfaceIntPtr, float tickDeltaTime) @export("PlayerController_tick")
{
    // var playerControllerInterfacePtr = castIntPtr(PlayerControllerInterface, playerControllerInterfaceIntPtr);
    // playerControllerInterfacePtr.tick(tickDeltaTime);
}

fn void playerController_onMessageReceived(IntPtr64 playerControllerInterfaceIntPtr, int message, uint senderNameHash, CppPtr parametersIntPtr) @export("PlayerController_onMessageReceived")
{
    // var playerControllerInterfacePtr = castIntPtr(PlayerControllerInterface, playerControllerInterfaceIntPtr);
    // const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
    // playerControllerInterfacePtr.onMessageReceived(message, senderNameHash, parameters);
}

// Component factory:

fn IntPtr64 cFactory_newComponent(IntPtr64 factoryInterfaceIntPtr, InteropTypedPtr cppContextPtr, bool onClient) @export("CFactory_newComponent")
{
	IComponentFactory* iface = (IComponentFactory*)factoryInterfaceIntPtr;
	return iface.newComponent(cppContextPtr, onClient);

    // var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
    // const componentIntPtr = factoryInterfacePtr.newComponent(cppContextPtr, onClient);
    // return basis.bindings.hostIntPtrFromLib(componentIntPtr);
	//return 0;
}

// export fn CFactory_newComponent_WASM(IntPtr64 factoryInterfaceIntPtr, cppContextPtr_0: basis.CppPtr, cppContextPtr_1: u32, onClient: bool) basis.IntPtr64 {
//     return CFactory_newComponent(
//         factoryInterfaceIntPtr,
//         InteropTypedPtr{ .ptr = cppContextPtr_0, .type = cppContextPtr_1 },
//         onClient,
//     );
// }

fn void cFactory_deleteComponent(IntPtr64 factoryInterfaceIntPtr, bool onClient, IntPtr64 componentIntPtr) @export("CFactory_deleteComponent")
{
	IComponentFactory* iface = (IComponentFactory*)factoryInterfaceIntPtr;
	iface.deleteComponent(onClient, componentIntPtr);

    // var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
    // const compIntPtr = basis.bindings.libIntPtrFromHost(componentIntPtr);
    // factoryInterfacePtr.deleteComponent(onClient, compIntPtr);
}

fn void cFactory_updateComponents(IntPtr64 factoryInterfaceIntPtr, bool onClient, float deltaTime) @export("CFactory_updateComponents")
{
	IComponentFactory* iface = (IComponentFactory*)factoryInterfaceIntPtr;
	iface.update(onClient, deltaTime);
    //var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
    //factoryInterfacePtr.update(onClient, deltaTime);
}

fn void cFactory_preTickComponents(IntPtr64 factoryInterfaceIntPtr, bool onClient, float tickDeltaTime) @export("CFactory_preTickComponents")
{
	IComponentFactory* iface = (IComponentFactory*)factoryInterfaceIntPtr;
	iface.preTick(onClient, tickDeltaTime);
    //var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
    //factoryInterfacePtr.preTick(onClient, tickDeltaTime);
}

fn void cFactory_tickComponents(IntPtr64 factoryInterfaceIntPtr, bool onClient, float tickDeltaTime) @export("CFactory_tickComponents")
{
	IComponentFactory* iface = (IComponentFactory*)factoryInterfaceIntPtr;
	iface.tick(onClient, tickDeltaTime);
    //var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
    //factoryInterfacePtr.tick(onClient, tickDeltaTime);
}

fn IntPtr64 cFactory_createBlueprintProperties(IntPtr64 factoryInterfaceIntPtr) @export("CFactory_createBlueprintProperties")
{
    //var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
    //const bppPropsIntPtr = factoryInterfacePtr.createBlueprintProperties();
    //return basis.bindings.hostIntPtrFromLib(bppPropsIntPtr);
	return 0;
}

fn int cFactory_loadBlueprintPropertiesJSON(IntPtr64 factoryInterfaceIntPtr, IntPtr64 bpPropsIntPtr, InteropString* json) @export("CFactory_loadBlueprintPropertiesJSON")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return if (factoryInterfacePtr.bpPropsLoadJSON(basis.bindings.libIntPtrFromHost(bpPropsIntPtr), json.ptr[0..json.len])) 1 else 0;
	return 0;
}

//fn int cFactory_loadBlueprintPropertiesJSON_WASM(IntPtr64 factoryInterfaceIntPtr, IntPtr64 bpPropsIntPtr, char* jsonPtr, uint jsonLength)  @export("CFactory_loadBlueprintPropertiesJSON_WASM")
//{
//     const json = jsonPtr[0..jsonLength];
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return if (factoryInterfacePtr.bpPropsLoadJSON(basis.bindings.libIntPtrFromHost(bpPropsIntPtr), json)) 1 else 0;
//}

fn void cFactory_setBlueprintProperties(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr, IntPtr64 bpPropsIntPtr) @export("CFactory_setBlueprintProperties")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.setBlueprintProperties(
//         basis.bindings.libIntPtrFromHost(componentIntPtr),
//         basis.bindings.libIntPtrFromHost(bpPropsIntPtr),
//     );
}

fn void cFactory_readExposedPropertyLayout(IntPtr64 factoryInterfaceIntPtr, CppPtr readerIntPtr) @export("CFactory_readExposedPropertyLayout")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.readExposedPropertyLayout(readerIntPtr);
}

fn uint cFactory_readExposedPropertyMeta(
    IntPtr64 factoryInterfaceIntPtr,
    InteropExposedPropertyMeta* metaBuffer,
    uint metaBufferLength,
    InteropBuffer* defaultValueBuffer,
    InteropBuffer* stringBuffer,
) @export("CFactory_readExposedPropertyMeta")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return factoryInterfacePtr.readExposedPropertyMeta(metaBuffer, metaBufferLength, defaultValueBuffer, stringBuffer);
	return 0;
}

//fn CFactory_readExposedPropertyMeta_WASM(
//     IntPtr64 factoryInterfaceIntPtr,
//     metaBufferLength: u32, // In InteropExposedPropertyMeta elements
//     metaBufferPtr: [*c]u8,
//     metaBufferByteLength: u32,
//     defaultValueBufferPtr: [*c]u8,
//     defaultValueBufferLength: u32,
//     stringBufferPtr: [*c]u8,
//     stringBufferLength: u32,
// ) u32 {
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
//}

fn void cFactory_registerAngelScript(
    IntPtr64 factoryInterfaceIntPtr,
    CppPtr componentRegistrationIntPtr,
) @export("CFactory_registerAngelScript")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.registerAngelScript(componentRegistrationIntPtr);
}

fn void cFactory_create(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr) @export("CFactory_create")
{
	IComponentFactory* iface = (IComponentFactory*)factoryInterfaceIntPtr;
	iface.create(componentIntPtr);
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.create(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

fn void cFactory_onObjectCreated(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr) @export("CFactory_onObjectCreated")
{
	IComponentFactory* iface = (IComponentFactory*)factoryInterfaceIntPtr;
	iface.onObjectCreated(componentIntPtr);
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onObjectCreated(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

fn void cFactory_drawEditor(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr, bool selected, bool hoveredOver) @export("CFactory_drawEditor")
{
	IComponentFactory* iface = (IComponentFactory*)factoryInterfaceIntPtr;
	iface.drawEditor(componentIntPtr, selected, hoveredOver);
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.drawEditor(basis.bindings.libIntPtrFromHost(componentIntPtr), selected, hoveredOver);
}

fn void cFactory_onMessageReceived(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr, int message2, uint senderNameHash, CppPtr parametersIntPtr) @export("CFactory_onMessageReceived")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     factoryInterfacePtr.onMessageReceived(basis.bindings.libIntPtrFromHost(componentIntPtr), message, senderNameHash, parameters);
}

fn void cFactory_onPipeDataReceived(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr, ulong pipe, char* data, uint dataLength) @export("CFactory_onPipeDataReceived")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     const dataSlice: []const u8 = data[0..dataLength];
//     factoryInterfacePtr.onPipeDataReceived(basis.bindings.libIntPtrFromHost(componentIntPtr), pipe, dataSlice);
}

fn void cFactory_onBecameClientLocalAvatar(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr) @export("CFactory_onBecameClientLocalAvatar")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onBecameClientLocalAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

fn void cFactory_onLostClientLocalAvatar(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr) @export("CFactory_onLostClientLocalAvatar")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onLostClientLocalAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

fn void cFactory_onBecameServerAvatar(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr, int hostID) @export("CFactory_onBecameServerAvatar")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onBecameServerAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr), hostID);
}

fn void cFactory_onLostServerAvatar(IntPtr64 factoryInterfaceIntPtr, IntPtr64 componentIntPtr, int hostID) @export("CFactory_onLostServerAvatar")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.onLostServerAvatar(basis.bindings.libIntPtrFromHost(componentIntPtr), hostID);
}

fn void cFactory_syncExposedPropertyValues(
    IntPtr64 factoryInterfaceIntPtr,
    IntPtr64 componentIntPtr,
    InteropBuffer* valueBuffer,
    int direction,
) @export("CFactory_syncExposedPropertyValues")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.syncExposedPropertyValues(basis.bindings.libIntPtrFromHost(componentIntPtr), valueBuffer, direction);
}

fn int cFactory_exposedPropertyEvent(
    IntPtr64 factoryInterfaceIntPtr,
    IntPtr64 componentIntPtr,
    InteropString* propertyName,
    int eventType,
) @export("CFactory_exposedPropertyEvent")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return factoryInterfacePtr.exposedPropertyEvent(basis.bindings.libIntPtrFromHost(componentIntPtr), propertyName, eventType);
	return 0;
}

fn int cFactory_exportLevel(
    IntPtr64 factoryInterfaceIntPtr,
    IntPtr64 componentIntPtr,
    int phase,
    CppPtr dataBlockMgrCppPtr,
) @export("CFactory_exportLevel")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     return factoryInterfacePtr.exportLevel(basis.bindings.libIntPtrFromHost(componentIntPtr), phase, dataBlockMgrCppPtr);
	return 0;
}

fn void cFactory_serializeEditorState(
    IntPtr64 factoryInterfaceIntPtr,
    IntPtr64 componentIntPtr,
    InteropBuffer* stateData,
) @export("CFactory_serializeEditorState")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.serializeEditorState(basis.bindings.libIntPtrFromHost(componentIntPtr), stateData);
}

fn void cFactory_deserializeEditorState(
    IntPtr64 factoryInterfaceIntPtr,
    IntPtr64 componentIntPtr,
    InteropString* stateData,
) @export("CFactory_deserializeEditorState")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.deserializeEditorState(basis.bindings.libIntPtrFromHost(componentIntPtr), stateData);
}

fn void cFactory_resetEditorState(
    IntPtr64 factoryInterfaceIntPtr,
    IntPtr64 componentIntPtr,
) @export("CFactory_resetEditorState")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.resetEditorState(basis.bindings.libIntPtrFromHost(componentIntPtr));
}

fn void cFactory_editorStateModeChanged(
    IntPtr64 factoryInterfaceIntPtr,
    IntPtr64 componentIntPtr,
    bool editingEnabled,
) @export("CFactory_editorStateModeChanged")
{
//     var factoryInterfacePtr = castIntPtr(ComponentFactoryInterface, factoryInterfaceIntPtr);
//     factoryInterfacePtr.editorStateModeChanged(basis.bindings.libIntPtrFromHost(componentIntPtr), editingEnabled);
}

// Propagated value:

fn void pV_updateFloat(IntPtr64 pvPtr, float value, bool localChange, double valueTime) @export("PV_updateFloat")
{
//     var pv = castIntPtr(PropagatedValue(f32), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateDouble(IntPtr64 pvPtr, double value, bool localChange, double valueTime) @export("PV_updateDouble")
{
//     var pv = castIntPtr(PropagatedValue(f64), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateInt32(IntPtr64 pvPtr, int value, bool localChange, double valueTime) @export("PV_updateInt32")
{
//     var pv = castIntPtr(PropagatedValue(i32), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateUint32(IntPtr64 pvPtr, uint value, bool localChange, double valueTime) @export("PV_updateUint32")
{
//     var pv = castIntPtr(PropagatedValue(u32), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateInt16(IntPtr64 pvPtr, short value, bool localChange, double valueTime) @export("PV_updateInt16")
{
//     var pv = castIntPtr(PropagatedValue(i16), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateUint16(IntPtr64 pvPtr, ushort value, bool localChange, double valueTime) @export("PV_updateUint16")
{
//     var pv = castIntPtr(PropagatedValue(u16), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateInt64(IntPtr64 pvPtr, long value, bool localChange, double valueTime) @export("PV_updateInt64")
{
//     var pv = castIntPtr(PropagatedValue(i64), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateUint64(IntPtr64 pvPtr, ulong value, bool localChange, double valueTime) @export("PV_updateUint64")
{
//     var pv = castIntPtr(PropagatedValue(u64), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateInt8(IntPtr64 pvPtr, ichar value, bool localChange, double valueTime) @export("PV_updateInt8")
{
//     var pv = castIntPtr(PropagatedValue(i8), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateUint8(IntPtr64 pvPtr, char value, bool localChange, double valueTime) @export("PV_updateUint8")
{
//     var pv = castIntPtr(PropagatedValue(u8), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateBool(IntPtr64 pvPtr, bool value, bool localChange, double valueTime) @export("PV_updateBool")
{
//     var pv = castIntPtr(PropagatedValue(bool), pvPtr);
//     pv._setPropagated(value, localChange, valueTime);
}

fn void pV_updateVec2(IntPtr64 pvPtr, InteropVec2* value, bool localChange, double valueTime) @export("PV_updateVec2")
{
//     const v = basis.math.Vec2.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec2), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

//fn void pV_updateVec2_WASM(IntPtr64 pvPtr, float x, float y, bool localChange, double valueTime) @export("PV_updateVec2_WASM")
//{
//     const v = basis.math.Vec2.init(x, y);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec2), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
//}

fn void pV_updateVec3(IntPtr64 pvPtr, InteropVec3 value, bool localChange, double valueTime) @export("PV_updateVec3")
{
//     const v = basis.math.Vec3.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec3), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

//fn void pV_updateVec3_WASM(IntPtr64 pvPtr, float x, float y, float z, bool localChange, double valueTime) @export("PV_updateVec3_WASM")
//{
//     const v = basis.math.Vec3.init(x, y, z);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec3), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
//}

fn void pV_updateVec4(IntPtr64 pvPtr, InteropVec4* value, bool localChange, double valueTime) @export("PV_updateVec4")
{
//     const v = basis.math.Vec4.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec4), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
}

//fn void pV_updateVec4_WASM(IntPtr64 pvPtr, float x, float y, float z, float w, bool localChange, double valueTime) @export("PV_updateVec4_WASM")
//{
//     const v = basis.math.Vec4.init(x, y, z, w);
//     var pv = castIntPtr(PropagatedValue(basis.math.Vec4), pvPtr);
//     pv._setPropagated(v, localChange, valueTime);
//}

fn void pV_updateQuaternion(IntPtr64 pvPtr, InteropQuaternion* value, bool localChange, double valueTime) @export("PV_updateQuaternion")
{
//     const q = basis.math.Quaternion.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Quaternion), pvPtr);
//     pv._setPropagated(q, localChange, valueTime);
}

//fn void pV_updateQuaternion_WASM(IntPtr64 pvPtr, float w, float x, float y, float z, bool localChange, double valueTime) @export("PV_updateQuaternion_WASM")
//{
//     const q = basis.math.Quaternion.init(w, x, y, z);
//     var pv = castIntPtr(PropagatedValue(basis.math.Quaternion), pvPtr);
//     pv._setPropagated(q, localChange, valueTime);
//}

fn void pV_updateMat43(IntPtr64 pvPtr, InteropMat43 value, bool localChange, double valueTime) @export("PV_updateMat43")
{
//     const m = basis.math.Mat43.fromInterop(value.*);
//     var pv = castIntPtr(PropagatedValue(basis.math.Mat43), pvPtr);
//     pv._setPropagated(m, localChange, valueTime);
}

fn void pA_fire(IntPtr64 paPtr, bool localChange, double valueTime) @export("PA_fire")
{
//     var pa = castIntPtr(PropagatedAction, paPtr);
//     pa._firePropagated(localChange, valueTime);
}

// // Resource mananger:

fn void resourceManager_resourceWasReloaded(CppPtr resourceCppPtr, uint callbackID) @export("ResourceManager_resourceWasReloaded")
{
//     basis.resources.resource_manager._resourceWasReloaded(resourceCppPtr, callbackID);
}

// // Flow state:

fn void flowState_deinit(IntPtr64 flowStateInterfaceIntPtr) @export("FlowState_deinit")
{
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.deinit();
}

fn void flowState_onEnter(IntPtr64 flowStateInterfaceIntPtr) @export("FlowState_onEnter")
{
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.onEnter();
}

fn void flowState_onExit(IntPtr64 flowStateInterfaceIntPtr) @export("FlowState_onExit")
{
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.onExit();
}

fn void flowState_update(IntPtr64 flowStateInterfaceIntPtr, float deltaTime) @export("FlowState_update")
{
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     flowStateInterfacePtr.update(deltaTime);
}

fn int flowState_isLoadingComplete(IntPtr64 flowStateInterfaceIntPtr) @export("FlowState_isLoadingComplete")
{
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     return if (flowStateInterfacePtr.isLoadingComplete()) 1 else 0;
	return 0;
}

fn void flowState_onMessageReceived(IntPtr64 flowStateInterfaceIntPtr, int message, uint senderNameHash, CppPtr parametersIntPtr) @export("FlowState_onMessageReceived")
{
//     var flowStateInterfacePtr = castIntPtr(FlowStateInterface, flowStateInterfaceIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     flowStateInterfacePtr.onMessageReceived(message, senderNameHash, parameters);
}

// // Debug overlay:

fn void debugOverlay_runImGuiMenuBarCallbacks() @export("DebugOverlay_runImGuiMenuBarCallbacks")
{
//     basis.debug_overlay._runImGuiMenuBarCallbacks();
}

fn void debugOverlay_runImGuiCallbacks() @export("DebugOverlay_runImGuiCallbacks")
{
//     basis.debug_overlay._runImGuiCallbacks();
}

// // Message node:

fn void messageNode_onMessageReceived(IntPtr64 nodeIntPtr, int message, uint senderNameHash, CppPtr parametersIntPtr) @export("MessageNode_onMessageReceived")
{
//     const node = castIntPtr(MessageNode, nodeIntPtr);
//     const parameters = basis.messaging.MessageParametersPtr.init(parametersIntPtr);
//     if (node.onMessageReceived) |delegate| {
//         delegate.call(message, senderNameHash, parameters);
//     }
}

// // Physics:

fn void physics_onTriggerEnterEvent(CppPtr triggerActorIntPtr, CppPtr otherActorIntPtr, uint otherActorType) @export("Physics_onTriggerEnterEvent")
{
//     basis.physics.physics_trigger._onTriggerEnterEvent(triggerActorIntPtr, otherActorIntPtr, otherActorType);
}

fn void physics_onTriggerExitEvent(CppPtr triggerActorIntPtr, CppPtr otherActorIntPtr, uint otherActorType, bool otherActorRemoved) @export("Physics_onTriggerExitEvent")
{
//     basis.physics.physics_trigger._onTriggerExitEvent(triggerActorIntPtr, otherActorIntPtr, otherActorType, otherActorRemoved);
}

fn void physics_onCollisionCallback(CppPtr sceneIntPtr, InteropCollisionData* interopCollisionData) @export("Physics_onCollisionCallback")
{
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
