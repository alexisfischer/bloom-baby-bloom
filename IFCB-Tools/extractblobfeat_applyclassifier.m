%% Extacting Blobs and Features and Applying a Classifier
%  Alexis D. Fischer, University of California - Santa Cruz, April 2020

% modify according to dataset
ifcbdir='F:\IFCB104\'; %SCW
%ifcbdir='F:\IFCB113\'; %USGS cruises
%ifcbdir='F:\IFCB113\Exploratorium\'; %Exploratorium
%ifcbdir='F:\IFCB113\ACIDD2017\'; %ACIDD
%ifcbdir='F:\CAWTHRON\'; %New Zealand

summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\SCW\'; %SCW
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\SFB\'; %USGS cruises
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Exploratorium\'; %Exploratorium
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\ACIDD\'; %ACIDD
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\NZ\'; %New Zealand
%summarydir='F:\CAWTHRON\summary\'; %New Zealand

classifier = 'F:\IFCB104\manual\summary\UserExample_Trees_27Aug2019';

addpath(genpath(summarydir));
addpath(genpath([ifcbdir 'data\']));
addpath(genpath('C:\Users\kudelalab\Documents\GitHub\'));

%remove_empty_blob_folders([ifcbdir 'blobs\2020\'])
 
%% Step 1: Sort data into folders
sort_data_into_folders([ifcbdir 'data\raw\'],[ifcbdir 'data\2020\']);
addpath(genpath([ifcbdir 'data\2020\']));
addpath(genpath([ifcbdir 'blobs\2020\']));
addpath(genpath([ifcbdir 'features\2020\']));
addpath(genpath([ifcbdir 'class\2020\']));

% Step 2: Extract blobs
start_blob_batch_user_training([ifcbdir 'data\2020\'],[ifcbdir 'blobs\2020\'],true)
addpath(genpath([ifcbdir 'blobs\2020\']));

% Step 3: Extract features
start_feature_batch_user_training([ifcbdir 'data\2020\'],[ifcbdir 'blobs\2020\'],[ifcbdir 'features\2020\'],true)
addpath(genpath([ifcbdir 'features\2020\']));

% Step 4: Apply classifier
% start_classify_batch_user_training(classifier,[ifcbdir 'features\2015\'],[ifcbdir 'class\class2015_v1\']);
% start_classify_batch_user_training(classifier,[ifcbdir 'features\2016\'],[ifcbdir 'class\class2016_v1\']);
% start_classify_batch_user_training(classifier,[ifcbdir 'features\2017\'],[ifcbdir 'class\class2017_v1\']);
% start_classify_batch_user_training(classifier,[ifcbdir 'features\2018\'],[ifcbdir 'class\class2018_v1\']);
% start_classify_batch_user_training(classifier,[ifcbdir 'features\2019\'],[ifcbdir 'class\class2019_v1\']);
start_classify_batch_user_training(classifier,[ifcbdir 'features\2020\'],[ifcbdir 'class\class2020_v1\']);

%% Step 5: Summarize manual and classifier results for cell counts
%addpath(genpath([ifcbdir 'manual\']));
summarize_cells_from_manual([ifcbdir 'manual\'],[ifcbdir 'data\'],[summarydir 'manual\']); 

summarize_cells_from_classifier([ifcbdir 'class\classXXXX_v1\'],...
    [ifcbdir 'data\'],[summarydir 'class\'],2020); %you will need to do this separately for each year of data

