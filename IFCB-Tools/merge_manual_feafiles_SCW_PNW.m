function [] = merge_manual_feafiles_SCW_PNW(mergedpath,SCWpath,PNWpath)
%merge_manual_feafiles_SCW_PNW merges manual and feature files in
%preparation for building a training set
%   copies all SCW and Shimada manual and feature files to merged folders
%   converts SCW manual classes to PNW classes
%   Alexis D. Fischer, NOAA NWFSC, September 2021

% % Input path names
% mergedpath = 'D:\Shimada\classifier\';
% SCWpath = 'D:\SCW\';
% PNWpath = 'D:\Shimada\';

manualpath = [mergedpath '\manual_merged\'];
feapathbase = [mergedpath 'features_merged\'];

%% read in universal class2use
PNWmanualpath = [PNWpath 'manual\']; 
manual_files = dir([PNWmanualpath 'D*.mat']);
manual_files = {manual_files.name}';
class2use = load([PNWmanualpath manual_files{1}], 'class2use_manual'); %load in first PNW manual file
class2use = class2use.class2use_manual;
clearvars manual_files 

%% Shimada
% copy manual files to merged manual folder
manual_files = dir([PNWmanualpath 'D*.mat']); %only select manual files
for i=1:length(manual_files)  
    copyfile([PNWmanualpath manual_files(i).name],manualpath); 
end

% copy corresponding features files to merged features folder
PNWfeapathbase = [PNWpath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    PNWfeapath=[PNWfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];    
    copyfile([PNWfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files PNWmanualpath i PNWfeapath feapath
fprintf('Finished copying corresponding Shimada manual and feature files');

%% SCW
% copy manual files to merged manual folder and convert classes
SCWmanualpath = [SCWpath 'manual\'];
manual_files = dir([SCWmanualpath 'D*104.mat']); %only select SCW files
for i=1:length(manual_files)  
    copyfile([SCWmanualpath manual_files(i).name],manualpath);  
    baseFileName = manual_files(i).name;        
    fullFileName = fullfile(manualpath, baseFileName);
    fprintf(1, 'Now converting classes in file %s\n', fullFileName);
    load(fullFileName,'class2use_auto','classlist','default_class_original','list_titles');
    
    %overwrite SCW classes with PNW classes    
    [classlist(:,2)]=convert_classnum_SCW2PNW(classlist(:,2)); 
    [classlist(:,3)]=convert_classnum_SCW2PNW(classlist(:,3));     
    class2use_manual=class2use;
    if isempty(class2use_auto)
    else
        class2use_auto = class2use;
    end    
    
    save(fullFileName,'class2use_auto','class2use_manual','classlist','default_class_original','list_titles');
    clearvars class2use_auto class2use_manual classlist default_class_original list_titles baseFileName fullFileName; 
end

% copy corresponding features files to merged features folder
SCWfeapathbase = [SCWpath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    SCWfeapath=[SCWfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];
    copyfile([SCWfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files i SCWfeapath feapath
fprintf('Finished copying corresponding SCW manual and feature files');

end

