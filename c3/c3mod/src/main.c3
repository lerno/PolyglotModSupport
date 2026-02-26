module c3mod;

import basis;
import std::io;

// TODO: Move these into their proper places.
const uint BASIS_API_VERSION_NUMBER = 2;
const uint MEANSLIB_API_VERSION_NUMBER = 1;

fn uint getVersionNumber(uint versionNumberType) @export("getVersionNumber")
{
	return (versionNumberType == 0) ? BASIS_API_VERSION_NUMBER : MEANSLIB_API_VERSION_NUMBER;
}

fn void initLibrary(ComponentRegCallback callback) @export("initLibrary")
{
    //means.app = basis.app.create(means.MeansApp, meansAllocator);

	registerTestComponent(callback);
	// More components go here...
}

fn void deinitLibrary() @export("deinitLibrary")
{
    // basis.app.destroy(means.app);
    basis::deinitComponentTypes();
}
