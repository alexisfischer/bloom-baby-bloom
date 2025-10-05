%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2022'; % '2023'
ydinolim=[0 4]; ymesolim=[0 10]; 
load([filepath 'Data/BuddInlet_data_summary'],'T','fli','dmatrix','ymatrix');

% only select data from year of interest
T(~(T.dt.Year==str2double(yr)),:)=[];
fli(~(fli.dt.Year==str2double(yr)),:)=[];
idx=~(dmatrix.Year==str2double(yr)); dmatrix(idx)=[]; ymatrix(:,idx)=[];

col=(brewermap(7,'Accent'));
c=[col(1,:);col(6,:);col(2,:);col(4,:);col(3,:);col(5,:);col(7,:);];
c(2,:)=[.1 .1 .1];

% Total Dinophysis
figure('Units','inches','Position',[1 1 2.5 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.08], [0.26 0.05]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(6,1,1); 
idx=~isnan(T.dinoML_microscopy);
dt=T.dt(idx); cell=T.dinoML_microscopy(idx);
Delta=diff(cell)./diff(datenum(dt));
plot(dt(1:end-1),Delta,':ko','Markersize',3,'markerfacecolor','w','linewidth',1); hold on;
hline(0,'k-'); hold on;
    set(gca,'xaxislocation','top','xlim',[xax(1) xax(2)],...
        'ylim',[-2 2],'ytick',-2:1:2,'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'\Delta Mcrspy';'(cells/mL)'},'fontsize',11); hold on;    
    datetick('x', 'm', 'keeplimits'); 
    title(yr,'fontsize', 10)     
   
subplot(6,1,2); 
idx=~isnan(T.dino_fl);
dt=T.dt(idx); ifcb=smooth(T.dino_fl(idx),2);
Delta=diff(ifcb)./diff(datenum(dt));
plot(dt(1:end-1),Delta,'-k','linewidth',1); hold on;
%figure; plot(T.dt(idx),T.dino_fl(idx),'k-',dt,ifcb,'r-');
hline(0,'k-'); hold on;
    set(gca,'xaxislocation','top','xticklabel',{},'xlim',[xax(1) xax(2)],...
        'ylim',[-2 2],'ytick',-2:2:2,'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'\Delta IFCB';'(cells/mL)'},'fontsize',11); hold on;    

subplot(6,1,3); 
idx=~isnan(T.dino_fl);
plot(T.dt(idx),cumsum(T.dino_fl(idx)),'-k','linewidth',1); hold on;
hline(0,'k-'); hold on;
    set(gca,'xaxislocation','top','xlim',[xax(1) xax(2)],...
        'ylim',[0 40],'ytick',0:20:40,'xticklabel',{},'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'cumulative';'(cells/mL)'},'fontsize',11); hold on;   

% subplot(4,1,2)
% idx=~isnan(T.DST_ngL);
% dt=T.dt(idx); quota=T.DST_pgcell(idx);
% Delta=diff(quota)./diff(datenum(dt));
% plot(dt(1:end-1),Delta,':ko','Markersize',3,'markerfacecolor','w','linewidth',1); hold on;
% hline(0,'k-'); hold on;
% set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},...
%         'ylim',[-1 1],'ytick',-1:1:1,'fontsize', 8,'tickdir','out','ycolor','k');
%     ylabel({'\Delta DST';'(pg/cell)'},'fontsize',11); hold on;    

subplot(6,1,4)
idx=~isnan(T.DST_ngL);
plot(T.dt(idx),cumsum(T.DST_ngL(idx)),':ko','Markersize',3,'markerfacecolor','w','linewidth',1); hold on;
hline(0,'k-'); hold on;
    set(gca,'xaxislocation','bottom','ylim',[0 150],'ytick',0:75:150,'xticklabel',{},...
        'xlim',[xax(1) xax(2)],'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'cumulative DST';'/(ng/L)'},'fontsize',11); hold on;

subplot(6,1,5)
idx=~isnan(T.DST_ngL);
dt=T.dt(idx); toxsum=T.DST_ngL(idx);
Delta=diff(toxsum)./diff(datenum(dt));
plot(dt(1:end-1),Delta,':ko','Markersize',3,'markerfacecolor','w','linewidth',1); hold on;
hline(0,'k-'); hold on;
set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'\Delta partic.'; 'DST (ng/L)'},'fontsize',11); hold on;   

subplot(6,1,6)
idx=~isnan(T.DST);
dt=T.dt(idx); DST=T.DST(idx);
Delta=diff(DST)./diff(datenum(dt));
plot(dt(1:end-1),Delta,':ko','Markersize',3,'markerfacecolor','w','linewidth',1); hold on;
hline(0,'k-'); hold on;
    set(gca,'xaxislocation','bottom','ylim',[-3 3],'ytick',-3:3:3,...
        'xlim',[xax(1) xax(2)],'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'\Delta DST'; '/100g muss.'},'fontsize',11); hold on;   
    datetick('x', 'm', 'keeplimits'); 
             
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_toxin_rate_' yr '.png'],'Resolution',300)    
hold off



