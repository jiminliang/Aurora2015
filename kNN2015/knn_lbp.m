clear all
close all

K=3;                % K value for kNN classifier
nRows = 1;          % block of the LBP map, 1x1 or 3x6
nCols = 1;

labelListPath = '../train_test_split_20150913';
distancePath = '../distance';
distanceFileName = [distancePath '/LBP_Dist_1x1_Basic.mat'];
knnClassificationResult = 'LBP_KNN_1x1_Basic.mat';

load(distanceFileName);

minTrainDays = 7;
dayNums = 19;

tic
accuracyAll_mean = zeros(dayNums-minTrainDays, 4);
accuracyAll_std = zeros(dayNums-minTrainDays, 4);
rejectAll = zeros(dayNums-minTrainDays,1);
for i = minTrainDays:dayNums - 1
    trainFilePre = sprintf('train_%d_%d', i, dayNums-i);
    testFilePre = sprintf('test_%d_%d', i, dayNums-i);
    
    trainList = dir([labelListPath '/' trainFilePre '*.txt']);
    if isempty(trainList)
        break;
    end

    testList = dir([labelListPath '/' testFilePre '*.txt']);
    if isempty(testList)
        break;
    end
    
    accuracy = [];
    reject = [];
    for j=1:size(trainList,1)
        trainFileName = trainList(j).name;
        [trainIndex, trainName, trainLabel] = textread([labelListPath '/' trainFileName],'%d %s %d');
        trainNum = length(trainIndex);
        
        for k=1:size(testList,1)
            testFileName = testList(k).name;
            [testIndex, testName, testLabel] = textread([labelListPath '/' testFileName],'%d %s %d');
            testNum = length(testIndex);
            
            distanceTT = distance(trainIndex, testIndex);

            confuseM = zeros(4,4);
            
            [minD, index] = sort(distanceTT);
            toplabels = trainLabel(index(1:K,:));
            n = hist(toplabels,4);
            [row,col] = find(n>=ceil(K/2));
            acceptNum = length(row);
            
            reject_index = setdiff([1:testNum],col);
            reject_index38044(k) = {testIndex(reject_index)};
            
            for x=1:acceptNum
                testI  = testLabel(col(x));
                trainI = row(x);
                confuseM(testI, trainI) = confuseM(testI, trainI) + 1;
            end
        end  % for test   
        
        accuracy = [accuracy; diag(confuseM)'./sum(confuseM')];
        reject = [reject; 1-acceptNum/testNum];
    end % for train
    
    accuracyAll_mean(i-minTrainDays+1,:) = mean(accuracy)
    accuracyAll_std (i-minTrainDays+1,:) = std(accuracy);
    rejectAll(i-minTrainDays+1) = mean(reject);
end

meanAccuracy = mean(accuracyAll_mean');
figure; plot([minTrainDays:dayNums-1], meanAccuracy);

save(knnClassificationResult, 'accuracyAll_mean', 'accuracyAll_std', 'rejectAll');
toc
  
