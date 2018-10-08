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
    [BIO(i).bio_i] = interp1babygap(BIO(i).bio,3);
    [BIO(i).car_i] = interp1babygap(BIO(i).car,3);
end

for i=1:length(ydino)
    [ydino] = interp1babygap(ydino,3);
    [ydino_ml] = interp1babygap(ydino_ml,3);

    [ydiat] = interp1babygap(ydiat,3);
    [ydiat_ml] = interp1babygap(ydiat_ml,3);
    
    [ymat] = interp1babygap(ymat,3);
    [ymat_ml] = interp1babygap(ymat_ml,3);

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

%% zoom into Feb March
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.04 0.04], [0.11 0.22]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum(['' num2str(year) '-02-25']); xax2=datenum(['' num2str(year) '-04-05']);     

%total cell-derived CARBON
subplot(7,1,1);
    y=smooth(ymat./ymat_ml,3); 
    idx=isnan(ymat); y(idx)=NaN;
    plot(xmat,y,'k-',SC.dn,SC.CHL,'*k',SC.dn,SC.CHLsensor,'k:','linewidth', 1,'Markersize',4);
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',9,...
        'fontname','arial','tickdir','out','xaxislocation','top')
    datetick('x','dd','keeplimits');       
    ylabel('Carbon (\mug L^{-1})', 'fontsize', 10, 'fontname', 'arial','fontweight','bold')
    lh=legend('IFCB','manual','sensor','Location','EastOutside'); legend boxoff
    set(lh,'Position',[0.797685185185185 0.885920353223593 0.118055555555556 0.0607638888888888]);
    box on
    hold on

