%% merge phytoflash and moped data (2015-2018)

%addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/SFB/Data/MOPED_txt/')); % add new data to search path
indir = '~/Documents/UCSC_research/SanFranciscoBay/Data/';
outdir = '~/Documents/MATLAB/bloom-baby-bloom/SFB/Data/';

%% import 5 underway files from 2015-2016
UNdir = dir([[indir 'Underway/'] '*.xlsx']);

for ii=1:length(UNdir)
    UNid = [[filepath 'Underway/'] UNdir(ii).name];
    disp(UNdir(ii).name);
    opts = detectImportOptions(UNid);   
    opts.SelectedVariableNames={'Date','Time','Latitude','Longitude','Temperature','Conductivity','Salinity'};
    T=readtable(UNid,opts);

    lat=cell2mat(T.Latitude);
    LAT=NaN*ones(length(lat),2);
    for i=1:length(lat)
        var=lat(i,:);
        LAT(i,:)=str2num(var(5:end-2)); %remove first 4 letters and last 2 letters
    end
  
    lon=cell2mat(T.Longitude);
    LON=NaN*ones(length(lon),2);
    for i=1:length(lon)
        var=lon(i,:);
        LON(i,:)=str2num(var(5:end-2)); %remove first 4 letters and last 2 letters
    end
    
    date = char(T.Date);
    time = char(T.Time);
    dn=NaN*ones(length(time),1);
    for i=1:length(dn)
        d=date(i,:);
        t=time(i,:);
        dn(i)=datenum(datetime([2000+str2num(d(9:end)),str2num(d(7:8)),str2num(d(5:6)),str2num(t(5:6)),str2num(t(7:8)),str2num(t(9:end))]));    
    end

    time=datetime(dn,'ConvertFrom','datenum');
    time=time-hours(8);    
    time.TimeZone='America/Los_Angeles';       

    temp=cell2mat(T.Temperature);
    TEMP=NaN*ones(length(temp),1);
    for i=1:length(temp)
        var=temp(i,:);
        TEMP(i)=str2num(var(5:end));
    end

    con=cell2mat(T.Conductivity);
    CON=NaN*ones(length(con),1);
    for i=1:length(con)
        var=con(i,:);
        CON(i)=str2num(var(5:end));
    end

    sal=cell2mat(T.Salinity);
    SAL=NaN*ones(length(sal),1);
    for i=1:length(sal)
        var=sal(i,:);
        SAL(i)=str2num(var(5:end));
    end

    %remove the seconds component    
    time=datenum(datestr(datenum(time),'dd-mmm-yyyy HH:MM'));
    [dn,id,~]=unique(time);
    time=datetime(dn,'ConvertFrom','datenum');
    time.TimeZone='America/Los_Angeles';       
    
    tur=CON(id);
    sal=SAL(id);
    temp=TEMP(id);  
    lat=LAT(id,:);
    lon=LON(id,:);
    
    u(ii).day=datenum(datestr((dn(1)),'dd-mmm-yyyy'));
    u(ii).t0=datestr(datenum(dn(1)));    
    u(ii).time=time;
    u(ii).lat=dm2degrees([lat(:,1) lat(:,2)]);    % convert deg min to dd
    u(ii).lon=-dm2degrees([lon(:,1) lon(:,2)]);    % convert deg min to dd    
    u(ii).sal=sal;
    u(ii).temp=temp;
    u(ii).chl=NaN*temp;    
    u(ii).tur=NaN*temp;    

   clearvars day time LAT LON SAL TEMP CON lat lon var sal t con i temp dn date T UNid opts d
   
end

m=u;

%% import moped data

