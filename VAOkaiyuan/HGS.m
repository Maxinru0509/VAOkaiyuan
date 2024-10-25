function [Destination_fitness,bestPositions,BestCost]=HGS(nPop,MaxIt,VarMin,VarMax,nVar,fobj)
% disp('HGS is now tackling your problem')

% tic
% initialize position
bestPositions=zeros(1,nVar);
tempPosition=zeros(nPop,nVar);

Destination_fitness=inf;%change this to -inf for maximization problems
Worstest_fitness=-inf;
AllFitness = inf*ones(nPop,1);%record the fitness of all positions
VC1 = ones(nPop,1);%record the variation control of all positions

weight3 = ones(nPop,nVar);%hungry weight of each position
weight4 = ones(nPop,nVar);%hungry weight of each position

%Initialize the set of random solutions
X=initialization(nPop,nVar,VarMax,VarMin);
BestCost=zeros(1,MaxIt);
it=1; %Number of iterations

hungry = zeros(1,size(X,1));%record the hungry of all positions
count=0;

% Main loop
while  it <= MaxIt
    VC2 = 0.03; %The variable of variation control 

    sumHungry = 0;%record the sum of each hungry 
    
    %sort the fitness
    for i=1:size(X,1)
        % Check if solutions go outside the search space and bring them back
        Flag4ub=X(i,:)>VarMax;
        Flag4lb=X(i,:)<VarMin;
        X(i,:)=(X(i,:).*(~(Flag4ub+Flag4lb)))+VarMax.*Flag4ub+VarMin.*Flag4lb;
        AllFitness(i) = fobj(X(i,:));
    end
    [AllFitnessSorted,IndexSorted] = sort(AllFitness);
    bestFitness = AllFitnessSorted(1);
    worstFitness = AllFitnessSorted(size(X,1));
    
    %update the best fitness value and best position
    if bestFitness < Destination_fitness
        bestPositions=X(IndexSorted(1),:);
        Destination_fitness = bestFitness;
        count=0;
    end
    
    if worstFitness > Worstest_fitness
        Worstest_fitness = worstFitness;
    end
    
    for i = 1:size(X,1)
         %calculate the variation control of all positions
         VC1(i) = sech(abs(AllFitness(i)-Destination_fitness));    
         %calculate the hungry of each position
        if Destination_fitness == AllFitness(i)
            hungry(1,i) = 0;
            count = count+1;
            tempPosition(count,:)=X(i,:);
        else
            temprand = rand();
            c = (AllFitness(i)-Destination_fitness)/(Worstest_fitness-Destination_fitness)*temprand*2*(VarMax-VarMin);
            if c<100
                b=100*(1+temprand);
            else
                b=c;
            end   
            hungry(1,i) = hungry(1,i)+ max(b); 
            sumHungry = sumHungry + hungry(1,i);
        end
    end 
    
    %calculate the hungry weight of each position
    for i=1:size(X,1)
        for j=2:size(X,2)
                weight3(i,j) = (1-exp(-abs(hungry(1,i)-sumHungry)))*rand()*2;
                if rand()<VC2
                    weight4(i,j) = hungry(1,i)*size(X,1)/sumHungry*rand();
                else
                    weight4(i,j) = 1;
                end
        end
        
    end
    
    
    % Update the Position of search agents
    shrink=2*(1-it/MaxIt); % a decreases linearly fron 2 to 0
    for i=1:size(X,1)
        if rand<VC2
            X(i,:) = X(i,j)*(1+randn(1));
        else
            A = randi([1,count]);
            for j=1:size(X,2)
                r = rand();
                vb = 2*shrink*r-shrink;%[-a,a]
                % Moving based on the bestPosition
                % The transformation range is controlled by weight3,bestPositions and X
                if r>VC1(i)
                    X(i,j) = weight4(i,j)*tempPosition(A,j)+vb*weight3(i,j)*abs(tempPosition(A,j)-X(i,j));
                else
                    X(i,j) = weight4(i,j)*tempPosition(A,j)-vb*weight3(i,j)*abs(tempPosition(A,j)-X(i,j));
                end
            end
        end
    end
    
    BestCost(it)=Destination_fitness;
    it=it+1;
    disp(['In Iteration No ' num2str(it) ': HGS Best Cost Is = ' num2str(Destination_fitness)]);
end
% toc
end