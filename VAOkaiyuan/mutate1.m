function mutant = mutate1(parent, mutationRate)
    nGenes = numel(parent); % ��ȡ������򳤶�
    mutant = parent; % ���Ƹ�������
    
    % ��ÿ��������б������
    for i = 1:nGenes
        if rand <= mutationRate % ���ݱ����ʾ����Ƿ���б���
            mutant(i) = rand(); % ��������µĻ���ֵ
        end
    end
end