%% imports all the data (except wind and IFCB) from Santa Cruz Wharf
% T, SSS, Chl, nit, amm, urea, ammon, phos, sil, DA, STX, RAI

filepath='/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/SCW_master'],'SC');

dn=(datenum('01-Jan-2003'):1:datenum('31-Dec-2018'))';

%%
SC.dn=dn;

% preallocate space
SC.SST=nan(size(SC.dn));
SC.T=nan(size(SC.dn));
SC.SSS=nan(size(SC.dn));
SC.CHL=nan(size(SC.dn));
SC.nitrate=nan(size(SC.dn));
SC.ammonium=nan(size(SC.dn));
SC.urea=nan(size(SC.dn));
SC.phosphate=nan(size(SC.dn));
SC.silicate=nan(size(SC.dn));
SC.DA=nan(size(SC.dn));
SC.STX=nan(size(SC.dn));
SC.Alex=nan(size(SC.dn));
SC.dinophysis=nan(size(SC.dn));
SC.Pn=nan(size(SC.dn));
SC.Paust=nan(size(SC.dn));
SC.Pmult=nan(size(SC.dn));
SC.fxDino=nan(size(SC.dn));
SC.fxDiat=nan(size(SC.dn));
SC.Tsensor=nan(size(SC.dn));
SC.CHLsensor=nan(size(SC.dn));
SC.TURsensor=nan(size(SC.dn));

SC.maxdTdz=nan(size(SC.dn));
SC.Zmax=nan(size(SC.dn));
SC.mld5=nan(size(SC.dn));

SC.maxdTdzS=nan(size(SC.dn));
SC.ZmaxS=nan(size(SC.dn));
SC.mld5S=nan(size(SC.dn));

SC.upwell=nan(size(SC.dn));
SC.river=nan(size(SC.dn));

SC.wind=nan(size(SC.dn));
SC.winddir=nan(size(SC.dn));
SC.windU=nan(size(SC.dn));
SC.windV=nan(size(SC.dn));
SC.wind42=nan(size(SC.dn));
SC.windM1=nan(size(SC.dn));

SC.PDO=nan(size(SC.dn));
SC.NPGO=nan(size(SC.dn));

%% step 1) import hourly river discharge data 2003-2018
% Discharge (cubic feet per second)
% Date,  dn=datenum(TimeUTC,'yyyy-mm-dd HH:MM');
filename = [filepath 'Data/PajaroRiver_2003-2018.txt'];
delimiter = '\t';
startRow = 33;
formatSpec = '%*q%*q%q%*q%q%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

% Converts text in the input cell array to numbers. Replaced non-numeric text with NaN.
rawData = dataArray{2};
for row=1:size(rawData, 1)
    % Create a regular expression to detect and remove non-numeric prefixes and
    % suffixes.
    regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
    try
        result = regexp(rawData(row), regexstr, 'names');
        numbers = result.numbers;
        
        % Detected commas in non-thousand locations.
        invalidThousandsSeparator = false;
        if numbers.contains(',')
            thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
            if isempty(regexp(numbers, thousandsRegExp, 'once'))
                numbers = NaN;
                invalidThousandsSeparator = true;
            end
        end
        % Convert numeric text to numbers.
        if ~invalidThousandsSeparator
            numbers = textscan(char(strrep(numbers, ',', '')), '%f');
            numericData(row, 2) = numbers{1};
            raw{row, 2} = numbers{1};
        end
    catch
        raw{row, 2} = rawData{row};
    end
end

% Convert the contents of columns with dates to MATLAB datetimes using the specified date format.
try
    dates{1} = datetime(dataArray{1}, 'Format', 'MM/dd/yy HH:mm', 'InputFormat', 'MM/dd/yy HH:mm');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{1} = cellfun(@(x) x(2:end-1), dataArray{1}, 'UniformOutput', false);
        dates{1} = datetime(dataArray{1}, 'Format', 'MM/dd/yy HH:mm', 'InputFormat', 'MM/dd/yy HH:mm');
    catch
        dates{1} = repmat(datetime([NaN NaN NaN]), size(dataArray{1}));
    end
