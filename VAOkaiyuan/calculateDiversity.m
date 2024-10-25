function diversity = calculateDiversity(pop)
    nPop = numel(pop); % 获取种群大小
    nGenes = numel(pop(1).Position); % 获取个体基因长度

    % 计算种群中每个基因的分布范围
    geneRanges = zeros(nGenes, 2);
    for i = 1:nGenes
        geneValues = [pop.Position]; % 提取种群中所有个体的当前基因值
        geneRanges(i, :) = [min(geneValues(i: nGenes: end)), max(geneValues(i: nGenes: end))]; % 计算当前基因的最小值和最大值
    end

    % 计算基于基因分布范围的多样性度量
    diversity = 0;
    for i = 1:nGenes
        geneRange = geneRanges(i, :);
        geneDiversity = geneRange(2) - geneRange(1); % 当前基因的范围
        diversity = diversity + geneDiversity;
    end

    diversity = diversity / nGenes; % 平均多样性度量
end