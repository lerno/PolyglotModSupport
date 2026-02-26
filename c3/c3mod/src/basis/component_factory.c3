module basis;

import std::collections::list;

interface IComponentFactory
{
    fn void deinit();
	fn IntPtr newComponent(InteropTypedPtr cppContextPtr, bool onClient);
    fn void deleteComponent(bool onClient, IntPtr64 componentIntPtr);
    fn void update(bool onClient, float deltaTime);
    fn void preTick(bool onClient, float tickDeltaTime);
    fn void tick(bool onClient, float tickDeltaTime);
    // TODO: More here...

    // Methods forwarded to individual components:
    fn void create(IntPtr64 componentIntPtr);
    fn void onObjectCreated(IntPtr64 componentIntPtr);
    fn void drawEditor(IntPtr64 componentIntPtr, bool selected, bool hoveredOver);
	// TODO: More here...
}

struct ComponentFactory (IComponentFactory) <ComponentType> 
{
	IComponentFactory iface;
	List{ ComponentType* } clientComponents;
	List{ ComponentType* } serverComponents;
}

fn void ComponentFactory.init(&self)
{
	// Initialize the factory interface with the pointer to the factory itself.
	self.iface = self;

	self.clientComponents.init(mem);
	self.serverComponents.init(mem);
}

fn void ComponentFactory.deinit(&self) @dynamic
{
	// if (hasBPProps) {
	// 	for (self.bpPropList.items) |bpProps| {
	// 		if (@hasDecl(BPPropType, "deinit")) {
	// 			bpProps.deinit();
	// 		}

	// 		self.allocator.destroy(bpProps);
	// 	}

	// 	self.bpPropList.deinit();
	// }

	self.clientComponents.free();
	self.serverComponents.free();

	// Release the memory for the factory itself.
	free(self);
}

fn IntPtr ComponentFactory.newComponent(&self, InteropTypedPtr cppContextPtr, bool onClient) @dynamic
{
	// Allocate the component on the heap.
	ComponentType* componentPtr = mem::new(ComponentType);

	componentPtr.init(cppContextPtr, onClient);

	if (onClient)
	{
		self.clientComponents.push(componentPtr);
	}
	else
	{
		self.serverComponents.push(componentPtr);
	}

	return (IntPtr)componentPtr;
}

fn void ComponentFactory.deleteComponent(&self, bool onClient, IntPtr64 componentIntPtr) @dynamic
{
	ComponentType* componentPtr = (ComponentType*)componentIntPtr;

	$if $defined(ComponentType.destroy):
		componentPtr.destroy();
	$endif

	// Remove the component ptr from the correct list.
	if (onClient)
	{
		foreach (i, compPtr : self.clientComponents)
		{
			if (compPtr == componentPtr)
			{
				self.clientComponents.remove_at(i);
				break;
			}
		}
	}
	else
	{
		foreach (i, compPtr : self.serverComponents)
		{
			if (compPtr == componentPtr)
			{
				self.serverComponents.remove_at(i);
				break;
			}
		}
	}

	free(componentPtr);
}

fn void ComponentFactory.update(&self, bool onClient, float deltaTime) @dynamic
{
	$if $defined(ComponentType.update):
		if (onClient)
		{
			foreach (comp : self.clientComponents)
			{
				comp.update(deltaTime);
			}
		}
		else
		{
			foreach (comp : self.serverComponents)
			{
				comp.update(deltaTime);
			}
		}
	$endif
}

fn void ComponentFactory.preTick(&self, bool onClient, float tickDeltaTime) @dynamic
{
	$if $defined(ComponentType.preTick):
		if (onClient)
		{
			foreach (comp : self.clientComponents)
			{
				comp.preTick(tickDeltaTime);
			}
		}
		else
		{
			foreach (comp : self.serverComponents)
			{
				comp.preTick(tickDeltaTime);
			}
		}
	$endif
}

fn void ComponentFactory.tick(&self, bool onClient, float tickDeltaTime) @dynamic
{
	$if $defined(ComponentType.tick):
		if (onClient)
		{
			foreach (comp : self.clientComponents)
			{
				comp.tick(tickDeltaTime);
			}
		}
		else
		{
			foreach (comp : self.serverComponents)
			{
				comp.tick(tickDeltaTime);
			}
		}
	$endif
}

fn void ComponentFactory.create(&self, IntPtr componentIntPtr) @dynamic
{
	$if $defined(ComponentType.create):
		ComponentType* comp = (ComponentType*)componentIntPtr;
		comp.create();
	$endif
}

fn void ComponentFactory.onObjectCreated(&self, IntPtr componentIntPtr) @dynamic
{
	$if $defined(ComponentType.onObjectCreated):
		ComponentType* comp = (ComponentType*)componentIntPtr;
		comp.onObjectCreated();
	$endif
}

fn void ComponentFactory.drawEditor(&self, IntPtr componentIntPtr, bool selected, bool hoveredOver) @dynamic
{
	$if $defined(ComponentType.drawEditor):
		ComponentType* comp = (ComponentType*)componentIntPtr;
		comp.drawEditor(selected, hovered);
	$endif
}
