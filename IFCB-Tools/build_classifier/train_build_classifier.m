%% Training and Making a classifier
%   Alexis D. Fischer, NOAA NWFSC, September 2021
clear;
filepath='C:\Users\ifcbuser\Documents\';
addpath(genpath(filepath));
class2useName ='D:\general\config\class2use_12';

%% Step 1: create SCW and Shimada merged manual and feature file folders to pull from for training set
mergedpath = 'D:\general\classifier\';
UCSCpath = 'D:\SCW\';
OSUpath = 'D:\OSU\';
SHMDApath = 'D:\Shimada\';
LABpath = 'D:\LabData\';
BUDDpath = 'D:\BuddInlet\';

%update classlist to latest
start_mc_adjust_classes_user_training(class2useName,[LABpath 'manual\']);
%start_mc_adjust_classes_user_training(class2useName,[SHMDApath 'manual\'])
%start_mc_adjust_classes_user_training(class2useName,[BUDDpath 'manual\']);

merge_manual_feafiles_SHMDA_UCSC_OSU_LAB_BUDD(class2useName,mergedpath,UCSCpath,OSUpath,SHMDApath,LABpath,BUDDpath)
clearvars  mergedpath UCSCpath SHMDApath LABpath BUDDpath OSUpath;

%% Step 2: select classes of interest and find class2skip
% Shimada classifier
load([filepath 'GitHub\bloom-baby-bloom\NOAA\Shimada\Data\topclasses_bylatitude_CCS'],'classBC');
TopClass=classBC;
TopClass=[TopClass;{'Dinophysis_acuminata';'Dinophysis_acuta';'Dinophysis_caudata';...
        'Dinophysis_fortii'; 'Dinophysis_norvegica'; 'Dinophysis_odiosa'; ...
        'Dinophysis_parva'; 'Dinophysis_rotundata'; 'Dinophysis_tripos';...
        'Pseudo-nitzschia_large_narrow';'Pseudo-nitzschia_large_wide';'Pseudo-nitzschia_small'}];

%TopClassName=[filepath 'GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\TopClasses'];
[class2skip] = find_class2skip(class2useName,TopClass);

clearvars manualpath id

%% Step 2: Compile features for the training set
addpath(genpath('D:\general\classifier\'));
addpath(genpath('C:\Users\ifcbuser\Documents\'));

manualpath = 'D:\general\classifier\manual_merged\'; % manual annotation file location
feapath_base = 'D:\general\classifier\features_merged\'; %feature file location, assumes \yyyy\ organization
outpath = 'D:\general\classifier\summary\'; % location to save training set
maxn = 6000; %maximum number of images per class to include
minn = 1000; %minimum number for inclusion
class2group={{'Dinophysis' 'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata'...
        'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' ...
        'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'}...
        {'Pseudo-nitzschia' 'Pseudo-nitzschia_large_narrow' ...
        'Pseudo-nitzschia_large_wide' 'Pseudo-nitzschia_small'}...
        {'Thalassiosira_chain' 'Thalassiosira_single'}...
        {'Chaetoceros_chain' 'Chaetoceros_single'}};
%IFCB='UCSC';
IFCB=[];

compile_train_features_NWFSC(manualpath,feapath_base,outpath,maxn,minn,class2useName,class2skip,class2group,IFCB);
addpath(genpath(outpath)); % add new data to search path

% Step 3: Train (make) the classifier
result_path = 'D:\general\classifier\summary\'; %USER location of training file and classifier output
train_filename = 'Train_29Sep2022'; %USER what file contains your training features
result_filename = 'Trees_29Sep2022';
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications
make_TreeBaggerClassifier(result_path, train_filename, result_filename, nTrees)

determine_classifier_performance([result_path result_filename],'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\');

%plot_classifier_performance

%% Find the volume sampled in milliliters for >1 IFCB files
%examples
myfiles = { 'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141118T234705_IFCB102.hdr';...
    'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141106T132705_IFCB102.hdr' }
ml = IFCB_volume_analyzed( myfiles )

%% Extract the date and time from a sample file name and convert it to
% MATLAB serial date numbers (for convenient plotting, for instance)

myfiles = { 'D20141118T234705_IFCB102'; 'D20141106T132705_IFCB102' }
IFCB_file2date( myfiles )