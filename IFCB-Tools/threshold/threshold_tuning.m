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
load([summarydir 'class\performance_classifier_CCS_v1'],'all'); %get classlist from classifier
class2do_string = all.class;
for i=1:length(class2do_string)
    countcells_allTB_class_by_threshold(class2do_string(i),yrrange,...
        [ifcbdir 'class\classxxxx_v1\'],[summarydir 'threshold\'],[ifcbdir 'data\'])
end

%% Step 3) evaluate the right threshold to use for your class files
summarize_thresholds_byclass(class2do_string,summarydir,[summarydir 'manual\count_class_biovol_manual'],[summarydir 'summary_allTB_bythre_' class2do_string]);

%% Step 4) Run TB_plots_versus_Manual