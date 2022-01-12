%% Wind Rose manages the binning and display of speed and direction data. 
% The data binning is performed on two levels: 
% The speed data is divided into 6 bins of equal length starting from 0 and covering the range of windspeeds.
% The direction data is divided into 36 bins of equal angular size (10 degrees).

% plot SCW local winds each year 2012-2018
vwind=[0 1 2 3 4];
Options1 = {'anglenorth',0,'angleeast',90,'cMap','parula',...
    'freqlabelangle',45,'Min_Radius',0,'vWinds',vwind,...
    'LegendType',2,'TitleString',{'2018';''},'MaxFrequency',10,'nFreq',2};

WindRose(W_18.Direction,W_18.Speed,Options1);
set(gcf,'Units','inches','Position',[1 1 5.3 5],'PaperPositionMode','auto','menubar','none','toolbar','none');
set(legend,'visible','off')
