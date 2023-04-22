%% plot PN cell width histogram
% complete dataset
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'NOAA/Shimada/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/class/summary_PN_allTB.mat'],...
    'mdateTB','PNwidth_opt','filelistTB','ml_analyzedTB','PNcount_above_optthresh');

dt=datetime(mdateTB,'ConvertFrom','datenum');

[lat,lon,ia,filelistTB] = match_IFCBdata_w_Shimada_lat_lon(filepath,filelistTB);
dt=dt(ia); PNwidth_opt=PNwidth_opt(ia); filelistTB=filelistTB(ia); 
ml_analyzedTB=ml_analyzedTB(ia); PNcount_above_optthresh=PNcount_above_optthresh(ia);

% remove data south of 40 N so ~equivalent between 2019 and 2021
    idx=find(lat<40); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; PNwidth_opt(idx)=[];
    ml_analyzedTB(idx)=[]; PNcount_above_optthresh(idx)=[];
% remove data from the Strait
    idx=find(lat>48 & lon>-124.7); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; 
    PNwidth_opt(idx)=[]; ml_analyzedTB(idx)=[]; PNcount_above_optthresh(idx)=[];
% remove errant first date    
    idx=find(dt>datetime('01-Jan-2020') & dt<datetime('20-Jul-2021'));
    dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; PNwidth_opt(idx)=[];
    ml_analyzedTB(idx)=[]; PNcount_above_optthresh(idx)=[];
    clearvars ia idx mdateTB filelistTB

figure('Units','inches','Position',[1 1 6.5 4.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.12], [0.12 0.07], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%2019
id19=find(dt<datetime('01-Jan-2021'));
mean_width_19=nanmean([PNwidth_opt(id19).total])
std_width_19=std([PNwidth_opt(id19).total])
max_19=max([PNcount_above_optthresh(id19)./ml_analyzedTB(id19)])

%2021
id21=find(dt>datetime('01-Jan-2021'));
mean_width_21=nanmean([PNwidth_opt(id21).total])
std_width_21=std([PNwidth_opt(id21).total])
max_21=max([PNcount_above_optthresh(id21)./ml_analyzedTB(id21)])


subplot(2,2,1);
plot(lat(id19),PNcount_above_optthresh(id19)./ml_analyzedTB(id19),'-')
set(gca,'xlim',[40 49],'fontsize',10,'tickdir','out');
ylabel('PN per mL','fontsize',12)
title('2019(top) 2021(bottom)')

subplot(2,2,2);
histogram([PNwidth_opt(id19).total],0:1:10);
set(gca,'xtick',0:2:10,'fontsize',10,'tickdir','out');
ylabel('Count','fontsize',12)

subplot(2,2,3);
plot(lat(id21),PNcount_above_optthresh(id21)./ml_analyzedTB(id21),'-')
set(gca,'xlim',[40 49],'fontsize',10,'tickdir','out');
ylabel('PN per mL','fontsize',12)
xlabel('Latitude (^oN)','fontsize',12)

subplot(2,2,4);
histogram([PNwidth_opt(id21).total],0:1:10);
set(gca,'xtick',0:2:10,'fontsize',10,'tickdir','out');
xlabel('Width (\mum)','fontsize',12)
ylabel('Count','fontsize',12)

% set figure parameters
exportgraphics(gcf,[outpath 'PN_width_histogram_CCS.png'],'Resolution',100)    
hold off

