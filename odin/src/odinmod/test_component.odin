package odinmod

import basis "../basis"

TestComponent :: struct {
    // TODO: Wrap this in a nicer type?
    cppContextPtr: basis.InteropTypedPtr,

	someField: i32
}

TestComponent_register :: proc (callback: basis.ComponentRegCallback) {
    fnList := basis.ComponentFnList(TestComponent){}
    fnList.create = TestComponent_create
    fnList.destroy = TestComponent_destroy
    fnList.onObjectCreated = TestComponent_onObjectCreated
    fnList.update = TestComponent_update
    fnList.preTick = TestComponent_preTick
    fnList.tick = TestComponent_tick

    basis.initComponentType(
        TestComponent,
        "odin.TestComponent",
        "GameObjectComponent",
        fnList,
        basis.COMPONENT_DEFAULT_UPDATE_ORDER,
        callback,
    )
}

TestComponent_create :: proc(self: ^TestComponent) {
    basis.printf("TestComponent_create()\n")
    self.someField = 123;
}

TestComponent_destroy :: proc(self: ^TestComponent) {
    basis.printf("TestComponent_destroy()\n")
    // msg := basis.toInteropString("Hello, fancy assert failure you got there...")
    // cap := basis.toInteropString("Something something assert failed")

    // ret := basis._Core_showAssertDialog(msg, cap)
}

TestComponent_onObjectCreated :: proc(self: ^TestComponent) {
    basis.printf("TestComponent_onObjectCreated() - someField: %d\n", self.someField)
}

TestComponent_update :: proc(self: ^TestComponent, deltaTime: f32) {
    //basis.printf("TestComponent_update(%.2f)\n", deltaTime)
}

TestComponent_preTick :: proc(self: ^TestComponent, tickDeltaTime: f32) {
    //basis.printf("TestComponent_preTick(%.2f) - %d\n", tickDeltaTime, self.someField)
}

TestComponent_tick :: proc(self: ^TestComponent, tickDeltaTime: f32) {
    //basis.printf("TestComponent_tick(%.2f) - %d\n", tickDeltaTime, self.someField)
}