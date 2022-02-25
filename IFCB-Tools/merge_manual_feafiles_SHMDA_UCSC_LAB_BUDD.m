function [] = merge_manual_feafiles_SHMDA_UCSC_LAB_BUDD(class2useName,mergedpath,UCSCpath,SHMDApath,LABpath,BUDDpath)
%merge_manual_feafiles_UCSC_SHMDA merges manual and feature files in
%preparation for building a training set
%   copies all UCSC and Shimada manual and feature files to merged folders
%   converts UCSC manual classes to SHMDA classes
%   Alexis D. Fischer, SHMDA NWFSC, September 2021

% % Input path names
% class2useName ='D:\Shimada\config\class2use_10';
% mergedpath = 'D:\Shimada\classifier\';
% UCSCpath = 'D:\SCW\';
% SHMDApath = 'D:\Shimada\';
% LABpath = 'D:\Shimada\LabData\';
% BUDDpath = 'D:\BuddInlet\';

%%
manualpath = [mergedpath '\manual_merged\'];
feapathbase = [mergedpath 'features_merged\'];
load([class2useName '.mat'], 'class2use');

% Shimada
% copy manual files to merged manual folder
SHMDAmanualpath = [SHMDApath 'manual\'];
manual_files = dir([SHMDAmanualpath 'D*.mat']); %only select manual files
for i=1:length(manual_files)  
    copyfile([SHMDAmanualpath manual_files(i).name],manualpath); 
end

% copy corresponding features files to merged features folder
SHMDAfeapathbase = [SHMDApath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    SHMDAfeapath=[SHMDAfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];    
    copyfile([SHMDAfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files SHMDAmanualpath i SHMDAfeapath feapath
fprintf(' Finished copying corresponding SHIMADA manual and feature files');

%% Lab Data
addpath(genpath(LABpath));
addpath(genpath(mergedpath));

% copy manual files to merged manual folder
LABmanualpath = [LABpath 'manual\'];
manual_files = dir([LABmanualpath 'D*.mat']); %only select manual files
for i=1:length(manual_files)  
    copyfile([LABmanualpath manual_files(i).name],manualpath); 
end

% copy corresponding features files to merged features folder
LABfeapathbase = [LABpath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    LABfeapath=[LABfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];    
    copyfile([LABfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files LABmanualpath i LABfeapath feapath
fprintf(' Finished copying corresponding LAB manual and feature files');

%% Budd Inlet Data
addpath(genpath(BUDDpath));
addpath(genpath(mergedpath));

% copy manual files to merged manual folder
BUDDmanualpath = [BUDDpath 'manual\'];
manual_files = dir([BUDDmanualpath 'D*.mat']); %only select manual files
for i=1:length(manual_files)  
    copyfile([BUDDmanualpath manual_files(i).name],manualpath); 
end

% copy corresponding features files to merged features folder
BUDDfeapathbase = [BUDDpath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    BUDDfeapath=[BUDDfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];    
    copyfile([BUDDfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files BUDDmanualpath i BUDDfeapath feapath
fprintf(' Finished copying corresponding BUDD manual and feature files');

%% UCSC
% copy manual files to merged manual folder and convert classes
UCSCmanualpath = [UCSCpath 'manual\'];
manual_files = dir([UCSCmanualpath 'D*104.mat']); %only select UCSC files
for i=1:length(manual_files)  
    copyfile([UCSCmanualpath manual_files(i).name],manualpath);  
    baseFileName = manual_files(i).name;        
    fullFileName = fullfile(manualpath, baseFileName);
    fprintf(1, 'Now converting classes in file %s\n', fullFileName);
    load(fullFileName,'class2use_auto','classlist','default_class_original','list_titles');
    
    %overwrite UCSC classes with NOAA classes    
    [classlist(:,2)]=convert_classnum_UCSC2NOAA(classlist(:,2)); 
    [classlist(:,3)]=convert_classnum_UCSC2NOAA(classlist(:,3));     
    class2use_manual=class2use;
    if isempty(class2use_auto)
    else
        class2use_auto = class2use;
    end    
    
    save(fullFileName,'class2use_auto','class2use_manual','classlist','default_class_original','list_titles');
    clearvars class2use_auto class2use_manual classlist default_class_original list_titles baseFileName fullFileName; 
end

% copy corresponding features files to merged features folder
UCSCfeapathbase = [UCSCpath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    UCSCfeapath=[UCSCfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];
    copyfile([UCSCfeapath fea_files{i}],feapath); 
end

% convert to preferred classlist
manualdir = dir([manualpath 'D*']);
for ii = 1:length(manualdir)
    manualfile = open([manualpath manualdir(ii).name]);
    manualfile.class2use_manual = class2use;
    if ~isempty(manualfile.class2use_auto)
        manualfile.class2use_auto = transpose(class2use);
    end
    save([manualpath manualdir(ii).name], '-struct', 'manualfile');
end

clearvars manual_files fea_files i UCSCfeapath feapath
fprintf(' Finished copying corresponding UCSC manual and feature files');

end