end

dates = dates(:,1);
rawNumericColumns = raw(:, 2); % Split data into numeric and string columns.
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
dt = dates{:, 1};
Rii = cell2mat(rawNumericColumns(:, 1));
dn=datenum(dt);

Ri=pl33tn(Rii); % low pass filter
[dn, R] = filltimeseriesgaps( datenum(dt), Ri ); % fill time gaps with NaNs

%interpolate data unless gaps >4 
index    = isnan(R);
R(index) = interp1(find(~index), R(~index), find(index), 'linear');
[b, n]     = RunLength(index);
longRun    = RunLength(b & (n > 4), n);
R(longRun) = NaN;

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.river(i)=R(j);       
        else
        end
    end
end

figure; plot(SC.dn,SC.river,'-b')
datetick('x','yyyy');

clearvars filename delimiter startRow formatSpec fileID dataArray ans ...
    raw col numericData rawData row regexstr result numbers ...
    invalidThousandsSeparator thousandsRegExp dates blankDates ...
    anyBlankDates invalidDates anyInvalidDates rawNumericColumns...
    i j dn dt Rii Ri R index longRun n b;

%% step 2) import weekly Temperature from SCOOS spreadsheet 2005-2018
[~, ~, raw] = xlsread('/Users/afischer/Documents/UCSC_research/SCW_Dino_Project/Data/SCW_temp_2005-2018.xlsx','Sheet1');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
data = reshape([raw{:}],size(raw));
dn = data(:,1) + 693960; %convert excel to matlab format
T = data(:,2);
T((T==-999))=NaN; %convert -999 to NaNs

[~,~,ib]=intersect(dn,[SC.dn]); %find where matches dn in dataset
for i=1:length(ib)    
    SC.T(ib(i))=T(i);
end

 idx=~isnan(SC.T);
 figure; plot(SC.dn(idx),SC.T(idx)); datetick('x','yyyy');

clearvars data raw R dn ib T i idx;

%% step 3) import weekly Chl, nutrients, PN and Alex from DOD 2005-2015

filename = [filepath 'Data/SCW_DODserver_2005-2015.txt'];
delimiter = ',';
startRow = 18;
formatSpec = '%{yyyy-MM-dd HH:mm:ss.S}D%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');

textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false);
fclose(fileID);

dt = dataArray{:, 1};
    dn=datenum(datestr(dt,'yyyy-mm-dd'));
CHL = dataArray{:, 2};
    CHL((CHL==-999))=NaN; %convert -999 to NaNs
urea = dataArray{:, 3};
ammonium = dataArray{:, 4};
nitrate = dataArray{:, 5};
phosphate = dataArray{:, 6};
silicate = dataArray{:, 7};
Pn = dataArray{:, 8};
Paust = dataArray{:, 9};
Pmult = dataArray{:, 10};
Alex = dataArray{:, 11};

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.CHL(i)=CHL(j);
            SC.urea(i)=urea(j);
            SC.ammonium(i)=ammonium(j);
            SC.nitrate(i)=nitrate(j);
            SC.phosphate(i)=phosphate(j);
            SC.silicate(i)=silicate(j);
            SC.Pn(i)=Pn(j);
            SC.Paust(i)=Paust(j);
            SC.Pmult(i)=Pmult(j);
            SC.Alex(i)=Alex(j);
        else
        end
    end
end
    
 idx=~isnan(SC.CHL);
 figure; plot(SC.dn(idx),SC.CHL(idx)); datetick('x','yyyy');

clearvars Alex ammonium CHL dataArray delimiter dn dt fileID filename...
    formatSpec i j nitrate Paust Paustralis phosphate Pmult Pmultiseries...
    Pn silicate startRow test urea;

