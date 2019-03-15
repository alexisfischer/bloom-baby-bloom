addpath(genpath('~/Documents/UCSC_research/SanFranciscoBay/Phytoflash/Underway/')); % add new data to search path

% import raw phytoflash data
in_dir_base = '~/Documents/UCSC_research/SanFranciscoBay/Phytoflash/Underway/';
out_dir = '~/Documents/MATLAB/bloom-baby-bloom/SFB/Data/';

filedir = dir([in_dir_base '*_flowthru.xlsx']);
%filedir = dir([in_dir_base '*_moped.xlsx']);

%ii=1;
for ii=1:length(filedir)
    filename = [in_dir_base filedir(ii).name];
    
    opts = detectImportOptions(filename);   
    
    opts.SelectedVariableNames={'t_temperature__C_','c_conductivity_S_m_',...
        's_salinity','Latitude','Longitude','hms_hours_Minutes_Seconds',...
        'dmy_day_dd__Month_mm__Year_yy_'};

    T=readtable(filename,opts);

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

    date = char(T.dmy_day_dd__Month_mm__Year_yy_(1));
    day=datenum(datetime([2000+str2num(date(9:end)), str2num(date(7:8)), str2num(var(5:6))]));

    date = char(T.dmy_day_dd__Month_mm__Year_yy_);
    time = char(T.hms_hours_Minutes_Seconds);
    dn=NaN*ones(length(time),1);
    for i=1:length(time)
        d=date(i,:);
        t=time(i,:);
        dn(i)=datenum(datetime([2000+str2num(d(9:end)),str2num(d(7:8)),str2num(d(5:6)),str2num(t(5:6)),str2num(t(7:8)),str2num(t(9:end))]));    
    end

    temp=cell2mat(T.t_temperature__C_);
    TEMP=NaN*ones(length(temp),1);
    for i=1:length(temp)
        var=temp(i,:);
        TEMP(i)=str2num(var(5:end));
    end

    con=cell2mat(T.c_conductivity_S_m_);
    CON=NaN*ones(length(con),1);
    for i=1:length(con)
        var=con(i,:);
        CON(i)=str2num(var(5:end));
    end

    sal=cell2mat(T.s_salinity);
    SAL=NaN*ones(length(sal),1);
    for i=1:length(sal)
        var=sal(i,:);
        SAL(i)=str2num(var(5:end));
    end

    F(ii).day=day;
    F(ii).dn=dn;
    F(ii).lat=LAT;
    F(ii).lon=LON;
    F(ii).sal=SAL;
    F(ii).temp=TEMP;
    F(ii).con=CON;

    clearvars sal con temp time date t d i var lon lat opts T day dn LAT LON SAL TEMP CON;
    
end

