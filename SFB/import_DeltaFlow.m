%% import Net Delta Outflow

filepath = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SFB/';
filename = '/Users/afischer/Documents/UCSC_research/SanFranciscoBay/Dayflow1955-2018.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%s%*s%*s%*s%*s%s%[^\n\r]';
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
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
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
    dates{1} = datetime(dataArray{1}, 'Format', 'dd-MMM-yyyy', 'InputFormat', 'dd-MMM-yyyy');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{1} = cellfun(@(x) x(2:end-1), dataArray{1}, 'UniformOutput', false);
        dates{1} = datetime(dataArray{1}, 'Format', 'dd-MMM-yyyy', 'InputFormat', 'dd-MMM-yyyy');
    catch
        dates{1} = repmat(datetime([NaN NaN NaN]), size(dataArray{1}));
    end
end

dates = dates(:,1);
rawNumericColumns = raw(:, [2,3]);
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
DN = datenum(dates{:, 1});
OUT = cell2mat(rawNumericColumns(:, 1));
X2 = cell2mat(rawNumericColumns(:, 2));

clearvars filename delimiter startRow formatSpec fileID dataArray ans ...
    raw col numericData rawData row regexstr result numbers ...
    invalidThousandsSeparator thousandsRegExp dates blankDates ...
    anyBlankDates invalidDates anyInvalidDates rawNumericColumns R;

%% select only 2013-present
id=find(DN>=datenum('01-Jan-2013'),1);
OUT=OUT(id:end);
X2=X2(id:end);
DN=DN(id:end);

save([filepath 'Data/NetDeltaFlow'],'DN','X2','OUT');
