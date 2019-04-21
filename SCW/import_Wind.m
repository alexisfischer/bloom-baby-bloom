%% import raw Wind data
% 46042
% SCW
% M1

filepath='/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/';
%% 46042 
%%%%(step 1) Import annual data 2002-2018
yr=(2002:2018)';
for i=1:length(yr)
    filename = [filepath '46042/46042_' num2str(yr(i)) '.txt'];
    
    if yr(i) <=2006
        startRow = 2;
    else
        startRow = 3;
    end

    formatSpec = '%4f%3f%3f%3f%3f%7f%7f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    YYYY = dataArray{:, 1};
    MM = dataArray{:, 2};
    DD = dataArray{:, 3};
    hh = dataArray{:, 4};
    mm = dataArray{:, 5};
    dir = dataArray{:, 6};
    spd = dataArray{:, 7};

    dn=datenum(YYYY,MM,DD,hh,mm,zeros(size(YYYY)));

    for j=1:length(dn)
        if dir(j) == 999
            dir(j) = NaN;        
        end
        if spd(j) == 999
            spd(j) = NaN;        
        end    
    end

    [u,v] = UVfromDM(dir,spd);

    W(i).yr=YYYY(end);
    W(i).dn=dn;
    W(i).dir=dir;
    W(i).spd=spd;
    W(i).u=u;
    W(i).v=v;

    clearvars ans dataArray DD dir DIR dn DN fileID filename formatSpec hh j mm MM spd SPD startRow u v YY;
end

%%%%(step 2) Combine data into single column
w.s42.dn=W(1).dn;
w.s42.dir=W(1).dir;
w.s42.spd=W(1).spd;
w.s42.u=W(1).u;
w.s42.v=W(1).v;

for i=2:length(W)    
    w.s42.dn=[w.s42.dn;W(i).dn];
    w.s42.dir=[w.s42.dir;W(i).dir];
    w.s42.spd=[w.s42.spd;W(i).spd];
    w.s42.u=[w.s42.u;W(i).u];
    w.s42.v=[w.s42.v;W(i).v];
end

clearvars W i

%% SCW 

%%%%(step 1) Import annual data 2012-2018
yr=[2012:2018]';

for i=1:length(yr)
    fileToRead = [filepath 'SCW_weatherstation_cencoos/RawData_' num2str(yr(i)) '.mat'];
    Data = load('-mat', fileToRead);
    vars = fieldnames(Data);
    for j = 1:length(vars)
        assignin('base', vars{j}, Data.(vars{j}));
    end
    
    spd=WINDSPEED*0.44704; %convert from mph to m/s
    dir=WINDDIR;
    dn=TIME;
    [u,v] = UVfromDM(dir,spd);

    W(i).dn=dn;
    W(i).dir=dir;
    W(i).spd=spd;
    W(i).u=u;
    W(i).v=v;

    clearvars j Data fileToRead AIRTEMP BAROMETER DEWPOINT HUMIDITY PAR RAINFALL TIME WINDDIR WINDSPEED dn dir spd u v;
end

%%%%(step 2) Combine data into single column
w.scw.dn=W(1).dn;
w.scw.dir=W(1).dir;
w.scw.spd=W(1).spd;
w.scw.u=W(1).u;
w.scw.v=W(1).v;

for i=2:length(W)    
    w.scw.dn=[w.scw.dn;W(i).dn];
    w.scw.dir=[w.scw.dir;W(i).dir];
    w.scw.spd=[w.scw.spd;W(i).spd];
    w.scw.u=[w.scw.u;W(i).u];
    w.scw.v=[w.scw.v;W(i).v];
end

clearvars W i

%%%%(step 3) Import monthly data April-June 2018
filename = [filepath 'SCW_weatherstation_cencoos/KCSANTA_132_180401-180612.txt'];
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%s%*s%*s%*s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[2,3]
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
rawNumericColumns = raw(:, [2,3]);
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
dn = dates{:, 1}; dn=datenum(dn);

spd = cell2mat(rawNumericColumns(:, 1));
dir = cell2mat(rawNumericColumns(:, 2));

clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp dates blankDates anyBlankDates invalidDates anyInvalidDates rawNumericColumns R;

[u,v] = UVfromDM(dir,spd);

