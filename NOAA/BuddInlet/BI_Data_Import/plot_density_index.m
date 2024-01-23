%% plot buoyancy frequency vs simple density difference
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/Misc-Functions/')); % add new data to search path

load([filepath 'Data/BuddInlet_data_summary'],'T');
load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');

figure('Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.06 0.09], [0.12 0.14]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

yr='2021';
subplot(3,1,1)
yyaxis left
    plot(T.dt,T.sigmat_diff,'k-'); hold on
    set(gca,'xlim',[datetime([yr '-05-01']) datetime([yr '-10-01'])],'ylim',[-5 8],'xaxislocation','top','fontsize',10,'ycolor','k'); 
    ylabel(yr,'fontsize',11)
yyaxis right
plot(dt,[B.N],'r*'); hold on
    set(gca,'xlim',[datetime([yr '-05-01']) datetime([yr '-10-01'])],'ylim',[0 .08],'ytick',0:.04:.08,...
        'ycolor','r','xaxislocation','top','fontsize',10); 

yr='2022';
subplot(3,1,2)
yyaxis left
    plot(T.dt,T.sigmat_diff,'k-'); hold on
    set(gca,'xlim',[datetime([yr '-05-01']) datetime([yr '-10-01'])],'ylim',[-5 8],'xticklabel',{},'fontsize',10,'ycolor','k'); 
    ylabel({'density index (rho @3m-1.5m)';yr},'fontsize',11)
yyaxis right
plot(dt,[B.N],'r*'); hold on
    set(gca,'xlim',[datetime([yr '-05-01']) datetime([yr '-10-01'])],'ylim',[0 .08],'ytick',0:.04:.08,...
        'ycolor','r','xticklabel',{},'fontsize',10); 
    ylabel('max buoyancy frequency (cycles/s)','fontsize',11)

yr='2023';
subplot(3,1,3)
yyaxis left
    plot(T.dt,T.sigmat_diff,'k-'); hold on
    set(gca,'xlim',[datetime([yr '-05-01']) datetime([yr '-10-01'])],'ylim',[-5 8],'xaxislocation','bottom','fontsize',10,'ycolor','k'); 
    ylabel(yr,'fontsize',11)
yyaxis right
plot(dt,[B.N],'r*'); hold on
    set(gca,'xlim',[datetime([yr '-05-01']) datetime([yr '-10-01'])],'ylim',[0 .08],'ytick',0:.04:.08,...
        'ycolor','r','xaxislocation','bottom','fontsize',10); 

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/DensityIndex_BI.png'],'Resolution',100)    
hold off


