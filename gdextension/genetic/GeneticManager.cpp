#include "GeneticManager.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void GeneticManager::_bind_methods() {
	ClassDB::bind_method(D_METHOD("_on_wave_completed", "stats"),
	                     &GeneticManager::_on_wave_completed);

	ADD_SIGNAL(MethodInfo("generation_ready",
	    PropertyInfo(Variant::ARRAY, "new_population")));
}

GeneticManager::GeneticManager() {
	ga = new GeneticAlgorithm(20, 0.5f, 0.1f);  // población, elitismo, mutación
}

GeneticManager::~GeneticManager() {
	delete ga;
}

void GeneticManager::_on_wave_completed(const Dictionary &stats) {
	Array lived = stats["lived_times"];
	Array golds = stats["gold_drops"];
	Array originals = stats["original_data"];

	const float tau_max = 30000.0f;
	const float g_max = 50.0f;

	std::vector<GeneticChromosome> parents;
	std::vector<float> fitnesses;

	for (int i = 0; i < lived.size(); ++i) {
		GeneticChromosome chrom;

		if (i < originals.size()) {
			Dictionary d = originals[i];
			chrom.health        = d.get("health", 50.0f);
			chrom.speed         = d.get("speed", 50.0f);
			chrom.arrow_res     = d.get("arrow_res", 0.0f);
			chrom.magic_res     = d.get("magic_res", 0.0f);
			chrom.artillery_res = d.get("artillery_res", 0.0f);
			chrom.gold          = d.get("gold", 10.0f);
		}

		parents.push_back(chrom);

		float t_norm = float(lived[i]) / tau_max;
		float g_norm = float(golds[i]) / g_max;
		fitnesses.push_back(0.5f * t_norm + 0.5f * g_norm);
	}

	// Ejecutar la nueva generación
	auto next_gen = ga->run_generation(parents, fitnesses);

	// Convertir a Array para Godot
	Array out;
	for (auto &c : next_gen) {
		Dictionary d;
		d["health"]        = c.health;
		d["speed"]         = c.speed;
		d["arrow_res"]     = c.arrow_res;
		d["magic_res"]     = c.magic_res;
		d["artillery_res"] = c.artillery_res;
		d["gold"]          = c.gold;

		if (c.gold >= 44)
			d["type"] = "merc";
		else if (c.gold >= 29)
			d["type"] = "harpia";
		else if (c.gold >= 24)
			d["type"] = "elfo";
		else
			d["type"] = "ogro";

		out.append(d);
	}

	emit_signal("generation_ready", out);
	UtilityFunctions::print("🏁 [C++] generation_ready emitted with ", out.size(), " individuals");
}
