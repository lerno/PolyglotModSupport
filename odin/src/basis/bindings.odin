package basis
//----------------------------------------------------

// Common function pointers:
FP_void :: #type proc "c" () // =  *const fn () callconv(.c) void;
FP_void_i32 :: #type proc "c" (i32) // = *const fn (i32) callconv(.c) void;
FP_void_bool:: #type proc "c" (bool) // = *const fn (bool) callconv(.c) void;
FP_void_f32 :: #type proc "c" (f32) // = *const fn (f32) callconv(.c) void;
FP_void_IntPtr64_i32 :: #type proc "c" (IntPtr64, i32) //= *const fn (basis.IntPtr64, i32) callconv(.c) void;
FP_i32 :: #type proc "c" () -> i32 // = *const fn () callconv(.c) i32;
FP_bool :: #type proc "c" () -> bool // = *const fn () callconv(.c) bool;
FP_f32 :: #type proc "c" () -> f32 //= *const fn () callconv(.c) f32;
FP_i32_IntPtr_IntPtr_u32 :: #type proc "c" (IntPtr, IntPtr, u32) -> i32 //= *const fn (basis.IntPtr, basis.IntPtr, u32) callconv(.c) i32;
FP_i32_IntPtr_IntPtr_u32_Vec3_Vec3 :: #type proc "c" (IntPtr, IntPtr, u32, #by_ptr InteropVec3, #by_ptr InteropVec3) -> i32 // = *const fn (basis.IntPtr, basis.IntPtr, u32, *const InteropVec3, *const InteropVec3) callconv(.c) i32;
FP_i32_IntPtr_IntPtr64_u32 :: #type proc "c" (IntPtr, IntPtr, u32) -> i32 // = *const fn (basis.IntPtr, basis.IntPtr64, u32) callconv(.c) i32;
FP_i32_IntPtr_IntPtr64_u32_Vec3_Vec3 :: #type proc "c" (IntPtr, IntPtr, u32, #by_ptr InteropVec3, #by_ptr InteropVec3) -> i32 // = *const fn (basis.IntPtr, basis.IntPtr64, u32, *const InteropVec3, *const InteropVec3) callconv(.c) i32;
// Add more here...

ComponentRegCallback :: #type proc "c" (
    zigLibCppPtr: InteropTypedPtr,
    #by_ptr typeName: InteropString,
    typeNameHash: u32,
    #by_ptr contextTypeName: InteropString,
    updateSortingKey: u32,
    factoryInterfacePtr: IntPtr64,
    flags: u32,
)

//----------------------------------------------------

CppZigPointerPair :: struct {
    cpp: uintptr,
    zig: uintptr,
}

InteropVec2 :: struct {
    x: f32,
    y: f32,
}

InteropVec3 :: struct {
    x: f32,
    y: f32,
    z: f32,
}

InteropVec4 :: struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
}

InteropQuaternion :: struct {
    w: f32,
    x: f32,
    y: f32,
    z: f32,
}

InteropMat43 :: struct {
    _11: f32,
    _12: f32,
    _13: f32,
    _21: f32,
    _22: f32,
    _23: f32,
    _31: f32,
    _32: f32,
    _33: f32,
    _41: f32,
    _42: f32,
    _43: f32,
}

InteropMat4 :: struct {
    _11: f32,
    _12: f32,
    _13: f32,
    _14: f32,
    _21: f32,
    _22: f32,
    _23: f32,
    _24: f32,
    _31: f32,
    _32: f32,
    _33: f32,
    _34: f32,
    _41: f32,
    _42: f32,
    _43: f32,
    _44: f32,
}

InteropColor :: struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
}

InteropTypedPtr :: struct {
    ptr: IntPtr64,
    type: u32,
}

InteropClientProxy :: struct {
    hostID: i32,
}

PhysicsInteropRayCastResult :: struct {
    hitPoint: InteropVec3,
    hitPointNormal: InteropVec3,
    distance: f32,
    hitGameObjectCppPtr: uintptr,
    hitPhysicsActorCppPtr: uintptr,
    hitPhysicsActorType: u32,
}

