// Note! Keep this in sync with the C++ side (called ZigComponentFlags there)
ComponentFlags :: enum_flags u32 {
    None :: 0;
    HasUpdate :: (1 << 0);
    HasPreTick :: (1 << 1);
    HasTick :: (1 << 2);
    HasExposedProperties :: (1 << 3);
    HasBlueprintProperties :: (1 << 4);
    NeedsExport :: (1 << 5);
    IsTransformComponent :: (1 << 6);
    IsScripted :: (1 << 7);
    HasDrawEditor :: (1 << 8);
    HasEditorState :: (1 << 9);
}

COMPONENT_DEFAULT_UPDATE_ORDER :: 50;

//----------------------------------------------------

initComponentType :: (
    $T: Type,
    componentTypeName: string,
    componentContextTypeName: string,
    updateSortingKey: u32,
    callback: ComponentRegCallback,

    $CreateFn: (self: *T) = nullCompCreate,
    $DestroyFn: (self: *T) = nullCompDestroy,
    $OnObjectCreatedFn: (self: *T) = nullCompOnObjectCreated,
    $DrawEditorFn: (self: *T, selected: bool, hoveredOver: bool) = nullCompDrawEditor,
    $UpdateFn: (self: *T, deltaTime: float32) = nullCompUpdate,
    $PreTickFn: (self: *T, tickDeltaTime: float32) = nullCompPreTick,
    $TickFn: (self: *T, tickDeltaTime: float32) = nullCompTick,
    ) {

    factory := New(ComponentFactory(T));
    factory.iface = makeComponentFactoryInterface(
        T,
        factory,
        CreateFn,
        DestroyFn,
        OnObjectCreatedFn,
        DrawEditorFn,
        UpdateFn,
        PreTickFn,
        TickFn,
    );

    componentFlags: ComponentFlags;

    //------------------------------------------------

    if UpdateFn != nullCompUpdate {
        componentFlags |= .HasUpdate;
    }

    if PreTickFn != nullCompPreTick {
        componentFlags |= .HasPreTick;
    }

    if TickFn != nullCompTick {
        componentFlags |= .HasTick;
    }

    if DrawEditorFn != nullCompDrawEditor {
        componentFlags |= .HasDrawEditor;
    }

    //------------------------------------------------

    factoryIntPtr := cast(IntPtr64)factory;

    _gCFPointers[_gCFPointerCount] = CFPointerStorage.{
        ifacePtr = *factory.iface,
        factoryIntPtr = factoryIntPtr,
    };
    _gCFPointerCount += 1;

    libCppPtr := getLibCppPtr();

    typeName := toInteropString(componentTypeName);
    typeNameHash := makeStringHash(componentTypeName);
    contextTypeName := toInteropString(componentContextTypeName);

    callback(
        libCppPtr,
        *typeName,
        typeNameHash,
        *contextTypeName,
        updateSortingKey,
        factoryIntPtr,
        cast(u32)componentFlags);
}

deinitComponentTypes :: () {
    for 0.._gCFPointerCount-1 {
        _gCFPointers[it].ifacePtr.deinit(_gCFPointers[it].ifacePtr);
    }
}

//------------------------------------------------

// Keep a list of all factory pointers here. We currently support
// up to 200 factories on the c++ side, so let's do the same here.
CFPointerStorage :: struct {
    ifacePtr: *ComponentFactoryInterface;
    factoryIntPtr: IntPtr64;
}

_gCFPointers: [200]CFPointerStorage;
_gCFPointerCount: int;

//------------------------------------------------

nullCompCreate :: (self: *$T) {
    //print("nullCompCreate() called\n");
}

nullCompDestroy :: (self: *$T) {
    //print("nullCompDestroy() called\n");
}

nullCompOnObjectCreated :: (self: *$T) {
    //print("nullCompOnObjectCreated() called\n");
}

nullCompDrawEditor :: (self: *$T, selected: bool, hoveredOver: bool) {
    //print("nullCompDrawEditor() called\n");
}

nullCompUpdate :: (self: *$T, deltaTime: float32) {
    //print("nullCompUpdate() called\n");
}

nullCompPreTick :: (self: *$T, tickDeltaTime: float32) {
    //print("nullCompPreTick() called\n");
}

nullCompTick :: (self: *$T, tickDeltaTime: float32) {
    //print("nullCompTick() called\n");
}
