%% PART 1: Apply classifier
%% Step 1: Sort data into folders

%% Step 2: Extract blobs
start_blob_batch_user_training('F:\IFCB113\ACIDD2017\data\2017\','F:\IFCB113\ACIDD2017\blobs\2017\',false)

% Step 3: Extract features
start_feature_batch_user_training('F:\IFCB113\ACIDD2017\data\2017\',...
   'F:\IFCB113\ACIDD2017\blobs\2017\','F:\IFCB113\ACIDD2017\features\2017\',true)

% Step 4: Apply classifier
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_25Jul2018',...
    'F:\IFCB113\ACIDD2017\features\2017\','F:\IFCB113\ACIDD2017\class\class2017_v1\')

% PART 2: Summarize results 
% Step 5: Summarize random forest classification results by class
countcells_allTBnew_user_training('F:\IFCB113\ACIDD2017\class\classxxxx_v1\',...
    'F:\IFCB113\ACIDD2017\data\',...
    'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\ACIDD2017\Data\IFCB_summary\class\',2017)

%% Step 6: Summarize biovolume from Manual files
biovolume_summary_manual('F:\IFCB113\ACIDD2017\manual\',...
        'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\ACIDD2017\Data\IFCB_summary\manual\',...
        'F:\IFCB113\ACIDD2017\data\','F:\IFCB113\ACIDD2017\features\XXXX\');

% Step 7: Summarize biovolume from Classification results
resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\ACIDD2017\Data\IFCB_summary\class\'; %Where you want the summary file to go
classpath_generic = 'F:\IFCB113\ACIDD2017\class\classxxxx_v1\';
feapath_generic = 'F:\IFCB113\ACIDD2017\features\xxxx\'; %Put in your featurepath byyear
roibasepath_generic = 'F:\IFCB113\ACIDD2017\data\xxxx\'; %Where you raw data is
adhocthresh = 0.5;
yrrange = 2017;

biovolume_summary_CA_allTB(resultpath,classpath_generic,feapath_generic,roibasepath_generic,adhocthresh,yrrange)

extract_biovolume_allcells;
%%
% PART 3: Evaluate classifier
% Step 8: Summarize counts for thresholds 0.1 to 1 for the specified class
yrrange = 2017;
classpath_generic = 'F:\IFCB113\ACIDD2017\class\classxxxx_v1\';
out_path = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\ACIDD2017\Data\IFCB_summary\class\';
in_dir = 'F:\IFCB113\ACIDD2017\data\';

countcells_allTB_class('Umbilicosphaera', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Gymnodinium', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Ciliates', yrrange, classpath_generic, out_path, in_dir)
%%
%dinos
countcells_allTB_class('Akashiwo', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Ceratium', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Dinophysis', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Lingulodinium', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Prorocentrum', yrrange, classpath_generic, out_path, in_dir)

%diatoms
countcells_allTB_class('Chaetoceros', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Det_Cer_Lau', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Eucampia', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Pseudo-nitzschia', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('NanoP_less10', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Cryptophyte', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Skeletonema', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Centric', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Guin_Dact', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Pennate', yrrange, classpath_generic, out_path, in_dir)
