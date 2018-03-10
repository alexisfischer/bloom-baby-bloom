function [st,filename] = import_IFCB_stations(filename)

delimiter = ',';
startRow = 2;
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(filename,'r','n','UTF-8');
fseek(fileID, 3, 'bof'); % Skip the BOM (Byte Order Mark).
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

% Converts text in the input cell array to numbers. Replaced non-numeric text with NaN.
rawData = dataArray{1};
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
            numericData(row, 1) = numbers{1};
            raw{row, 1} = numbers{1};
        end
    catch
        raw{row, 1} = rawData{row};
    end
end

% Split data into numeric and string columns.
rawNumericColumns = raw(:, 1);
rawStringColumns = string(raw(:, 2));

% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

% Allocate imported array to column variable names
st = cell2mat(rawNumericColumns(:, 1));
filename = rawStringColumns(:, 1);

%% Clear temporary variables
clearvars delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp rawNumericColumns rawStringColumns R;
end
