clear all;
clc;

imgPath = '../labeled2003_38044';
imgType = 'bmp';

R = 2;  % radius of LBP
P = 8;  % samples of LBP
mapping=getmapping(8,'riu2'); % uniform rotation-invariant LBP
bins = mapping.num;
lbpPath = sprintf('../LBP_R%dP%dRIU2', R, P); 
if ~exist(lbpPath, 'dir')
    mkdir(lbpPath);
end

labeled = textread('Alllabel2003_38044.txt','%s');% 2009年标记的03年过冬数据，38044幅图像
labeled = reshape(labeled, 2, length(labeled)/2);
labeled = labeled';

n = size(labeled,1);
for i=1:n   % for train
    img = imread([imgPath '/' cell2mat(labeled(i,1)) '.' imgType]);
    lbpMap = lbp(img, R, P, mapping, 0);   
    
    lbpFileName = [lbpPath '/' cell2mat(labeled(i,1)) '.mat'];
    save(lbpFileName, 'lbpMap', 'bins');
end