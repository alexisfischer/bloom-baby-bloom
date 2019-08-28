%% Plot daily carbon, chlorophyll, and phytoplaknton for 2018 at SCW
% parts modified from 'compile_biovolume_summaries'
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

%%%% Load in data
filepath = '~/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Wind_MB'],'w');

[phytoTotal,dino,diat,nano,zoop,carbonml,class2useTB,mdate] = extract_daily_carbon(...
    [filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018']);

id=strcmp('Cochlodinium',class2useTB); class2useTB(id)={'Margalefidinium'};

dino_OI={'Akashiwo';'Ceratium';'Dinophysis';'Gymnodinium,Peridinium';...
    'Margalefidinium';'Prorocentrum';'Scrip_Het'};
[~,~,idino]=intersect(dino_OI,class2useTB); select_dino=carbonml(:,idino);

diat_OI={'Chaetoceros';'Det_Cer_Lau';'Eucampia';'Guin_Dact';'Pseudo-nitzschia';...
    'Skeletonema';'Thalassiosira';'Centric';'Pennate'};
[~,~,idiat]=intersect(diat_OI,class2useTB); select_diat=carbonml(:,idiat);

fx_dinoOI=select_dino./phytoTotal;
fx_otherdino=dino./phytoTotal-sum(fx_dinoOI,2);
fx_diatOI=select_diat./phytoTotal;
fx_otherdiat=diat./phytoTotal-nansum(fx_diatOI,2);
fx_diatOI(:,strcmp('Centric',diat_OI))=sum([fx_diatOI(:,strcmp('Centric',diat_OI)) fx_otherdiat],2); % let other diatoms = centric
fx_nano=nano./phytoTotal; 

[ ~, dino_label] = get_dino_ind_CA( dino_OI, dino_OI );
[ ~, diat_label] = get_diatom_ind_CA( diat_OI, diat_OI );

%%%% find monthly/annual fractions of interest
% itime=find(mdate>=datenum('01-Jan-2018') & mdate<=datenum('31-Mar-2018')); 
% nansum(dino(itime))/nansum(total(itime))
% nansum(diat(itime))/nansum(total(itime))
% nansum(nano(itime))/nansum(total(itime))
% 
% itime=find(mdate>=datenum('01-Jan-2018') & mdate<=datenum('31-Dec-2018')); 
% nansum(dino(itime))/nansum(total(itime))
% nansum(diat(itime))/nansum(total(itime))
% nansum(nano(itime))/nansum(total(itime))

test=sum([fx_dinoOI,fx_otherdino,fx_diatOI,fx_nano],2);
clearvars select_diat select_dino dino_OI diat_OI idino idiat carbonml fx_otherdiat id

%% (top) legend (middle1) fraction phytoplankton, (middle2) carbon (bottom) environmental variables
figure('Units','inches','Position',[1 1 9 12],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.04 0.04], [0.09 0.08]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
col_dino=[brewermap(10,'PiYG');flipud(brewermap(7,'YlOrBr'))];
col_diat=[brewermap(7,'YlGn');brewermap(7,'Blues');brewermap(5,'Purples')];

subplot(9,1,[4 5 6]); %species breakdown
h = bar(mdate,[fx_dinoOI fx_otherdino fx_diatOI fx_nano],'stack');
    set(h(1),'FaceColor',col_dino(1,:),'BarWidth',1); %aka
    set(h(2),'FaceColor',col_dino(2,:),'BarWidth',1); %cer
    set(h(3),'FaceColor',col_dino(4,:),'BarWidth',1); %dino
    set(h(4),'FaceColor',col_dino(11,:),'BarWidth',1); %gym
    set(h(5),'FaceColor',col_dino(12,:),'BarWidth',1); %margalef
    set(h(6),'FaceColor',col_dino(14,:),'BarWidth',1); %pro
    set(h(7),'FaceColor',col_dino(16,:),'BarWidth',2); %scrip
    set(h(8),'FaceColor',col_dino(17,:)','BarWidth',1); %other dino

    set(h(9),'FaceColor',col_diat(2,:),'BarWidth',1); %chae
    set(h(10),'FaceColor',col_diat(4,:),'BarWidth',1); %DCL
    set(h(11),'FaceColor',col_diat(6,:),'BarWidth',1); %Euc
    set(h(12),'FaceColor',col_diat(7,:),'BarWidth',1); %GuinDact   
    set(h(13),'FaceColor',col_diat(9,:),'BarWidth',1); %PN
    set(h(14),'FaceColor',col_diat(12,:),'BarWidth',1); %skel
    set(h(15),'FaceColor',col_diat(14,:),'BarWidth',1); %thal
    set(h(16),'FaceColor',col_diat(17,:),'BarWidth',1); %Ceh
    set(h(17),'FaceColor',col_diat(19,:),'BarWidth',1); %Pen
    set(h(18),'FaceColor',[100 100 100]./255,'BarWidth',1); %nanoplankton
 
    datetick('x', 'm', 'keeplimits');
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'xaxislocation','top','yticklabel',{'.2','.4','.6','.8','1'});
    ylabel('Fraction of total C','fontsize',14)
    lh=legend([dino_label;'other dinoflagellates';diat_label;'nanoplankton']);
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)-.49 hp(2)+.35 hp(3) hp(4)]; hold on
    
