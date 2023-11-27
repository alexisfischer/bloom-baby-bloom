%% fx composition of community
% who was dominant
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
classidxpath = [filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1;
yr=2021; % 2019; 2021

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');

if yr==2019
    idx=find(P.DT>datetime('01-Jan-2020'));
    P(idx,:)=[];
elseif yr==2021
    idx=find(P.DT<datetime('01-Jan-2020'));
    P(idx,:)=[];
end

%diat=mean(P.diatom_biovol./(P.dino_biovol+P.diatom_biovol));

names=P.Properties.VariableNames([19:37,42]);
cells=timetable2table(P(:,[19:37,42]));
cells(:,1)=[];
cells=table2array(cells);
lat=P.LAT;

% Create grid
res = 0.2; %Set grid resolution (degrees)
lat_grid = min(lat):res:max(lat)+.5;
ny = length(lat_grid);
nx = size(cells,2);

% Average data on grid
data_grid = nan(ny,nx); 
for i = 1:nx
    data=cells(:,i);
    for j = 1:ny
        data_grid(j,i) = mean(data(lat>=lat_grid(j)-res/2 & lat<lat_grid(j)+res/2),'omitnan');
    end
end

% calculate fractions of cells
total=sum(data_grid,2);
fx = data_grid./total;

% reorder by highest fraction
t=sum(fx,1,'omitnan');
[~,i]=sort(t,'descend');
fxi=fx(:,i);
names=names(i);

col=brewermap(length(names),'Spectral');
col=col(i,:);
idx=contains(names,'PN_cell');
col(idx,:)=[0 0 0];

% find the dominant phytoplankton
fx_2=nanmean(fxi);
fx_PN=nanmean(fxi(:,idx));

clearvars i j nx ny data_grid total res lat data cells t

fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 6 5]); 
b=bar(lat_grid,fxi,'stacked','EdgeColor','none'); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:)); hold on;
end

set(gca,'ylim',[0 1],'ytick',.1:.1:1,'xlim',[39.9 49],'xtick',40:1:49,...
    'fontsize',9,'yaxislocation','right');
legend(names,'Location','EastOutside','fontsize',9);legend boxoff; hold on;
ylabel('fx of sample','fontsize',10); hold on;
view([90 -90])

if fprint
    exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/FxCommunity_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 
