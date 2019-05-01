%% Plot daily biovolume for 2018 at SCW
% parts modified from "compile_biovolume_summaries"
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
%%
%%%% Step 1: Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS');
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Wind_MB'],'w');
load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018'],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

%%%% convert to PST (UTC is 7 hrs ahead)
time=datetime(mdateTB,'ConvertFrom','datenum'); time=time-hours(7); 
time.TimeZone='America/Los_Angeles'; mdateTB=datenum(time);
 
%%%% eliminate samples where tina was likely not taking in new samples
total=NaN*ones(size(mdateTB));
for i=1:length(mdateTB)
    total(i)=sum(classcountTB(i,:)); %find number of triggers per sample
end
idx=find(total<=100); %find totals where tina was likely not taking in new samples 
mdateTB(idx)=[];
filelistTB(idx)=[];
ml_analyzedTB(idx)=[];
classcountTB(idx,:)=[];
classbiovolTB(idx,:)=[];

%%%% Step 2: Convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
[ cellC ] = biovol2carbon(classbiovolTB, ind_diatom ); 
volC=zeros(size(cellC)); %convert from per cell to per mL
volB=zeros(size(cellC)); %convert from per cell to per mL
for i=1:length(cellC)
    volC(i,:)=cellC(i,:)./ml_analyzedTB(i);
    volB(i,:)=classbiovolTB(i,:)./ml_analyzedTB(i);    
end  
volC=volC./1000; %convert from pg/mL to ug/L 

