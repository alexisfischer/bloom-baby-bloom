%% SF Bay timeseries from 2017-07-31 to present
% stations: 36/34, 32, 27, 22, 18, 15, 13, 9, 6, 3, 649, 657
% Extract blobs and features and apply classifier

start_blob_batch_user_training(...
    'F:\IFCB113\data\2017qc\',...
    'F:\IFCB113\blobs\2017qc\',true)

start_feature_batch_user_training(...
    'F:\IFCB113\data\2017qc\',...
    'F:\IFCB113\blobs\2017qc\',...
    'F:\IFCB113\features\2017qc\',true)

start_classify_batch_user_training(...
    'F:\IFCB104\manual\summary\UserExample_Trees_19Dec2017',...
    'F:\IFCB113\features\2017ok\',...
    'F:\IFCB113\class\class2017ok_v1\')


%% IFCB113 - Extract blobs and features and apply classifier

start_blob_batch_user_training('F:\IFCB113\data\2016\','F:\IFCB113\blobs\2016\',true)
start_feature_batch_user_training('F:\IFCB113\data\2016\',...
    'F:\IFCB113\blobs\2016\','F:\IFCB113\features\2016\',true)
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Feb2018',...
    'F:\IFCB113\features\2016\','F:\IFCB113\class\class2016_v1\')

start_blob_batch_user_training('F:\IFCB113\data\2017\','F:\IFCB113\blobs\2017\',true)
start_feature_batch_user_training('F:\IFCB113\data\2017\',...
    'F:\IFCB113\blobs\2017\','F:\IFCB113\features\2017\',true)
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Feb2018',...
    'F:\IFCB113\features\2017\','F:\IFCB113\class\class2017_v1\')

start_blob_batch_user_training('F:\IFCB113\data\2018\','F:\IFCB113\blobs\2018\',true)
start_feature_batch_user_training('F:\IFCB113\data\2018\',...
    'F:\IFCB113\blobs\2018\','F:\IFCB113\features\2018\',true)
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Feb2018',...
    'F:\IFCB113\features\2018\','F:\IFCB113\class\class2018_v1\')

%% IFCB104 - Extract blobs and features and apply classifier
%start_blob_batch_user_training('F:\IFCB104\data\2015\','F:\IFCB104\blobs\2015\',true)
%start_blob_batch_user_training('F:\IFCB104\data\2016\','F:\IFCB104\blobs\2016\',true)
%start_blob_batch_user_training('F:\IFCB104\data\2017\','F:\IFCB104\blobs\2017\',true)
start_blob_batch_user_training('F:\IFCB104\data\2018\','F:\IFCB104\blobs\2018\',true)

% start_feature_batch_user_training('F:\IFCB104\data\2015\',...
%     'F:\IFCB104\blobs\2015\','F:\IFCB104\features\2015\',true)
% start_feature_batch_user_training('F:\IFCB104\data\2016\',...
%     'F:\IFCB104\blobs\2016\','F:\IFCB104\features\2016\',true)
% start_feature_batch_user_training('F:\IFCB104\data\2017\',...
%     'F:\IFCB104\blobs\2017\','F:\IFCB104\features\2017\',true)
start_feature_batch_user_training('F:\IFCB104\data\2018\',...
    'F:\IFCB104\blobs\2018\','F:\IFCB104\features\2018\',true)

% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Feb2018',...
%     'F:\IFCB104\features\2015\','F:\IFCB104\class\class2015_v1\')
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Feb2018',...
%     'F:\IFCB104\features\2016\','F:\IFCB104\class\class2016_v1\')
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Feb2018',...
%     'F:\IFCB104\features\2017\','F:\IFCB104\class\class2017_v1\')
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Feb2018',...
    'F:\IFCB104\features\2018\','F:\IFCB104\class\class2018_v1\')

%%
% Summarize random forest classification results by class
countcells_allTBnew_user_training(...
    'F:\IFCB104\class\classxxxx_v1\',...
    'F:\IFCB104\data\', 2015:2018)

%% Compile features for the training set

manualpath = 'F:\IFCB104\manual\'; % manual annotation file location
feapath_base = 'F:\IFCB104\features\'; %feature file location, assumes \yyyy\ organization
maxn = 500; %maximum number of images per class to include
minn = 18; %minimum number for inclusion
class2skip = {'unclassified' 'Noctiluca','Phaeocystis','Polykrikos','Pyrocystis'...
     'DinoMix','FlagMix' 'Beads','Detritus','small_misc' 'bubbles' 'Karenia'};
 
class2group = {{'Cryptophyte' 'NanoP_less10'} {'Myrionecta' 'Ciliates'}...
    {'Asterionellopsis' 'Bacteriastrum' 'Chaetoceros' 'Corethron'...
    'Ditylum' 'Entomoneis' 'Eucampia' 'Fragilariopsis' 'Helicotheca'...
    'Hemiaulus' 'Leptocylindrus' 'Licmophora' 'Lithodesmium' 'Navicula'...
    'Odontella' 'Paralia' 'Pleurosigma' 'Skeletonema' 'Thalassionema' ...
    'Thalassiosira' 'Tropidoneis' 'Centric' 'Det_Cer_Lau' 'Cyl_Nitz' ...
    'Guin_Dact' 'Lio_Thal' 'Steph_Melo' 'Rhiz_Prob' 'Centric<10'...
    'Pennate' 'Boreadinium' 'Pyramimonas' 'Torodinium' 'Oxyp_Oxyt'}}; %use nested cells for multiple groups of 2 or more classes 

compile_train_features_user_training(manualpath,feapath_base,maxn,minn,class2skip,class2group);

%% Train (make) the classifier

result_path = 'F:\IFCB104\manual\summary\'; %USER location of training file and classifier output
train_filename = 'UserExample_Train_27Feb2018'; %USER what file contains your training features
result_str = 'UserExample_Trees_';
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications

make_TreeBaggerClassifier_user_training(result_path, train_filename, result_str, nTrees)

%%
classifier_oob_analysis('F:\IFCB104\manual\summary\UserExample_Trees_21Jan2018');

%% Find the volume sampled in milliliters for >1 IFCB files
%examples
myfiles = { 'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141118T234705_IFCB102.hdr';...
    'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141106T132705_IFCB102.hdr' }
ml = IFCB_volume_analyzed( myfiles )

%% Extract the date and time from a sample file name and convert it to
% MATLAB serial date numbers (for convenient plotting, for instance)

myfiles = { 'D20141118T234705_IFCB102'; 'D20141106T132705_IFCB102' }
IFCB_file2date( myfiles )
