%% Import wind data from Cape Elizabeth NDBC #46041 
%u = E-W or cross-shore velocity
%v = N-S or alongshore velocity
% The upwelling season at this latitude is defined from a climatological mean ...
% to occur from 27 April to 26 September [Schwing et al., 2006]. 

clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

% 2019
filename = '/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/Data/46041h2019.txt';
startRow = 3;
formatSpec = '%4f%3f%3f%3f%3f%4f%5f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
YYYY = dataArray{:, 1};
MM = dataArray{:, 2};
DD = dataArray{:, 3};
hh = dataArray{:, 4};
mm = dataArray{:, 5};
dtt=datetime(YYYY,MM,DD,hh,mm,YYYY);

dir = dataArray{:, 6}; dir(dir==999)=NaN;
spd = dataArray{:, 7}; spd(spd==999)=NaN;
[dt,dir,~] = ts_aggregation(dtt,dir,1,'day',@mean); 
[~,spd,~] = ts_aggregation(dtt,spd,1,'day',@mean);
dir=inpaintn(dir); spd=inpaintn(spd);
[u,v] = UVfromDM(dir,spd);
w19=table; w19.dt=dt; w19.u=u; w19.v=v;

idx=find(dt>datetime('27-Apr-2019') & dt<datetime('26-Sep-2019'));
w19.cui(idx)=-(cumsum(v(idx)));

clearvars filename startRow formatSpec fileID dataArray ans DD dtt hh mm MM YYYY u v dir spd dt;

% 2021
filename = '/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/Data/46041h2021.txt';
startRow = 3;
formatSpec = '%4f%3f%3f%3f%3f%4f%5f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
YYYY = dataArray{:, 1};
MM = dataArray{:, 2};
DD = dataArray{:, 3};
hh = dataArray{:, 4};
mm = dataArray{:, 5};
dtt=datetime(YYYY,MM,DD,hh,mm,YYYY);

dir = dataArray{:, 6}; dir(dir==999)=NaN;
spd = dataArray{:, 7}; spd(spd==999)=NaN;
[dt,dir,~] = ts_aggregation(dtt,dir,1,'day',@mean); 
[~,spd,~] = ts_aggregation(dtt,spd,1,'day',@mean);
dir=inpaintn(dir); spd=inpaintn(spd);
[u,v] = UVfromDM(dir,spd);
w21=table; w21.dt=dt; w21.u=u; w21.v=v;
w21.cui(idx)=-(cumsum(v(idx)));

clearvars filename startRow formatSpec fileID dataArray ans DD dtt hh mm MM YYYY u v dir spd dt;

save([filepath 'NOAA/Shimada/Data/wind_46041'],'w19','w21');

