%% Zoom into blooms for specific time periods
% parts modified from "compile_biovolume_summaries"
%  Alexis D. Fischer, University of California - Santa Cruz, February 2019

addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
%%
year=2018; %USER

%%%% Step 1: Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/'; % MAC 
% filepath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\'; %PC
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS','CA','MB');

load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Wind_MB'],'w');
load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018'],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');
    
%%%% Step 2: Convert Biovolume to Carbon
% convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
[ cellC ] = biovol2carbon(classbiovolTB, ind_diatom ); 

%convert from per cell to per mL
volC=zeros(size([cellC]));
volB=zeros(size([cellC]));

for i=1:length(cellC)
    volC(i,:)=cellC(i,:)./ml_analyzedTB(i);
    volB(i,:)=classbiovolTB(i,:)./ml_analyzedTB(i);    
end
    
%convert from pg/mL to ug/L 
volC=volC./1000;

%%
%%%% Step 3: Determine what fraction of Cell-derived carbon is 
% Dinoflagellates vs Diatoms vs Classes of interest

% HIGH RESOLUTION

% using this for full 2018
% n=10;
% maxgap=10;

n=4;
maxgap=8;

%select total living biovolume 
[ ind_cell, ~ ] = get_cell_ind_CA( class2useTB, class2useTB );
[xmat,ymat,~] =  ts_aggregation(mdateTB,nansum(volC(:,ind_cell),2),n,'hour',@mean);
[~,ymat_ml,~] =  ts_aggregation(mdateTB,ml_analyzedTB,n,'hour',@mean);

%select only diatoms
[ ind_diatom, class_label_diat ] = get_diatom_ind_CA( class2useTB, class2useTB );
[~,ydiat,~] =  ts_aggregation(mdateTB,nansum(volC(:,ind_diatom),2),n,'hour',@mean);

%select only dinoflagellates
[ ind_dino, class_label_dino ] = get_dino_ind_CA( class2useTB, class2useTB );
[~,ydino,~] =  ts_aggregation(mdateTB,nansum(volC(:,ind_dino),2),n,'hour',@mean);

% extract biovolume and carbon for each class (daily average)
for i=1:length(class2useTB)
    BIO(i).class = class2useTB(i);
    [~,BIO(i).bio,~] = ts_aggregation(mdateTB,volB(:,i),n,'hour',@mean);
    [~,BIO(i).car,~] = ts_aggregation(mdateTB,volC(:,i),n,'hour',@mean);
end

%%%% Step 4: Interpolate data for small data gaps 
for i=1:length(BIO)
    [BIO(i).bio_i] = interp1babygap(BIO(i).bio,maxgap);
    [BIO(i).car_i] = interp1babygap(BIO(i).car,maxgap);
end

% % can comment
% for i=1:length(BIO)
%     [BIO(i).bio_i] = smooth(BIO(i).bio_i,3);
%     [BIO(i).car_i] = smooth(BIO(i).car_i,3);
% end

for i=1:length(ydino)
    [ydino] = interp1babygap(ydino,maxgap);
    [ydiat] = interp1babygap(ydiat,maxgap);
    [ymat] = interp1babygap(ymat,maxgap);
    [ymat_ml] = interp1babygap(ymat_ml,maxgap);
end

% % can comment
% for i=1:length(ydino)
%     [ydino] = smooth(ydino,2);
%     [ydiat] = smooth(ydiat,2);
%     [ymat] = smooth(ymat,2);
%     [ymat_ml] = smooth(ymat_ml,2);
% end

for i=1:length(class2useTB)
    BIO(i).class = class2useTB(i);
    [~,BIO(i).bio,~] = ts_aggregation(mdateTB,volB(:,i),12,'hour',@mean);
end


%% Spring Akashiwo bloom 
figure('Units','inches','Position',[1 1 13 11],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.015 0.015], [0.05 0.05], [0.07 0.27]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-19'); xax2=datenum('2018-04-14'); xtick=((xax1+2):10:xax2);
%xax1=datenum('2018-02-15'); xax2=datenum('2018-04-28'); xtick=((xax1+2):10:xax2);

