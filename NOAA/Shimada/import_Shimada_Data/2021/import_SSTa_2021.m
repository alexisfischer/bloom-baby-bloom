%% import SST anomaly from 2021 MHW
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

opts = delimitedTextImportOptions("NumVariables", 5);
opts.DataLines = [3, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["time", "latitude", "longitude", "sstAnom", "mask"];
opts.VariableTypes = ["char", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, "time", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "time", "EmptyFieldRule", "auto");
T = readtable("/Users/alexis.fischer/Documents/Shimada2021/SSTanomaly_2021.csv", opts);

T.dt=datetime(T.time,'InputFormat','uuuu-MM-dd''T''HH:mm:ss''Z');
[y,m,d]=ymd(T.dt); T.dt=datetime(y,m,d); T.dt.Format='yyyy-MM-dd';

%%%% load in survey data 
%%%% load in survey data 
load([filepath 'NOAA/Shimada/Data/environ_Shimada2021'],'DT','LAT','LON');
P=table(DT,LAT,LON); P=P(P.DT>datetime('01-Jan-2020'),:);
P(P.LAT<40,:)=[];% remove data south of 40N
P(P.LAT>47.5 & P.LON>-124.7,:)=[]; % remove data from the Strait

%%%% remove cruise legs to port
P((P.DT<datetime('26-Jul-2021')),:)=[];
P((P.DT>=datetime('08-Aug-2021') & P.DT<datetime('06-Sep-2021')),:)=[];
P((P.DT>=datetime('22-Sep-2021')),:)=[];
%figure; plot(P.DT,P.LAT,'o');
%figure; plot(P.DT,smooth(P.LAT,.2),'o');

P.LATs=smooth(P.LAT,.2);
[y,m,d]=ymd(P.DT); P.DT=datetime(y,m,d); P.DT.Format='yyyy-MM-dd';

%%%% find when survey encounted specific latitudinal range
Y=(40:.1:48.8)'; 
H=NaT(length(Y)-1,2); 
H.Format='yyyy-MM-dd';

for i=1:length(Y)-1
    irange=find(P.LATs>=Y(i) & P.LATs<Y(i+1));
    dt=P.DT(irange);
    H(i,1)=dt(1); H(i,2)=dt(end);
end
clearvars i irange opts y m d dt

%%%% find where survey matches with Anomaly dataset
lat=[]; lon=[]; sstA=[]; dt=[]; 
for i=1:length(H)
    ia=find(T.latitude==Y(i));
    ib=find(T.dt(ia)>=H(i,1) & T.dt(ia)<=H(i,2));

    lati=T.latitude(ia(ib));
    loni=T.longitude(ia(ib));
    sstAi=T.sstAnom(ia(ib));
    dti=T.dt(ia(ib));

    lat=[lat;lati];
    lon=[lon;loni];
    sstA=[sstA;sstAi];
    dt=[dt;dti];
    clearvars lati loni sstAi sti r ia ib
end
A=table(dt,lat,lon,sstA);

save([filepath 'NOAA/Shimada/Data/sstA_Shimada2021'],'A');
