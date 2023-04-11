%% plot PN cell count and width against different environmental variables
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
classidxpath = [filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1; %0 
yr=2019; % 2019; 2021 
width=1; %0

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],...
    'dt','lat','lon','class2useTB','cellsmL','PN_width','sal','temp','pco2');

if width==1
    label='PN width (\mum)';    
    data=PN_width;
elseif width==0
    label='PN per mL';
    data=cellsmL(:,strcmp('Pseudonitzschia',class2useTB)); data(data<1)=NaN;
end

[P19,P21] = find_PN_patch_coordinates(dt,lat,lon);

if yr==2019
    idx=find(dt<datetime('01-Jan-2020'));
    data=data(idx); temp=temp(idx); sal=sal(idx); pco2=pco2(idx);  
    P=P19;    
elseif yr==2021
    idx=find(dt>datetime('01-Jan-2020'));
    data=data(idx); temp=temp(idx); sal=sal(idx); pco2=pco2(idx);  
    P=P21;    
end

clearvars P19 P21 idx cellsmL class2useTB lat lon PN_width;

% patches overlaid on Salinity vs Temperature
figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');

for i=1:length(P)
    bubblechart(sal(P(i).idx),temp(P(i).idx),data(P(i).idx),P(i).col,'MarkerFaceAlpha',0); hold on        
end
remain=sum([P.idx],2); iremain=find(remain==0);    
bubblechart(sal(iremain),temp(iremain),data(iremain),[.3 .3 .3],'MarkerFaceAlpha',0); hold on;

bubblesize([1 10]);
bubblelegend(label,'Location','southwest');
set(gca,'ylim',[9.4 18],'ytick',10:2:18,'xlim',[28 34],'fontsize',10,'tickdir','out')
box on; axis square;
ylabel('Temperature (^oC)','fontsize',12);
xlabel('Salinity (psu)','fontsize',12)
title(yr,'fontsize',12)

if width==1
    bubblelim([1 10]); 
    filename=[filepath 'NOAA/Shimada/Figs/PN_width_patches_T_vs_S_' num2str(yr) '.png'];
else
    bubblelim([5 50]); 
    filename=[filepath 'NOAA/Shimada/Figs/PN_patches_T_vs_S_' num2str(yr) '.png'];
end

if fprint==1
    exportgraphics(gca,filename,'Resolution',100)    
end
hold off 

%%%% patches overlaid on PCO2 vs Temperature
figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');

for i=1:length(P)
    bubblechart(pco2(P(i).idx),temp(P(i).idx),data(P(i).idx),P(i).col,'MarkerFaceAlpha',0); hold on        
end
remain=sum([P.idx],2); iremain=find(remain==0);    
bubblechart(pco2(iremain),temp(iremain),data(iremain),[.3 .3 .3],'MarkerFaceAlpha',0); hold on;

bubblesize([1 10]);
bubblelegend(label,'Location','northeast');

set(gca,'xlim',[0 800],'xtick',0:200:800,'ylim',[9.4 18],'ytick',10:2:18,'fontsize',10,'tickdir','out')
box on; axis square;
ylabel('Temperature (^oC)','fontsize',12);
xlabel('pCO_2 (ppm)','fontsize',12)
title(yr,'fontsize',12)

if width==1
    bubblelim([1 10]);     
    filename=[filepath 'NOAA/Shimada/Figs/PN_width_patches_T_vs_PCO2_' num2str(yr) '.png'];
else
    bubblelim([5 50]);         
    filename=[filepath 'NOAA/Shimada/Figs/PN_patches_T_vs_PCO2_' num2str(yr) '.png'];
end

if fprint==1
    exportgraphics(gca,filename,'Resolution',100)    
end
hold off 
