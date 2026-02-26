package basis

ComponentFactoryInterface :: struct {
    factoryPointer: IntPtr64,

    // Methods for the actual component factory:
    deinit: proc(self: ^ComponentFactoryInterface),
    newComponent: proc(self: ^ComponentFactoryInterface, cppContextPtr: InteropTypedPtr, onClient: bool) -> IntPtr64,
    deleteComponent: proc(self: ^ComponentFactoryInterface, onClient: bool, componentIntPtr: IntPtr64),
    update: proc(self: ^ComponentFactoryInterface, onClient: bool, deltaTime: f32),
    preTick: proc(self: ^ComponentFactoryInterface, onClient: bool, tickDeltaTime: f32),
    tick: proc(self: ^ComponentFactoryInterface, onClient: bool, tickDeltaTime: f32),
    // TODO: More here...

    // Methods forwarded to individual components:
    create: proc(self: ^ComponentFactoryInterface, componentIntPtr: IntPtr64),
    onObjectCreated: proc(self: ^ComponentFactoryInterface, componentIntPtr: IntPtr64),
    drawEditor: proc(self: ^ComponentFactoryInterface, componentIntPtr: IntPtr64, selected: bool, hoveredOver: bool),
    // TODO: More here...
}

makeComponentFactoryInterface :: proc($T: typeid, factoryPointer: ^ComponentFactory(T)) -> ComponentFactoryInterface {
    iface := ComponentFactoryInterface{factoryPointer = IntPtr64(uintptr(factoryPointer))}

    iface.deinit = proc(self: ^ComponentFactoryInterface) {
        factoryPtr := cast(^ComponentFactory(T))uintptr(self.factoryPointer)
        ComponentFactory_deinit(T, factoryPtr)
    }

    iface.newComponent = proc(self: ^ComponentFactoryInterface, cppContextPtr: InteropTypedPtr, onClient: bool) -> IntPtr64 {
        factoryPtr := cast(^ComponentFactory(T))uintptr(self.factoryPointer)
        return ComponentFactory_newComponent(T, factoryPtr, cppContextPtr, onClient)
    }

    iface.deleteComponent = proc(self: ^ComponentFactoryInterface, onClient: bool, componentIntPtr: IntPtr64) {
        factoryPtr := cast(^ComponentFactory(T))uintptr(self.factoryPointer)
        ComponentFactory_deleteComponent(T, factoryPtr, onClient, componentIntPtr)
    }

    iface.update = proc(self: ^ComponentFactoryInterface, onClient: bool, deltaTime: f32) {
        factoryPtr := cast(^ComponentFactory(T))uintptr(self.factoryPointer)

        if factoryPtr.fnList.update != nil {
            if onClient {
                for ptr in factoryPtr.clientComponents {
                    factoryPtr.fnList.update(ptr, deltaTime)
                }
            } else {
                for ptr in factoryPtr.serverComponents {
                    factoryPtr.fnList.update(ptr, deltaTime)
                }
            }
        }
    }

    iface.preTick = proc(self: ^ComponentFactoryInterface, onClient: bool, tickDeltaTime: f32) {
        factoryPtr := cast(^ComponentFactory(T))uintptr(self.factoryPointer)

        if factoryPtr.fnList.preTick != nil {
            if onClient {
                for ptr in factoryPtr.clientComponents {
                    factoryPtr.fnList.preTick(ptr, tickDeltaTime)
                }
            } else {
                for ptr in factoryPtr.serverComponents {
                    factoryPtr.fnList.preTick(ptr, tickDeltaTime)
                }
            }
        }
    }

    iface.tick = proc(self: ^ComponentFactoryInterface, onClient: bool, tickDeltaTime: f32) {
        factoryPtr := cast(^ComponentFactory(T))uintptr(self.factoryPointer)

        if factoryPtr.fnList.tick != nil {
            if onClient {
                for ptr in factoryPtr.clientComponents {
                    factoryPtr.fnList.tick(ptr, tickDeltaTime)
                }
            } else {
                for ptr in factoryPtr.serverComponents {
                    factoryPtr.fnList.tick(ptr, tickDeltaTime)
                }
            }
        }
    }

    iface.create = proc(self: ^ComponentFactoryInterface, componentIntPtr: IntPtr64) {
        factoryPtr := cast(^ComponentFactory(T))uintptr(self.factoryPointer)

        if factoryPtr.fnList.create != nil {
            componentPtr := cast(^T)uintptr(componentIntPtr)
            factoryPtr.fnList.create(componentPtr)
        }
    }

    iface.onObjectCreated = proc(self: ^ComponentFactoryInterface, componentIntPtr: IntPtr64) {
        factoryPtr := cast(^ComponentFactory(T))uintptr(self.factoryPointer)

        if factoryPtr.fnList.onObjectCreated != nil {
            componentPtr := cast(^T)uintptr(componentIntPtr)
            factoryPtr.fnList.onObjectCreated(componentPtr)
        }
    }

    iface.drawEditor = proc(self: ^ComponentFactoryInterface, componentIntPtr: IntPtr64, selected: bool, hoveredOver: bool) {
        factoryPtr := cast(^ComponentFactory(T))uintptr(self.factoryPointer)

        if factoryPtr.fnList.drawEditor != nil {
            componentPtr := cast(^T)uintptr(componentIntPtr)
            factoryPtr.fnList.drawEditor(componentPtr, selected, hoveredOver)
        }
    }

    return iface
}

//----------------------------------------------------

ComponentFactory :: struct($T: typeid) {
    iface: ComponentFactoryInterface,
    fnList: ComponentFnList(T),
    clientComponents: [dynamic]^T,
    serverComponents: [dynamic]^T,
}

ComponentFactory_deinit :: proc ($T: typeid, factory: ^ComponentFactory(T)) {
    // if (hasBPProps) {
    //     for (self.bpPropList.items) |bpProps| {
    //         if (@hasDecl(BPPropType, "deinit")) {
    //             bpProps.deinit();
    //         }

    //         self.allocator.destroy(bpProps);
    //     }    

    //     self.bpPropList.deinit();
    // }

    delete(factory.clientComponents)
    delete(factory.serverComponents)

    // Release the memory for the factory itself.
    free(factory)
}

ComponentFactory_newComponent :: proc ($T: typeid, factory: ^ComponentFactory(T), cppContextPtr: InteropTypedPtr, onClient: bool) -> IntPtr64 {
    componentPtr: ^T = new(T)
    componentPtr^ = {
        cppContextPtr = cppContextPtr,
    }

    if onClient {
        append(&factory.clientComponents, componentPtr)
    } else {
        append(&factory.serverComponents, componentPtr)
    }

    return IntPtr64(uintptr(componentPtr));
}

ComponentFactory_deleteComponent :: proc ($T: typeid, factory: ^ComponentFactory(T), onClient: bool, componentIntPtr: IntPtr64) {
    componentPtr := cast(^T)uintptr(componentIntPtr)

    if (factory.fnList.destroy != nil) {
        factory.fnList.destroy(componentPtr)
    }

    if onClient {
        for ptr, i in factory.clientComponents {
            if ptr == componentPtr {
                unordered_remove(&factory.clientComponents, i)
                break
            }
        }
    } else {
        for ptr, i in factory.serverComponents {
            if ptr == componentPtr {
                unordered_remove(&factory.serverComponents, i)
                break
            }
        }
    }

    free(componentPtr)
}
