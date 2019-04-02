%% Applying and evaluating a classifier
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

% modify according to dataset
ifcbdir='F:\IFCB104\'; %SCW
%ifcbdir='F:\IFCB113\'; %USGS cruises
%ifcbdir='F:\IFCB113\Exploratorium\'; %Exploratorium
%ifcbdir='F:\IFCB113\ACIDD2017\'; %ACIDD
%ifcbdir='F:\IFCB117\'; %New Zealand

summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\Data\IFCB_summary\'; %SCW
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\IFCB_summary\'; %USGS cruises
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Exploratorium\Data\IFCB_summary\'; %Exploratorium
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\ACIDD2017\Data\IFCB_summary\'; %ACIDD
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\NZ\Data\IFCB_summary\'; %New Zealand

%%%% PART 1: Apply classifier
%% Step 1: Sort data into folders
sort_data_into_folders([ifcbdir 'data\raw\'],[ifcbdir 'data\2019\']);
addpath(genpath([ifcbdir 'data\2018\']));

%addpath(genpath('C:\Users\kudelalab\Documents\GitHub\'));

%% Step 2: Extract blobs
start_blob_batch_user_training([ifcbdir 'data\2018\'],[ifcbdir 'blobs\2018\'],true)
%addpath(genpath([ifcbdir 'blobs\2018\']));

%%% Step 3: Extract features
start_feature_batch_user_training([ifcbdir 'data\2018\'],[ifcbdir 'blobs\2018\'],[ifcbdir 'features\2018\'],true)
%addpath(genpath([ifcbdir 'features\2018\']));

% Step 4: Apply classifier
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Mar2019',...
%     [ifcbdir 'features\2015\'],[ifcbdir 'class\class2015_v1\']);
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Mar2019',...
%     [ifcbdir 'features\2016\'],[ifcbdir 'class\class2016_v1\']);
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Mar2019',...
%     [ifcbdir 'features\2017\'],[ifcbdir 'class\class2017_v1\']);
start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Mar2019',...
    [ifcbdir 'features\2018\'],[ifcbdir 'class\class2018_v1\']);
% start_classify_batch_user_training('F:\IFCB104\manual\summary\UserExample_Trees_27Mar2019',...
%     [ifcbdir 'features\2019\'],[ifcbdir 'class\class2019_v1\']);

%%%% PART 2: Summarize manual results 
% %% Step 5: classes
% %addpath(genpath([ifcbdir 'manual\']));
% countcells_manual_user_training([ifcbdir 'manual\'],[ifcbdir 'data\'],[summarydir 'manual\']); 
% 
% % Step 6: biovolume and classes
% biovolume_summary_manual_user_training([ifcbdir 'manual\'],...
%     [ifcbdir 'data\'],[ifcbdir 'features\XXXX\'],[summarydir 'manual\']);
% 
% %old
% %biovolume_summary_manual([ifcbdir 'manual\'],[summarydir 'manual\'],[ifcbdir 'data\2019\'],[ifcbdir 'features\XXXX\']);

% PART 3: Summarize random forest classification results 
% Step 7: classes    
% biovolume_summary_CA_allTB([summarydir 'class\'],[ifcbdir 'class\classxxxx_v1\'],...
%     [ifcbdir 'features\xxxx\'],[ifcbdir 'data\xxxx\'],0.5,2017:2018); %ACIDD
biovolume_summary_CA_allTB([summarydir 'class\'],[ifcbdir 'class\classxxxx_v1\'],...
    [ifcbdir 'features\xxxx\'],[ifcbdir 'data\xxxx\'],0.5,2018);

countcells_allTBnew_user_training([ifcbdir 'class\classXXXX_v1\'],...
    [ifcbdir 'data\'],[summarydir 'class\'],2018);

%%%% PART 3: Assign threshold scores to specific classes
%% Step 8: Summarize counts for thresholds 0.1 to 1 for the specified class
yrrange = 2017:2018;
classpath_generic = [indir 'class\classxxxx_v1\'];
out_path = [summarydir 'class\'];
in_dir = [indir 'data\'];

%dinos
%countcells_allTB_class('Akashiwo', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Ceratium', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Cochlodinium', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Dinophysis', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Lingulodinium', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Prorocentrum', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Gymnodinium', yrrange, classpath_generic, out_path, in_dir)

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
countcells_allTB_class('Hemiaulus', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Asterionellopsis', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Thalassiosira', yrrange, classpath_generic, out_path, in_dir)

countcells_allTB_class('Umbilicosphaera', yrrange, classpath_generic, out_path, in_dir)

%% extract data for a certain date range
filelist(1:140)=[];
ml_analyzed(1:140)=[];
matdate(1:140)=[];
classbiovol(1:140,:)=[];
classcount(1:140,:)=[];
