%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

ydinolim=[0 8];
load([filepath 'Data/BuddInlet_data_summary'],'T');
load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');

figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.1 0.1], [0.11 0.1]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1)
yr='2022';
xax=[datetime(['' yr '-05-01']) datetime(['' yr '-09-26'])];
idx=find(isnan(T.dino_fl)); val=0.1*ones(size(idx));
plot(T.dt(idx),val,'k.','linewidth',10,'markerfacecolor','k'); hold on;
hm=plot(T.dt,T.dinoML_microscopy,'ro','MarkerSize',4); hold on;
h1=plot(T.dt,T.dino_sc,'k-',T.dt,T.dino_fl,'k:','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ydinolim,'xticklabel',{},...
        'fontsize', 10,'tickdir','out','ycolor','k');  
    ylabel(yr,'fontsize',11); hold on;   
    title('Dinophysis (cells/mL)')
    legend([hm;h1],'mcrspy','ifcb sc','ifcb fl','location','NW'); legend boxoff;

subplot(2,1,2)
yr='2023';
xax=[datetime(['' yr '-05-01']) datetime(['' yr '-09-26'])];
idx=find(isnan(T.dino_fl)); val=0.1*ones(size(idx));
plot(T.dt(idx),val,'k.','linewidth',10,'markerfacecolor','k'); hold on;
hm=plot(T.dt,T.dinoML_microscopy,'ro','MarkerSize',4); hold on;
h1=plot(T.dt,T.dino_sc,'k-',T.dt,T.dino_fl,'k:','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ydinolim,...
        'fontsize', 10,'tickdir','out','ycolor','k');  
    ylabel(yr,'fontsize',11); hold on;   

    % set figure parameters
exportgraphics(gcf,[filepath 'Figs/Dinophysis_IFCB_sc_fl_microscopy.png'],'Resolution',100)    
hold off

