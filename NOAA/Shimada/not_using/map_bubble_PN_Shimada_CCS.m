%% map IFCB data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
classidxpath = [filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1;
yr=2021; % 2019; 2021
load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],...
    'dt','lat','lon','class2useTB','cellsmL');
target='Pseudonitzschia'; dataformat='cells'; label='PN per mL';
data=cellsmL(:,strcmp(target,class2useTB));

[P19,P21] = find_PN_patch_coordinates(dt,lat,lon);

if yr==2019
    idx=find(dt<datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx);  
    P=P19;    
elseif yr==2021
    idx=find(dt>datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx);  
    P=P21;    
end

clearvars P19 P21 idx cellsmL class2useTB;

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.2 5]); 
ind=find(data<2); data(ind)=NaN;
scatter(lon(ind),lat(ind),ones(size(ind)),[.3 .3 .3],'o','filled'); hold on
%bubblechart(lon,lat,data,'r','MarkerFaceAlpha',0); hold on;

for i=1:length(P)
    bubblechart(lon(P(i).idx),lat(P(i).idx),data(P(i).idx),P(i).col,'MarkerFaceAlpha',0); hold on        
end
remain=sum([P.idx],2); iremain=find(remain==0);    
bubblechart(lon(iremain),lat(iremain),data(iremain),[.3 .3 .3],'MarkerFaceAlpha',0); hold on;

bubblelim([5 50]); bubblesize([1 10]);
h=bubblelegend(label,'Location','southwest','Box','off');
    hp=get(h,'pos'); 
    hp=[1.8*hp(1) 0.85*hp(2) hp(3) hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp); 

axis([min(lon) max(lon) min(lat) max(lat)]);

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[34 49],'xlim',[-127 -120],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);
   
if fprint
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' target '_IFCB_Shimada' num2str(yr) '.png'],'Resolution',100)    
end
hold off 
