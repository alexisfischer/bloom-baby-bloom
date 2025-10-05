%% plot Sequim Bay 12 hr study
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

load([filepath 'Data/Sequim_12hr'],'Tide','Dino','S');
load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');

% %% statistics to test if same Dinophysis counts at each depth
% 
% [p,tbl,stats] = anova1([Dino.D0m,Dino.D05m,Dino.D15m,Dino.D25m]);
% Fstat = tbl{2,5}
% 
% (F(3,16)=1.45,p=0.26)

%%%% Dinophysis vs Time
figure('Units','inches','Position',[1 1 3.5 2.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.11], [0.16 0.24]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

yyaxis left
h=plot(Dino.dt,[Dino.D0m Dino.D05m Dino.D15m Dino.D25m],'*-','Markersize',4,'linewidth',1); hold on;
set(h(2),'Marker','^'); set(h(3),'Marker','o'); set(h(4),'Marker','s');
c=brewermap(4,'Set1');
    for i=1:length(h), set(h(i),'Color',c(i,:)); end  
    set(gca,'ylim',[0 15],'ytick',0:5:15,...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel('Ccells/mL','fontsize',10); hold on;

yyaxis right
ht=plot(Tide.dt,Tide.Heightm,':k','linewidth',1.5); hold on;
    set(gca,'xlim',[datetime('12-Aug-2014 07:00') datetime('12-Aug-2014 20:00')],'ylim',[-.35 3],'ytick',0:1:3,...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel({'Tidal Height (m)'},'fontsize',10); hold on;  
    lh=legend([h(1),h(2),h(3),h(4)],'0 m','0.5 m','1.5 m','2.5 m','Location','NorthWest');
    lh.FontSize = 9; legend boxoff; hold on      

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Sequim12hrDinophysis.png'],'Resolution',300)    
hold off

%% T-S profiles
%only select data in August
idx=find(dt.Month==8); data=[B(:,idx)]; dt=dt(idx);

figure('Units','inches','Position',[1 1 5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.04 0.13], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

col=brewermap(length(data)+4,'YlOrRd'); col(1:4,:)=[];

subplot(1,4,1);
for i=1:length(data)
    idx = ~isnan(data(i).fl);    
    h(i)=plot(data(i).fl(idx),data(i).z(idx),'-','Color',col(i,:),'linewidth',1); hold on
end
plot(S.fl,S.z,'k-','linewidth',1.5); hold on
%h=plot(mean([data.fl],2,'omitnan'),[data(1).z],'k--','linewidth',2);
set(gca,'ylim',[0 6],'xlim',[0 10],'Ydir','reverse','xaxislocation','top','fontsize',9,'Tickdir','out');
xlabel('Chl (rfu)','fontsize',10);
ylabel('depth (m)','fontsize',10);

subplot(1,4,2);
for i=1:length(data)
    idx = ~isnan(data(i).CT);    
    h(i)=plot(data(i).CT(idx),data(i).z(idx),'-','Color',col(i,:),'linewidth',1); hold on
end
plot(S.CT,S.z,'k-','linewidth',1.5); hold on
set(gca,'ylim',[0 6],'xlim',[10 23],'Ydir','reverse','xaxislocation','top','yticklabel',{},'fontsize',9,'Tickdir','out');
xlabel('CT (^oC)','fontsize',10);

subplot(1,4,3);
for i=1:length(data)
    idx = ~isnan(data(i).SA);        
    h(i)=plot(data(i).SA(idx),data(i).z(idx),'-','Color',col(i,:),'linewidth',1); hold on
end
plot(S.SA,S.z,'k-','linewidth',1.5); hold on
set(gca,'ylim',[0 6],'xlim',[0 33],'xtick',0:15:30,'Ydir','reverse','xaxislocation','top',...
    'yticklabel',{},'fontsize',9,'Tickdir','out');
xlabel('SA (ppt)','fontsize',10);

subplot(1,4,4);
for i=1:length(data)
    idx = ~isnan(data(i).sigmat);            
    h(i)=plot(data(i).sigmat(idx),data(i).z(idx),'-','Color',col(i,:),'linewidth',1); hold on
end
sb=plot(S.sigmat,S.z,'k-','linewidth',1.5); hold on
set(gca,'ylim',[0 6],'xlim',[0 24],'Ydir','reverse','xaxislocation','top',...
    'yticklabel',{},'fontsize',9,'Tickdir','out');
xlabel('sigma-t','fontsize',10);

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/SequimBay_BuddInlet_watercolumn.png'],'Resolution',300)    
hold off
