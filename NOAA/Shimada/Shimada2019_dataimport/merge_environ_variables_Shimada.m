% merge Shimada temperature data with lat lon coordinates
% load in lat lon coordinates and environmental variables from Shimada 2021
% Alexis D. Fischer, NWFSC, May 2022

clear;
filepath= '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/'; 
addpath(genpath(filepath)); 

load([filepath 'Data/lat_lon_time_Shimada2019'],'DT','LON','LAT');
load([filepath 'Data/temperature_Shimada2019'],'dt','temp');
[~,ia,ib]=intersect(dt,DT);
TEMP=NaN*ones(size(DT)); TEMP(ib)=temp(ia);
%figure; plot(LON(ib),LAT(ib),'o'); % test plot
%figure; plot(LAT(ib),TEMP(ib),'o'); % test plot

load([filepath 'Data/salinity_Shimada2021'],'dt','sal');
[~,ia,ib]=intersect(dt,DT);
SAL=NaN*ones(size(DT)); SAL(ib)=sal(ia);
%figure; plot(LON(ib),LAT(ib),'o'); % test plot

load([filepath 'Data/fluorescence_Shimada2021'],'dt','fl');
[~,ia,ib]=intersect(dt,DT);
FL=NaN*ones(size(DT)); FL(ib)=fl(ia);
%figure; plot(LON(ib),LAT(ib),'o'); % test plot

clearvars ia ib dt fl dt sal temp

save([filepath 'Data/environ_Shimada2021'],'DT','LON','LAT','TEMP','SAL','FL');