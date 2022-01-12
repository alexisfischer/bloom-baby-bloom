%% Plot daily carbon, chlorophyll, and phytoplaknton for 2018 at SCW
% parts modified from 'compile_biovolume_summaries'
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
addpath(genpath('~/MATLAB/UCSC/')); % add new data to search path

clear;

%%%% Load in data
filepath = '~/MATLAB/UCSC/SCW/'; 
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Wind_MB'],'w');

[phytoTotal,dino,diat,nano,zoop,carbonml,classbiovol,class2useTB,mdate] = extract_daily_carbon_SCW(...
    '~/MATLAB/bloom-baby-bloom/IFCB-Data/SCW/class/summary_biovol_allTB2018');

%save([filepath 'Data/IFCB_summary/class/carbon_summary_SCW2018'],'carbonml','classbiovol','class2useTB','mdate');

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

[~, dino_label] = get_dino_ind_CA( dino_OI, dino_OI );
[~, diat_label] = get_diatom_ind_CA( diat_OI, diat_OI );

%% find monthly/annual fractions of interest
% date=datenum('08-Aug-2018'); 
% DTint=(date-3:1:date+3)';
% 
% [time,itime]=intersect(mdate,DTint);
% datestr(time)

itime=find(SC.dn==datenum('26-Jan-2019') & SC.dn<=datenum('01-Feb-2019'))
SC.DINOrai(itime)

nansum(diat(itime))/nansum(phytoTotal(itime))
nansum(dino(itime))/nansum(phytoTotal(itime))
nansum(nano(itime))/nansum(phytoTotal(itime))
% 
% itime=find(mdate>=datenum('01-Jan-2018') & mdate<=datenum('31-Dec-2018')); 
% nansum(dino(itime))/nansum(total(itime))
% nansum(diat(itime))/nansum(total(itime))
% nansum(nano(itime))/nansum(total(itime))

%%%% find chl fluorescence
itime=find(SC.dn==datenum('-Apr-2019'));% & mdate<=datenum('31-May-2018')); 
SC.CHLsensor(itime)

%%%%
test=sum([fx_dinoOI,fx_otherdino,fx_diatOI,fx_nano],2);
clearvars select_diat select_dino dino_OI diat_OI idino idiat carbonml fx_otherdiat id

%% (top) legend (middle1) fraction phytoplankton, (middle2) carbon (bottom) environmental variables
figure('Units','inches','Position',[1 1 9 11.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.03 0.04], [0.08 0.08]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
xax1=datenum('2017-04-21'); xax2=datenum('2017-04-23');     

subplot(9,1,[4 5 6]); %species breakdown
h = bar(round(mdate),[fx_dinoOI fx_otherdino fx_diatOI fx_nano],'stack','Barwidth',1);

    col_dino=[brewermap(10,'PiYG');flipud(brewermap(7,'YlOrBr'))];
    col_diat=[brewermap(7,'YlGn');brewermap(7,'Blues');brewermap(5,'Purples')];
    col=[col_dino(1:2,:);col_dino(4,:);col_dino(11:12,:);col_dino(14,:);...
        col_dino(16:17,:);col_diat(2,:);col_diat(4,:);col_diat(6:7,:);...
        col_diat(9,:);col_diat(12,:);col_diat(14,:);col_diat(17,:);...
        col_diat(19,:);[.4 .4 .4]];
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end
    datetick('x', 'm', 'keeplimits');
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 14,'fontname', 'arial','tickdir','out',...
        'xaxislocation','top','yticklabel',{'.2','.4','.6','.8','1'});
    ylabel('Fraction of total C','fontsize',15)
    lh=legend([dino_label;'other dinoflagellates';diat_label;'nanoplankton']);
    legend boxoff; lh.FontSize = 12; hp=get(lh,'pos');
    lh.Position=[hp(1)-.48 hp(2)+.36 hp(3) hp(4)]; hold on
    
subplot(9,1,7); % total cell-derived biovolume
yyaxis left
    plot(mdate,phytoTotal,'ko','linewidth', 1,'Markersize',3.5);
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',14,'xticklabel',{},...
        'fontname','arial','tickdir','out','ylim',[0 95],'ytick',30:30:90,'ycolor','k')
    ylabel({'C (\mug L^{-1})'}, 'fontsize', 15, 'fontname', 'arial'); hold on
