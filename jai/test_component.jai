#import "Math";

TestComponent :: struct {
    // TODO: Wrap this in a nicer type?
    cppContextPtr: basis.InteropTypedPtr;

	someField: s32;

    lastPos: basis.InteropVec3;
    positions: [..]basis.InteropVec3;

    //------------------------------------------------

    register :: (callback: basis.ComponentRegCallback) {
        basis.initComponentType(
            TestComponent,
            "jai.TestComponent",
            "GameObjectComponent",
            basis.COMPONENT_DEFAULT_UPDATE_ORDER,
            callback,

            CreateFn = create,
            DestroyFn = destroy,
            UpdateFn = update,
            TickFn = tick,
        );
    }

    //------------------------------------------------

    create :: (self: *TestComponent) {
        self.someField = 343;
        basis.print("TestComponent.create() called\n");
    }

    destroy :: (self: *TestComponent) {
        basis.print("TestComponent.destroy() called\n");

        free(self.positions.data);
    }

    update :: (self: *TestComponent, deltaTime: float32) {
        if self.positions.count > 1 {
            for 1..self.positions.count-1 {
                p0 := self.positions.data[it-1];
                p1 := self.positions.data[it];
                color := basis.InteropColor.{255, 255, 0, 255};
                basis._DebugDraw_drawLine3D(*p0, *p1, *color, *color);
            }
        }
    }

    tick :: (self: *TestComponent, tickDeltaTime: float32) {
        THRESHOLD :: 0.5;
        pos: basis.InteropVec3;
        basis._ComponentContext_getPosition(self.cppContextPtr, *pos);

        v := basis.InteropVec3.{self.lastPos.x - pos.x, self.lastPos.y - pos.y, self.lastPos.z - pos.z};
        l := squaredLength(v);

        if (l > THRESHOLD * THRESHOLD)
        {
            array_add(*self.positions, pos);
            self.lastPos = pos;
        } 
    }

    squaredLength :: (v: basis.InteropVec3) -> float32 {
        return v.x * v.x + v.y * v.y + v.z * v.z;
    }
}
