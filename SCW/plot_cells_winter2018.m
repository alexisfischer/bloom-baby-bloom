%% Plot cells/L for select classes for winter 2018 at SCW
%  Alexis D. Fischer, University of California - Santa Cruz, April 2019
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/IFCB_summary/class/summary_allTB_2018'],...
    'class2useTB','ml_analyzedTB','mdateTB','classcountTB_above_optthresh');
classcountTB=classcountTB_above_optthresh;
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Wind_MB'],'w');
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS');

%%%% (1) process and extract Classifier data for class of interest
% convert to PST (UTC is 7 hrs ahead)
time=datetime(mdateTB,'ConvertFrom','datenum'); time=time-hours(7); 
time.TimeZone='America/Los_Angeles'; mdateTB=datenum(time);
 
% eliminate samples where tina was likely not taking in new samples
total=NaN*ones(size(mdateTB));
for i=1:length(mdateTB)
    total(i)=sum(classcountTB(i,:)); %find number of triggers per sample
end
idx=find(total<=100); %find totals where tina was likely not taking in new samples 
mdateTB(idx)=[]; ml_analyzedTB(idx)=[]; classcountTB(idx,:)=[];

%%%% (2) extract classes of interest
n=1;
[mdate,AKA,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Akashiwo',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,CER,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Ceratium',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,GYM,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Gymnodinium',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,PRO,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Prorocentrum',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,CHA,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Chaetoceros',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,DCL,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Det_Cer_Lau',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,EUC,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Eucampia',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,PSN,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Pseudo-nitzschia',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,CEN,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Centric',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);

idx=isnan(AKA); mdate(idx)=[];
AKA(idx)=[]; CER(idx)=[]; GYM(idx)=[]; PRO(idx)=[]; CHA(idx)=[]; DCL(idx)=[]; EUC(idx)=[]; PSN(idx)=[]; CEN(idx)=[];

idx=diff(mdate)>4;%find where data gap exceeds threshold
AKA(idx)=nan; CER(idx)=nan; GYM(idx)=nan; PRO(idx)=nan; CHA(idx)=nan; DCL(idx)=nan; EUC(idx)=nan; PSN(idx)=nan; CEN(idx)=nan;

% AKA=classcountTB(:,strmatch('Akashiwo',class2useTB))./ml_analyzedTB(:); 
% CER=classcountTB(:,strmatch('Ceratium',class2useTB))./ml_analyzedTB(:); 
% GYM=classcountTB(:,strmatch('Gymnodinium',class2useTB))./ml_analyzedTB(:); 
% PRO=classcountTB(:,strmatch('Prorocentrum',class2useTB))./ml_analyzedTB(:); 
% CHA=classcountTB(:,strmatch('Chaetoceros',class2useTB))./ml_analyzedTB(:); 
% DCL=classcountTB(:,strmatch('Det_Cer_Lau',class2useTB))./ml_analyzedTB(:); 
% EUC=classcountTB(:,strmatch('Eucampia',class2useTB))./ml_analyzedTB(:); 
% PSN=classcountTB(:,strmatch('Pseudo-nitzschia',class2useTB))./ml_analyzedTB(:); 
% CEN=classcountTB(:,strmatch('Centric',class2useTB))./ml_analyzedTB(:); 

clearvars total time idx i classcountTB mdateTB classcountTB_above_optthresh ml_analyzedTB

%% 2018 plot fraction biovolume with Chlorophyll
figure('Units','inches','Position',[1 1 16 11],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.04 0.04], [0.08 0.24]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%xax1=datenum('2018-01-19'); xax2=datenum('2018-04-07'); xtick=(xax1:7:xax2);
xax1=datenum('2018-02-15'); xax2=datenum('2018-04-04'); xtick=(xax1+1:5:xax2);

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(7,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGn'));
col_diat2=(brewermap(7,'Blues'));
col_diat3=(brewermap(5,'Purples'));

subplot(6,1,[1 2])
    h=plot(mdate,[AKA GYM PRO],'-k','linewidth',2);    
    set(h(1),'Color',col_dino1(9,:)); %aka
    set(h(2),'Color',col_dino2(7,:)); %gm
    set(h(3),'Color',col_dino2(4,:)); %pro
   set(gca,'xaxislocation','top','xlim',[xax1 xax2],'xtick',xtick,'xticklabel',datestr(xtick,'dd-mmm'),...
        'ylim',[0 75],'ytick',25:25:75,'fontsize', 14, 'fontname', 'arial','tickdir','out');
    ylabel('Cells/mL', 'fontsize', 16, 'fontname', 'arial')
    lh=legend('\itAkashiwo sanguinea','\itGymnodinium','\itProrocentrum');
    legend boxoff
    lh.FontSize = 16;               
    hp=get(lh,'pos'); 
    lh.Position = [hp(1) hp(2) hp(3)+.35 hp(4)]; 
    hold on

% subplot(6,1,2)
%     h=plot(mdate,[CHA DCL PSN.*5 CEN],'-k','linewidth',2);
%     set(h(1),'Color',col_diat1(6,:)); %cha
%     set(h(2),'Color',col_diat1(4,:)); %DCL
%     set(h(3),'Color',col_diat2(5,:)); %PN
%     set(h(4),'Color',col_diat2(7,:)); %Ceh
% 
%    set(gca,'xaxislocation','bottom','xlim',[xax1 xax2],'xtick',xtick,'xticklabel',{},...
%         'ylim',[0 120],'ytick',20:40:120,'fontsize', 14, 'fontname', 'arial','tickdir','out');
%     ylabel('Cells/mL', 'fontsize', 16, 'fontname', 'arial')
%     lh=legend('\itChaetoceros','\itDetonula, Cerataulina, Lauderia',...
%         '\itPseudo-nitzschia','centric');
%     legend boxoff    
%     lh.FontSize = 16;               
%     hp=get(lh,'pos'); 
%     lh.Position = [hp(1) hp(2) hp(3)+.48 hp(4)]; 
%     hold on

subplot(6,1,3); %SCW wind
    [U,~]=plfilt(w.scw.u, w.scw.dn);
    [V,DN]=plfilt(w.scw.v, w.scw.dn);
    [~,u,~] = ts_aggregation(DN,U,4,'hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,4,'hour',@mean);
    yax1=-3; yax2=3;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    xlim([xax1;xax2])    
    set(gca,'xlim',[xax1 xax2],'xtick',xtick,'ytick',-2:2:2,'xticklabel',{},'fontsize',14);    
    ylabel({'SCW';'wind (m/s)'},'fontsize',16,'fontname','arial');  
    hold on   
    
subplot(6,1,4); %upwelling wind
    [U,~]=plfilt(w.s42.u, w.s42.dn);
    [V,DN]=plfilt(w.s42.v, w.s42.dn);
    [~,u,~] = ts_aggregation(DN,U,4,'hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,4,'hour',@mean);
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    xlim([xax1;xax2])    
    set(gca,'xtick',xtick','ytick',-8:8:8,'xticklabel',{},'fontsize',14);    
    ylabel({'Offshore';'wind (m/s)'},'fontsize',16,'fontname','arial');  
    hold on   
%%
ax=subplot(6,1,5); %Brunt-Väisälä frequency
    cax=[-5 -3]; 
    X=[ROMS.dn]';
    Y=(ROMS(1).Zi(1:end-1))';
    C=[ROMS.logN2];
    pcolor(X,Y,C); shading interp;
    colormap(ax,parula); caxis(cax); grid on; 
    hold on
    hold on     
    set(gca,'xlim',[xax1 xax2],'xtick',xtick,'xticklabel',{},'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'ytick',[5 10 20 40],'fontsize',14,'tickdir','out');
    set(gca, 'XTickLabel',{})
    ylabel('Depth (m)','fontsize',16);
    hold on
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 14;
    h.Label.String = 'log N^2 (s^{-2})';     
    h.Label.FontSize = 16;
    h.Ticks=linspace(cax(1),cax(2),3);       
    hold on

 ax1=subplot(6,1,6); %SCW ROMS Temp
    cax=[10 14]; 
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,parula); caxis(cax); grid on; 
    hold on
    hh=plot(X,[ROMS.mld5],'w-','linewidth',2);
    hold on     
    set(gca,'xlim',[xax1 xax2],'xtick',xtick,'xticklabel',...
        datestr(xtick,'dd-mmm'),'Ydir','reverse','ylim',[0 ROMS(1).Zi(end)],...
        'ytick',[5 10 20 40],'fontsize',14,'tickdir','out')
    ylabel('Depth (m)','fontsize',16);
    hold on
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 12;
    h.Label.String = 'Temperature (^oC)';     
    h.Label.FontSize = 16;
    h.Ticks=linspace(cax(1),cax(2),3);       
    hold on    
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW_March2018_cells_highres.tif']);
hold off
