filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/SCW_master'],'SC');

dn=SC.dn;
n=14;
%%

var = SC.PDO; varname = 'PDO'; units = '';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.NPGO; varname = 'NPGO'; units = '';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = (SC.Zmax); varname = 'Zmax'; units = ' (m)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.maxdTdz; varname = 'maxdTdz'; units = ' (^oC/m)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.mld5; varname = 'MixedLayerDepth'; units = ' (m)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.ZmaxS; varname = 'Zmax_S'; units = ' (m)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.maxdTdzS; varname = 'maxdTdz_S'; units = ' (^oC/m)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.mld5S; varname = 'MixedLayerDepth_S'; units = ' (m)';
[C] = extractClimatology(var,dn,filepath,varname,n);

%var = log(SC.upwell+1 - min(SC.upwell))
var = SC.upwell; varname = 'UpwellingIndex'; units = ' (m^3/s/100m coastline)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.silicate; varname = 'Silicate'; units = ' (uM)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.ammonium; varname = 'Ammonium'; units = ' (uM)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.SSS; varname = 'SSS'; units = ' (ppt)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.T; varname = 'Temperature'; units = ' (^oC)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.SST; varname = 'SST'; units = ' (^oC)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = log(SC.CHL); varname = 'log(Chlorophyll)'; units = ' (mg m^{-3})';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.nitrate; varname = 'Nitrate'; units = '(uM)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = log(SC.river); varname = 'Discharge'; units = ' (ft^3 s^{-1})';
[C] = extractClimatology(var,dn,filepath,varname,n);

idx=isnan(SC.fxDino); SC.CHL(idx)=NaN; %make sure CHL and DINO have same points
var = SC.fxDino.*log(SC.CHL); varname = 'Dinoflagellate Chl'; units = ' (mg m^{-3})';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.fxDino.*SC.CHL; varname = 'Dinoflagellate CHL'; units = ' (mg m^{-3})';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.wind; varname = 'Windspeed_SC'; units = ' (m/s)';
[C] = extractClimatology(var,dn,filepath,varname,n);

var = SC.wind42; varname = 'Windspeed_46042'; units = ' (m/s)';
[C] = extractClimatology(var,dn,filepath,varname,n);

%% rename structures
load([filepath 'Data/Climatology_Dinoflagellate log(CHL)'],'C'); dino=C;
load([filepath 'Data/Climatology_maxdTdz'],'C'); maxdTdz=C;
load([filepath 'Data/Climatology_UpwellingIndex'],'C'); upwell=C;
load([filepath 'Data/Climatology_Zmax'],'C'); Zmax=C;
load([filepath 'Data/Climatology_Zmax_S'],'C'); ZmaxS=C;

load([filepath 'Data/Climatology_NPGO'],'C'); NPGO=C;
load([filepath 'Data/Climatology_PDO'],'C'); PDO=C;
load([filepath 'Data/Climatology_MixedLayerDepth'],'C'); MLD=C;
load([filepath 'Data/Climatology_MixedLayerDepth_S'],'C'); MLDS=C;

load([filepath 'Data/Climatology_Nitrate'],'C'); nit=C;
load([filepath 'Data/Climatology_Silicate'],'C'); sil=C;
load([filepath 'Data/Climatology_Ammonium'],'C'); ammon=C;
load([filepath 'Data/Climatology_log(Chlorophyll)'],'C'); chl=C;
load([filepath 'Data/Climatology_Dinoflagellate log(CHL)'],'C'); dino=C;
load([filepath 'Data/Climatology_Discharge'],'C'); river=C;
load([filepath 'Data/Climatology_Temperature'],'C'); T=C;
load([filepath 'Data/Climatology_Windspeed_SC'],'C'); windSC=C;
%load([filepath 'Data/Climatology_Windspeed_46042'],'C'); wind46042=C;

%% Plot Climatology drought analysis

figure('Units','inches','Position',[1 1 11 9],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.04 0.04], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jan-2003');
xax2=datenum('01-Oct-2018');

