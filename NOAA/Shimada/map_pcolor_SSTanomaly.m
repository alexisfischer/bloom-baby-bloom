%% plot SST anomalies during 2019 and 2021 Hake survey
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2019; % 2019; 2021
fprint=1;
res=0.2; % Coarser=0.2; Finer=0.1 % Set grid resolution (degrees)
cax=[-4 4]; ticks=-4:4:4; col=flipud(brewermap(256,'RdBu')); 

%%%% load in  data
load([filepath 'NOAA/Shimada/Data/sstA_Shimada' num2str(yr) ''],'A');
A(isnan(A.sstA),:)=[];
lat=A.lat; lon=A.lon; data=A.sstA;

% Create grid
lon_grid = min(lon):res:max(lon)+.5;
lat_grid = min(lat):res:max(lat)+.5;
nx = length(lon_grid);
ny = length(lat_grid);

% Average data on grid
data_grid = nan(nx,ny);
for ii = 1:nx
    for jj = 1:ny
        data_grid(ii,jj) = mean(data(lon>=lon_grid(ii)-res/2 & lon<lon_grid(ii)+res/2 & lat>=lat_grid(jj)-res/2 & lat<lat_grid(jj)+res/2),'omitnan');
    end
end
[lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 4.7]); 

pcolor(lon_plot-res/2,lat_plot-res/2,data_grid) % have to shift lat/lon for pcolor with flat shading
shading flat; hold on;
%contour(lon_plot-res/2,lat_plot-res/2,data_grid,[2.5 2.5],'k-');

%clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid 

colormap(col); clim(cax);
axis([min(lon) max(lon) min(lat) max(lat)]);
%%
h=colorbar('northoutside','xtick',ticks); hp=get(h,'pos');    
set(h,'pos',hp,'xaxisloc','top','fontsize',9,'tickdir','out');
%h=colorbar('east'); hp=get(h,'pos');     
%hp=[0.9*hp(1) 1*hp(2) .6*hp(3) .25*hp(4)]; % [left, bottom, width, height].
%set(h,'pos',hp,'xaxisloc','left','fontsize',9);
hold on     

colorTitleHandle = get(h,'Title');
set(colorTitleHandle,'String',{'SST anomaly (^oC)'},'fontsize',11);

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); 
dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;

    set(gca,'ylim',[39.9 49],'xlim',[-127 -122.3],'xtick',-127:2:-122,...
        'xticklabel',{'127 W','125 W','123 W'},'yticklabel',...
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');    
   text(-124.25,47.75,{'JF';'Eddy'},'fontsize',9); hold on
   text(-123.85,46.2,{'Colum.';'River'},'fontsize',9); hold on
   text(-124,44,{'Heceta';'Bank'},'fontsize',9); hold on
   text(-124,41.65,{'Trinidad';' Head'},'fontsize',9); hold on
   xtickangle(0); hold on;    

if fprint==1
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/SSTanomaly_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 