yyaxis right
    datetick('x', 'm', 'keeplimits')
    plot(SC.dn,SC.CHL,'*r','linewidth', 1.5,'Markersize',5);
    ylabel({'Chl \ita \rm(\mug L^{-1})'}, 'fontsize', 15, 'fontname', 'arial')
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',14,'ycolor','r',...
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
    set(gca,'xlim',[xax1 xax2],'ylim',[-11 10],'ytick',-7:7:7,'xticklabel',{},'fontsize',14,'tickdir','out');    
    ylabel('m s^{-1}','fontsize',15);
    hold on    
    
subplot(9,1,9) 
yyaxis left
    plot(SC.dn,SC.sanlorR,'-k','linewidth',2);
    set(gca,'xgrid','on','ylim',[0 1500],'ytick',400:400:1200,'XLim',[xax1;xax2],...
       'fontsize',14,'yticklabel',{'.4','.8','1.2'},'tickdir','out','ycolor','k'); 
    ylabel({'ft^3 s^{-1}'},'fontsize',15);
    datetick('x','m','keeplimits');       
    hold on  
yyaxis right
    plot(SC.dn,SC.nitrate,'ob','linewidth',2,'markersize',4);
    set(gca,'xgrid','on','XLim',[xax1;xax2],...
        'ylim',[0 15],'ytick',5:5:15,'fontsize',14,'tickdir','out','ycolor','b'); 
    ylabel({'uM'},'fontsize',15);
    hold on       
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'Figs/SCW2018_all_upwell.tif']);
hold off

%% for ppt presentation
figure('Units','inches','Position',[1 1 11 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.015 0.015], [0.07 0.02], [0.06 0.28]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     

%justdino=1;
justdino=0;

if justdino==0
    subplot(5,1,[1 2 3 4]); %species breakdown
    col_dino=[brewermap(10,'PiYG');flipud(brewermap(7,'YlOrBr'))];
    col_diat=[brewermap(7,'YlGn');brewermap(7,'Blues');brewermap(5,'Purples')];    
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
            'xticklabel',{},'yticklabel',{'.2','.4','.6','.8','1'});
        ylabel('Fraction of total C','fontsize',14)
        lh=legend([dino_label;'other dinoflagellates';diat_label;'nanoplankton']);
        legend boxoff; lh.FontSize = 11; hp=get(lh,'pos');
        lh.Position=[hp(1)-.49 hp(2) hp(3)+1.57 hp(4)]; hold on

elseif justdino==1
    subplot(5,1,[1 2 3 4]); %species breakdown
    color=brewermap(2,'Set2');
    h = bar(mdate,[dino./phytoTotal diat./phytoTotal fx_nano],'stack');
        set(h(1),'FaceColor',color(2,:),'BarWidth',1); %aka
        set(h(2),'FaceColor',color(1,:),'BarWidth',1); %cer
        set(h(3),'FaceColor',[100 100 100]./255,'BarWidth',1); %nanoplankton

        datetick('x', 'm', 'keeplimits');
        set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
            'fontsize', 12,'fontname', 'arial','tickdir','out',...
            'xticklabel',{},'yticklabel',{'.2','.4','.6','.8','1'});
        ylabel('Fraction of total C','fontsize',14)
        lh=legend('dinoflagellates','diatoms','nanoplankton');
        legend boxoff; lh.FontSize = 14; hp=get(lh,'pos');
        lh.Position=[hp(1)-.49 hp(2) hp(3)+1.35 hp(4)]; hold on       
end

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
        
%% set figure parameters
set(gcf,'color','w');
if justdino==0   
    print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_forppt.tif']);
elseif justdino==1
    print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_fxdino_diat_forppt.tif']);
end
hold off


%% news article
figure('Units','inches','Position',[1 1 12 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.015 0.015], [0.07 0.02], [0.06 0.3]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     

    subplot(5,1,[1 2 3 4]); %species breakdown
    col_dino=[brewermap(10,'PiYG');flipud(brewermap(7,'YlOrBr'))];
    col_diat=[brewermap(7,'YlGn');brewermap(7,'Blues');brewermap(5,'Purples')];    
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
            'yticklabel',{'.2','.4','.6','.8','1'});
        ylabel('Fraction of Total Phytoplankton Carbon','fontsize',14)
        lh=legend([dino_label;'other dinoflagellates';diat_label;'nanoplankton']);
        legend boxoff; lh.FontSize = 13; hp=get(lh,'pos');
        lh.Position=[hp(1)-.49 hp(2) hp(3)+1.6 hp(4)]; hold on


% set figure parameters
set(gcf,'color','w');
    print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_fxdino_diat_forKathleen.tif']);
hold off
