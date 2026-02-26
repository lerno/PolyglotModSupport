#import "Basic";
basis :: #import "basis";

#load "test_component.jai";

basisAPIVersionNumber :: 2;
meanslibAPIVersionNumber :: 1;

#program_export
getVersionNumber :: (versionNumberType: u32) -> u32 #c_call {
    if (versionNumberType == 0) {
        return basisAPIVersionNumber;
    } else {
        return meanslibAPIVersionNumber;
    }
}

#program_export
initLibrary :: (callback: basis.ComponentRegCallback) #c_call {
    push_context {
        TestComponent.register(callback);
    }
}

#program_export
deinitLibrary :: () #c_call {
    push_context {
	    basis.deinitComponentTypes();
    }
}
