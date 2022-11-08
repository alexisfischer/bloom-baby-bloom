%% IMPORT HOBO logger data from Budd Inlet
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/'; %USER
indir= [filepath 'HOBO_T_S/']; %USER

addpath(genpath(filepath)); 
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); 

%% 1m import
Tdir=dir([indir '*1m.xlsx']);
dti=[]; tempi=[]; sali=[];
for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);     
    opts = spreadsheetImportOptions("NumVariables", 5);    
    opts.DataRange = "A2:E19266";    
    opts.VariableNames = ["DateTimeGMT0700", "Var2", "TempCLGRSN20794837SENSN20794837", "Var4", "SalinityPptLGRSN20794837"];
    opts.SelectedVariableNames = ["DateTimeGMT0700", "TempCLGRSN20794837SENSN20794837", "SalinityPptLGRSN20794837"];
    opts.VariableTypes = ["datetime", "char", "double", "char", "double"];    
    opts = setvaropts(opts, ["Var2", "Var4"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var2", "Var4"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "DateTimeGMT0700", "InputFormat", "");

    T = readtable(filename, opts, "UseExcel", false);
    dti=[dti;table2array(T(:,1))];
    tempi=[tempi;table2array(T(:,2))];
    sali=[sali;table2array(T(:,3))];  
    clear opts filename name T
end

[dt,id]=sort(dti); sal=sali(id); temp=tempi(id);
H1m=table(dt,temp,sal);

%% 3m import
Tdir=dir([indir '*3m.xlsx']);
dti=[]; tempi=[]; sali=[];
for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);     
    opts = spreadsheetImportOptions("NumVariables", 5);    
    opts.DataRange = "A2:E19266";    
    opts.VariableNames = ["DateTimeGMT0700", "Var2", "TempCLGRSN20794837SENSN20794837", "Var4", "SalinityPptLGRSN20794837"];
    opts.SelectedVariableNames = ["DateTimeGMT0700", "TempCLGRSN20794837SENSN20794837", "SalinityPptLGRSN20794837"];
    opts.VariableTypes = ["datetime", "char", "double", "char", "double"];    
    opts = setvaropts(opts, ["Var2", "Var4"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var2", "Var4"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "DateTimeGMT0700", "InputFormat", "");

    T = readtable(filename, opts, "UseExcel", false);
    dti=[dti;table2array(T(:,1))];
    tempi=[tempi;table2array(T(:,2))];
    sali=[sali;table2array(T(:,3))];  
    clear opts filename name T
end

[dt,id]=sort(dti); sal=sali(id); temp=tempi(id);
H3m=table(dt,temp,sal);

clearvars dti id dt sali tempi sal temp i indir Tdir

save([filepath 'temp_sal_1m_3m_BuddInlet'],'H1m','H3m');

    %%
figure;
subplot(2,1,1)
plot(H1m.dt,H1m.temp,'-',H3m.dt,H3m.temp,'-'); hold on
ylabel('temperature (^oC)')

subplot(2,1,2)
plot(H1m.dt,H1m.sal,'-',H3m.dt,H3m.sal,'-'); hold on
ylabel('salinity (psu)')

legend('1m','3m','Location','NW')


