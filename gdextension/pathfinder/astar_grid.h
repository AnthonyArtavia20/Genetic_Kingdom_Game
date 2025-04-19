#ifndef ASTAR_GRID_H
#define ASTAR_GRID_H

#include <unordered_map>
#include <vector>
#include <queue>
#include <limits>
#include <cmath>
#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/variant/vector2i.hpp>
#include <godot_cpp/variant/packed_vector2_array.hpp>


using namespace godot;

struct Vector2iHash {
    std::size_t operator()(const godot::Vector2i& v) const {
        return std::hash<int>()(v.x) ^ (std::hash<int>()(v.y) << 1);
    }
};


class AStarGrid {
public:
    AStarGrid(int width, int height);

    void add_obstacle(Vector2i position);
    void remove_obstacle(Vector2i position);
    bool is_obstacle(Vector2i position) const;
    std::vector<Vector2i> compute_path(Vector2i start, Vector2i goal) const;

    // Agregado para compatibilidad con Pathfinder
    void set_walkable(Vector2i pos, bool walkable);

private:
    int width, height;
    std::unordered_map<Vector2i, bool, struct Vector2iHash> obstacles;

    struct Vector2iHash {
        std::size_t operator()(const Vector2i& v) const {
            return std::hash<int>()(v.x) ^ (std::hash<int>()(v.y) << 1);
        }
    };

    std::vector<Vector2i> get_neighbors(Vector2i node) const;
    int heuristic(Vector2i a, Vector2i b) const;
};

#endif // ASTAR_GRID_H
