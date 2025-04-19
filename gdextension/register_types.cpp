#include "register_types.h"
#include "gdexample.h"
#include "pathfinder/pathfinder.h"

using namespace godot;

void initialize_types(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE)
        return;

    ClassDB::register_class<GDExample>();
    ClassDB::register_class<Pathfinder>();
}

void uninitialize_types(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE)
        return;
}

extern "C" {
GDExtensionBool GDE_EXPORT initialize_example_module(
    GDExtensionInterfaceGetProcAddress get_proc_address,
    GDExtensionClassLibraryPtr library,
    GDExtensionInitialization *r_initialization)
{
    GDExtensionBinding::InitObject init_obj(get_proc_address, library, r_initialization);
    init_obj.register_initializer(initialize_types);
    init_obj.register_terminator(uninitialize_types);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);
    return init_obj.init();
}
}
