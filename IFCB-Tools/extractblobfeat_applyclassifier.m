%% Extacting Blobs and Features and Applying a Classifier
%  Alexis D. Fischer, NOAA NWFSC, August 2021
clear;

%%%% modify according to dataset
%ifcbdir='D:\Shimada\'; 
ifcbdir='D:\BuddInlet\'; 
%ifcbdir='D:\SCW\'; 

%summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
addpath(genpath(summarydir));

classifier = 'D:\Shimada\classifier\summary\Trees_17Jan2022_BI';
%addpath(genpath(classifier));

addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\'));
%remove_empty_blob_folders([ifcbdir 'blobs\2021\'])

%% Step 1: Sort data into folders
addpath(genpath([ifcbdir 'raw\']));
sort_data_into_folders([ifcbdir 'raw\'],[ifcbdir 'data\2021\']);

% Step 2: Extract blobs
addpath(genpath([ifcbdir 'data\2021\']));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\'));
start_blob_batch_user_training([ifcbdir 'data\2021\'],[ifcbdir 'blobs\2021\'],true);

% Step 3: Extract features
addpath(genpath([ifcbdir 'blobs\2021\']));
addpath(genpath([ifcbdir 'data\2021\']));
start_feature_batch_user_training([ifcbdir 'data\2021\'],[ifcbdir 'blobs\2021\'],[ifcbdir 'features\2021\'],true)

%% Step 4: Apply classifier
addpath(genpath([ifcbdir 'features\2021\']));
start_classify_batch_user_training(classifier,[ifcbdir 'features\2021\'],[ifcbdir 'class\class2021_v1\']);

% Step 5: Summarize results

%summarize_cells_from_manual([ifcbdir 'manual\'],[ifcbdir 'data\'],[summarydir 'manual\']); 

%   summarize_biovol_eqdiam_from_manual([ifcbdir 'manual\'],[summarydir 'manual\'],...
%       [ifcbdir 'data\'],[ifcbdir 'features\2019\'],'2019',1/3.4)
  
% Step 6: Summarize classifier results for biovolume and cells
classpath_generic = [ifcbdir 'class\classxxxx_v1\'];
feapath_generic = [ifcbdir 'features\xxxx\']; %Put in your featurepath byyear
roibasepath_generic = [ifcbdir 'data\xxxx\']; %location of raw data
sumdir=[summarydir 'class\'];
yrrange = 2021;
adhocthresh = 0.5;

summarize_biovol_from_classifier(sumdir,classpath_generic,feapath_generic,roibasepath_generic,adhocthresh,yrrange)

summarize_cells_from_classifier(classpath_generic,[ifcbdir 'data\'],sumdir,yrrange); %you will need to do this separately for each year of data

%% Adjust annotations with added class
start_mc_adjust_classes_user_training('D:\Shimada\config\class2use_10','D:\BuddInlet\manual\')
