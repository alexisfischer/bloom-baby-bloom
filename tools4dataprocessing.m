%% IFCB113 - Extract blobs and features and apply classifier

start_blob_batch_user_training('F:\IFCB113\data\2016\','F:\IFCB113\blobs\2016\',true)
start_blob_batch_user_training('F:\IFCB113\data\2017\','F:\IFCB113\blobs\2017\',true)
start_blob_batch_user_training('F:\IFCB113\data\2018\','F:\IFCB113\blobs\2018\',true)

start_feature_batch_user_training('F:\IFCB113\data\2016\',...
    'F:\IFCB113\blobs\2016\','F:\IFCB113\features\2016\',true)
start_feature_batch_user_training('F:\IFCB113\data\2017\',...
    'F:\IFCB113\blobs\2017\','F:\IFCB113\features\2017\',true)
start_feature_batch_user_training('F:\IFCB113\data\2018\',...
    'F:\IFCB113\blobs\2018\','F:\IFCB113\features\2018\',true)

start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_23Mar2018',...
    'F:\IFCB113\features\2016\','F:\IFCB113\class\class2016_v1\')
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_23Mar2018',...
    'F:\IFCB113\features\2017\','F:\IFCB113\class\class2017_v1\')
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_23Mar2018',...
    'F:\IFCB113\features\2018\','F:\IFCB113\class\class2018_v1\')

%% Summarize random forest classification results by class
countcells_allTBnew_user_training(...
    'F:\IFCB113\class\classxxxx_v1\','F:\IFCB113\data\', 2017:2018)

countcells_allTB_class_by_thre_user_v2('Akashiwo');
countcells_allTB_class_by_thre_user_v2('Alexandrium_singlet');
countcells_allTB_class_by_thre_user_v2('Dinophysis');
countcells_allTB_class_by_thre_user_v2('Prorocentrum');
countcells_allTB_class_by_thre_user_v2('Pseudo-nitzschia');

%% IFCB104 - Apply and evaluate classifier
%sort_data_into_folders;

% Extract blobs
%start_blob_batch_user_training('F:\IFCB104\data\2015\','F:\IFCB104\blobs\2015\',true)
%start_blob_batch_user_training('F:\IFCB104\data\2016\','F:\IFCB104\blobs\2016\',true)
%start_blob_batch_user_training('F:\IFCB104\data\2017\','F:\IFCB104\blobs\2017\',true)
start_blob_batch_user_training('F:\IFCB104\data\2018\','F:\IFCB104\blobs\2018\',true)

% Extract features
% start_feature_batch_user_training('F:\IFCB104\data\2015\',...
%     'F:\IFCB104\blobs\2015\','F:\IFCB104\features\2015\',true)
% start_feature_batch_user_training('F:\IFCB104\data\2016\',...
%     'F:\IFCB104\blobs\2016\','F:\IFCB104\features\2016\',true)
% start_feature_batch_user_training('F:\IFCB104\data\2017\',...
%     'F:\IFCB104\blobs\2017\','F:\IFCB104\features\2017\',true)
start_feature_batch_user_training('F:\IFCB104\data\2018\',...
   'F:\IFCB104\blobs\2018\','F:\IFCB104\features\2018\',true)

% Apply classifier
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_30Mar2018',...
%     'F:\IFCB104\features\2015\','F:\IFCB104\class\class2015_v1\')
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_30Mar2018',...
%     'F:\IFCB104\features\2016\','F:\IFCB104\class\class2016_v1\')
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_30Mar2018',...
%     'F:\IFCB104\features\2017\','F:\IFCB104\class\class2017_v1\')
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_30Mar2018',...
    'F:\IFCB104\features\2018\','F:\IFCB104\class\class2018_v1\')

% Summarize random forest classification results by class
countcells_allTBnew_user_training(...
    'F:\IFCB104\class\classxxxx_v1\','F:\IFCB104\data\', 2015:2018)

% Summarize biovolume from forest classification results by class
biovolume_summary_manual('F:\IFCB104\manual\','F:\IFCB104\data\',...
    'F:\IFCB104\features\XXXX\');

% Summarize counts for thresholds 0.1 to 1 for the specified class
yrrange = 2015:2018;
classpath_generic = 'F:\IFCB104\class\classxxxx_v1\';
out_path = 'F:\IFCB104\class\summary\'; 
in_dir = 'F:\IFCB104\data\';
countcells_allTB_class_by_thre('Akashiwo', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class_by_thre('Alexandrium_singlet', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class_by_thre('Dinophysis', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class_by_thre('Prorocentrum', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class_by_thre('Pseudo-nitzschia', yrrange, classpath_generic, out_path, in_dir)

%% Compile features for the training set

manualpath = 'F:\IFCB104\manual\'; % manual annotation file location
feapath_base = 'F:\IFCB104\features\'; %feature file location, assumes \yyyy\ organization
maxn = 2000; %maximum number of images per class to include
minn = 30; %minimum number for inclusion
class2skip = {'unclassified' 'Alexandrium_doublet' 'Alexandrium_triplet'...
    'Alexandrium_quad' 'Bacteriastrum' 'Fragilariopsis' 'Hemiaulus' ...
    'Leptocylindrus' 'Licmophora' 'Lithodesmium' 'Navicula' 'Paralia' ...
    'Tropidoneis' 'Cyl_Nitz' 'Lio_Thal' 'Steph_Melo' 'Centric<10'...
    'Boreadinium' 'Gyrodinium' 'Noctiluca' 'Phaeocystis' 'Polykrikos'...
    'Pyramimonas' 'Pyrocystis' 'Torodinium' 'Oxyp_Oxyt' 'Beads' ...
    'small_misc' 'bubbles'};

compile_train_features_user_training(manualpath,feapath_base,maxn,minn,class2skip);

%% Train (make) the classifier

result_path = 'F:\IFCB104\manual\summary\'; %USER location of training file and classifier output
train_filename = 'UserExample_Train_30Mar2018'; %USER what file contains your training features
result_str = 'UserExample_Trees_';
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications

make_TreeBaggerClassifier_user_training(result_path, train_filename, result_str, nTrees)

%%
classifier_oob_analysis('F:\IFCB104\manual\summary\UserExample_Trees_23Mar2018');

%% Find the volume sampled in milliliters for >1 IFCB files
%examples
myfiles = { 'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141118T234705_IFCB102.hdr';...
    'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141106T132705_IFCB102.hdr' }
ml = IFCB_volume_analyzed( myfiles )

%% Extract the date and time from a sample file name and convert it to
% MATLAB serial date numbers (for convenient plotting, for instance)

myfiles = { 'D20141118T234705_IFCB102'; 'D20141106T132705_IFCB102' }
IFCB_file2date( myfiles )
