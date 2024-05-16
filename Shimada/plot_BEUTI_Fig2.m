%% plot BEUTI during 2019 and 2021 Hake surveys along CCS
% data from https://mjacox.com/upwelling-indices/
% Fig. 2 in Fischer et al. 2024, L&O
% A.D. Fischer, May 2024
%
clear;

%%%%USER
filepath = '~/Documents/MATLAB/bloom-baby-bloom/Shimada/';

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/BEUTI_Shimada2019'],'B'); B19=B;
load([filepath 'Data/BEUTI_Shimada2021'],'B'); B21=B;
LAT=B.lat;
c=brewermap(6,'RdBu');

%%%% line plot
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 1.3 4]); 
axes('NextPlot', 'add');   % as: hold on
size(LAT);
patch([B19.mbeuti_all+B19.sdbeuti_all;flip(B19.mbeuti_all-B19.sdbeuti_all)],...
    [LAT;flip(LAT)],c(3,:),'FaceAlpha',.8,'EdgeColor','none');
patch([B21.mbeuti_all+B21.sdbeuti_all;flip(B21.mbeuti_all-B21.sdbeuti_all)],...
    [LAT;flip(LAT)],c(4,:),'FaceAlpha',.8,'EdgeColor','none');

plot(B19.mbeuti_yr,LAT,'-o','markersize',2,'color',c(1,:),'markerfacecolor',c(1,:),'linewidth',1); hold on;
plot(B21.mbeuti_yr,LAT,'-o','markersize',2,'color',c(end,:),'linewidth',1); hold on;
%legend(' ',' ',' ','Location','NW'); legend boxoff;
xlabel('BEUTI (\muM/m/s)')
set(gca,'ylim',[39.9 49],'xlim',[-3 35],'xtick',10:20:30,'xaxislocation','top','yticklabel',...
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},...
    'fontsize',9,'tickdir','out');
box on;

exportgraphics(fig,[filepath 'Figs/BEUTI_2019-2021_line.png'],'Resolution',300)    


