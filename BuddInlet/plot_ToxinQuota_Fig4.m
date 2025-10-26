%% plot continuous Budd Inlet data
clear
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
filepath = 'C:\Users\alexis.fischer\OneDrive - SePRO Corporation\Documents\MATLAB\bloom-baby-bloom\BuddInlet\';
addpath(genpath('C:\Users\alexis.fischer\OneDrive - SePRO Corporation\Documents\MATLAB\'));
%addpath(genpath(filepath));

yr='2021'; % '2023'
load([filepath 'Data/BuddInlet_data_summary'],'T','fli','dmatrix','ymatrix');
%load([filepath 'Data\BuddInlet_data_summary'],'T','fli','dmatrix','ymatrix');

% create cells/mL vectors for Other
T.DOtherML=sum([T.DOdioML T.DParvML T.DAcutML],2);

% only select data from year of interest
T(~(T.dt.Year==str2double(yr)),:)=[];
fli(~(fli.dt.Year==str2double(yr)),:)=[];
idx=~(dmatrix.Year==str2double(yr)); dmatrix(idx)=[]; ymatrix(:,idx)=[];

%remove nans from microscopy dataset
M=T; M(isnan(M.DinoML_micro),:)=[];

%colorscheme
col=(brewermap(3,'Dark2')); 
c=[col(1,:);col(2,:);col(3,:)];
c(4,:)=[.1 .1 .1];
pink=brewermap(3,'PuRd');
B=flipud(brewermap(6,'Blues'));

%%%% pie chart of toxin cell quota at max cell densities
[~,idx]=max(M.DinoML_micro);
figure('Units','inches','Position',[1 1 1 1],'PaperPositionMode','auto');
p=piechart([M.DST_pgcell(idx) M.PTX2_pgcell(idx)],LabelStyle="none");
colororder([pink(3,:);B(1,:)])

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/maxcells_pgcell_pie_' yr '.png'],'Resolution',300)    

%% Total Dinophysis
figure('Units','inches','Position',[1 1 2.5 3.8],'PaperPositionMode','auto');
%subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.13], [0.19 0.05]);
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.12], [0.23 0.18]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(4,1,1);
    idx=(M.DinoML_micro==0);        
    h=plot(M.dt(~idx),[M.DFortML(~idx) M.DAcumML(~idx) M.DNorvML(~idx) M.DOtherML(~idx)],'o-',...
        'Linewidth',.5,'markersize',2); hold on;    
    for i=1:length(h), set(h(i),'Color',c(i,:)); end  
    
    ylabel({'cells/mL'},'fontsize',10); hold on;   
    set(gca,'xaxislocation','top','xlim',xax,'ylim',[0 12],'ytick',0:6:12,...
        'fontsize', 8,'fontname', 'arial','tickdir','out','ycolor','k')
    datetick('x', 'm', 'keeplimits');    
    ylabel({'cells/mL'},'fontsize',9); 
    title(yr,'fontsize', 10)   
%    lh=legend('\itfortii','\itacuminata','\itnorvegica','other','location','NW');
%    legend boxoff; lh.FontSize = 8; hp=get(lh,'pos');
%   lh.Position=[hp(1)-.03 hp(2)+.02 hp(3) hp(4)]; hold on   
  
subplot(4,1,2)
yyaxis left
idx=~isnan(T.PTX2_pgML);
plot(T.dt(idx),T.DST_pgML(idx),'o-','color',pink(3,:),'Markersize',2,'linewidth',.8); hold on
    set(gca,'ylim',[0 100],'ytick',0:50:100,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 8,'tickdir','out','ycolor',pink(3,:));
    ylabel({'pg/mL';'DST'},'fontsize',9); hold on;
yyaxis right
plot(T.dt(idx),T.PTX2_pgML(idx),'*-','Color',B(1,:),'Markersize',2,'linewidth',.5); hold on
    set(gca,'ylim',[0 400],'ytick',0:200:400,'xlim',[xax(1) xax(2)],'ycolor',B(1,:),'xticklabel',{},...
        'fontsize', 8,'tickdir','out');
    ylabel({'PTX2'},'fontsize',9); hold on;    

subplot(4,1,3)
idx=~isnan(T.PTX2_pgcell);
yyaxis left
plot(T.dt(idx),T.DST_pgcell(idx),'o-','color',pink(3,:),'Markersize',2,'linewidth',.8); hold on
    set(gca,'ylim',[0 15],'xlim',[xax(1) xax(2)],'ytick',0:15:15,'ycolor',pink(3,:),'xticklabel',{},'fontsize', 8,'tickdir','out');
    ylabel({'pg/cell';'DST'},'fontsize',9); hold on;
yyaxis right
plot(T.dt(idx),T.PTX2_pgcell(idx),'*-','Color',B(1,:),'Markersize',2,'linewidth',.5); hold on
    set(gca,'ylim',[0 152],'ytick',0:75:150,'xlim',[xax(1) xax(2)],'ycolor',B(1,:),'xticklabel',{},'fontsize',8,'tickdir','out');
    ylabel({'PTX2'},'fontsize',9); hold on;    

subplot(4,1,4)
idx=~isnan(T.DST);
plot(T.dt(idx),T.DST(idx),'o-','color',pink(3,:),'Markersize',2,'linewidth',.8); hold on;
yline(16,'k-','linewidth',.5); hold on;
yline(6,'k:','linewidth',.75); hold on;
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],'ylim',[0 32],'ytick',0:16:32,...
        'fontsize', 8,'tickdir','out','ycolor',pink(3,:));
    ylabel({'(µg/100g)';'DST'},'fontsize',9); hold on;
    datetick('x', 'm', 'keeplimits');   

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_Species_ToxinQuota_' yr '.png'],'Resolution',300)    
hold off



