%% plot PN cell width histogram with literature values
clear;

micron_factor=3.8; %3.8; %3.1;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'NOAA/Shimada/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

%%%% import Pn width data from literature
% plot Pn width from literature
s(1).width=[1.1 2]; s(1).name='delicatissima';
s(2).width=[1.5 3.4]; s(2).name='pseudodelicatissima';
s(3).width=[2.4 5.3]; s(3).name='pungens';
s(4).width=[3.4 6]; s(4).name='multiseries';
s(5).width=[4 6]; s(5).name='hemii';
%s(6).width=[4.5 6.5]; s(6).name='fraudulenta';
s(6).width=[6.5 8]; s(6).name='australis';

s(1).letter='A'; s(2).letter='B'; s(3).letter='C';
s(4).letter='D'; s(5).letter='E'; s(6).letter='F'; 

%col=brewermap(4,'RdBu'); 
low=brewermap(1,'Blues'); %no(1,:)=[];
med=brewermap(1,'YlOrBr'); 
high=brewermap(2,'Reds'); high(1,:)=[];
s(1).color=low; s(2).color=med; s(3).color=low;
s(4).color=high; s(5).color=med; s(6).color=high;

c=brewermap(4,'Purples'); 
Scol=c(2,:); Lcol=c(4,:);

%%%% import PN data from manual counts
load([filepath 'IFCB-Data/Shimada/manual/summary_PN_width_manual_micron-factor' num2str(micron_factor) ''],...
    'ml_analyzed','mdate','filelist','PN*','micron_factor');
dt=datetime(mdate,'ConvertFrom','datenum');

% match w lat lon
    [lat,lon,ia,filelist] = match_IFCBdata_w_Shimada_lat_lon(filepath,filelist);
    dt=dt(ia); PNwidth_large=PNwidth_large(ia); filelist=filelist(ia); 
    ml_analyzed=ml_analyzed(ia); PNwidth_small=PNwidth_small(ia);

% remove data south of 40 N so ~equivalent between 2019 and 2021
    idx=find(lat<40); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; PNwidth_large(idx)=[];
    ml_analyzed(idx)=[]; PNwidth_small(idx)=[];
% remove data from the Strait
    idx=find(lat>48 & lon>-124.7); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; 
    PNwidth_large(idx)=[]; ml_analyzed(idx)=[]; PNwidth_small(idx)=[];

clearvars ia idx mdate filelist idx


figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.12], [0.15 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(5,1,[1 2])
    plot([3 3],[0 10],':k','linewidth',1); hold on

    for i=1:length(s)
        line(s(i).width,[i./10 i./10],'color',s(i).color,'linewidth',9); hold on
        %text(s(i).width(1)+.04,i./10+.005,s(i).name,'fontsize',9); hold on
        %  text(mean(s(i).width)-.45,i./10+.005,['' s(i).name(1:5) '.'],'fontsize',9); hold on
    end
    set(gca,'ylim',[0.05 .65],'xlim',[1 9],'xtick',1:2:9,'fontsize',10,...
        'xaxislocation','top','tickdir','out','yticklabel',{}); box on
    xlabel('Width (\mum)','fontsize',11);

subplot(5,1,[3 4 5])
    histogram([PNwidth_small.total],1:.25:9,'FaceColor',Scol); hold on
    histogram([PNwidth_large.total],1:.25:9,'FaceColor',Lcol); hold on
    %xline(3.87,':k','linewidth',2); hold on
    set(gca,'xlim',[1 9],'xtick',1:2:9,'fontsize',10,'xaxislocation','bottom','tickdir','out');
    ylabel('PN Image Count','fontsize',11)
    legend('small','large'); legend boxoff

% set figure parameters
exportgraphics(gcf,[outpath 'PN_width_histogram_manual_CCS.png'],'Resolution',300)    
hold off

%% plot by year manual counts

i19=find(dt<datetime('01-Jan-2020'));
i21=find(dt>datetime('01-Jan-2020'));
figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.12 0.07], [0.15 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1);
h1=histogram([PNwidth_small(i19).total],1:.25:9); hold on
histogram([PNwidth_large(i19).total],1:.25:9); hold on
xline(3.88,'-r','linewidth',1); hold on
set(gca,'xlim',[1 9],'xtick',1:2:9,'xticklabel',{},'fontsize',10,'tickdir','out');
ylabel('Count','fontsize',11)
legend('"small"','"large"')
title(['' num2str(micron_factor) ' pixels/\mum'],'fontsize',11)
text(1.2,270,'2019','fontsize',11,'color','k'); hold on

subplot(2,1,2);
histogram([PNwidth_small(i21).total],1:.25:9); hold on
histogram([PNwidth_large(i21).total],1:.25:9); hold on
xline(3.88,'-r','3.9 \mum','linewidth',1); hold on
set(gca,'xlim',[1 9],'xtick',1:2:9,'fontsize',10,'tickdir','out');
ylabel('Count','fontsize',11)
xlabel('Width (\mum)','fontsize',11)
text(1.2,270,'2021','fontsize',11,'color','k'); hold on
  
% set figure parameters
exportgraphics(gcf,[outpath 'PN_width_histogram_manual_CCS_micron-factor' num2str(micron_factor) '.png'],'Resolution',100)    
hold off

