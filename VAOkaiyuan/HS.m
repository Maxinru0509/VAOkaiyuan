function BestCost=HS(CostFunction,nVar,MaxIt)
VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = -5.12;          % Lower Bound of Decision Variables
VarMax = 5.12;          % Upper Bound of Decision Variables
% %% Harmony Search Parameters
% MaxIt = 500;     % Maximum Number of Iterations
HMS = 30;         % Harmony Memory Size
nNew = 25;        % Number of New Harmonies

HMCR = 0.9;       % Harmony Memory Consideration Rate
PAR = 0.2;        % Pitch Adjustment Rate
FW = 0.02*(VarMax-VarMin);    % Fret Width (Bandwidth)
FW_damp = 0.995;              % Fret Width Damp Ratio

%% Initialization

% Empty Harmony Structure
empty_harmony.Position = [];
empty_harmony.Cost = [];


% Initialize Harmony Memory
HM = repmat(empty_harmony, HMS, 1);

% Create Initial Harmonies
for i = 1:HMS
HM(i).Position = unifrnd(VarMin, VarMax, VarSize);
HM(i).Cost = CostFunction(HM(i).Position);
end

% Sort Harmony Memory
[~, SortOrder] = sort([HM.Cost]);
HM = HM(SortOrder);

% Update Best Solution Ever Found
BestSol = HM(1);

% Array to Hold Best Cost Values
BestCost = zeros(1,MaxIt);

%% Harmony Search Main Loop

for it = 1:MaxIt

% Initialize Array for New Harmonies
NEW = repmat(empty_harmony, nNew, 1);

% Create New Harmonies
for k = 1:nNew

% Create New Harmony Position
NEW(k).Position = unifrnd(VarMin, VarMax, VarSize);
for j = 1:nVar
if rand <= HMCR
% Use Harmony Memory
i = randi([1 HMS]);
NEW(k).Position(j) = HM(i).Position(j);
end

% Pitch Adjustment
if rand <= PAR
%DELTA = FW*unifrnd(-1, +1);    % Uniform
DELTA = FW*randn();            % Gaussian (Normal) 
NEW(k).Position(j) = NEW(k).Position(j)+DELTA;
end
end

% Apply Variable Limits
NEW(k).Position = max(NEW(k).Position, VarMin);
NEW(k).Position = min(NEW(k).Position, VarMax);

% Evaluation
NEW(k).Cost  = CostFunction(NEW(k).Position);
end

% Merge Harmony Memory and New Harmonies
HM = [HM
NEW]; %#ok

% Sort Harmony Memory
[~, SortOrder] = sort([HM.Cost]);
HM = HM(SortOrder);

% Truncate Extra Harmonies
HM = HM(1:HMS);

% Update Best Solution Ever Found
BestSol = HM(1);

% Store Best Cost Ever Found
BestCost(it) = BestSol.Cost;

% Show Iteration Information
disp(['Iteration ' num2str(it) ':HS Best Cost = ' num2str(BestCost(it))]);

% Damp Fret Width
FW = FW*FW_damp;

% figure(1);
% PlotSolution(BestSol.Sol, model);
% pause(0.01);

end
