
% 1) import MBARI M1 CTD Temperature data from 2000 to 2018

filepath='~/Documents/MATLAB/bloom-baby-bloom/SCW/'; %change for whatever year

delimiter = ',';
startRow = 2;
formatSpec = '%*q%q%*q%*q%q%q%[^\n\r]'; % Read columns of data as text:
fileID = fopen([filepath 'Data/M1-46092/PCTD_M1_Tmp_TS.csv'],'r'); % Open the text file.

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,...
    'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError',...
    false, 'EndOfLine', '\r\n'); % Read columns of data according to the format.

fclose(fileID); % Close the text file.

% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
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

% Convert the contents of columns with dates to MATLAB datetimes using the
% specified date format.
try
    dates{1} = datetime(dataArray{1}, 'Format', 'yyyy-MM-dd HH:mm:ss', 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{1} = cellfun(@(x) x(2:end-1), dataArray{1}, 'UniformOutput', false);
        dates{1} = datetime(dataArray{1}, 'Format', 'yyyy-MM-dd HH:mm:ss', 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
    catch
        dates{1} = repmat(datetime([NaN NaN NaN]), size(dataArray{1}));
    end
end

dates = dates(:,1);

rawNumericColumns = raw(:, [2,3]); % Split data into numeric and string columns.

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

% Allocate imported array to column variable names
dt = dates{:, 1};
depth = cell2mat(rawNumericColumns(:, 1));
T = cell2mat(rawNumericColumns(:, 2));

d = dateshift(dt, 'start', 'day');
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw...
    col numericData rawData row regexstr result numbers invalidThousandsSeparator... 
    thousandsRegExp dates blankDates anyBlankDates invalidDates...
    anyInvalidDates rawNumericColumns R d dt;

%% 2) Organize these data into a structure

uniqueDates = unique(dn);

%organize into structure by date
for i = 1:length(uniqueDates)
    thisDate = uniqueDates(i);
    indexesWithThisDate = (dn == thisDate); % Extract all rows with this date
    Zi = depth(indexesWithThisDate); 
    Ti = T(indexesWithThisDate);
    M1(i).dn = thisDate;
    M1(i).Z = Zi;
    M1(i).T = Ti;   

end

%remove duplicates, make sure all data are unique
for i=1:length(M1)
    [Z,idx,~]=unique(M1(i).Z);
    M1(i).Z=Z;
    M1(i).T=M1(i).T(idx);
end

%remove partial depth profiles
%interpolate so exactly 1:200 depths
for i=1:length(M1)
    if length(M1(i).Z) <= 102
        M1(i)=[]; % remove the depth profiles that are less than 110 depths
    else
    M1(i).Zi=(1:200)';
    M1(i).Ti = spline(M1(i).Z,M1(i).T,M1(i).Zi); %cubic spline interpolation
    end
end


%% 3) find the MLD (depth at which T=0.5ºC below the surface temp), and the
% depth and temperature at the max dT/dz (vertical temperature gradient, ie thermocline)
deep=max(M1(1).Zi);

for i=1:length(M1)
    
    if isnan(M1(i).Ti)
        M1(i).diff = NaN*ones(size(M1(1).Zi));   
        M1(i).mld5=NaN;
        M1(i).dTdz=NaN*ones(length(M1(1).Zi)-1,1); 
        M1(i).zero4=NaN;
        M1(i).maxdTdz=NaN;        
        M1(i).Zmax=NaN;
        M1(i).Tmax=NaN;
     
    else          
        
    for j=1:length(M1(i).Ti)
       M1(i).diff(j)=abs(diff([M1(i).Ti(1) M1(i).Ti(j)]))';
    end
    M1(i).mld5=M1(i).Zi(find(M1(i).diff > 0.5,1));
    M1(i).mld5(isempty(M1(i).mld5))=deep; %replace with deepest depth if empty    
    M1(i).diff=M1(i).diff';
    M1(i).dTdz=abs(diff(M1(i).Ti))';   
    M1(i).dTdz=(M1(i).dTdz)';  
    [M1(i).maxdTdz,idx]=max(M1(i).dTdz);
    M1(i).Zmax=M1(i).Zi(idx);   
    M1(i).Tmax=M1(i).Ti(idx);    
    
    end
    
end

%% 4) median filter and smoothing

%eliminate outliers w 3 iterations of the median filter
dTdz = medfilt(medfilt(medfilt([M1.maxdTdz]')));
Zmax = medfilt(medfilt(medfilt([M1.Zmax]')));
Tmax = medfilt(medfilt(medfilt([M1.Tmax]')));

% smooth w 37 pt running average filter to emphaseize low-frequency
% variability to assess long term trends
dTdzS = smooth(dTdz,37);
ZmaxS = smooth(Zmax,37);
TmaxS = smooth(Tmax,37);

for i =1:length(M1)
   M1(i).maxdTdzM = dTdz(i);
   M1(i).maxdTdzS = dTdzS(i);
   
   M1(i).ZmaxM = Zmax(i);
   M1(i).ZmaxS = ZmaxS(i);
   
   M1(i).TmaxM = Tmax(i);  
   M1(i).TmaxS = TmaxS(i);  
end

clearvars deep depth dn i idx indexesWithThisDate j T thisDate Ti ...
    uniqueDates Z Zi dTdz Zmax Tmax dTdzS ZmaxS TmaxS;

save([filepath 'Data/M1-46092/M1_CTD_TS'],'M1');
