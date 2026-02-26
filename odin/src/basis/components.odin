package basis

// Note! Keep this in sync with the C++ side (called ZigComponentFlags there)
ComponentFlags :: enum u32 {
    None = 0,
    HasUpdate = (1 << 0),
    HasPreTick = (1 << 1),
    HasTick = (1 << 2),
    HasExposedProperties = (1 << 3),
    HasBlueprintProperties = (1 << 4),
    NeedsExport = (1 << 5),
    IsTransformComponent = (1 << 6),
    IsScripted = (1 << 7),
    HasDrawEditor = (1 << 8),
    HasEditorState = (1 << 9),
}

COMPONENT_DEFAULT_UPDATE_ORDER :: 50

//----------------------------------------------------

ComponentFnList :: struct ($T: typeid) {
    create: proc(self: ^T),
    destroy: proc(self: ^T),
    onObjectCreated: proc(self: ^T),
    drawEditor: proc(self: ^T, selected: bool, hoveredOver: bool),

    update: proc(self: ^T, deltaTime: f32),
    preTick: proc(self: ^T, tickDeltaTime: f32),
    tick: proc(self: ^T, tickDeltaTime: f32),

    //More here: onMessageReceived etc...

    // TODO: Add AvatarTrackingComponent-specific functions, onBecameClientLocalAvatar etc.
}

//----------------------------------------------------

// Nil_create :: proc (self: ^$T) {}
// Nil_destroy :: proc (self: ^$T) {}
// Nil_onObjectCreated :: proc (self: ^$T) {}
// Nil_drawEditor :: proc (self: ^$T, selected: bool, hoveredOver: bool) {}
// Nil_update :: proc (self: ^$T, deltaTime: f32) {}
// Nil_preTick :: proc (self: ^$T, tickDeltaTime: f32) {}
// Nil_tick :: proc (self: ^$T, tickDeltaTime: f32) {}

initComponentType :: proc(
    $T: typeid,
    componentTypeName: string,
    componentContextTypeName: string,
    fnList: ComponentFnList(T),
    updateSortingKey: u32,
    callback: ComponentRegCallback,

    // $CreateProc: proc (self: ^T),
    // $DestroyProc: proc (self: ^T),
    // $OnObjectCreatedProc: proc (self: ^T),
    // $DrawEditorProc: proc (self: ^T, selected: bool, hoveredOver: bool),
    // $UpdateProc: proc (self: ^T, deltaTime: f32),
    // $PreTickProc: proc (self: ^T, tickDeltaTime: f32),
    // $TickProc: proc (self: ^T, tickDeltaTime: f32),
    ) {

    factory: ^ComponentFactory(T) = new(ComponentFactory(T))
	factory^ = {
        fnList = fnList,
		iface = makeComponentFactoryInterface(T, factory),
	}

    componentFlags: u32 = 0

    //------------------------------------------------

    if fnList.update != nil {
        componentFlags |= cast(u32)ComponentFlags.HasUpdate
    }

    if fnList.preTick != nil {
        componentFlags |= cast(u32)ComponentFlags.HasPreTick
    }

    if fnList.tick != nil {
        componentFlags |= cast(u32)ComponentFlags.HasTick
    }

    if fnList.drawEditor != nil {
        componentFlags |= cast(u32)ComponentFlags.HasDrawEditor
    }

    //------------------------------------------------

    factoryIntPtr: IntPtr64 = IntPtr64(uintptr(factory))

    gCFPointers[gCFPointerCount] = CFPointerStorage {
        ifacePtr = &factory.iface,
        factoryIntPtr = factoryIntPtr,
    }
    gCFPointerCount += 1

    libCppPtr := getLibCppPtr()

    typeName := toInteropString(componentTypeName)
    typeNameHash := makeStringHash(componentTypeName)
    contextTypeName := toInteropString(componentContextTypeName)

    callback(
        libCppPtr,
        typeName,
        typeNameHash,
        contextTypeName,
        updateSortingKey,
        IntPtr64(factoryIntPtr),
        componentFlags)
}

deinitComponentTypes :: proc() {
    for i in 0..<gCFPointerCount {
        gCFPointers[i].ifacePtr.deinit(gCFPointers[i].ifacePtr)
    }
}

//----------------------------------------------------

// Keep a list of all factory pointers here. We currently support
// up to 200 factories on the c++ side, so let's do the same here.
@(private="file")
CFPointerStorage :: struct {
    ifacePtr: ^ComponentFactoryInterface,
    factoryIntPtr: IntPtr64,
}

@(private="file")
gCFPointers: [200]CFPointerStorage

@(private="file")
gCFPointerCount: int = 0

