#include "astar_grid.h"
#include <algorithm>
#include <cmath>

AStarGrid::AStarGrid(int w, int h) : width(w), height(h) {}

void AStarGrid::add_obstacle(Vector2i position) {
    obstacles[position] = true;
}

void AStarGrid::remove_obstacle(Vector2i position) {
    obstacles.erase(position);
}

void AStarGrid::set_walkable(Vector2i pos, bool walkable) {
    if (walkable) {
        remove_obstacle(pos);
    } else {
        add_obstacle(pos);
    }
}


bool AStarGrid::is_obstacle(Vector2i position) const {
    auto it = obstacles.find(position);
    return it != obstacles.end();
}

std::vector<Vector2i> AStarGrid::compute_path(Vector2i start, Vector2i goal) const {
    std::priority_queue<std::pair<int, Vector2i>,
                        std::vector<std::pair<int, Vector2i>>,
                        std::greater<>> frontier;
    frontier.emplace(0, start);

    std::unordered_map<Vector2i, Vector2i, Vector2iHash> came_from;
    std::unordered_map<Vector2i, int, Vector2iHash> cost_so_far;
    came_from[start] = start;
    cost_so_far[start] = 0;

    const Vector2i directions[] = {
        {1, 0}, {-1, 0}, {0, 1}, {0, -1}
    };

    while (!frontier.empty()) {
        Vector2i current = frontier.top().second;
        frontier.pop();

        if (current == goal) break;

        for (const Vector2i &dir : directions) {
            Vector2i next = current + dir;
            if (next.x < 0 || next.y < 0 || next.x >= width || next.y >= height || is_obstacle(next))
                continue;

            int new_cost = cost_so_far[current] + 1;
            if (cost_so_far.find(next) == cost_so_far.end() || new_cost < cost_so_far[next]) {
                cost_so_far[next] = new_cost;
                int priority = new_cost + abs(goal.x - next.x) + abs(goal.y - next.y);
                frontier.emplace(priority, next);
                came_from[next] = current;
            }
        }
    }

    std::vector<Vector2i> path;
    if (came_from.find(goal) == came_from.end()) return path;

    for (Vector2i at = goal; at != start; at = came_from[at])
        path.push_back(at);

    path.push_back(start);
    std::reverse(path.begin(), path.end());
    return path;
}
