%% plot nutrients in Budd Inlet 
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2022'; % '2023'
ydinolim=[0 4]; ymesolim=[0 10]; 
load([filepath 'Data/BuddInlet_data_summary'],'T');
%load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');
load([filepath 'Data/LOTT_nutrients'],'dt','NH3_mgL','NO3NO2_mgL','TKN_mgL');

idx=find(~isnan(T.meso_fl)); mesof=T.meso_fl(idx); dtf=T.dt(idx);

%%%% plot BI and LOTT nutrients
figure('Units','inches','Position',[1 1 5 4.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.1 0.07], [0.14 0.12]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(4,1,1)
yyaxis left
idx=find(isnan(T.dino_fl)); val=0.1*ones(size(idx));
h1=plot(T.dt,T.dino_fl,'k-','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ydinolim,'ytick',0:2:4,...
        'fontsize', 10,'tickdir','out','ycolor','k');  
    ylabel({'dino/mL'},'fontsize',11); hold on;   
yyaxis right
if strcmp(yr,'2021')
    iend=find(~isnan(T.dino_fl),1); 
    dti=datetime('01-Apr-2021'):1:datetime(T.dt(iend-1)); 
    val=0.1*ones(size(dti));
    plot(dti,val,'ks','linewidth',.5,'markersize',5,'markerfacecolor','k'); hold on;
else
    plot(T.dt(idx),val,'ks','linewidth',.5,'markersize',5,'markerfacecolor','k'); hold on;    
end

    h2=plot(dtf,mesof,'--r.','Linewidth',1); hold on;
    set(gca,'xaxislocation','top','xlim',[xax(1) xax(2)],'ylim',ymesolim,'ytick',0:5:10,...
        'fontsize', 10,'tickdir','out','ycolor','r');  
    ylabel({'meso/mL'},'fontsize',11); hold on;      

subplot(4,1,2)
yyaxis left
errorbar(T.dt(~isnan(T.NH3_avg)),T.NH3_avg(~isnan(T.NH3_avg)),...
    T.NH3_std(~isnan(T.NH3_avg)),'.-k','linewidth',1); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},'ylim',[0 23],'fontsize',10,'tickdir','out','ycolor','k');   
    ylabel('NH_3 (uM)','fontsize',11,'color','k'); hold on;
yyaxis right
plot(dt(~isnan(NH3_mgL)),NH3_mgL(~isnan(NH3_mgL)),'b:','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},'ylim',[0 .4],...
        'fontsize',10,'tickdir','out','ycolor','b');   
    ylabel('LOTT (mg/L)','fontsize',11,'color','b'); hold on;

subplot(4,1,3)
yyaxis left
errorbar(T.dt(~isnan(T.NO3_avg)),T.NO3_avg(~isnan(T.NO3_avg)),...
    T.NO3_std(~isnan(T.NO3_avg)),'.-k','linewidth',1); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},'ylim',[0 20],'fontsize', 10,'tickdir','out','ycolor','k');   
    ylabel('NO_3 (uM)','fontsize',11,'color','k'); hold on;
yyaxis right
plot(dt(~isnan(NO3NO2_mgL)),NO3NO2_mgL(~isnan(NO3NO2_mgL)),'b:','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 5],'xticklabel',{},...
        'fontsize',10,'tickdir','out','ycolor','b');   
    ylabel('LOTT (mg/L)','fontsize',11,'color','b'); hold on; 

subplot(4,1,4)
    errorbar(T.dt(~isnan(T.Urea_avg)),T.Urea_avg(~isnan(T.Urea_avg)),...
    T.Urea_std(~isnan(T.Urea_avg)),'.-k','linewidth',1); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 5],'fontsize', 10,'tickdir','out','ycolor','k');   
    ylabel('Urea (uM)','fontsize',11,'color','k'); hold on;    

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Nutrients_BI_' yr '.png'],'Resolution',100)    
hold off

%% plot LOTT with Dinophysis populations
figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.1 0.07], [0.14 0.12]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime('2021-04-01') datetime('2023-10-01')];

subplot(2,1,1)    
h=plot(dt(~isnan(NH3_mgL)),NH3_mgL(~isnan(NH3_mgL)),'-',...
    dt(~isnan(NO3NO2_mgL)),NO3NO2_mgL(~isnan(NO3NO2_mgL)),'-',...
    dt(~isnan(TKN_mgL)),TKN_mgL(~isnan(TKN_mgL)),'-'); hold on;
ylabel('LOTT Effluent (mg/L)','fontsize',11)
    datetick('x','yyyy'); box on;         
set(gca,'xaxislocation','top','fontsize',10,'xlim',[xax(1) xax(2)])
legend([h(1) h(2) h(3)],'NH_3','NO_3+NO_2','TKN','Location','NW','fontsize',10); legend boxoff

subplot(2,1,2)
yyaxis left
idx=find(isnan(T.dino_fl)); val=0.1*ones(size(idx));
h1=plot(T.dt,T.dino_fl,'k-','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ydinolim,'ytick',0:2:4,...
        'fontsize', 10,'tickdir','out','ycolor','k');  
    ylabel({'dino/mL'},'fontsize',11); hold on;   
yyaxis right
    plot(T.dt(idx),val,'s','color',[.5 .5 .5],'linewidth',.5,'markersize',5,'markerfacecolor','k'); hold on;    
    plot(dtf,mesof,'--r.','Linewidth',1); hold on;
    datetick('x','yyyy'); box on;         
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],'ylim',ymesolim,'ytick',0:5:10,...
        'fontsize', 10,'tickdir','out','ycolor','r'); 
    ylabel({'meso/mL'},'fontsize',11); hold on;  

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/LOTT_Nutrients.png'],'Resolution',100)    
hold off
