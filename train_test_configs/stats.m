% 统计标记数据库中样本天数及每天每类样本的数量
% 存储为mat文件

clear all
clc;

% labeled = textread('labeled09_8K.txt','%s');    % 8001幅标记图像，从38044中选择出来的
% labeled = textread('alllbp04-09Pri_70K.txt','%s');% 王倩JASTP论文中分类用的04-09的数据
labeled = textread('Alllabel2003_38044.txt','%s');% 2009年标记的03年过冬数据，38044幅图像
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

                