%% Import BI temp, sal, chl profiles data from Excel
clear;

filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/';
filename=[filepath 'TSDChl_Data_Graphs.xlsx'];
sheets = sheetnames(filename);

for i=1:length(sheets)
    opts = spreadsheetImportOptions("NumVariables", 4);
    opts.Sheet = sheets(i);
    opts.DataRange = 'A2:D300'; %300 is just a big value
    opts.VariableNames = ["C", "SALPSU", "ChlRFU", "VertPosM"];
    opts.VariableTypes = ["double", "double", "double", "double"];    
    T = readtable(filename, opts, "UseExcel", false);

    idx=isnan(T.C); T(idx,:)=[]; %remove all of the extra rows
    edges=(0:.1:8)'; 
    ind=discretize(T.VertPosM,edges);
    
    B(i).dn=datenum(datetime(sheets(i),'InputFormat','MMddyy'));    
    B(i).depth_m=edges;
    B(i).temp_C = accumarray(ind,T.C,[length(edges) 1],@mean,NaN);
    B(i).sal_psu = accumarray(ind,T.SALPSU,[length(edges) 1],@mean,NaN);
    B(i).chl_rfu = accumarray(ind,T.ChlRFU,[length(edges) 1],@mean,NaN);
    
    clearvars opts T ind idx;    
end

clearvars i sheets range edges;

save([filepath 'BuddInlet_TSChl_profiles'],'B');