subplot(7,1,2); 
h=plot(AKA.mdateTB,AKA.y_mat,'-k',CER.mdateTB,CER.y_mat,'-k',...
    GYM.mdateTB,GYM.y_mat,'-k',PRO.mdateTB,PRO.y_mat,'-k',......
    CHA.mdateTB,CHA.y_mat,'-k',DCL.mdateTB,DCL.y_mat,'-k',...
    EUC.mdateTB,EUC.y_mat,'-k',CEN.mdateTB,CEN.y_mat,'-k',...
    PEN.mdateTB,PEN.y_mat,'-k','linewidth',2);

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(5,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGnBu'));
col_diat2=(brewermap(5,'Purples'));
col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(5,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGnBu'));
col_diat2=(brewermap(5,'Purples'));

set(h(1),'Color',col_dino1(10,:)); %aka
set(h(2),'Color',col_dino1(9,:)); %cer
set(h(3),'Color',col_dino2(4,:)); %gm
set(h(4),'Color',col_dino2(2,:)); %pro
set(h(5),'Color',col_diat1(6,:)); %chae
set(h(6),'Color',col_diat1(5,:)); %DCL
set(h(7),'Color',col_diat1(4,:)); %Euc
set(h(8),'Color',col_diat2(5,:)); %Cen
set(h(9),'Color',col_diat2(4,:)); %Pen
set(h(1),'Color',col_dino1(10,:)); %aka
set(h(2),'Color',col_dino1(9,:)); %cer
set(h(3),'Color',col_dino2(4,:)); %gm
set(h(4),'Color',col_dino2(2,:)); %pro
set(h(5),'Color',col_diat1(6,:)); %chae
set(h(6),'Color',col_diat1(5,:)); %DCL
set(h(7),'Color',col_diat1(4,:)); %Euc
set(h(8),'Color',col_diat2(5,:)); %Cen
set(h(9),'Color',col_diat2(4,:)); %Pen

set(gca,'xlim',[xax1 xax2],...
    'fontsize', 9, 'fontname', 'arial','tickdir','out')
ylabel('Cells ml^{-1}', 'fontsize', 10, 'fontname', 'arial','fontweight','bold')
lh=legend('Akashiwo','Ceratium','Gymnodinium','Prorocentrum',...
    'Chaetoceros','DetCerLau','Eucampia','Centric diatoms','Pennate diatoms');
set(lh,'Position',[0.798560185185185 0.679022388790906 0.177083333333333 0.170138888888889]);
    datetick('x','dd','keeplimits');           
hold on

subplot(7,1,3); %Discharge
    plot(SC.dn,SC.river,'-k','linewidth',1.5);
    set(gca,'xgrid','on','XLim',[xax1;xax2],...
        'fontsize',9,'tickdir','out'); 
    datetick('x','dd','keeplimits');           
    ylabel({'Discharge'; '(ft^3 s^{-1})'},'fontsize',10,'fontweight','bold');
hold on  

subplot(7,1,4); %SCW wind
    [U,~]=plfilt(w.scw.u, w.scw.dn);
    [V,DN]=plfilt(w.scw.v, w.scw.dn);
    [~,u,~] = ts_aggregation(DN,U,4,'hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,4,'hour',@mean);
    yax1=-5; yax2=5;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    xlim([xax1;xax2])    
    datetick('x','dd','keeplimits');       
    set(gca,'ytick',-4:4:4,'xticklabel',{},'fontsize',9);    
    ylabel({'SCW Wind'; '(m s^{-1})'},'fontsize',10,'fontname','arial','fontweight','bold');  
    hold on   
    
subplot(7,1,5); %46042 wind
    [U,~]=plfilt(w.s42.u, w.s42.dn);
    [V,DN]=plfilt(w.s42.v, w.s42.dn);
    [~,u,~] = ts_aggregation(DN,U,4,'hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,4,'hour',@mean);
    yax1=-12; yax2=12;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    xlim([xax1;xax2])    
    datetick('x','dd','keeplimits');       
    set(gca,'ytick',-10:10:10,'xticklabel',{},'fontsize',9);    
    ylabel({'46042 Wind';'(m s^{-1})'},'fontsize',10,'fontname','arial','fontweight','bold');  
    hold on            
    
subplot(7,1,6); %SCW  
    plot(SC.dn,SC.T,'*k',SC.dn,SC.Tsensor,':k','linewidth',1.5,'markersize',4);
    set(gca,'xgrid','on','XLim',[xax1;xax2],...
        'fontsize',9,'tickdir','out'); 
    datetick('x','dd','keeplimits');           
    ylabel('SST (^oC)','fontsize',10,'fontweight','bold');
hold on  

subplot(7,1,7); %ROMS Temp
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    caxis([10 16]); grid on; 
    hold on
    hh=plot(X,smooth([ROMS.Zmax],2),'w-','linewidth',2);
    hold on
    datetick('x','dd','keeplimits');           
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');
    ylabel('Depth (m)','fontsize',10,'fontweight','bold');
    box on    
    datetick('x','dd','keeplimits');       
    h=colorbar('Position',[0.787962962962964 0.0397805212620027 0.0148148148148148 0.113854595336077]);
    h.Label.String = 'T (^oC)';
    h.FontSize = 8;
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';

    lh=legend(hh,'Z(max dT/dz)') ; 
    legend boxoff
    lh.FontSize = 10;
    lh.FontWeight = 'bold';    
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dpng','-r600',[filepath 'Figs/ZoomIn_IFCB_SCW_Spring' num2str(year) '.png']);
hold off

%% plot pcolor temperature profile, delta T MLD, and  dinos/diatom

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.06 0.04], [0.1 0.12]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum(['' num2str(year) '-01-01']); xax2=datenum(['' num2str(year) '-10-01']);     
    
subplot(6,1,1);
h = plot(SC.dn,SC.fxDino.*SC.CHL,'ro',SC.dn,SC.fxDiat.*SC.CHL,'b^',...
    xmat,smooth(ydino./ymat_ml,1),'-r.',...
    xmat,smooth(ydiat./ymat_ml,1),'-b.','linewidth',1.5);
    cstr=brewermap(2,'RdBu');
    set(h(1),'Markersize',4, 'Color',cstr(1,:));
    set(h(2),'Markersize',4, 'Color',cstr(2,:));
    set(h(3), 'Color',cstr(1,:));
    set(h(4),'Color',cstr(2,:));  

    set(gca,'xlim',[xax1 xax2],'xgrid','on',...
        'fontsize', 9,'fontname', 'arial','tickdir','out','xaxislocation','top')
    datetick('x','mmm','keeplimits')
    ylabel('Carbon (\mug L^{-1})','fontsize',10,'fontname','arial','fontweight','bold')
    legend('dinoflagellates','diatoms','Location','NW');
    legend boxoff;
    hold on  
    
% subplot(6,1,2); %SCW wind
%     [U,~]=plfilt(w.scw.u, w.scw.dn);
%     [V,DN]=plfilt(w.scw.v, w.scw.dn);
%     [~,u,~] = ts_aggregation(DN,U,12,'hour',@mean);
%     [time,v,~] = ts_aggregation(DN,V,12,'hour',@mean);
%     yax1=-5; yax2=5;
%     stick(time,u,v,xax1,xax2,yax1,yax2,'');
%     xlim([xax1;xax2])    
%     datetick('x','m','keeplimits');   
%     set(gca,'ytick',-4:4:4,'xticklabel',{},'fontsize',9);    
%     ylabel({'SCW';'Wind (m s^{-1})'},'fontsize',10,'fontname','arial','fontweight','bold');  
%     hold on  
%     
% subplot(6,1,3); %40462 wind
%     [U,~]=plfilt(w.s42.u, w.s42.dn);
%     [V,DN]=plfilt(w.s42.v, w.s42.dn);
%     [~,u,~] = ts_aggregation(DN,U,12,'hour',@mean);
%     [time,v,~] = ts_aggregation(DN,V,12,'hour',@mean);
%     yax1=-10; yax2=10;
%     stick(time,u,v,xax1,xax2,yax1,yax2,'');
%     xlim([xax1;xax2])    
%     datetick('x','m','keeplimits');   
%     set(gca,'ytick',-10:10:10,'xticklabel',{},'fontsize',9);    
%     ylabel({'46042';'Wind (m s^{-1})'},'fontsize',10,'fontname','arial','fontweight','bold');  
%     hold on      
%     
% subplot(6,1,3); %Discharge
%     plot(SC.dn,SC.river,'-k','linewidth',1.5);
%     xlim([xax1;xax2]);    
%     datetick('x', 3, 'keeplimits')    
%     set(gca,'xgrid','on','xticklabel',{},...
%         'fontsize',9,'tickdir','out'); 
%     ylabel('Discharge (ft^3 s^{-1})','fontsize',10,'fontweight','bold');
% hold on       
%     
ax=subplot(6,1,4); %SCW ROMS Sal    
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Si];
    pcolor(X,Y,C); shading interp;
    colormap(ax,jet);     
    caxis([33.2 33.9]); datetick('x','mmm');  grid on; 
    hold on
     
    set(gca,'XLim',[xax1;xax2],'xticklabel',{},'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');
    ylabel('Depth (m)','fontsize',10,'fontweight','bold');
    h=colorbar('Position',...
    [0.894965277777778 0.3671875 0.0203993055555555 0.1328125]);
    h.Label.String = 'S (g kg^{-1})';
    h.FontSize = 8;
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
  
ax1=subplot(6,1,5); %SCW ROMS Temp
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,jet);     
    caxis([10 16]); datetick('x',4);  grid on; 
    hold on
    hh=plot(X,smooth([ROMS.mld5],10),'w-','linewidth',2);
hold on     
    set(gca,'XLim',[xax1;xax2],'xticklabel',{},'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');    
    ylabel('Depth (m)','fontsize',10,'fontweight','bold');
    h=colorbar('Position',...
    [0.894965277777778 0.217447916666667 0.0230034722222223 0.1328125]);
    h.FontSize = 8;
    h.Label.String = 'T (^oC)';     
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
  
ax2=subplot(6,1,6); %ROMS MLD
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi(1:end-1)]';
    C=[ROMS.dTdz];
    pcolor(X,Y,C); shading interp;
    colormap(ax2,jet);     
    caxis([0 0.2]); datetick('x','mmm','keeplimits');  grid on; 
    hold on
    hh=plot(X,smooth([ROMS.Zmax],10),'w-','linewidth',2);
    hold on
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');
    ylabel('Depth (m)','fontsize',10,'fontweight','bold');
    datetick('x','mmm','keeplimits')
    
    h=colorbar('Position',...
    [0.898871527389727 0.0598958333333333 0.0217013892769401 0.1328125]);
    h.Label.String = 'dT/dz (^oC m^{-1})';
    h.FontSize = 8;
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Dino-Diatom_W_D_S_T_' num2str(year) '_50m.tif']);
hold off

