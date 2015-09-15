clear all;

R = 2;      % radius of LBP
P = 8;      % samples of LBP 
rows = 3;   % block of the LBP map
cols = 6;

lbpPath = sprintf('../LBP_R%dP%d', R, P);

labeled = textread('Alllabel2003_38044.txt','%s');% 2009���ǵ�03�����ݣ�38044��ͼ��
labeled = reshape(labeled, 2, length(labeled)/2);
labeled = labeled';

n = size(labeled,1);

% load all the histograms
lbpFileName = [lbpPath '/' cell2mat(labeled(1,1)) '.mat'];
load(lbpFileName);
Hist  = zeros(n, length(lbpHist_1x1_Basic));

disp('Load histograms...');
tic
for i=1:n
    lbpFileName = [lbpPath '/' cell2mat(labeled(i,1)) '.mat'];
%     save(lbpFileName, 'lbpHist_1x1_Basic','lbpHist_3x6_Basic',...
%     'lbpHist_1x1_U2','lbpHist_3x6_U2',...
%     'lbpHist_1x1_RI','lbpHist_3x6_RI', ...
%     'lbpHist_1x1_RIU2','lbpHist_3x6_RIU2');
    load(lbpFileName);
    
    Hist(i,:)  = lbpHist_1x1_Basic;
end
toc

disp('Calculating distances...');
tic
distance  = zeros(n, n);
for i=1:n
    i
    tic
    parfor j=i+1:n
        distance(i,j)     = kai2distance(Hist(i,:), Hist(j,:));
    end
    toc
end
distance  = distance + distance';
toc

disp('Saving...');
distancePath = '../distance';
if ~exist(distancePath, 'dir')
    mkdir(distancePath);
end
save([distancePath '/LBP_Dist_1x1_Basic.mat'],  'distance', '-v7.3');
