% read train and test data and conver to hdf5
% for the classifier we only need binary labels
clc
close all
clear
%addpath functions
%%

% get current directory
gcd1=pwd;

% get path to dataset
pathname=uigetdir('../imgs/');

% check if mat file exists
datasetfn=fullfile(pathname,'dataset.mat');

if ~exist(datasetfn,'file')
    disp([datasetfn,' does not exist!'])
else
    disp(['please wait while loading ', datasetfn])
    load(datasetfn,'Icat','Lcat');
end


% dividie into training and validation
total_num=size(Icat,4);
numoftrain=round(total_num*.7); 
numoftest=total_num-numoftrain; 
disp(['total: ', num2str(total_num), ' number of train: ', num2str(numoftrain),' number of test: ', num2str(numoftest)])

% pick random numbers for training dataset
train_ind=randperm(total_num,numoftrain);
temp=setxor(1:total_num,train_ind);
test_ind = temp(randperm(numel(temp)));                          
disp(['intersect of train and test: ', num2str(intersect(train_ind,test_ind))])
save([pathname,'/traintestind.mat'],'train_ind','test_ind');



% train data
trainData=Icat(:,:,:,train_ind);
Ltrain=Lcat(train_ind,1);

% test data
testData=Icat(:,:,:,test_ind);
Ltest=Lcat(test_ind,1);
    


% reshape labels to 4-D and permute
trainLabels=Ltrain;
testLabels=Ltest;

% save to mat file lmmdb
% full path to output mat file
pathname2='../matfiles';
trainfnlmdb=fullfile(pathname2,'traindata_lmdb.mat');
save(trainfnlmdb,'trainLabels','trainData','-v7.3');
disp(' mat files was saved for lmdb processing !');


testfnlmdb=fullfile(pathname2,'testdata_lmdb.mat');
save(testfnlmdb,'testLabels','testData','-v7.3');
disp(' mat files was saved for lmdb processing !');


n1=randi(size(trainData,4))
n1=n1+1
imshow(trainData(:,:,1,n1))
title(num2str(trainLabels(1,1,1,n1)))
