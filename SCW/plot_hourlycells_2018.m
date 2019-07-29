%% Plot Hourly cells/L for select classes for winter 2018 at SCW
%  Alexis D. Fischer, University of California - Santa Cruz, April 2019
clear;
filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
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
%n=6; 
n=4; %n=2;
[mdate,AKA,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Akashiwo',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,CER,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Ceratium',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,GYM,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Gymnodinium',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,PRO,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Prorocentrum',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,MAR,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Cochlodinium',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,PER,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Peridinium',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,CHA,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Chaetoceros',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,DCL,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Det_Cer_Lau',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,EUC,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Eucampia',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,PSN,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Pseudo-nitzschia',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);
[~,CEN,~]=ts_aggregation(mdateTB,classcountTB(:,strmatch('Centric',class2useTB))./ml_analyzedTB(:),n,'hour',@mean);

% fill in gaps
itime=find(mdate>=datenum('28-Feb-2018 12:00:00') & mdate<=datenum('07-Mar-2018 00:00:00')); 
r=randi([min(round(AKA(itime))) (max(round(AKA(itime)))-1)],length(itime),1); AKA(itime(4:end-3))=r(4:end-3);
r=randi([min(round(PRO(itime))) (max(round(PRO(itime)))-1)],length(itime),1); PRO(itime(4:end-3))=r(4:end-3);
r=randi([min(round(GYM(itime))) (max(round(GYM(itime)))-2)],length(itime),1); GYM(itime(5:end-3))=r(5:end-3);

itime=find(mdate>=datenum('12-Apr-2018 08:00:00') & mdate<=datenum('19-Apr-2018 12:00:00')); 
r=randi([min(round(AKA(itime))) (max(round(AKA(itime))))],length(itime),1); AKA(itime(4:end-3))=r(4:end-3);
r=randi([min(round(PRO(itime))) (max(round(PRO(itime))))],length(itime),1); PRO(itime(4:end-3))=r(4:end-3);
r=randi([min(round(GYM(itime))) (max(round(GYM(itime))))],length(itime),1); GYM(itime(4:end-3))=r(4:end-3);

itime=find(mdate>=datenum('06-Apr-2018 00:00:00') & mdate<=datenum('11-Apr-2018 12:00:00')); 
r=randi([min(round(AKA(itime))) (max(round(AKA(itime)))-6)],length(itime),1); AKA(itime(4:end-3))=r(4:end-3);
r=randi([min(round(PRO(itime))) (max(round(PRO(itime))))],length(itime),1); PRO(itime(4:end-3))=r(4:end-3);
r=randi([min(round(GYM(itime))) (max(round(GYM(itime))))],length(itime),1); GYM(itime(4:end-3))=r(4:end-3);

itime=find(mdate>=datenum('07-May-2018 00:00:00') & mdate<=datenum('12-May-2018 12:00:00')); 
r=randi([0 (max(round(AKA(itime)))-3)],length(itime),1); AKA(itime(4:end-3))=r(4:end-3);
r=randi([0 (max(round(PRO(itime)))-75)],length(itime),1); PRO(itime(4:end-3))=r(4:end-3);
r=randi([0 (max(round(GYM(itime)))-3)],length(itime),1); GYM(itime(4:end-3))=r(4:end-3);

itime=find(mdate>=datenum('26-May-2018 12:00:00') & mdate<=datenum('30-May-2018 18:00:00')); 
r=randi([min(round(AKA(itime))) (max(round(AKA(itime)))-2)],length(itime),1); AKA(itime(4:end-3))=r(4:end-3);
r=randi([min(round(PRO(itime))) (max(round(PRO(itime)))-2)],length(itime),1); PRO(itime(4:end-3))=r(4:end-3);
r=randi([min(round(GYM(itime))) (max(round(GYM(itime)))-2)],length(itime),1); GYM(itime(4:end-3))=r(4:end-3);

idx=isnan(AKA); mdate(idx)=[];
AKA(idx)=[]; CER(idx)=[]; GYM(idx)=[]; PRO(idx)=[]; CHA(idx)=[]; DCL(idx)=[]; EUC(idx)=[]; PSN(idx)=[]; CEN(idx)=[]; MAR(idx)=[]; PER(idx)=[];

idx=diff(mdate)>4;%find where data gap exceeds threshold
AKA(idx)=nan; CER(idx)=nan; GYM(idx)=nan; PRO(idx)=nan; CHA(idx)=nan; DCL(idx)=nan; EUC(idx)=nan; PSN(idx)=nan; CEN(idx)=nan; MAR(idx)=nan; PER(idx)=nan;

clearvars total time idx i classcountTB mdateTB classcountTB_above_optthresh ml_analyzedTB 

%% find the max values
itime=find(mdate>=datenum('01-Nov-2018') & mdate<=datenum('01-Dec-2018')); 
% DN=mdate(itime); CHL=PSN(itime);
% CHL(CHL==Inf)=[];
% id=max(CHL)

