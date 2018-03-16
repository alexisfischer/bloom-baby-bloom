function[phys]=loadSFBparameters_v2(filename)

%filename = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\sfb_raw_2.csv';
delimiter = ',';
startRow = 3;

% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r','n','UTF-8');
% Skip the BOM (Byte Order Mark).
fseek(fileID, 3, 'bof');

% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[3,4,5,6,7,8,9,10,11,12,13,14,15]
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
rawNumericColumns = raw(:, [3,4,5,6,7,8,9,10,11,12,13,14,15]);
rawStringColumns = string(raw(:, 2));


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
Date = dates{:, 1};
IFCB = rawStringColumns(:, 1);
StationNumber = cell2mat(rawNumericColumns(:, 1));
Distancefrom36 = cell2mat(rawNumericColumns(:, 2));
CalculatedChlorophyll = cell2mat(rawNumericColumns(:, 3));
CalculatedOxygen = cell2mat(rawNumericColumns(:, 4));
OpticalBackscatter = cell2mat(rawNumericColumns(:, 5));
CalculatedSPM = cell2mat(rawNumericColumns(:, 6));
Salinity = cell2mat(rawNumericColumns(:, 7));
Temperature = cell2mat(rawNumericColumns(:, 8));
Nitrite = cell2mat(rawNumericColumns(:, 9));
NitrateNitrite = cell2mat(rawNumericColumns(:, 10));
Ammonium = cell2mat(rawNumericColumns(:, 11));
Phosphate = cell2mat(rawNumericColumns(:, 12));
Silicate = cell2mat(rawNumericColumns(:, 13));

Date=datenum(Date);

[Latitude,Longitude] = match_st_lat_lon(StationNumber);


%%
for i=1:length(Date)
    phys(i).dn=Date(i);
    phys(i).filename=IFCB(i);
    phys(i).st=StationNumber(i);
    phys(i).lat=Latitude(i);
    phys(i).lon=Longitude(i);
    phys(i).d36=Distancefrom36(i);    
    phys(i).sal=Salinity(i);    
    phys(i).chl=CalculatedChlorophyll(i);
    phys(i).temp=Temperature(i);
    phys(i).obs=OpticalBackscatter(i);
    phys(i).spm=CalculatedSPM(i);
    phys(i).ni=Nitrite(i);
    phys(i).nina=NitrateNitrite(i);
    phys(i).amm=Ammonium(i);
    phys(i).phos=Phosphate(i);
    phys(i).sil=Silicate(i);
end


%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp R;

save('C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\parameters','phys');

end