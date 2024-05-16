%% import 2019 BEUTI
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
B = readtable([filepath 'Shimada/Data/BEUTI_daily.csv'], opts);

%%%% prep data for mean climatology
dt=datetime(B.year,B.month,B.day); dt.Format='yyyy-MM-dd';
data=table2array(B(:,4:end));

%%%% create mean climatology for each date and latitude
Adata=NaN*ones(366,size(data,2));
for i=1:size(data,2)
    [mdate_mat,y_mat,~,~] = timeseries2ydmat(datenum(dt),data(:,i));
    Adata(:,i) = nanmean(y_mat,2); %average same day for all years
end
Adata(1,:)=[];

%%%% prep data for 2019 only analysis
B(~(B.year==2019),:)=[];
dt=datetime(B.year,B.month,B.day); dt.Format='yyyy-MM-dd';
Bdata=table2array(B(:,4:end));

clearvars mdate_mat y_mat i B opts data

%% load in survey data 
load([filepath 'Shimada/Data/environ_Shimada2019'],'DT','LAT','LON');
P=table(DT,LAT,LON); P=P(P.DT<datetime('01-Jan-2020'),:);
P(P.LAT<39,:)=[];% remove data south of 39N
P(P.LAT>47.5 & P.LON>-124.7,:)=[]; % remove data from the Strait

%%%% remove cruise legs to port
P((P.DT<datetime('09-Jul-2019')),:)=[];
P((P.DT>=datetime('14-Jul-2019') & P.DT<datetime('20-Jul-2019')),:)=[];
P((P.DT>=datetime('01-Aug-2019') & P.DT<datetime('07-Aug-2019')),:)=[];
P((P.DT>=datetime('12-Aug-2019 10:00:00') & P.DT<datetime('14-Aug-2019 02:00:00')),:)=[];
P((P.DT>=datetime('19-Aug-2019')),:)=[];
%figure; plot(P.DT,P.LAT,'o');
%figure; plot(P.DT,smooth(P.LAT,.2),'o');

P.LAT=smooth(P.LAT,.2);
[y,m,d]=ymd(P.DT); P.DT=datetime(y,m,d); P.DT.Format='yyyy-MM-dd';

%%%% find date range (R) when survey encounted specific latitudinal range
Y=(39:1:48)'; 
R=NaT(length(Y)-1,2); 
R.Format='yyyy-MM-dd';
for i=1:length(Y)-1
    irange=find(P.LAT>=Y(i) & P.LAT<Y(i+1));
    dti=P.DT(irange);
    R(i,1)=dti(1); R(i,2)=dti(end);
end
clearvars y m d idx DT LAT LON i irange P dti

%% find where survey matches with BEUTI dataset 
% and take 2019 and climatology BEUTI value
mbeuti_19=[]; sdbeuti_19=[];
mbeuti_all=[]; sdbeuti_all=[];

for i=1:length(R)
    ia=find(dt>=R(i,1) & dt<=R(i,2));

    %climatology on 2019 survey dates
    m=mean(Adata(ia,i));
    sd=std(Adata(ia,i));
    mbeuti_all=[mbeuti_all;m];
    sdbeuti_all=[sdbeuti_all;sd];

    %2019 survey    
    m=mean(Bdata(ia,i));
    sd=std(Bdata(ia,i));
    mbeuti_19=[mbeuti_19;m];
    sdbeuti_19=[sdbeuti_19;sd];
    clearvars ia m sd
end

lat=Y(1:end-1);
dt1=R(:,1); dt2=R(:,2);
B=table(lat,dt1,dt2,mbeuti_19,sdbeuti_19,mbeuti_all,sdbeuti_all);

save([filepath 'Shimada/Data/BEUTI_Shimada2019'],'B','lat');

