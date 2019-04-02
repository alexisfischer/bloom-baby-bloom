filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/SCW_master'],'SC');

dn=SC.dn;
n=14;

idx=isnan(SC.fxDino); SC.CHL(idx)=NaN; %make sure CHL and DINO have same points
var = SC.fxDino.*log(SC.CHL); varname = 'Dinoflagellate Chl'; [dinoC] = extractClimatology_partial(var,dn,filepath,varname,n);

%var = log(SC.AKA); varname = 'Akashiwo'; [akaC] = extractClimatology_partial(var,dn,filepath,varname,n);

var = SC.NPGO; varname = 'NPGO'; [NPGO] = extractClimatology(var,dn,filepath,varname,n);

var = SC.MEI; varname = 'MEI'; [MEI] = extractClimatology(var,dn,filepath,varname,n);

var = SC.Tsensor; varname = 'Temperature'; [temp] = extractClimatology(var,dn,filepath,varname,n);

var=log(SC.river); varname = 'Discharge'; [river] = extractClimatology(var,dn,filepath,varname,n);

var = SC.windU; varname = 'U wind-vector'; [Uwind] = extractClimatology(var,dn,filepath,varname,n);

var = SC.windV; varname = 'V wind-vector'; [Vwind] = extractClimatology(var,dn,filepath,varname,n);

%var = SC.wind42U; varname = 'U 42 wind-vector'; [U42wind] = extractClimatology(var,dn,filepath,varname,n);

%var = SC.wind42V; varname = 'V 42 wind-vector'; [V42wind] = extractClimatology(var,dn,filepath,varname,n);

%var = SC.Zmax; varname = 'Zmax'; [Zmax] = extractClimatology(var,dn,filepath,varname,n);

var = SC.PDO; varname = 'PDO'; [PDO] = extractClimatology_partial(var,dn,filepath,varname,n);

%var = SC.mld5; varname = 'MixedLayerDepth'; [MLD] = extractClimatology(var,dn,filepath,varname,n);

%lag=2;vari = [NaN*ones(lag,1);SC.upwell]; var=vari(1:end-lag); %add lag to upwelling
%varname = 'UpwellingIndex'; [upwell] = extractClimatology(var,dn,filepath,varname,n);
%var=SC.upwell; varname = 'UpwellingIndex'; [upwell] = extractClimatology(var,dn,filepath,varname,n);

%var = SC.SwD; varname = 'SwellDirection'; [SwD] = extractClimatology_partial(var,dn,filepath,varname,n);

%var = SC.ammonium; varname = 'Ammonium'; [ammon] = extractClimatology_partial(var,dn,filepath,varname,n);

clearvars var varname idx;

%% Plot Climatology drought analysis

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.04 0.04], [0.08 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
    
all=8;
xax1=datenum('01-Jan-2004');
%xax1=datenum('01-Jan-2012');
xax2=datenum('01-Jan-2019');

subplot(all,1,1); anomaly(dinoC.dn14d(1:end-1),zscore(dinoC.tAnom(1:end-1)));
datetick('x','yy','keeplimits'); 
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14,'xaxislocation','top'); box on
ylabel({'Dino Chl'},'fontsize',16,'fontweight','bold'); hold on

subplot(all,1,2); anomaly(Uwind.dn14d(1:end-1),zscore(Uwind.tAnom(1:end-1)));
datetick('x','yy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14,'xticklabel',{}); box on
ylabel({'U-wind'},'fontsize',16,'fontweight','bold')
hold on

subplot(all,1,3); anomaly(Vwind.dn14d(1:end-1),zscore(Vwind.tAnom(1:end-1)));
datetick('x','yy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14,'xticklabel',{}); box on
ylabel({'V-wind'},'fontsize',16,'fontweight','bold')
hold on

subplot(all,1,4); anomaly(NPGO.dn14d(1:end-1),zscore(NPGO.tAnom(1:end-1)));
datetick('x','yy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14,'xticklabel',{}); box on
ylabel({'NPGO'},'fontsize',16,'fontweight','bold')
hold on

subplot(all,1,5); anomaly(PDO.dn14d(1:end-1),zscore(PDO.tAnom(1:end-1)));
datetick('x','yy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14,'xticklabel',{}); box on
ylabel({'PDO'},'fontsize',16,'fontweight','bold')
hold on

subplot(all,1,6); anomaly(MEI.dn14d(1:end-1),zscore(MEI.tAnom(1:end-1)));
datetick('x','yy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14,'xticklabel',{}); box on
ylabel({'MEI'},'fontsize',16,'fontweight','bold')
hold on

subplot(all,1,7); anomaly(temp.dn14d(1:end-1),zscore(temp.tAnom(1:end-1)));
datetick('x','yy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14,'xticklabel',{},'ylim',[-2 2.5]); box on
ylabel({'SST'},'fontsize',16,'fontweight','bold'); hold on

subplot(all,1,8); anomaly(river.dn14d(1:end-1),zscore(river.tAnom(1:end-1)));
datetick('x','yy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14); box on
ylabel({'River'},'fontsize',16,'fontweight','bold')

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\Climatology_SCW_2004-2018.tiff']);
hold off

%% Plot Climatology (generic)

C=NPGO;
varname='NPGO';
units=' ';
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.05], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jan-2003');
xax2=datenum('01-Jan-2019');

subplot(3,1,1);
anomaly(C.dn14d,C.tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',12)
datetick('x','yy','keeplimits')
box on
ylabel('Anomalies','fontsize',14,'fontweight','bold')
%title(['' num2str(varname) ''],'fontsize',12,'fontweight','bold');
hold on

subplot(3,1,2);
plot(C.dn,C.t,'o-',C.dn14d,C.ti9,'-','linewidth',1.5,'markersize',3)
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',12)
datetick('x','yy','keeplimits')
ylabel({['' num2str(varname) ''];['' num2str(units) '']},'fontsize',14,'fontweight','bold')
title('weekly raw (blue), 9pt running average (red)','fontsize',12,'fontweight','normal');
hold on

subplot(3,1,3);
h=plot(C.dn14d,C.t14d,'--k',C.dn14d,C.ti3,'-','linewidth',1.5);
set(h(1),'linewidth',3);
set(gca,'xlim',[datenum('01-Jan-2015') datenum('01-Jan-2019')],...
    'xtick',datenum('01-Jan-2015'):365:datenum('01-Jan-2019'),...
    'xgrid','on','fontsize',12)
datetick('x','yyyy','keeplimits')
ylabel({['' num2str(varname) ''];['' num2str(units) '']},'fontsize',14,'fontweight','bold')
title('climatology (black dashed), 3pt running average (blue)','fontsize',12,'fontweight','normal');
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\Climatology_SCW_' num2str(varname) '.tiff']);
hold off

