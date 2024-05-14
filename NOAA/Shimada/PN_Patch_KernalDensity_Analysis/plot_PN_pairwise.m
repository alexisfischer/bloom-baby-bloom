%% plot patches overlaid on Salinity vs Temperature
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

fprint=1;
load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
P.PN=sum([P.Pseudonitzschia_large,P.Pseudonitzschia_medium,P.Pseudonitzschia_small],2);
P((P.PN<1),:)=[];

y19=load([filepath 'NOAA/Shimada/Data/Patch_2019'],'lat_range_tox','lat_range_pn');
y21=load([filepath 'NOAA/Shimada/Data/Patch_2021'],'lat_range_tox','lat_range_pn');

%%%% delineate patches
% Trinidad Head - 2021:non
    iTH_21=(P.DT>datetime('01-Jan-2020') & P.LAT>y21.lat_range_pn(1,1) & P.LAT<y21.lat_range_pn(1,end));
% Heceta Bank - 2019:toxic, 2021:non
    iHB_19=(P.DT<datetime('01-Jan-2020') & P.LAT>y19.lat_range_pn(1,1) & P.LAT<y19.lat_range_pn(1,end));
    iHB_21=(P.DT>datetime('01-Jan-2020') & P.LAT>y21.lat_range_pn(2,1) & P.LAT<y21.lat_range_pn(2,end));
% Juan de Fuca Eddy - 2019:non, 2021:toxic
    iJF_19=(P.DT<datetime('01-Jan-2020') & P.LAT>47.5);
    iJF_21=(P.DT>datetime('01-Jan-2020') & P.LAT>47.5);

    col=brewermap(4,'OrRd'); 
 
%% separate HB and JF
fig=figure('Units','inches','Position',[1 1 3.5 5.],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.09 0.03], [0.14 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[31 34]; yax=[9.4 18];

subplot(2,1,1)
bubblechart(P.SAL(iHB_19),P.TEMP(iHB_19),P.PN(iHB_19),col(3,:),'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblechart(P.SAL(iHB_21),P.TEMP(iHB_21),P.PN(iHB_21),[.7 .7 .7],'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblesize([1 10]);
bubblelegend('PN cells/mL','Location','eastoutside');
set(gca,'ylim',yax,'ytick',10:2:18,'xlim',xax,'fontsize',10,'tickdir','out')
box on; axis square;
title('Heceta Bank');
ylabel('Temperature (^oC)','fontsize',11);
bubblelim([5 50]); 

subplot(2,1,2)
bubblechart(P.SAL(iJF_19),P.TEMP(iJF_19),P.PN(iJF_19),[.7 .7 .7],'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblechart(P.SAL(iJF_21),P.TEMP(iJF_21),P.PN(iJF_21),col(4,:),'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblesize([1 10]);
bubblelegend('PN cells/mL','Location','eastoutside');
set(gca,'ylim',yax,'ytick',10:2:18,'xlim',xax,'fontsize',10,'tickdir','out')
box on; axis square;
title('Juan de Fuca');
ylabel('Temperature (^oC)','fontsize',11);
xlabel('Salinity (psu)','fontsize',11)
bubblelim([5 50]); 

if fprint
    exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/PNtox_JF-HB_TvsS.png'],'Resolution',100)    
end
hold off 

%% separate 2019 and 2021 panels
fig=figure('Units','inches','Position',[1 1 3.5 5.],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.09 0.03], [0.14 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[28 34]; yax=[9.4 18];

subplot(2,1,1)
i19=(P.DT<datetime('01-Jan-2020')); iremain=find(sum([i19 iHB_19],2)==1);
bubblechart(P.SAL(iremain),P.TEMP(iremain),P.PN(iremain),[.7 .7 .7],'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblechart(P.SAL(iHB_19),P.TEMP(iHB_19),P.PN(iHB_19),col(3,:),'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblesize([1 10]);
bubblelegend('PN cells/mL','Location','eastoutside');
set(gca,'ylim',yax,'ytick',10:2:18,'xlim',xax,'fontsize',10,'tickdir','out')
box on; axis square;
title('2019');
ylabel('Temperature (^oC)','fontsize',11);
bubblelim([5 50]); 

subplot(2,1,2)
i21=(P.DT>datetime('01-Jan-2020')); iremain=find(sum([i21 iJF_21],2)==1);
bubblechart(P.SAL(iremain),P.TEMP(iremain),P.PN(iremain),[.7 .7 .7],'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblechart(P.SAL(iJF_21),P.TEMP(iJF_21),P.PN(iJF_21),col(4,:),'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblesize([1 10]);
bubblelegend('PN cells/mL','Location','eastoutside');
set(gca,'ylim',yax,'ytick',10:2:18,'xlim',xax,'fontsize',10,'tickdir','out')
box on; axis square;
title('2021');
ylabel('Temperature (^oC)','fontsize',11);
xlabel('Salinity (psu)','fontsize',11)
bubblelim([5 50]); 

if fprint
    exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/PNtox_2019-2021_TvsS.png'],'Resolution',100)    
end
hold off 


%% 2019 and 2021 combined
itox=sum([iHB_19,iJF_21],2); iremain=find(itox==0);

figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
xax=[28 34]; yax=[9.4 18];

bubblechart(P.SAL(iremain),P.TEMP(iremain),P.PN(iremain),[.7 .7 .7],'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblechart(P.SAL(iHB_19),P.TEMP(iHB_19),P.PN(iHB_19),col(3,:),'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblechart(P.SAL(iJF_21),P.TEMP(iJF_21),P.PN(iJF_21),col(4,:),'MarkerFaceAlpha',0,'linewidth',1.5); hold on        
bubblesize([1 10]);
bubblelegend('PN cells/mL','Location','eastoutside');
set(gca,'ylim',yax,'ytick',10:2:18,'xlim',xax,'fontsize',10,'tickdir','out')
box on; axis square;
title('2019');
ylabel('Temperature (^oC)','fontsize',12);
xlabel('Salinity (psu)','fontsize',12)
bubblelim([5 50]); 
