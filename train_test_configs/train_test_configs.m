% ���ɼ���ѵ����������������ļ�
% ���ɵ�ѵ�������ļ���Ϊ��train_n_m_k_x.txt
% ���У�n��ǰn��ѵ��
%      m����m�����
%      k����k��ʵ������
%      x��ÿ������������ȡΪ�������������ٵ�һ������
% ���ɵĲ��������ļ���Ϊ��test_n_m.txt
% 
% Created by Jimin, 2015-09-01
%
% Modified by Jimin, 2015-09-13
% The index of the training and testing sample in the original label list
% are also saved, as the the first column. 
% Because the distance matrix between all the 38044 samples are calcuated.
% It is more convinent to use the index other than filename to extract the
% distance values.

clear all

load stats_38044.mat; % dayslist, types

dayNums = size(dayslist, 1);
typeNums = size(types,2);

sampleNums = zeros(dayNums, typeNums);
sampleNums(1,:) = types(1,:);
for i=2:size(sampleNums,1)
    sampleNums(i,:) = sum(types(1:i,:));
end

[types sampleNums]
minTrainDays = 7;

[samples, labels] = textread('Alllabel2003_38044.txt','%s %d');% 2009���ǵ�03��������ݣ�38044��ͼ��
[samples, index] = sort(samples); % in case the file list is not sorted
labels = labels(index);

totalNum = size(samples,1);
for i = minTrainDays:dayNums-1
    trainDays = dayslist(1:i,:);
    trainNums = sampleNums(i,:);
    [minClassNum, minNumType] = min(trainNums);
    totalTrainNum = sum(trainNums);
    
    % find the train and test samples
    sampleTrain = samples(1:totalTrainNum);
    sampleTrainLabels = labels(1:totalTrainNum);

    sampleTest = samples(totalTrainNum+1:totalNum);
    sampleTestLabels = labels(totalTrainNum+1:totalNum);

    %[sampleTrainLabels,index] = sort(cell2mat(sampleTrainLabels));
    %sampleTrain = sampleTrain(index);
    
    sampleTrainSet = cell(1,typeNums);
    sampleTrainSetIndex = cell(1,typeNums);
    for t=1:typeNums
        index = find(sampleTrainLabels == t);
        sampleTrainSet{t} = sampleTrain(index);
        sampleTrainSetIndex{t} = index;
    end
    
    for j=1:10
        filenameTrain = sprintf('./train_test_split/train_%d_%d_%d_%d.txt', i, dayNums-i, j, minClassNum);
        fTrain = fopen(filenameTrain,'wt');
                
        %generate training list
        for t=1:typeNums
            Ns = length(sampleTrainSet{t});
            selNs = randperm(Ns, minClassNum);
            selNs = sort(selNs);
            for k=1:length(selNs)
                fprintf(fTrain, '%d    %s    %d\n', sampleTrainSetIndex{t}(selNs(k)), cell2mat(sampleTrainSet{t}(selNs(k))), t);
            end
        end
        
        fclose(fTrain);
    end
    
    filenameTest = sprintf('./train_test_split/test_%d_%d.txt', i, dayNums-i);
    fTest  = fopen(filenameTest, 'wt');
    for k = 1:length(sampleTest)
        fprintf(fTest, '%d    %s    %d\n', k+totalTrainNum, cell2mat(sampleTest(k)), sampleTestLabels(k));
    end
    fclose(fTest);
end

                