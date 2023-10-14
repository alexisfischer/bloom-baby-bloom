%% plot BEUTI
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'NOAA/Shimada/Data/BEUTI_Shimada2019'],'B'); B19=B;
load([filepath 'NOAA/Shimada/Data/BEUTI_Shimada2021'],'B'); B21=B;
LAT=B.lat;
%LAT=(B.lat+.5);
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

exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/BEUTI_2019-2021_line.png'],'Resolution',300)    

%% line plot w errorbars
LAT=(Y+.5)';
c=brewermap(3,'RdBu');
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 1 4]); 
errorbar(M,LAT,STDV,'horizontal',':ks','markersize',3,'linewidth',1); hold on;
errorbar(CC1,LAT,S1,'horizontal','-o','markersize',3,'color',c(1,:),'markerfacecolor',c(1,:),'linewidth',1); hold on;
anserrorbar(CC2,LAT,S2,'horizontal','-^','markersize',3,'color',c(3,:),'linewidth',1); hold on;
xlabel('BEUTI (\muM/m/s)')
set(gca,'ylim',[39.9 49],'xlim',[0 40],'xtick',0:20:40,'fontsize',9,'tickdir','out');
exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/BEUTI_2019-2021_error.png'],'Resolution',300)    

%% pcolor
C=flipud([CC1,CC2]); 
LAT=fliplr([Y,Y(end)+1]);

fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 2.5 4]); 

imagesc(C,'AlphaData',~isnan(C)); hold on;

colormap('parula'); clim([0 20]); h=colorbar('eastoutside');   
axis tight; axis equal; 
set(gca,'Xtick',1:1:length(C),'xticklabel',[2019 2021],...
   'ylim',[.5 length(C)+.5],'ytick',.5:1:length(C)+.5,'yticklabel',...
    {'49 N','48 N','47 N','46 N','45 N','44 N','43 N','42 N','41 N','40 N'},...
    'fontsize',11,'tickdir','out')
title('BEUTI')  
%exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/BEUTI_2019-2021.png'],'Resolution',300)    



