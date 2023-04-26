%% map underway environmental data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2021; % 2019; 2021
option=1; % 1=Plot the individual data points; 2=Grid the data
fprint=1;

%%%% load in discrete data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
data=HA.chlA_ugL; cax=[1 20]; label={'Extracted';'Chl a (ug/L)'}; name='CHL';
%data=HA.pDA_ngL; cax=[0 100]; label='pDA (ng/L)'; name='PDA';
%data=HA.PNcellsmL; cax=[0 20]; label={'Pseudo-nitzschia';'(cells/mL)'}; name='PNcellsmL';
%data=HA.NitrateM; cax=[0 20]; label='Nitrate (M)'; name='NIT';
%data=HA.PhosphateM; cax=[0 3]; label='Phosphate (M)'; name='PHS';
%data=HA.SilicateM; cax=[0 100]; label='Silicate (M)'; name='SIL';

    if yr==2019
        idx=find(HA.dt<datetime('01-Jan-2020'));
        data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx);  
    elseif yr==2021
        idx=find(HA.dt>datetime('01-Jan-2020'));
        data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx);  
    end

col=parula;
%col=brewermap([],'PuBu');
idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[];
lon=lon-.08;

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 4]); 
if option==1
    scatter3(lon,lat,data,30,data,'filled'); view(2); hold on
else
    % Set grid resolution (degrees)
    res = 0.3; % Coarser=0.2; Finer=0.1
    
    % Create grid
    lon_grid = min(lon):res:max(lon);
    lat_grid = min(lat):res:max(lat);
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
    pcolor(lon_plot-res/2,lat_plot-res/2,data_grid) % have to shift lat/lon for pcolor with flat shading
    shading flat; hold on;
  %  clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res

end
    colormap(col); caxis(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('east'); h.Label.String = label;              
    hp=get(h,'pos'); 
    % hp=[3.2*hp(1) hp(2) .4*hp(3) .6*hp(4)]; % [left, bottom, width, height].
    % set(h,'pos',hp,'xaxisloc','top','fontsize',9); h.Label.FontSize = 12;     
    hp=[.9*hp(1) 2.6*hp(2) .8*hp(3) .25*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','left','fontsize',9); h.Label.FontSize = 12;  
    hold on    

    % h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 12;               
    % hp=get(h,'pos'); 
    % hp=[1.9*hp(1) .9*hp(2) .4*hp(3) .6*hp(4)]; % [left, bottom, width, height].

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.8 49],'xlim',[-127 -120],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);

if fprint==1
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_discrete_Shimada' num2str(yr) '.png'],'Resolution',100)    
end
hold off 