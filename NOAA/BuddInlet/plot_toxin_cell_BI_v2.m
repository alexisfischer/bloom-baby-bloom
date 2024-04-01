%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2022'; % '2023'
ydinolim=[0 4]; ymesolim=[0 10]; 
load([filepath 'Data/BuddInlet_data_summary'],'T','fli','dmatrix','ymatrix');

figure('Units','inches','Position',[1 1 3 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.07 0.11], [0.16 0.24]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(4,1,1);
h = bar(T.dt,[T.fx_Dfortii T.fx_Dacuminata T.fx_Dnorvegica T.fx_Dodiosa...
    T.fx_Drotundata T.fx_Dparva T.fx_Dacuta],'stack','Barwidth',3.5,'linestyle','none');
    c=(brewermap(7,'Paired'));
    for i=1:length(h), set(h(i),'FaceColor',c(i,:)); end  
    set(gca,'xaxislocation','top','xlim',xax,'ylim',[0 1],'ytick',0:.5:1,...
        'fontsize', 9,'fontname', 'arial','tickdir','out','ycolor','k')
    ylabel({'species fx'},'fontsize',11);
    % lh=legend('\itfortii','\itacuminata','\itnorvegica','\itodiosa',...
    %     '\itrotundata','\itparva','\itacuta');
    % legend boxoff; lh.FontSize = 8; hp=get(lh,'pos');
    % lh.Position=[hp(1)+.26 hp(2)+.04 hp(3) hp(4)]; hold on    
    datetick('x', 'm', 'keeplimits');   
title(yr,'fontsize', 11)   

subplot(4,1,2); 
%%%Option 1
% idx=find(isnan(T.dino_fl)); val=0.1*ones(size(idx));
% h1=plot(T.dt,T.dino_fl,'k-','linewidth',1.5); hold on;
%     set(gca,'xlim',[xax(1) xax(2)],'ylim',ydinolim,'ytick',0:2:4,'xticklabel',{},...
%         'fontsize', 9,'tickdir','out','ycolor','k');  
%     ylabel('cells/mL','fontsize',11); hold on; 
% 
%     % add grey lines to axis where no IFCB data 
%     idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
%     hn=plot(T.dt(idx),val,'s','markersize',3,'linewidth',.5,'color',[.5 .5 .5],'markerfacecolor',[.5 .5 .5]); hold on;              
%     if strcmp(yr,'2021')
%         iend=find(~isnan(T.dino_fl),1); 
%         dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
%         val=0.1*ones(size(dti));
%         plot(dti,val,'-','linewidth',3.2,'color',[.5 .5 .5]); hold on;        
%     end

%%%%Option 2
P=prctile(ymatrix,[25 50 75],1); x=dmatrix'; y1=P(1,:); y2=P(2,:); y3=P(3,:);
    hf=plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
    % h27=patch([x fliplr(x)], [y1 fliplr(y3)],[65 173 213]./255,'Edgecolor',[76 134 162]./255,'Linewidth',1); hold on
    % h50=plot(x,y2,'-','Color',[16 48 82]./255,'Linewidth',2); hold on;

    %deal with data gaps
    xx=datetime('15-Aug-2021'):1:datetime('18-Aug-2021');
    yy1=.05*ones(size(xx)); yy2=3*ones(size(xx));
    patch([xx fliplr(xx)], [yy1 fliplr(yy2)],'w','Edgecolor','none'); hold on

    %deal with data gaps
    xx=datetime('26-Jul-2022'):1:datetime('03-Aug-2022');
    yy1=.05*ones(size(xx)); yy2=5.5*ones(size(xx));
    patch([xx fliplr(xx)], [yy1 fliplr(yy2)],'w','Edgecolor','none'); hold on    

    %deal with data gaps
    xx=datetime('28-Sep-2022'):1:datetime('01-Oct-2022');
    yy1=.05*ones(size(xx)); yy2=3*ones(size(xx));
    patch([xx fliplr(xx)], [yy1 fliplr(yy2)],'w','Edgecolor','none'); hold on        

    %deal with data gaps
    xx=datetime('24-Jun-2023'):1:datetime('27-Jun-2023');
    yy1=.05*ones(size(xx)); yy2=3*ones(size(xx));
    patch([xx fliplr(xx)], [yy1 fliplr(yy2)],'w','Edgecolor','none'); hold on        

    hm=plot(T.dt,T.dinoML_microscopy,'r^','markerfacecolor','r','Linewidth',.8,'markersize',4); hold on;            
    ylabel({'dino/mL'},'fontsize',11); hold on;   
        set(gca,'xgrid','on','tickdir','out','xlim',xax,'xticklabel',{},...
            'ylim',[0 15],'ytick',0:7:14,'fontsize',10,'ycolor','k','box','on');         
set(gca,'Layer','top'); grid off;        
%lh=legend([hf h50 h27 hm],'raw IFCB','median','25-75%','microscopy','location','east');  
%hp=get(lh,'pos'); lh.Position=[hp(1)+.27 hp(2) hp(3) hp(4)]; hold on            

subplot(4,1,3)
yyaxis left
idx=~isnan(T.PTX2_pgcell);
plot(T.dt(idx),T.DST_pgcell(idx),'ko-','Markersize',3,'linewidth',1); hold on
    set(gca,'ylim',[0 12],'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel({'DST (pg/cell)'},'fontsize',11); hold on;
yyaxis right
plot(T.dt(idx),T.PTX2_pgcell(idx),'o-','Color',c(2,:),'Markersize',3,'linewidth',1); hold on
    set(gca,'ylim',[0 155],'ytick',0:75:150,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 9,'tickdir','out','ycolor',c(2,:));
    ylabel({'PTX2 (pg/cell)'},'fontsize',11); hold on;    

subplot(4,1,4)
idx=~isnan(T.DST);
plot(T.dt(idx),T.DST(idx),'k.:','Markersize',12,'linewidth',1.5); hold on;
hline(16,'k:'); hold on;
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel({'DST (µg/100g)'},'fontsize',11); hold on;
    datetick('x', 'm', 'keeplimits');   
             
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_toxin_vs_cell_' yr '.png'],'Resolution',300)    
hold off

