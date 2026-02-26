#import "Basic";
#import "Compiler";
#import "String";

// Run something like "jai .\build.jai" to build the project.

#run {
    set_build_options_dc(.{do_output=false});  // No executable for this workspace.

    // Build the DLL:
    {
        w := compiler_create_workspace();
        options := get_build_options(w);
        copy_commonly_propagated_fields(get_build_options(), *options);
        options.output_executable_name = "jaimod";
        options.output_path = "bin";
        options.output_type = .DYNAMIC_LIBRARY;
        set_optimization(*options, .DEBUG);
        
        //modules_path := join(#filepath, "basis");
        modules_path := #filepath;
        modules_paths: [..] string;
        array_add(*modules_paths, modules_path);
        array_add(*modules_paths, ..options.import_path);
        options.import_path = modules_paths;
        
        set_build_options(options, w);

        add_build_file("main.jai", w);
    }
}
