%% plot Puget Sound map
%https://www.mathworks.com/help/map/converting-coastline-data-gshhs-to-shapefile-format.html
%https://www.ngdc.noaa.gov/mgg/shorelines/data/gshhg/latest/
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));


%% can't figure out how to get waterbody
mappath='~/Downloads/NHD_H_17110016_HU8_Shape/Shape/';
%Sw = shaperead([mappath 'NHDWaterbody.shp']);
Sw = readgeotable([mappath 'NHDWaterbody.shp']);

%%
% %%
% mappath='~/Downloads/WBD_17_HU2_Shape/Shape/';
% 
% figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');        
% 
% Sw = shaperead([mappath 'WBDHU12.shp'],'UseGeoCoords',true);
% 
% gx=geoaxes('Basemap','grayland');
% geoplot(gx,[Sw.Lat],[Sw.Lon],'color','w','linewidth',1.5); hold on
% geolimits(gx,[46.8 48.2],[-123.2 -122.2])
% 
% lat=[47.04571 48.08195 47.70521 47.39728 48.03791 48.0569];
% lon=[-122.90702 -123.04609 -122.62655 -122.43893 -122.86722 -122.69488];
% geoscatter(gx,lat,lon,35,'filled','k'); hold on
% 
% gx = gca; gx.Scalebar.Visible;
% gx.Scalebar.BackgroundAlpha = 1;

% %%
% m_proj('albers equal-area','lat',[48.5 46.8],'long',[-125 -122],'rect','on');
% m_gshhs_f('save',[filepath 'Figs/PugetSound_map']);
% load([filepath 'Figs/PugetSound_map'],'ncst');

%%
%%%% Puget Sound Map
figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');        
m_proj('albers equal-area','lat',[48.2 46.9],'long',[-123.3 -122.2],'rect','on'); hold on;

m_gshhs_f('patch',[.8 .8 .8],'edgecolor','none');  hold on;
m_grid('linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','top','yaxisloc','left','fontsize',12); hold on;  

m_usercoast([filepath 'Data/PNW_watershed'],'color','w','linewidth',1.5)

m_ruler(.05,[.02 .3],3,'ticklen',.02,'fontsize',10);

m_line(-122.90702,47.04571,'marker','.','markersize',12,'color','k');
m_text(-122.90702-.11,47.04571-.03,{'BI'},'fontsize',10);

m_line(-123.04609,48.08195,'marker','.','markersize',12,'color','k');
m_text(-123.04609-.13,48.08195-.03,{'SB'},'fontsize',10);

m_line(-122.62655,47.70521,'marker','.','markersize',12,'color','k');
m_text(-122.62655-.13,47.70521-.03,{'LB'},'fontsize',10);

m_line(-122.43893,47.39728,'marker','.','markersize',12,'color','k');
m_text(-122.43893-.13,47.39728-.03,{'QH'},'fontsize',10);

m_line(-122.86722,48.03791,'marker','.','markersize',12,'color','k');
m_text(-122.86722-.13,48.03791-.03,{'DB'},'fontsize',10);

m_line(-122.69488,48.0569,'marker','.','markersize',12,'color','k');
m_text(-122.69488-.13,48.0569-.03,{'MB'},'fontsize',10);

hold on;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Map_PugetSound.png'],'Resolution',300)    
hold off

%% BuddInlet Map
figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');        
m_proj('albers equal-area','lat',[47.13 47.04],'long',[-122.94 -122.88],'rect','on');

m_gshhs_f('patch',[.8 .8 .8],'edgecolor','none'); hold on
m_grid('linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','top','yaxisloc','left','fontsize',12);  

m_ruler(.05,[.02 .35],'ticklen',.01);

m_usercoast([filepath 'Data/PNW_watershed'],'color','w','linewidth',1.5)

m_line(-122.906843,47.047,'marker','.','markersize',12,'color','k');


%% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Map_BuddInlet.png'],'Resolution',300)    
hold off