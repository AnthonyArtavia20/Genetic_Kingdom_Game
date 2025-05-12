#include "GeneticAlgorithm.h"
#include <random>
#include <algorithm>

// clamp personalizado (C++14 compatible)
template <typename T>
T clamp(T value, T min_val, T max_val) {
    return std::max(min_val, std::min(value, max_val));
}

GeneticAlgorithm::GeneticAlgorithm(size_t population_size, float mutation_prob, float sigma_val)
    : pop_size(population_size), p_mut(mutation_prob), sigma(sigma_val) { }

std::vector<GeneticChromosome> GeneticAlgorithm::run_generation(
    const std::vector<GeneticChromosome>& parents,
    const std::vector<float>& fitnesses) {

    std::vector<GeneticChromosome> next_gen;
    next_gen.reserve(pop_size);

    std::mt19937_64 rng(std::random_device{}());
    std::uniform_real_distribution<float> uni01(0.0f, 1.0f);

    while (next_gen.size() < pop_size) {
        // 1) Selección (torneo)
        GeneticChromosome A = tournament_select(parents, fitnesses);
        GeneticChromosome B = tournament_select(parents, fitnesses);

        // 2) Cruce
        GeneticChromosome child = crossover_one_point(A, B);

        // 3) Mutación
        mutate(child);

        next_gen.push_back(child);
    }

    return next_gen;
}

GeneticChromosome GeneticAlgorithm::tournament_select(
    const std::vector<GeneticChromosome>& pop,
    const std::vector<float>& fitnesses) {

    static thread_local std::mt19937_64 rng(std::random_device{}());
    std::uniform_int_distribution<size_t> pick(0, pop.size() - 1);

    size_t i1 = pick(rng);
    size_t i2 = pick(rng);
    return (fitnesses[i1] > fitnesses[i2]) ? pop[i1] : pop[i2];
}

GeneticChromosome GeneticAlgorithm::crossover_one_point(
    const GeneticChromosome& A,
    const GeneticChromosome& B) {

    GeneticChromosome child;

    float a_genes[6] = { A.health, A.speed, A.arrow_res, A.magic_res, A.artillery_res, A.gold };
    float b_genes[6] = { B.health, B.speed, B.arrow_res, B.magic_res, B.artillery_res, B.gold };

    static thread_local std::mt19937_64 rng(std::random_device{}());
    std::uniform_int_distribution<int> cut_dp(0, 5);
    int cut = cut_dp(rng);

    float out[6];
    for (int i = 0; i < 6; ++i) {
        out[i] = (i <= cut) ? a_genes[i] : b_genes[i];
    }

    child.health        = out[0];
    child.speed         = out[1];
    child.arrow_res     = out[2];
    child.magic_res     = out[3];
    child.artillery_res = out[4];
    child.gold          = out[5];

    return child;
}

void GeneticAlgorithm::mutate(GeneticChromosome& chrom) {
    static thread_local std::mt19937_64 rng(std::random_device{}());
    std::uniform_real_distribution<float> uni01(0.0f, 1.0f);
    std::normal_distribution<float> gauss(0.0f, sigma);

    if (uni01(rng) < p_mut) chrom.health        += gauss(rng);
    if (uni01(rng) < p_mut) chrom.speed         += gauss(rng);
    if (uni01(rng) < p_mut) chrom.arrow_res     += gauss(rng);
    if (uni01(rng) < p_mut) chrom.magic_res     += gauss(rng);
    if (uni01(rng) < p_mut) chrom.artillery_res += gauss(rng);
    if (uni01(rng) < p_mut) chrom.gold          += gauss(rng);

    // Aplicar límites válidos
    chrom.health        = clamp(chrom.health,        10.0f, 300.0f);
    chrom.speed         = clamp(chrom.speed,         10.0f, 150.0f);
    chrom.arrow_res     = clamp(chrom.arrow_res,     0.0f, 1.0f);
    chrom.magic_res     = clamp(chrom.magic_res,     0.0f, 1.0f);
    chrom.artillery_res = clamp(chrom.artillery_res, 0.0f, 1.0f);
    chrom.gold          = clamp(chrom.gold,          10.0f, 45.0f);
}
