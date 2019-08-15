%% Plot daily carbon, chlorophyll, and phytoplaknton for 2018 at SCW
% also plots carbon to chlorophyll comparison
% parts modified from "compile_biovolume_summaries"
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear

%%%% Step 1: Load in data
filepath = '~/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Wind_MB'],'w');

[phytoTotal,dino,diat,nano,zoop,carbonml,class2useTB,mdate] = extract_daily_carbon_SCW2018(...
    [filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018']);

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

%% Option 3: (top) legend (middle1) fraction phytoplankton, (middle2) carbon (bottom) environmental variables
figure('Units','inches','Position',[1 1 9 12],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.04 0.04], [0.09 0.08]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     

subplot(9,1,[4 5 6]); %species breakdown
select_dino=[carbonml(:,strmatch('Akashiwo',class2useTB)),...
    carbonml(:,strmatch('Ceratium',class2useTB)),...
    carbonml(:,strmatch('Dinophysis',class2useTB)),...    
    carbonml(:,strmatch('Gymnodinium',class2useTB)),...
    carbonml(:,strmatch('Lingulodinium',class2useTB)),...    
    carbonml(:,strmatch('Cochlodinium',class2useTB)),...    
    carbonml(:,strmatch('Prorocentrum',class2useTB)),...
    carbonml(:,strmatch('Peridinium',class2useTB)),...
    carbonml(:,strmatch('Scrip_Het',class2useTB))];

select_diat=[carbonml(:,strmatch('Chaetoceros',class2useTB)),...
    carbonml(:,strmatch('Det_Cer_Lau',class2useTB)),...
    carbonml(:,strmatch('Eucampia',class2useTB)),...
    carbonml(:,strmatch('Guin_Dact',class2useTB)),...   
    carbonml(:,strmatch('Pseudo-nitzschia',class2useTB)),...        
    carbonml(:,strmatch('Skeletonema',class2useTB)),...
    carbonml(:,strmatch('Thalassiosira',class2useTB)),...    
    carbonml(:,strmatch('Centric',class2useTB)),...        
    carbonml(:,strmatch('Pennate',class2useTB))];

fx_dino=select_dino./phytoTotal;
fx_otherdino=dino./phytoTotal-nansum(fx_dino,2);

fx_diat=select_diat./phytoTotal;
fx_otherdiat=diat./phytoTotal-nansum(fx_diat,2);
fx_diat(:,strmatch('Centric',class2useTB)) = ...
    sum([fx_diat(:,strmatch('Centric',class2useTB)) fx_otherdiat],2); % let other diatoms = centric
 
fx_nano=nano./phytoTotal; 

h = bar(mdate,[fx_dino fx_otherdino fx_diat fx_nano],'stack');

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(7,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGn'));
col_diat2=(brewermap(7,'Blues'));
col_diat3=(brewermap(5,'Purples'));

set(h(1),'FaceColor',col_dino1(10,:),'BarWidth',1); %aka
set(h(2),'FaceColor',col_dino1(9,:),'BarWidth',1); %cer
set(h(3),'FaceColor',col_dino1(8,:),'BarWidth',1); %dino
set(h(4),'FaceColor',col_dino1(7,:),'BarWidth',1); %gym
set(h(5),'FaceColor',col_dino1(6,:),'BarWidth',1); %ling
set(h(6),'FaceColor',col_dino2(7,:),'BarWidth',1); %margalef

set(h(7),'FaceColor',col_dino2(6,:),'BarWidth',1); %pro
set(h(8),'FaceColor',col_dino2(4,:),'BarWidth',2); %per
set(h(9),'FaceColor',col_dino2(2,:),'BarWidth',1); %scrip
set(h(10),'FaceColor',col_dino2(1,:),'BarWidth',1); %other dinos

set(h(11),'FaceColor',col_diat1(6,:),'BarWidth',1); %chae
set(h(12),'FaceColor',col_diat1(5,:),'BarWidth',1); %DCL
set(h(13),'FaceColor',col_diat1(3,:),'BarWidth',1); %Euc
set(h(14),'FaceColor',col_diat1(1,:),'BarWidth',1); %GuinDact
set(h(15),'FaceColor',col_diat2(2,:),'BarWidth',1); %PN
set(h(16),'FaceColor',col_diat2(3,:),'BarWidth',1); %skel
set(h(17),'FaceColor',col_diat2(5,:),'BarWidth',1); %thal
set(h(18),'FaceColor',col_diat2(7,:),'BarWidth',1); %Ceh
set(h(19),'FaceColor',col_diat3(5,:),'BarWidth',1); %Pen
set(h(20),'FaceColor',[100 100 100]./255,'BarWidth',1); %nanoplankton
 
    datetick('x', 'm', 'keeplimits')
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'xaxislocation','top','yticklabel',{'.2','.4','.6','.8','1'});
    ylabel('Fraction of total C', 'fontsize', 14)
        lh=legend('\itAkashiwo sanguinea','\itCeratium \rmspp.',...
        '\itDinophysis \rmspp.','\itGymnodinium \rmspp.',...
        '\itLingulodinium \rmspp.','\itMargalefidinium \rmspp.',...
        '\itProrocentrum \rmspp.','\itPeridinium \rmspp.',...
        '\itScrippsiella, Heterocapsa \rmspp.','other dinoflagellates',...
        '\itChaetoceros \rmspp.','\itDetonula, Cerataulina, Lauderia \rmspp.',...
        '\itEucampia \rmspp.','\itGuinardia, Dactyliosolen \rmspp.',...
        '\itPseudo-nitzschia \rmspp.','\itSkeletonema \rmspp.',...
        '\itThalassiosira \rmspp.','centric diatoms','pennate diatoms','nanoplankton');
    legend boxoff
    lh.FontSize = 10; hp=get(lh,'pos'); lh.Position=[hp(1)-.49 hp(2)+.35 hp(3) hp(4)]; 
    hold on

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
    
    [up,across]=rotate_current(ufilt,vfilt,44); 
    upp = interp1babygap(up,24); 
    [DF,UP,~] = ts_aggregation(df,upp,1,'day',@mean); 
    h1=plot(DF,UP,'-','Color','k','linewidth',2); 
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

%% Option 1: (top) carbon, (middle) fraction phytoplankton, (bottom) legend
figure('Units','inches','Position',[1 1 9 9.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.04 0.04], [0.08 0.08]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     

subplot(7,1,1); % total cell-derived biovolume
yyaxis left
    plot(mdate,phytoTotal,'ko','linewidth', 1,'Markersize',3.5);
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',12,...
        'fontname','arial','tickdir','out','ylim',[0 95],'ytick',30:30:90,'ycolor','k')
    ylabel({'C (\mug L^{-1})'}, 'fontsize', 14, 'fontname', 'arial'); hold on
yyaxis right
    datetick('x', 'm', 'keeplimits')
    plot(SC.dn,SC.CHL,'*r','linewidth', 1.5,'Markersize',5);
    ylabel({'Chl \ita \rm(\mug L^{-1})'}, 'fontsize', 14, 'fontname', 'arial')
    set(gca,'xaxislocation','top','xgrid','on','xlim',[xax1 xax2],'fontsize',12,'ycolor','r',...
        'fontname','arial','tickdir','out','ylim',[0 25],'ytick',5:10:25)    
    box on; hold on  
    
subplot(7,1,[2 3 4]); %species breakdown
select_dino=[carbonml(:,strmatch('Akashiwo',class2useTB)),...
    carbonml(:,strmatch('Ceratium',class2useTB)),...
    carbonml(:,strmatch('Dinophysis',class2useTB)),...    
    carbonml(:,strmatch('Gymnodinium',class2useTB)),...
    carbonml(:,strmatch('Lingulodinium',class2useTB)),...    
    carbonml(:,strmatch('Cochlodinium',class2useTB)),...    
    carbonml(:,strmatch('Prorocentrum',class2useTB)),...
    carbonml(:,strmatch('Peridinium',class2useTB)),...
    carbonml(:,strmatch('Scrip_Het',class2useTB))];

select_diat=[carbonml(:,strmatch('Chaetoceros',class2useTB)),...
    carbonml(:,strmatch('Det_Cer_Lau',class2useTB)),...
    carbonml(:,strmatch('Eucampia',class2useTB)),...
    carbonml(:,strmatch('Guin_Dact',class2useTB)),...   
    carbonml(:,strmatch('Pseudo-nitzschia',class2useTB)),...        
    carbonml(:,strmatch('Skeletonema',class2useTB)),...
    carbonml(:,strmatch('Thalassiosira',class2useTB)),...    
    carbonml(:,strmatch('Centric',class2useTB)),...        
    carbonml(:,strmatch('Pennate',class2useTB))];

fx_dino=select_dino./phytoTotal;
fx_otherdino=dino./phytoTotal-nansum(fx_dino,2);

fx_diat=select_diat./phytoTotal;
fx_otherdiat=diat./phytoTotal-nansum(fx_diat,2);
fx_diat(:,strmatch('Centric',class2useTB)) = ...
    sum([fx_diat(:,strmatch('Centric',class2useTB)) fx_otherdiat],2); % let other diatoms = centric
 
fx_nano=nano./phytoTotal; 

h = bar(mdate,[fx_dino fx_otherdino fx_diat fx_nano],'stack');

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(7,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGn'));
col_diat2=(brewermap(7,'Blues'));
col_diat3=(brewermap(5,'Purples'));

set(h(1),'FaceColor',col_dino1(10,:),'BarWidth',1); %aka
set(h(2),'FaceColor',col_dino1(9,:),'BarWidth',1); %cer
set(h(3),'FaceColor',col_dino1(8,:),'BarWidth',1); %dino
set(h(4),'FaceColor',col_dino1(7,:),'BarWidth',1); %gym
set(h(5),'FaceColor',col_dino1(6,:),'BarWidth',1); %ling
set(h(6),'FaceColor',col_dino2(7,:),'BarWidth',1); %margalef

set(h(7),'FaceColor',col_dino2(6,:),'BarWidth',1); %pro
set(h(8),'FaceColor',col_dino2(4,:),'BarWidth',2); %per
set(h(9),'FaceColor',col_dino2(2,:),'BarWidth',1); %scrip
set(h(10),'FaceColor',col_dino2(1,:),'BarWidth',1); %other dinos

set(h(11),'FaceColor',col_diat1(6,:),'BarWidth',1); %chae
set(h(12),'FaceColor',col_diat1(5,:),'BarWidth',1); %DCL
set(h(13),'FaceColor',col_diat1(3,:),'BarWidth',1); %Euc
set(h(14),'FaceColor',col_diat1(1,:),'BarWidth',1); %GuinDact
set(h(15),'FaceColor',col_diat2(2,:),'BarWidth',1); %PN
set(h(16),'FaceColor',col_diat2(3,:),'BarWidth',1); %skel
set(h(17),'FaceColor',col_diat2(5,:),'BarWidth',1); %thal
set(h(18),'FaceColor',col_diat2(7,:),'BarWidth',1); %Ceh
set(h(19),'FaceColor',col_diat3(5,:),'BarWidth',1); %Pen
set(h(20),'FaceColor',[100 100 100]./255,'BarWidth',1); %nanoplankton
 
    datetick('x', 'm', 'keeplimits')
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'},'XTickLabel',{});
    ylabel('Fraction of total C', 'fontsize', 14)
        lh=legend('\itAkashiwo sanguinea','\itCeratium \rmspp.',...
        '\itDinophysis \rmspp.','\itGymnodinium \rmspp.',...
        '\itLingulodinium \rmspp.','\itMargalefidinium \rmspp.',...
        '\itProrocentrum \rmspp.','\itPeridinium \rmspp.',...
        '\itScrippsiella, Heterocapsa \rmspp.','other dinoflagellates',...
        '\itChaetoceros \rmspp.','\itDetonula, Cerataulina, Lauderia \rmspp.',...
        '\itEucampia \rmspp.','\itGuinardia, Dactyliosolen \rmspp.',...
        '\itPseudo-nitzschia \rmspp.','\itSkeletonema \rmspp.',...
        '\itThalassiosira \rmspp.','centric diatoms','pennate diatoms','nanoplankton');
    legend boxoff
    lh.FontSize = 10; hp=get(lh,'pos'); lh.Position=[hp(1)-.49 hp(2)-.38 hp(3) hp(4)]; 
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_all.tif']);
hold off

%% Option 2: (top) fraction phytoplankton and legend, (bottom) carbon
figure('Units','inches','Position',[1 1 11 6.2],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.06 0.07], [0.07 0.28]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     

subplot(4,1,1); % total cell-derived biovolume
yyaxis left
    plot(mdate,total,'ko','linewidth', 1,'Markersize',3.5);
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',14,...
        'fontname','arial','tickdir','out','ylim',[0 95],'ytick',30:30:90,'ycolor','k')
    ylabel({'C (\mug L^{-1})'}, 'fontsize', 16, 'fontname', 'arial')
hold on
yyaxis right
    datetick('x', 'm', 'keeplimits')
    plot(SC.dn,SC.CHL,'*r','linewidth', 1.5,'Markersize',5);
    ylabel({'Chl (\mug L^{-1})'}, 'fontsize', 16, 'fontname', 'arial')
    set(gca,'xaxislocation','top','xgrid','on','xlim',[xax1 xax2],'fontsize',14,'ycolor','r',...
        'fontname','arial','tickdir','out','ylim',[0 25],'ytick',5:10:25)    
    box on
    hold on  
    
subplot(4,1,[2 3 4]); %species breakdown
select_dino=[carbonml(:,strmatch('Akashiwo',class2useTB)),...
    carbonml(:,strmatch('Ceratium',class2useTB)),...
    carbonml(:,strmatch('Dinophysis',class2useTB)),...    
    carbonml(:,strmatch('Gymnodinium',class2useTB)),...
    carbonml(:,strmatch('Cochlodinium',class2useTB)),...    
    carbonml(:,strmatch('Prorocentrum',class2useTB)),...
    carbonml(:,strmatch('Peridinium',class2useTB)),...
    carbonml(:,strmatch('Scrip_Het',class2useTB))];

select_diat=[carbonml(:,strmatch('Chaetoceros',class2useTB)),...
    carbonml(:,strmatch('Det_Cer_Lau',class2useTB)),...
    carbonml(:,strmatch('Eucampia',class2useTB)),...
    carbonml(:,strmatch('Guin_Dact',class2useTB)),...   
    carbonml(:,strmatch('Pseudo-nitzschia',class2useTB)),...        
    carbonml(:,strmatch('Skeletonema',class2useTB)),...
    carbonml(:,strmatch('Thalassiosira',class2useTB)),...    
    carbonml(:,strmatch('Centric',class2useTB)),...        
    carbonml(:,strmatch('Pennate',class2useTB))];

fx_otherdino=(dino-nansum(select_dino,2))./total; %fraction other dinos
fx_otherdiat=(diat-nansum(select_diat,2))./total; %fraction other dinos
fx_nano=nano./total; %fraction not dinos or diatoms

h = bar(mdate,[select_dino./total fx_otherdino select_diat./total fx_otherdiat fx_nano],'stack');
col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(7,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGn'));
col_diat2=(brewermap(7,'Blues'));
col_diat3=(brewermap(5,'Purples'));

set(h(1),'FaceColor',col_dino1(10,:),'BarWidth',1); %aka
set(h(2),'FaceColor',col_dino1(9,:),'BarWidth',1); %cer
set(h(3),'FaceColor',col_dino1(8,:),'BarWidth',1); %coch
set(h(4),'FaceColor',col_dino1(7,:),'BarWidth',1); %din
set(h(5),'FaceColor',col_dino2(7,:),'BarWidth',1); %gm
set(h(6),'FaceColor',col_dino2(6,:),'BarWidth',1); %pro
set(h(7),'FaceColor',col_dino2(4,:),'BarWidth',2); 
set(h(8),'FaceColor',col_dino2(2,:),'BarWidth',1); 
set(h(9),'FaceColor',col_dino2(1,:),'BarWidth',1); %other dinos

set(h(10),'FaceColor',col_diat1(6,:),'BarWidth',1); %chae
set(h(11),'FaceColor',col_diat1(5,:),'BarWidth',1); %DCL
set(h(12),'FaceColor',col_diat1(3,:),'BarWidth',1); %Euc
set(h(13),'FaceColor',col_diat1(1,:),'BarWidth',1); %GuinDact
set(h(14),'FaceColor',col_diat2(2,:),'BarWidth',1); %PN
set(h(15),'FaceColor',col_diat2(3,:),'BarWidth',1); %skel
set(h(16),'FaceColor',col_diat2(5,:),'BarWidth',1); %thal
set(h(17),'FaceColor',col_diat2(7,:),'BarWidth',1); %Ceh
set(h(18),'FaceColor',col_diat3(5,:),'BarWidth',1); %Pen
set(h(19),'FaceColor',col_diat3(3,:),'BarWidth',1); %other diat
set(h(20),'FaceColor',[100 100 100]./255,'BarWidth',1); %other cell derived
 
    datetick('x', 'm', 'keeplimits');
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 14,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'},'XTickLabel',{});
    ylabel('Fraction of total carbon biomass', 'fontsize', 16)
        lh=legend('\itAkashiwo sanguinea','\itCeratium',...
        '\itDinophysis','\itGymnodinium','\itMargalefidinium',...
        '\itProrocentrum','\itPeridinium','\itScrippsiella/Heterocapsa','other dinoflagellates',...
        '\itChaetoceros','\itDetonula/Cerataulina/Lauderia','\itEucampia',...
        '\itGuinardia/Dactyliosolen','\itPseudo-nitzschia','\itSkeletonema',...
        '\itThalassiosira','centric','pennate','other diatoms','nanoplankton');
    legend boxoff
    lh.FontSize = 13; hp=get(lh,'pos'); lh.Position=[hp(1) hp(2)+.03 hp(3)+.58 hp(4)]; 
    hold on
  
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_all.tif']);
hold off

%% plot chlorophyll to carbon comparison
col1=brewermap(1,'Greys');

[idx]=~isnan(SC.CHL); chl=SC.CHL(idx); dne=SC.dn(idx); % remove NaNs
[idx]=~isnan(phytoTotal); carbon=phytoTotal(idx); dni=mdate(idx); % remove NaNs
[~,ia,ib]=intersect(dne,dni); x=(chl(ia)); y=(carbon(ib));
Lfit = fitlm(x,y,'RobustOpts','on');
[~,outliers] = maxk((Lfit.Residuals.Raw),4);
x(outliers)=[]; y(outliers)=[];

Lfit = fitlm(x,y,'RobustOpts','on');
b = round(Lfit.Coefficients.Estimate(1),2,'significant');
m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
Rsq = round(Lfit.Rsquared.Ordinary,2,'significant')
xfit = linspace(min(x),max(x),100); 
yfit = m*xfit+b; 

figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
scatter(x,y,8,'k','linewidth',2); hold on 
L=plot(xfit,yfit,'-','Color',col1,'linewidth',1.5);
legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; r^2=' num2str(Rsq) ''],...
    'Location','NorthOutside'); legend boxoff
 set(gca,'fontsize',12,'tickdir','out',...
     'ylim',[0 50],'ytick',0:10:50,'xlim',[0 20],'xtick',0:5:20); box on
ylabel('C (\mug L^{-1})','fontsize',14);
xlabel('Chl \ita \rm(\mug L^{-1})','fontsize',14);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/IFCB_vs_ChlExtracted.tif']);
hold off

%% plot chlorophyll to carbon comparison
col1=brewermap(1,'Greys');

[idx]=~isnan(SC.CHL); chl=SC.CHL(idx); dne=SC.dn(idx); % remove NaNs
[idx]=~isnan(phytoTotal); carbon=phytoTotal(idx); dni=mdate(idx); % remove NaNs
[~,ia,ib]=intersect(dne,dni); x=log(chl(ia)); y=log(carbon(ib));
Lfit = fitlm(x,y,'RobustOpts','on');
[~,outliers] = maxk((Lfit.Residuals.Raw),2);
x(outliers)=[]; y(outliers)=[];

Lfit = fitlm(x,y,'RobustOpts','on');
b = round(Lfit.Coefficients.Estimate(1),2,'significant');
m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
Rsq = round(Lfit.Rsquared.Ordinary,2,'significant')
xfit = linspace(min(x),max(x),100); 
yfit = m*xfit+b; 

figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
scatter(x,y,8,'k','linewidth',2); hold on 
L=plot(xfit,yfit,'-','Color',col1,'linewidth',1.5);
legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; r^2=' num2str(Rsq) ''],...
    'Location','NorthOutside'); legend boxoff
 set(gca,'fontsize',12,'tickdir','out',...
     'ylim',[1 4],'ytick',0:1:4,'xlim',[0 3],'xtick',0:1:3); box on
ylabel('Log [C] (\mug L^{-1})','fontsize',14);
xlabel('Log [Chl \ita\rm] (\mug L^{-1})','fontsize',14);

%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/IFCB_vs_ChlExtracted_log.tif']);
hold off