MOdir = dir([[indir 'MOPED/'] '*.txt']);
for i=1:length(MOdir)
    MOid = [[indir 'MOPED/'] MOdir(i).name];
    disp(MOdir(i).name);
    
    opts = detectImportOptions(MOid);   
    opts.SelectedVariableNames={'Date','LatDeg','LatMin','LonDeg','LonMin','Chlor','Turb','WaterTemp','Sal'};
    opts = setvaropts(opts,'Date','InputFormat','MM/dd/uuuu HH:mm:ss'); 
    Traw=readtable(MOid,opts);
    
    T=rmmissing(Traw); %remove rows w nan
    T=standardizeMissing(T,-999); 
        
    time=datenum(datestr(datenum(T.Date),'dd-mmm-yyyy HH:MM')); %remove the seconds component
    [dn,id,~]=unique(time);
          
    chl=T.Chlor(id);
    tur=T.Turb(id);
    sal=T.Sal(id);
    temp=T.WaterTemp(id);
    
    if chl==0
        chl(chl==0)=NaN;
    else
    end
    
    if tur==0
        tur(tur==0)=NaN;
    else
    end    
      
    if sal==0
        sal(sal==0)=NaN;
    else
    end
    
    if temp==0
        temp(temp==0)=NaN;
    else
    end        

    time=datetime(dn,'ConvertFrom','datenum');
    time.TimeZone='America/Los_Angeles';
    
    m(i+length(u)).day=datenum(datestr((time(1)),'dd-mmm-yyyy')); %remove the hours, minutes, seconds
    m(i+length(u)).t0=datestr(datenum(time(1)));
    m(i+length(u)).time=time;
    m(i+length(u)).lat=dm2degrees([T.LatDeg(id) T.LatMin(id)]);    % convert deg min to dd
    m(i+length(u)).lon=-dm2degrees(-[T.LonDeg(id) T.LonMin(id)]);    % convert deg min to dd
    m(i+length(u)).chl=chl;
    m(i+length(u)).tur=tur;
    m(i+length(u)).sal=sal;
    m(i+length(u)).temp=temp;
  
   clearvars Traw T opts MOid sal temp tur chl time
   
end
   
%% import phytoflash data
PHYdir = dir([[indir 'Phytoflash_raw/'] '*.txt']);
for i=1:length(PHYdir)
    Pid = [[indir 'Phytoflash_raw/'] PHYdir(i).name];
    disp(PHYdir(i).name);
    
    opts = detectImportOptions(Pid);   
    opts.VariableNames={'Date','Time','Fo','Fm','Blank','Fv','Yield'};
    opts = setvaropts(opts,'Date','InputFormat','MM/dd/yy');       
    Traw=readtable(Pid,opts);
    T=rmmissing(Traw); %remove rows w nan
    
    day=datenum(T.Date(1)); 
    T.Date.Format = 'dd-MMM-uuuu HH:mm:ss'; 
    time=datetime(T.Date)+T.Time;
    time=time-hours(8); 
    time.TimeZone='America/Los_Angeles';   
        
    pm(i).day=day;
    pm(i).t0=datestr(datenum(time(1)));
    pm(i).time=time;
    pm(i).dn=time;
    pm(i).Fo=T.Fo;
    pm(i).Fm=T.Fm;
    pm(i).Fv=T.Fv;
    pm(i).FvFm=T.Yield;
 
   clearvars Traw T opts day time;
    
end

for i=[1,44,46,47,48] %-8 hrs behind time
    pm(i).time=pm(i).time+hours(8);   
    pm(i).time.TimeZone='America/Los_Angeles';   
    pm(i).t0=datestr(datenum(pm(i).time(1)));    
end

%% merge moped and phytoflash
%i=1;
%j=1;
for i=1:length(pm)
    for j=1:length(m)
        if m(j).day == pm(i).day 
           % disp('yes')
             [C,ia,ib]  = intersect(pm(i).time,m(j).time); %C = A(ia,:) and C = B(ib,:) 
            PM(i).day=pm(i).day;             
            PM(i).time=C;
            PM(i).lat=m(j).lat(ib);
            PM(i).lon=m(j).lon(ib);
            PM(i).chl=m(j).chl(ib);
            PM(i).sal=m(j).sal(ib);
            PM(i).tur=m(j).tur(ib);
            PM(i).temp=m(j).temp(ib);            
            PM(i).Fo=pm(i).Fo(ia);
            PM(i).Fm=pm(i).Fm(ia);
            PM(i).Fv=pm(i).Fv(ia);
            PM(i).FvFm=pm(i).FvFm(ia);
            
        else
        end
    end
end

%% eliminate empty rows
PM = PM(~cellfun(@isempty,{PM.lat}));

save([outdir 'Phytoflash_2015-2018'],'PM');
