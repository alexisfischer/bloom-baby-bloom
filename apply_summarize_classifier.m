%% Applying and evaluating a classifier
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

%% PART 1: Apply classifier
%% Step 1: Sort data into folders
%sort_data_into_folders;

%% Step 2: Extract blobs
%start_blob_batch_user_training('F:\IFCB104\data\2015\','F:\IFCB104\blobs\2015\',true)
%start_blob_batch_user_training('F:\IFCB104\data\2016\','F:\IFCB104\blobs\2016\',true)
%start_blob_batch_user_training('F:\IFCB104\data\2017\','F:\IFCB104\blobs\2017\',true)
start_blob_batch_user_training('F:\IFCB104\data\2018\','F:\IFCB104\blobs\2018\',true)

% Step 3: Extract features
% start_feature_batch_user_training('F:\IFCB104\data\2015\',...
%     'F:\IFCB104\blobs\2015\','F:\IFCB104\features\2015\',true)
% start_feature_batch_user_training('F:\IFCB104\data\2016\',...
%     'F:\IFCB104\blobs\2016\','F:\IFCB104\features\2016\',true)
% start_feature_batch_user_training('F:\IFCB104\data\2017\',...
%     'F:\IFCB104\blobs\2017\','F:\IFCB104\features\2017\',true)
start_feature_batch_user_training('F:\IFCB104\data\2018\',...
   'F:\IFCB104\blobs\2018\','F:\IFCB104\features\2018\',true)

% Step 4: Apply classifier
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_22Jun2018',...
%     'F:\IFCB104\features\2015\','F:\IFCB104\class\class2015_v1\')
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_22Jun2018',...
%     'F:\IFCB104\features\2016\','F:\IFCB104\class\class2016_v1\')
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_22Jun2018',...
%     'F:\IFCB104\features\2017\','F:\IFCB104\class\class2017_v1\')
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_22Jun2018',...
    'F:\IFCB104\features\2018\','F:\IFCB104\class\class2018_v1\')

%% PART 2: Summarize results
% Step 5: Summarize random forest classification results by class
countcells_allTBnew_user_training(...
    'F:\IFCB104\class\classxxxx_v1\','F:\IFCB104\data\', 2015:2018)

% Step 6: Summarize biovolume from Manual files
biovolume_summary_manual('F:\IFCB104\manual\','F:\IFCB104\data\',...
    'F:\IFCB104\features\XXXX\');

% Step 7: Summarize biovolume from Classification results
%have not tested this ye, but should work
resultpath = 'F:\IFCB104\class\summary\'; %Where you want the summary file to go
classpath_generic = 'F:\IFCB104\class\classxxxx_v1\';
feapath_generic = 'F:\IFCB104\features\xxxx\'; %Put in your featurepath byyear
roibasepath_generic = 'F:\IFCB104\data\xxxx\'; %Where you raw data is
adhocthresh = 0.5;
yrrange = 2017:2018;

biovolume_summary_CA_allTB(resultpath,classpath_generic,feapath_generic,roibasepath_generic,adhocthresh,yrrange)

%% PART 3: Evaluate classifier
%% Step 8: Summarize counts for thresholds 0.1 to 1 for the specified class
yrrange = 2016:2018;
classpath_generic = 'F:\IFCB104\class\classxxxx_v1\';
out_path = 'F:\IFCB104\class\summary\'; 
in_dir = 'F:\IFCB104\data\';

%dinos
%countcells_allTB_class('Akashiwo', yrrange, classpath_generic, out_path, in_dir)
%countcells_allTB_class('Ceratium', yrrange, classpath_generic, out_path, in_dir)
%countcells_allTB_class('Dinophysis', yrrange, classpath_generic, out_path, in_dir)
%countcells_allTB_class('Lingulodinium', yrrange, classpath_generic, out_path, in_dir)
%countcells_allTB_class('Prorocentrum', yrrange, classpath_generic, out_path, in_dir)

%diatoms
%countcells_allTB_class('Chaetoceros', yrrange, classpath_generic, out_path, in_dir)
% countcells_allTB_class('Det_Cer_Lau', yrrange, classpath_generic, out_path, in_dir)
% countcells_allTB_class('Eucampia', yrrange, classpath_generic, out_path, in_dir)
% countcells_allTB_class('Pseudo-nitzschia', yrrange, classpath_generic, out_path, in_dir)
% countcells_allTB_class('NanoP_less10', yrrange, classpath_generic, out_path, in_dir)
% countcells_allTB_class('Cryptophyte', yrrange, classpath_generic, out_path, in_dir)
% countcells_allTB_class('Skeletonema', yrrange, classpath_generic, out_path, in_dir)
% countcells_allTB_class('Centric', yrrange, classpath_generic, out_path, in_dir)
% countcells_allTB_class('Guin_Dact', yrrange, classpath_generic, out_path, in_dir)

