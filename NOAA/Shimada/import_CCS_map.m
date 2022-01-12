clear
addpath(genpath('~/MATLAB/NOAA/Shimada/')); % add new data to search path
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/Misc-Functions/')); % add new data to search path

filepath = '~/MATLAB/NOAA/Shimada/';
filename='/Users/afischer/MATLAB/bloom-baby-bloom/Misc-Functions/m_map/data/gshhs_i.b';
C = gshhs(filename, [30 49], [-128 -120]);
L1=C([C.Level]==1);

coast(:,1)=[L1.Lon]; coast(:,2)=[L1.Lat];

save([filepath 'Data/coast_CCS','coast']);

%%
clear 
filepath = '~/MATLAB/NOAA/Shimada/';
load([filepath 'Data/coast_CCS','C']);
%states=load([filepath 'Data/USwestcoast_pol']);
load([filepath 'Data/Shimada_HAB_2019'],'HA19');
    
data=HA19.Chl_agL; lat = HA19.Lat_dd; lon = HA19.Lon_dd;
ii=~isnan(data+lat+lon);lon=lon(ii); lat=lat(ii); data=data(ii);   
[LON,LAT,DATA] = xyz2grid(lon,lat,data);
LON=round(LON,4); LAT=round(LAT,4);

%%
figure('Units','inches','Position',[1 1 2.5 5],'PaperPositionMode','auto');        
geoshow(LAT,LON,DATA,'DisplayType','texturemap'); hold on;
geoshow(C(land),'FaceColor',[.7 .7 .7]); hold on;
axis([-128 -120 34 49]);

%%
%plot(states(:,1),states(:,2),'k'); MapAspect(40); box on;