fxdino = ydino./(ymat);
fxdiat = ydiat./(ymat);
fx_other=(ymat-(ydino+ydiat))./ymat; %fraction not dinos or diatoms

%species breakdown
subplot(7,1,[1 2 3]);
select_dino=[BIO(strmatch('Akashiwo',class2useTB)).car_i,...
    BIO(strmatch('Ceratium',class2useTB)).car_i,...
    BIO(strmatch('Dinophysis',class2useTB)).car_i,...    
    BIO(strmatch('Gymnodinium',class2useTB)).car_i,...
    BIO(strmatch('Cochlodinium',class2useTB)).car_i,...    
    BIO(strmatch('Prorocentrum',class2useTB)).car_i];

fx_otherdino=(ydino-sum(select_dino,2))./ymat; %fraction other dinos

select_diat=[BIO(strmatch('Chaetoceros',class2useTB)).car_i,...
    BIO(strmatch('Det_Cer_Lau',class2useTB)).car_i,...
    BIO(strmatch('Eucampia',class2useTB)).car_i,...
    BIO(strmatch('Guin_Dact',class2useTB)).car_i,...   
    BIO(strmatch('Pseudo-nitzschia',class2useTB)).car_i,...        
    BIO(strmatch('Skeletonema',class2useTB)).car_i,...
    BIO(strmatch('Centric',class2useTB)).car_i,...    
    BIO(strmatch('Pennate',class2useTB)).car_i];

fx_otherdiat=(ydiat-sum(select_diat,2))./ymat; %fraction other dinos

h=bar(xmat,[100*select_dino./ymat 100*fx_otherdino ...
    100*select_diat./ymat 100*fx_otherdiat 100*fx_other], 'stack');
