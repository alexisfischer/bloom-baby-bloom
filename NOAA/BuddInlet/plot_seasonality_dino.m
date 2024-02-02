%% plot Dinophysis vs day of year
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/Misc-Functions/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));

load([filepath 'Data/BuddInlet_data_summary'],'T');
%T.day=day(T.dt,'dayofyear');
T.dino_fl=smoothdata(T.dino_fl,'movmean',2,'omitnan');

id1=(T.dt.Year==2021); id2=(T.dt.Year==2022); id3=(T.dt.Year==2023); 

figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.04], [0.1 0.1], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1); %dinophysis
scatter(T.dt(id1)+2*365,T.dino_fl(id1),20); hold on
scatter(T.dt(id2)+365,T.dino_fl(id2),20); hold on
scatter(T.dt(id3),T.dino_fl(id3),20); hold on
set(gca,'xlim',[datetime('15-Apr-2023') datetime('15-Dec-2023')],...
    'xaxislocation','top','fontsize', 10,'ytick',0:2:4,'tickdir','out','ycolor','k');  
    datetick('x','m'); box on; 
ylabel('dino/mL','fontsize',11)
legend('2021','2022','2023','fontsize', 10,'location','NE'); legend boxoff

subplot(2,1,2); %mesodinium
scatter(T.dt(id1)+2*365,T.meso_fl(id1),20); hold on
scatter(T.dt(id2)+365,T.meso_fl(id2),20); hold on
scatter(T.dt(id3),T.meso_fl(id3),20); hold on
set(gca,'xlim',[datetime('15-Apr-2023') datetime('15-Dec-2023')],...
   'fontsize', 10,'ylim',[0 10],'tickdir','out','ycolor','k');  
    datetick('x','m'); box on; 
ylabel('meso/mL','fontsize',11)
legend('2021','2022','2023','fontsize', 10,'location','NE'); legend boxoff

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/DinoMeso_dayofyear.png'],'Resolution',100)    
hold off