subplot(9,1,7); % total cell-derived biovolume
yyaxis left
    plot(mdate,phytoTotal,'ko','linewidth', 1,'Markersize',3.5);
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',12,'xticklabel',{},...
        'fontname','arial','tickdir','out','ylim',[0 95],'ytick',30:30:90,'ycolor','k')
    ylabel({'C (\mug L^{-1})'}, 'fontsize', 14, 'fontname', 'arial'); hold on
yyaxis right
    datetick('x', 'm', 'keeplimits')
    plot(SC.dn,SC.CHL,'*r','linewidth', 1.5,'Markersize',5);
    ylabel({'Chl \ita \rm(\mug L^{-1})'}, 'fontsize', 14, 'fontname', 'arial')
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',12,'ycolor','r',...
        'fontname','arial','tickdir','out','ylim',[0 25],'ytick',5:10:25,'xticklabel',{})    
    box on; hold on  
 
subplot(9,1,8) %regional upwelling
    itime=find(w.s42.dn>=xax1 & w.s42.dn<=xax2);
    [time,v,~] = ts_aggregation(w.s42.dn(itime),w.s42.v(itime),1,'hour',@mean); 
    [~,u,~] = ts_aggregation(w.s42.dn(itime),w.s42.u(itime),1,'hour',@mean);
    [vfilt,~]=plfilt(v,time); [ufilt,df]=plfilt(u,time);    
    
    [up,~]=rotate_current(ufilt,vfilt,44); 
    upp = interp1babygap(up,24); 
    [DF,UP,~] = ts_aggregation(df,upp,1,'day',@mean); 
    plot(DF,UP,'-','Color','k','linewidth',2); 
    hold on
    xL = get(gca, 'XLim'); plot(xL, [0 0], 'k--')      
    
    datetick('x', 'm', 'keeplimits')
    set(gca,'xlim',[xax1 xax2],'ylim',[-11 10],'ytick',-7:7:7,'fontsize',12,'tickdir','out');    
    ylabel('m s^{-1}','fontsize',14);
    hold on    
    
subplot(9,1,9) %regional upwelling  
yyaxis left
    plot(SC.dn,SC.sanlorR,'-k','linewidth',2);
    set(gca,'xgrid','on','ylim',[0 1500],'ytick',500:500:1500,'XLim',[xax1;xax2],...
       'fontsize',12,'tickdir','out','ycolor','k'); 
    ylabel({'ft^3 s^{-1}'},'fontsize',14);
    datetick('x','m','keeplimits');       
    hold on  
yyaxis right
    plot(SC.dn,SC.nitrate,'ob','linewidth',2,'markersize',4);
    set(gca,'xgrid','on','XLim',[xax1;xax2],...
        'ylim',[0 15],'fontsize',12,'tickdir','out','ycolor','b'); 
    ylabel({'uM'},'fontsize',14);
    hold on       
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_all_upwell.tif']);
hold off

