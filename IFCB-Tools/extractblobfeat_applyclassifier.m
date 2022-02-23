%% Extacting Blobs and Features and Applying a Classifier
%  Alexis D. Fischer, NOAA NWFSC, August 2021
clear;

%%%% modify according to dataset
%ifcbdir='D:\Shimada\'; 
ifcbdir='D:\BuddInlet\'; 
%ifcbdir='D:\SCW\'; 
%ifcbdir='D:\Shimada\LabData\'; 

%summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
%summarydir=[ifcbdir 'summary\'];

yr='2021';

addpath(genpath(summarydir));
addpath(genpath(ifcbdir));
addpath(genpath([ifcbdir 'data\']));
addpath(genpath([ifcbdir 'blobs\']));
addpath(genpath([ifcbdir 'features\']));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\'));

classifier='D:\Shimada\classifier\summary\Trees_16Feb2022_nocentric_ungrouped_PN';

%%
sort_data_into_folders([ifcbdir 'raw\'],[ifcbdir 'data\' yr '\']);

% Step 2: Extract blobs
start_blob_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],false);

% Step 3: Extract features
start_feature_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],[ifcbdir 'features\' yr '\'],false)

%% Step 4: Apply classifier
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\class' yr '_v1\']);

%% Step 5: Summaries
classpath_generic = [ifcbdir 'class\classxxxx_v1\'];
feapath_generic = [ifcbdir 'features\xxxx\']; %Put in your featurepath byyear
roibasepath_generic = [ifcbdir 'data\xxxx\']; %location of raw data
manualpath=[ifcbdir 'manual\'];
adhocthresh = 0.9;

% class
summarize_biovol_from_classifier([summarydir 'class\'],classpath_generic,...
    feapath_generic,roibasepath_generic,adhocthresh,str2double(yr));

%% manual results
summarize_cells_from_manual(manualpath,[ifcbdir 'data\'],[summarydir 'manual\'],yr); 

summarize_biovol_eqdiam_from_manual(manualpath,summarydir,...
    [ifcbdir 'data\'],[ifcbdir 'features\' yr '\'],yr,1/3.4)

%% Adjust annotations with added class
start_mc_adjust_classes_user_training('D:\Shimada\config\class2use_11','D:\Shimada\LabData\manual\')
