function diversity = calculateDiversity(pop)
    nPop = numel(pop); % ��ȡ��Ⱥ��С
    nGenes = numel(pop(1).Position); % ��ȡ������򳤶�

    % ������Ⱥ��ÿ������ķֲ���Χ
    geneRanges = zeros(nGenes, 2);
    for i = 1:nGenes
        geneValues = [pop.Position]; % ��ȡ��Ⱥ�����и���ĵ�ǰ����ֵ
        geneRanges(i, :) = [min(geneValues(i: nGenes: end)), max(geneValues(i: nGenes: end))]; % ���㵱ǰ�������Сֵ�����ֵ
    end

    % ������ڻ���ֲ���Χ�Ķ����Զ���
    diversity = 0;
    for i = 1:nGenes
        geneRange = geneRanges(i, :);
        geneDiversity = geneRange(2) - geneRange(1); % ��ǰ����ķ�Χ
        diversity = diversity + geneDiversity;
    end

    diversity = diversity / nGenes; % ƽ�������Զ���
end