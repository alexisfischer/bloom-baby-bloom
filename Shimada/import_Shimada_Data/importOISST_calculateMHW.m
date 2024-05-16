%% import OISST climatology data
%I also smoothed it in time by a running 90 day gaussian filter over it. 
% don't use the values older than jan 1, 1982, they're no good.

clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath(filepath)); % add new data to search path
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/m_mhw1.0/')); % add new data to search path

load('~/Documents/Shimada2019/rawOISST_1982-2022.mat','ncdcOisst21Agg_LonPM180')

dt=datetime(unixtime2mat(ncdcOisst21Agg_LonPM180.time),'ConvertFrom','datenum'); % seconds since 1970-01-01T00:00:00Z;
dn=datenum(dateshift(dt,'start','day')); 
%idx=find(diff(dn)>1); missing data on 2 dates so am just going to move time series over those dates, and ignore
dn=datenum(1982,1,1):datenum(2021,12,31);

%%%% format m-n-t
M.lat=double(ncdcOisst21Agg_LonPM180.latitude);
M.lon=double(ncdcOisst21Agg_LonPM180.longitude);
sst=double(squeeze(ncdcOisst21Agg_LonPM180.sst)); sst=permute(sst,[2 3 1]);
sst(:,:,end+1)=sst(:,:,end);

%%%% hobday calculation
%https://github.com/ZijieZhaoMMHW/m_mhw1.0
% mhw19 or mhw21 = indicates the maximum intensity of each event in unit of deg. C.
% %2019
dn_19=(datenum(2019,1,1):datenum(2019,12,31))';
[MHW19,~,~,mhw19]=detect(sst,dn,dn(1),dn(end),dn_19(1),dn_19(end));
%MHW.mhw_onset=datetime(datenum(num2str(MHW.mhw_onset),'yyyymmdd'),'ConvertFrom','datenum');
%MHW.mhw_end=datetime(datenum(num2str(MHW.mhw_end),'yyyymmdd'),'ConvertFrom','datenum')

% %2021
dn_21=(datenum(2021,1,1):datenum(2021,12,31))';
[MHW21,mclim,m90,mhw21]=detect(sst,dn,dn(1),dn(end),dn_21(1),dn_21(end));

%%%% format into structure
M.dt19=datetime(dn_19,'ConvertFrom','datenum');
M.dt21=datetime(dn_21,'ConvertFrom','datenum');

M.sst19=sst(:,:,dn>=dn_19(1) & dn<=dn_19(end));
M.sst21=sst(:,:,dn>=dn_21(1) & dn<=dn_21(end));
M.mhw19=mhw19; M.mhw21=mhw21; 

mclim(:,:,end)=[]; m90(:,:,end)=[]; M.clim=mclim; M.m90=m90; 

clearvars ncdcOisst21Agg_LonPM180 dt sst MHW dn m90 mclim mhw19 mhw21 dn_21 dn_19

save([filepath 'Shimada/data/OISST_MHW_2019_2021_raw.mat'],'M','MHW19','MHW21');
