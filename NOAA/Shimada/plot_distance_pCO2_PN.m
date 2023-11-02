%% dome shaped relationship
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');

i19=(P.DT<datetime('01-Jan-2020')); 

%%%% split data by yr
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
scatter(P.coast_km(~i19),P.PN_cell(~i19),25,c(2,:),'.','linewidth',1); hold on
scatter(P.coast_km(i19),P.PN_cell(i19),25,c(1,:),'.','linewidth',1); hold on
set(gca,'xlim',[0 110],'xtick',0:50:100,'xticklabel',{},'tickdir','out');
ylabel('PN (cells/mL)','fontsize',12,'color','k')
box on;

subplot(4,1,3)
scatter(P.coast_km(~i19),P.chlA_ugL(~i19),10,c(2,:),'o','linewidth',1); hold on
scatter(P.coast_km(i19),P.chlA_ugL(i19),10,c(1,:),'o','linewidth',1); hold on
%scatter(P.coast_km(~i19),P.FL(~i19),20,c(2,:),'.','linewidth',1); hold on
%scatter(P.coast_km(i19),P.FL(i19),20,c(1,:),'.','linewidth',1); hold on
%scatter(P.coast_km(~i19),sum([P.diatom_biovol(~i19),P.dino_biovol(~i19)],2),20,c(2,:),'.','linewidth',1); hold on
%scatter(P.coast_km(i19),sum([P.diatom_biovol(i19),P.dino_biovol(i19)],2),20,c(1,:),'.','linewidth',1); hold on
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


exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/distance_pCO2_PN_DA.png'],'Resolution',300)    

%% split by region
iJ=(P.LAT>48);
iH=(P.LAT>43 & P.LAT<45);
iT=(P.LAT<43);

% subplot(3,1,2)
% scatter(P.coast_km(iJ),P.PN_cell(iJ),14,c(1,:),'d','linewidth',1); hold on;
% scatter(P.coast_km(iH),P.PN_cell(iH),14,c(2,:),'*','linewidth',1); hold on;
% scatter(P.coast_km(iT),P.PN_cell(iT),14,c(3,:),'o','linewidth',1); hold on;
% set(gca,'xlim',[0 110],'xtick',0:50:100,'xticklabel',{},...
%     'tickdir','out','fontsize',10);
% legend('JDF','HB','TH'); legend boxoff;
% ylabel('PN (cells/mL)','fontsize',12,'color','k')
% box on;
%%
c=brewermap(3,'Set2');
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.5 4.]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.12 0.04], [0.21 0.18]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, height, width} describes the inner and outer spacings.  

subplot(2,1,1)
scatter(P.coast_km,P.PCO2,14,'ko','linewidth',1)
set(gca,'xlim',[0 110],'xtick',0:50:100,'xticklabel',{},...
    'ytick',0:400:1200,'ylim',[0 1200],'tickdir','out','fontsize',10);
ylabel('pCO_2 (ppm)','fontsize',12)
box on;

subplot(2,1,2)
yyaxis left
scatter(P.coast_km,P.PN_cell,14,c(2,:),'ko','linewidth',1)
set(gca,'ycolor','k')
ylabel('PN (cells/mL)','fontsize',12,'color','k')

yyaxis right
scatter(P.coast_km,P.pDA_pgmL,14,'r^','linewidth',1)
set(gca,'xlim',[0 110],'xtick',0:50:100,'tickdir','out','ycolor','r');
xlabel('distance from shore (km)','fontsize',12)
ylabel('pDA (pg/mL)','fontsize',12,'color','r')
box on;

%exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/distance_pCO2_PN_DA.png'],'Resolution',300)    

%%

% subplot(3,1,2)
% scatter(P.coast_km,P.chlA_ugL,14,'ko','linewidth',1)
% set(gca,'xlim',[0 110],'xtick',0:50:100,'xticklabel',{},...
%     'ytick',0:20:40,'ylim',[0 43],'tickdir','out','fontsize',10);
% ylabel('Chl a (ug/L)','fontsize',12,'color','k')
% box on;

%% older
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