%%%% Step 3: Take daily average and determine what fraction of Cell-derived carbon is 
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
[ ind_dino, ~ ] = get_dino_ind_CA( class2useTB, class2useTB );
[~, ydino ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_dino),2));
[xdino, ydino_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%extract biovolume and carbon for each class (daily average)
    for i=1:length(class2useTB)
        BIO(i).class = class2useTB(i);
        [~,BIO(i).bio ] = timeseries2ydmat(mdateTB, volB(:,i));
        [~,BIO(i).car ] = timeseries2ydmat(mdateTB, volC(:,i));    
    end

%%%% Interpolate data for small data gaps 
    maxgap=3;
    [ydino] = interp1babygap(ydino,maxgap);
    [ydino_ml] = interp1babygap(ydino_ml,maxgap);
    [ydiat] = interp1babygap(ydiat,maxgap);
    [ydiat_ml] = interp1babygap(ydiat_ml,maxgap);
    [ymat] = interp1babygap(ymat,maxgap);
    [ymat_ml] = interp1babygap(ymat_ml,maxgap);
for i=1:length(BIO)
    [BIO(i).bio_i] = interp1babygap(BIO(i).bio,maxgap);
    [BIO(i).car_i] = interp1babygap(BIO(i).car,maxgap);
end

%% 2018 plot fraction biovolume with Chlorophyll
figure('Units','inches','Position',[1 1 14 11],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.04 0.04], [0.06 0.24]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
%xax1=datenum('2018-04-01'); xax2=datenum('2018-05-31');     

subplot(6,1,[1 2 3]); %species breakdown
select_dino=[BIO(strmatch('Akashiwo',class2useTB)).car_i,...
    BIO(strmatch('Ceratium',class2useTB)).car_i,...
    BIO(strmatch('Dinophysis',class2useTB)).car_i,...    
    BIO(strmatch('Gymnodinium',class2useTB)).car_i,...
    BIO(strmatch('Cochlodinium',class2useTB)).car_i,...    
    BIO(strmatch('Prorocentrum',class2useTB)).car_i,...
    BIO(strmatch('Peridinium',class2useTB)).car_i,...
    BIO(strmatch('Scrip_Het',class2useTB)).car_i];

select_diat=[BIO(strmatch('Chaetoceros',class2useTB)).car_i,...
    BIO(strmatch('Det_Cer_Lau',class2useTB)).car_i,...
    BIO(strmatch('Eucampia',class2useTB)).car_i,...
    BIO(strmatch('Guin_Dact',class2useTB)).car_i,...   
    BIO(strmatch('Pseudo-nitzschia',class2useTB)).car_i,...        
    BIO(strmatch('Skeletonema',class2useTB)).car_i,...
    BIO(strmatch('Thalassiosira',class2useTB)).car_i,...    
    BIO(strmatch('Centric',class2useTB)).car_i,...        
    BIO(strmatch('Pennate',class2useTB)).car_i];

fx_otherdino=(ydino-nansum(select_dino,2))./ymat; %fraction other dinos
fx_otherdiat=(ydiat-nansum(select_diat,2))./ymat; %fraction other dinos
fx_other=(ymat-(ydino+ydiat))./ymat; %fraction not dinos or diatoms

h = bar(xmat,...
    [100*select_dino./ymat ...
    100*fx_otherdino ...
    100*select_diat./ymat ...
    100*fx_otherdiat ...
    100*fx_other], 'stack');

%set(h, 'barwidth', 1.2)
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

    datetick('x', 'mmm', 'keeplimits')
    set(gca,'xaxislocation','top','xlim',[xax1 xax2],'ylim',[0 100],'ytick',25:25:100,...
        'fontsize', 14, 'fontname', 'arial','tickdir','out');
    ylabel('% Carbon', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    lh=legend('\itAkashiwo sanguinea','\itCeratium',...
        '\itDinophysis','\itGymnodinium','\itMargalefidinium',...
        '\itProrocentrum','\itPeridinium','\itScrippsiella/Heterocapsa','other dinoflagellates',...
        '\itChaetoceros','\itDetonula/Cerataulina/Lauderia','\itEucampia',...
        '\itGuinardia/Dactyliosolen','\itPseudo-nitzschia','\itSkeletonema',...
        '\itThalassiosira','centric','pennate',...
        'other diatoms','other cell-derived');
    datetick('x','mmm','keeplimits'); 
    set(gca, 'XTickLabel',{})       
    legend boxoff
    lh.FontSize = 14;               
    hp=get(lh,'pos'); 
    lh.Position = [hp(1) hp(2) hp(3)+.49 hp(4)]; 
    datetick('x', 'mmm', 'keeplimits')
    hold on

subplot(6,1,4); % total cell-derived biovolume
    h=plot(xmat,ymat./ymat_ml,'ko',SC.dn,SC.CHL,'*r','linewidth', 1.5,'Markersize',6);
    set(h(1),'linewidth', 1,'Markersize',4)
    set(gca,'xgrid','on','xlim',[xax1 xax2],'XTickLabel',{},'fontsize',14,...
        'fontname','arial','tickdir','out','ylim',[0 25],'ytick',5:10:25)
    ylabel({'\mug/L'}, 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    lh=legend('Carbon biomass (IFCB)','Chlorophyll','Location','NorthEast'); legend boxoff
    datetick('x','mmm','keeplimits'); 
    set(gca, 'XTickLabel',{})   
    hp=get(lh,'pos'); 
    lh.FontSize = 14;                   
    lh.Position = [hp(1) hp(2) hp(3)+.38 hp(4)];
    box on
    hold on

ax=subplot(6,1,5); %Brunt-Väisälä frequency
    cax=[-5 -3]; 
    X=[ROMS.dn]';
    Y=(ROMS(1).Zi(1:end-1))';
    C=[ROMS.logN2];
    pcolor(X,Y,C); shading interp;
    colormap(ax,parula); caxis(cax); datetick('x','mmm');  grid on; 
    hold on
    hold on     
    set(gca,'XLim',[xax1;xax2],'xticklabel',{},'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'ytick',10:20:50,'fontsize',14,'tickdir','out');
    datetick('x','mmm','keeplimits')    
    set(gca, 'XTickLabel',{})
    ylabel('Depth (m)','fontsize',16,'fontweight','bold');
    hold on
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 14;
    h.Label.String = 'log_1_0 N^2 (s^{-2})';     
    h.Label.FontSize = 16;
    h.Label.FontWeight = 'bold';
    h.Ticks=linspace(cax(1),cax(2),3);       
    hold on

 ax1=subplot(6,1,6); %SCW ROMS Temp
    cax=[10 16]; 
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,parula); caxis(cax); datetick('x','mmm');  grid on; 
    hold on
    hh=plot(X,[ROMS.mld5],'k-','linewidth',2);
    hold on     
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'ytick',10:20:50,'fontsize',14,'tickdir','out');
    datetick('x','mmm','keeplimits')    
    ylabel('Depth (m)','fontsize',16,'fontweight','bold');
    hold on
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 14;
    h.Label.String = 'T (^oC)';     
    h.Label.FontSize = 16;
    h.Label.FontWeight = 'bold';
    h.Ticks=linspace(cax(1),cax(2),4);       
    legend(hh,'MLD','Location','NE','fontsize',14); legend boxoff
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_dino_daily.tif']);
hold off

%% 2018 subplot of all variables
figure('Units','inches','Position',[1 1 12 10],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.05 0.05], [0.07 0.16]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
fxdino = ydino./(ymat);
fxdiat = ydiat./(ymat);
fx_other=(ymat-(ydino+ydiat))./ymat; %fraction not dinos or diatoms

subplot(6,1,1);
    h=plot(xmat,ymat./ymat_ml,'k-',SC.dn,SC.CHL,'*r',SC.dn,SC.CHLsensor,':r',...
        'linewidth', 1.5,'Markersize',8);
    set(h(3),'linewidth',2);
    set(gca,'xaxislocation','top','xgrid','on','xlim',[xax1 xax2],'fontsize',12,...
        'fontname','arial','tickdir','out','ylim',[0 30],'ytick',10:10:30)
    ylabel({'Carbon (\mug/L)'}, 'fontsize', 14, 'fontname', 'arial','fontweight','bold')
    lh=legend('IFCB Carbon','Extracted Chl','Fluorometer Chl','Location','EastOutside'); legend boxoff
    legend boxoff
    lh.FontSize = 12;               
    hp=get(lh,'pos'); 
    lh.Position = [hp(1) hp(2) hp(3)+.32 hp(4)]; 
    datetick('x','mmm','keeplimits'); 
    box on
    hold on

subplot(6,1,2);    
    h=bar(xmat,[100*fxdino 100*fxdiat 100*fx_other], 'stack');
    set(h, 'barwidth', 1.2)
    col=flipud(brewermap(3,'Greys'));
    set(h(1),'FaceColor',col(1,:),'BarWidth',1); %aka
    set(h(2),'FaceColor',col(2,:),'BarWidth',1); %cer
    set(h(3),'FaceColor',col(3,:),'BarWidth',1); 
    datetick('x', 'mmm', 'keeplimits')    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 100],'ytick',25:25:100,...
        'fontsize', 12, 'fontname', 'arial','XTickLabel',{},'tickdir','out');
    ylabel('% Carbon', 'fontsize', 14, 'fontname', 'arial','fontweight','bold')
    lh=legend('Dinoflagellates','Diatoms','Other');
    legend boxoff
    lh.FontSize = 12;               
    hp=get(lh,'pos'); 
    lh.Position = [hp(1) hp(2) hp(3)+.32 hp(4)]; 

 ax1=subplot(6,1,3); %SCW ROMS Temp
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,parula); caxis([10 16]); datetick('x','mmm');  grid on; 
    hold on
    hh=plot(X,[ROMS.mld5],'k-','linewidth',2);
    hold on     
    set(gca,'XLim',[xax1;xax2],'xticklabel',{},'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'ytick',10:20:50,'fontsize',12,'tickdir','out');
    datetick('x','mmm','keeplimits')    
    set(gca, 'XTickLabel',{})
    ylabel('Depth (m)','fontsize',14,'fontweight','bold');
    hold on
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 12;
    h.Label.String = 'T (^oC)';     
    h.Label.FontSize = 14;
    h.Label.FontWeight = 'bold';
    legend(hh,'MLD','Location','NE','fontsize',14); legend boxoff
    hold on

ax=subplot(6,1,4); %SCW ROMS Sal    
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Si];
    pcolor(X,Y,C); shading interp;
    colormap(ax,parula);    
    datetick('x','dd','keeplimits')        
    caxis([33.3 33.8]); datetick('x','mmm','keeplimits'); grid on; 
    hold on     
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse','ytick',10:20:50,...
        'ylim',[0 ROMS(1).Zi(end)],'xticklabel',{},'fontsize',12,'tickdir','out');
    ylabel('Depth (m)','fontsize',14,'fontweight','bold');
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 12;
    h.Label.String = 'S (g/kg)';
    h.Label.FontSize = 14;
    h.Label.FontWeight = 'bold';
    hold on

subplot(6,1,5); %SCW wind
%     [U,~]=plfilt(w.scw.u, w.scw.dn);
%     [V,DN]=plfilt(w.scw.v, w.scw.dn);
%     [~,u,~] = ts_aggregation(DN,U,12,'hour',@mean);
%     [time,v,~] = ts_aggregation(DN,V,12,'hour',@mean);
    yax1=-2; yax2=3;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    xlim([xax1;xax2])    
    datetick('x','mmm','keeplimits');   
    set(gca,'ytick',-2:2:2,'xticklabel',{},'fontsize',12);    
    ylabel('Wind (m/s)','fontsize',14,'fontname','arial','fontweight','bold');  
    hold on  
    
subplot(6,1,6);
    plot(SC.dn,SC.river,'-k','linewidth',1.5);
    set(gca,'xgrid','on','XLim',[xax1;xax2],'ytick',0:300:600,...
        'fontsize',12,'tickdir','out'); 
    ylabel({'Discharge (ft^3/s)'},'fontsize',14,'fontweight','bold');
datetick('x','mmm','keeplimits');  
hold on  

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_Dino_chl_class_wind_TS.tif']);
hold off

