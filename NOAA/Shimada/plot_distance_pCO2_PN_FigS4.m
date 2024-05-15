%% plot relationship between PN, chl, pDA, and pCO2, with distance from shore
% reveals the "dome shaped" relationship
% Fig. S4 in Fischer et al. 2024, L&O
% A.D. Fischer, May 2024
%
clear;

%%%%USER
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/';

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/summary_19-21Hake_cells'],'P');
i19=(P.DT.Year==2019); 

%%%% plot
c=brewermap(2,'RdBu');
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.5 5.5]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.12 0.04], [0.21 0.18]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, height, width} describes the inner and outer spacings.  

subplot(4,1,1)
scatter(P.coast_km(~i19),P.PCO2(~i19),25,c(2,:),'.','linewidth',1); hold on
scatter(P.coast_km(i19),P.PCO2(i19),25,c(1,:),'.','linewidth',1); hold on
set(gca,'xlim',[0 110],'xtick',0:50:100,'xticklabel',{},...
    'ytick',0:400:1200,'ylim',[0 1200],'tickdir','out','fontsize',10);
ylabel('pCO_2 (ppm)','fontsize',12)
box on;

subplot(4,1,2)
scatter(P.coast_km(~i19),P.Pseudonitzschia(~i19),25,c(2,:),'.','linewidth',1); hold on
scatter(P.coast_km(i19),P.Pseudonitzschia(i19),25,c(1,:),'.','linewidth',1); hold on
set(gca,'xlim',[0 110],'xtick',0:50:100,'xticklabel',{},'tickdir','out');
ylabel('PN (cells/mL)','fontsize',12,'color','k')
box on;

subplot(4,1,3)
scatter(P.coast_km(~i19),P.chlA_ugL(~i19),10,c(2,:),'o','linewidth',1); hold on
scatter(P.coast_km(i19),P.chlA_ugL(i19),10,c(1,:),'o','linewidth',1); hold on
set(gca,'ylim',[0 20],'xlim',[0 110],'xtick',0:50:100,'xticklabel',{},...
    'tickdir','out','fontsize',10);
ylabel({'Chl a (\mug/L)'},'fontsize',12,'color','k')
box on;

subplot(4,1,4)
h21=scatter(P.coast_km(~i19),P.pDA_pgmL(~i19),10,c(2,:),'o','linewidth',1); hold on
h19=scatter(P.coast_km(i19),P.pDA_pgmL(i19),10,c(1,:),'o','linewidth',1); hold on
set(gca,'xlim',[0 110],'xtick',0:50:100,'tickdir','out');
xlabel('distance from shore (km)','fontsize',12)
ylabel('pDA (pg/mL)','fontsize',12)
box on;
legend([h19 h21],'2019','2021','Location','NE'); legend boxoff;

exportgraphics(fig,[filepath 'Figs/distance_pCO2_PN_DA.png'],'Resolution',300)    
