% Calculate LPB histogram of 1x1 and 3x6 subblocks for all the 38044 images
% Created 2015-09-11

clear all;

imgPath = '../labeled2003_38044';
imgType = 'bmp';

R = 2;      % radius of LBP
P = 8;      % samples of LBP 
rows = 3;   % block of the LBP map
cols = 6;

lbpPath = sprintf('../LBP_R%dP%d', R, P);
if ~exist(lbpPath, 'dir')
    mkdir(lbpPath);
end

labeled = textread('Alllabel2003_38044.txt','%s');% 2009年标记的03年过冬数据，38044幅图像
labeled = reshape(labeled, 2, length(labeled)/2);
labeled = labeled';

n = size(labeled,1);
for i=1:n 
    i
    
    img = imread([imgPath '/' cell2mat(labeled(i,1)) '.' imgType]);

    % ===============================
    % basic LBP, no mapping
    bins = 256;
    
    lbpHist_1x1_Basic = lbp(img, R, P);
    
    lbpMap = lbp(img, R, P, 0, 0);  
    sm = size(lbpMap,1);
    sn = size(lbpMap,2);
    subrow=ceil(sm/rows);
    subcol=ceil(sn/cols);
    blocksize = [subrow, subcol];

    patch = im2col(lbpMap, blocksize, 'distinct');
    hist_3x6_Basic = zeros(bins,rows*cols);
    for p=1:size(patch,2)
        hist_3x6_Basic(:,p) = hist(patch(:,p), 0:bins-1);
    end
    lbpHist_3x6_Basic = hist_3x6_Basic(:);

    % ===============================
    % uniform LBP
    mapping=getmapping(8,'u2'); 
    bins = mapping.num;

    lbpHist_1x1_U2 = lbp(img, R, P, mapping);

    lbpMap = lbp(img, R, P, mapping, 0);  
    sm = size(lbpMap,1);
    sn = size(lbpMap,2);
    subrow=ceil(sm/rows);
    subcol=ceil(sn/cols);
    blocksize = [subrow, subcol];

    patch = im2col(lbpMap, blocksize, 'distinct');
    hist_3x6_U2 = zeros(bins,rows*cols);
    for p=1:size(patch,2)
        hist_3x6_U2(:,p) = hist(patch(:,p), 0:bins-1);
    end
    lbpHist_3x6_U2 = hist_3x6_U2(:);  
    
    % ===============================
    % rotation invariant LBP
    mapping=getmapping(8,'ri'); 
    bins = mapping.num;

    lbpHist_1x1_RI = lbp(img, R, P, mapping);

    lbpMap = lbp(img, R, P, mapping, 0);  
    sm = size(lbpMap,1);
    sn = size(lbpMap,2);
    subrow=ceil(sm/rows);
    subcol=ceil(sn/cols);
    blocksize = [subrow, subcol];

    patch = im2col(lbpMap, blocksize, 'distinct');
    hist_3x6_RI = zeros(bins,rows*cols);
    for p=1:size(patch,2)
        hist_3x6_RI(:,p) = hist(patch(:,p), 0:bins-1);
    end
    lbpHist_3x6_RI = hist_3x6_RI(:); 
    
    % ===============================
    % rotation invariant LBP
    mapping=getmapping(8,'riu2'); 
    bins = mapping.num;

    lbpHist_1x1_RIU2 = lbp(img, R, P, mapping);

    lbpMap = lbp(img, R, P, mapping, 0);  
    sm = size(lbpMap,1);
    sn = size(lbpMap,2);
    subrow=ceil(sm/rows);
    subcol=ceil(sn/cols);
    blocksize = [subrow, subcol];

    patch = im2col(lbpMap, blocksize, 'distinct');
    hist_3x6_RIU2 = zeros(bins,rows*cols);
    for p=1:size(patch,2)
        hist_3x6_RIU2(:,p) = hist(patch(:,p), 0:bins-1);
    end
    lbpHist_3x6_RIU2 = hist_3x6_RIU2(:);     
    
    %=================================
    lbpFileName = [lbpPath '/' cell2mat(labeled(i,1)) '.mat'];
    save(lbpFileName, 'lbpHist_1x1_Basic','lbpHist_3x6_Basic',...
    'lbpHist_1x1_U2','lbpHist_3x6_U2',...
    'lbpHist_1x1_RI','lbpHist_3x6_RI', ...
    'lbpHist_1x1_RIU2','lbpHist_3x6_RIU2');
end