%% Training and Making a classifier
%  Alexis D. Fischer, NOAA, August 2021
clear
filepath='C:\Users\ifcbuser\Documents\';

addpath(genpath(filepath));

load([filepath 'GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\TopClasses'],'class'); 
load([filepath 'GitHub\bloom-baby-bloom\IFCB-Tools\PNW2SCWclassconversion'],'PNWclass2use','SCWconversion','SCWclass2use');

[class2use,class2skip] = convert_class_PNW2SCW(class,PNWclass2use,SCWclass2use,SCWconversion);
clearvars PNWclass2use SCWconversion class;

%% Step 1: Compile features for the training set
manualpath = 'D:\SCW\manual\'; % manual annotation file location
feapath_base = 'D:\SCW\features\'; %feature file location, assumes \yyyy\ organization
maxn = 5000; %maximum number of images per class to include
minn = 500; %minimum number for inclusion

compile_train_features_user_training(manualpath,feapath_base,maxn,minn,class2skip);
addpath(genpath('D:\Shimada\manual\summary\')); % add new data to search path

% Step 2: Train (make) the classifier
result_path = 'D:\Shimada\manual\summary\'; %USER location of training file and classifier output
train_filename = 'UserExample_Train_25Aug2021'; %USER what file contains your training features
result_str = 'UserExample_Trees_';
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications

make_TreeBaggerClassifier_user_training(result_path, train_filename, result_str, nTrees)

%% If want to remake figures related to classifier output
classifier_oob_analysis('F:\IFCB104\manual\summary\UserExample_Trees_27Aug2019',...
    'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\Figs\');

%% Find the volume sampled in milliliters for >1 IFCB files
%examples
myfiles = { 'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141118T234705_IFCB102.hdr';...
    'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141106T132705_IFCB102.hdr' }
ml = IFCB_volume_analyzed( myfiles )

%% Extract the date and time from a sample file name and convert it to
% MATLAB serial date numbers (for convenient plotting, for instance)

myfiles = { 'D20141118T234705_IFCB102'; 'D20141106T132705_IFCB102' }
IFCB_file2date( myfiles )
