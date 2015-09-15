close all;
clear all;

results = {'LBP_KNN_1x1_Basic.mat','LBP_KNN_1x1_U2.mat', 'LBP_KNN_1x1_RI.mat', 'LBP_KNN_1x1_RIU2.mat', ...
    'LBP_KNN_3x6_Basic.mat','LBP_KNN_3x6_U2.mat', 'LBP_KNN_3x6_RI.mat', 'LBP_KNN_3x6_RIU2.mat'
    };
legends = {'1x1-Basic','1x1-U2', '1x1-RI', '1x1-RIU2', ...
    '3x6-Basic','3x6-U2', '3x6-RI', '3x6-RIU2'
    };
N = length(results);

accuracy = zeros(12, N);

for i=1:N
    load(cell2mat(results(i))); % save(knnClassificationResult, 'accuracyAll_mean', 'accuracyAll_std', 'rejectAll');
    
    accuracy(:,i) = mean(accuracyAll_mean');
end

figure;
x = 7:18;
plot(x, accuracy(:,1),'r-', ...
    x, accuracy(:,2), 'g-', ...
    x, accuracy(:,3), 'b-', ...
    x, accuracy(:,4), 'k-', ...
    x, accuracy(:,5), 'r--', ...
    x, accuracy(:,6), 'g--', ...
    x, accuracy(:,7), 'b--', ...
    x, accuracy(:,8), 'k--');

legend(cell2mat(legends(1)), cell2mat(legends(2)), cell2mat(legends(3)), cell2mat(legends(4)), ...
    cell2mat(legends(5)), cell2mat(legends(6)), cell2mat(legends(7)), cell2mat(legends(8)));

xlabel('Training days');
ylabel('Accuracy');

    