RendererInteropRayCastResult :: struct {
    hitPoint: InteropVec3,
    hitPointNormal: InteropVec3,
    hitObject: uintptr,
}

InteropString :: struct {
    ptr: [^]u8,
    len: u32,
}

InteropBuffer :: struct {
    ptr: [^]u8,
    capacity: u32,
    len: u32,
}

InteropLooseFileMapping :: struct {
    sourceFilePath: InteropString,
    resourcePath: InteropString,
    resourceType: i32,
};

InteropExposedPropertyMeta :: struct {
    exposedPropertyType: i32,
    typeID: i32,
    versionAdded: i32,
    defaultValueBufferOffset: i32,

    // Since interop types cannot contain pointers to be usable with WASM
    // we don't store InteropStrings here, but instead offsets + lengths into
    // a separate string buffer.

    //name: InteropString,
    nameStartOffset: u32,
    nameLength: u32,

    //options: InteropString,
    optionsStartOffset: u32,
    optionsLength: u32,
};

InteropNavMeshQueryFilter :: struct {
    areaCost: [64]f32,
    includeFlags: u16,
    excludeFlags: u16,
};

// Physics interop types:

InteropWheelDesc :: struct {
    radius: f32,
    mass: f32,
    width: f32,
    maxSteerAngle: f32,
    maxBrakeTorque: f32,
    maxHandbrakeTorque: f32,
    maxSuspensionCompression: f32,
    maxSuspensionDroop: f32,
    springStrength: f32,
    springDamperRate: f32,
    camberAngleAtRest: f32,
    camberAngleAtMaxCompression: f32,
    camberAngleAtMaxDroop: f32,
    offset: InteropVec3,
    driven: bool,
    innerWheelMultiplier: f32,
};

// TODO: move elsewhere...
MaxWheelCount :: 8
MaxGearCount :: 12
SteerVsForwardSpeedTableSize :: 16
MaxCollisionPointCount :: 8

