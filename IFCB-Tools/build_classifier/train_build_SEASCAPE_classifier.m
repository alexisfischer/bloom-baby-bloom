%% Training and Making a Seascape classifier
%   Alexis D. Fischer, NOAA NWFSC, December 2022
clear;
filepath='C:\Users\ifcbuser\Documents\';
addpath(genpath(filepath));
addpath(genpath('D:\general\classifier\'));

class2useName ='D:\general\config\class2use_12';

%% Step 1: find topclasses for each seascape


%% Step 2: find class2skip

%load([filepath 'GitHub\bloom-baby-bloom\NOAA\Shimada\Data\topclasses_bylatitude_CCS'],'classBC');
[class2skip] = find_class2skip(class2useName,TopClass);


%% Step 3: compile features for the training set

manualpath = 'D:\general\classifier\manual_merged\'; % manual annotation file location
feapath_base = 'D:\general\classifier\features_merged\'; %feature file location, assumes \yyyy\ organization
outpath = 'D:\general\classifier\summary\'; % location to save training set
maxn = 5000; %maximum number of images per class to include
minn = 1000; %minimum number for inclusion
class2group={{'Pseudo-nitzschia' 'Pseudo-nitzschia_large_narrow' ...
        'Pseudo-nitzschia_large_wide' 'Pseudo-nitzschia_small'}...
        {'Chaetoceros_chain' 'Chaetoceros_single'}};        
IFCB=[]; 

classifiername='test'; 

compile_train_features_NWFSC(manualpath,feapath_base,outpath,maxn,minn,classifiername,class2useName,class2skip,class2group,IFCB);
addpath(genpath(outpath)); % add new data to search path

%% Step 4: Train (make) the classifier
result_path = 'D:\general\classifier\summary\'; %USER location of training file and classifier output
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications
make_TreeBaggerClassifier(result_path, classifiername, nTrees)

determine_classifier_performance([result_path 'Trees_' classifiername],'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\class\');
%determine_classifier_performance([result_path 'Trees_' classifiername],'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\');

