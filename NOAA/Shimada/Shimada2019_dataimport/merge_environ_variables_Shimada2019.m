% merge Shimada temperature data with lat lon coordinates
% load in lat lon coordinates and environmental variables from Shimada 2019
% Alexis D. Fischer, NWFSC, May 2022

clear;
filepath= '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/'; 
addpath(genpath(filepath)); 

load([filepath 'Data/lat_lon_time_Shimada2019'],'DT','LON','LAT');
load([filepath 'Data/temperature_salinity_Shimada2019'],'dt','temp','sal');
[~,ia,ib]=intersect(dt,DT);
TEMP=NaN*ones(size(DT)); TEMP(ib)=temp(ia);  
SAL=NaN*ones(size(DT)); SAL(ib)=sal(ia);
%figure; plot(LON(ib),LAT(ib),'o'); % test plot
%figure; plot(LAT(ib),TEMP(ib),'o'); % test plot
%figure; plot(LAT(ib),SAL(ib),'o'); % test plot

load([filepath 'Data/fluorescence_Shimada2019'],'dt','fl');
[~,ia,ib]=intersect(dt,DT);
FL=NaN*ones(size(DT)); FL(ib)=fl(ia);
%figure; plot(LAT(ib),FL(ib),'o'); % test plot

load([filepath 'Data/pCO2_Shimada2019'],'dt','fco2');
[~,ia,ib]=intersect(dt,DT);
FCO2=NaN*ones(size(DT)); FCO2(ib)=fco2(ia);
%figure; plot(LON(ib),LAT(ib),'o'); % test plot

clearvars ia ib dt fl dt sal temp

save([filepath 'Data/environ_Shimada2019'],'DT','LON','LAT','TEMP','SAL','FL','FCO2');