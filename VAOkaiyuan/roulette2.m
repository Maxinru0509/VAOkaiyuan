function[newpop2] = roulette2(pop2,nVar,nPop)
%roulette is the traditional selection function with the probability of
%surviving equal to the fittness of i / sum of the fittness of all individuals
%
%function[newPop] = roulette(oldPop,options)
%newPop  - the new population selected from the oldPop
%oldPop  - the current population
%options - options [gen]

%Get the parameters of the population
numVars = size(pop2,2);
numSols = size(pop2,1);
% 查找矩阵pop中最后一列的Inf值并替换
for i = 1:size(pop2, 1)
    % 检查最后一列的值是否为Inf
    if isinf(pop2(i, numVars ))
        % 将Inf替换为上一列的数值
        pop2(i, numVars ) =0;
    end
end

%Generate the relative probabilites of selection
totalFit = sum(pop2(:,numVars));
prob=pop2(:,numVars) / totalFit; 
prob=cumsum(prob);

rNums=sort(rand(numSols,1)); 		%Generate random numbers
newpop2=zeros(nPop,nVar+1);
%Select individuals from the oldPop to the new
fitIn=1;newIn=1;
while newIn<=nPop
  if(rNums(newIn)<prob(fitIn))
    newpop2(newIn,:) = pop2(fitIn,:);
    newIn = newIn+1;
  else
    fitIn = fitIn + 1;
  end
end

