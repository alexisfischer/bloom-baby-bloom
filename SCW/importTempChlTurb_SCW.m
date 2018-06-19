
resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';

filename = [resultpath 'Data/SCW_weatherstation_cencoos/CENCOOS_09-18.csv'];
delimiter = ',';
startRow = 3;

%% Import Cencoos .csv file 
%Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%f%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% Close the text file.
fclose(fileID);

% Allocate imported array to column variable names
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

[~,CHL_ugL,~] = ts_aggregation(dn,flipud(mass_concentration_of_chlorophyll_in_sea_water),1,'day',@mean);
[~,TEMP_F,~] = ts_aggregation(dn,flipud(sea_water_temperature),1,'day',@mean);
TEMP_C=(TEMP_F-32)*.5556;
[DN,TUR_ntu,~] = ts_aggregation(dn,flipud(turbidity),1,'day',@mean);

for i=1:length(DN)
    if CHL_ugL(i) <=0
        CHL_ugL(i) = NaN;        
    end
    if TEMP_C(i) <= 0
        TEMP_C(i) = NaN;        
    end    
    if TUR_ntu(i) <= 0
        TUR_ntu(i) = NaN;        
    end       
end

%remove the extra minutes. just keep the day
d = dateshift(datetime(datestr(DN)),'start','day');
d.Format = 'dd-MMM-yyyy';

S.dn=datenum(d);
S.temp=TEMP_C;
S.chl=CHL_ugL;
S.turbid=TUR_ntu;
S.notes1='chlorophyll = ug/L';
S.notes2='turbidity = ntu';

save([resultpath 'Data/TempChlTurb_SCW'],'S');