w.scw.dn=[w.scw.dn;dn];
w.scw.dir=[w.scw.dir;dir];
w.scw.spd=[w.scw.spd;spd];
w.scw.u=[w.scw.u;u];
w.scw.v=[w.scw.v;v];

clearvars dir DIR dn DN spd SPD u v vars yr;

%%
%%%%(step 4) Import monthly data Mar-Aug 2018
filename = [filepath 'SCW_weatherstation_cencoos/windSC_Mar-Aug2018.txt'];
delimiter = ',';
startRow = 2;
formatSpec = '%*s%{yyyy-MM-dd HH:mm:ss}D%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%*s%*s%*s%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

dates = dataArray{:, 1};
spd = dataArray{:, 2};
dir = dataArray{:, 3};
dn=datenum(dates);

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

[u,v] = UVfromDM(dir,spd);

idx = find(dn>=w.scw.dn(end),1); %id for where the points overlap
w.scw.dn = [[w.scw.dn]; dn(idx:end)];   
w.scw.dir = [[w.scw.dir]; dir(idx:end)];   
w.scw.spd = [[w.scw.spd]; spd(idx:end)];   
w.scw.u = [[w.scw.u]; u(idx:end)];   
w.scw.v = [[w.scw.v]; v(idx:end)];   

clearvars dir DIR dn dates DN spd SPD u v vars yr idx;

%%

%%%%(step 5) Import monthly data Aug2018-Feb 2019
filename = [filepath 'SCW_weatherstation_cencoos/windSC_Aug2018_Feb2019.txt'];
delimiter = ',';
startRow = 2;
formatSpec = '%*s%{yyyy-MM-dd HH:mm:ss}D%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%*s%*s%*s%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

dates = dataArray{:, 1};
spd = dataArray{:, 2};
dir = dataArray{:, 3};
dn=datenum(dates);

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

[u,v] = UVfromDM(dir,spd);

idx = find(dn>=w.scw.dn(end),1); %id for where the points overlap
w.scw.dn = [[w.scw.dn]; dn(idx:end)];   
w.scw.dir = [[w.scw.dir]; dir(idx:end)];   
w.scw.spd = [[w.scw.spd]; spd(idx:end)];   
w.scw.u = [[w.scw.u]; u(idx:end)];   
w.scw.v = [[w.scw.v]; v(idx:end)];   

clearvars dir DIR dn dates DN spd SPD u v vars yr idx;


%% M1

%%%%(step 1) Import annual data 2012-2017
yr=[2012:2017]';

for i=1:length(yr)
    filename = [filepath 'M1-46092/M1_' num2str(yr(i)) '.txt'];
    startRow = 3;
    formatSpec = '%4f%3f%3f%3f%3f%4f%5f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);

    YY = dataArray{:, 1};
    MM = dataArray{:, 2};
    DD = dataArray{:, 3};
    hh = dataArray{:, 4};
    mm = dataArray{:, 5};
    dir = dataArray{:, 6};
    spd = dataArray{:, 7};

    dn=datenum(YY,MM,DD,hh,mm,zeros(size(YY)));

    for j=1:length(dn)
        if dir(j) == 999
            dir(j) = NaN;        
        end
        if spd(j) == 999
            spd(j) = NaN;        
        end    
    end

    [u,v] = UVfromDM(dir,spd);

    W(i).yr=YY(end);
    W(i).dn=dn;
    W(i).dir=dir;
    W(i).spd=spd;
    W(i).u=u;
    W(i).v=v;

    clearvars ans dataArray DD dir dn fileID filename formatSpec hh j mm MM spd startRow u v YY;
end

%%%%(step 2) Import monthly data 2018
mo=[1:6]';

for i=1:length(mo)
    filename = [filepath 'M1-46092/M1_' num2str(mo(i,:)) '_2018.txt'];
    startRow = 3;
    formatSpec = '%4f%3f%3f%3f%3f%4f%5f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);

    YY = dataArray{:, 1};
    MM = dataArray{:, 2};
    DD = dataArray{:, 3};
    hh = dataArray{:, 4};
    mm = dataArray{:, 5};
    dir = dataArray{:, 6};
    spd = dataArray{:, 7};

    dn=datenum(YY,MM,DD,hh,mm,zeros(size(YY)));

    for j=1:length(dn)
        if dir(j) == 999
            dir(j) = NaN;        
        end
        if spd(j) == 999
            spd(j) = NaN;        
        end    
    end
    
    [u,v] = UVfromDM(dir,spd);

    W(7).yr=YY(end);
    W(7).dn=[W(7).dn;dn];
    W(7).dir=[W(7).dir;dir];
    W(7).spd=[W(7).spd;spd];
    W(7).u=[W(7).u;u];
    W(7).v=[W(7).v;v];

    clearvars ans dataArray DD dir DIR dn DN fileID filename formatSpec hh j mm MM spd SPD startRow u v YY;
