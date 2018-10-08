%% Plot biovolume for dinoflagellates vs diatoms
% parts modified from "compile_biovolume_summaries"
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

year=2018; %USER

%%%% Step 1: Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/'; % MAC 
% filepath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\'; %PC
%load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD'],'ROMS','CA','MB');
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS','CA','MB');

load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Wind_MB'],'w');
load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB' num2str(year) ''],...
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

%%%% Step 3: Determine what fraction of Cell-derived carbon is 
% Dinoflagellates vs Diatoms vs Classes of interest

%select total living biovolume 
[ ind_cell, ~ ] = get_cell_ind_CA( class2useTB, class2useTB );
[~, ymat ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_cell),2));
[xmat, ymat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%select only diatoms
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
[~, ydiat ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_diatom),2));
[xdiat, ydiat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%select only dinoflagellates
[ ind_dino, class_label ] = get_dino_ind_CA( class2useTB, class2useTB );
[~, ydino ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_dino),2));
[xdino, ydino_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

% extract biovolume and carbon for each class
for i=1:length(class2useTB)
    BIO(i).class = class2useTB(i);
    [~,BIO(i).bio ] = timeseries2ydmat(mdateTB, volB(:,i));
    [~,BIO(i).car ] = timeseries2ydmat(mdateTB, volC(:,i));    
end

%%%% Step 4: Interpolate data for small data gaps 
for i=1:length(BIO)
    [BIO(i).bio_i] = interp1babygap(BIO(i).bio,4);
    [BIO(i).car_i] = interp1babygap(BIO(i).car,4);
end

for i=1:length(ydino)
    [ydino] = interp1babygap(ydino,4);
    [ydino_ml] = interp1babygap(ydino_ml,4);

    [ydiat] = interp1babygap(ydiat,4);
    [ydiat_ml] = interp1babygap(ydiat_ml,4);
    
    [ymat] = interp1babygap(ymat,4);
    [ymat_ml] = interp1babygap(ymat_ml,4);

end

%%%% Step 5: import your cell count data
%General input
%Thr_sum = [filepath 'Data/IFCB_summary/Coeff_' class2do_string];
%biovol_sum = [filepath 'Data/IFCB_summary/manual/count_biovol_manual_12Sep2018'];
%class_sum = [filepath 'Data/IFCB_summary/class/summary_allTB_bythre_' class2do_string];

Thr_sum = [filepath 'Data/IFCB_summary/Coeff_'];
biovol_sum = [filepath 'Data/IFCB_summary/manual/count_biovol_manual_12Sep2018'];
class_sum = [filepath 'Data/IFCB_summary/class/summary_allTB_bythre_'];

class2do_string = 'Akashiwo';
[AKA] = summarize_class(class2do_string,[Thr_sum class2do_string],biovol_sum,[class_sum class2do_string],filepath);

class2do_string = 'Gymnodinium';
[GYM] = summarize_class(class2do_string,[Thr_sum class2do_string],biovol_sum,[class_sum class2do_string],filepath);

class2do_string = 'Prorocentrum';
[PRO] = summarize_class(class2do_string,[Thr_sum class2do_string],biovol_sum,[class_sum class2do_string],filepath);

class2do_string = 'Ceratium';
[CER] = summarize_class(class2do_string,[Thr_sum class2do_string],biovol_sum,[class_sum class2do_string],filepath);

class2do_string = 'Chaetoceros';
[CHA] = summarize_class(class2do_string,[Thr_sum class2do_string],biovol_sum,[class_sum class2do_string],filepath);

class2do_string = 'Det_Cer_Lau';
[DCL] = summarize_class(class2do_string,[Thr_sum class2do_string],biovol_sum,[class_sum class2do_string],filepath);

class2do_string = 'Eucampia';
[EUC] = summarize_class(class2do_string,[Thr_sum class2do_string],biovol_sum,[class_sum class2do_string],filepath);

class2do_string = 'Centric';
[CEN] = summarize_class(class2do_string,[Thr_sum class2do_string],biovol_sum,[class_sum class2do_string],filepath);

class2do_string = 'Pennate';
[PEN] = summarize_class(class2do_string,[Thr_sum class2do_string],biovol_sum,[class_sum class2do_string],filepath);

clearvars Thr_sum biovol_sum class_sum 
%[~, cind] = sort(sum(x), 'descend'); %rank order biomass    

clear ydiat_ml ydino_ml



%% plot fraction biovolume with Chlorophyll
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.06 0.04], [0.09 0.25]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum(['' num2str(year) '-01-01']); xax2=datenum(['' num2str(year) '-10-01']);     
fxdino = ydino./(ydino+ydiat);
fxdiat = ydiat./(ydino+ydiat);
fx_other=(ymat-(ydino+ydiat))./ymat; %fraction not dinos or diatoms

