#include "register_types.h"
#include "gdexample.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

// Esta función registra tu clase GDExample
void initialize_example(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) return;
    ClassDB::register_class<GDExample>();
}

// Esta es la función que Godot busca al cargar la librería
extern "C" void initialize_example_module(GDExtensionInterfaceGetProcAddress get_proc_address,
                                          GDExtensionClassLibraryPtr library,
                                          GDExtensionInitialization* initialization) {
    static GDExtensionBinding::InitObject init_obj(get_proc_address, library, initialization);
    init_obj.register_initializer(initialize_example);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);
    init_obj.init();
}
