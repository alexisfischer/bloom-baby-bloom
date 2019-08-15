%% Import 2018 Microscopy data from SCW
% Alexis D. Fischer, March 2019

outdir='/Users/afischer/MATLAB/bloom-baby-bloom/SCW/';

filename ='/Users/afischer/Documents/UCSC_research/SCW_Dino_Project/Data/Microscopy_SCW_2018_ADF.xlsx';
opts = spreadsheetImportOptions("NumVariables", 8); % Setup the Import Options
opts.Sheet = "matlab_ready";
opts.DataRange = "A2:H849";

% Specify column names and types
opts.VariableNames = ["Genus", "Class", "Month", "Day", "Year", "FOV", "count", "cellsL"];
opts.VariableTypes = ["string", "string", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, [1, 2], "EmptyFieldRule", "auto");

% Setup rules for import
opts.ImportErrorRule = "omitrow";
opts.MissingRule = "omitrow";
opts = setvaropts(opts, [3, 4, 5, 6, 7, 8], "TreatAsMissing", '');
T = readtable(filename, opts, "UseExcel", false);

dn=datenum(datetime(T.Year,T.Month,T.Day));
dnM=unique(dn);
g=T.Genus;
genus=unique(g)';
cellsml=T.cellsL*.001; %convert to cells/mL
count=T.count;

micro=NaN*ones([length(dnM),length(genus)]); %create empty matrix
n=NaN*ones([length(dnM),length(genus)]); %create empty matrix

%organize data into a Matrix of date x genus
for i = 1:length(dn)
    iD = find(dn(i)==dnM);
    iC = strmatch(g(i), genus); %classifier index
    micro(iD,iC) = cellsml(i);
    n(iD,iC) = count(i);    
end

%%
err=2./sqrt(n); % percent error for each species (Willen, 1976, Lund et al. 1958)
% iD=find(err>=20); % restrict data to +/- 20% or 30%
% micro(iD)=NaN; n(iD)=NaN; err(iD)=NaN; 

% n(isnan(n))=0; % replace NaN with 0
% micro(isnan(micro))=0; % replace NaN with 0

clearvars opts cellsml count dn iD iC g i T dn chain g

save([outdir 'Data/Microscopy_SCW'],'micro','genus','dnM','err','n');
