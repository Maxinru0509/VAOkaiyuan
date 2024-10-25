function [index1, index2, index3] = Fitness_Constraint_v2(population, fitness, KI)

[populationSize, dimension] = size(population);
[~, constraint_number] = size(KI);

index=zeros(1,3);
[~,fit_index]=sort(fitness);

bestKI_1=KI(fit_index(1), :);
bestKI_2=KI(fit_index(2), :);
bestKI_3=KI(fit_index(3), :);
bestKI=[bestKI_1; bestKI_2;bestKI_3];

bestpop_1=population(fit_index(1), :);
bestpop_2=population(fit_index(2), :);
bestpop_3=population(fit_index(3), :);
bestpop=[bestpop_1; bestpop_2;bestpop_3];


distances_KI = zeros(3, populationSize); 
distances_pop = zeros(3, populationSize); 
normFitness = zeros(1, populationSize); 
normDistances_KI = zeros(1, populationSize); 
normDistances_pop = zeros(1, populationSize); 
divDistances = zeros(1, populationSize); 

if min(fitness) == max(fitness)
%     disp('nofdb')
    index1 = randi(populationSize);
    index2 = randi(populationSize);
    index3 = randi(populationSize);
    
else  
    
    for n=1:3
    %%%distances_KI
        for i = 1 : populationSize
            value = 0;
            for j = 1 : constraint_number
                value = value + abs(bestKI(n, j) - KI(i, j));
            end
            distances_KI(n,i) = value;
        end


        %%%distances_population
        for i = 1 : populationSize
            value = 0;
            for j = 1 : dimension
                value = value + abs(bestpop(n, j) - population(i, j));
            end
            distances_pop(n, i) = value;
        end


        minFitness = min(fitness); 
        maxMinFitness = max(fitness) - minFitness;

        minDistance_pop = min(distances_pop(n,:)); 
        maxMinDistance_pop = max(distances_pop(n,:)) - minDistance_pop;

        minDistance_KI = min(distances_KI(n,:)); 
        maxMinDistance_KI = max(distances_KI(n,:)) - minDistance_KI;

        %%%kýsýt ihlali kontrolü
        for i = 1 : populationSize  
            normFitness(i) = 1 - ((fitness(i) - minFitness) / maxMinFitness);
            normDistances_KI(i) = (distances_KI(n,i) - minDistance_KI) / maxMinDistance_KI;
            normDistances_pop(i) = (distances_pop(n,i) - minDistance_pop) / maxMinDistance_pop;

            KIval=KI(i,:);
            sumKI = (sumabs(KIval))/constraint_number; 

                if sumKI>1e-4 

                    divDistances(i) = (normFitness(i) + normDistances_KI(i))/2;
                else

                    divDistances(i) = (normFitness(i) + normDistances_pop(i))/2;

                end

        end
    
    [~, index(n)] = max(divDistances);
    
    end %%end for n
    index1=index(1);
    index2=index(2);
    index3=index(3);
   
end

end