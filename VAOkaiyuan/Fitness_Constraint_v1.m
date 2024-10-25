function [index] = Fitness_Constraint_v1(population, fitness, KI)

[populationSize, dimension] = size(population);
[~, constraint_number] = size(KI);

[~, bestIndex] = min(fitness); 
best_KI = KI(bestIndex, :);
best_pop = population(bestIndex, :);

distances_KI = zeros(1, populationSize); 
distances_pop = zeros(1, populationSize); 
normFitness = zeros(1, populationSize); 
normDistances_KI = zeros(1, populationSize); 
normDistances_pop = zeros(1, populationSize); 
divDistances = zeros(1, populationSize); 

if min(fitness) == max(fitness)
    
    index = randi(constraint_number);
    
else    
    
    %%%distances_KI
    for i = 1 : populationSize
        value = 0;
        for j = 1 : constraint_number
            value = value + abs(best_KI(j) - KI(i, j));
        end
        distances_KI(i) = value;
    end
    
    %%%distances_population
    for i = 1 : populationSize
        value = 0;
        for j = 1 : dimension
            value = value + abs(best_pop(j) - population(i, j));
        end
        distances_pop(i) = value;
    end
    
    minFitness = min(fitness); maxMinFitness = max(fitness) - minFitness;
    minDistance_pop = min(distances_pop); maxMinDistance_pop = max(distances_pop) - minDistance_pop;
    minDistance_KI = min(distances_KI); maxMinDistance_KI = max(distances_KI) - minDistance_KI;
    
    for i = 1 : populationSize  
        normFitness(i) = 1 - ((fitness(i) - minFitness) / maxMinFitness);
        normDistances_KI(i) = (distances_KI(i) - minDistance_KI) / maxMinDistance_KI;
        normDistances_pop(i) = (distances_pop(i) - minDistance_pop) / maxMinDistance_pop;
       
        KIval=KI(i,:);
        sumKI = (sumabs(KIval))/constraint_number; 
        
            if sumKI>1e-4 
                divDistances(i) = (normFitness(i) + normDistances_KI(i))/2;
            else
                divDistances(i) = (normFitness(i) + normDistances_pop(i))/2;
            end        
    end
    
    [~, index] = max(divDistances);
        
end
end