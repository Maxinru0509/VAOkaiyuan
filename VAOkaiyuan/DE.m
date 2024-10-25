function BestCost=DE(CostFunction,nVar,MaxIt)
for u = 1:1
VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = -5.12;          % Lower Bound of Decision Variables
VarMax = 5.12;          % Upper Bound of Decision Variables
% 
% %% DE Parameters
% 
% MaxIt = 500;      % Maximum Number of Iterations
 nPop = 30;        % Population Size

beta_min = 0.2;   % Lower Bound of Scaling Factor
beta_max = 0.8;   % Upper Bound of Scaling Factor

pCR = 0.2;        % Crossover Probability

%% Initialization

empty_individual.Position = [];
empty_individual.Cost = [];

BestSol.Cost = inf;

pop = repmat(empty_individual, nPop, 1);

for i = 1:nPop

pop(i).Position = unifrnd(VarMin, VarMax, VarSize);

pop(i).Cost = CostFunction(pop(i).Position);

if pop(i).Cost<BestSol.Cost
BestSol = pop(i);
end

end

BestCost = zeros(1, MaxIt);

%% DE Main Loop

for it = 1:MaxIt

for i = 1:nPop

r = pop(i).Position;

A = randperm(nPop);

A(A == i) = [];

a = A(1);
b = A(2);
c = A(3);

% Mutation
%beta = unifrnd(beta_min, beta_max);
beta = unifrnd(beta_min, beta_max, VarSize);
y = pop(a).Position+beta.*(pop(b).Position-pop(c).Position);
y = max(y, VarMin);
y = min(y, VarMax);

% Crossover
z = zeros(size(r));
j0 = randi([1 numel(r)]);
for j = 1:numel(r)
if j == j0 || rand <= pCR
z(j) = y(j);
else
z(j) = r(j);
end
end

NewSol.Position = z;
NewSol.Cost = CostFunction(NewSol.Position);

if NewSol.Cost<pop(i).Cost
pop(i) = NewSol;

if pop(i).Cost<BestSol.Cost
BestSol = pop(i);
end
end

end

% Update Best Cost
BestCost(it) = BestSol.Cost;
% Show Iteration Information
disp(['Iteration ' num2str(it) ':DE Best Cost = ' num2str(BestCost(it))]);

end
end
% r=BestSol.Position;
% err=BestSol.Cost;

%% Show Results
% figure;
% plot(BestCost,'k','LineWidth',2);
% xlabel('Iteration');
% ylabel('Best Cost');
% ax = gca; 
% ax.FontSize = 12; 
% ax.FontWeight='bold';
% grid on;
