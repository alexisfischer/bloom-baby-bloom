%% find top classes that correspond to specific latitudinal gradients
clear;
filepath = '~/Documents/MATLAB/ifcb-data-science/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB2021'],'filelistTB','mdateTB');
[lat,~,~,filelistTB,mdateTB]=match_IFCBdata_w_Shimada_lat_lon(filepath,2021,filelistTB,mdateTB);

% find files within a specific lat lon region
idx=find(lat>=38 & lat<41.5);
filelist=filelistTB(idx);