%% for ppt presentation
figure('Units','inches','Position',[1 1 11 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.015 0.015], [0.07 0.02], [0.06 0.28]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
col_dino=[brewermap(10,'PiYG');flipud(brewermap(7,'YlOrBr'))];
col_diat=[brewermap(7,'YlGn');brewermap(7,'Blues');brewermap(5,'Purples')];
    
subplot(5,1,[1 2 3 4]); %species breakdown
h = bar(mdate,[fx_dinoOI fx_otherdino fx_diatOI fx_nano],'stack');
    set(h(1),'FaceColor',col_dino(1,:),'BarWidth',1); %aka
    set(h(2),'FaceColor',col_dino(2,:),'BarWidth',1); %cer
    set(h(3),'FaceColor',col_dino(4,:),'BarWidth',1); %dino
    set(h(4),'FaceColor',col_dino(5,:),'BarWidth',1); %gym
    set(h(5),'FaceColor',col_dino(11,:),'BarWidth',1); %ling
    set(h(6),'FaceColor',col_dino(12,:),'BarWidth',1); %margalef
    set(h(7),'FaceColor',col_dino(14,:),'BarWidth',1); %pro
    set(h(8),'FaceColor',col_dino(16,:),'BarWidth',2); %scrip
    set(h(9),'FaceColor',col_dino(17,:),'BarWidth',1); %other dino

    set(h(10),'FaceColor',col_diat(2,:),'BarWidth',1); %chae
    set(h(11),'FaceColor',col_diat(4,:),'BarWidth',1); %DCL
    set(h(12),'FaceColor',col_diat(6,:),'BarWidth',1); %Euc
    set(h(13),'FaceColor',col_diat(7,:),'BarWidth',1); %GuinDact   
    set(h(14),'FaceColor',col_diat(9,:),'BarWidth',1); %PN
    set(h(15),'FaceColor',col_diat(12,:),'BarWidth',1); %skel
    set(h(16),'FaceColor',col_diat(14,:),'BarWidth',1); %thal
    set(h(17),'FaceColor',col_diat(17,:),'BarWidth',1); %Ceh
    set(h(18),'FaceColor',col_diat(19,:),'BarWidth',1); %Pen
    set(h(19),'FaceColor',[100 100 100]./255,'BarWidth',1); %nanoplankton
 
    datetick('x', 'm', 'keeplimits');
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'xticklabel',{},'yticklabel',{'.2','.4','.6','.8','1'});
    ylabel('Fraction of total C','fontsize',14)
    lh=legend([dino_label;'other dinoflagellates';diat_label;'nanoplankton']);
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)-.49 hp(2) hp(3)+1.55 hp(4)]; hold on

subplot(5,1,5); % total cell-derived biovolume
yyaxis left
    plot(mdate,phytoTotal,'ko','linewidth', 1,'Markersize',3.5);
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',12,'xticklabel',{},...
        'fontname','arial','tickdir','out','ylim',[0 95],'ytick',30:30:90,'ycolor','k')
    ylabel({'C (\mug L^{-1})'}, 'fontsize', 14, 'fontname', 'arial'); hold on
yyaxis right
    datetick('x', 'm', 'keeplimits')
    plot(SC.dn,SC.CHL,'*r','linewidth', 1.5,'Markersize',5);
    ylabel({'Chl \ita \rm(\mug L^{-1})'}, 'fontsize', 14, 'fontname', 'arial')
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',12,'ycolor','r',...
        'fontname','arial','tickdir','out','ylim',[0 25],'ytick',5:10:25)    
    box on; hold on      
        
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_forppt.tif']);
hold off

%% just dino/diat fxs for ppt presentation
figure('Units','inches','Position',[1 1 11 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.015 0.015], [0.07 0.02], [0.06 0.28]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
col_dino=[brewermap(10,'PiYG');flipud(brewermap(7,'YlOrBr'))];
col_diat=[brewermap(7,'YlGn');brewermap(7,'Blues');brewermap(5,'Purples')];
    
subplot(5,1,[1 2 3 4]); %species breakdown
h = bar(mdate,[fx_dinoOI fx_otherdino fx_diatOI fx_nano],'stack');
    set(h(1),'FaceColor',col_dino(1,:),'BarWidth',1); %aka
    set(h(2),'FaceColor',col_dino(2,:),'BarWidth',1); %cer
    set(h(19),'FaceColor',[100 100 100]./255,'BarWidth',1); %nanoplankton
 
    datetick('x', 'm', 'keeplimits');
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'xticklabel',{},'yticklabel',{'.2','.4','.6','.8','1'});
    ylabel('Fraction of total C','fontsize',14)
    lh=legend([dino_label;'other dinoflagellates';diat_label;'nanoplankton']);
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)-.49 hp(2) hp(3)+1.55 hp(4)]; hold on

subplot(5,1,5); % total cell-derived biovolume
yyaxis left
    plot(mdate,phytoTotal,'ko','linewidth', 1,'Markersize',3.5);
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',12,'xticklabel',{},...
        'fontname','arial','tickdir','out','ylim',[0 95],'ytick',30:30:90,'ycolor','k')
    ylabel({'C (\mug L^{-1})'}, 'fontsize', 14, 'fontname', 'arial'); hold on
yyaxis right
    datetick('x', 'm', 'keeplimits')
    plot(SC.dn,SC.CHL,'*r','linewidth', 1.5,'Markersize',5);
    ylabel({'Chl \ita \rm(\mug L^{-1})'}, 'fontsize', 14, 'fontname', 'arial')
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',12,'ycolor','r',...
        'fontname','arial','tickdir','out','ylim',[0 25],'ytick',5:10:25)    
    box on; hold on      
        
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_fxdino_diat_forppt.tif']);
hold off
