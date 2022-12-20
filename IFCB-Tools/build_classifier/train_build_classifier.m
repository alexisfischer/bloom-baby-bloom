%% Training and Making a classifier
%   Alexis D. Fischer, NOAA NWFSC, December 2022
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
%start_mc_adjust_classes_user_training(class2useName,[LABpath 'manual\']);
%start_mc_adjust_classes_user_training(class2useName,[SHMDApath 'manual\'])
%start_mc_adjust_classes_user_training(class2useName,[BUDDpath 'manual\']);

merge_manual_feafiles_SHMDA_UCSC_OSU_LAB_BUDD(class2useName,mergedpath,UCSCpath,OSUpath,SHMDApath,LABpath,BUDDpath)
clearvars  mergedpath UCSCpath SHMDApath LABpath BUDDpath OSUpath;

%% Step 2: select classes of interest and find class2skip
% Shimada classifier
load([filepath 'GitHub\bloom-baby-bloom\NOAA\SeascapesProject\Data\topclasses_bylatitude_CCS'],'classBC');
[class2skip] = find_class2skip(class2useName,classBC);
class2skip(end+1)={'Cerataulina'};
class2skip(end+1)={'Bacteriastrum'};

% %% Budd Inlet
% load([filepath 'GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\manual\TopClasses'],'class2use');
% TopClass=class2use;
% %class2use(ismember(class2use,'Dinophysis'))=[]; %removing bulk Dinophysis class for special BI classifier
% 
% %TopClassName=[filepath 'GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\TopClasses'];
% [class2skip] = find_class2skip(class2useName,TopClass);
% class2skip(end+1)={'Cerataulina'};
% class2skip(end+1)={'Nitzschia'};
% class2skip(end+1)={'Strombidium'};
% class2skip(end+1)={'Dinophysis'};
% 
% clearvars manualpath id

% Step 2: Compile features for the training set
addpath(genpath('D:\general\classifier\'));
addpath(genpath('C:\Users\ifcbuser\Documents\'));

manualpath = 'D:\general\classifier\manual_merged\'; % manual annotation file location
feapath_base = 'D:\general\classifier\features_merged\'; %feature file location, assumes \yyyy\ organization
outpath = 'D:\general\classifier\summary\'; % location to save training set
maxn = 500; %maximum number of images per class to include
minn = 10; %minimum number for inclusion
class2group={{'Pseudo-nitzschia' 'Pseudo-nitzschia_large_narrow' ...
        'Pseudo-nitzschia_large_wide' 'Pseudo-nitzschia_small'}...
        {'Chaetoceros_chain' 'Chaetoceros_single'}};        
%         {'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata'...
%         'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' ...
%         'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'}};  
%    {'Thalassiosira_chain' 'Thalassiosira_single'}

%IFCB='OSU';
IFCB=[]; 

%classifiername='BI_Dinophysis_GenusLevel_v4'; %separate Thalassiosira,
%classifiername='BI_Dinophysis_GenusLevel_v4'; %separate Thalassiosira, Chaetoceros, no UCSC Dinophysis
%classifiername='BI_Dinophysis_GenusLevel_v5'; %separate Thalassiosira, no UCSC Dinophysis
%classifiername='BI_Dinophysis_GenusLevel_v6'; %separate Thalassiosira, only NOAA images
classifiername='CCS_group-PN-Ch'; 
%classifiername='test'; 

compile_train_features_NWFSC(manualpath,feapath_base,outpath,maxn,minn,classifiername,class2useName,class2skip,class2group,IFCB);
addpath(genpath(outpath)); % add new data to search path

%% Step 3: Train (make) the classifier
result_path = 'D:\general\classifier\summary\'; %USER location of training file and classifier output
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications
make_TreeBaggerClassifier(result_path, classifiername, nTrees)

determine_classifier_performance([result_path 'Trees_' classifiername],'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\class\');
%determine_classifier_performance([result_path 'Trees_' classifiername],'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\');

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
