%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2023'; % '2023'
ydinolim=[0 4]; ymesolim=[0 10]; 
load([filepath 'Data/BuddInlet_data_summary'],'T');
load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');

idx=find(~isnan(T.meso_fl)); mesof=T.meso_fl(idx); dtf=T.dt(idx);

T.t1=smoothdata(T.t1,'movmean',4,'omitnan');
T.s1=smoothdata(T.s1,'movmean',4,'omitnan');

figure('Units','inches','Position',[1 1 5 5.],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.06 0.11], [0.14 0.22]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(5,1,1)
plot(T.dt,T.DST,'k*','Markersize',4,'linewidth',1.5); hold on;
hline(16,'k:'); hold on;
    set(gca,'xaxislocation','top','xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize', 10,'tickdir','out','ycolor','k');
    datetick('x', 'mmm', 'keeplimits');            
    ylabel({'DSP toxins';'(µg/100 g)'},'fontsize',11); hold on;
    title(yr,'fontsize', 12)   

subplot(5,1,2);
h = bar(T.dt,[T.fx_Dfortii T.fx_Dacuminata T.fx_Dnorvegica T.fx_Dodiosa...
    T.fx_Drotundata T.fx_Dparva T.fx_Dacuta],'stack','Barwidth',2,'linestyle','none');
    c=brewermap(7,'Set2');
    for i=1:length(h), set(h(i),'FaceColor',c(i,:)); end  
    set(gca,'xlim',xax,'ylim',[0 1],'ytick',0:.5:1,'xticklabel',{},...
        'fontsize', 10,'fontname', 'arial','tickdir','out','ycolor','k')
    ylabel('species fx','fontsize',11);
    lh=legend('fortii','acuminata','norvegica','odiosa','rotundata','parva','acuta');
    legend boxoff; lh.FontSize = 8; hp=get(lh,'pos');
    lh.Position=[hp(1)+.24 hp(2)+.08 hp(3) hp(4)]; hold on    

subplot(5,1,3); %dino
yyaxis left
idx=find(isnan(T.dino_fl)); val=0.1*ones(size(idx));
h1=plot(T.dt,T.dino_fl,'k-','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ydinolim,'ytick',0:2:4,'xticklabel',{},...
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
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ymesolim,'ytick',0:5:10,'xticklabel',{},...
        'fontsize', 10,'tickdir','out','ycolor','r');  
    ylabel({'meso/mL'},'fontsize',11); hold on;      

subplot(5,1,4)
yyaxis left
plot(T.dt,T.s1,'-k','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[19 33],...
        'fontsize', 10,'tickdir','out','ycolor','k');   
    ylabel('ppt','fontsize',11,'color','k'); hold on;
yyaxis right
plot(T.dt,T.DeschutesCfs,'-b','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},'ylim',[0 1000],...
        'fontsize', 10,'tickdir','out','ycolor','b');   
    ylabel({'cfs'},'fontsize',11,'color','b'); hold on;

subplot(5,1,5)
plot(T.dt,T.t1,'-k','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[8 23],...
        'fontsize', 10,'tickdir','out','ycolor','k');   
    ylabel('^oC','fontsize',11,'color','k'); hold on;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_overview_' yr '_v2.png'],'Resolution',100)    
hold off


