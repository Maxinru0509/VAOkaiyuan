function [Agent_Fit,Agent_Pos,BestCost]=SAO(MaxIt,nVar,VarMax,VarMin,CostFunction)

Agent_Pos=zeros(1,nVar);
Agent_Fit=inf; %


Molecules=35;
olf=0.9;
K=0.6;
T=0.95;
M=0.9;
Step=0.02;

%Create the initial position of smell molecules
molesPos=initialization(Molecules,nVar,VarMax,VarMin);
BestScore=inf;
BestCost=zeros(1,MaxIt);


iter=0;% 

% Main loop
while iter<MaxIt
    for i=1:size(molesPos,1)        
%Make Sure smell molecules remains in the search space.
        Clip_ub=molesPos(i,:)>VarMax;
        Clip_lb=molesPos(i,:)<VarMin;
        molesPos(i,:)=(molesPos(i,:).*(~(Clip_ub+Clip_lb)))+VarMax.*Clip_ub+VarMin.*Clip_lb;                      
        % Calculate objective function for each molecules
        fitness=CostFunction(molesPos(i,:));        
        % Agent Fitness
        if fitness<Agent_Fit 
            Agent_Fit=fitness; % Update Agent fitness
            Agent_Pos=molesPos(i,:);
        end
    end  
    % Update the Position of molecules
    for i=1:size(molesPos,1)
        for j=1:size(molesPos,2)     
                       
            r1=rand(); % r1 is a random number in [0,1]
            r3=rand();       
            r4=rand();
            r5=rand();
            Sniff_mole(i,j)=molesPos(i,j)+r1*sqrt(3*K*T/M); %Sniffing Mode
        end
        fitness=CostFunction(Sniff_mole(i,:));
        [~,Index]=min(fitness);
        Agent_Pos=Sniff_mole(:,Index);
        [~,Indes]=max(fitness);
        Worst_Pos=Sniff_mole(:,Indes);
        if fitness<BestScore
            BestScore=fitness;
            molesPos(i,:)=Sniff_mole(i,:);
        end
        %Trailing Mode       
        for j=1:size(molesPos,2)     
            Trail_mole(i,j)=molesPos(i,j)+r3*olf*(molesPos(i,j)-Agent_Pos(i,1))...
                -r4*olf*(molesPos(i,j)-Worst_Pos(i,1)); %Traili Mode
        end
        fitness=CostFunction(Trail_mole(i,:));
        if fitness<BestScore
            BestScore=fitness;
            molesPos(i,:)=Trail_mole(i,:);
        end
         %Random Mode
        for j=1:size(molesPos,2)     
            Random_mole(i,j)=molesPos(i,j)+r5*Step; 
        end
        fitness=CostFunction(Random_mole(i,:));
        if fitness<BestScore
            BestScore=fitness;
            molesPos(i,:)=Random_mole(i,:);
        end                  
    end
    iter=iter+1;    
%     Agent_Fit=BestScore;
    BestCost(iter)=Agent_Fit;
    display(['In Iteration No ', num2str(iter), ' SAO Best Cost Is  ', num2str(Agent_Fit)]);
end