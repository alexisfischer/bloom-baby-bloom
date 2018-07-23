

filename = '~/Documents/MATLAB/bloom-baby-bloom/SCW/Data/SCW_weatherstation_cencoos/CENCOOS_09-18.csv';
delimiter = ',';
startRow = 3;

%% Import CENCOOS downloadable sensor data
formatSpec = '%s%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
time = dataArray{:, 1};
mass_concentration_of_chlorophyll_in_sea_water = dataArray{:, 2};
sea_water_temperature = dataArray{:, 3};
turbidity = dataArray{:, 4};

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% convert to useable format
%deal with weird date format
%flip vector direction
%convert from F to Celcius
dn = flipud(datenum(datetime(time,'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z')));

[~,CHL,~] = ts_aggregation(dn,flipud(mass_concentration_of_chlorophyll_in_sea_water),1,'day',@mean);
[~,T_F,~] = ts_aggregation(dn,flipud(sea_water_temperature),1,'day',@mean);
T=(T_F-32)*.5556;
[DN,TUR,~] = ts_aggregation(dn,flipud(turbidity),1,'day',@mean);

for i=1:length(DN)
    if CHL(i) <=0
        CHL(i) = NaN;        
    end
    if T(i) <= 0
        T(i) = NaN;        
    end    
    if TUR(i) <= 0
        TUR(i) = NaN;        
    end       
end

%remove the extra minutes. just keep the day
d = dateshift(datetime(datestr(DN)),'start','day');
d.Format = 'dd-MMM-yyyy';

S.dn=datenum(d);
S.temp=T;
S.chl=CHL;
S.turbid=TUR;
S.notes1='chlorophyll = ug/L';
S.notes2='turbidity = ntu';

save([resultpath 'Data/TempChlTurb_SCW'],'S');

