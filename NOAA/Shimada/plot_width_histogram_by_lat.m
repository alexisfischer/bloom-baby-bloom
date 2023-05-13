%% plot PN patches cell width histogram
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'NOAA/Shimada/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

yr=2021; % 2019; 2021
load([filepath 'IFCB-Data/Shimada/class/summary_PN_allTB_CCS_NOAA-OSU_v7.mat'],...
    'mdateTB','PNwidth_opt','filelistTB','PNcount_above_optthresh','ml_analyzedTB');
dt=datetime(mdateTB,'ConvertFrom','datenum');

%%% match data with lat lon
[lat,lon,ia,filelistTB] = match_IFCBdata_w_Shimada_lat_lon(filepath,filelistTB);
dt=dt(ia); width=PNwidth_opt(ia); PNmL=PNcount_above_optthresh(ia)./ml_analyzedTB(ia);

if yr==2019
    idx=dt<datetime('01-Jan-2020');
    dt=dt(idx); width=width(idx); lat=lat(idx); lon=lon(idx); PNmL=PNmL(idx);
elseif yr==2021
    idx=dt>datetime('01-Jan-2020');
    dt=dt(idx); width=width(idx); lat=lat(idx); lon=lon(idx); PNmL=PNmL(idx);
end

%%%% remove data south of 40 N and the Strait so ~equivalent between 2019 and 2021
idx=find(lat<40); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; width(idx)=[]; PNmL(idx)=[];
idx=find(lat>47.5 & lon>-124.7); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; width(idx)=[]; PNmL(idx)=[];

clearvars idx ia filelistTB PNwidth_opt mdateTB ml_analyzedTB PNcount_above_optthresh

% plot strip plot
%%%% split width into latitudinal bins
range=40:0.5:49;
t0=1; unit=0.5; tend=9;
for i=1:length(range)-1
    P(i).latmin=range(i);
    P(i).latmax=range(i+1);    
    P(i).idx=find(lat>=range(i) & lat<range(i+1)); 
    P(i).label=['' num2str(P(i).latmin) '-' num2str(P(i).latmax) '^oN'];
    P(i).width=sort([width(P(i).idx).total])';
    P(i).bin=(histcounts(P(i).width,t0:unit:tend))';
    P(i).fx=P(i).bin./sum(P(i).bin);
end

C=[P.fx]';C(end+1,:)=C(end,:);

X=repmat(t0+unit./2:unit:tend,size(C,1),1);
Y=repmat(range',1,size(C,2));
vmax=round(max(max([P.fx])),2);

fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.5 3]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.04 0.14], [0.12 0.08]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, height, width} describes the inner and outer spacings.  

subplot(1,3,1)
%subplot(1,5,[1,2])
    stem(lat,PNmL,'color','k','Marker','none');
    set(gca,'view',[90 -90],'xlim',[range(1) range(end)],'yaxislocation','right',...
        'ylim',[0 150],'ytick',0:100:100,'fontsize',9,'tickdir','out','box','on');
    ylabel('Cells mL^{-1}','fontsize',11);
    xlabel(['' num2str(yr) ' Latitude (ºN)'],'fontsize',11); hold on

subplot(1,3,[2,3])    
%subplot(1,5,[3,4,5])
   pcolor(X,Y,C); shading flat; hold on;
    colormap((parula)); caxis([0 vmax]); hold on
    set(gca,'ylim',[range(1) range(end)],'yticklabel',{},'xlim',[t0 tend],...
        'xaxislocation','top','xtick',t0:2:tend,'fontsize',9,'tickdir','out','box','on');
xlabel('Width (\mum)','fontsize',11);
xline(3.5,'-r','linewidth',1); hold on

for i=1:length(P)
    text(tend+.25,mean([P(i).latmin,P(i).latmax])-.1,num2str(length(P(i).idx)),'fontsize',8,'color','k'); hold on
end


% set figure parameters
exportgraphics(gcf,[outpath 'PN_width_by_latitude_pcolor_' num2str(yr) '.png'],'Resolution',300)    
hold off

%% plot as histogram
fig=figure('Units','inches','Position',[1 1 2 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.1 0.06], [0.05 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

for i=1:length(P)
    ax(i)=subplot(length(P),1,i);
    histogram([width(P(i).idx).total],0:1:10,'FaceColor','k'); hold on;
    set(gca,'xtick',0:2:10,'xticklabel',{},'yticklabel',{},'fontsize',9,'tickdir','out');  
    text(min(xlim),max(ylim),P(i).label,'fontsize',9,'Horiz','left', 'Vert','top')
end

set(gca,'xticklabel',0:2:10);

% Give common xlabel, ylabel and title to your figure
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
han.XTickLabel=0:2:10;
xlabel(han,'Width (\mum)','fontsize',11)
title(han,yr);

% set figure parameters
exportgraphics(gcf,[outpath 'PN_width_by_latitude_histogram_' num2str(yr) '.png'],'Resolution',100)    
hold off

