%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2021'; % '2023'
ydinolim=[0 5]; ymesolim=[0 10];
load([filepath 'Data/BuddInlet_data_summary'],'T');

figure('Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.06 0.11], [0.14 0.14]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-09-28'])];

subplot(5,1,1)
plot(T.dt,T.t1,':k','linewidth',2); hold on;
plot(T.dt,T.t3,'-k','linewidth',2); hold on;
    datetick('x', 'm', 'keeplimits');        
    set(gca,'xaxislocation','top','xlim',[xax(1) xax(2)],'ylim',[8 22],...
        'fontsize', 10,'tickdir','out','ycolor','k');   
    ylabel('^oC','fontsize',10,'color','k'); hold on;
    title(yr)
    legend('1.5m','3m','Location','NW'); legend boxoff;

subplot(5,1,2)
plot(T.dt,T.s1,':k','linewidth',2); hold on;
plot(T.dt,T.s3,'-k','linewidth',2); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},'ylim',[20 33],...
        'fontsize', 10,'tickdir','out','ycolor','k');   
    ylabel('ppt','fontsize',11,'color','k'); hold on;
   
subplot(5,1,3)
plot(T.dt,T.DeschutesCfs,'-k','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},'ylim',[0 1400],...
        'fontsize', 10,'tickdir','out','ycolor','k');   
    ylabel('cfs','fontsize',11,'color','k'); hold on;

subplot(5,1,4)
idx=find(isnan(T.dino)); val=0.1*ones(size(idx));
yyaxis left
plot(T.dt(idx),val,'ks','linewidth',.5,'markerfacecolor','k'); hold on;
plot(T.dt,T.meso,'k-','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ymesolim,'xticklabel',{},...
        'fontsize', 10,'tickdir','out','ycolor','k');  
    ylabel('meso','fontsize',11,'color','k'); hold on;  

yyaxis right
plot(T.dt,T.dino,'r-','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ydinolim,'xticklabel',{},...
        'fontsize', 10,'tickdir','out','ycolor','r');  
    ylabel('dino','fontsize',11,'color','r'); hold on;  

% idx=find(isnan(T.dino_fl)); val=0.1*ones(size(idx));
% plot(T.dt(idx),val,'ks','linewidth',.5,'markerfacecolor','k'); hold on;
% h=plot(T.dt,T.meso_fl,'k:',T.dt,T.meso_sc,'k-','linewidth',1.5); hold on;
%     set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 80],'xticklabel',{},...
%         'fontsize', 10,'tickdir','out','ycolor','k');  
%     ylabel('Mesodinium','fontsize',11,'color','k'); hold on;  
%     legend(h,'FL','SS','Location','NW'); legend boxoff;

subplot(5,1,5)
plot(T.dt,T.DST,'ko','Markersize',4,'linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 20],...
        'fontsize', 10,'tickdir','out');  
    ylabel('DST','fontsize',11); hold on;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_overview_' yr '.png'],'Resolution',100)    
hold off