%% step 4) Import SCW parameters (Temp, Chl, Alex, DA) 2000-2009

[~,~,raw]=xlsread('/Users/afischer/Documents/UCSC_research/SCW_Dino_Project/Data/SCW_Jester_2000-2009.xlsx','Sheet1');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
data = reshape([raw{:}],size(raw));

dn = data(:,1) +693960;

T = data(:,3);
SSS = data(:,2);
Paust = data(:,4);
Pmult = data(:,5);
Pn = data(:,6);
Alex = data(:,7);
DA = data(:,8);
STX = data(:,9);
CHL = data(:,10);
silicate = data(:,11);
nitrate = data(:,12);
phosphate = data(:,13);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.SSS(i)=SSS(j);
            SC.T(i)=T(j);            
            SC.Paust(i)=Paust(j);
            SC.Pmult(i)=Pmult(j);            
            SC.Pn(i)=Pn(j);            
            SC.Alex(i)=Alex(j);            
            SC.DA(i)=DA(j);            
            SC.STX(i)=STX(j);            
            SC.CHL(i)=CHL(j);            
            SC.silicate(i)=silicate(j);            
            SC.nitrate(i)=nitrate(j);            
            SC.phosphate(i)=phosphate(j);            
        else
        end
    end
end

idx=~isnan(SC.T);
figure; plot(SC.dn(idx),SC.T(idx)); datetick('x','yyyy');

clearvars data raw stringVectors R dn nitrate Paust phosphate Pmult Pn silicate STX T i j;

%% step 5) import weekly Chl, T, nutrients, PN and Alex from SCOOS Website 2008-2018
filename = [filepath 'Data/Harmful Algal Blooms_2011-2018.csv'];
delimiter = ',';
startRow = 9;
formatSpec = '%q%q%q%*q%*q%*q%*q%*q%*q%q%q%q%q%q%q%q%q%*q%q%*q%*q%*q%*q%q%*q%*q%q%q%*q%q%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType',...
    'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

clearvars filename delimiter startRow formatSpec fileID dataArray ans col...
    numericData rawData row regexstr result numbers invalidThousandsSeparator...
    thousandsRegExp R;

year = cell2mat(raw(:, 1));
month = cell2mat(raw(:, 2));
day = cell2mat(raw(:, 3));

dn=datenum(datetime(year,month,day));
Alex = cell2mat(raw(:, 4));
ammonium = cell2mat(raw(:, 5));
CHL = cell2mat(raw(:, 6));
dinophysis = cell2mat(raw(:, 10));
DA = cell2mat(raw(:, 11));
nitrate = cell2mat(raw(:, 12));
phosphate = cell2mat(raw(:, 13));
Pn = cell2mat(raw(:, 14));
silicate = cell2mat(raw(:, 15));
T = cell2mat(raw(:, 16));

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.Alex(i)=Alex(j);
            SC.ammonium(i)=ammonium(j);
            SC.CHL(i)=CHL(j);
            SC.dinophysis(i)=dinophysis(j);
            SC.DA(i)=DA(j);
            SC.nitrate(i)=nitrate(j);            
            SC.phosphate(i)=phosphate(j);
            SC.Pn(i)=Pn(j);            
            SC.silicate(i)=silicate(j);
            SC.T(i)=T(j);            
        else
        end
    end
end

 idx=~isnan(SC.T);
 figure; plot(SC.dn(idx),SC.T(idx)); datetick('x','yyyy');


clearvars T Alex CHL DA data dn i j nitrate phosphate ammonium day dinophysis month year Pn R raw silicate idx;

%% step 6) import RAI fx Dinoflagellated and Diatoms

load([filepath 'Data/RAI'],'FX','DN');
Dino=FX(:,end-1);
Diat=FX(:,end);

