%% Wind Rose manages the binning and display of speed and direction data. 
% The data binning is performed on two levels: 
% The speed data is divided into 6 bins of equal length starting from 0 and covering the range of windspeeds.
% The direction data is divided into 36 bins of equal angular size (10 degrees).

addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/MiscFunctions/')); % add new data to search path

%% import and organize data

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/Wind_MB'],'w');

[DIR,~]=plfilt(w.scw.dir, w.scw.dn);
[SPD,DN]=plfilt(w.scw.spd, w.scw.dn);
[~,dir,~] = ts_aggregation(DN,DIR,2,'hour',@mean);
[dn,spd,~] = ts_aggregation(DN,SPD,2,'hour',@mean);

idx=isnan(spd); dn(idx)=[]; spd(idx)=[]; dir(idx)=[];

% only select certain months
season='Jan-May'; [~,M] = datevec(dn);
id = find(ismember(M,1:5));
dn=dn(id); dir=dir(id); spd=spd(id);

%%
idx=find(dn>=datenum('01-Oct-2017') & dn<=datenum('01-Dec-2018'));
Direction=dir(idx); Speed=spd(idx);
W_1718=table(Direction,Speed);

idx=find(dn>=datenum('01-Jan-2012') & dn<=datenum('01-Oct-2017'));
Direction=dir(idx); Speed=spd(idx);
W_other=table(Direction,Speed);

clearvars DN DIR SPD Direction Speed w id idx

%% plot using WindRose function
close all
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.02 0.1], [0.12 0.03]);

axes1 = subplot(1,2,1);
set(gcf,'Units','inches','Position',[1 1 10 5],'PaperPositionMode','auto','menubar','none','toolbar','none');

Options1 = {'anglenorth',0,'angleeast',90,'cMap','parula',...
    'freqlabelangle',45,'axes',axes1,'Min_Radius',0,'vWinds',[0 1 2 3 4 5],...
    'LegendType',2,'TitleString',{'2012-2017';''},'MaxFrequency',12,'nFreq',4};
[figure_handle2,~,~,~,~] = WindRose(W_other.Direction,W_other.Speed,Options1);

legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[-0.0107638888888889 0.619907407407408 0.201388888888889 0.430555555555555], 'FontSize',12);

axes2 = subplot(1,2,2);
Options2 = {'anglenorth',0,'angleeast',90,'cMap','parula',...
    'freqlabelangle',45,'axes',axes2,'Min_Radius',0,'vWinds',[0 1 2 3 4 5],...
    'LegendType',0,'TitleString',{'2018';''},'MaxFrequency',12,'nFreq',4};
[figure_handle,~,~,~,~] = WindRose(W_1718.Direction,W_1718.Speed,Options2);
hold on

%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/WindRose_SCW_2hr_jan-may.tif']);
hold off


%% plot using Matlab example 

f = galleryFigure( 'Name', 'Wind Rose Example','Position', [0.25, 0.25, 0.50, 0.50] );
WR = WindRose( 'Parent', f, 'WindData', W_1718 );
WR.LegendTitle.String = 'Wind Speed (m/s)';
WR.Title.String = 'Sep 2017 - Dec 2018';
WR.Title.FontSize = 16;
WR.Title.Position(1:2) = [WR.Title.Position(1)-6, WR.Title.Position(2)-1];

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/WindRose_2017-2018.tif']);
hold off


%%
f = galleryFigure( 'Name', 'Wind Rose Example','Position', [0.25, 0.25, 0.50, 0.50] );
WR = WindRose( 'Parent', f, 'WindData', W_other );
WR.LegendTitle.String = 'Wind Speed (m/s)';
WR.Title.String = 'Jan 2012 - Sep 2017'
WR.Title.FontSize = 16;
WR.Title.Position(1:2) = [WR.Title.Position(1)-6, WR.Title.Position(2)-1];



%%
import Charts.WindRose
load( fullfile( galleryRoot(), '+Data', 'WindData.mat' ) )
f = galleryFigure( 'Name', 'Wind Rose Example','Position', [0.25, 0.25, 0.50, 0.50] );
               
WR = WindRose( 'Parent', f, 'WindData', W );

%Customize the appearance of the chart.
WR.LegendTitle.String = 'Wind Speed (m/s)';
WR.Title.String = 'Wind Rose';
WR.Title.FontSize = 16;
WR.Title.Position(1:2) = [WR.Title.Position(1)-6, WR.Title.Position(2)-1];

%Change the speed and direction data together.
% rng default
% direction = 360 * rand( 10000, 1 );
% speed = exp( 0.15 * randn( size( direction ) ) );
% newWindData = table( direction, speed, 'VariableNames', {'Direction', 'Speed'} );
% WR.WindData = newWindData;

%Adjust the position of the chart title.
WR.Title.Position(1:2) = [-WR.MaxRadius+0.5, WR.MaxRadius];

