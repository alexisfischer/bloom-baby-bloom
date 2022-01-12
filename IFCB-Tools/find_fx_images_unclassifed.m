clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
filepath = '/Users/afischer/MATLAB/';
load([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/class/summary_allTB_2019_2021']);

total_ind=sum(classcountTB,1);
total=sum(total_ind);
unclassifed=total_ind(strcmp(class2useTB,'unclassified'));
fx_un=unclassifed./total