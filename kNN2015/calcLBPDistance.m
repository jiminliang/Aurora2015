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
Hist_1x1_Basic  = zeros(n, length(lbpHist_1x1_Basic));
Hist_1x1_U2     = zeros(n, length(lbpHist_1x1_U2));
Hist_1x1_RI     = zeros(n, length(lbpHist_1x1_RI));
Hist_1x1_RIU2   = zeros(n, length(lbpHist_1x1_RIU2));
Hist_3x6_Basic  = zeros(n, length(lbpHist_3x6_Basic));
Hist_3x6_U2     = zeros(n, length(lbpHist_3x6_U2));
Hist_3x6_RI     = zeros(n, length(lbpHist_3x6_RI));
Hist_3x6_RIU2   = zeros(n, length(lbpHist_3x6_RIU2));

disp('Load histograms...');
tic
for i=1:n
    lbpFileName = [lbpPath '/' cell2mat(labeled(i,1)) '.mat'];
%     save(lbpFileName, 'lbpHist_1x1_Basic','lbpHist_3x6_Basic',...
%     'lbpHist_1x1_U2','lbpHist_3x6_U2',...
%     'lbpHist_1x1_RI','lbpHist_3x6_RI', ...
%     'lbpHist_1x1_RIU2','lbpHist_3x6_RIU2');
    load(lbpFileName);
    
    Hist_1x1_Basic(i,:)  = lbpHist_1x1_Basic;
    Hist_1x1_U2(i,:)     = lbpHist_1x1_U2;
    Hist_1x1_RI(i,:)     = lbpHist_1x1_RI;
    Hist_1x1_RIU2(i,:)   = lbpHist_1x1_RIU2;
    Hist_3x6_Basic(i,:)  = lbpHist_3x6_Basic';
    Hist_3x6_U2(i,:)     = lbpHist_3x6_U2';
    Hist_3x6_RI(i,:)     = lbpHist_3x6_RI';
    Hist_3x6_RIU2(i,:)   = lbpHist_3x6_RIU2';
end
toc

disp('Calculating distances...');
tic
Dist_1x1_Basic  = zeros(n, n);
Dist_1x1_U2     = zeros(n, n);
Dist_1x1_RI     = zeros(n, n);
Dist_1x1_RIU2   = zeros(n, n);
Dist_3x6_Basic  = zeros(n, n);
Dist_3x6_U2     = zeros(n, n);
Dist_3x6_RI     = zeros(n, n);
Dist_3x6_RIU2   = zeros(n, n);
for i=1:n
    i
    tic
    parfor j=i+1:n
        Dist_1x1_Basic(i,j)     = kai2distance(Hist_1x1_Basic(i,:), Hist_1x1_Basic(j,:));
        Dist_1x1_U2(i,j)        = kai2distance(Hist_1x1_U2(i,:),    Hist_1x1_U2(j,:));
        Dist_1x1_RI(i,j)        = kai2distance(Hist_1x1_RI(i,:),    Hist_1x1_RI(j,:));
        Dist_1x1_RIU2(i,j)      = kai2distance(Hist_1x1_RIU2(i,:),  Hist_1x1_RIU2(j,:));
        Dist_3x6_Basic(i,j)     = kai2distance(Hist_3x6_Basic(i,:), Hist_3x6_Basic(j,:));
        Dist_3x6_U2(i,j)        = kai2distance(Hist_3x6_U2(i,:),    Hist_3x6_U2(j,:));
        Dist_3x6_RI(i,j)        = kai2distance(Hist_3x6_RI(i,:),    Hist_3x6_RI(j,:));
        Dist_3x6_RIU2(i,j)      = kai2distance(Hist_3x6_RIU2(i,:),  Hist_3x6_RIU2(j,:));
    end
    toc
end
Dist_1x1_Basic  = Dist_1x1_Basic + Dist_1x1_Basic';
Dist_1x1_U2     = Dist_1x1_U2 + Dist_1x1_U2';
Dist_1x1_RI     = Dist_1x1_RI + Dist_1x1_RI';
Dist_1x1_RIU2   = Dist_1x1_RIU2 + Dist_1x1_RIU2';
Dist_3x6_Basic  = Dist_3x6_Basic + Dist_3x6_Basic';
Dist_3x6_U2     = Dist_3x6_U2 + Dist_3x6_U2';
Dist_3x6_RI     = Dist_3x6_RI + Dist_3x6_RI';
Dist_3x6_RIU2   = Dist_3x6_RIU2 + Dist_3x6_RIU2';
toc

disp('Saving...');
distancePath = '../distance';
if ~exist(distancePath, 'dir')
    mkdir(distancePath);
end
tic
save([distancePath '/LBP_Dist_1x1_Basic.mat'],  'Dist_1x1_Basic');
save([distancePath '/LBP_Dist_1x1_U2.mat'],     'Dist_1x1_U2');
save([distancePath '/LBP_Dist_1x1_RI.mat'],     'Dist_1x1_RI');
save([distancePath '/LBP_Dist_1x1_RIU2.mat'],   'Dist_1x1_RIU2');
save([distancePath '/LBP_Dist_3x6_Basic.mat'],  'Dist_3x6_Basic');
save([distancePath '/LBP_Dist_3x6_U2.mat'],     'Dist_3x6_U2');
save([distancePath '/LBP_Dist_3x6_RI.mat'],     'Dist_3x6_RI');
save([distancePath '/LBP_Dist_3x6_RIU2.mat'],   'Dist_3x6_RIU2');
toc