//declara el nodo Godot GeneticManager

#pragma once

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include "GeneticAlgorithm.h"

using namespace godot;

class GeneticManager : public Node2D {
    GDCLASS(GeneticManager, Node2D);

protected:
    static void _bind_methods();

public:
    GeneticManager();
    ~GeneticManager();

    // Handler para la señal wave_completed de Main.gd
    void _on_wave_completed(const Dictionary &stats);

private:
    GeneticAlgorithm *ga;
};
