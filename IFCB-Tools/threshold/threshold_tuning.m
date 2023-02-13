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
load([summarydir 'class\performance_classifier_CCS_v6'],'all'); %get classlist from classifier
classlist = all.class;
for i=1:length(classlist)
    countcells_allTB_class_by_threshold(char(classlist(i)),yrrange,[ifcbdir 'class\classxxxx_v1\'],[summarydir 'threshold\' classifiername '\'],[ifcbdir 'data\'])
end

%% Step 3) Manually evaluate the best threshold to use for your class files
% evaluate_thresholds_byclass

%% Step 4) Manually plot your data against annotations with chosen thresholds
% TB_plots_versus_Manual_NOAA

%% Step 5) Determine classifier performance w chosen thresholds
% classifier_oob_analysis_threshold