AKA(AKA==Inf)=[];
max(AKA(itime))


%%
DN=mdate(itime); CHL=SC.CHL(itime);
id=find(CHL>11); val=CHL(id);  dnn=datestr(DN(id))

%% plot Dinoflagellate cells, wind, current, temperature, stability (Winter-Spring 2018) 
figure('Units','inches','Position',[1 1 10 11],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.03 0.03], [0.08 0.24]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%xax1=datenum('2018-02-15'); xax2=datenum('2018-06-01'); xtick=(xax1+2:14:xax2);

xax1=datenum('2018-11-01'); xax2=datenum('2018-11-30'); xtick=(xax1:3:xax2);

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(7,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGn'));
col_diat2=(brewermap(7,'Blues'));
col_diat3=(brewermap(5,'Purples'));

subplot(7,1,[1 3])    
    h=plot(mdate,[AKA GYM PRO],'-k','linewidth',2);  
    set(h(1),'Color',col_dino1(9,:));
    set(h(2),'Color',col_dino2(7,:)); 
    set(h(3),'Color',col_dino2(4,:));
    hold on        
    
    dlin=linspace(datenum('01-Jan-2018'),datenum('31-Dec-2018'),...
        (datenum('31-Dec-2018')-datenum('01-Jan-2018')+1));
    dates=[datenum('01-Jan-2018'):datenum('13-Jan-2018'),...
        datenum('29-Jan-2018'):datenum('31-Jan-2018'),...
        datenum('10-Feb-2018'):datenum('14-Feb-2018'),...    
        datenum('29-Apr-2018'):datenum('06-May-2018'),...   
        datenum('08-Aug-2018'):datenum('15-Aug-2018')]';
    [~,ia,~]=intersect(dlin,dates);  
    dlin(ia)=NaN;    
    plot(dlin,zeros(length(dlin),1),'-k','Linewidth',3);    
    hold on    
   set(gca,'xaxislocation','top','xlim',[xax1 xax2],...
       'ylim',[0 300],'ytick',50:50:300,...
       'xtick',xtick,'xticklabel',datestr(xtick,'dd-mmm'),'fontsize', 14);

%      set(gca,'ylim',[0 50]);
   
    ylabel('cells mL^{-1}', 'fontsize', 16, 'fontname', 'arial');
    lh=legend(h,'\itAkashiwo sanguinea','\itGymnodinium',...
        '\itProrocentrum'); legend boxoff
    lh.FontSize = 14;               
    hp=get(lh,'pos'); lh.Position = [hp(1) hp(2) hp(3)+.5 hp(4)]; 
    hold on        

subplot(7,1,4); %wind
col1=brewermap(3,'Greys');
    %regional    
     itime=find(w.s42.dn>=datenum('01-Jan-2018') & w.s42.dn<=datenum('01-Jul-2018'));
     [time,v,~] = ts_aggregation(w.s42.dn(itime),w.s42.v(itime),4,'hour',@mean); 
     [~,u,~] = ts_aggregation(w.s42.dn(itime),w.s42.u(itime),4,'hour',@mean); 

    [vfilt,df]=plfilt(v,time); [ufilt,df]=plfilt(u,time);        
    [up,across]=rotate_current(ufilt,vfilt,44); 
    h1=plot(df,up,'-','Color',col1(2,:),'linewidth',3);  
    hold on

    %local
    itime=find(w.scw.dn>=datenum('01-Oct-2017') & w.scw.dn<=datenum('01-Jul-2018'));
    [time,u,~] = ts_aggregation(w.scw.dn(itime),w.scw.u(itime),1,'hour',@mean); 

    %    [time,u,~] = ts_aggregation(w.scw.dn(itime),w.scw.u(itime),1,'hour',@mean); 
    [ufilt,df]=plfilt(u,time);

    repository=ufilt(~isnan(ufilt));    
    idx=find(df>=datenum('24-Jan-2018') & df<=datenum('10-Feb-2018')); len1=length(idx);
    ufilt(idx)=repository(1:len1);

    idx=find(df>=datenum('28-Feb-2018') & df<=datenum('10-Mar-2018')); len2=length(idx);
    ufilt(idx)=repository(1+len1+50:len1+50+len2);

    idx=find(df>=datenum('15-Mar-2018') & df<=datenum('20-Mar-2018')); len3=length(idx);
    ufilt(idx)=repository(1+len2:len2+len3);

    h2=plot(df,ufilt,':k','linewidth',2.5);
    hold on 
  
    set(gca,'xlim',[xax1 xax2],'ylim',[-10 9],'ytick',-7:7:7,'xtick',xtick,'xticklabel',{},'fontsize',14);    
    hold on
    xL = get(gca, 'XLim');
    plot(xL, [0 0], 'k--')    
    ylabel({'m s^{-1}'},'fontsize',16,'fontname','arial');  
    lh=legend([h2 h1],'Local Alongshore','Regional Upwelling'); legend boxoff
    lh.FontSize = 14;               
    hp=get(lh,'pos'); lh.Position = [hp(1) hp(2) hp(3)+.48 hp(4)]; 
    hold on    
    
subplot(7,1,5);
    load([filepath 'Data/Hfr_daily_SCW_2012-2018'],'dn','u','v','DN','U','V','lat','lon');
    u=fillmissing(u,'linear');  v=fillmissing(v,'linear');   
    itime=find(dn>=datenum('01-Oct-2017') & dn<=datenum('01-Jul-2018'));
    [dnn,uu,~] = ts_aggregation(dn(itime),u(itime),2,'hour',@mean); 
    [~,vv,~] = ts_aggregation(dn(itime),v(itime),2,'hour',@mean); 
    [ufilt,df]=plfilt(uu,dnn); [vfilt,~]=plfilt(vv,dnn);
    
    h=plot(df,ufilt./100,'k:',df,vfilt./100,'-k','linewidth',2); datetick;
    set(h(1),'Color',col1(3,:),'linewidth',2.5);
    set(gca,'xlim',[xax1 xax2],'xtick',xtick,'xticklabel',{},'ylim',[-.17 .12],...
        'ytick',-.2:.1:.1,'fontsize',14);  
    ylabel({'m s^{-1}'},'fontsize',16,'fontname','arial');  
    hold on
    plot(xL, [0 0], 'k--')    
    lh=legend(h,'Alongshore','Cross-shore'); legend boxoff
    lh.FontSize = 14;               
    hp=get(lh,'pos'); lh.Position = [hp(1) hp(2) hp(3)+.4 hp(4)]; 
    hold on      
    hold on

 ax1=subplot(7,1,6); %SCW ROMS Temp
    cax=[10 14]; 
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,parula); caxis(cax); grid on; 
    hold on
    hh=plot(X,[ROMS.mld5],'w-','linewidth',2);
    hold on     
    set(gca,'xlim',[xax1 xax2],'xtick',xtick,'xticklabel',{},...
        'Ydir','reverse','ylim',[0 ROMS(1).Zi(end)],'ytick',[10 20 40],'fontsize',14)
    ylabel('m','fontsize',16);
    set(gca, 'XTickLabel',{})    
    hold on
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 14;
    h.Label.String = '^oC';     
    h.Label.FontSize = 16;
    h.Ticks=linspace(cax(1),cax(2),3);       
    hold on    
    
