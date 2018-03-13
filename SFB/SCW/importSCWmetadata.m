%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/afischer/Documents/MATLAB/bloom-baby-bloom/Data/temp_SCW_2011-2018.csv
%

%% Initialize variables.
filename = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/Data/temp_SCW_2011-2018.csv';
delimiter = ',';
startRow = 2;

%% Time
fileID = fopen(filename,'r');
formatSpec = '%*q%*q%*q%*q%q%*s%[^\n\r]';
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
time = cellstr(dataArray{:, 1}); % Allocate imported array to column variable names
dnn=datenum(time,'YYYY-mm-ddTHH:MM:SS');
clearvars formatSpec fileID dataArray time ans; % Clear temporary variables

%% Temperature (deg C)
fileID = fopen(filename,'r');
formatSpec = '%*q%*q%*q%*q%*q%f%[^\n\r]';
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
temp = dataArray{:, 1};
clearvars formatSpec fileID dataArray time ans delimiter filename startRow; % Clear temporary variables

%%
[dn,t,~]=ts_aggregation(dnn,temp,1,'day',@mean);
t(t==0)=NaN;

%%
figure('Units','inches','Position',[1 1 6 2],'PaperPositionMode','auto');

plot(dn,t,'k-','Linewidth',2);
    hold on
set(gca,'ylim',[8 20],'ytick',8:4:20,...
        'xlim',[datenum('2016-08-01') datenum('2017-07-31')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01'),...
        datenum('2016-12-01'),datenum('2017-01-01'),...
        datenum('2017-02-01'),datenum('2017-03-01'),...
        datenum('2017-04-01'),datenum('2017-05-01'),...
        datenum('2017-06-01'),datenum('2017-07-01')],...        
        'XTickLabel',{'Aug','Sep',...
        'Oct','Nov','Dec','Jan17','Feb','Mar','Apr','May','Jun','Jul'},...
        'fontsize',8,'XAxisLocation','bottom','TickDir','out'); 
        hold on
        ylabel('Temperature (^oC)','fontsize',9,'fontweight','bold');        

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600','~/Documents/MATLAB/bloom-baby-bloom/SCW/Figs/Temp_SCW.tif')
hold off 

%%
% %% Pressure
% %   column2: double (%f)
% fileID = fopen(filename,'r');
% formatSpec = '%*s%f%*s%*s%*s%[^\n\r]';
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
% sea_water_pressure = flipud(dataArray{:, 1}); % Allocate imported array to column variable names
% clearvars formatSpec fileID dataArray time ans; % Clear temporary variables
% 
% %% Mass concentration of Chlorophyll in sea water
% %   column3: double (%f)
% fileID = fopen(filename,'r');
% formatSpec = '%*s%*s%f%*s%*s%[^\n\r]';
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
% chl = flipud(dataArray{:, 1});
% clearvars formatSpec fileID dataArray time ans; % Clear temporary variables
% 
% %% Temperature
% %   column4: double (%f)
% fileID = fopen(filename,'r');
% formatSpec = '%*s%*s%*s%f%*s%[^\n\r]';
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
% temp = dataArray{:, 1}; % Allocate imported array to column variable names
% clearvars formatSpec fileID dataArray time ans; % Clear temporary variables
% 
% %% Turbidity
% %   column9: double (%f)
% fileID = fopen(filename,'r');
% formatSpec = '%*s%*s%*s%*s%f%[^\n\r]';
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
% turb = flipud(dataArray{:, 1}); % Allocate imported array to column variable names
% clearvars formatSpec fileID dataArray time ans delimiter filename startRow; % Clear temporary variables

