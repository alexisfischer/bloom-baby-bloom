%% Extacting Blobs and Features and Applying a Classifier
%  Alexis D. Fischer, NOAA NWFSC, August 2021
clear;

%%%% modify according to dataset
%ifcbdir='D:\Shimada\'; 
ifcbdir='D:\BuddInlet\';
%ifcbdir='D:\LabData\'; 
%ifcbdir='D:\SCW\'; 
%ifcbdir='D:\general\classifier\'; 

%summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
%summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\UCSC\SCW\';
%summarydir=[ifcbdir 'summary\'];

yr='2023';

addpath(genpath(summarydir));
addpath(genpath(ifcbdir));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\'));

classifier='D:\general\classifier\summary\Trees_BI_NOAA-OSU_v2';
%classifier='D:\general\classifier\summary\Trees_CCS_NOAA-OSU_v7';

copy_data_into_folders('C:\SFTP-BuddInlet\2023\',[ifcbdir 'data\' yr '\']);

% Step 2: Extract blobs
start_blob_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],true);

% Step 3: Extract features
start_feature_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],[ifcbdir 'features\' yr '\'],true)

% Step 4: Apply classifier
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\class' yr '_v1\']);
%%
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\CCS_NOAA-OSU_v7\class' yr '_v1\']);
yr='2021';
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\CCS_NOAA-OSU_v7\class' yr '_v1\']);

%% Step 5: Summaries
summarydir_base='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
summaryfolder='IFCB-Data\Shimada\class\';
classpath_generic = [ifcbdir 'class\CCS_NOAA-OSU_v7\classxxxx_v1\'];
feapath_generic = [ifcbdir 'features\xxxx\']; %Put in your featurepath byyear
roibasepath_generic = [ifcbdir 'data\xxxx\']; %location of raw data
adhocthresh = 0.5;
micron_factor=1/3.8; %pixels/micron

summarize_biovol_from_classifier(summarydir_base,summaryfolder,classpath_generic,...
    feapath_generic,roibasepath_generic,adhocthresh,micron_factor,2019:2021);

% summarize PN width
summarize_PN_width_from_classifier([summarydir_base 'IFCB-Data\Shimada\class\'],...
    feapath_generic,roibasepath_generic,classpath_generic,micron_factor,2019:2021)
%%

summarize_biovol_from_manual([ifcbdir 'manual\'],[summarydir 'manual\'],...
    [ifcbdir 'data\'],[ifcbdir 'features\'],micron_factor)

summarize_cells_from_manual([ifcbdir 'manual\'],[ifcbdir 'data\'],[summarydir 'manual\']); 

%summarize_cells_from_manual([ifcbdir 'manualEmilie\AlternateSamples\'],[ifcbdir 'data\'],[summarydir 'manual\']); 


%% adjust classlists
start_mc_adjust_classes_user_training('D:\general\config\class2use_16','D:\Shimada\manual_test\')
start_mc_adjust_classes_user_training('D:\general\config\class2use_16','D:\BuddInlet\manual\')
start_mc_adjust_classes_user_training('D:\general\config\class2use_16','D:\LabData\manual\')
start_mc_adjust_classes_user_training('D:\general\config\class2use_16','D:\BuddInlet\manual_DiscreteSamples\')
start_mc_adjust_classes_user_training('D:\general\config\class2use_16','D:\BuddInlet\manual_AltSamples\')

