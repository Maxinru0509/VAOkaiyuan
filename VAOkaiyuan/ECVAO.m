%% VAO Algorithm Function

function [BestCost,mu_history7] = ECVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta)

if isscalar(VarMin) && isscalar(VarMax)   %�ж�VarMin��VarMax�Ƿ�Ϊ����
dmax = (VarMax-VarMin)*sqrt(dim);
else
dmax = norm(VarMax-VarMin);   %����
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
     
     mu_history7 = zeros(1, MaxIt); % ��ʼ��mu�ı仯��ʷ��¼  
     
    for it = 1:MaxIt
        newpop = repmat(plants, nPop, 1);
        for i = 1:nPop
            newpop(i).Cost = inf;
            for j = 1:nPop
                if pop(j).Cost < pop(i).Cost
                    rij = norm(pop(i).Position - pop(j).Position) / dmax;
                    beta = psi * exp(-omega * rij^lambda);
                    e = delta * unifrnd(-1, 1, VarSize);
                   
                    mu=0.2*(exp(-((it/MaxIt)*pi))*abs(cos(5*8*(it/MaxIt)*pi))); %����Ӧ������� 
                    
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
% Merge �ϲ�
        pop = [pop; newpop];%�ϲ�������Ⱥ
        [~, SortOrder] = sort([pop.Cost]); % Sort ����
        pop = pop(SortOrder);%ʹ�� sort �����Ժϲ������Ⱥ pop ���ݳɱ��������򣬵õ���������Ⱥ pop ����Ӧ���������� SortOrder��
        pop = pop(1:nPop);%ͨ����ȡ���� pop = pop(1:nPop); ����Ⱥ pop �ض�Ϊǰ nPop �����壬������Ⱥ��ģ���䡣

        BestCost(it) = BestSol.Cost;
        
        mu_history7(it) = mu; % ��¼��ǰ��muֵ

        disp(['In Iteration No ' num2str(it) ': ECVAO Best Cost Is = ' num2str(BestCost(it))]);
    end
%          figure;
%        semilogy(mu_history7,'DisplayName','EC-mu','color','y','Marker','p','markerindices',(1:50:500),'MarkerSize',6);
%        xlabel('Iteration');
%        ylabel('Mutation Rate');
% %        title('Mutation Rate History');
%        legend('EC-mu');
 end