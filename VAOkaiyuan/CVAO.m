%% VAO Algorithm Function

function [BestCost,mu_history2] = CVAO(CostFunction, nVar, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta)

if isscalar(VarMin) && isscalar(VarMax)   %判断VarMin和VarMax是否为标量
dmax = (VarMax-VarMin)*sqrt(nVar);
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

     BestCost = zeros(1,MaxIt);
     
     mu_history2 = zeros(1, MaxIt); % 初始化mu的变化历史记录  
     
    for it = 1:MaxIt
        
        newpop = repmat(plants, nPop, 1);
        for i = 1:nPop
            newpop(i).Cost = inf;
            for j = 1:nPop
                if pop(j).Cost < pop(i).Cost
                    rij = norm(pop(i).Position - pop(j).Position) / dmax;
                    beta = psi * exp(-omega * rij^lambda);
                    e = delta .* unifrnd(-1, 1, VarSize);
                                       
                     newsol.Position = pop(i).Position ...
                        + beta * rand(VarSize) .* (pop(j).Position - pop(i).Position) ...
                        + mu * e;


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
% Merge 合并
        pop = [pop; newpop];%合并两个种群



        [~, SortOrder] = sort([pop.Cost]); % Sort 排序
        pop = pop(SortOrder);%使用 sort 函数对合并后的种群 pop 根据成本进行排序，得到排序后的种群 pop 和相应的排序索引 SortOrder。
        pop = pop(1:nPop);%通过截取操作 pop = pop(1:nPop); 将种群 pop 截断为前 nPop 个个体，保留种群规模不变。

        BestCost(it) = BestSol.Cost;
        mu_history2(it) = mu; % 记录当前的mu值
       
        disp(['In Iteration No ' num2str(it) ': CVAO Best Cost Is = ' num2str(BestCost(it))]);
    end
         figure;
       semilogy(mu_history2,'DisplayName','C-mu','color','#FFD700','Marker','<','markerindices',(1:20:MaxIt),'MarkerSize',6,'LineStyle','--','linewidth',1.3);
       xlabel('Iteration');
       ylabel('Mutation');
%        title('Mutation Rate History');
       legend('C-mu');
 end