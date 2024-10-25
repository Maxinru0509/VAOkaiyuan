function [Best_flame_score,Best_flame_pos,BestCost4]=MFO(nPop,MaxIt, VarMin, VarMax,nVar,fobj)
% VarMin = -5.12;         % Lower Bound of Variables
% VarMax = 5.12;         % Upper Bound of Variables
% display('MFO is optimizing your problem');

%Initialize the positions of moths
Moth_pos=initialization(nPop,nVar,VarMax,VarMin);

BestCost4=zeros(1,MaxIt);

Iteration=1;

% Main loop
while Iteration<MaxIt+1
    
    % Number of flames Eq. (3.14) in the paper
    Flame_no=round(nPop-Iteration*((nPop-1)/MaxIt));
    
    for i=1:size(Moth_pos,1)
        
        % Check if moths go out of the search spaceand bring it back
        Flag4ub=Moth_pos(i,:)>VarMax;
        Flag4lb=Moth_pos(i,:)<VarMin;
        Moth_pos(i,:)=(Moth_pos(i,:).*(~(Flag4ub+Flag4lb)))+VarMax.*Flag4ub+VarMin.*Flag4lb;  
        
        % Calculate the fitness of moths
        Moth_fitness(1,i)=fobj(Moth_pos(i,:));  
        
    end
       
    if Iteration==1
        % Sort the first population of moths
        [fitness_sorted I]=sort(Moth_fitness);
        sorted_population=Moth_pos(I,:);
        
        % Update the flames
        best_flames=sorted_population;
        best_flame_fitness=fitness_sorted;
    else
        
        % Sort the moths
        double_population=[previous_population;best_flames];
        double_fitness=[previous_fitness best_flame_fitness];
        
        [double_fitness_sorted I]=sort(double_fitness);
        double_sorted_population=double_population(I,:);
        
        fitness_sorted=double_fitness_sorted(1:nPop);
        sorted_population=double_sorted_population(1:nPop,:);
        
        % Update the flames
        best_flames=sorted_population;
        best_flame_fitness=fitness_sorted;
    end
    
    % Update the position best flame obtained so far
    Best_flame_score=fitness_sorted(1);
    Best_flame_pos=sorted_population(1,:);
      
    previous_population=Moth_pos;
    previous_fitness=Moth_fitness;
    
    % a linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
    a=-1+Iteration*((-1)/MaxIt);
    
    for i=1:size(Moth_pos,1)
        
        for j=1:size(Moth_pos,2)
            if i<=Flame_no % Update the position of the moth with respect to its corresponsing flame
                
                % D in Eq. (3.13)
                distance_to_flame=abs(sorted_population(i,j)-Moth_pos(i,j));
                b=1;
                t=(a-1)*rand+1;
                
                % Eq. (3.12)
                Moth_pos(i,j)=distance_to_flame*exp(b.*t).*cos(t.*2*pi)+sorted_population(i,j);
            end
            
            if i>Flame_no % Upaate the position of the moth with respct to one flame
                
                % Eq. (3.13)
                distance_to_flame=abs(sorted_population(i,j)-Moth_pos(i,j));
                b=1;
                t=(a-1)*rand+1;
                
                % Eq. (3.12)
                Moth_pos(i,j)=distance_to_flame*exp(b.*t).*cos(t.*2*pi)+sorted_population(Flame_no,j);
            end
            
        end
        
    end
    
    BestCost4(Iteration)=Best_flame_score;
    
    % Display the iteration and best optimum obtained so far
%     if mod(Iteration,50)==0
        display(['In Iteration No ', num2str(Iteration), ' MFO Best Cost Is  ', num2str(Best_flame_score)]);
%     end
    Iteration=Iteration+1; 
end

