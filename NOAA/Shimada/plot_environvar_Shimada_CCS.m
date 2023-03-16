%% map underway environmental data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2019; % 2019; 2021
option=2; % 1=Plot the individual data points; 2=Grid the data
fprint=1;

%%%% load in underway data
%type='underway';
%load([filepath 'NOAA/Shimada/Data/environ_Shimada' num2str(yr) ''],'DT','LON','LAT','TEMP','SAL','FL','PCO2');
%data=TEMP; cax=[10 20]; label='SST (^oC)'; name='SST';
%data=SAL; cax=[30 35]; label='Sal (psu)'; name='SAL';
%data=FL; cax=[0 5]; label={'Chl';'Fluorescence'}; name='FL';
%data=PCO2; cax=[0 800]; label={'PCO2 (ppm)'}; name='PCO2';

%%%% load in discrete data
type='discrete';
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
data=HA.chlA_ugL; cax=[0 20]; label={'Extracted';'Chl a (ug/L)'}; name='CHL';
%data=HA.pDA_ngL; cax=[0 300]; label='pDA (ng/L)'; name='PDA';
%data=HA.PNcellsmL; cax=[0 20]; label={'Pseudo-nitzschia';'(cells/mL)'}; name='PNcellsmL';
%data=HA.NitrateM; cax=[0 20]; label='Nitrate (M)'; name='NIT';
%data=HA.PhosphateM; cax=[0 3]; label='Phosphate (M)'; name='PHS';
%data=HA.SilicateM; cax=[0 70]; label='Silicate (M)'; name='SIL';

if yr==2019
    idx=find(HA.dt<datetime('01-Jan-2020'));
    data=data(idx); LAT = HA.lat(idx); LON = HA.lon(idx);  
elseif yr==2021
    idx=find(HA.dt>datetime('01-Jan-2020'));
    data=data(idx); LAT = HA.lat(idx); LON = HA.lon(idx);  
end

idx=isnan(data); data(idx)=[]; LAT(idx)=[]; LON(idx)=[];

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 5]); 

if option==1
    scatter3(LON,LAT,data,10,data,'filled'); 
    view(2); hold on
else
    % Set grid resolution (degrees)
    res = 0.2; % Coarser=0.2; Finer=0.1
    
    % Create grid
    lon_grid = min(LON):res:max(LON);
    lat_grid = min(LAT):res:max(LAT);
    nx = length(lon_grid);
    ny = length(lat_grid);
    
    % Average data on grid
    data_grid = nan(nx,ny);
    for ii = 1:nx
        for jj = 1:ny
            data_grid(ii,jj) = mean(data(LON>=lon_grid(ii)-res/2 & LON<lon_grid(ii)+res/2 & LAT>=lat_grid(jj)-res/2 & LAT<lat_grid(jj)+res/2),'omitnan');
        end
    end
    
    [lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);
    pcolor(lon_plot-res/2,lat_plot-res/2,data_grid) % have to shift lat/lon for pcolor with flat shading
    shading flat; hold on;
    clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res

end

    colormap(parula); caxis(cax);
    axis([min(LON) max(LON) min(LAT) max(LAT)]);
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 12;               
    hp=get(h,'pos'); 
    hp=[1.9*hp(1) .9*hp(2) .4*hp(3) .6*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); 
    hold on    

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol']);
load([filepath 'NOAA/Shimada/Data/coast_CCS'],'coast'); hold on
fillseg(coast); hold on; dasp(42); hold on;
plot(states(:,1),states(:,2),'k'); hold on;
set(gca,'ylim',[34 49],'xlim',[-127 -120],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);
    
if fprint
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_' type '_Shimada' num2str(yr) '.png'],'Resolution',100)    
end
hold off 