end

%%%%(step 3) Combine data into single column

w.M1.dn=W(1).dn;
w.M1.dir=W(1).dir;
w.M1.spd=W(1).spd;
w.M1.u=W(1).u;
w.M1.v=W(1).v;

for i=2:length(W)    
    w.M1.dn=[w.M1.dn;W(i).dn];
    w.M1.dir=[w.M1.dir;W(i).dir];
    w.M1.spd=[w.M1.spd;W(i).spd];
    w.M1.u=[w.M1.u;W(i).u];
    w.M1.v=[w.M1.v;W(i).v];
end

clearvars W i mo yr


%% Oneill Sea Odyssey
% roof of OSO office next to the Santa Cruz Yacht Harbor

%%%%(step 1) Import annual data 2012-2017
filename="/Users/afischer/Documents/UCSC_research/SCW_Dino_Project/Data/OneillOdyssey-Hourly-Wind-Data.xlsx";

yr=(2007:2018)';

for i=1:length(yr)
    opts = spreadsheetImportOptions("NumVariables", 7);
    opts.Sheet = ['OSO_' num2str(yr(i)) ''];
    opts.DataRange = "A2:G8761";
    opts.VariableNames = ["Year", "Day", "Time", "AvgWS", "AvgWDir", "MaxGst", "DirofGst"];
    opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
    T = readtable(filename, opts, "UseExcel", false);
    
    DDD=T.Day; 
    H=T.Time;    
    dir=T.AvgWDir;
    knots=T.AvgWS; 
    idx=isnan(DDD); DDD(idx)=[]; H(idx)=[]; dir(idx)=[]; knots(idx)=[]; %remove NaNs
    
    Date=datenum(['01-Jan-' num2str(yr(i)) ''])+DDD-1;
    dt=datetime(datestr(Date));
    [Y,M,D] = ymd(dt);
    
    %convert horrible hour format to something that works for datetime
    H(H==100)=1; H(H==200)=2; H(H==300)=3; H(H==400)=4; H(H==500)=5; H(H==600)=6;
    H(H==700)=7; H(H==800)=8; H(H==900)=9; H(H==1000)=10; H(H==1100)=11; H(H==1200)=12;
    H(H==1300)=13; H(H==1400)=14; H(H==1500)=15; H(H==1600)=16; H(H==1700)=17; H(H==1800)=18;
    H(H==1900)=19; H(H==2000)=20; H(H==2100)=21; H(H==2200)=22; H(H==2300)=23; H(H==2400)=24;
    
    MI=zeros(size(H)); S=MI;
    dt=datetime(Y,M,D,H,MI,S);
    
    spd=knots./0.514444; %convert from knots to m/s
    [u,v] = UVfromDM(dir,spd);
    
    W(i).yr=yr(i);
    W(i).dn=datenum(dt);
    W(i).dir=dir;
    W(i).spd=spd;
    W(i).u=u;
    W(i).v=v;    

    clearvars opts T  u v dir spd MI dt S H Y M D dt Date DDD H knots idx
    
end

%%
%%%%(step 2) Combine data into single column
w.oso.dn=W(1).dn;
w.oso.dir=W(1).dir;
w.oso.spd=W(1).spd;
w.oso.u=W(1).u;
w.oso.v=W(1).v;

for i=2:length(W)    
    w.oso.dn=[w.oso.dn;W(i).dn];
    w.oso.dir=[w.oso.dir;W(i).dir];
    w.oso.spd=[w.oso.spd;W(i).spd];
    w.oso.u=[w.oso.u;W(i).u];
    w.oso.v=[w.oso.v;W(i).v];
end

%%
save([filepath 'Data/Wind_MB'],'w');
