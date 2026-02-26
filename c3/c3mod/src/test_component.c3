module c3mod;
import basis;

fn void registerTestComponent(basis::ComponentRegCallback callback)
{
	basis::initComponentType{TestComponent}(
		"c3.TestComponent",
		"GameObjectComponent",
		50,
		callback);
}

struct TestComponent
{
	InteropTypedPtr cppContextPtr;

	uptr physicsActor;

	float time;
	bool upwards;
}

fn void TestComponent.init(&self, InteropTypedPtr cppContextPtr, bool onClient)
{
	self.cppContextPtr = cppContextPtr;
	self.time = 0.0;
	self.upwards = false;
}

fn void TestComponent.create(&self)
{
}

fn void TestComponent.onObjectCreated(&self)
{
	//String name = self.context.getName(); // <-- We want this API

	// InteropString is;
	// basis::funcPtr_ComponentContext_getName(self.cppContextPtr, &is);
	// String name = basis::fromInteropString(&is);
	// basis::printf("--TestComponent onObjectCreated, name: \"%s\"--\n", name);

	uint physicsActorType;
	basis::funcPtr_ComponentContext_getPhysicsActor(self.cppContextPtr, &self.physicsActor, &physicsActorType);
}

fn void TestComponent.destroy(&self)
{
	//basis::printf("--TestComponent destroy --\n");
}

fn void TestComponent.preTick(&self, float tickDeltaTime)
{
	self.time += tickDeltaTime;

	float timeout = self.upwards ? 10.0f : 2.0f;

	if (self.time > timeout)
	{
		self.time = 0.0f;
		self.upwards = !self.upwards;
	}

	basis::InteropVec3 force = {0.0f, self.upwards ? 500.0f : -500.0f, 0.0f};
	basis::InteropVec3 pos = {0.0f, 0.0f, 0.0f};

	basis::funcPtr_ComponentContext_getPosition(self.cppContextPtr, &pos);

	basis::funcPtr_PhysicsActor_addForce(self.physicsActor, &force, &pos, 1);
}
