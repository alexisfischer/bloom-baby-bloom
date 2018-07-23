figpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';

load('~/Documents/MATLAB/bloom-baby-bloom/SCW/ROMS/SCW_master','SC');

%var = SC.ammonium; varname = 'Ammonium'; units = ' (ppt)';

%var = SC.sal; varname = 'Salinity'; units = ' (ppt)';

%var = SC.T; varname = 'Temperature'; units = ' (^oC)';
%var = log(SC.CHL); varname = 'log(Chlorophyll)'; units = ' (mg m^{-3})';
%var = SC.CHL; varname = 'Chlorophyll'; units = ' (mg m^{-3})';

var = SC.nitrate; varname = 'Nitrate'; units = '(uM)';

%var = log(SC.river); varname = 'log(Discharge)'; units = ' (ft^3 s^{-1})';

%idx=isnan(SC.fxDino); SC.CHL(idx)=NaN; %make sure CHL and DINO have same points
%var = SC.fxDino.*log(SC.CHL); varname = 'Dinoflagellate log(CHL)'; units = ' (mg m^{-3})';

[dn,t,dn14d,t14d,ti3,ti9,tAnom] = extractClimatology(var,SC);

%%

nitrate.dn=dn;
nitrate.t=t;
nitrate.dn14d=dn14d;
nitrate.t14d=t14d;
nitrate.ti3=ti3;
nitrate.ti9=ti9;
nitrate.tAnom=tAnom;

T.dn=dn;
T.t=t;
T.dn14d=dn14d;
T.t14d=t14d;
T.ti3=ti3;
T.ti9=ti9;
T.tAnom=tAnom;

chl.dn=dn;
chl.t=t;
chl.dn14d=dn14d;
chl.t14d=t14d;
chl.ti3=ti3;
chl.ti9=ti9;
chl.tAnom=tAnom;

dino.dn=dn;
dino.t=t;
dino.dn14d=dn14d;
dino.t14d=t14d;
dino.ti3=ti3;
dino.ti9=ti9;
dino.tAnom=tAnom;

ammon.dn=dn;
ammon.t=t;
ammon.dn14d=dn14d;
ammon.t14d=t14d;
ammon.ti3=ti3;
ammon.ti9=ti9;
ammon.tAnom=tAnom;

river.dn=dn;
river.t=t;
river.dn14d=dn14d;
river.t14d=t14d;
river.ti3=ti3;
river.ti9=ti9;
river.tAnom=tAnom;

save('~/Documents/MATLAB/bloom-baby-bloom/SCW/ROMS/SCW_climate','chl','dino','ammon','river','nitrate','T');

%% Plot Climatology drought analysis

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.05 0.05], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jan-2002');
xax2=datenum('01-Jan-2019');

subplot(5,1,1);
anomaly(dino.dn14d,dino.tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10,'xaxislocation','top')
datetick('x','yyyy','keeplimits')
box on
ylabel({'Dino log(CHL)'; 'Anomalies'},'fontsize',10,'fontweight','bold')
hold on

subplot(5,1,2);
anomaly(chl.dn14d,chl.tAnom);
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',10,'xticklabel',{});
box on
ylabel({'log(CHL) (mg m^{-3})'; 'Anomalies'},'fontsize',10,'fontweight','bold')
hold on

subplot(5,1,3);
anomaly(river.dn14d,river.tAnom);
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',10,'xticklabel',{});    
box on
ylabel({'log(Discharge)';'(ft^3 s^{-1}) Anomalies'},'fontsize',10,'fontweight','bold')
hold on

subplot(5,1,4);
anomaly(T.dn14d,T.tAnom);
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',10,'xticklabel',{});    
box on
ylabel({'Temperature (^oC)';'Anomalies'},'fontsize',10,'fontweight','bold')
hold on

subplot(5,1,5);
anomaly(ammon.dn14d,ammon.tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
box on
ylabel({'Ammonium (uM)';'Anomalies'},'fontsize',10,'fontweight','bold')
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[figpath 'Figs\Dino_Drought.tiff']);
hold off

%% Plot Climatology (generic)

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.05], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jan-2002');
xax2=datenum('01-Jan-2019');

subplot(3,1,1);
anomaly(dn14d,tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
box on
ylabel('Anomalies','fontsize',11,'fontweight','bold')
title(['Santa Cruz Wharf ' num2str(varname) ''],'fontsize',12,'fontweight','bold');
hold on

subplot(3,1,2);
%[p,S]=polyfit(dn,t,1);
%f=polyval(p,dn);
%mdl=fitlm(dn,t,'linear')
plot(dn,t,'o-',dn14d,ti9,'-','linewidth',1.5,'markersize',3)
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
ylabel(['' num2str(varname) num2str(units) ''],'fontsize',11,'fontweight','bold')
title('weekly raw (blue), 9pt running average (red)','fontsize',11,'fontweight','normal');
hold on

subplot(3,1,3);
h=plot(dn14d,t14d,'--k',dn14d,ti3,'-','linewidth',1.5);
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
print(gcf,'-dtiff','-r200',[figpath 'Figs\Climatology_SCW_' num2str(varname) '.tiff']);
hold off

