function [PM] = importPhytoflash_15_19(indir,outdir)
%% import and merge phytoflash and moped data (2015-2018)

addpath(genpath('~/Documents/UCSC_research/SanFranciscoBay/Data/')); % add new data to search path

%Example inputs
%indir = '~/Documents/UCSC_research/SanFranciscoBay/Data/';
%outdir = '~/MATLAB/bloom-baby-bloom/SFB/Data/';

%% import 4 underway files from 2015-2016

UNdir = dir([[indir 'MOPED/'] '*.xlsx']);

for ii=1:length(UNdir)
    
    UNid = [[indir 'MOPED/'] UNdir(ii).name];
    disp(UNdir(ii).name);
    opts = detectImportOptions(UNid);   
    opts.VariableNames = ["Day", "HHMMSS", "Latitude", "Longitude", "Temperature", "Conductivity", "Salinity"];
    opts.SelectedVariableNames = ["Day", "HHMMSS", "Latitude", "Longitude", "Temperature", "Conductivity", "Salinity"];
    opts.VariableTypes = ["double", "double", "categorical", "categorical", "double", "double", "double"];
    opts = setvaropts(opts, [3, 4], "EmptyFieldRule", "auto");
    T=readtable(UNid,opts);
   
    date = num2str(T.Day);
    time = num2str(T.HHMMSS);    
    dn=NaN*ones(length(time),1);    
    for i=1:length(dn)
        d=date(i,:);
        t=time(i,:);
        dn(i)=datenum(datetime([2000+str2num(d(1:2)),str2num(d(3:4)),str2num(d(5:6)),str2num(t(1:2)),str2num(t(3:4)),str2num(t(5:6))]));
    end       
    
    time=datenum(datestr(datenum(dn),'dd-mmm-yyyy HH:MM')); %remove the seconds component    
    [dn,id,~]=unique(time);
    time=datetime(dn,'ConvertFrom','datenum'); %time.TimeZone='GMT';       
        
    lat=char(T.Latitude);
    LAT=NaN*ones(length(lat),2);
    for i=1:length(lat)
        var=lat(i,:);
        LAT(i,:)=str2num(var(1:end-2)); %remove first 4 letters and last 2 letters
    end
  
    lon=char(T.Longitude);
    LON=NaN*ones(length(lon),2);
    for i=1:length(lon)
        var=lon(i,:);
        LON(i,:)=str2num(var(1:end-2)); %remove first 4 letters and last 2 letters
    end
     
    TEMP=T.Temperature;
    CON=T.Conductivity;
    SAL=T.Salinity;
    
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
    u(ii).tur=tur;    

   clearvars day time LAT LON SAL TEMP CON lat lon var sal t con i temp dn date T UNid opts d
   
end

m=u;

%% import moped data (2015-2019) 
MOdir = dir([[indir 'MOPED/'] '*.csv']);

for i=1:length(MOdir)
    
    MOid = [[indir 'MOPED/'] MOdir(i).name];
    disp(MOdir(i).name);
    
    opts = detectImportOptions(MOid);   
    opts.SelectedVariableNames = ["Date", "LatDeg", "LatMin", "LonDeg", "LonMin", "Chlor", "Turb", "Water_Temp", "Sal"];
    opts = setvaropts(opts, "Date", "InputFormat", "MM/dd/yy HH:mm");
    Traw=readtable(MOid,opts);
    
    T=rmmissing(Traw); %remove rows w nan
    T=standardizeMissing(T,-999); 
    T=standardizeMissing(T,0); 
      
    time=T.Date; %time.TimeZone='GMT';       
    [dn,id,~]=unique(time);
          
    chl=T.Chlor(id);
    tur=T.Turb(id);
    temp=T.Water_Temp(id);
    sal=T.Sal(id);             
    
    m(i+length(u)).day=datenum(datestr((dn(1)),'dd-mmm-yyyy')); %remove the hours, minutes, seconds
    m(i+length(u)).t0=datestr(datenum(dn(1)));
    m(i+length(u)).time=dn;
    m(i+length(u)).lat=dm2degrees([T.LatDeg(id) T.LatMin(id)]);    % convert deg min to dd
    m(i+length(u)).lon=-dm2degrees(-[T.LonDeg(id) T.LonMin(id)]);    % convert deg min to dd
    m(i+length(u)).chl=chl;
    m(i+length(u)).tur=tur;
    m(i+length(u)).sal=sal;
    m(i+length(u)).temp=temp;
  
   clearvars Traw T opts MOid sal temp tur chl time dn
   
