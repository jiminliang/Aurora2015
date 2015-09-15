function distance = calcDistanceLBP(lbpPath, train, test, rows, cols)
% Calculate the distance between train and test samples using LBP feature.

m = size(train,1);
n  = size(test,1);

load([lbpPath '/' cell2mat(train(1,1))]);   %lbpMap, bins
bN = bins;
sm = size(lbpMap,1);
sn = size(lbpMap,2);
subrow=ceil(sm/rows); 
subcol=ceil(sn/cols);
blocksize = [subrow, subcol];

trainHists = zeros(rows*cols*bN, m);
testHists  = zeros(rows*cols*bN, n);

disp('Load training data');
tic
for i=1:m   % read all the train
    load([lbpPath '/' cell2mat(train(i,1))]);
    
    trainPatch = im2col(lbpMap, blocksize, 'distinct');

    trainHist = zeros(bN,rows*cols);
    for p=1:size(trainPatch,2)
        trainHist(:,p) = hist(trainPatch(:,p), 0:bN-1);
    end
    
    trainHists(:,i) = trainHist(:);
end
toc

disp('Load testing data');
tic
for j=1:n   % read all the test
    load([lbpPath '/' cell2mat(test(j,1))]);
    
    testPatch = im2col(lbpMap, blocksize, 'distinct');
    
    testHist = zeros(bN,rows*cols);
    for p=1:size(testPatch,2)
        testHist(:,p) = hist(testPatch(:,p), 0:bN-1);
    end
    
    testHists(:,j) = testHist(:);
end
toc

tic
distance = zeros(m, n);
for i=1:m   % for train
    i

    for j=1:n  % for test
        distance(i,j) = kai2distance(trainHists(:,i), testHists(:,j));
    end % of test
end % of train
toc

function d = kai2distance(h1, h2)
d = sum((h1-h2).^2./(h1+h2 + 1e-12));
