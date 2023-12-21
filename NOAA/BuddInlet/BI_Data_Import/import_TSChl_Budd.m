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

dt=datetime([B.dn],'ConvertFrom','datenum');
clearvars i sheets range edges;

%% interpolate data gaps
% do not include bottom (bottom varies for each profile)
for i=1:length(B)
    iend=find(~isnan(B(i).temp_C),1,'last');
    B(i).temp_C(1:iend)=fillmissing(B(i).temp_C(1:iend),'linear');
    B(i).sal_psu(1:iend)=fillmissing(B(i).sal_psu(1:iend),'linear');    
end

%% Stratification calculation
% N2 = calculate Brunt-Väisälä frequency
% mld5 = find where dT from the surface exceeds 0.5ºC, aka the MLD (mixed layer depth)
% dTdz = maximum temperature difference

lat=47.04571;
p=sw_pres(B(1).depth_m,lat); %dbar
deep=max(B(1).depth_m);

for i=1:length(B)

    B(i).tdiff=abs(diff(B(i).temp_C));
    [B(i).dTdz,idx]=max(B(i).tdiff);   
    B(i).Zmax=B(i).depth_m(idx);

    B(i).mld5=B(i).depth_m(find(B(i).tdiff > 0.5,1));
    iend=find(~isnan(B(i).temp_C),1,'last');
    B(i).mld5(isempty(B(i).mld5))=B(i).depth_m(iend); %replace with deepest depth if empty      

    B(i).CT = gsw_CT_from_t( B(i).sal_psu, B(i).temp_C, p ); %calculate Conservative Temperature 
    [B(i).N2, ~] = gsw_Nsquared( B(i).sal_psu, B(i).CT, p, lat );
    B(i).N2 = smooth(B(i).N2,10); %10 pt running average as in Graff & Behrenfeld 2018 and log transform
    B(i).logN2=log10(abs(B(i).N2));
end

%%
save([filepath 'BuddInlet_TSChl_profiles'],'B','dt');