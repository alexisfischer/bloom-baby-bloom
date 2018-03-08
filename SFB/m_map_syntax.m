% SF bay map
close all; clear all;
load('sfb.mat');

xax = [-122.6 -121.6]; yax=[37.4 38.3];


m_proj('albers equal-area','long',[-122.95 -121.4],'lat',[38.25 37.3],...
    'rect','on');

m_gshhs_h('save','coastline_SFbay'); 

figure('Units','inches','Position',[1 1 6 6],'PaperPositionMode','auto');

m_usercoast('coastline_SFbay','patch',[.6 .6 .6]);
m_grid('linest','none','linewidth',2,'tickdir','out','xaxisloc','top',...
    'yaxisloc','right');

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600','~/Documents/MATLAB/SantaCruz/Figs/SFbay_map.tif')
hold off

%% contour plot

lat=s(1).lat;
lon=s(1).long;
sal=s(1).sal;
ii=~isnan(sal+lat+lon);
lonok=lon(ii);latok=lat(ii);vvok=sal(ii);
    
% xx and yy are vectors that specifies the x and y coordinates,
% respectively, of the query points to be evaluated in Salt Pond. 
xx=[-122.95:.001:-121.62];
yy=[37.4:.001:38.2];

% zz fits a surface of the form v=f(lon,lat) to the scattered data in the
% vectors (lon,lat,sal). griddata interpolates the surface at the query 
% points specified by (xx,yy) and returns the interpolated value zz. The 
% surface always passes through the data points defined by lon and lat.
ii=~isnan(sal); % eliminates NaNs
%zz=griddata(lon(ii),lat(ii),sal(ii),xx,yy');
zz=griddata(lonok,latok,vvok,xx,yy');    

figure;
m_usercoast('coastline_SFbay','patch',[.6 .6 .6]);
m_grid('linest','none','linewidth',2,'tickdir','out','xaxisloc','top',...
    'yaxisloc','right');
m_contourf(xx,yy,zz);

%%

load stations_sfb.mat;

figure;
m_usercoast('coastline_SFbay','patch',[.6 .6 .6]);
m_grid('linest','none','linewidth',2,'tickdir','out','xaxisloc','top',...
    'yaxisloc','right');
hold on

% add station locations
m_plot(long,lat,'ko','markerfacecolor','r','markersize',5);
axis off; 
set(gca,'fontsize',10);

load stations_sfb.mat;

figure;
m_usercoast('coastline_SFbay','patch',[.6 .6 .6]);
m_grid('linest','none','linewidth',2,'tickdir','out','xaxisloc','top',...
    'yaxisloc','right');
hold on

% add station locations
m_plot(long,lat,'ko','markerfacecolor','r','markersize',5);
axis off; 
set(gca,'fontsize',10);

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600','~/Documents/MATLAB/SantaCruz/Figs/SFbay_map_st.tif')
hold off



%% 
%close all;
%load coastline_SFbay.mat
% ncst is the lat long coordinates

figure('Units','inches','Position',[1 1 3 3],'PaperPositionMode','auto'); clf;
fillseg([lon,lat]);
dasp(42); xlim([-122.62 -121.95]); ylim([37.4 38.2]);
set(gca,'fontsize',9,'tickdir','out','box','on','fontname','arial','xaxisloc','bottom');
hold on

%%
