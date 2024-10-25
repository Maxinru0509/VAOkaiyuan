%% randVAO Algorithm Function

function [BestCost,mu_history2]= randVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu ,mu_damp,delta )

if isscalar(VarMin) && isscalar(VarMax)   %判断VarMin和VarMax是否为标量
dmax = (VarMax-VarMin)*sqrt(dim);
else
dmax = norm(VarMax-VarMin);   %范数
end
 
    plants.Position = [];
    plants.Cost = [];

    % Initialize Population Array
    pop = repmat(plants, nPop, 1);

    % Initialize Best Solution Ever Found
    BestSol.Cost = inf;

    % Create Initial Plants
    for i = 1:nPop
        pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
        pop(i).Cost = CostFunction(pop(i).Position);
        if pop(i).Cost <= BestSol.Cost
            BestSol = pop(i);
        end
    end
    
    BestCost = zeros(1, MaxIt);
    
    for it = 1:MaxIt
        newpop = repmat(plants, nPop, 1);
        for i = 1:nPop
            newpop(i).Cost = inf;
            for j = 1:nPop
                if pop(j).Cost < pop(i).Cost
                    rij = norm(pop(i).Position - pop(j).Position) / dmax;
                    beta = psi * exp(-omega * rij^lambda);
%                     delta1 = (1 - exp(-it / MaxIt))* (VarMax - VarMin);
                    e = delta * unifrnd(-1, 1, VarSize);
                    
                   newsol.Position = pop(i).Position ...
                        + beta * ( 2 * rand(VarSize) - 1) .* (pop(j).Position - pop(i).Position) ...
                        + mu * e;
% % 光合作用算子
%   newsol.Position = newsol.Position +(VarMax - VarMin) * (1 - exp(-it / MaxIt)) * rand(VarSize) .* (BestSol.Position - newsol.Position);
                    
                    newsol.Position = max(newsol.Position, VarMin);
                    newsol.Position = min(newsol.Position, VarMax);
                    newsol.Cost = CostFunction(newsol.Position);
  

                    if newsol.Cost <= newpop(i).Cost
                        newpop(i) = newsol;
                        if newpop(i).Cost <= BestSol.Cost
                            BestSol = newpop(i);
                        end
                    end
                end
            end
        end

        pop = [pop; newpop];
        [~, SortOrder] = sort([pop.Cost]);
        pop = pop(SortOrder);
        pop = pop(1:nPop);

        BestCost(it) = BestSol.Cost;
        
         
        mu = mu * mu_damp;

             
        disp(['In Iteration No ' num2str(it) ': randVAO Best Cost Is = ' num2str(BestCost(it))]);
     end

end

