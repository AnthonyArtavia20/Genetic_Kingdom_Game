//Declara class GeneticAlgorithm

#pragma once
#include <vector>
#include "GeneticChromosome.h"

class GeneticAlgorithm {
public:
    GeneticAlgorithm(size_t population_size, float mutation_prob, float sigma);

    // Ejecuta una generación entera y devuelve la nueva población
    std::vector<GeneticChromosome> run_generation(
        const std::vector<GeneticChromosome>& parents,
        const std::vector<float>& fitnesses);

private:
    size_t pop_size;
    float  p_mut;   // probabilidad de mutar cada gen
    float  sigma;   // desviación gaussiana de la mutación

    // Métodos auxiliares
    GeneticChromosome tournament_select(
        const std::vector<GeneticChromosome>& pop,
        const std::vector<float>& fitnesses);
    GeneticChromosome crossover_one_point(
        const GeneticChromosome& A,
        const GeneticChromosome& B);
    void mutate(GeneticChromosome& chrom);
};