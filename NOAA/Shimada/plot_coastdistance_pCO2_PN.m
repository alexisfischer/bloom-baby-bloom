%% dome shaped relationship
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');

%%
c=brewermap(3,'Set2');
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.5 5.3]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.1 0.04], [0.13 0.1]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, height, width} describes the inner and outer spacings.  
subplot(2,1,1)
scatter(P.coast_km,P.PCO2,16,c(3,:),'*','linewidth',1)
set(gca,'xlim',[0 110],'xtick',0:50:100,'xticklabel',{},...
    'ytick',0:400:1200,'tickdir','out','fontsize',10);
ylabel('pCO_2 (ppm)','fontsize',12)
axis square; box on;

subplot(2,1,2)
yyaxis left
scatter(P.coast_km,P.PN_cell,16,c(2,:),'o','linewidth',1.6)
set(gca,'ycolor','k')
ylabel('PN (cells/mL)','fontsize',12,'color','k')

yyaxis right
scatter(P.coast_km,P.pDA_pgmL,16,c(1,:),'^','linewidth',1.5)
set(gca,'xlim',[0 110],'xtick',0:50:100,'tickdir','out','ycolor','k');
xlabel('distance from shore (km)','fontsize',12)
ylabel('pDA (pg/mL)','fontsize',12,'color','k')
axis square; box on;

exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/distance_pCO2_PN_DA.png'],'Resolution',300)    