for i=1:length(SC.dn)
    for j=1:length(DN)
        if DN(j) == SC.dn(i)
            SC.fxDino(i)=Dino(j);
            SC.fxDiat(i)=Diat(j);
        else
        end
    end
end

idx=~isnan(SC.fxDino);
figure; plot(SC.dn(idx),SC.fxDino(idx)); datetick('x','yyyy');

clearvars DN Diat Dino i j;

%% step 8) Import Temp, Chl, Turbidity SCW sensor data from ERDDAP CENCOOS portal

filename = [filepath 'Data/SCW_weatherstation_cencoos/sensors_SCW_09-18.csv'];
delimiter = ',';
startRow = 3;
formatSpec = '%s%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,...
    'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
time = dataArray{:, 1};
mass_concentration_of_chlorophyll_in_sea_water = dataArray{:, 2};
sea_water_temperature = dataArray{:, 3};
turbidity = dataArray{:, 4};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%%%% convert to useable format
%deal with weird date format, flip vector direction, convert from F to Celcius
dn = flipud(datenum(datetime(time,'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z')));

[sst,dnn]=plfilt(sea_water_temperature,dn);

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
dn = datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.Tsensor(i)=T(j);
            SC.CHLsensor(i)=CHL(j);
            SC.TURsensor(i)=TUR(j);            
        else
        end
    end
end

idx=~isnan(SC.T);
Ti=interp1([SC.dn(idx)],[SC.T(idx)],[SC.dn]);

for i=1:length(SC.Tsensor)
   if  isnan(SC.Tsensor(i))
        SC.Tsensor(i) = Ti(i);
    else
    end
end
SC.Tsensor=smooth(SC.Tsensor,8);
SC.Tsensor(1:5)=NaN;

 figure; plot(SC.dn(idx),SC.T(idx),SC.dn,SC.Tsensor); datetick('x','yyyy');

clearvars CHL d dn DN i mass_concentration_of_chlorophyll_in_sea_water sea_water_temperature T T_F time TUR turbidity j;

%% step 9) Import M1 sensor: MLD, dTdz, Tmax, and Zmax
load([filepath 'Data/M1_TS'],'M1R');

M1=M1R;
dn = [M1.dn]';

Zmax=NaN*(ones(size(dn)));
maxdTdz=NaN*(ones(size(dn)));
mld5=NaN*(ones(size(dn)));
for i=1:length(M1)
    Zmax(i)=M1(i).Zmax;
    maxdTdz(i)=M1(i).maxdTdz;
    mld5(i)=M1(i).mld5;    

end

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.Zmax(i)=Zmax(j);      
            SC.maxdTdz(i)=maxdTdz(j);   
            SC.mld5(i)=mld5(j);                
            
        else
        end
    end
end

figure; plot(SC.dn,SC.Zmax,'*b')
datetick('x','yyyy');

clearvars data raw R S dn i j M1;

%% step 10) Import ROMS nearest SCW (2010-2018)
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS');

dn = [ROMS.dn]';

SST=NaN*(ones(size(dn)));
SSS=NaN*(ones(size(dn)));
Zmax=NaN*(ones(size(dn)));
maxdTdz=NaN*(ones(size(dn)));
mld5=NaN*(ones(size(dn)));
for i=1:length(ROMS)
    SST(i)=ROMS(i).Ti(1);
    SSS(i)=ROMS(i).Si(1);    
    Zmax(i)=ROMS(i).Zmax;
    maxdTdz(i)=ROMS(i).maxdTdz;
    mld5(i)=ROMS(i).mld5;    

end

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.SST(i)=SST(j);      
            SC.SSS(i)=SSS(j);                  
            SC.ZmaxS(i)=Zmax(j);      
            SC.maxdTdzS(i)=maxdTdz(j);   
            SC.mld5S(i)=mld5(j);                
            
        else
        end
    end
end

idx=~isnan(SC.mld5S);
figure; plot(SC.dn(idx),SC.mld5S(idx),'-k')
datetick('x','yyyy');

