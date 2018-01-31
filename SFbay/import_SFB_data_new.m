function[sfb,s]=import_SFB_data_new(filename)

%filename = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Data\sfb_raw.csv';

delimiter = ',';
startRow = 3;
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r'); %% Open the text file.

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
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

% Convert the contents of columns with dates to MATLAB datetimes using the
% specified date format.
try
    dates{1} = datetime(dataArray{1}, 'Format', 'MM/dd/yy', 'InputFormat', 'MM/dd/yy');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{1} = cellfun(@(x) x(2:end-1), dataArray{1}, 'UniformOutput', false);
        dates{1} = datetime(dataArray{1}, 'Format', 'MM/dd/yy', 'InputFormat', 'MM/dd/yy');
    catch
        dates{1} = repmat(datetime([NaN NaN NaN]), size(dataArray{1}));
    end
end

dates = dates(:,1);

%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]);
rawStringColumns = string(raw(:, 18));


%% Replace blank cells with NaN
R = cellfun(@(x) isempty(x) || (ischar(x) && all(x==' ')),rawNumericColumns);
rawNumericColumns(R) = {NaN}; % Replace blank cells

%% Allocate imported array to column variable names
Date = dates{:, 1};
StationNumber = cell2mat(rawNumericColumns(:, 1));
Lat = cell2mat(rawNumericColumns(:, 2));
Long = cell2mat(rawNumericColumns(:, 3));
Depth = cell2mat(rawNumericColumns(:, 4));
CalculatedChlorophyll = cell2mat(rawNumericColumns(:, 5));
CalculatedOxygen = cell2mat(rawNumericColumns(:, 6));
Salinity = cell2mat(rawNumericColumns(:, 7));
Temperature = cell2mat(rawNumericColumns(:, 8));
OpticalBackscatter = cell2mat(rawNumericColumns(:, 9));
CalculatedSPM = cell2mat(rawNumericColumns(:, 10));
MeasuredExtinctionCoefficient = cell2mat(rawNumericColumns(:, 11));
Nitrite = cell2mat(rawNumericColumns(:, 12));
NitrateNitrite = cell2mat(rawNumericColumns(:, 13));
Ammonium = cell2mat(rawNumericColumns(:, 14));
Phosphate = cell2mat(rawNumericColumns(:, 15));
Silicate = cell2mat(rawNumericColumns(:, 16));
IFCB = rawStringColumns(:, 1);

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).
Date=datenum(Date);

sfb = [Date StationNumber Lat Long CalculatedChlorophyll CalculatedOxygen Salinity...
    Temperature OpticalBackscatter CalculatedSPM MeasuredExtinctionCoefficient...
    Nitrite NitrateNitrite Ammonium Phosphate Silicate];

%% Sort by date
%Find indices to elements in first column of sfb that satisfy the equality
%Use the logical indices to index into sfb to return required sub-matrices

sfb = sortrows(sfb,1); %sort by dates

s(1).a = sfb((sfb(:,1) == datenum('31-Jul-2017')),:);
s(2).a = sfb((sfb(:,1) == datenum('22-Aug-2017')),:);
s(3).a = sfb((sfb(:,1) == datenum('30-Aug-2017')),:);
s(4).a = sfb((sfb(:,1) == datenum('19-Sep-2017')),:);
s(5).a = sfb((sfb(:,1) == datenum('28-Sep-2017')),:);
s(6).a = sfb((sfb(:,1) == datenum('18-Oct-2017')),:);
s(7).a = sfb((sfb(:,1) == datenum('27-Oct-2017')),:);
s(8).a = sfb((sfb(:,1) == datenum('14-Nov-2017')),:);
%s(9).a = sfb((sfb(:,1) == datenum('06-Dec-2017')),:);

% organize station data into structures
for i=1:length(s)
    s(i).dn=s(i).a(:,1); % date  
    s(i).st=s(i).a(:,2); % station #
    s(i).lat=s(i).a(:,3); % lat
    s(i).long=s(i).a(:,4); % long
    s(i).chl=s(i).a(:,5); % chl
    s(i).oxg=s(i).a(:,6); % oxygen
    s(i).sal=s(i).a(:,7); % salinity
    s(i).temp=s(i).a(:,8); % temp
    s(i).obs=s(i).a(:,9); % optical backscatter sensor
    s(i).spm=s(i).a(:,10); % suspended particulate material
    s(i).ext=s(i).a(:,11); % measured light extinction coefficient
    s(i).ni=s(i).a(:,12); %nitrite
    s(i).nina=s(i).a(:,13); %nitrite +nitrate
    s(i).amm=s(i).a(:,14); % ammonium
    s(i).phos=s(i).a(:,15); % phosphate
    s(i).sil=s(i).a(:,16);  % silicate
end

s=rmfield(s,'a');

%% make cell array structure w IFCB

sfb = struct('dn',Date,'st',StationNumber,'lat',Lat,'long',Long,...
    'chl',CalculatedChlorophyll,'oxg',CalculatedOxygen,'sal',Salinity,...
    'temp',Temperature,'obs',OpticalBackscatter,'spm',CalculatedSPM,...
    'ext',MeasuredExtinctionCoefficient,'nit',Nitrite,'nina',NitrateNitrite,...
    'amm',Ammonium,'phos',Phosphate,'sil',Silicate,'ifcb',IFCB);

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp R;

save('C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Data\sfb','sfb','s');

end