%% plot fraction biovolume with Chlorophyll
figure('Units','inches','Position',[1 1 8.5 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.08 0.04], [0.11 0.22]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum(['' num2str(year) '-01-01']); xax2=datenum(['' num2str(year) '-10-01']);     
fxdino = ydino./(ydino+ydiat);
fxdiat = ydiat./(ydino+ydiat);
fx_other=(ymat-(ydino+ydiat))./ymat; %fraction not dinos or diatoms

%total cell-derived biovolume
subplot(2,1,1);
y=smooth(ymat./ymat_ml,3); 
idx=isnan(ymat); y(idx)=NaN;
datetick('x',3,'keeplimits'); 
hold on
plot(xmat,y,'k-',SC.dn,SC.CHL,'*k',SC.dn,SC.CHLsensor,'k:','linewidth', 1,'Markersize',4);
set(gca,'xgrid','on','xlim',[xax1 xax2],'xticklabel',{},'fontsize',14,'fontname','arial','tickdir','out')
ylabel('Carbon (\mug L^{-1})', 'fontsize', 14, 'fontname', 'arial','fontweight','bold')
legend('IFCB','manual','sensor','Location','NorthWest'); legend boxoff
datetick('x','m','keeplimits'); 
box on
hold on

%species breakdown
subplot(2,1,2);
 
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
set(h(17),'FaceColor','w','BarWidth',1); %other cell derived

datetick('x', 3, 'keeplimits')
set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',0.5:0.5:1,...
    'fontsize', 14, 'fontname', 'arial','tickdir','out')
