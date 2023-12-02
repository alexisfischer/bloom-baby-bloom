%% fx composition of community
% who was dominant
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
classidxpath = [filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1;
yr=2019; % 2019; 2021

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_biovolume.mat'],'PB');

if yr==2019
    PB(PB.DT>datetime('01-Jan-2020'),:)=[];
elseif yr==2021
    PB(PB.DT<datetime('01-Jan-2020'),:)=[];
end

names=PB.Properties.VariableNames(2:21);
bvmL=timetable2table(PB(:,2:21));
bvmL(:,1)=[];
bvmL=table2array(bvmL);
lat=PB.LAT;

% Create grid
res = 0.2; %Set grid resolution (degrees)
lat_grid = min(lat):res:max(lat)+.5;
ny = length(lat_grid);
nx = size(bvmL,2);

% Average data on grid
data_grid = nan(ny,nx); 
for i = 1:nx
    data=bvmL(:,i);
    for j = 1:ny
        data_grid(j,i) = mean(data(lat>=lat_grid(j)-res/2 & lat<lat_grid(j)+res/2),'omitnan');
    end
end

% calculate fractions of bvmL
total=sum(data_grid,2);
fx = data_grid./total;

% reorder by highest fraction
col=brewermap(length(names),'Spectral');
rng("default"); idx=randperm(length(names));
col=col(idx,:);

t=sum(fx,1,'omitnan');
[~,i]=sort(t,'descend');
fxi=fx(:,i);
names=names(i);
col=col(i,:);

idx=contains(names,'Pseudo-nitzschia');
col(idx,:)=[0 0 0];

% find the dominant phytoplankton
fx_2=nanmean(fxi);
fx_PN=nanmean(fxi(:,idx));

clearvars i j nx ny data_grid total res lat data bvmL t

fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 6 5]); 
b=bar(lat_grid,fxi,'stacked','EdgeColor','none'); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:)); hold on;
end

set(gca,'ylim',[0 1],'ytick',.1:.1:1,'xlim',[39.9 49],'xtick',40:1:49,...
    'fontsize',9,'yaxislocation','right');
legend(names,'Location','EastOutside','fontsize',9);legend boxoff; hold on;
ylabel('fx of sample biomass','fontsize',10); hold on;
view([90 -90])

if fprint
    exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/FxCommunity_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 
