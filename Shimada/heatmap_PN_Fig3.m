%% heatmap of IFCB-derived log10(Pseudo-nitzschia) abundance along CCS
% data options: Pseudo-nitzschia (PN), DA cell quota, DA/biovolume
% overlays location of discrete SEM samples
% option to plot scatter plot or heatmap (and change resolution)
% option to plot diatom biovolume
% Shimada 2019 and 2021
% Fig 3 in Fischer et al. 2024
% A.D. Fischer, May 2024
%
clear;

%%%%USER
fprint = 1; % 1 = print; 0 = don't
yr = 2021; % 2019; 2021
option = 1; % 1 = Plot the individual data points; 2 = Grid the data
res = 0.15; % heatmap resolution: Coarser = 0.2; Finer = 0.1 % Set grid resolution (degrees)
unit = 0.06; % amount to subtract from latitude so does not overlap with map
filepath = '~/Documents/MATLAB/bloom-baby-bloom/Shimada/';

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/summary_19-21Hake_cells'],'P'); %IFCB data
load([filepath 'Data/HAB_merged_Shimada19-21'],'HA'); %SEM data
load([filepath 'Data/coast_CCS'],'coast'); %map
states=load([filepath 'Data/USwestcoast_pol']); %map

P(~(P.DT.Year==yr),:)=[]; %select year of data
lat=P.LAT; lon=P.LON-unit; dt=P.DT;  

%%%%USER enter data of interest
data=log10(P.Pseudonitzschia); label={'log PN (cells/mL)'}; name='PN'; cax=[0 2]; col=brewermap(256,'YlOrBr'); col(1:30,:)=[];
%data=P.tox_PNcell; label={'pDA (fg/cell)'}; name='tox_cell'; cax=[0 200000]; col=brewermap(256,'Purples'); col(1:30,:)=[];

%%%% plot
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 4.7]); 

if option==1    
    scatter(lon,lat,15,data,'o','filled');  hold on
else
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
    pcolor(lon_plot-res/2,lat_plot-res/2,data_grid); % have to shift lat/lon for pcolor with flat shading     
    shading flat; hold on;
    clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res
end 

colormap(col); clim(cax);
axis([min(lon) max(lon) min(lat) max(lat)]);
h=colorbar('northoutside'); hp=get(h,'pos');    
set(h,'pos',hp,'xaxisloc','top','fontsize',9,'tickdir','out');
xtickangle(0); hold on;    
colorTitleHandle = get(h,'Title');
set(colorTitleHandle,'String',label,'fontsize',11);

% Plot map
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-126.6 -123.5],'xtick',-127:2:-124,...
    'xticklabel',{'127 W','125 W'},'yticklabel',...
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},...
    'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');

% overlay SEM data
HA.lon=HA.lon-unit;
sem=NaN*ones(size(HA.st));
HA=addvars(HA,sem,'after','dt');
HA((HA.lat<40),:)=[]; %remove CA stations
HA=HA(~isnan(HA.fx_frau),:); %remove non SEM samples
HA(~(HA.dt.Year==yr),:)=[]; %select year of data
H=flipud(HA); H.st2(:)=(1:1:length(H.st)); %order them top to bottom

scatter([H.lon],[H.lat],20,'o','k','MarkerFaceColor','none'); hold on
if yr==2019    
    text([H.lon]-0.4,[H.lat]-.1,num2str([H.st2]),'fontsize',8)
else
    text([H.lon]-0.6,[H.lat]-.15,num2str([H.st2]+9),'fontsize',8); % more spacing for 2 digits
end
hold on

if fprint
    exportgraphics(fig,[filepath 'Figs/' name '_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 