clearvars data raw R S dn i j M1;

%% 11) import Bakun Upwelling index
delimiter = ' ';
startRow = 7;
formatSpec = '%{yyyyMMdd}D%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen([filepath 'Data/UpwellingIndex_daily_36N.txt'],'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,...
    'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,...
    'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

dt = dataArray{:, 1};
upwell = dataArray{:, 2};
upwell((upwell==-9999))=NaN; %convert -9999 to NaNs


d = dateshift(dt, 'start', 'day');
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.upwell(i)=upwell(j);       
        else
        end
    end
end

figure; plot(SC.dn,SC.upwell,'-b')
datetick('x','yyyy');

% Clear temporary variables
clearvars filename delimiter startRow formatSpec upwell dn fileID dataArray ans d dt;

%% 12) Import wind
load([filepath 'Data/Wind_MB'],'w');
[~,spd,~] = ts_aggregation(w.scw.dn,w.scw.spd,1,'day',@mean);
[~,dir,~] = ts_aggregation(w.scw.dn,w.scw.dir,1,'day',@mean);
[~,U,~] = ts_aggregation(w.scw.dn,w.scw.u,1,'day',@mean);
[dn,V,~] = ts_aggregation(w.scw.dn,w.scw.v,1,'day',@mean);
d = dateshift(datetime(datestr(dn)),'start','day'); %remove the extra minutes. just keep the day
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.wind(i)=spd(j);       
            SC.winddir(i)=dir(j);    
            SC.windU(i)=U(j);       
            SC.windV(i)=V(j);       
        else
        end
    end
end

[dn,spd,~] = ts_aggregation(w.s42.dn,w.s42.spd,1,'day',@mean);
d = dateshift(datetime(datestr(dn)),'start','day'); %remove the extra minutes. just keep the day
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.wind42(i)=spd(j);       
        else
        end
    end
end

[dn,spd,~] = ts_aggregation(w.M1.dn,w.M1.spd,1,'day',@mean);
d = dateshift(datetime(datestr(dn)),'start','day'); %remove the extra minutes. just keep the day
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.windM1(i)=spd(j);       
        else
        end
    end
end

clearvars d dn DN i j spd SPD w;

%% 13) import PDO
filename = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/PDO.txt';
startRow = 23;
endRow = 141;
formatSpec = '%4s%9s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%s%[^\n\r]';
fileID = fopen(filename,'r');
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11,12,13]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

PDOraw = cell2mat(raw);
clearvars filename startRow endRow formatSpec fileID dataArray ans raw...
    col numericData rawData row regexstr result numbers ...
    invalidThousandsSeparator thousandsRegExp R;

PDOraw=PDOraw';
PDOraw=PDOraw(1:end,1:116); %only take through 2018
yr=PDOraw(1,:);
PDO=PDOraw(2:end,:);
PDO=PDO(:);
dn=bsxfun(@(Year,Month) datenum(Year,Month,15),yr',(1:12));
dn=sort(dn(:));

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.PDO(i)=PDO(j);       
        else
        end
    end
end

figure; plot(SC.dn,SC.PDO,'ok')
datetick('x','yyyy');

clearvars i j PDO yr;

%% 14) import NPGO
filename = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/NPGO.txt';
delimiter = {'  '};
startRow = 27;
formatSpec = '%*s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

yr = cell2mat(raw(:, 1));
month = cell2mat(raw(:, 2));
NPGO = cell2mat(raw(:, 3));

dn=datenum(yr,month,15);

figure; plot(dn,NPGO,'-b')
datetick('x','yyyy');

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.NPGO(i)=NPGO(j);       
        else
        end
    end
end

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans ...
    raw col numericData rawData row regexstr result numbers ...
    invalidThousandsSeparator thousandsRegExp;

%%
save([filepath 'Data/SCW_master'],'SC');