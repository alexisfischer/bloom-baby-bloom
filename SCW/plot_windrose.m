%% Wind Rose manages the binning and display of speed and direction data. 
% The data binning is performed on two levels: 
% The speed data is divided into 6 bins of equal length starting from 0 and covering the range of windspeeds.
% The direction data is divided into 36 bins of equal angular size (10 degrees).

%addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/MiscFunctions/')); % add new data to search path

filepath = '~/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/Wind_MB'],'w');

%% SCW import and organize data

site='SCW';
[DIR,~]=plfilt(w.scw.dir, w.scw.dn);
[SPD,DN]=plfilt(w.scw.spd, w.scw.dn);

[~,dir,~] = ts_aggregation(DN,DIR,2,'hour',@mean);
[dn,spd,~] = ts_aggregation(DN,SPD,2,'hour',@mean);
idx=isnan(spd); dn(idx)=[]; spd(idx)=[]; dir(idx)=[];

% only select certain months
season='Jan-May'; [~,M] = datevec(dn);
id = find(ismember(M,1:12));
dn=dn(id); dir=dir(id); spd=spd(id);

idx=find(dn>=datenum('01-Jan-2012') & dn<=datenum('31-Dec-2012'));
Direction=dir(idx); Speed=spd(idx); W_12=table(Direction,Speed);

idx=find(dn>=datenum('01-Jan-2013') & dn<=datenum('31-Dec-2013'));
Direction=dir(idx); Speed=spd(idx); W_13=table(Direction,Speed);

idx=find(dn>=datenum('01-Jan-2014') & dn<=datenum('31-Dec-2014'));
Direction=dir(idx); Speed=spd(idx); W_14=table(Direction,Speed);

idx=find(dn>=datenum('01-Jan-2015') & dn<=datenum('31-Dec-2015'));
Direction=dir(idx); Speed=spd(idx); W_15=table(Direction,Speed);

idx=find(dn>=datenum('01-Jan-2016') & dn<=datenum('31-Dec-2016'));
Direction=dir(idx); Speed=spd(idx); W_16=table(Direction,Speed);

idx=find(dn>=datenum('01-Jan-2017') & dn<=datenum('31-Dec-2017'));
Direction=dir(idx); Speed=spd(idx); W_17=table(Direction,Speed);

idx=find(dn>=datenum('01-Jan-2018') & dn<=datenum('31-Dec-2018'));
Direction=dir(idx); Speed=spd(idx); W_18=table(Direction,Speed);

% idx=find(dn>=datenum('01-Oct-2017') & dn<=datenum('31-Dec-2018'));
% Direction=dir(idx); Speed=spd(idx);
% W_1718=table(Direction,Speed);

% idx=find(dn>=datenum('01-Jan-2012') & dn<=datenum('01-Oct-2017'));
% Direction=dir(idx); Speed=spd(idx);
% W_other=table(Direction,Speed);

clearvars DN DIR SPD Direction Speed w id idx

%% plot SCW each year 2012-2018 (Jan-May)
close all
vwind=[0 1 2 3 4 5]; %SCW

Options1 = {'anglenorth',0,'angleeast',90,'cMap','gray',...
    'freqlabelangle',45,'Min_Radius',0,'vWinds',vwind,...
    'LegendType',2,'TitleString',{'2018';''},'MaxFrequency',12,'nFreq',4};
WindRose(W_18.Direction,W_18.Speed,Options1);
set(gcf,'Units','inches','Position',[1 1 5.3 5],'PaperPositionMode','auto','menubar','none','toolbar','none');

set(legend,'visible','off')
%set(legend,'Position',[-0.0224971064814815 0.596310763888889 0.31712962962963 0.411111111111111],'FontSize',12);
   
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/WindRose_2018_' num2str(site) '.tif']);
hold off

%% plot SCW each year 2012-2018
close all
vwind=[0 1 2 3 4]; %SCW

Options1 = {'anglenorth',0,'angleeast',90,'cMap','gray',...
    'freqlabelangle',45,'Min_Radius',0,'vWinds',vwind,...
    'LegendType',2,'TitleString',{'2012';''},'MaxFrequency',10,'nFreq',2};

WindRose(W_12.Direction,W_12.Speed,Options1);
set(gcf,'Units','inches','Position',[1 1 5.3 5],'PaperPositionMode','auto','menubar','none','toolbar','none');

set(legend,'visible','off')
%set(legend,'Position',[-0.0224971064814815 0.596310763888889 0.31712962962963 0.411111111111111],'FontSize',12);

set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/WindRose_2012_' num2str(site) 'all.tif']);
hold off

