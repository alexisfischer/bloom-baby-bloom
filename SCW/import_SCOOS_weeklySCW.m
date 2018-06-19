function [a] = import_SCOOS_weeklySCW()

%copy pasted and saved this file from http://habmap.info/data.html

%% Import the data
[~, ~, raw] = xlsread('/Users/afischer/Documents/UCSC_research/SCW_classifier/SCW_SCOOS.xlsx','Sheet1');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
Date = data(:,1)+693960; %convert from excel to datenum
AlexandriumsppcellsL = data(:,2);
Chloromgm3 = data(:,3);
DomoicAcidngmL = data(:,4);
NO3uM = data(:,5);
PuM = data(:,6);
PseudonitzschiaseriatagroupcellsL = data(:,7);
SiuM = data(:,8);
WaterTempC = data(:,9);

%% Save
a.dn=flipud(Date);
a.chl=flipud(Chloromgm3);
a.temp=flipud(WaterTempC);
a.ALE=flipud(AlexandriumsppcellsL);
a.PSE=flipud(PseudonitzschiaseriatagroupcellsL);
a.NitrateuM=flipud(NO3uM);
a.PhosphateuM=flipud(PuM);
a.SilicateuM=flipud(SiuM);
a.DomoicAcidngmL=flipud(DomoicAcidngmL);

save('/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/SCW_SCOOS','a');

%% Clear temporary variables
clearvars data raw R;

end