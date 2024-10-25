function [newpop5] = intervalSelect(pop5, nPop)
    % Sort the population based on fitness (assuming fitness is the last column)
    [~, sortIdx] = sort(pop5(:, end));
    pop5 = pop5(sortIdx, :);
    n=size(pop5, 1);%行，相当于个体数
    m=round(n/nPop);

    % Select individuals with specified step
    Ind = 1:m:n;
    selectedPopulation = pop5(Ind, :);
    g = size(selectedPopulation, 1) ;
    % Check if the selected population size is less than nPop
    if g < nPop
        % Calculate the number of additional individuals needed
        remainingNeeded = nPop - g;
        
        if remainingNeeded > 0
            % Supplement the selected population with randomly selected individuals from the sorted population
            remainingIndices = randperm(n, remainingNeeded);
            selectedPopulation = [selectedPopulation; pop5(remainingIndices, :)];
        end
    elseif g > nPop
        % If the selected population size is greater than nPop, discard the excess individuals
        selectedPopulation = selectedPopulation(1:nPop, :);
    end
    
    % Store the selected population in newpop
    newpop5 = selectedPopulation;
end

