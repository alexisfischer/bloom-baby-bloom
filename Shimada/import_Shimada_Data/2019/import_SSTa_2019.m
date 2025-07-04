%% import SST anomaly from 2019 MHW
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
T = readtable("/Users/alexis.fischer/Documents/Shimada2019/SSTanomaly_2019.csv", opts);
T.dt=datetime(T.time,'InputFormat','uuuu-MM-dd''T''HH:mm:ss''Z');
[y,m,d]=ymd(T.dt); T.dt=datetime(y,m,d); T.dt.Format='yyyy-MM-dd';

%%%% load in survey data 
load([filepath 'Shimada/Data/environ_Shimada2019'],'DT','LAT','LON');
P=table(DT,LAT,LON); P=P(P.DT<datetime('01-Jan-2020'),:);
P(P.LAT<40,:)=[];% remove data south of 40N
P(P.LAT>47.5 & P.LON>-124.7,:)=[]; % remove data from the Strait

%%%% remove cruise legs to port
P((P.DT<datetime('09-Jul-2019')),:)=[];
P((P.DT>=datetime('14-Jul-2019') & P.DT<datetime('20-Jul-2019')),:)=[];
P((P.DT>=datetime('01-Aug-2019') & P.DT<datetime('07-Aug-2019')),:)=[];
P((P.DT>=datetime('12-Aug-2019 10:00:00') & P.DT<datetime('14-Aug-2019 02:00:00')),:)=[];
P((P.DT>=datetime('19-Aug-2019')),:)=[];
%figure; plot(P.DT,P.LAT,'o');
%figure; plot(P.DT,smooth(P.LAT,.2),'o');

P.LATs=smooth(P.LAT,.2);
[y,m,d]=ymd(P.DT); P.DT=datetime(y,m,d); P.DT.Format='yyyy-MM-dd';

%%%% find when survey encounted specific latitudinal range
Y=(40:.1:48.6)'; 
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

save([filepath 'Shimada/Data/sstA_Shimada2019'],'A');
