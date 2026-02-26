module basis;

enum ComponentFlags : const uint
{
    NONE = 0,
    HAS_UPDATE = (1 << 0),
    HAS_PRETICK = (1 << 1),
    HAS_TICK = (1 << 2),
    HAS_EXPOSED_PROPERTIES = (1 << 3),
    HAS_BLUEPRINT_PROPERTIES = (1 << 4),
    NEEDS_EXPORT = (1 << 5),
    IS_TRANSFORM_COMPONENT = (1 << 6),
    IS_SCRIPTED = (1 << 7),
    HAS_DRAW_EDITOR = (1 << 8),
    HAS_EDITOR_STATE = (1 << 9),
}

// Keep a list of all factory interface pointers here. We currently support
// up to 200 factories on the c++ side, so let's do the same here.
IComponentFactory[200] gFactoryInterfacePointers;
uint gFactoryInterfaceCount = 0;

fn void initComponentType(
	String componentTypeName,
    String componentContextTypeName,
	uint updateSortingKey,
	basis::ComponentRegCallback callback) <ComponentType>
{
	ComponentFactory{ComponentType}* factory = mem::new(ComponentFactory{ComponentType});
	factory.init();

	InteropString typeName = basis::toInteropString(componentTypeName);
	StringHash typeNameHash = basis::makeStringHash(componentTypeName);
	InteropString contextTypeName = basis::toInteropString(componentContextTypeName);

	uint flags = 0;

	$if $defined(ComponentType.update):
		flags |= (uint)ComponentFlags.HAS_UPDATE;
	$endif

	$if $defined(ComponentType.preTick):
		flags |= (uint)ComponentFlags.HAS_PRETICK;
	$endif

	$if $defined(ComponentType.tick):
		flags |= (uint)ComponentFlags.HAS_TICK;
	$endif

    // if (Factory.hasExposedProperties) {
    //     flags |= ZigComponentFlags.HasExposedProperties.asInt();
    // }

    // if (Factory.hasBlueprintProperties) {
    //     flags |= ZigComponentFlags.HasBlueprintProperties.asInt();
    // }

    // if (Factory.needsExport) {
    //     flags |= ZigComponentFlags.NeedsExport.asInt();
    // }

    // // Not supported yet...
    // // if (Factory.isTransformComponent) {
    // //     flags |= ZigComponentFlags.IsTransformComponent.asInt();
    // // }

    // if (Factory.isScripted) {
    //     flags |= ZigComponentFlags.IsScripted.asInt();
    // }

	$if $defined(ComponentType.drawEditor):
		flags |= (uint)ComponentFlags.HAS_DRAW_EDITOR;
	$endif

    // if (Factory.hasEditorState) {
    //     flags |= ZigComponentFlags.HasEditorState.asInt();
    // }

    uptr factoryIfaceIntPtr = (uptr)&factory.iface;

    gFactoryInterfacePointers[gFactoryInterfaceCount] = factory.iface;
    gFactoryInterfaceCount += 1;

	InteropTypedPtr libCppPtr = getLibCppPtr();

	callback(
		libCppPtr,
		&typeName,
		typeNameHash,
		&contextTypeName,
		updateSortingKey,
		factoryIfaceIntPtr,
		flags,
	);
}

fn void deinitComponentTypes()
{
	for (uint i = 0; i < gFactoryInterfaceCount; ++i)
	{
		gFactoryInterfacePointers[i].deinit();
	}
}
