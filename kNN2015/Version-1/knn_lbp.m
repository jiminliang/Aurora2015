clear all
clc;

K=3;                % K value for kNN classifier
lbpType = 'Basic';  % Basic, U2, RI, U2RI
nRows = 1;          % block of the LBP map, 1x1 or 3x6
nCols = 1;

labelListPath = '../train_test_split_20150901';
distancePath = '../distance';

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
            str = sprintf('_LBP_%s_R%dC%d.mat', lbpType, nRows, nCols);
            distanceFileName = [trainFileName(1:lenTrain-4) '_' testFileName(1:lenTest-4) str];
            
            load([distancePath '/' distanceFileName]);
        end            
    end
end
toc
      

setindex=dir('tentestexperiment\train-test-set*.mat');

for j=10:10
    
   setname =setindex(j).name;
   load(['tentestexperiment\'  setname])
%    confuseM_ave = zeros(4,4);
   for jj=1:10
     testindex=testsets{jj};
     testlabel=label_8k(testindex);
     numTest=length(testindex);
     
     trainindex=trainsets{jj};
     trainlabel=label_8k(trainindex);
     
     distancenow=distance(trainindex,testindex);
     confuseM = zeros(4,4);

     [minD, index] = sort(distancenow);
     toplabels=trainlabel(index(1:K,:));
     n=hist(toplabels,4);
     [row,col]=find(n>=ceil(K/2));
     numTest_label=length(row);
     reject_index=setdiff([1:numTest],col);
     reject_indexin8k(jj)={testindex(reject_index)};
     for i=1: numTest_label
         testI  = testlabel(col(i));
         trainI = row(i);
         confuseM(testI, trainI) = confuseM(testI, trainI) + 1;
     end

%        disp('confuse matrix:');
%         confuseM_ave=confuseM+confuseM_ave;
%        disp('correct rate:');
         accuracy_knn(j,jj)=sum(diag(confuseM))/numTest_label;% a ratio per row
         reject(j,jj)=1-numTest_label/numTest;
%          reject(2,jj)=length(reject_index);
%      disp('correct rate for 2 classes:');
%      (sum(sum(confuseM(2:4,2:4)))+confuseM(1,1))/numTest
   end
end
accuracy_knn
accuracy_Knn_std=std(accuracy_knn')
accuracy_Knn_mena=mean(accuracy_knn')
reject

% confuseM_ave=confuseM_ave./10