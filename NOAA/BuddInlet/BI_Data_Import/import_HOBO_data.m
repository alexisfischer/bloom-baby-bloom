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

[dt,id]=sort(dti); s1m=sali(id); t1m=tempi(id);

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

[dt,id]=sort(dti); s3m=sali(id); t3m=tempi(id);

dt=datetime(dt,'Format','dd-MMM-yyyy HH:mm:ss'); 
H=table(dt,t1m,t3m,s1m,s3m);

clearvars dti id sali tempi  i indir Tdir

%% interpolate to every minute
H=timetable(dt,t1m,t3m,s1m,s3m);
H=retime(H,'minutely');
H.t1m = fillmissing(H.t1m,'linear','SamplePoints',H.dt,'MaxGap',minutes(30));
H.t3m = fillmissing(H.t3m,'linear','SamplePoints',H.dt,'MaxGap',minutes(30));
H.s1m = fillmissing(H.s1m,'linear','SamplePoints',H.dt,'MaxGap',minutes(30));
H.s3m = fillmissing(H.s3m,'linear','SamplePoints',H.dt,'MaxGap',minutes(30));

% %% test plot
% figure;
% subplot(2,1,1)
%     plot(dt,t1m,'k-',H.dt,H.t1m,'r-');
% subplot(2,1,2)
%     plot(dt,t3m,'k-',H.dt,H.t3m,'r-');
% legend('before','after','Location','NW')


save([filepath 'temp_sal_1m_3m_BuddInlet'],'H');
