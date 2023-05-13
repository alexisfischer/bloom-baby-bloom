%% plot PN cell width histogram
% complete dataset
clear;

micron_factor=3.8;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'NOAA/Shimada/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/manual/summary_PN_width_manual_micron-factor' num2str(micron_factor) ''],...
    'ml_analyzed','mdate','filelist','PN*','micron_factor');

dt=datetime(mdate,'ConvertFrom','datenum');

[lat,lon,ia,filelist] = match_IFCBdata_w_Shimada_lat_lon(filepath,filelist);
dt=dt(ia); PNwidth_large=PNwidth_large(ia); filelist=filelist(ia); 
ml_analyzed=ml_analyzed(ia); PNwidth_small=PNwidth_small(ia);

% remove data south of 40 N so ~equivalent between 2019 and 2021
    idx=find(lat<40); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; PNwidth_large(idx)=[];
    ml_analyzed(idx)=[]; PNwidth_small(idx)=[];
% remove data from the Strait
    idx=find(lat>48 & lon>-124.7); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; 
    PNwidth_large(idx)=[]; ml_analyzed(idx)=[]; PNwidth_small(idx)=[];

i19=find(dt<datetime('01-Jan-2020'));
i21=find(dt>datetime('01-Jan-2020'));

clearvars ia idx mdate filelist idx

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.12 0.07], [0.14 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1);
histogram([PNwidth_small(i19).total],1:.25:9); hold on
histogram([PNwidth_large(i19).total],1:.25:9); hold on
xline(3.75,'-r','linewidth',1); hold on
set(gca,'xlim',[1 9],'xtick',1:2:9,'xticklabel',{},'fontsize',10,'tickdir','out');
ylabel('Count','fontsize',11)
legend('"small"','"large"')
title(['' num2str(micron_factor) ' pixels/\mum'],'fontsize',11)
text(1.2,350,'2019','fontsize',11,'color','k'); hold on

subplot(2,1,2);
histogram([PNwidth_small(i21).total],1:.25:9); hold on
histogram([PNwidth_large(i21).total],1:.25:9); hold on
xline(3.75,'-r','3.75 \mum','linewidth',1); hold on
set(gca,'xlim',[1 9],'xtick',1:2:9,'fontsize',10,'tickdir','out');
ylabel('Count','fontsize',11)
xlabel('Width (\mum)','fontsize',11)
text(1.2,350,'2021','fontsize',11,'color','k'); hold on
  
% set figure parameters
exportgraphics(gcf,[outpath 'PN_width_histogram_manual_CCS_micron-factor' num2str(micron_factor) '.png'],'Resolution',100)    
hold off

