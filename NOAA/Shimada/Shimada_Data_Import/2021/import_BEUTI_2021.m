%% import 2021 BEUTI
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

opts = delimitedTextImportOptions("NumVariables", 20);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["year", "month", "day", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "N8", "N9", "N10", "N11", "N12", "N13", "N14", "N15", "N16"];
opts.SelectedVariableNames = ["year", "month", "day", "N8", "N9", "N10", "N11", "N12", "N13", "N14", "N15", "N16"];
opts.VariableTypes = ["double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11"], "EmptyFieldRule", "auto");
B = readtable("/Users/alexis.fischer/Documents/BEUTI_daily.csv", opts);
Y=39:1:47; 

%%%% remove data outside of July-September
idx=(B.month==7 | B.month==8 | B.month==9); B(~idx,:)=[];

%%%% find mean BEUTI during these months in other years
idx=(B.year<2000); B(idx,:)=[]; %remove data before 2000
M=NaN(length(Y),1);
STDV=NaN(length(Y),1);
for i=1:length(Y)
    M(i)=table2array(mean(B(:,3+i)));
    STDV(i)=table2array(std(B(:,3+i),0,1,'omitnan'));  
end

%%%% remove data outside of 2021
B(~(B.year==2021),:)=[];
BDT=datetime(B.year,B.month,B.day); BDT.Format='yyyy-MM-dd';
C=table2array(B(:,4:end));

%% load in survey data 
load([filepath 'NOAA/Shimada/Data/environ_Shimada2021'],'DT','LAT','LON');
P=table(DT,LAT,LON); P=P(P.DT>datetime('01-Jan-2020'),:);
P(P.LAT<39,:)=[];% remove data south of 39N
P(P.LAT>47.5 & P.LON>-124.7,:)=[]; % remove data from the Strait

%%%% remove cruise legs to port
P((P.DT<datetime('26-Jul-2021')),:)=[];
P((P.DT>=datetime('08-Aug-2021') & P.DT<datetime('06-Sep-2021')),:)=[];
P((P.DT>=datetime('22-Sep-2021')),:)=[];
%figure; plot(P.DT,P.LAT,'o');
%figure; plot(P.DT,smooth(P.LAT,.2),'o');

P.LAT=smooth(P.LAT,.2);
[y,m,d]=ymd(P.DT); P.DT=datetime(y,m,d); P.DT.Format='yyyy-MM-dd';
clearvars idx opts B i y m d

%% find when survey encounted specific latitudinal range
Y=(39:1:48)'; 
H=NaT(length(Y)-1,2); 
H.Format='yyyy-MM-dd';
for i=1:length(Y)-1
    irange=find(P.LAT>=Y(i) & P.LAT<Y(i+1));
    dt=P.DT(irange);
    H(i,1)=dt(1); H(i,2)=dt(end);
end
clearvars i irange opts y m d dt

%% find where survey matches with BEUTI dataset
beutiM=[];
beutiSD=[];
for i=1:length(H)
    ia=find(BDT>=H(i,1) & BDT<=H(i,2));
    m=mean(C(ia,i));
    sd=std(C(ia,i));
    beutiM=[beutiM;m];
    beutiSD=[beutiSD;sd];
    clearvars ia m sd
end

lat=Y(1:end-1);
dt1=H(:,1);dt2=H(:,2);
B=table(lat,dt1,dt2,beutiM,beutiSD);

save([filepath 'NOAA/Shimada/Data/BEUTI_Shimada2021'],'B','M','STDV','lat');
