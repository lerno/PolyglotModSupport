package odinmod

import "core:fmt"
import "core:mem"
import "base:runtime"

import basis "../basis"

basisAPIVersionNumber :: 2
meanslibAPIVersionNumber :: 1

@export
getVersionNumber :: proc "c" (versionNumberType: u32) -> u32 {
	return basisAPIVersionNumber if versionNumberType == 0 else meanslibAPIVersionNumber
}

@export
initLibrary :: proc "c" (callback: basis.ComponentRegCallback)
{
	context = basis.getContext()

	TestComponent_register(callback)
	// Register more components here...
}

@export
deinitLibrary :: proc "c" ()
{
	context = basis.getContext()

	basis.deinitComponentTypes()
}
