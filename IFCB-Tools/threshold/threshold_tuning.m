%% Threshold tuning
% Alexis Fischer, NOAA Feb 2023
clear;
ifcbdir='D:\Shimada\'; 
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
addpath(genpath(ifcbdir));
addpath(genpath(summarydir));
yrrange = 2019:2021;

%% Step 1) Make a biovolume summary file from manual results
summarize_biovol_from_manual([ifcbdir 'manual\'],[summarydir 'manual\'],[ifcbdir 'data\'],[ifcbdir 'features\'],1/3.4)
 
%% Step 2) Make summary file of counts for thresholds 0.1 to 1 for all classes
load([summarydir 'class\performance_classifier_CCS_v2'],'all'); %get classlist from classifier
classlist = all.class;
for i=20:length(classlist)
    countcells_allTB_class_by_threshold(char(classlist(i)),yrrange,[ifcbdir 'class\classxxxx_v1\'],[summarydir 'threshold\'],[ifcbdir 'data\'])
end

%% Step 3) evaluate the right threshold to use for your class files
% summarize_thresholds_byclass

%% Step 4) plot your data with 
% TB_plots_versus_Manual