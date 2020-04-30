% modify according to dataset
ifcbdir='F:\IFCB104\'; %SCW
%ifcbdir='F:\IFCB113\'; %USGS cruises
%ifcbdir='F:\IFCB113\Exploratorium\'; %Exploratorium

summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\Data\IFCB_summary\'; %SCW
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\IFCB_summary\'; %USGS cruises
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Exploratorium\Data\IFCB_summary\'; %Exploratorium

addpath(genpath(summarydir));
addpath(genpath([ifcbdir 'data\']));
addpath(genpath('C:\Users\kudelalab\Documents\GitHub\'));

%remove_empty_blob_folders([ifcbdir 'blobs\2019\'])
 
% Step 1: Sort data into folders
sort_data_into_folders([ifcbdir 'data\raw\'],[ifcbdir 'data\2019\']);
addpath(genpath([ifcbdir 'data\2019\']));
addpath(genpath([ifcbdir 'blobs\2019\']));
addpath(genpath([ifcbdir 'features\2019\']));
addpath(genpath([ifcbdir 'class\2019\']));

% Step 2: Extract blobs
start_blob_batch_user_training([ifcbdir 'data\2019\'],[ifcbdir 'blobs\2019\'],true)
addpath(genpath([ifcbdir 'blobs\2019\']));

% Step 3: Extract features
start_feature_batch_user_training([ifcbdir 'data\2019\'],[ifcbdir 'blobs\2019\'],[ifcbdir 'features\2019\'],true)

% Step 4: Apply classifier
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Aug2019',...
    [ifcbdir 'features\2019\'],[ifcbdir 'class\class2019_v1\']);
