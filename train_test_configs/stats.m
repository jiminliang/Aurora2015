% ͳ�Ʊ�����ݿ�������������ÿ��ÿ������������
% �洢Ϊmat�ļ�

clear all
clc;

% labeled = textread('labeled09_8K.txt','%s');    % 8001�����ͼ�񣬴�38044��ѡ�������
% labeled = textread('alllbp04-09Pri_70K.txt','%s');% ��ٻJASTP�����з����õ�04-09������
labeled = textread('Alllabel2003_38044.txt','%s');% 2009���ǵ�03��������ݣ�38044��ͼ��
labeled = reshape(labeled, 2, length(labeled)/2);
labeled = labeled';

dayslist = [];
types = [];
for i=1:size(labeled,1)
    filename = [labeled{i,1}];
    day = filename(2:9);
    label = uint64(str2num(labeled{i,2}));
    
    row = findDay(dayslist,day);
    if ~isempty(row)
        types(row,label) = types(row,label) + 1;
    else
        dayslist = [dayslist; day];
        types = [types; zeros(1,4)];
        row = size(dayslist,1);
        types(row,label) = types(row,label) + 1;
    end
end

dayslist
types
% save('stats_38044.mat', 'dayslist', 'types');

                