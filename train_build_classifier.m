%% Training and Making a classifier
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

%% Step 1: Compile features for the training set
manualpath = 'F:\IFCB104\manual\'; % manual annotation file location
feapath_base = 'F:\IFCB104\features\'; %feature file location, assumes \yyyy\ organization
maxn = 10000; %maximum number of images per class to include
minn = 200; %minimum number for inclusion
class2skip = {'unclassified' 'Alexandrium_doublet' 'Alexandrium_triplet' ...
    'Alexandrium_quad' 'Azadinium' 'Beads' 'Boreadinium' 'Pollen' 'Detritus'...
    'Centric<10' 'DinoMix' 'FlagMix' 'Fragilariopsis' 'Helicotheca' 'Ciliates'... 
    'Leptocylindrus' 'Lio_Thal' 'Navicula' 'Noctiluca' 'Paralia' 'Torodinium'...
    'small_misc' 'Ash_dark' 'Ash_glassy' 'bubbles' 'cyst' 'Clusterflagellate'...
    'Gyrosigma' 'Dolichospermum' 'Desmid' 'Plagiolemma' 'small_misc' 'zooplankton_misc'};

class2group = {'NanoP_less10' 'Cryptophyte'};

compile_train_features_user_training(manualpath,feapath_base,maxn,minn,class2skip,class2group);
addpath(genpath('F:\IFCB104\manual\summary\')); % add new data to search path

%% Step 2: Train (make) the classifier
result_path = 'F:\IFCB104\manual\summary\'; %USER location of training file and classifier output
train_filename = 'UserExample_Train_26Mar2019'; %USER what file contains your training features
result_str = 'UserExample_Trees_';
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications

make_TreeBaggerClassifier_user_training(result_path, train_filename, result_str, nTrees)

%% If want to remake figures related to classifier output
classifier_oob_analysis('F:\IFCB104\manual\summary\UserExample_Trees_27Mar2019',...
    'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\Figs\');

%% Find the volume sampled in milliliters for >1 IFCB files
%examples
myfiles = { 'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141118T234705_IFCB102.hdr';...
    'http://ifcb-data.whoi.edu/IFCB102_PiscesNov2014/D20141106T132705_IFCB102.hdr' }
ml = IFCB_volume_analyzed( myfiles )

%% Extract the date and time from a sample file name and convert it to
% MATLAB serial date numbers (for convenient plotting, for instance)

myfiles = { 'D20141118T234705_IFCB102'; 'D20141106T132705_IFCB102' }
IFCB_file2date( myfiles )