%% plot SCW 2012-2017 vs 2018
close all
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.02 0.1], [0.12 0.03]);

vwind=[0 1 2 3 4 5]; %SCW

axes1 = subplot(1,2,1);
set(gcf,'Units','inches','Position',[1 1 10 5],'PaperPositionMode','auto','menubar','none','toolbar','none');

Options1 = {'anglenorth',0,'angleeast',90,'cMap','parula',...
    'freqlabelangle',45,'axes',axes1,'Min_Radius',0,'vWinds',vwind,...
    'LegendType',2,'TitleString',{'2012-2017';''},'MaxFrequency',12,'nFreq',4};
[figure_handle2,~,~,~,~] = WindRose(W_other.Direction,W_other.Speed,Options1);

legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[-0.0107638888888889 0.619907407407408 0.201388888888889 0.430555555555555], 'FontSize',12);

axes2 = subplot(1,2,2);
Options2 = {'anglenorth',0,'angleeast',90,'cMap','parula',...
    'freqlabelangle',45,'axes',axes2,'Min_Radius',0,'vWinds',vwind,...
    'LegendType',0,'TitleString',{'2018';''},'MaxFrequency',12,'nFreq',4};
[figure_handle,~,~,~,~] = WindRose(W_1718.Direction,W_1718.Speed,Options2);
hold on

set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/WindRose_2hr_jan-may_12-18_' num2str(site) '.tif']);
hold off

%% OSO import and organize data

site='OSO';
[DIR,~]=plfilt(w.oso.dir, w.oso.dn);
[SPD,DN]=plfilt(w.oso.spd, w.oso.dn);

[~,dir,~] = ts_aggregation(DN,DIR,2,'hour',@mean);
[dn,spd,~] = ts_aggregation(DN,SPD,2,'hour',@mean);
idx=isnan(spd); dn(idx)=[]; spd(idx)=[]; dir(idx)=[];

% only select certain months
season='Jan-May'; [~,M] = datevec(dn);
id = find(ismember(M,1:5));
dn=dn(id); dir=dir(id); spd=spd(id);

idx=find(dn>=datenum('01-Oct-2017') & dn<=datenum('31-Dec-2018'));
Direction=dir(idx); Speed=spd(idx);
W_1718=table(Direction,Speed);

idx=find(dn>=datenum('01-Jan-2008') & dn<=datenum('01-Oct-2017'));
Direction=dir(idx); Speed=spd(idx);
W_other=table(Direction,Speed);

idx=find(dn>=datenum('01-Jan-2007') & dn<=datenum('01-Jan-2008'));
Direction=dir(idx); Speed=spd(idx);
W_2007=table(Direction,Speed);

clearvars DN DIR SPD Direction Speed w id idx

%% plot OSO using WindRose function
close all
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.02 0.1], [0.12 0.03]);

vwind=[0 3 6 9 12 15]; %OSO

axes1 = subplot(1,3,1);
set(gcf,'Units','inches','Position',[1 1 10 5],'PaperPositionMode','auto','menubar','none','toolbar','none');

Options1 = {'anglenorth',0,'angleeast',90,'cMap','parula',...
    'freqlabelangle',45,'axes',axes1,'Min_Radius',0,'vWinds',vwind,...
    'LegendType',2,'TitleString',{'2007';''},'MaxFrequency',8,'nFreq',4};
[figure_handle2,~,~,~,~] = WindRose(W_other.Direction,W_other.Speed,Options1);

legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[-0.0107638888888889 0.619907407407408 0.201388888888889 0.430555555555555], 'FontSize',12);

axes2 = subplot(1,3,2);
Options2 = {'anglenorth',0,'angleeast',90,'cMap','parula',...
    'freqlabelangle',45,'axes',axes2,'Min_Radius',0,'vWinds',vwind,...
    'LegendType',0,'TitleString',{'2008-2017';''},'MaxFrequency',8,'nFreq',4};
[figure_handle,~,~,~,~] = WindRose(W_1718.Direction,W_1718.Speed,Options2);
hold on

axes2 = subplot(1,3,3);
Options2 = {'anglenorth',0,'angleeast',90,'cMap','parula',...
    'freqlabelangle',45,'axes',axes2,'Min_Radius',0,'vWinds',vwind,...
    'LegendType',0,'TitleString',{'2018';''},'MaxFrequency',8,'nFreq',4};
[figure_handle,~,~,~,~] = WindRose(W_1718.Direction,W_1718.Speed,Options2);
hold on

%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/WindRose_2hr_jan-may_07-18_' num2str(site) '.tif']);
hold off