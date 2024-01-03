%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

yr='2022';
load([filepath 'Data/BuddInlet_data_summary'],'T');

figure('Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.06 0.11], [0.14 0.14]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-09-28'])];

subplot(4,1,1)
plot(T.dt,T.t1,':k','linewidth',2); hold on;
plot(T.dt,T.t3,'-k','linewidth',2); hold on;
    datetick('x', 'm', 'keeplimits');        
    set(gca,'xaxislocation','top','xlim',[xax(1) xax(2)],...
        'fontsize', 11,'tickdir','out','ycolor','k');   
    ylabel('^oC','fontsize',12,'color','k'); hold on;
    title(yr)
    legend('1.5m','3m','Location','NW'); legend boxoff;

subplot(4,1,2)
plot(T.dt,T.s1,':k','linewidth',2); hold on;
plot(T.dt,T.s3,'-k','linewidth',2); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 11,'tickdir','out','ycolor','k');   
    ylabel('ppt','fontsize',12,'color','k'); hold on;
   
subplot(4,1,3)
plot(T.dt,T.DeschutesCfs,'-k','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 11,'tickdir','out','ycolor','k');   
    ylabel('cfs','fontsize',12,'color','k'); hold on;

subplot(4,1,4)
idx=find(isnan(T.dino_fl)); val=0.1*ones(size(idx));
c=brewermap(2,'RdBu'); 
yyaxis left
plot(T.dt(idx),val,'ks','linewidth',.5,'markerfacecolor','k'); hold on;
plot(T.dt,T.dino_fl,'-','Color',c(1,:),'linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 7],...
        'fontsize', 11,'tickdir','out','ycolor',c(1,:));   
    ylabel('Dinophysis','fontsize',12,'color',c(1,:)); hold on;    
yyaxis right
plot(T.dt,T.meso_fl,'-','Color',c(2,:),'linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 80],...
        'fontsize', 11,'tickdir','out','ycolor',c(2,:));  
    ylabel('Mesodinium','fontsize',12,'color',c(2,:)); hold on;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_overview_' yr '.png'],'Resolution',100)    
hold off


