%% Extacting Blobs and Features and Applying a Classifier
%  Alexis D. Fischer, NOAA NWFSC, August 2021
clear;

%%%% modify according to dataset
ifcbdir='D:\Shimada\'; 
%ifcbdir='D:\BuddInlet\';
%ifcbdir='D:\LabData\'; 
%ifcbdir='D:\SCW\'; 
%ifcbdir='D:\general\classifier\'; 

summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
%summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
%summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\UCSC\SCW\';
%summarydir=[ifcbdir 'summary\'];

yr='2019';

addpath(genpath(summarydir));
addpath(genpath(ifcbdir));
addpath(genpath([ifcbdir 'data\']));
addpath(genpath([ifcbdir 'blobs\']));
addpath(genpath([ifcbdir 'features\']));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\'));

classifier='D:\general\classifier\summary\Trees_BI_Dinophysis_GenusLevel_v5';
%classifier='D:\general\classifier\summary\Trees_16Jun2022_regional1000';

%%
%copy_data_into_folders('C:\SFTP-BuddInlet\',[ifcbdir 'data\' yr '\']);
copy_data_into_folders([ifcbdir 'raw\'],[ifcbdir 'data\' yr '\']);

%% Step 2: Extract blobs
start_blob_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],true);

% Step 3: Extract features
start_feature_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],[ifcbdir 'features\' yr '\'],true)

%% Step 4: Apply classifier
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\class' yr '_v1\']);
yr='2021';
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\class' yr '_v1\']);

%% Step 5: Summaries
summarydir_base='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
summaryfolder='IFCB-Data\Shimada\class\';
classpath_generic = [ifcbdir 'class\classxxxx_v1\'];
feapath_generic = [ifcbdir 'features\xxxx\']; %Put in your featurepath byyear
roibasepath_generic = [ifcbdir 'data\xxxx\']; %location of raw data
manualpath=[ifcbdir 'manual\'];
adhocthresh = 0.5;

% summarize_biovol_from_classifier(summarydir_base,summaryfolder,classpath_generic,...
%   feapath_generic,roibasepath_generic,adhocthresh,2021:2022);

% manual results
% summarize_biovol_from_manual([ifcbdir 'manual\'],[summarydir 'manual\'],...
%     [ifcbdir 'data\'],[ifcbdir 'features\'],1/3.4)


summarize_cells_from_manual(manualpath,[ifcbdir 'data\'],[summarydir 'manual\']); 
%%
manualpath='D:\BuddInlet\manualEmilie\Labexperiments\testPMTsettingsDANY1\';
addpath(genpath(manualpath));
addpath(genpath([ifcbdir 'data\']));

summarize_cells_from_manual(manualpath,[ifcbdir 'data\'],'D:\BuddInlet\manualEmilie\');
