%% map pcolor PN data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
classidxpath = [filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1;
unit=0.06;
yr=2021; % 2019; 2021
option=2; % 1=Plot the individual data points; 2=Grid the data
res = 0.15; % Coarser=0.2; Finer=0.1 % Set grid resolution (degrees)

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');

%data=P.PN_biovol./sum([P.diatom_biovol,P.dino_biovol],2); label={'fx PN biovol'}; name='fxPN'; cax=[0 .3];
data=P.PN_cell; label={'log PN (cells/mL)'}; name='PN'; cax=[0 2];
%data=P.diatom_biovol; label={'  diatom';'  bvl/mL'}; name='diatom'; cax=[1 7.3];
%data=P.tox_cell./1000; label={'Cellular DA (pg/cell)'}; name='tox_cell'; cax=[0 100]; 
%data=P.dino_diat_ratio; label={'dino:diat ratio'}; name='ratio'; cax=[0 1]; 

lat=P.LAT; lon=P.LON-unit; dt=P.DT;  
%col=brewermap(256,'YlGn'); col(1:30,:)=[];
col=brewermap(256,'YlOrBr'); col(1:30,:)=[];
%col=flipud(brewermap(256,'PiYG')); 

if yr==2019
    idx=find(dt<datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx);  
elseif yr==2021
    idx=find(dt>datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx); 
end

logdata=log10(data);
%logdata=(data);

%%%% plot
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 4.7]); 
%scatter(lon,lat,1,[.3 .3 .3],'o','filled'); hold on

if option==1    
    scatter(lon,lat,15,logdata,'o','filled');  hold on
    % scatter(lon(~ind),lat(~ind),15,logdata(~ind),'o','filled'); hold on
    % scatter(lon(ind),lat(ind),1,[.3 .3 .3],'o','filled'); hold on
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
            data_grid(ii,jj) = mean(logdata(lon>=lon_grid(ii)-res/2 & lon<lon_grid(ii)+res/2 & lat>=lat_grid(jj)-res/2 & lat<lat_grid(jj)+res/2),'omitnan');
        end
    end    
    [lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);
    h=pcolor(lon_plot-res/2,lat_plot-res/2,data_grid); % have to shift lat/lon for pcolor with flat shading     
    shading flat; hold on;
    clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res
end 

    colormap(col); clim(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('northoutside'); hp=get(h,'pos');    
    set(h,'pos',hp,'xaxisloc','top','fontsize',9,'tickdir','out');
    xtickangle(0); hold on;    
    hold on     

colorTitleHandle = get(h,'Title');
set(colorTitleHandle,'String',label,'fontsize',11);

    % Plot map
    states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
    load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
    fillseg(coast); dasp(42); hold on;
    plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-126.6 -123.5],'xtick',-127:2:-124,...
    'xticklabel',{'127 W','125 W'},'yticklabel',...
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},...
    'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');

load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA'); 
HA.lon=HA.lon-unit;
sem=NaN*ones(size(HA.st));
HA=addvars(HA,sem,'after','dt');
HA((HA.lat<40),:)=[]; %remove CA stations
HA=HA(~isnan(HA.fx_frau),:); %remove non SEM samples

if yr==2019
    idx=find(HA.dt<datetime('01-Jan-2020')); HA=HA(idx,:);    
    H=flipud(HA); H.st2(:)=(1:1:length(H.st)); %order them top to bottom
    scatter([H.lon],[H.lat],20,'o','k','MarkerFaceColor','none'); hold on
    text([H.lon]-0.4,[H.lat]-.1,num2str([H.st2]),'fontsize',8)
else
    idx=find(HA.dt>datetime('01-Jan-2020'));HA=HA(idx,:); 
    H=flipud(HA); H.st2(:)=(1:1:length(H.st)); %order them so 1:6, top to bottom
    scatter([H.lon],[H.lat],20,'o','k','MarkerFaceColor','none'); hold on
    text([H.lon]-0.6,[H.lat]-.15,num2str([H.st2]+9),'fontsize',8); hold on
end

if fprint
    exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/' name '_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 
