filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';

load([filepath 'Data/SCW_master'],'SC');

%var = SC.ammonium; varname = 'Ammonium'; units = ' (ppt)';

%var = SC.sal; varname = 'Salinity'; units = ' (ppt)';

%var = SC.T; varname = 'Temperature'; units = ' (^oC)';

%var = log(SC.CHL); varname = 'log(Chlorophyll)'; units = ' (mg m^{-3})';

%var = SC.CHL; varname = 'Chlorophyll'; units = ' (mg m^{-3})';

%var = SC.nitrate; varname = 'Nitrate'; units = '(uM)';

%var = log(SC.river); varname = 'log(Discharge)'; units = ' (ft^3 s^{-1})';
%var = SC.river; varname = 'Discharge'; units = ' (ft^3 s^{-1})';

idx=isnan(SC.fxDino); SC.CHL(idx)=NaN; %make sure CHL and DINO have same points
var = SC.fxDino.*log(SC.CHL); varname = 'Dinoflagellate log(CHL)'; units = ' (mg m^{-3})';

%%%%wind
% load([filepath 'Data/Wind_MB'],'w');
% [SPD,DN]=plfilt(w.scw.spd, w.scw.dn);
% [dn,spd,~] = ts_aggregation(DN,SPD,1,'day',@mean);
% d = dateshift(datetime(datestr(dn)),'start','day'); %remove the extra minutes. just keep the day
% d.Format = 'dd-MMM-yyyy';
% SC.dn=datenum(d);
%var = spd; varname = 'Windspeed'; units = ' (m/s)';

[C] = extractClimatology(var,SC,filepath,varname);

%% rename structures
load([filepath 'Data/Climatology_Ammonium'],'C'); ammon=C;
load([filepath 'Data/Climatology_log(Chlorophyll)'],'C'); chl=C;
load([filepath 'Data/Climatology_Dinoflagellate log(CHL)'],'C'); dino=C;
load([filepath 'Data/Climatology_log(Discharge)'],'C'); river=C;
%load([filepath 'Data/Climatology_Discharge'],'C'); river=C;
load([filepath 'Data/Climatology_Temperature'],'C'); T=C;
load([filepath 'Data/Climatology_Windspeed'],'C'); wind=C;

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
ylabel({'Dinoflagellate';'log Chlorophyll'},'fontsize',10,'fontweight','bold')
hold on

subplot(5,1,2);
anomaly(wind.dn14d,wind.tAnom);
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',10,'xticklabel',{});
box on
ylabel({'Windspeed'; '(m/s)'},'fontsize',10,'fontweight','bold')
hold on

subplot(5,1,3);
anomaly(river.dn14d,river.tAnom);
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',10,'xticklabel',{});    
box on
ylabel({'log Discharge';'(ft^3 s^{-1})'},'fontsize',10,'fontweight','bold')
hold on

subplot(5,1,4);
anomaly(T.dn14d,T.tAnom);
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on',...
    'fontsize',10,'xticklabel',{});    
box on
ylabel({'Temperature'; '(^oC)'},'fontsize',10,'fontweight','bold')
hold on

subplot(5,1,5);
anomaly(ammon.dn14d,ammon.tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
box on
ylabel({'Ammonium'; '(uM)'},'fontsize',10,'fontweight','bold')
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Dino_Drought.tiff']);
hold off

%% Plot Climatology (generic)

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.05], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jan-2002');
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

%% Plot Climatology (WIND)


wind.ti3(1:2)=NaN; wind.ti3(end)=NaN; wind.ti9(end)=NaN; 

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.05], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jan-2012');
xax2=datenum('01-Jan-2019');

subplot(3,1,1);
anomaly(wind.dn14d,wind.tAnom);
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
box on
ylabel('Anomalies','fontsize',11,'fontweight','bold')
title(['Santa Cruz Wharf ' num2str(varname) ''],'fontsize',12,'fontweight','bold');
hold on

subplot(3,1,2);
plot(wind.dn,wind.t,'o-',wind.dn14d,wind.ti9,'-','linewidth',1.5,'markersize',3)
set(gca,'xlim',[xax1 xax2],'xtick',xax1:365:xax2,'xgrid','on','fontsize',10)
datetick('x','yyyy','keeplimits')
ylabel(['' num2str(varname) num2str(units) ''],'fontsize',11,'fontweight','bold')
title('weekly raw (blue), 9pt running average (red)','fontsize',11,'fontweight','normal');
hold on

subplot(3,1,3);
h=plot(wind.dn14d,wind.t14d,'--k',wind.dn14d,wind.ti3,'-','linewidth',1.5);
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