%species breakdown
subplot(6,1,[1 2]);
select_dino=[BIO(strmatch('Akashiwo',class2useTB)).car_i,...
    BIO(strmatch('Ceratium',class2useTB)).car_i,...
    BIO(strmatch('Cochlodinium',class2useTB)).car_i,...
    BIO(strmatch('Dinophysis',class2useTB)).car_i,...    
    BIO(strmatch('Gymnodinium',class2useTB)).car_i,...
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

h=bar(xmat,[select_dino./ymat fx_otherdino select_diat./ymat fx_otherdiat fx_other], 0.5, 'stack');
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

datetick('x', 'mmm', 'keeplimits')
set(gca,'xaxislocation','top','xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
    'fontsize', 12, 'fontname', 'arial','tickdir','out');
ylabel('Fraction Carbon', 'fontsize', 12, 'fontname', 'arial','fontweight','bold')
h=legend('Akashiwo','Ceratium','Cochlodinium','Dinophysis','Gymnodinium','Prorocentrum',...
    'other dinos','Chaetoceros','DetCerLau','Eucampia',...
    'GuinDact','Pseudo-nitzchia','Skeletonema','Centric diatoms',...
    'Pennate diatoms','other diatoms','other cell-derived');
legend boxoff
set(h,'Position',[0.767361111111111 0.555266129032257 0.215277777777778 0.404513888888888]);
hold on

%total cell-derived biovolume
subplot(6,1,3);
y=smooth(ymat./ymat_ml,3); 
idx=isnan(ymat); y(idx)=NaN;
datetick('x','m','keeplimits'); 
hold on
plot(xmat,y,'k-',SC.dn,SC.CHL,'*k',SC.dn,SC.CHLsensor,'k:','linewidth', 1,'Markersize',4);
set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',12,'fontname','arial',...
    'tickdir','out','ytick',20:20:60)
ylabel('Carbon (\mug L^{-1})', 'fontsize', 12, 'fontname', 'arial','fontweight','bold')
legend('IFCB','manual','sensor','Location','NorthWest'); legend boxoff
datetick('x','m','keeplimits'); 
box on
hold on

subplot(6,1,4); %SCW wind
%     [U,~]=plfilt(w.scw.u, w.scw.dn);
%     [V,DN]=plfilt(w.scw.v, w.scw.dn);
%     [~,u,~] = ts_aggregation(DN,U,12,'hour',@mean);
%     [time,v,~] = ts_aggregation(DN,V,12,'hour',@mean);
    yax1=-5; yax2=5;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    xlim([xax1;xax2])    
    datetick('x','m','keeplimits');   
    set(gca,'ytick',-4:4:4,'xticklabel',{},'fontsize',12);    
    ylabel('Wind (m s^{-1})','fontsize',12,'fontname','arial','fontweight','bold');  
    hold on  
  
ax1=subplot(6,1,5); %SCW ROMS Temp
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,parula); caxis([10 16]); datetick('x',4);  grid on; 
    hold on
    hh=plot(X,smooth([ROMS.mld5],10),'w-','linewidth',2);
    hold on     
    set(gca,'XLim',[xax1;xax2],'xticklabel',{},'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'ytick',10:10:40,'fontsize',12,'tickdir','out');
    datetick('x','m','keeplimits')        
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar('Position',[0.765624999999999 0.210069444444444 0.0277777777777778 0.142361111111111]);
    h.FontSize = 12;
    h.Label.String = 'T (^oC)';     
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    legend(hh,'MLD','Location','NW')
    legend boxoff
    hold on

ax=subplot(6,1,6); %SCW ROMS Sal    
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Si];
    pcolor(X,Y,C); shading interp;
    colormap(ax,parula);     
    caxis([33.2 33.9]); datetick('x','mmm','keeplimits');  grid on; 
    hold on     
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse','ytick',10:10:40,...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',12,'tickdir','out');
    datetick('x','mmm','keeplimits')    
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar('Position',[0.765625000000202 0.0538194444444444 0.0277777777777778 0.140625]);
    h.Label.String = 'S (g kg^{-1})';
    h.FontSize = 12;
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_chl_class_wind_TS.tif']);
hold off

