%% plot PN patches cell width histogram
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'NOAA/Shimada/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/class/summary_PN_allTB.mat'],...
    'mdateTB','PNwidth_opt','filelistTB','ml_analyzedTB','PNcount_above_optthresh');

dt=datetime(mdateTB,'ConvertFrom','datenum');

% match data with lat lon
[lat,lon,ia,filelistTB] = match_IFCBdata_w_Shimada_lat_lon(filepath,filelistTB);
dt=dt(ia); width=PNwidth_opt(ia); ml_analyzedTB=ml_analyzedTB(ia); PNcount_above_optthresh=PNcount_above_optthresh(ia);

[P19,P21] = find_PN_patch_coordinates(dt,lat,lon);

yr=2021; % 2019; 2021
if yr==2019
    idx=dt<datetime('01-Jan-2020');
    dt=dt(idx); width=width(idx); ml_analyzedTB=ml_analyzedTB(idx); PNcount=PNcount_above_optthresh(idx);
    P=P19;
elseif yr==2021
    idx=dt>datetime('01-Jan-2020');
    dt=dt(idx); width=width(idx); ml_analyzedTB=ml_analyzedTB(idx); PNcount=PNcount_above_optthresh(idx);
    P=P21;
end

clearvars mdateTB PNwidth_opt ia idx PNwidth_opt P19 P21 filelistTB lat lon PNcount_above_optthresh;

%% plot cell count with patches in different colors
figure('Units','inches','Position',[1 1 3.5 2],'PaperPositionMode','auto');

remain=sum([P.idx],2); iremain=find(remain==0);

plot(dt(iremain),PNcount(iremain)./ml_analyzedTB(iremain),'-','Color',[.3 .3 .3]); hold on;
for i=1:length(P)
    plot(dt(P(i).idx),PNcount(P(i).idx)./ml_analyzedTB(P(i).idx),'-','Color',P(i).col); hold on;
end

set(gca,'xlim',[datetime(['28-Jun-' num2str(yr) '']) datetime(['01-Oct-' num2str(yr) ''])],...
    'fontsize',10,'tickdir','out');
datetick('x', 'mm/dd', 'keeplimits');    
ylabel('PN per mL','fontsize',12)
title(yr,'fontsize',12)

% set figure parameters
exportgraphics(gcf,[outpath 'PN_patch_vs_time_' num2str(yr) '.png'],'Resolution',100)    
hold off

%% plot PN width of each patch
fig=figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.12 0.07], [0.17 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

for i=1:length(P)
    ax(i)=subplot(length(P),1,i); %JDF
    histogram([width(P(i).idx).total],0:1:10,'FaceColor',P(i).col); hold on;
    set(gca,'xtick',0:2:10,'fontsize',10,'tickdir','out');  
    text(min(xlim),max(ylim),P(i).label, 'Horiz','left', 'Vert','top')
end

% Give common xlabel, ylabel and title to your figure
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Count','fontsize',12)
xlabel(han,'Width (\mum)','fontsize',12)
title(han,yr);

% set figure parameters
exportgraphics(gcf,[outpath 'PN_width_histogram_' num2str(yr) '.png'],'Resolution',100)    
hold off

