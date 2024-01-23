%% IMPORT HOBO logger data from Budd Inlet
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/'; %USER
indir= [filepath 'HOBO_T_S/']; %USER

addpath(genpath(filepath)); 
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); 

interval=60*2; %smoothing interval 2hr moving mean

%%%% 1m import
Tdir=dir([indir '*1m.xlsx']);
dti=[]; tempi=[]; sali=[];
for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);

    opts = spreadsheetImportOptions("NumVariables", 3);
    opts.DataRange = "A2:C30066";
    opts.VariableNames = ["DateTimeGMT0700", "TempCLGRSN20794837SENSN20794837", "SalinityPptLGRSN20794837"];
    opts.VariableTypes = ["datetime", "double", "double"];

    T = readtable(filename, opts, "UseExcel", false);
    T(isnat(T.DateTimeGMT0700),:)=[]; %remove nans from big import dimensions to account for spreadsheet variability

    dti=[dti;table2array(T(:,1))];
    tempi=[tempi;table2array(T(:,2))];
    sali=[sali;table2array(T(:,3))];  
    clear opts filename name T
end

[dt,id]=sort(dti); s1=sali(id); t1=tempi(id);
dt=datetime(dt,'Format','dd-MMM-yyyy HH:mm:ss'); 
H1=timetable(dt,t1,s1);
H1.dt=dateshift(H1.dt,'start','minute');

%%%% smooth data by year so no trailing edges
idx=find(H1.dt.Year==2021);
    H1.s1(idx)=smoothdata(H1.s1(idx),'movmedian',interval); 
    H1.t1(idx)=smoothdata(H1.t1(idx),'movmedian',interval); 
idx=find(H1.dt.Year==2022);
    H1.s1(idx)=smoothdata(H1.s1(idx),'movmedian',interval);
    H1.t1(idx)=smoothdata(H1.t1(idx),'movmedian',interval);
idx=find(H1.dt.Year==2023);
    H1.s1(idx)=smoothdata(H1.s1(idx),'movmedian',interval);
    H1.t1(idx)=smoothdata(H1.t1(idx),'movmedian',interval);

% figure; %sanity check plot
% subplot(2,1,1); plot(dt,t1,'k-',H1.dt,H1.t1,'r-')
% subplot(2,1,2); plot(dt,s1,'k-',H1.dt,H1.s1,'r-')

%%%% 3m import
Tdir=dir([indir '*3m.xlsx']);
dti=[]; tempi=[]; sali=[];
for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);    

    opts = spreadsheetImportOptions("NumVariables", 3);
    opts.DataRange = "A2:C30066";
    opts.VariableNames = ["DateTimeGMT0700", "TempCLGRSN20794837SENSN20794837", "SalinityPptLGRSN20794837"];
    opts.VariableTypes = ["datetime", "double", "double"];    
    
    T = readtable(filename, opts, "UseExcel", false);
    T(isnat(T.DateTimeGMT0700),:)=[]; %remove nans from big import dimensions to account for spreadsheet variability
    
    dti=[dti;table2array(T(:,1))];
    tempi=[tempi;table2array(T(:,2))];
    sali=[sali;table2array(T(:,3))];  
    clear opts filename name T
end

[dt,id]=sort(dti); s3=sali(id); t3=tempi(id);
dt=datetime(dt,'Format','dd-MMM-yyyy HH:mm:ss'); 
H3=timetable(dt,t3,s3);
H3.dt=dateshift(H3.dt,'start','minute');

%%%% smooth data by year so no trailing edges
idx=find(H3.dt.Year==2021);
    H3.s3(idx)=smoothdata(H3.s3(idx),'movmedian',interval); 
    H3.t3(idx)=smoothdata(H3.t3(idx),'movmedian',interval); 
idx=find(H3.dt.Year==2022);
    H3.s3(idx)=smoothdata(H3.s3(idx),'movmedian',interval);
    H3.t3(idx)=smoothdata(H3.t3(idx),'movmedian',interval);
idx=find(H3.dt.Year==2023);
    H3.s3(idx)=smoothdata(H3.s3(idx),'movmedian',interval);
    H3.t3(idx)=smoothdata(H3.t3(idx),'movmedian',interval);

% figure; %sanity check plot
% subplot(2,1,1); plot(dt,t3,'k-',H3.dt,H3.t3,'r-')
% subplot(2,1,2); plot(dt,s3,'k-',H3.dt,H3.s3,'r-')
clearvars dti id sali tempi  i indir Tdir dt t1 t3 s1 s3

%%%% merge
H=synchronize(H1,H3);
H=retime(H,'minutely');
Hm=H;
% figure;
% subplot(2,1,1)
%     plot(H1.dt,H1.t1,'k-',H.dt,H.t1,'ro'); title('1m');
% subplot(2,1,2)
%     plot(H3.dt,H3.t3,'k-',H.dt,H.t3,'ro'); title('3m');

%%%% interpolate to every minute
H.t1 = fillmissing(H.t1,'linear','SamplePoints',H.dt,'MaxGap',minutes(30));
H.t3 = fillmissing(H.t3,'linear','SamplePoints',H.dt,'MaxGap',minutes(30));
H.s1 = fillmissing(H.s1,'linear','SamplePoints',H.dt,'MaxGap',minutes(30));
H.s3 = fillmissing(H.s3,'linear','SamplePoints',H.dt,'MaxGap',minutes(30));


%%
% %%%% test plot
% figure;
% subplot(2,1,1)
%     plot(Hm.dt,Hm.t1,'k-',H.dt,H.t1,'r-');
%     set(gca,'xlim',[datetime('01-Jun-2021') datetime('01-Dec-2023')])    
% subplot(2,1,2)
%     plot(Hm.dt,Hm.t3,'k-',H.dt,H.t3,'r-');
%     set(gca,'xlim',[datetime('01-Jun-2021') datetime('01-Dec-2023')])
% legend('before','after')

%clearvars H1 H3 Hm

%% calculate density
lat=47.04571;
%1.5m
p1=gsw_p_from_z(-1.5,lat)*ones(size(H.s1)); %calculate pressure from height
[H.SA1,~]= gsw_SA_from_SP(H.s1,p1,-122.90702,lat);    
H.CT1=gsw_CT_from_t(H.SA1,H.t1,p1); 
H.sigmat1=gsw_rho(H.SA1,H.CT1,p1)-1000; %'Sigma-t' is rho minus 1000

%3m
p3=gsw_p_from_z(-3,lat)*ones(size(H.s3)); %calculate pressure from height
[H.SA3,~]= gsw_SA_from_SP(H.s3,p3,-122.90702,lat);    
H.CT3=gsw_CT_from_t(H.SA3,H.t3,p3); 
H.sigmat3=gsw_rho(H.SA3,H.CT3,p3)-1000; %'Sigma-t' is rho minus 1000

%density difference
H.sigmat_diff=H.sigmat3-H.sigmat1;
%%
save([filepath 'temp_sal_1m_3m_BuddInlet'],'H');
