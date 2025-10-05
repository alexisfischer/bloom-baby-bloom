%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2021'; % '2023'
ydinolim=[0 4]; ymesolim=[0 10];
load([filepath 'Data/BuddInlet_data_summary'],'T');
load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');

figure('Units','inches','Position',[1 1 5 5.6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.06 0.11], [0.14 0.22]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%xax=[datetime(['' yr '-05-01']) datetime(['' yr '-09-26'])];
xax=[datetime(['' yr '-05-01']) datetime(['' yr '-10-01'])];

subplot(6,1,1)
plot(T.dt,T.DST,'k*','Markersize',4,'linewidth',1.5); hold on;
    set(gca,'xaxislocation','top','xlim',[xax(1) xax(2)],'ylim',[0 20],...
        'fontsize', 10,'tickdir','out','ycolor','k');
    datetick('x', 'mmm', 'keeplimits');            
    ylabel({'DSP toxins';'(µg/100 g)'},'fontsize',11); hold on;
    title(yr,'fontsize', 12)    

subplot(6,1,2);
h = bar(T.dt,[T.fx_Dacuminata T.fx_Dfortii T.fx_Dnorvegica T.fx_Dodiosa...
    T.fx_Drotundata T.fx_Dparva T.fx_Dacuta],'stack','Barwidth',2,'linestyle','none');
    c=brewermap(7,'Set2');
    for i=1:length(h), set(h(i),'FaceColor',c(i,:)); end  
    set(gca,'xlim',xax,'ylim',[0 1],'ytick',0:.5:1,'xticklabel',{},...
        'fontsize', 10,'fontname', 'arial','tickdir','out','ycolor','k')
    ylabel('species fx','fontsize',11);
    lh=legend('acuminata','fortii','norvegica','odiosa','rotundata','parva','acuta');
    legend boxoff; lh.FontSize = 8; hp=get(lh,'pos');
    lh.Position=[hp(1)+.24 hp(2)+.08 hp(3) hp(4)]; hold on    

subplot(6,1,3)
yyaxis left
idx=find(isnan(T.dino_fl)); val=0.1*ones(size(idx));
%plot(T.dt,T.dinoML_microscopy,'ro','MarkerSize',4); hold on;
h1=plot(T.dt,T.dino_fl,'k-','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ydinolim,'xticklabel',{},...
        'fontsize', 10,'tickdir','out','ycolor','k');  
    ylabel({'dinophy.';'(cells/mL)'},'fontsize',11); hold on;   
yyaxis right
    plot(T.dt(idx),val,'ks','linewidth',.5,'markersize',5,'markerfacecolor','k'); hold on;
if strcmp(yr,'2021')
    iend=find(~isnan(T.dino_fl),1); 
    dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
    val=0.1*ones(size(dti));
    plot(dti,val,'ks','linewidth',.5,'markersize',5,'markerfacecolor','k'); hold on;
end
    h2=plot(T.dt,T.meso_fl,'r-','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',ymesolim,'xticklabel',{},...
        'fontsize', 10,'tickdir','out','ycolor','r');  
    ylabel({'mesodin.';'(cells/mL)'},'fontsize',11); hold on;   

subplot(6,1,4)
plot(T.dt,T.DeschutesCfs,'-k','linewidth',1.5); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},'ylim',[0 1000],...
        'fontsize', 10,'tickdir','out','ycolor','k');   
    ylabel({'cfs'},'fontsize',11,'color','k'); hold on;
    
ax(4)=subplot(6,1,5); %temperature
[X,Y,Temp] = griddata4pcolor([B.dn]',[B(1).z]',[B.t]',2);
X=datetime(X,'convertfrom','datenum');
pcolor(X,Y,Temp); cax=[8 22]; clim(cax); shading flat;
patch(T.dt,1.5*ones(size(T.t1)),zeros(size(T.t1)),T.t1,'edgecolor','interp','linewidth',7); hold on
patch(T.dt,3*ones(size(T.t3)),zeros(size(T.t3)),T.t3,'edgecolor','interp','linewidth',7); hold on
plot(T.dt(~isnan(T.IFCBDepthm)),T.IFCBDepthm(~isnan(T.IFCBDepthm)),'k-'); hold on;
set(gca,'YDir','reverse','xlim',xax,'xticklabel',{},'ycolor','k',...
    'ylim',[0 3.3],'ytick',0:1:3,'fontsize', 10,'tickdir','out');
    ylabel('depth (m)', 'fontsize', 11); hold on
    colormap(ax(4),brewermap([],'YlOrRd'));  
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); h.Position = [hp(1)*1.12 hp(2) .5*hp(3) hp(4)];    
    h.TickDirection = 'out'; h.FontSize = 10; h.Label.String = '^oC';     
    h.Label.FontSize = 11; h.Ticks=linspace(cax(1),cax(2),3); hold on   
    
ax(5)=subplot(6,1,6); %salinity
[X,Y,Sal] = griddata4pcolor([B.dn]',[B(1).z]',[B.s]',2);
X=datetime(X,'convertfrom','datenum');
pcolor(X,Y,Sal); cax=[10 30]; clim(cax); shading flat; 
patch(T.dt,1.5*ones(size(T.s1)),zeros(size(T.s1)),T.s1,'edgecolor','interp','linewidth',7); hold on
patch(T.dt,3*ones(size(T.s3)),zeros(size(T.s3)),T.s3,'edgecolor','interp','linewidth',7); hold on
set(gca,'YDir','reverse','xlim',xax,'ycolor','k',...
    'ylim',[0 3.3],'ytick',0:1:3,'fontsize', 10,'tickdir','out');
    ylabel('depth (m)', 'fontsize', 11); hold on
    colormap(ax(5),brewermap([],'YlGnBu'));  
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); h.Position = [hp(1)*1.12 hp(2) .5*hp(3) hp(4)];    
    h.TickDirection = 'out'; h.FontSize = 10; h.Label.String = 'ppt';     
    h.Label.FontSize = 11; h.Ticks=linspace(cax(1),cax(2),3); hold on  
    datetick('x', 'mmm', 'keeplimits');            

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_overview_' yr '_v2.png'],'Resolution',100)    
hold off


