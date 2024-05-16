%% Import 2021 pCO2
clear
filepath='~/Documents/Shimada2021/pCO2_2021_processed/';
outpath='~/Documents/MATLAB/bloom-baby-bloom/Shimada/Data/';

addpath(outpath);
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

filedir = dir([filepath '*.csv']);
for i=1:length(filedir)
    disp(filedir(i).name);   
    
    opts = delimitedTextImportOptions("NumVariables", 24);
    opts.DataLines = [6, Inf];
    opts.Delimiter = ",";
    opts.VariableNames = ["Var1", "Var2", "Var3", "YD_UTC", "DATE_UTC__ddmmyyyy", "Var6", "LAT_dec_degree", "LONG_dec_degree", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "SST_C", "SAL_permil", "fCO2_SWSST_uatm", "Var18", "Var19", "Var20", "Var21", "O2Sat", "Var23", "O2Umm"];
    opts.SelectedVariableNames = ["YD_UTC", "DATE_UTC__ddmmyyyy", "LAT_dec_degree", "LONG_dec_degree", "SST_C", "SAL_permil", "fCO2_SWSST_uatm", "O2Sat", "O2Umm"];
    opts.VariableTypes = ["char", "char", "char", "double", "double", "char", "double", "double", "char", "char", "char", "char", "char", "char", "double", "double", "double", "char", "char", "char", "char", "double", "char", "double"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var6", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21", "Var23"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var6", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21", "Var23"], "EmptyFieldRule", "auto");
    T = readtable([filepath filedir(i).name], opts); 

    y = mod(T.DATE_UTC__ddmmyyyy(1),1E4);
    [yy,MM,dd,HH,mm,ss] = datevec(datenum(y,1,T.YD_UTC));
    dt=datetime(yy,MM,dd,HH,mm,ss,'Format','yyyy-MM-dd HH:mm:ss');
    
    p(i).dt = dt;
    p(i).lat=T.LAT_dec_degree;
    p(i).lon=T.LONG_dec_degree;
    p(i).sst=T.SST_C;
    p(i).sal=T.SAL_permil;
    p(i).fco2=T.fCO2_SWSST_uatm;
  
end

% create merged table
dt=vertcat(p.dt);
lat=vertcat(p.lat); 
lon=vertcat(p.lon);
sst=vertcat(p.sst); sst(sst==-999)=NaN;
sal=vertcat(p.sal); sal(sal==-999)=NaN;
fco2=vertcat(p.fco2); fco2(fco2==-999)=NaN;

save([outpath 'pCO2_Shimada2021'],'dt','lat','lon','sst','sal','fco2');

