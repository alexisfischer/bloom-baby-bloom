%% Plot daily carbon, chlorophyll, and phytoplaknton for 2018 at SCW
% parts modified from 'compile_biovolume_summaries'
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

%%%% Load in data
filepath = '~/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/SCW_master'],'SC');

[phytoTotal,dino,diat,nano,zoop,carbonml,class2useTB,mdate] = extract_daily_carbon(...
    [filepath 'Data/IFCB_summary/class/summary_biovol_allTB2017']);

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
% itime=find(mdate==datenum('07-Aug-2019'))
% nansum(dino(itime))/nansum(phytoTotal(itime))
% nansum(diat(itime))/nansum(phytoTotal(itime))
% nansum(nano(itime))/nansum(phytoTotal(itime))

clearvars select_diat select_dino dino_OI diat_OI idino idiat carbonml fx_otherdiat id

%% (top) legend (middle1) fraction phytoplankton, (middle2) carbon (bottom) environmental variables
figure('Units','inches','Position',[1 1 3.5 8.4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.05 0.03], [0.18 0.12]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=datenum('2017-05-04');
str=datestr(xax);

%xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
col_dino=[brewermap(10,'PiYG');flipud(brewermap(7,'YlOrBr'))];
col_diat=[brewermap(7,'YlGn');brewermap(7,'Blues');brewermap(5,'Purples')];

subplot(7,1,[4 5 6]); %species breakdown
h = bar(round(mdate),[fx_dinoOI fx_otherdino fx_diatOI fx_nano],'stack');
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
 
    datetick('x', 'dd', 'keeplimits');
    set(gca,'xlim',[xax-1 xax+1],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'xaxislocation','top','yticklabel',{'.2','.4','.6','.8','1'});
    ylabel('Fraction of total C','fontsize',14)
    lh=legend([dino_label;'other dinoflagellates';diat_label;'nanoplankton']);
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)+.1 hp(2)+.44 hp(3) hp(4)]; hold on
    
subplot(7,1,7); % total cell-derived biovolume
    plot(mdate,phytoTotal,'ko','linewidth', 1,'Markersize',5,'markerfacecolor','k');
    ylabel({'C (\mug L^{-1})'}, 'fontsize', 14, 'fontname', 'arial'); hold on
    datetick('x', 'dd-mmm-yy', 'keeplimits')
    set(gca,'xgrid','on','xlim',[xax-1 xax+1],'fontsize',12,...
        'fontname','arial','tickdir','out','ylim',[0 25],'ytick',5:10:25)    
    box on; hold on  
    datetick('x', 'dd-mmm-yy', 'keeplimits')
    
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/IFCB_Dorado_' str '.tif']);
hold off
    