end

clearvars u i ii UNdir MOdir id 

%% import phytoflash data
PHYdir = dir([[indir 'Phytoflash/'] '*.txt']);

for i=1:length(PHYdir)
    
    Pid = [[indir 'Phytoflash/'] PHYdir(i).name];
    disp(PHYdir(i).name);
    
    opts = detectImportOptions(Pid);   
    opts.VariableNames={'Date','Time','Fo','Fm','Blank','Fv','Yield'};
    opts = setvaropts(opts,'Date','InputFormat','MM/dd/yy');       
    Traw=readtable(Pid,opts);
    T=rmmissing(Traw); %remove rows w nan
    
    day=datenum(T.Date(1)); 
    T.Date.Format = 'dd-MMM-uuuu HH:mm:ss'; 
    time=datetime(T.Date)+T.Time; %time.TimeZone='GMT';  
        
    p(i).day=day;
    p(i).t0=datestr(datenum(time(1)));
    p(i).time=time;
    p(i).Fo=T.Fo;
    p(i).Fm=T.Fm;
 
   clearvars Traw T opts day time;
    
end

%correct time of 26-Aug-2015 data
p(1).time=p(1).time+hours(8); p(1).t0=datestr(datenum(p(1).time(1)));

%% merge moped and phytoflash
for i=1:length(p)
    for j=1:length(m)
        if m(j).day == p(i).day 
           % disp('yes')
             [C,ia,ib]  = intersect(p(i).time,m(j).time); %C = A(ia,:) and C = B(ib,:) 
            M(i).day=p(i).day;             
            M(i).time=C;
            M(i).lat=m(j).lat(ib);
            M(i).lon=m(j).lon(ib);
            M(i).chl=m(j).chl(ib);
            M(i).sal=m(j).sal(ib);
            M(i).tur=m(j).tur(ib);
            M(i).temp=m(j).temp(ib);            
            M(i).Fo=p(i).Fo(ia); 
            M(i).Fm=p(i).Fm(ia);
            
        else
        end
    end
end

% eliminate empty rows
M = M(~cellfun(@isempty,{M.lat}));

clearvars i ia ib j m PHYdir Pid p C
%% Now import already-merged Phytoflash-Underway data 2019

PM=M;

PHYdir = dir([[indir 'Phytoflash_merged_2019/'] '*.xlsx']);

for i=1:length(PHYdir)
    PHYid = [[indir 'Phytoflash_merged_2019/'] PHYdir(i).name];
    disp(PHYdir(i).name);

    opts = detectImportOptions(PHYid);   
    opts.SelectedVariableNames = ["Date", "LatDeg", "LatMin", "LonDeg", "LonMin", "Chlor_volts", "Turb", "Fluor_scufa", "Temp", "Sal", "Fo", "Fm", "Fv", "FvFm"];
    T=readtable(PHYid,opts);        
    
    time=datenum(datestr(datenum(T.Date),'dd-mmm-yyyy HH:MM')); %remove the seconds component        
    [dn,id,~]=unique(time);           
    time=datetime(dn,'ConvertFrom','datenum'); %time.TimeZone='GMT';  
    
    PM(i+length(M)).day=datenum(datestr((dn(1)),'dd-mmm-yyyy')); %remove the hours, minutes, seconds          
    PM(i+length(M)).time=time;
    PM(i+length(M)).lat=dm2degrees([T.LatDeg(id) T.LatMin(id)]);    % convert deg min to dd
    PM(i+length(M)).lon=-dm2degrees(-[T.LonDeg(id) T.LonMin(id)]);    % convert deg min to dd
    PM(i+length(M)).chl=T.Chlor_volts(id);
    PM(i+length(M)).sal=T.Sal(id);   
    PM(i+length(M)).tur=T.Turb(id);
    PM(i+length(M)).temp=T.Temp(id);    
    PM(i+length(M)).Fo=T.Fo(id);
    PM(i+length(M)).Fm=T.Fm(id);  
   
clearvars id T time dn opts
    
end

clearvars PHYdir PHYid

%%
save([outdir 'Phytoflash_2015-2019'],'PM');

end