InteropVehCtrlDesc :: struct {
    chassisRigidBodyIntPtr: CppPtr,
    chassisMass: f32,
    chassisCenterOfMass: InteropVec3,
    wheels: [MaxWheelCount]InteropWheelDesc,
    wheelCount: u32,
    engineMaxRotationSpeed: f32,
    engineMaxTorque: f32,
    differentialType: i32,
    torqueVectoringEnabled: bool,
    torquePerWheelInAir: f32,
    wheelsOnGroundThreshold: u32,
    gearRatios: [MaxGearCount]f32,
    gearCount: u32,
    gearSwitchTime: f32,
    autoGearBox: bool,
    steerRiseRate: f32,
    steerFallRate: f32,
    steerVsForwardSpeed: [SteerVsForwardSpeedTableSize]f32,
    steerVsForwardSpeedCount: u32,
    usesSweptWheels: bool,

    // //----------------------------------------------------

    // pub fn initFromDesc(desc: VehicleControllerDescription) basis.bindings.InteropVehCtrlDesc {
    //     var interopDesc = basis.bindings.InteropVehCtrlDesc{};

    //     if (desc.chassisRigidBody) |rb| {
    //         interopDesc.chassisRigidBodyIntPtr = rb.cppPtr;
    //     } else {
    //         interopDesc.chassisRigidBodyIntPtr;
    //     }

    //     interopDesc.chassisMass = desc.chassisMass;
    //     interopDesc.chassisCenterOfMass = desc.chassisCenterOfMass.toInterop();

    //     interopDesc.wheelCount = @as(u32, @intCast(desc.wheels.len));
    //     for (desc.wheels.slice(), 0..) |wheel, i| {
    //         interopDesc.wheels[i].radius = wheel.radius;
    //         interopDesc.wheels[i].mass = wheel.mass;
    //         interopDesc.wheels[i].width = wheel.width;
    //         interopDesc.wheels[i].maxSteerAngle = wheel.maxSteerAngle;
    //         interopDesc.wheels[i].maxBrakeTorque = wheel.maxBrakeTorque;
    //         interopDesc.wheels[i].maxHandbrakeTorque = wheel.maxHandbrakeTorque;
    //         interopDesc.wheels[i].maxSuspensionCompression = wheel.maxSuspensionCompression;
    //         interopDesc.wheels[i].maxSuspensionDroop = wheel.maxSuspensionDroop;
    //         interopDesc.wheels[i].springStrength = wheel.springStrength;
    //         interopDesc.wheels[i].springDamperRate = wheel.springDamperRate;
    //         interopDesc.wheels[i].camberAngleAtRest = wheel.camberAngleAtRest;
    //         interopDesc.wheels[i].camberAngleAtMaxCompression = wheel.camberAngleAtMaxCompression;
    //         interopDesc.wheels[i].camberAngleAtMaxDroop = wheel.camberAngleAtMaxDroop;
    //         interopDesc.wheels[i].offset = wheel.offset.toInterop();
    //         interopDesc.wheels[i].driven = wheel.driven;
    //         interopDesc.wheels[i].innerWheelMultiplier = wheel.innerWheelMultiplier;
    //     }

    //     interopDesc.engineMaxRotationSpeed = desc.engineMaxRotationSpeed;
    //     interopDesc.engineMaxTorque = desc.engineMaxTorque;
    //     interopDesc.differentialType = @intFromEnum(desc.differentialType);
    //     interopDesc.torqueVectoringEnabled = desc.torqueVectoring.enabled;
    //     interopDesc.torquePerWheelInAir = desc.torqueVectoring.torquePerWheelInAir;
    //     interopDesc.wheelsOnGroundThreshold = desc.torqueVectoring.wheelsOnGroundThreshold;

    //     interopDesc.gearCount = @as(u32, @intCast(desc.gearRatios.len));
    //     for (desc.gearRatios.slice(), 0..) |gearRatio, i| {
    //         interopDesc.gearRatios[i] = gearRatio;
    //     }

    //     interopDesc.gearSwitchTime = desc.gearSwitchTime;
    //     interopDesc.autoGearBox = desc.autoGearBox;

    //     interopDesc.steerRiseRate = desc.steerRiseRate;
    //     interopDesc.steerFallRate = desc.steerFallRate;

    //     interopDesc.steerVsForwardSpeedCount = @as(u32, @intCast(desc.steerVsForwardSpeed.len));
    //     for (desc.steerVsForwardSpeed.slice(), 0..) |value, i| {
    //         interopDesc.steerVsForwardSpeed[i] = value;
    //     }

    //     interopDesc.usesSweptWheels = desc.usesSweptWheels;

    //     return interopDesc;
    // }
};

InteropVehInputData :: struct {
    acceleration: f32,
    brake: f32,
    steering: f32,
    handbrake: f32,
};

InteropVehStateInfo :: struct {
    engineRotationSpeed: f32,
    currentGear: i32,
    currentSpeedForward: f32,
    inAir: bool,
    hasStickyTires: bool,
};

InteropVehWheelStateInfo :: struct {
    localPos: InteropVec3,
    localOri: InteropQuaternion,
    contactPoint: InteropVec3,
    rotationSpeed: f32,
    rotationAngle: f32,
    steeringAngle: f32,
    inAir: bool,
    longitudinalSlip: f32,
    lateralSlip: f32,
    tireFriction: f32,
    suspensionJounce: f32,
    suspensionSpringForce: f32,
    surfaceMaterialCppPtr: CppPtr,
    stickyTire: bool,
};

InteropCollisionPoint :: struct {
    position: InteropVec3,
    normal: InteropVec3,
    impulse: InteropVec3,
    force: f32,
    material0: CppPtr,
    material1: CppPtr,
};

InteropCollisionData :: struct {
    shape0: CppPtr,
    shape1: CppPtr,
    collisionPoints: [MaxCollisionPointCount]InteropCollisionPoint,
    collisionPointCount: u32,
};
