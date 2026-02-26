// Common function pointers:
FP_void :: #type () #c_call;
FP_void_i32 :: #type (s32) #c_call;
FP_void_bool:: #type (bool) #c_call;
FP_void_f32 :: #type (float32) #c_call;
FP_void_IntPtr64_i32 :: #type (IntPtr64, s32) #c_call;
FP_i32 :: #type () -> s32 #c_call;
FP_bool :: #type () -> bool #c_call; 
FP_f32 :: #type () -> float32 #c_call;
FP_i32_IntPtr_IntPtr_u32 :: #type (IntPtr, IntPtr, u32) -> s32 #c_call;
FP_i32_IntPtr_IntPtr_u32_Vec3_Vec3 :: #type (IntPtr, IntPtr, u32, *InteropVec3, *InteropVec3) -> s32 #c_call;
FP_i32_IntPtr_IntPtr64_u32 :: #type (IntPtr, IntPtr, u32) -> s32 #c_call;
FP_i32_IntPtr_IntPtr64_u32_Vec3_Vec3 :: #type (IntPtr, IntPtr, u32, *InteropVec3, *InteropVec3) -> s32 #c_call;
// Add more here...

uintptr :: u64;

//----------------------------------------------------

ComponentRegCallback :: #type (
    zigLibCppPtr: InteropTypedPtr,
    typeName: *InteropString,
    typeNameHash: u32,
    contextTypeName: *InteropString,
    updateSortingKey: u32,
    factoryInterfacePtr: IntPtr64,
    flags: u32,
) #c_call;

//----------------------------------------------------

CppZigPointerPair :: struct {
    cpp: uintptr;
    zig: uintptr;
}

InteropVec2 :: struct {
    x: float32;
    y: float32;
}

InteropVec3 :: struct {
    x: float32;
    y: float32;
    z: float32;
}

InteropVec4 :: struct {
    x: float32;
    y: float32;
    z: float32;
    w: float32;
}

InteropQuaternion :: struct {
    w: float32;
    x: float32;
    y: float32;
    z: float32;
}

InteropMat43 :: struct {
    _11: float32;
    _12: float32;
    _13: float32;
    _21: float32;
    _22: float32;
    _23: float32;
    _31: float32;
    _32: float32;
    _33: float32;
    _41: float32;
    _42: float32;
    _43: float32;
}

InteropMat4 :: struct {
    _11: float32;
    _12: float32;
    _13: float32;
    _14: float32;
    _21: float32;
    _22: float32;
    _23: float32;
    _24: float32;
    _31: float32;
    _32: float32;
    _33: float32;
    _34: float32;
    _41: float32;
    _42: float32;
    _43: float32;
    _44: float32;
}

InteropColor :: struct {
    r: u8;
    g: u8;
    b: u8;
    a: u8;
}

InteropTypedPtr :: struct {
    ptr: IntPtr64;
    type: u32;
}

InteropClientProxy :: struct {
    hostID: s32;
}

PhysicsInteropRayCastResult :: struct {
    hitPoint: InteropVec3;
    hitPointNormal: InteropVec3;
    distance: float32;
    hitGameObjectCppPtr: uintptr;
    hitPhysicsActorCppPtr: uintptr;
    hitPhysicsActorType: u32;
}

RendererInteropRayCastResult :: struct {
    hitPoint: InteropVec3;
    hitPointNormal: InteropVec3;
    hitObject: uintptr;
}

InteropString :: struct {
    ptr: *u8;
    len: u32;
}

InteropBuffer :: struct {
    ptr: *u8;
    capacity: u32;
    len: u32;
}

InteropLooseFileMapping :: struct {
    sourceFilePath: InteropString;
    resourcePath: InteropString;
    resourceType: s32;
};

InteropExposedPropertyMeta :: struct {
    exposedPropertyType: s32;
    typeID: s32;
    versionAdded: s32;
    defaultValueBufferOffset: s32;

    // Since interop types cannot contain pointers to be usable with WASM
    // we don't store InteropStrings here, but instead offsets + lengths into
    // a separate string buffer.

    // name: InteropString,
    nameStartOffset: u32;
    nameLength: u32;

    // options: InteropString,
    optionsStartOffset: u32;
    optionsLength: u32;
};

InteropNavMeshQueryFilter :: struct {
    areaCost: [64]float32;
    includeFlags: u16;
    excludeFlags: u16;
};

// Physics interop types:

InteropWheelDesc :: struct {
    radius: float32;
    mass: float32;
    width: float32;
    maxSteerAngle: float32;
    maxBrakeTorque: float32;
    maxHandbrakeTorque: float32;
    maxSuspensionCompression: float32;
    maxSuspensionDroop: float32;
    springStrength: float32;
    springDamperRate: float32;
    camberAngleAtRest: float32;
    camberAngleAtMaxCompression: float32;
    camberAngleAtMaxDroop: float32;
    offset: InteropVec3;
    driven: bool;
    innerWheelMultiplier: float32;
};

// TODO: move elsewhere...
MaxWheelCount :: 8;
MaxGearCount :: 12;
SteerVsForwardSpeedTableSize :: 16;
MaxCollisionPointCount :: 8;

InteropVehCtrlDesc :: struct {
    chassisRigidBodyIntPtr: CppPtr;
    chassisMass: float32;
    chassisCenterOfMass: InteropVec3;
    wheels: [MaxWheelCount]InteropWheelDesc;
    wheelCount: u32;
    engineMaxRotationSpeed: float32;
    engineMaxTorque: float32;
    differentialType: s32;
    torqueVectoringEnabled: bool;
    torquePerWheelInAir: float32;
    wheelsOnGroundThreshold: u32;
    gearRatios: [MaxGearCount]float32;
    gearCount: u32;
    gearSwitchTime: float32;
    autoGearBox: bool;
    steerRiseRate: float32;
    steerFallRate: float32;
    steerVsForwardSpeed: [SteerVsForwardSpeedTableSize]float32;
    steerVsForwardSpeedCount: u32;
    usesSweptWheels: bool;

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
    acceleration: float32;
    brake: float32;
    steering: float32;
    handbrake: float32;
};

InteropVehStateInfo :: struct {
    engineRotationSpeed: float32;
    currentGear: s32;
    currentSpeedForward: float32;
    inAir: bool;
    hasStickyTires: bool;
};

InteropVehWheelStateInfo :: struct {
    localPos: InteropVec3;
    localOri: InteropQuaternion;
    contactPoint: InteropVec3;
    rotationSpeed: float32;
    rotationAngle: float32;
    steeringAngle: float32;
    inAir: bool;
    longitudinalSlip: float32;
    lateralSlip: float32;
    tireFriction: float32;
    suspensionJounce: float32;
    suspensionSpringForce: float32;
    surfaceMaterialCppPtr: CppPtr;
    stickyTire: bool;
};

InteropCollisionPoint :: struct {
    position: InteropVec3;
    normal: InteropVec3;
    impulse: InteropVec3;
    force: float32;
    material0: CppPtr;
    material1: CppPtr;
};

InteropCollisionData :: struct {
    shape0: CppPtr;
    shape1: CppPtr;
    collisionPoints: [MaxCollisionPointCount]InteropCollisionPoint;
    collisionPointCount: u32;
};
