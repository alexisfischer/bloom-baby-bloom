%% plot Shimada 2019 data 
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
filepath = '/Users/afischer/MATLAB/';
load([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/class/summary_biovol_allTB2019'],...
    'filelistTB','class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB')

%%%% find lat lon coordinate of each file
load([filepath 'NOAA/Shimada/Data/IFCB_Lat_Lon_coordinates_2019'],'L');
lat=NaN*mdateTB; lon=NaN*mdateTB;
for i=1:length(filelistTB)
    idx=(strcmp(filelistTB(i), L.headerfile));      
    lat(i)=L.Lat_dd(idx);
    lon(i)=L.Lon_dd(idx);
end

idx=(strcmp('Pseudo-nitzschia', class2useTB));
PN=classcountTB(:,idx)./ml_analyzedTB;
PN(PN<1)=NaN; idx=isnan(PN); PN(idx)=[]; lat(idx)=[]; lon(idx)=[];
T=table(lat,lon,PN); 

figure('Units','inches','Position',[1 1 2 5],'PaperPositionMode','auto');
gb=geobubble(T,'lat','lon','SizeVariable','PN',...
    'Title','2019','Basemap','grayland','MapLayout','Maximized');
geolimits(gb,[33.5 49],[-125 -121]); grid off;
gb.SizeLegendTitle = 'PN cells/mL'; 
gb.BubbleWidthRange = [2 15]; gb.SizeLimits=[1 40];


set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'NOAA/Shimada/Figs/MappedIFCBShimada2019_PNcellsmL.tif']);