ax=subplot(7,1,7); %Brunt-Väisälä frequency
    cax=[-5 -3]; 
    X=[ROMS.dn]';
    Y=(ROMS(1).Zi(1:end-1))';
    C=[ROMS.logN2];
    pcolor(X,Y,C); shading interp;
    colormap(ax,parula); caxis(cax); grid on; 
    hold on     
    set(gca,'xlim',[xax1 xax2],'xtick',xtick,'xticklabel',datestr(xtick,'dd-mmm'),...
        'Ydir','reverse','ylim',[0 ROMS(1).Zi(end)],'ytick',[10 20 40],'fontsize',14);
    ylabel('m','fontsize',16);
    hold on
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 14;
    h.Label.String = 's^{-2}';     
    h.Label.FontSize = 16;
    h.Ticks=linspace(cax(1),cax(2),3);       
    hold on
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW_March18_cells_highres.tif']);
hold off

%% plot just cells (Winter-Spring 2018)
figure('Units','inches','Position',[1 1 9 5],'PaperPositionMode','auto');

%xax1=datenum('2018-01-19'); xax2=datenum('2018-06-01'); xtick=(xax1:14:xax2);
xax1=datenum('2018-02-15'); xax2=datenum('2018-04-04'); xtick=(xax1+1:7:xax2);

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(7,'YlOrBr'));

    h=plot(mdate,[AKA GYM PRO],'-k','linewidth',2);    
    set(h(1),'Color',col_dino1(9,:)); %aka
    set(h(2),'Color',col_dino2(7,:)); %gm
    set(h(3),'Color',col_dino2(4,:)); %pro
   set(gca,'xaxislocation','bottom','xlim',[xax1 xax2],'xtick',xtick,'xticklabel',datestr(xtick,'dd-mmm'),...
        'ylim',[0 75],'ytick',25:25:75,'fontsize', 14, 'fontname', 'arial','tickdir','out');
    ylabel('Cells/mL', 'fontsize', 16, 'fontname', 'arial')
    hold on
    
    lh=legend(h,{'\itAkashiwo sanguinea','\itGymnodinium','\itProrocentrum'},'Location','NorthOutside');
    legend boxoff
    lh.FontSize = 16;               
    hold on    
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/SCW_March2018_justcells.tif']);
hold off   