set(h, 'barwidth', 1.2)
col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(5,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGnBu'));
col_diat2=(brewermap(5,'Purples'));

set(h(1),'FaceColor',col_dino1(10,:),'BarWidth',1); %aka
set(h(2),'FaceColor',col_dino1(9,:),'BarWidth',1); %cer
set(h(3),'FaceColor',col_dino1(8,:),'BarWidth',1); %coch
set(h(4),'FaceColor',col_dino2(5,:),'BarWidth',1); %din
set(h(5),'FaceColor',col_dino2(4,:),'BarWidth',1); %gm
set(h(6),'FaceColor',col_dino2(2,:),'BarWidth',1); %pro
set(h(7),'FaceColor',col_dino2(1,:),'BarWidth',1); %other dinos
set(h(8),'FaceColor',col_diat1(6,:),'BarWidth',1); %chae
set(h(9),'FaceColor',col_diat1(5,:),'BarWidth',1); %DCL
set(h(10),'FaceColor',col_diat1(4,:),'BarWidth',1); %Euc
set(h(11),'FaceColor',col_diat1(3,:),'BarWidth',1); %GuinDact
set(h(12),'FaceColor',col_diat1(2,:),'BarWidth',1); %PN
set(h(13),'FaceColor',col_diat1(1,:),'BarWidth',1); %skel
set(h(14),'FaceColor',col_diat2(5,:),'BarWidth',1); %Ceh
set(h(15),'FaceColor',col_diat2(4,:),'BarWidth',1); %Pen
set(h(16),'FaceColor',col_diat2(2,:),'BarWidth',1); %other diat
set(h(17),'FaceColor',[100 100 100]./255,'BarWidth',1); %other cell derived

set(gca,'XLim',[xax1;xax2],'xtick',xtick,'XTickLabel',datestr(xtick,'dd-mmm'),...
        'ylim',[0 100],'ytick',25:25:100,'xaxislocation','top',...
    'fontsize', 14, 'fontname', 'arial','tickdir','out');
ylabel('% Carbon', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
lh=legend('\itAkashiwo sanguinea','\itCeratium',...
    '\itDinophysis','\itGymnodinium','\itMargalefidinium','\itProrocentrum','other dinoflagellates',...
    '\itChaetoceros','\itDetonula/Cerataulina/Lauderia','\itEucampia',...
    '\itGuinardia/Dactyliosolen','\itPseudo-nitzschia','\itSkeletonema',...
    'Centric diatoms','Pennate diatoms','other diatoms','other cell-derived');
legend boxoff
set(lh, 'fontsize',14);
set(lh,'Position',[0.715423465423172 0.513211397125375 0.291666666666666 0.438271604938272]);

hold on

%total cell-derived biovolume
subplot(7,1,4);
% y=smooth(ymat./ymat_ml,1); 
% idx=isnan(ymat); y(idx)=NaN;
hold on
h=plot(xmat,ymat./ymat_ml,'k-',SC.dn,SC.CHL,'*r',SC.dn,SC.CHLsensor,':r',...
    'linewidth', 1.5,'Markersize',8);
set(h(3),'linewidth',2);
set(gca,'xgrid','on','xlim',[xax1 xax2],'xtick',xtick,...        
        'XTickLabel',{},'fontsize',14,'fontname','arial',...
    'tickdir','out','ylim',[0 17],'ytick',5:10:20)
ylabel('Carbon (\mug/L)', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
lh=legend('IFCB','fluorometer','Location','NorthWest'); legend boxoff
set(lh, 'fontsize',14);
box on
hold on

subplot(7,1,5); %SCW wind
    [U,~]=plfilt(w.scw.u, w.scw.dn);
    [V,DN]=plfilt(w.scw.v, w.scw.dn);
    [~,u,~] = ts_aggregation(DN,U,4,'hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,4,'hour',@mean);
    yax1=-4; yax2=4;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    xlim([xax1 xax2])    
    set(gca,'ytick',-3:3:3,'xtick',xtick,...        
        'XTickLabel',{},'fontsize',14);    
    ylabel('Wind (m/s)','fontsize',16,'fontname','arial','fontweight','bold');  
    hold on  

ax1=subplot(7,1,6); %SCW ROMS Temp
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,parula); caxis([10 14]); grid on; 
    hold on
    hh=plot(X,[ROMS.mld5],'w-','linewidth',2);
    hold on     
    set(gca,'XLim',[xax1;xax2],'xtick',xtick,...        
        'XTickLabel',{},'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'ytick',0:20:40,'fontsize',14,'tickdir','out');
    ylabel('Depth (m)','fontsize',16,'fontweight','bold');
    h=colorbar('Position',[0.745726495726249 0.17929292929293 0.0170940170940171 0.116161616161616]);
    h.FontSize = 14;
    h.Label.String = 'T (^oC)';     
    h.Label.FontSize = 14;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    lh=legend(hh,'MLD','Location','NW');
    set(lh, 'fontsize',14);
  legend boxoff    

ax2=subplot(7,1,7); %SCW ROMS Sal    
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Si];
    pcolor(X,Y,C); shading interp;
    colormap(ax2,parula);     
    caxis([33.2 33.7]); 
    hold on     
    set(gca,'xaxislocation','bottom','XLim',[xax1;xax2],...
        'ylim',[0 50],'xtick',xtick,...
        'XTickLabel',{},'Ydir','reverse','ytick',0:20:50,...
        'fontsize',14,'tickdir','out');
    hold on
    ylabel('Depth (m)','fontsize',16,'fontweight','bold');
    h=colorbar('Position',[0.745726495726247 0.0505050505050505 0.0170940170940171 0.11489898989899]);
    h.Label.String = 'S (g/kg)';
    h.FontSize = 14;
    h.Label.FontSize = 14;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
set(gca,'TickDir','out')
    
    % set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Akashiwo_Spring2018_SCW.tif']);
hold off

