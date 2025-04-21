#include "pathfinder.h"
#include "astar_grid.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/vector2i.hpp>
#include <godot_cpp/variant/packed_vector2_array.hpp>

using namespace godot;

void Pathfinder::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_path", "start", "end"), &Pathfinder::get_path);
    ClassDB::bind_method(D_METHOD("set_obstacle", "pos", "walkable"), &Pathfinder::set_obstacle);
}

void Pathfinder::_ready() {
    astar = std::make_unique<AStarGrid>(40, 20);
    //astar->set_walkable(Vector2i(5, 5), false); // ejemplo
}

PackedVector2Array Pathfinder::get_path(Vector2i start, Vector2i end) const {
    std::vector<Vector2i> path = astar->compute_path(start, end);
    PackedVector2Array result;
    for (const Vector2i &p : path) {
        result.append(p);
    }
    return result;
}

void Pathfinder::set_obstacle(Vector2i pos, bool walkable) {
    astar->set_walkable(pos, walkable);
}
