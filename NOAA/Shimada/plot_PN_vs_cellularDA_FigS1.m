%% scatter plot of PN vs cellular DA and distance between samples
% Fig. S1 in Fischer et al. 2024, L&O
% A.D. Fischer, May 2024
%
clear;

%%%%USER
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/';
addpath(genpath(filepath)); % add new data to search path

% load in data and split into 2019 and 2021
load([filepath 'Data/summary_19-21Hake_4nicheanalysis'],'P');
idx=(P.DT.Year==2019); cells19=P.PN_cell(idx); tox19=P.tox_cell(idx)./1000; km19=P.gap_km(idx);
idx=(P.DT.Year==2021); cells21=P.PN_cell(idx); tox21=P.tox_cell(idx)./1000; km21=P.gap_km(idx);

%%%% plot
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 7 2.7]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.16 0.04], [0.12 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, height, width} describes the inner and outer spacings.  
col=brewermap(2,'RdBu');

subplot(1,3,1)
plot(km19,tox19,'o','color',col(1,:),'markersize',4,'markerfacecolor',col(1,:)); hold on
plot(km21,tox21,'o','color',col(2,:),'markersize',4,'markerfacecolor',col(2,:)); hold on

set(gca,'yscale','log','xlim',[0 4],'xtick',0:1:4,'ylim',[5*10^-2 10^3],...
    'ytick',[10^-1 10^0 10^1 10^2 10^3],'tickdir','out','fontsize',10)
xlabel('Sample gap (km)','fontsize',12)
ylabel('Cellular DA (pg/cell)','fontsize',12)
box on; axis square

subplot(1,3,2)
h1=plot(cells19,tox19,'o','color',col(1,:),'markersize',4,'markerfacecolor',col(1,:)); hold on
h2=plot(cells21,tox21,'o','color',col(2,:),'markersize',4,'markerfacecolor',col(2,:)); hold on

set(gca,'yscale','log','xscale','log','ylim',[5*10^-2 10^3],'ytick',[10^-1 10^0 10^1 10^2 10^3],...
    'xlim',[10^-1 10^2],'xtick',[10^-1 10^0 10^1 10^2],'tickdir','out','yticklabel',{},'fontsize',10)
legend([h1 h2],'2019','2021')
xlabel('PN (cells/mL)','fontsize',12)
box on; axis square

subplot(1,3,3)
plot([1 1],[.6 3.61],'k-','linewidth',2); hold on
plot([2 2],[.5 3.3],'k-','linewidth',2); hold on
plot([3 3],[12 37],'k-','linewidth',2); hold on
plot([4 4],[10^-1 8*10^2],'k-','linewidth',2); hold on

set(gca,'yscale','log','ylim',[5*10^-2 10^3],'ytick',[10^-1 10^0 10^1 10^2 10^3],...
    'xlim',[0 5],'tickdir','out','yticklabel',{},'fontsize',10)
box on; axis square

exportgraphics(fig,[filepath 'Figs/CellularToxicity.png'],'Resolution',300)    
