clear all;


labelListPath = '../train_test_split_20150901';

lbpPath = '../LBP_R2P8Basic';
distancePath = '../distance';
if ~exist(distancePath, 'dir')
    mkdir(distancePath);
end

nRows = 1;  % block of the LBP map
nCols = 1;

minTrainDays = 7;
dayNums = 19;

tic
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
    
    for j=1:1 %size(trainList,1)
        trainFileName = trainList(j).name;
        train = textread([labelListPath '/' trainFileName],'%s');
        train = reshape(train, 2, length(train)/2);
        train = train';
        
        for k=1:size(testList,1)
            testFileName = testList(k).name;
            test = textread([labelListPath '/' testFileName],'%s');
            test = reshape(test, 2, length(test)/2);
            test = test';
            
            lenTrain = length(trainFileName);
            lenTest  = length(testFileName);
            str = sprintf('_LBP_Basic_R%dC%d.mat', nRows, nCols);
            distanceFileName = [trainFileName(1:lenTrain-4) '_' testFileName(1:lenTest-4) str];
            
            distance = calcDistanceLBP(lbpPath, train, test, nRows, nCols);
            
            save([distancePath '/' distanceFileName], 'distance');
        end            
    end
end
toc
      
