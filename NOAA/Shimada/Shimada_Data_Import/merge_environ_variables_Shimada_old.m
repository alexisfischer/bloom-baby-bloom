%% merge Shimada temperature data with lat lon coordinates
% load in lat lon coordinates and environmental variables from Shimada 
% intakes 2019 or 2021 data
% group data by the minute 
% Alexis D. Fischer, NWFSC, May 2022

clear;
filepath= '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/'; 
yr='2019'; %'2021'
addpath(genpath(filepath)); 

%%%% lat lon coordinates
load([filepath 'Data/lat_lon_time_Shimada' yr],'DT','LON','LAT');
TTi=timetable(LAT,LON,'RowTimes',DT);
TT=retime(TTi,'minutely');
LAT = fillmissing(TT.LAT,'nearest'); 
LON = fillmissing(TT.LON,'nearest'); 
DT=TT.Time;
clearvars TTi TT

%% temperature and salinity
if strcmp(yr,'2019')
    load([filepath 'Data/temperature_salinity_Shimada' yr],'dt','temp','sal');
    [tempi,dt1,numt] = groupsummary(temp,dt,minutes(2),'mean','IncludeEmptyGroups',true);
    [sali,~,nums] = groupsummary(sal,dt,minutes(2),'mean','IncludeEmptyGroups',true);
    dt2=char(dt1);
    dti=datetime(cellstr(dt2(:,2:21)))+minutes(1); %add one minute so in between 2 min groups
    
    %add those datapoints back in
    t=timetable(tempi,sali,'RowTimes',dti); t=retime(t,'minutely');
    dti=t.Time; tempi=t.tempi; sali=t.sali;
    tempi = fillmissing(tempi,'linear','SamplePoints',dti,'MaxGap',minutes(5));
    sali = fillmissing(sali,'linear','SamplePoints',dti,'MaxGap',minutes(5));
    %figure;plot(dt,temp,'-',dti,tempi,'-')
    %figure;plot(dt,sal,'-',dti,sali,'-')
    
    % merge 
    [~,ia,ib]=intersect(dti,DT);
    TEMP=NaN*ones(size(DT)); TEMP(ib)=tempi(ia);
    SAL=NaN*ones(size(DT)); SAL(ib)=sali(ia);
    %figure; plot(dt,sal,'-',DT,SAL,'-')
    %figure; plot(dt,temp,'-',DT,TEMP,'-')
    
    clearvars dt temp sal tempi sali dt1 dt2 dti nums numt ia ib t

else
    %%%% temp
    load([filepath 'Data/temperature_Shimada' yr],'dt','temp');
    [tempi,dt1,num] = groupsummary(temp,dt,minutes(2),'mean','IncludeEmptyGroups',true);
    dt2=char(dt1);
    dti=datetime(cellstr(dt2(:,2:21)))+minutes(1); %add one minute so in between 2 min groups
    
    %add those datapoints back in
    t=timetable(tempi,'RowTimes',dti); t=retime(t,'minutely');
    dti=t.Time; tempi=t.tempi;
    tempi = fillmissing(tempi,'linear','SamplePoints',dti,'MaxGap',minutes(5));
    %figure;plot(dt,temp,'-',dti,tempi,'-')
    
    % merge 
    [~,ia,ib]=intersect(dti,DT);
    TEMP=NaN*ones(size(DT)); TEMP(ib)=tempi(ia);
    %figure; plot(dt,temp,'-',DT,TEMP,'-')    
    clearvars dt temp tempi dti num ia ib t dt1 dt2

    %%%% sal
    load([filepath 'Data/salinity_Shimada' yr],'dt','sal');
    [sali,dt1,num] = groupsummary(sal,dt,minutes(2),'mean','IncludeEmptyGroups',true);
    dt2=char(dt1);
    dti=datetime(cellstr(dt2(:,2:21)))+minutes(1); %add one minute so in between 2 min groups
    
    %add those datapoints back in
    t=timetable(sali,'RowTimes',dti); t=retime(t,'minutely');
    dti=t.Time; sali=t.sali;
    sali = fillmissing(sali,'linear','SamplePoints',dti,'MaxGap',minutes(5));
    %figure;plot(dt,sal,'-',dti,sali,'-')
    
    % merge 
    [~,ia,ib]=intersect(dti,DT);
    SAL=NaN*ones(size(DT)); SAL(ib)=sali(ia);
    %figure; plot(dt,sal,'-',DT,SAL,'-')    
    clearvars dt sal sali dti num ia ib t dt1 dt2    

end

%% fluorescence
load([filepath 'Data/fluorescence_Shimada' yr],'dt','fl');
[fli,dt1,num] = groupsummary(fl,dt,minutes(2),'mean','IncludeEmptyGroups',true);
dt2=char(dt1);
dti=datetime(cellstr(dt2(:,2:21)))+minutes(1); %add one minute so in between 2 min groups

%add those datapoints back in
t=timetable(fli,'RowTimes',dti); t=retime(t,'minutely');
dti=t.Time; fli=t.fli;
fli = fillmissing(fli,'linear','SamplePoints',dti,'MaxGap',minutes(5));
%figure;plot(dt,fl,'-',dti,fli,'-')

%merge
[~,ia,ib]=intersect(dti,DT);
FL=NaN*ones(size(DT)); FL(ib)=fli(ia);

clearvars dt fl dt1 dt2 num t dti ia ib fli

%% pco2
%%%%pco2
    [pco2i,dt1,num] = groupsummary(fco2,dt,minutes(2),'mean','IncludeEmptyGroups',true);
    dt2=char(dt1);
    dti=datetime(cellstr(dt2(:,2:21)))+minutes(1); %add one minute so in between 2 min groups
    
    %add those datapoints back in
    t=timetable(pco2i,'RowTimes',dti); t=retime(t,'minutely');
    dti=t.Time; pco2i=t.pco2i;
    pco2i = fillmissing(pco2i,'linear','SamplePoints',dti,'MaxGap',minutes(5));
    %figure;plot(dt,fco2,'-',dti,pco2i,'-')
    
    [~,ia,ib]=intersect(dti,DT);
    PCO2=NaN*ones(size(DT)); PCO2(ib)=pco2i(ia);
    
    clearvars fco2 dt1 dt2 num t ia ib pco2i dti

%intake temperature
    [ssti,dt1,num] = groupsummary(sst,dt,minutes(2),'mean','IncludeEmptyGroups',true);
    dt2=char(dt1);
    dti=datetime(cellstr(dt2(:,2:21)))+minutes(1); %add one minute so in between 2 min groups
    
    %add those datapoints back in
    t=timetable(ssti,'RowTimes',dti); t=retime(t,'minutely');
    dti=t.Time; ssti=t.ssti;
    ssti = fillmissing(ssti,'linear','SamplePoints',dti,'MaxGap',minutes(5));

    %%
    figure;plot(dt,sst,'-',dti,ssti,'-')
    
    [~,ia,ib]=intersect(dti,DT);
    TEMPi=NaN*ones(size(DT)); TEMPi(ib)=ssti(ia);

clearvars dt sst dt1 dt2 num t ia ib ssti dti

%%
%figure; plot(LON(ib),LAT(ib),'o'); % test plot

save([filepath 'Data/environ_Shimada' yr],'DT','LON','LAT','TEMP','TEMPi','SAL','FL','PCO2');