module basis;

alias Callback = fn void(int value);

// Common function pointers:
alias FP_void = fn void();
alias FP_void_i32 = fn void(int);
alias FP_void_bool = fn void(bool);
alias FP_void_f32 = fn void(float);
alias FP_void_IntPtr64_i32 = fn void(IntPtr64, int);
alias FP_i32 = fn int();
alias FP_bool = fn bool();
alias FP_f32 = fn float();
alias FP_i32_IntPtr_IntPtr_u32 = fn int(IntPtr, IntPtr, uint);
alias FP_i32_IntPtr_IntPtr_u32_Vec3_Vec3 = fn int(IntPtr, IntPtr, uint, InteropVec3*, InteropVec3*);
alias FP_i32_IntPtr_IntPtr64_u32 = fn int(IntPtr, IntPtr, uint);
alias FP_i32_IntPtr_IntPtr64_u32_Vec3_Vec3 = fn int(IntPtr, IntPtr, uint, InteropVec3*, InteropVec3*);
// Add more here...

alias ComponentRegCallback = fn void(
	InteropTypedPtr zigLibCppPtr,
	InteropString* typeName,
	uint typeNameHash,
	InteropString* contextTypeName,
	uint updateSortingKey,
	IntPtr64 factoryInterfacePtr,
	uint flags);

//////////////////////////////////
// Interop types.
//////////////////////////////////

struct CppZigPointerPair
{
    uptr cpp;
    uptr zig;
}

alias InteropVec2 = float[<2>];
alias InteropVec3 = float[<3>];
alias InteropVec4 = float[<4>];

struct InteropQuaternion
{
    float w;
    float x;
    float y;
    float z;
}

struct InteropMat43
{
    float e11;
    float e12;
    float e13;
    float e21;
    float e22;
    float e23;
    float e31;
    float e32;
    float e33;
    float e41;
    float e42;
    float e43;
}

struct InteropMat4
{
    float e11;
    float e12;
    float e13;
    float e14;
    float e21;
    float e22;
    float e23;
    float e24;
    float e31;
    float e32;
    float e33;
    float e34;
    float e41;
    float e42;
    float e43;
    float e44;
}

alias InteropColor = char[<4>];

struct InteropTypedPtr
{
    IntPtr64 ptr;
    uint type;
}

struct InteropClientProxy
{
    int hostID;
}

struct PhysicsInteropRayCastResult
{
    InteropVec3 hitPoint;
    InteropVec3 hitPointNormal;
    float distance;
    uptr hitGameObjectCppPtr;
    uptr hitPhysicsActorCppPtr;
    uint hitPhysicsActorType;
}

struct RendererInteropRayCastResult
{
    InteropVec3 hitPoint;
    InteropVec3 hitPointNormal;
    uptr hitObject;
}

struct InteropString
{
    char* ptr;
    uint len;
}

struct InteropBuffer
{
    char* ptr;
    uint capacity;
    uint len;
}

struct InteropLooseFileMapping
{
    InteropString sourceFilePath;
    InteropString resourcePath;
    int resourceType;
}

struct InteropExposedPropertyMeta
{
    int exposedPropertyType;
    int typeID;
    int versionAdded;
    int defaultValueBufferOffset;

    // Since interop types cannot contain pointers to be usable with WASM
    // we don't store InteropStrings here, but instead offsets + lengths into
    // a separate string buffer.

    //name: InteropString,
    uint nameStartOffset;
    uint nameLength;

    //options: InteropString,
    uint optionsStartOffset;
    uint optionsLength;
}

struct InteropNavMeshQueryFilter
{
    float[64] areaCost;
    ushort includeFlags;
    ushort excludeFlags;
}

struct InteropWheelDesc
{
    float radius;
    float mass;
    float width;
    float maxSteerAngle;
    float maxBrakeTorque;
    float maxHandbrakeTorque;
    float maxSuspensionCompression;
    float maxSuspensionDroop;
    float springStrength;
    float springDamperRate;
    float camberAngleAtRest;
    float camberAngleAtMaxCompression;
    float camberAngleAtMaxDroop;
    InteropVec3 offset;
    bool driven;
    float innerWheelMultiplier;
}

// TODO: move elsewhere...
const uint MAX_WHEEL_COUNT = 8;
const uint MAX_GEAR_COUNT = 12;
const uint STEER_VS_FORWARD_SPEED_TABLE_SIZE = 16;
const uint MAX_COLLISION_POINT_COUNT = 8;

struct InteropVehCtrlDesc
{
    CppPtr chassisRigidBodyIntPtr;
    float chassisMass;
    InteropVec3 chassisCenterOfMass;
    InteropWheelDesc[MAX_WHEEL_COUNT] wheels;
    uint wheelCount;
    float engineMaxRotationSpeed;
    float engineMaxTorque;
    int differentialType;
    bool torqueVectoringEnabled;
    float torquePerWheelInAir;
    uint wheelsOnGroundThreshold;
    float[MAX_GEAR_COUNT] gearRatios;
    uint gearCount;
    float gearSwitchTime;
    bool autoGearBox;
    float steerRiseRate;
    float steerFallRate;
    float[STEER_VS_FORWARD_SPEED_TABLE_SIZE] steerVsForwardSpeed;
    uint steerVsForwardSpeedCount;
    bool usesSweptWheels;

    //----------------------------------------------------

    // pub fn initFromDesc(desc: VehicleControllerDescription) basis.bindings.InteropVehCtrlDesc {
    //     var interopDesc = basis.bindings.InteropVehCtrlDesc{};

    //     if (desc.chassisRigidBody) |rb| {
    //         interopDesc.chassisRigidBodyIntPtr = rb.cppPtr;
    //     } else {
    //         interopDesc.chassisRigidBodyIntPtr = 0;
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
}

struct InteropVehInputData
{
    float acceleration;
    float brake;
    float steering;
    float handbrake;
}

struct InteropVehStateInfo
{
    float engineRotationSpeed;
    int currentGear;
    float currentSpeedForward;
    bool inAir;
    bool hasStickyTires;
}

struct InteropVehWheelStateInfo
{
    InteropVec3 localPos;
    InteropQuaternion localOri;
    InteropVec3 contactPoint;
    float rotationSpeed;
    float rotationAngle;
    float steeringAngle;
    bool inAir;
    float longitudinalSlip;
    float lateralSlip;
    float tireFriction;
    float suspensionJounce;
    float suspensionSpringForce;
    CppPtr surfaceMaterialCppPtr;
    bool stickyTire;
}

struct InteropCollisionPoint
{
    InteropVec3 position;
    InteropVec3 normal;
    InteropVec3 impulse;
    float force;
    CppPtr material0;
    CppPtr material1;
}

struct InteropCollisionData
{
    CppPtr shape0;
    CppPtr shape1;
    InteropCollisionPoint[MAX_COLLISION_POINT_COUNT] collisionPoints;
    uint collisionPointCount;
}