subplot(7,1,1);
anomaly(dino.dn14d,dino.tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',16,'xaxislocation','top')
datetick('x','yy','keeplimits')
box on
ylabel({'Dino Chl'},'fontsize',16,'fontweight','bold')
hold on

subplot(7,1,2);
anomaly(T.dn14d,T.tAnom);
datetick('x','yy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',16,'xticklabel',{},'ylim',[-2 2.5]);    
box on
ylabel({'SST'},'fontsize',16,'fontweight','bold')
hold on

subplot(7,1,3);
anomaly(upwell.dn14d,upwell.tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',16,'xticklabel',{})
box on
ylabel({'Upwelling'},'fontsize',16,'fontweight','bold')

subplot(7,1,4);
anomaly(river.dn14d,river.tAnom);
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',16,'xticklabel',{});
box on
ylabel({'River'},'fontsize',16,'fontweight','bold')

subplot(7,1,5);
anomaly(Zmax.dn14d,Zmax.tAnom);
datetick('x','yy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',16,'xticklabel',{});
box on
ylabel({'MLD'},'fontsize',16,'fontweight','bold')
hold on

% subplot(8,1,6);
% anomaly(nit.dn14d,nit.tAnom);
% datetick('x','yy','keeplimits')
% set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
%     'fontsize',16,'xticklabel',{});
% box on
% ylabel({'Nitrate (uM)'},'fontsize',16,'fontweight','bold')
% hold on

subplot(7,1,6);
anomaly(PDO.dn14d,PDO.tAnom);
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',16,'xticklabel',{});
box on
ylabel({'PDO'},'fontsize',16,'fontweight','bold')

subplot(7,1,7);
anomaly(NPGO.dn14d,NPGO.tAnom);
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',16,'xticklabel',{});
box on
ylabel({'NPGO'},'fontsize',16,'fontweight','bold')
datetick('x','yy','keeplimits')
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\Dino_Zmax_MLD_@SCW.tiff']);
hold off

%% Plot Climatology (generic)

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.05], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jan-2004');
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


%% Plot Climatology Zmax

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.05], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Sep-2010');
xax2=datenum('01-Jan-2019');

subplot(3,1,1);
anomaly(C.dn14d,C.tAnom);
hold on
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
box on
ylabel('Anomalies','fontsize',11,'fontweight','bold')
title('SCW ROMS Z(max dT/dz)','fontsize',12,'fontweight','bold');
hold on

subplot(3,1,2);
plot(C.dn,C.t,'o-',C.dn14d,C.ti9,'-','linewidth',1.5,'markersize',3)
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,...
    'Ydir','reverse','xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
ylabel('Z(max dT/dz) (m)','fontsize',10,'fontweight','bold')
title('weekly raw (blue), 9pt running average (red)','fontsize',11,'fontweight','normal');
hold on

subplot(3,1,3);
h=plot(C.dn14d,C.t14d,'--k',C.dn14d,C.ti3,'-','linewidth',1.5);
set(h(1),'linewidth',3);
set(gca,'xlim',[datenum('01-Jan-2015') datenum('01-Jan-2019')],...
    'xtick',datenum('01-Jan-2015'):365:datenum('01-Jan-2019'),...
    'xgrid','on','fontsize',10,'Ydir','reverse')
datetick('x','yyyy','keeplimits')
ylabel('Z(max dT/dz) (m)','fontsize',10,'fontweight','bold')
title('climatology (black dashed), 3pt running average (blue)','fontsize',11,'fontweight','normal');
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Climatology_SCW_' num2str(varname) '.tiff']);
hold off

%% Plot Climatology (WIND)

%wind.ti3(1:2)=NaN; wind.ti3(end)=NaN; wind.ti9(end)=NaN; 

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.05], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jan-2012');
xax2=datenum('01-Jan-2019');

subplot(3,1,1);
anomaly(C.dn14d,C.tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
box on
ylabel('Anomalies','fontsize',11,'fontweight','bold')
title(['Santa Cruz Wharf ' num2str(varname) ''],'fontsize',12,'fontweight','bold');
hold on

subplot(3,1,2);
plot(C.dn,C.t,'o-',C.dn14d,C.ti9,'-','linewidth',1.5,'markersize',3)
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
ylabel(['' num2str(varname) num2str(units) ''],'fontsize',11,'fontweight','bold')
title('weekly raw (blue), 9pt running average (red)','fontsize',11,'fontweight','normal');
hold on

subplot(3,1,3);
h=plot(C.dn14d,C.t14d,'--k',C.dn14d,C.ti3,'-','linewidth',1.5);
set(h(1),'linewidth',3);
set(gca,'xlim',[datenum('01-Jan-2015') datenum('01-Jan-2019')],...
    'xtick',datenum('01-Jan-2015'):365:datenum('01-Jan-2019'),...
    'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
ylabel(['' num2str(varname) num2str(units)''],'fontsize',11,'fontweight','bold')
title('climatology (black dashed), 3pt running average (blue)','fontsize',11,'fontweight','normal');
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Climatology_SCW_' num2str(varname) '.tiff']);
hold off
