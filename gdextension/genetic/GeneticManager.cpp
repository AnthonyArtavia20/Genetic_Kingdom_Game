#include "GeneticManager.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void GeneticManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("_on_wave_completed", "stats"), &GeneticManager::_on_wave_completed);

    ADD_SIGNAL(MethodInfo("generation_ready",
        PropertyInfo(Variant::ARRAY, "new_population")
    ));
}

GeneticManager::GeneticManager() {
    // Inicialización diferida en _on_wave_completed
    ga = nullptr;
}

GeneticManager::~GeneticManager() {
    if (ga != nullptr)
        delete ga;
}

void GeneticManager::_on_wave_completed(const Dictionary &stats) {
    Array lived = stats["lived_times"];
    Array gold  = stats["gold_drops"];
    Array original_data = stats["original_data"];

    const float tau_max = 30000.0f;
    const float g_max   = 50.0f;

    std::vector<GeneticChromosome> parents;
    std::vector<float> fitnesses;

    int count = lived.size();
    parents.reserve(count);
    fitnesses.reserve(count);

    for (int i = 0; i < count; ++i) {
        Dictionary d = original_data[i];  // ✅ Tomar datos reales

        GeneticChromosome chrom;
        chrom.health        = d["health"];
        chrom.speed         = d["speed"];
        chrom.arrow_res     = d["arrow_res"];
        chrom.magic_res     = d["magic_res"];
        chrom.artillery_res = d["artillery_res"];
        chrom.gold          = d["gold"];
        parents.push_back(chrom);

        float t_norm = float(lived[i]) / tau_max;
        float g_norm = float(gold[i])  / g_max;
        fitnesses.push_back(0.5f * t_norm + 0.5f * g_norm);
    }

    // Se Reinicializar el GA según el tamaño de la oleada
    if (ga != nullptr) delete ga;
    ga = new GeneticAlgorithm(count, 1.0f, 6.0f); // Mutación del 100%, sigma más alto


    auto next_gen = ga->run_generation(parents, fitnesses);

    Array out;
    for (auto &c : next_gen) {
        Dictionary d;
        d["health"]        = c.health;
        d["speed"]         = c.speed;
        d["arrow_res"]     = c.arrow_res;
        d["magic_res"]     = c.magic_res;
        d["artillery_res"] = c.artillery_res;
        d["gold"]          = c.gold;

        // Inferencia de tipo a partir del oro esto cambia los enemigos que se generan cada oleada.
        if (c.gold >= 40.0f) {
            d["type"] = "merc";
        } else if (c.gold >= 30.0f) {
            d["type"] = "harpia";
        } else if (c.gold >= 20.0f) {
            d["type"] = "elfo";
        } else {
            d["type"] = "ogro";
        }

        out.append(d);
    }

    emit_signal("generation_ready", out);
    UtilityFunctions::print("🏁 [C++] generation_ready emitted with ", out.size(), " individuals");
}
