addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path

%%
filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/SCW_master'],'SC');

gap=40; n=14; dn=SC.dn;

idx=isnan(SC.fxDino); SC.CHL(idx)=NaN; var = SC.fxDino.*log(SC.CHL); var(var<0)=0; %make sure CHL and DINO have same points 
varname = 'Dinoflagellate Chl'; [dinoC] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.windU; varname = 'Alongshore wind'; [Uwind] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.windV; varname = 'Crossshore wind'; [Vwind] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.NPGO; varname = 'NPGO'; [NPGO] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.MEI; varname = 'MEI'; [MEI] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.Tsensor; varname = 'Temperature'; [temp] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.N2; varname = 'N2'; [N2] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var=log(SC.sanlorR); varname = 'Discharge'; [sanlorR] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.PDO; varname = 'PDO'; [PDO] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

varname = 'Upwelling wind'; 
    [vfilt,~]=plfilt(SC.wind42V,dn); [ufilt,df]=plfilt(SC.wind42U,dn);   
    [up,across]=rotate_current(ufilt,vfilt,44); 
    [UpwellW] = extractClimatology_v1(up,df,filepath,varname,n,gap);

var = SC.curU; varname = 'Alongshore current'; [Ucur] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
var = SC.curV; varname = 'Crossshore current'; [Vcur] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
    
var = SC.ammonia; varname = 'Ammonium'; [ammon] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
var = SC.nitrate; varname = 'Nitrate'; [nitrate] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
var = SC.upwell; varname = 'UI'; [UI] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

%lag=2;vari = [NaN*ones(lag,1);SC.upwell]; var=vari(1:end-lag); %add lag to upwelling
%varname = 'UpwellingIndex'; [upwell] = extractClimatology(var,dn,filepath,varname,n);
%var=SC.upwell; varname = 'UpwellingIndex'; [upwell] =
%extractClimatology(var,dn,filepath,varname,n,gap);

clearvars var varname idx;

%% Plot Climatology 2004-2018

figure('Units','inches','Position',[1 1 7.5 9],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.05 0.05], [0.07 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
    
all=9;
xax1=datenum('01-Jan-2004');
%xax1=datenum('01-Jan-2012');
xax2=datenum('01-Jan-2019');
tick=datenum(2004:1:2019,1,1);
%tick=(xax1:31:xax2);

subplot(all,1,1); anomaly(dinoC.dn14d,dinoC.tAnom);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',12,'xtick',tick,...
    'xaxislocation','top','tickdir','out'); box on
ylabel({'Dino chl'},'fontsize',14,'fontweight','bold'); hold on
datetick('x','yy','keepticks','keeplimits')

Uwind.dn14d(1)=[]; Uwind.tAnom(1)=[]; Uwind.dn14d(end)=[]; Uwind.tAnom(end)=[];
subplot(all,1,2); anomaly(Uwind.dn14d,Uwind.tAnom);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',12,'xticklabel',{},...
    'xtick',tick,'tickdir','out'); box on
ylabel({'EW wind'},'fontsize',14,'fontweight','bold')
hold on

Vwind.dn14d(1)=[]; Vwind.tAnom(1)=[]; Vwind.dn14d(end)=[]; Vwind.tAnom(end)=[];
subplot(all,1,3); anomaly(Vwind.dn14d,Vwind.tAnom);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',12,'xticklabel',{},...
    'xtick',tick,'tickdir','out'); box on
ylabel({'NS wind'},'fontsize',14,'fontweight','bold')
hold on

subplot(all,1,4); anomaly(sanlorR.dn14d,sanlorR.tAnom);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',12,'xticklabel',{},...
    'xtick',tick,'tickdir','out'); box on
ylabel({'River'},'fontsize',14,'fontweight','bold')

subplot(all,1,5); anomaly(nitrate.dn14d,nitrate.tAnom);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',12,'ylim',[-1.8 2.8],...
    'xtick',tick,'xticklabel',{},'tickdir','out'); box on
ylabel({'Nitrate'},'fontsize',14,'fontweight','bold')
hold on

subplot(all,1,6); anomaly(UI.dn14d,UI.tAnom);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',12,'xticklabel',{},...
    'xtick',tick,'tickdir','out'); box on
ylabel({'Bakun'},'fontsize',14,'fontweight','bold')

subplot(all,1,7); anomaly(temp.dn14d,temp.tAnom);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',12,'xticklabel',{},...
    'xtick',tick,'ylim',[-2 2.6],'tickdir','out'); box on
ylabel({'Temp.'},'fontsize',14,'fontweight','bold'); hold on

subplot(all,1,8); anomaly(NPGO.dn14d,NPGO.ti9);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',12,'ylim',[-2.2 2.2],...
    'xtick',tick,'xticklabel',{},'tickdir','out'); box on
ylabel({'NPGO'},'fontsize',14,'fontweight','bold')
hold on

subplot(all,1,9); anomaly(PDO.dn14d,PDO.ti9);
set(gca,'xlim',[xax1 xax2],'xtick',tick,'xgrid','on','fontsize',12,...
    'tickdir','out'); box on
%datetick('x','yyyy','keepticks','keeplimits')
datetick('x','yy','keepticks','keeplimits')
ylabel({'PDO'},'fontsize',14,'fontweight','bold')
hold on

%%
subplot(all,1,9); anomaly(MEI.dn14d,MEI.ti9);
set(gca,'xlim',[xax1 xax2],'xtick',tick,'xgrid','on','fontsize',12,...
    'tickdir','out'); box on
%datetick('x','yyyy','keepticks','keeplimits')
datetick('x','yy','keepticks','keeplimits')
ylabel({'MEI'},'fontsize',14,'fontweight','bold')
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Climatology_SCW_2004-2018.tiff']);
hold off

%% Plot Climatology (generic)

C=dinoC;
varname='Dinoflagellate Chl';
units='(\mug/L)';
figure('Units','inches','Position',[1 1 8 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.02], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jul-2004');
xax2=datenum('01-Jan-2019');

subplot(3,1,1);
anomaly(C.dn14d,C.tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'ylim',[-2.3 3.1],'xgrid','on','fontsize',14)
datetick('x','yy','keeplimits')
box on
ylabel('Anomalies','fontsize',14)
hold on

subplot(3,1,2);
h=plot(C.dn,C.t,'o-',C.dn14d,C.ti9,'-','linewidth',1.5,'markersize',3);
set(h(2),'linewidth',2);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',14)
datetick('x','yy','keeplimits')
ylabel({['' num2str(units) '']},'fontsize',14)
legend('weekly raw','9pt running average','Location','N')
legend boxoff
hold on

subplot(3,1,3);
h=plot(C.dn14d,C.t14d,':k',C.dn14d,C.ti3,'-','linewidth',1.5);
set(h(1),'linewidth',2.5);
set(gca,'xlim',[datenum('01-Jan-2015') datenum('01-Jan-2019')],...
    'xtick',datenum('01-Jan-2015'):365:datenum('01-Jan-2019'),...
    'xgrid','on','fontsize',14)
datetick('x','yyyy','keeplimits')
ylabel({['' num2str(units) '']},'fontsize',14)
legend('climatology','3pt running average','Location','N')
legend boxoff
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\Climatology_SCW_' num2str(varname) '.tiff']);
hold off

