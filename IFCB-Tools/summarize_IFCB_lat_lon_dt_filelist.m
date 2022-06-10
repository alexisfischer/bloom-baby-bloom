%% find top classes that correspond to specific latitudinal gradients
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'IFCB-Data/SCW/manual/count_class_biovol_manual'],'filelist','matdate')
UCSC.filelist=cellfun(@(X) X(1:end-4),({filelist.name})','Uniform',0);
UCSC.lat=36.96149*ones(size(matdate));
UCSC.lon=-122.02187*ones(size(matdate));
UCSC.dt=datetime(matdate,'convertfrom','datenum');

I19=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2019']);
I21=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2021']);

NOAA.filelist=[I19.filelistTB;I21.filelistTB];
NOAA.lat=[I19.latI;I21.latI];
NOAA.lon=[I19.lonI;I21.lonI];
NOAA.dt=[I19.dtI;I21.dtI];

save([filepath 'NOAA/Shimada/Data/IFCB_NOAA_UCSC_lat_lon_dt'],'NOAA','UCSC');
