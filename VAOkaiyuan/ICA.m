function BestCost = ICA(CostFunction,nVar,MaxIt)
VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = -5.12;         % Lower Bound of Variables
VarMax =5.12;         % Upper Bound of Variables
% 
% 
% %% ICA Parameters
% 
% MaxIt = 500;         % Maximum Number of Iterations
nPop = 30;            % Population Size
nEmp = 25;            % Number of Empires/Imperialists

alpha = 1;            % Selection Pressure
beta = 1.5;           % Assimilation Coefficient
pRevolution = 0.05;   % Revolution Probability
mu = 0.1;             % Revolution Rate
zeta = 0.2;           % Colonies Mean Cost Coefficient


%% Globalization of Parameters and Settings

global ProblemSettings;
ProblemSettings.CostFunction = CostFunction;
ProblemSettings.nVar = nVar;
ProblemSettings.VarSize = VarSize;
ProblemSettings.VarMin = VarMin;
ProblemSettings.VarMax = VarMax;

global ICASettings;
ICASettings.MaxIt = MaxIt;
ICASettings.nPop = nPop;
ICASettings.nEmp = nEmp;
ICASettings.alpha = alpha;
ICASettings.beta = beta;
ICASettings.pRevolution = pRevolution;
ICASettings.mu = mu;
ICASettings.zeta = zeta;


%% Initialization

% Initialize Empires
emp = CreateInitialEmpires();

% Array to Hold Best Cost Values
BestCost = zeros(1,MaxIt);


%% ICA Main Loop

for it = 1:MaxIt
    
    % Assimilation
    emp = AssimilateColonies(emp);
    
    % Revolution
    emp = DoRevolution(emp);
    
    % Intra-Empire Competition
    emp = IntraEmpireCompetition(emp);
    
    % Update Total Cost of Empires
    emp = UpdateTotalCost(emp);
    
    % Inter-Empire Competition
    emp = InterEmpireCompetition(emp);
    
    % Update Best Solution Ever Found
    imp = [emp.Imp];
    [~, BestImpIndex] = min([imp.Cost]);
    BestSol = imp(BestImpIndex);
    
    % Update Best Cost
    BestCost(it) = BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ':ICA Best Cost = ' num2str(BestCost(it))]);
    
end


%% Results

% figure;
% %plot(BestCost, 'LineWidth', 2);
% semilogy(BestCost, 'LineWidth', 2);
% xlabel('Iteration');
% ylabel('Best Cost');
% grid on;