%% Extacting Blobs and Features and Applying a Classifier
%  Alexis D. Fischer, University of California - Santa Cruz, April 2020
clear;

%%%% modify according to dataset
%ifcbdir='D:\Shimada\'; 
ifcbdir='D:\BuddInlet\'; 
%ifcbdir='D:\SCW\'; 

%summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
addpath(genpath(summarydir));

classifier = 'D:\SCW\manual\summary\UserExample_Trees_27Aug2019';
addpath(genpath(classifier));

addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\'));
%remove_empty_blob_folders([ifcbdir 'blobs\2021\'])
 
%% Step 1: Sort data into folders
addpath(genpath([ifcbdir 'raw\']));
sort_data_into_folders([ifcbdir 'raw\'],[ifcbdir 'data\2021\']);

%% Step 2: Extract blobs
addpath(genpath([ifcbdir 'data\2021\']));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\'));
start_blob_batch_user_training([ifcbdir 'data\2021\'],[ifcbdir 'blobs\2021\'],true)

%% Step 3: Extract features
addpath(genpath([ifcbdir 'blobs\2021\']));
addpath(genpath([ifcbdir 'data\2021\']));
start_feature_batch_user_training([ifcbdir 'data\2021\'],[ifcbdir 'blobs\2021\'],[ifcbdir 'features\2021\'],true)

%% Step 4: Apply classifier
addpath(genpath([ifcbdir 'features\2021\']));
start_classify_batch_user_training(classifier,[ifcbdir 'features\2021\'],[ifcbdir 'class\class2021_v1\']);
start_classify_batch_user_training(classifier,[ifcbdir 'features\2021\'],[ifcbdir 'class\class2021_v1\']);
start_classify_batch_user_training(classifier,[ifcbdir 'features\2021\'],[ifcbdir 'class\class2021_v1\']);
start_classify_batch_user_training(classifier,[ifcbdir 'features\2021\'],[ifcbdir 'class\class2021_v1\']);
start_classify_batch_user_training(classifier,[ifcbdir 'features\2021\'],[ifcbdir 'class\class2021_v1\']);
start_classify_batch_user_training(classifier,[ifcbdir 'features\2021\'],[ifcbdir 'class\class2021_v1\']);


%% Step 5: Summarize manual and classifier results for cell counts
addpath(genpath([ifcbdir 'manual\']));
summarize_cells_from_manual([ifcbdir 'manual\'],[ifcbdir 'data\'],[summarydir 'manual\']); 

summarize_cells_from_classifier([ifcbdir 'class\classXXXX_v1\'],...
    [ifcbdir 'data\'],[summarydir 'class\'],2021); %you will need to do this separately for each year of data

%% Step 6: Summarize manual and classifier results for biovolume
summarize_biovol_eqdiam_from_manual([ifcbdir 'manual\'],[summarydir 'manual\'],...
    [ifcbdir 'data\'],[ifcbdir 'features\2019\'],2019,1/3.4)

