%% Plot daily phytoplaknton carbon fractions for 2018 at SCW
%  Alexis D. Fischer, University of California - Santa Cruz, October 2020

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
addpath(genpath('~/MATLAB/UCSC/')); % add new data to search path

clear;

%%%% Load in data
filepath1 = '~/MATLAB/bloom-baby-bloom/IFCB-Data/SCW/class/';
filepath2 = '~/MATLAB/UCSC/SCW/';

load([filepath2 'Data/SCW_master'],'SC');
load([filepath2 'Data/Wind_MB'],'w');

[phytoTotal,dino,diat,nano,zoop,carbonml,classbiovol,class2useTB,mdate] = extract_daily_carbon_SCW(...
    '~/MATLAB/bloom-baby-bloom/IFCB-Data/SCW/class/summary_biovol_allTB2018');

id=strcmp('Cochlodinium',class2useTB); class2useTB(id)={'Margalefidinium'};

dino_OI={'Akashiwo';'Ceratium';'Dinophysis';'Gymnodinium,Peridinium';...
    'Margalefidinium';'Prorocentrum';'Scrip_Het'};
[~,~,idino]=intersect(dino_OI,class2useTB); select_dino=carbonml(:,idino);

diat_OI={'Chaetoceros';'Det_Cer_Lau';'Eucampia';'Guin_Dact';'Pseudo-nitzschia';...
    'Skeletonema';'Thalassiosira';'Centric';'Pennate'};
[~,~,idiat]=intersect(diat_OI,class2useTB); select_diat=carbonml(:,idiat);

%%
fx_dinoOI=select_dino./phytoTotal;
fx_otherdino=dino./phytoTotal-sum(fx_dinoOI,2);
fx_diatOI=select_diat./phytoTotal;
fx_otherdiat=diat./phytoTotal-nansum(fx_diatOI,2);
fx_diatOI(:,strcmp('Centric',diat_OI))=sum([fx_diatOI(:,strcmp('Centric',diat_OI)) fx_otherdiat],2); % let other diatoms = centric
fx_nano=nano./phytoTotal; 

[~, dino_label] = get_dino_ind_CA( dino_OI, dino_OI );
[~, diat_label] = get_diatom_ind_CA( diat_OI, diat_OI );

figure('Units','inches','Position',[1 1 8 4.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.015 0.015], [0.07 0.02], [0.09 0.35]);
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
            'xticklabel',{},'yticklabel',{'.2','.4','.6','.8','1'});
        ylabel('fraction of phytoplankton carbon','fontsize',14)
        lh=legend([dino_label;'other dinoflagellates';diat_label;'nanoplankton']);
        legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
        lh.Position=[hp(1)-.49 hp(2)+.04 hp(3)+1.73 hp(4)]; hold on

subplot(5,1,5); 
%%%% load in Pseudo-nitzschia data
    class2do_string = 'Pseudo-nitzschia'; chain=4; yr='2018'; error=0.7;
    [class2do_string,mdate,~,~,iraifx,fish,mcrpy,RAI]=matchClassifierwMicroscopy(filepath1,[filepath2 'Data/'],class2do_string,chain,error,'2018');
    load([filepath1 'summary_allTB_' yr],'class2useTB','ml_analyzedTB','mdateTB','classcountTB_above_optthresh');
    y_mat=classcountTB_above_optthresh(:,strcmp(class2do_string, class2useTB)).*chain; %class
    y_mat=y_mat./ml_analyzedTB;

    clearvars classcountTB_above_optthresh ml_analyzedTB class2useTB;

%%%% 
bar(mdateTB, y_mat,'FaceColor','k','Barwidth',20); hold on
    h1 = plot(datenum('01-Jan-2019'),2,'linewidth',1.5,'color','k'); hold on     
    h3 = errorbar(fish.dn,fish.cells,fish.err,'o','Linestyle','none','Linewidth',1.5,...
    'Color','r','MarkerFaceColor','r','Markersize',3.5); hold on  

    set(gca,'xlim',[xax1 xax2],'xaxislocation','bottom','ytick',0:50:100,...
        'fontsize',12,'Ylim',[0 110],'tickdir','out');  
    datetick('x','m','keeplimits');       

    lh=legend([h1,h3],'Classified IFCB','FISH Microscopy','Location','E','fontsize',11);    
    lh.Title.String=['\it' class2do_string ' \rmspp.']; lh.Title.FontSize=11;
        legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
        lh.Position=[hp(1)-.49 hp(2)-.02 hp(3)+1.45 hp(4)]; hold on      
    legend boxoff
    ylabel('cells mL^{-1}','fontsize',14); hold on    
    
    
%%
set(gcf,'color','w');
print(gcf,'-dtiff','-r400',[filepath2 'Figs/SCW2018_phytocarbon_' num2str(class2do_string) '.tif']);
hold off