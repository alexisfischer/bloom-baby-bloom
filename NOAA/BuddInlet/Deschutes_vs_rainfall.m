%% Agreement between Deschutes R. flow and rainfall at Olympia Airport
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2022'; % '2023'
ydinolim=[0 4]; ymesolim=[0 10]; 
load([filepath 'Data/BuddInlet_data_summary'],'T');
load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');

figure('Units','inches','Position',[1 1 5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.1 0.1], [0.14 0.12]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-05-01']) datetime(['' yr '-10-01'])];

subplot(2,1,1)
plot(T.dt,T.s1,'-k','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},'ylim',[19 33],...
        'fontsize', 10,'tickdir','out','ycolor','k');   
    ylabel('ppt','fontsize',11,'color','k'); hold on;
    title(yr,'fontsize', 12)    

subplot(2,1,2)
yyaxis left
plot(T.dt,T.DeschutesCfs,'-b','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 1000],...
        'fontsize', 10,'tickdir','out','ycolor','b');   
    ylabel({'Deschutes (cfs)'},'fontsize',11,'color','b'); hold on;    
yyaxis right
plot(T.dt,T.PRCP,'-r','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 30],...
        'fontsize', 10,'tickdir','out','ycolor','r');   
    ylabel({'precipitation'},'fontsize',11,'color','r'); hold on;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Precip_vs_deschutes_' yr '.png'],'Resolution',100)    
hold off

    
