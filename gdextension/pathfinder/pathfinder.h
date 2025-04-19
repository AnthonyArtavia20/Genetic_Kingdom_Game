// pathfinder.h
#ifndef PATHFINDER_H
#define PATHFINDER_H

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/variant/vector2i.hpp>
#include <godot_cpp/variant/packed_vector2_array.hpp>
#include "astar_grid.h"
#include <memory>

namespace godot {

class Pathfinder : public Node2D {
    GDCLASS(Pathfinder, Node2D)

private:
    std::unique_ptr<AStarGrid> astar;

protected:
    static void _bind_methods();

public:
    Pathfinder() {}
    ~Pathfinder() {}

    virtual void _ready() override;

    PackedVector2Array get_path(Vector2i start, Vector2i end) const;
    void set_obstacle(Vector2i pos, bool walkable);
};

} // namespace godot

#endif // PATHFINDER_H
