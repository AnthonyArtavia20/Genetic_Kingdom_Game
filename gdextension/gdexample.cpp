#include "gdexample.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

GDExample::GDExample() {
    // Constructor
}

GDExample::~GDExample() {
    // Destructor
}

void GDExample::_process(double delta) {
    time_passed += delta;
}

void GDExample::_bind_methods() {
    // Aquí puedes exponer variables o métodos
}
