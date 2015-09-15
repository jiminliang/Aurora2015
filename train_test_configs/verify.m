% 验证抽取样本的文件名与其类标是否与原始数据库中的一至

clear all;

sample = './train_test_split/test_7_12.txt'
sample = './train_test_split/test_8_11.txt'
% sample = './train_test_split/train_7_12_1_1080.txt'
sample = './train_test_split/train_7_12_10_1080.txt'
% sample = './train_test_split/train_11_8_7_1796.txt'
all = 'Alllabel2003_38044.txt'

[index_s names_s label_s] = textread(sample,'%d %s %d');
[names_a label_a] = textread(all,'%s %d');

error = 0;

for i = 1:length(index_s)
    name1 = cell2mat(names_s(i));
    name2 = cell2mat(names_a(index_s(i)));
    label1 = label_s(i);
    label2 = label_a(index_s(i));
    if (name1 == name2) & (label1 == label2)
        continue;
    else
        disp(['Error: '  name1]);
        error = error + 1;
    end
end

msg = sprintf('Verfication complete. Found %d errors!',error); 
disp(msg);