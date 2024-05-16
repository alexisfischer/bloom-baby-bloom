%% merge Shimada temperature data with lat lon coordinates
% load in lat lon coordinates and environmental variables from Shimada 
% intakes 2019 or 2021 data
% group data by the minute 
% Alexis D. Fischer, NWFSC, May 2022

clear;
filepath= '~/Documents/MATLAB/bloom-baby-bloom/Shimada/'; 
yr='2019'; %'2021'
addpath(genpath(filepath)); 

%%%% lat lon coordinates
load([filepath 'Data/lat_lon_time_Shimada' yr],'DT','LON','LAT');
T=timetable(DT,LAT,LON); T=retime(T,'minutely');
LAT = fillmissing(T.LAT,'nearest'); 
LON = fillmissing(T.LON,'nearest'); 
DT=T.DT;
TT=timetable(DT,LAT,LON);

clearvars LON LAT DT TTi T;

%% temperature and salinity
if strcmp(yr,'2019')
    load([filepath 'Data/temperature_salinity_Shimada' yr],'dt','temp','sal');
    T=timetable(dt,temp,sal);
    TT = synchronize(TT,T,'first','mean');
    %figure; plot(dt,temp,'-',TT.DT,TT.temp,'-')    
    clearvars T dt temp sal
    idx=find(~isnan(TT.temp),2); %remove first rows with nothing in them
    TT(1:idx(2)-1,:)=[];        

else
    %%%% temp
    load([filepath 'Data/temperature_Shimada' yr],'dt','temp');
    T=timetable(dt,temp);    
    TT = synchronize(TT,T,'first','mean');
    clearvars T dt temp 

    %%%% sal
    load([filepath 'Data/salinity_Shimada' yr],'dt','sal');
    T=timetable(dt,sal);    
    TT = synchronize(TT,T,'first','mean');
    clearvars T dt sal

    idx=find(~isnan(TT.temp),1); %remove first rows with nothing in them
    TT(1:idx-1,:)=[];    
end

TT.temp = fillmissing(TT.temp,'linear','SamplePoints',TT.DT,'MaxGap',minutes(20));
TT.sal = fillmissing(TT.sal,'linear','SamplePoints',TT.DT,'MaxGap',minutes(20));

    idx=(isnan(TT.temp)); d=diff(idx); da=find(d>0); db=find(d<0);
    for i=1:length(da) % duplicate  data for 10 minutes after last value
        id=da(i);
        TT.temp(id:id+10)=TT.temp(id-1);
    end
    for i=1:length(db) % duplicate  data for 10 minutes before last value  
        id=db(i);
        TT.temp(id-10:id)=TT.temp(id+1);
    end

    idx=(isnan(TT.sal)); d=diff(idx); da=find(d>0); db=find(d<0);
    for i=1:length(da) % duplicate  data for 10 minutes after last value
        id=da(i);
        TT.sal(id:id+10)=TT.sal(id-1);
    end
    for i=1:length(db) % duplicate  data for 10 minutes before last value  
        id=db(i);
        TT.sal(id-10:id)=TT.sal(id+1);
    end

    clearvars T dt temp sal id di idx i
    
%% fluorescence
load([filepath 'Data/fluorescence_Shimada' yr],'dt','fl');
    T=timetable(dt,fl);
    TT = synchronize(TT,T,'first','mean');
    TT.fl = fillmissing(TT.fl,'linear','SamplePoints',TT.DT,'MaxGap',minutes(20));
    %figure; plot(dt,fl,'-',TT.DT,TT.fl,'-')

    clearvars T dt fl id di idx i

%% pco2
load([filepath 'Data/pCO2_Shimada' yr],'dt','fco2','sst');
    T=timetable(dt,fco2,sst);    
    TT = synchronize(TT,T,'first','mean');    
    TT.pco2 = fillmissing(TT.fco2,'linear','SamplePoints',TT.DT,'MaxGap',minutes(20));

    idx=(isnan(TT.pco2)); d=diff(idx); da=find(d>0); db=find(d<0);
    for i=1:length(da) % duplicate  data for 10 minutes after last value
        id=da(i);
        TT.pco2(id:id+10)=TT.pco2(id-1);
    end
    for i=1:length(db) % duplicate  data for 10 minutes before last value  
        id=db(i);
        TT.pco2(id-10:id)=TT.pco2(id+1);
    end

    clearvars T dt fco2 id da db idx i

%% air temperature (only 2019)
load([filepath 'Data/airtemperature_Shimada' yr],'dt','airtemp');
    T=timetable(dt,airtemp);
    TT = synchronize(TT,T,'first','mean');
    TT.airtemp = fillmissing(TT.airtemp,'linear','SamplePoints',TT.DT,'MaxGap',minutes(20));
    %figure; plot(dt,airtemp,'-',TT.DT,TT.airtemp,'-')

    clearvars T dt fl id di idx i 

%% air pressure (only 2019)
load([filepath 'Data/airpressure_Shimada' yr],'dt','atmp');
    T=timetable(dt,atmp);
    TT = synchronize(TT,T,'first','mean');
    TT.atmp = fillmissing(TT.atmp,'linear','SamplePoints',TT.DT,'MaxGap',minutes(20));
    %figure; plot(dt,atmp,'-',TT.DT,TT.atmp,'-')

    clearvars T dt fl id di idx i 

%%
%figure; plot(LON(ib),LAT(ib),'o'); % test plot

TEMP=TT.temp; SAL=TT.sal; FL=TT.fl; PCO2=TT.pco2; LON=TT.LON; LAT=TT.LAT; 
DT=TT.DT; TEMPi=TT.sst; AIRTEMP=TT.airtemp; ATMP=TT.atmp;

save([filepath 'Data/environ_Shimada' yr],'DT','LON','LAT','TEMP','SAL',...
    'FL','PCO2','ATMP','AIRTEMP','TEMPi');

