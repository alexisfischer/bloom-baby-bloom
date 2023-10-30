% matchup between cells/mL and cellular DA
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');

idx=find(P.DT<datetime('01-Jan-2020')); cells19=P.PN_cell(idx); tox19=P.tox_cell(idx)./1000; p19=P.PCO2(idx);
idx=find(P.DT>datetime('01-Jan-2020')); cells21=P.PN_cell(idx); tox21=P.tox_cell(idx)./1000; p21=P.PCO2(idx);

%%
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 6]); 
subplot(2,1,1)
scatter(P.LON,P.PCO2,'ks'); hold on
ylabel('pCO2','fontsize',12)
axis square

subplot(2,1,2)
scatter(P.LON,P.PN_cell); hold on
%scatter(P.LON,P.pDA_pgmL,'r^')
%legend('PN','pDA')
axis square
ylabel('PN','fontsize',12)
xlabel('longitude','fontsize',12)

%%
%%%% plot
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.5 6]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.04], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, height, width} describes the inner and outer spacings.  
col=brewermap(2,'RdBu');

subplot(2,1,1)
h1=plot(p19,cells19,'o','color',col(1,:),'markersize',4,'markerfacecolor',col(1,:)); hold on
h2=plot(p21,cells21,'o','color',col(2,:),'markersize',4,'markerfacecolor',col(2,:)); hold on
set(gca,'xlim',[0 800],'xtick',0:200:800,'xticklabel',{},'ylim',[0 100],'tickdir','out','fontsize',10)
ylabel('PN (cells/mL)','fontsize',12)
box on; axis square

subplot(2,1,2)
h1=plot(p19,tox19,'o','color',col(1,:),'markersize',4,'markerfacecolor',col(1,:)); hold on
h2=plot(p21,tox21,'o','color',col(2,:),'markersize',4,'markerfacecolor',col(2,:)); hold on
set(gca,'xlim',[0 800],'xtick',0:200:800,'ylim',[0 250],'tickdir','out','fontsize',10)
%legend([h1 h2],'2019','2021','Location','East')
ylabel('DA (pg/mL)','fontsize',12)
xlabel('pCO2 (ppm)','fontsize',12)
box on; axis square

exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/pCO2_PN_DA.png'],'Resolution',300)    
