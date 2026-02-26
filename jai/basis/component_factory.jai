ComponentFactoryInterface :: struct {
    factoryPointer: IntPtr64;

    // Methods for the actual component factory:
    deinit: (self: *ComponentFactoryInterface);
    newComponent: (self: *ComponentFactoryInterface, cppContextPtr: InteropTypedPtr, onClient: bool) -> IntPtr64;
    deleteComponent: (self: *ComponentFactoryInterface, onClient: bool, componentIntPtr: IntPtr64);
    update: (self: *ComponentFactoryInterface, onClient: bool, deltaTime: float32);
    preTick: (self: *ComponentFactoryInterface, onClient: bool, tickDeltaTime: float32);
    tick: (self: *ComponentFactoryInterface, onClient: bool, tickDeltaTime: float32);
    // TODO: More here...

    // Methods forwarded to individual components:
    create: (self: *ComponentFactoryInterface, componentIntPtr: IntPtr64);
    onObjectCreated: (self: *ComponentFactoryInterface, componentIntPtr: IntPtr64);
    drawEditor: (self: *ComponentFactoryInterface, componentIntPtr: IntPtr64, selected: bool, hoveredOver: bool);
    // TODO: More here...
}

makeComponentFactoryInterface :: (
    $T: Type,
    factoryPointer: *ComponentFactory(T),

    $CreateFn: (self: *T),
    $DestroyFn: (self: *T),
    $OnObjectCreatedFn: (self: *T),
    $DrawEditorFn: (self: *T, selected: bool, hoveredOver: bool),
    $UpdateFn: (self: *T, deltaTime: float32),
    $PreTickFn: (self: *T, tickDeltaTime: float32),
    $TickFn: (self: *T, tickDeltaTime: float32),
) -> ComponentFactoryInterface {
    iface := ComponentFactoryInterface.{factoryPointer = cast(IntPtr64)factoryPointer};

    iface.deinit = (self: *ComponentFactoryInterface) {
        factoryPtr := cast(*ComponentFactory(T))self.factoryPointer;
        ComponentFactory_deinit(T, factoryPtr);
    }

    iface.newComponent = (self: *ComponentFactoryInterface, cppContextPtr: InteropTypedPtr, onClient: bool) -> IntPtr64 {
        factoryPtr := cast(*ComponentFactory(T))self.factoryPointer;
        return ComponentFactory_newComponent(T, factoryPtr, cppContextPtr, onClient);
    }

    iface.deleteComponent = (self: *ComponentFactoryInterface, onClient: bool, componentIntPtr: IntPtr64) {
        factoryPtr := cast(*ComponentFactory(T))self.factoryPointer;
        ComponentFactory_deleteComponent(T, DestroyFn, factoryPtr, onClient, componentIntPtr);
    }

    iface.update = (self: *ComponentFactoryInterface, onClient: bool, deltaTime: float32) {
        factoryPtr := cast(*ComponentFactory(T))self.factoryPointer;

        if onClient {
            for factoryPtr.clientComponents {
                UpdateFn(it, deltaTime);
            }
        } else {
            for factoryPtr.serverComponents {
                UpdateFn(it, deltaTime);
            }
        }
    }

    iface.preTick = (self: *ComponentFactoryInterface, onClient: bool, tickDeltaTime: float32) {
        factoryPtr := cast(*ComponentFactory(T))self.factoryPointer;

        if onClient {
            for factoryPtr.clientComponents {
                PreTickFn(it, tickDeltaTime);
            }
        } else {
            for factoryPtr.serverComponents {
                PreTickFn(it, tickDeltaTime);
            }
        }
    }

    iface.tick = (self: *ComponentFactoryInterface, onClient: bool, tickDeltaTime: float32) {
        factoryPtr := cast(*ComponentFactory(T))self.factoryPointer;

        if onClient {
            for factoryPtr.clientComponents {
                TickFn(it, tickDeltaTime);
            }
        } else {
            for factoryPtr.serverComponents {
                TickFn(it, tickDeltaTime);
            }
        }
    }

    iface.create = (self: *ComponentFactoryInterface, componentIntPtr: IntPtr64) {
        factoryPtr := cast(*ComponentFactory(T))self.factoryPointer;
        componentPtr := cast(*T)componentIntPtr;
        CreateFn(componentPtr);
    }   

    iface.onObjectCreated = (self: *ComponentFactoryInterface, componentIntPtr: IntPtr64) {
        factoryPtr := cast(*ComponentFactory(T))self.factoryPointer;
        componentPtr := cast(*T)componentIntPtr;
        OnObjectCreatedFn(componentPtr);
    }  

    iface.drawEditor = (self: *ComponentFactoryInterface, componentIntPtr: IntPtr64, selected: bool, hoveredOver: bool) {
        factoryPtr := cast(*ComponentFactory(T))self.factoryPointer;
        componentPtr := cast(*T)componentIntPtr;
        DrawEditorFn(componentPtr, selected, hoveredOver);
    }  

    return iface;
}

//----------------------------------------------------

ComponentFactory :: struct($T: Type) {
    iface: ComponentFactoryInterface;
    clientComponents: [..]*T;
    serverComponents: [..]*T;
}

ComponentFactory_deinit :: ($T: Type, factory: *ComponentFactory(T)) {
    // if (hasBPProps) {
    //     for (self.bpPropList.items) |bpProps| {
    //         if (@hasDecl(BPPropType, "deinit")) {
    //             bpProps.deinit();
    //         }

    //         self.allocator.destroy(bpProps);
    //     }    

    //     self.bpPropList.deinit();
    // }

    free(factory.clientComponents.data);
    free(factory.serverComponents.data);

    // Release the memory for the factory itself.
    free(factory);
}

ComponentFactory_newComponent :: ($T: Type, factory: *ComponentFactory(T), cppContextPtr: InteropTypedPtr, onClient: bool) -> IntPtr64 {
    componentPtr := New(T);
    componentPtr.* = T.{cppContextPtr = cppContextPtr}; // This probably breaks...

    if onClient {
        array_add(*factory.clientComponents, componentPtr);
    } else {
        array_add(*factory.serverComponents, componentPtr);
    }

    return cast(IntPtr64)componentPtr;
}

ComponentFactory_deleteComponent :: ($T: Type, $DestroyFn: (componentPtr: *T), factory: *ComponentFactory(T), onClient: bool, componentIntPtr: IntPtr64) {
    componentPtr := cast(*T)componentIntPtr;

    DestroyFn(componentPtr);

    if onClient {
        array_ordered_remove_by_value(*factory.clientComponents, componentPtr);
    } else {
        array_ordered_remove_by_value(*factory.serverComponents, componentPtr);
    }

    free(componentPtr);
}
