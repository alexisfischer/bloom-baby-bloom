%% plot Shimada 2019 data 
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

filepath = '~/MATLAB/NOAA/Shimada/';
load([filepath 'Data/Shimada_HAB_2019'],'HA19');
HA19.Total_PNcellsmL=0.001*HA19.Total_PNcellsL;

%varname='pDAngL'; units='pDA (ng/L)'; lim=[1 2000]; HA19.pDAngL(HA19.pDAngL<0)=0;
varname='Total_PNcellsmL'; units='PN cells/mL'; lim=[1 40];
%varname='NitrateM'; units='Nitrate (uM)'; lim=[1 50];

figure('Units','inches','Position',[1 1 2 5],'PaperPositionMode','auto');
gb=geobubble(HA19,'Lat_dd','Lon_dd','SizeVariable',varname,...
    'Title','2019','Basemap','grayland','MapLayout','Maximized');
geolimits(gb,[33.5 49],[-125 -121]); grid off;
gb.SizeLegendTitle = units; 
gb.BubbleWidthRange = [2 15]; gb.SizeLimits=lim;

%
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'Figs/MappedDiscreteShimada2019_' varname '.tif']);