ylabel('Fraction Biomass', 'fontsize', 14, 'fontname', 'arial','fontweight','bold')
h=legend('Akashiwo','Ceratium','Cochlodinium','Dinophysis','Gymnodinium','Prorocentrum',...
    'other dinos','Chaetoceros','DetCerLau','Eucampia',...
    'GuinDact','Pseudo-nitzchia','Skeletonema','Centric diatoms',...
    'Pennate diatoms','other diatoms','other cell-derived');
set(h,'Position',[0.808159725831097 0.399956604207141 0.187499996391125 0.246744784681747]);
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/FxBiovolume_Chl_IFCB_SCW_' num2str(year) '.tif']);
hold off

%% old scripts
yyaxis left %total cell-derived biovolume
    h1=plot(xmat, smooth(ymat./ymat_ml,1),'k-','linewidth', 1);
    datetick('x', 3, 'keeplimits')
    xlim([xax1;xax2]);    
    set(gca,'yscale','log','ylim',[10^3 10^6],'xgrid','on','fontsize', 9, 'fontname', 'arial',...
        'tickdir','out','ycolor','k','Xticklabel',{})
    ylabel({'Biovolume';'(\mum^{-3} mL^{-1})'},'fontsize',10,'fontname','arial','fontweight','bold')
    hold on      
yyaxis right %Chlorophyll
    h2=plot(SC.dn,SC.CHL,'*-','Markersize',4,'Color',[0.8500 0.3250 0.0980]);
    hold on
    h3=plot(SC.dn,SC.CHLsensor,'-','linewidth',1,'Color',[0.8500 0.3250 0.0980]);
    xlim([xax1;xax2]);    
    set(gca,'yscale','log','ylim',[1 40],'xgrid','on','fontsize',9, 'fontname', 'arial',...
        'xaxislocation','top','tickdir','out','ycolor','k','ycolor',[0.8500 0.3250 0.0980])   
    datetick('x','mmm','keeplimits','keepticks');        
    ylabel('Chl (mg m^{-3})','Color',[0.8500 0.3250 0.0980],'fontsize',10,'fontname','arial','fontweight','bold');         
    hold on   

subplot(7,1,2); %Fraction dinos and diatoms
    bar(xmat, [ydino./[ydino+ydiat] ydiat./[ydino+ydiat]], 0.5, 'stack');
    ax = get(gca);
    cat = ax.Children;
    cstr = [ [200 200 200]/255; [80 80 80]/255]; %black/dk grey/lt grey
    for ii = 1:length(cat)
        set(cat(ii), 'FaceColor', cstr(ii,:),'BarWidth',1)
    end
hold on
    datetick('x','mmm', 'keeplimits')
    xlim([xax1;xax2])    
    ylim([0;1])
    set(gca,'xgrid','on', 'fontsize', 9, 'fontname', 'arial',...
        'xaxislocation','top','tickdir','out','Xticklabel',{})
    ylabel({'Fraction of';'Biovolume'}, 'fontsize', 10, 'fontname', 'arial','fontweight','bold')
    h=legend('dinos','diatoms','Location','NE');
    h.FontSize = 8;    
    hold on 
    