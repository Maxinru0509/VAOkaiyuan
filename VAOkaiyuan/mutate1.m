function mutant = mutate1(parent, mutationRate)
    nGenes = numel(parent); % 获取个体基因长度
    mutant = parent; % 复制父代个体
    
    % 对每个基因进行变异操作
    for i = 1:nGenes
        if rand <= mutationRate % 根据变异率决定是否进行变异
            mutant(i) = rand(); % 随机生成新的基因值
        end
    end
end