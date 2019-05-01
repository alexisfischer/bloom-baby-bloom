%% Plot zoomed in winter-spring biovolume for 2018 at SCW
% parts modified from "compile_biovolume_summaries"
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

%%%% Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS');
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Wind_MB'],'w');
load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018'],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

%%%% convert to PST (UTC is 7 hrs ahead)
    time=datetime(mdateTB,'ConvertFrom','datenum'); time=time-hours(7); 
    time.TimeZone='America/Los_Angeles'; 
    time.Format = 'dd-MMM-uuuu HH:mm:ss'; 
    mdateTB = datenum(dateshift(time, 'start', 'hour')); %round to the nearest hour

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

%%%% Convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
    [ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
    [ cellC ] = biovol2carbon(classbiovolTB, ind_diatom ); 
    volC=zeros(size(cellC)); %convert from per cell to per mL
    volB=zeros(size(cellC)); %convert from per cell to per mL
    for i=1:length(cellC)
        volC(i,:)=cellC(i,:)./ml_analyzedTB(i);
        volB(i,:)=classbiovolTB(i,:)./ml_analyzedTB(i);    
    end  
    volC=volC./1000; %convert from pg/mL to ug/L 
 
%%%% Take n hr average for various groups
    n=4; 
    %select total living biovolume 
    [ ind_cell, ~ ] = get_cell_ind_CA( class2useTB, class2useTB );
    [xmat,ymat,~] =  ts_aggregation(mdateTB,nansum(volC(:,ind_cell),2),n,'hour',@mean);
    [~,ymat_ml,~] =  ts_aggregation(mdateTB,ml_analyzedTB,n,'hour',@mean);

    % select only diatoms
    [ ind_diatom, class_label_diat ] = get_diatom_ind_CA( class2useTB, class2useTB );
    [~,ydiat,~] =  ts_aggregation(mdateTB,nansum(volC(:,ind_diatom),2),n,'hour',@mean);

    %select only dinoflagellates
    [ ind_dino, class_label_dino ] = get_dino_ind_CA( class2useTB, class2useTB );
    [~,ydino,~] =  ts_aggregation(mdateTB,nansum(volC(:,ind_dino),2),n,'hour',@mean);

    for i=1:length(class2useTB)
        BIO(i).class = class2useTB(i);
        [~,BIO(i).bio,~] = ts_aggregation(mdateTB,volB(:,i),n,'hour',@mean);
        [~,BIO(i).car,~] = ts_aggregation(mdateTB,volC(:,i),n,'hour',@mean);
    end    

%%%% Interpolate data for small data gaps 
    maxgap=5;
    [ydino] = interp1babygap(ydino,maxgap);
    [ydiat] = interp1babygap(ydiat,maxgap);
    [ymat] = interp1babygap(ymat,maxgap);
    [ymat_ml] = interp1babygap(ymat_ml,maxgap);
    for i=1:length(BIO)
        [BIO(i).bio_i] = interp1babygap(BIO(i).bio,maxgap);
        [BIO(i).car_i] = interp1babygap(BIO(i).car,maxgap);
    end    

    clearvars ind_dino ind_diat ind_cell

%% 2018 plot fraction biovolume with Chlorophyll
figure('Units','inches','Position',[1 1 16 11],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.04 0.04], [0.08 0.24]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%xax1=datenum('2018-01-19'); xax2=datenum('2018-05-20'); xtick=(xax1:7:xax2);
xax1=datenum('2018-02-15'); xax2=datenum('2018-04-07'); xtick=(xax1+1:7:xax2);

subplot(7,1,[1 2 3]); %species breakdown
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

Y=100*[select_dino./ymat,fx_otherdino,select_diat./ymat,fx_otherdiat,fx_other];
h = bar(xmat,Y, 'stack');

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

    set(gca,'xaxislocation','top','xlim',[xax1 xax2],'xtick',xtick,'xticklabel',datestr(xtick,'dd-mmm'),...
        'ylim',[0 100],'ytick',25:25:100,'fontsize', 16, 'fontname', 'arial','tickdir','out');
    ylabel('% Carbon', 'fontsize', 16, 'fontname', 'arial')
    lh=legend('\itAkashiwo sanguinea','\itCeratium',...
        '\itDinophysis','\itGymnodinium','\itMargalefidinium',...
        '\itProrocentrum','\itPeridinium','\itScrippsiella/Heterocapsa','other dinoflagellates',...
        '\itChaetoceros','\itDetonula/Cerataulina/Lauderia','\itEucampia',...
        '\itGuinardia/Dactyliosolen','\itPseudo-nitzschia','\itSkeletonema',...
        '\itThalassiosira','centric','pennate',...
        'other diatoms','other cell-derived');
    legend boxoff
    lh.FontSize = 16;               
    hp=get(lh,'pos'); 
    lh.Position = [hp(1) hp(2)+.05 hp(3)+.49 hp(4)]; 
    hold on

subplot(7,1,4); %SCW wind
    [U,~]=plfilt(w.scw.u, w.scw.dn);
    [V,DN]=plfilt(w.scw.v, w.scw.dn);
    [~,u,~] = ts_aggregation(DN,U,4,'hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,4,'hour',@mean);
    yax1=-2; yax2=3;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    xlim([xax1;xax2])    
    set(gca,'xlim',[xax1 xax2],'xtick',xtick,'ytick',-2:2:2,'xticklabel',{},'fontsize',16);    
    ylabel({'SCW';'wind (m/s)'},'fontsize',16,'fontname','arial');  
    hold on   
    
subplot(7,1,5); %upwelling wind
    [U,~]=plfilt(w.s42.u, w.s42.dn);
    [V,DN]=plfilt(w.s42.v, w.s42.dn);
    [~,u,~] = ts_aggregation(DN,U,4,'hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,4,'hour',@mean);
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    xlim([xax1;xax2])    
    set(gca,'xtick',xtick','ytick',-8:8:8,'xticklabel',{},'fontsize',16);    
    ylabel({'46042';'wind (m/s)'},'fontsize',16,'fontname','arial');  
    hold on   

ax=subplot(7,1,6); %Brunt-Väisälä frequency
    cax=[-5 -3]; 
    X=[ROMS.dn]';
    Y=(ROMS(1).Zi(1:end-1))';
    C=[ROMS.logN2];
    pcolor(X,Y,C); shading interp;
    colormap(ax,(gray)); caxis(cax); grid on; 
    hold on
    hold on     
    set(gca,'xlim',[xax1 xax2],'xtick',xtick,'xticklabel',{},'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'ytick',10:20:50,'fontsize',16,'tickdir','out');
    set(gca, 'XTickLabel',{})
    ylabel('Depth (m)','fontsize',16);
    hold on
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 14;
    h.Label.String = 'log_1_0 N^2 (s^{-2})';     
    h.Label.FontSize = 16;
    h.Ticks=linspace(cax(1),cax(2),3);       
    hold on
    
%  ax1=subplot(7,1,6); %SCW ROMS Temp
%     cax=[10 14]; 
%     X=[ROMS.dn]';
%     Y=[ROMS(1).Zi]';
%     C=[ROMS.Ti];
%     pcolor(X,Y,C); shading interp;
%     colormap(ax1,parula); caxis(cax); grid on; 
%     hold on
%     hh=plot(X,[ROMS.mld5],'k-','linewidth',2);
%     hold on     
%     set(gca,'xlim',[xax1 xax2],'xtick',xtick,'xticklabel',{},'Ydir','reverse',...
%         'ylim',[0 ROMS(1).Zi(end)],'ytick',10:20:50,'fontsize',12,'tickdir','out','XTickLabel',{})
%     ylabel('Depth (m)','fontsize',14,'fontweight','bold');
%     hold on
%     h=colorbar('east','AxisLocation','out');
%     hp=get(h,'pos'); 
%     h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
%     h.TickDirection = 'out';         
%     h.FontSize = 12;
%     h.Label.String = 'T (^oC)';     
%     h.Label.FontSize = 14;
%     h.Label.FontWeight = 'bold';
%     h.Ticks=linspace(cax(1),cax(2),3);       
%     legend(hh,'MLD','Location','NW','fontsize',14); legend boxoff
%     hold on

subplot(7,1,7);
    plot(SC.dn,SC.river,'-k','linewidth',1.5);
    set(gca,'xgrid','on','xlim',[xax1 xax2],'xtick',xtick,...
        'xticklabel',datestr(xtick,'dd-mmm'),'ytick',0:300:600,'fontsize',16,'tickdir','out'); 
    ylabel({'Discharge';'(ft^3/s)'},'fontsize',16);
hold on  

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW2018_dino_highres.tif']);
hold off