#ifndef GDEXAMPLE_H
#define GDEXAMPLE_H

#include <godot_cpp/classes/node2d.hpp>

namespace godot {

class GDExample : public Node2D {
    GDCLASS(GDExample, Node2D)

private:
    float time_passed = 0.0;

public:
    GDExample();
    ~GDExample();

    void _process(double delta);
    static void _bind_methods();
};

} // namespace godot

#endif // GDEXAMPLE_H
