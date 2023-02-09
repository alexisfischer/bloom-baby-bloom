%% Training and Making a classifier
%   Alexis D. Fischer, NOAA NWFSC, December 2022
clear;
filepath='C:\Users\ifcbuser\Documents\GitHub\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
addpath(genpath(filepath));
class2useName ='D:\general\config\class2use_13';

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
% Regional CCS classifier
load([filepath 'bloom-baby-bloom\NOAA\SeascapesProject\Data\seascape_topclasses'],'SS');
[class2skip] = find_class2skip(class2useName,SS(end).topclasses);
class2skip(end+1)={'Bacteriastrum'};
class2skip(end+1)={'Thalassiosira_single'};
class2skip(end+1)={'Heterosigma'};
class2skip(end+1)={'pennate'};
class2skip(end+1)={'nanoplankton'};
class2skip(end+1)={'cryptophyta'};
class2skip(end+1)={'Pseudo-nitzschia'};
class2skip(end+1)={'Dinophysis'};
%class2skip(end+1)={'Amylax'};

% Shimada classifier
%load([filepath 'bloom-baby-bloom\IFCB-Data\Shimada\manual\TopClasses'],'class2use');
%[class2skip] = find_class2skip(class2useName,class2use);

%load([filepath 'bloom-baby-bloom\NOAA\SeascapesProject\Data\topclasses_bylatitude_CCS'],'classBC');
%[class2skip] = find_class2skip(class2useName,classBC);

% %% Budd Inlet
% load([filepath 'bloom-baby-bloom\IFCB-Data\BuddInlet\manual\TopClasses'],'class2use');
% TopClass=class2use;
% %class2use(ismember(class2use,'Dinophysis'))=[]; %removing bulk Dinophysis class for special BI classifier
% 
% %TopClassName=[filepath 'bloom-baby-bloom\IFCB-Data\Shimada\manual\TopClasses'];
% [class2skip] = find_class2skip(class2useName,TopClass);
% 
% clearvars manualpath id

% Step 2: Compile features for the training set
addpath(genpath('D:\general\classifier\'));
addpath(genpath('C:\Users\ifcbuser\Documents\'));

manualpath = 'D:\general\classifier\manual_merged_ungrouped\'; % manual annotation file location
feapath_base = 'D:\general\classifier\features_merged_ungrouped\'; %feature file location, assumes \yyyy\ organization
outpath = 'D:\general\classifier\summary\'; % location to save training set
maxn = 5000; %maximum number of images per class to include
minn = 500; %minimum number for inclusion
class2group={{'Pseudo_nitzschia_small_1cell' 'Pseudo_nitzschia_large_1cell'}...
        {'Pseudo_nitzschia_small_2cell' 'Pseudo_nitzschia_large_2cell'}...
        {'Pseudo_nitzschia_small_3cell' 'Pseudo_nitzschia_large_3cell'}...
        {'Pseudo_nitzschia_small_4cell' 'Pseudo_nitzschia_large_4cell'}...
        {'Pseudo_nitzschia_small_5cell' 'Pseudo_nitzschia_large_5cell'}...
        {'Pseudo_nitzschia_small_6cell' 'Pseudo_nitzschia_large_6cell'}...
        {'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata' 'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' 'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'}...
        {'Chaetoceros_chain' 'Chaetoceros_single'}...
        {'Cerataulina' 'Dactyliosolen' 'Detonula' 'Guinardia'}};        
    
%        {'Rhizosolenia' 'Proboscia'}...                   
%        {'Stephanopyxis' 'Melosira'}...      
%        {'Gymnodinium' 'Heterocapsa_triquetra' 'Scrippsiella'}...
%        {'Dactyliosolen' 'Guinardia'}};
%        {'Cerataulina' 'Detonula' 'Lauderia'}... 
%        {'Cylindrotheca' 'Nitzschia'}...

group=[]; %[]; %'NOAA-OSU'; %'OSU'; 
classifiername=['CCS_' group 'v4']; 

compile_train_features_NWFSC(manualpath,feapath_base,outpath,maxn,minn,classifiername,class2useName,class2skip,class2group,group);
addpath(genpath(outpath)); % add new data to search path

% Step 3: Train (make) the classifier
result_path = 'D:\general\classifier\summary\'; %USER location of training file and classifier output
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications
make_TreeBaggerClassifier(result_path, classifiername, nTrees)

determine_classifier_performance([result_path 'Trees_' classifiername],[summarydir 'class\']);

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
