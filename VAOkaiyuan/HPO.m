function BestCost = HPO(CostFunction,nVar)
VarSize = [1 nVar];       % Decision Variables Matrix Size

lb = -100;             % Decision Variables Lower Bound
ub = 100;             % Decision Variables Upper Bound
%% HPO Parameters
  MaxIt = 500;     % Maximum Nomber of Iterations
  nPop = 30;         % Population Size
  BestCost = zeros(1,MaxIt);

% Constriction Coefeicient
B = 0.1;

%% Initialization
 HPpos=rand(nPop,nVar).*(ub-lb)+lb;
% for i=1:nPop
%     HPposFitness(i)=inf;
% end
    % Evaluate
for i=1:size(HPpos,1)
HPposFitness(i)=CostFunction(HPpos(i,:));       
end
% NFE = nPop;
 [~,indx] = min(HPposFitness);
% 
 Target = HPpos(indx,:);   % Target HPO
 TargetScore =HPposFitness(indx);
 BestCost(1)=TargetScore;

%nfe = zeros(1,MaxIt);

%% HPO Main Loop
for it = 2:MaxIt

   c = 1 - it*((0.98)/MaxIt);   % Update C Parameter
    kbest=round(nPop*c);        % Update kbest
     for i = 1:nPop
            r1=rand(1,nVar)<c;
            r2=rand;
            r3=rand(1,nVar);
            idx=(r1==0);
            z=r2.*idx+r3.*~idx;
%             r11=rand(1,dim)<c;
%             r22=rand;
%             r33=rand(1,dim);
%             idx=(r11==0);
%             z2=r22.*idx+r33.*~idx;
        if rand<B
        xi=mean(HPpos);
        dist = pdist2(xi,HPpos);
        [~,idxsortdist]=sort(dist);
        SI=HPpos(idxsortdist(kbest),:);
        HPpos(i,:) =HPpos(i,:)+0.5*((2*(c)*z.*SI-HPpos(i,:))+(2*(1-c)*z.*xi-HPpos(i,:)));
        else
          for j=1:nVar
            rr=-1+2*z(j);
          HPpos(i,j)= 2*z(j)*cos(2*pi*rr)*(Target(j)-HPpos(i,j))+Target(j);

          end
        end  
        HPpos(i,:) = min(max(HPpos(i,:),lb),ub);
        % Evaluation
        HPposFitness(i) = CostFunction(HPpos(i,:));
        % Update Target
        if HPposFitness(i)<TargetScore 
            Target = HPpos(i,:);
            TargetScore = HPposFitness(i);
        end
     end
  
    
  BestCost(it)=TargetScore;
   disp(['Iteration: ',num2str(it),'HPO Best Cost = ',num2str(TargetScore)]);
 end