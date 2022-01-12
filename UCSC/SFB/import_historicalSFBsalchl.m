function[P,Pi]=import_historicalSFBsalchl(filepath,distance,depth)
% import long timeseries of SFB salinity, chl, and chlpha
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

% filepath='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
% distance=[filepath 'Data/st_lat_lon_distance'];
% depth=1;
% depth=2;

if depth==1
    sal_file="/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/sfb_salinity_1m_1969-present.xlsx";
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = "Sheet1";
    opts.DataRange = "A1:E19711"; %1m
    opts.VariableNames = ["Date", "st", "chl_discrete", "chl", "sal"];
    opts.SelectedVariableNames = ["Date", "st", "chl_discrete", "chl", "sal"];
elseif depth==2
    sal_file="/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/sfb_salinity_2m_1969-present.xlsx";
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = "Sheet1";
    opts.DataRange = "A1:E19438"; 
    opts.VariableNames = ["Date", "st", "chlpha", "chl", "sal"];
    opts.SelectedVariableNames = ["Date", "st", "chlpha", "chl", "sal"];
end

opts.VariableTypes = ["datetime", "double", "double", "double", "double"];
opts = setvaropts(opts, 1, "InputFormat", "");
T = readtable(sal_file, opts, "UseExcel", false);

dn=datenum(T.Date);
st=T.st;
chl=T.chl;
sal=T.sal;
[Latitude,Longitude,D19] = match_st_lat_lon(st);

% organize data with respect to space and time
ss=struct('dn',NaN*ones(length(dn),1)); %preallocate
for i=1:length(dn)
    ss(i).dn=dn(i);
    ss(i).st=st(i);
    ss(i).lat=Latitude(i);
    ss(i).lon=Longitude(i);    
    ss(i).d19=D19(i);        
    ss(i).sal=sal(i);
    ss(i).chl=chl(i);
end    
clearvars T opts sal_file Latitude Longitude D19 sal chl dn st i;

%% organize by unique surveys
[C,IA,~] = unique([ss.dn]);
id=isnan(C); C(id)=[]; IA(id)=[]; %remove weird nans

pp=struct('dn',NaN*ones(length(C),1)); %preallocate 
for i=1:length(C)
    if i<length(C)
        pp(i).a=(IA(i):(IA(i+1)-1));        
        pp(i).dn=C(i);
        else
        pp(i).a=(IA(i):length(ss));        
        pp(i).dn=C(i);        
    end
end

% place variables into their own categories 
for i=1:length(pp)
    pp(i).st=[ss(pp(i).a).st]'; 
    pp(i).lat=[ss(pp(i).a).lat]'; 
    pp(i).lon=[ss(pp(i).a).lon]';     
    pp(i).d19=[ss(pp(i).a).d19]';     
    pp(i).sal=[ss(pp(i).a).sal]';         
    pp(i).chl=[ss(pp(i).a).chl]';
end
pp=rmfield(pp,'a');
clearvars C i IA ss id;

%% eliminate surveys without North Bay datapoints
for i=1:length(pp)
    id=isnan(pp(i).d19);
    pp(i).st(id)=[];
    pp(i).lat(id)=[];
    pp(i).lon(id)=[];
    pp(i).d19(id)=[];
    pp(i).sal(id)=[];
    pp(i).chl(id)=[];
end
pp(cellfun(@isempty,{pp.st}))=[]; %remove empty rows

% remove all rows with less than one datapoint
del=zeros(length(pp),1);
for i=1:length(pp)
    val=sum(~isnan(pp(i).d19));
    if val>1
    else
        del(i)=i;        
    end
end
del(del==0)=[]; pp(del)=[];

% make sure cruise tracks go from marine to freshwater
for i=1:length(pp) 
    if pp(i).d19(1) > pp(i).d19(end) %flip coordinates if doesn't go from marine to freshwater
        pp(i).st=flip(pp(i).st);        
        pp(i).lat=flip(pp(i).lat);
        pp(i).lon=flip(pp(i).lon);
        pp(i).d19=flip(pp(i).d19);        
        pp(i).sal=flip(pp(i).sal);
        pp(i).chl=flip(pp(i).chl);
    else
    end
end

clearvars i ib ic id suisun i phys row val del id;

%% insert existing data into new structure so 20 stations to facilitate pcolor
load(distance,'d19','st','lat','lon');
id=find(d19>0,1); d19(1:id-1)=[]; lat(1:id-1)=[]; lon(1:id-1)=[]; st(1:id-1)=[]; %remove points south of st 18

P=struct('dn',NaN*ones(length(pp),1)); %preallocate 
for i=1:length(pp)
    P(i).dn=pp(i).dn;
    P(i).st=st; 
    P(i).lat=lat;
    P(i).lon=lon;
    P(i).d19=d19;
    P(i).sal=NaN*st; 
    P(i).chl=NaN*st;       
end

% insert existing data into new structure
for i=1:length(pp)
    [ia,~]=ismember(st,pp(i).st);
    P(i).sal(ia)=pp(i).sal;
    P(i).chl(ia)=pp(i).chl;    
end

% interpolate
Pi=P;
for i=1:length(P)
    Pi(i).chl=fillmissing([P(i).chl],'movmean',5);
    Pi(i).sal=fillmissing([P(i).sal],'movmean',5);
end

clearvars d19 i lat lon st ia id distance;

save([filepath 'Data/salPOD_' num2str(depth) 'm'],'P','Pi');%import long timeseries of SFB salinity, chl, and chlpha
clear
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

filepath='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
distance=[filepath 'Data/st_lat_lon_distance'];

depth=1;
%depth=2;

if depth==1
    sal_file="/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/sfb_salinity_1m_1969-present.xlsx";
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = "Sheet1";
    opts.DataRange = "A1:E19711"; %1m
    opts.VariableNames = ["Date", "st", "chl_discrete", "chl", "sal"];
    opts.SelectedVariableNames = ["Date", "st", "chl_discrete", "chl", "sal"];
elseif depth==2
    sal_file="/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/sfb_salinity_2m_1969-present.xlsx";
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = "Sheet1";
    opts.DataRange = "A1:E19438"; 
    opts.VariableNames = ["Date", "st", "chlpha", "chl", "sal"];
    opts.SelectedVariableNames = ["Date", "st", "chlpha", "chl", "sal"];
end

opts.VariableTypes = ["datetime", "double", "double", "double", "double"];
opts = setvaropts(opts, 1, "InputFormat", "");
T = readtable(sal_file, opts, "UseExcel", false);

dn=datenum(T.Date);
st=T.st;
chl=T.chl;
sal=T.sal;
[Latitude,Longitude,D19] = match_st_lat_lon(st);

% organize data with respect to space and time
ss=struct('dn',NaN*ones(length(dn),1)); %preallocate
for i=1:length(dn)
    ss(i).dn=dn(i);
    ss(i).st=st(i);
    ss(i).lat=Latitude(i);
    ss(i).lon=Longitude(i);    
    ss(i).d19=D19(i);        
    ss(i).sal=sal(i);
    ss(i).chl=chl(i);
end    
clearvars T opts sal_file Latitude Longitude D19 sal chl dn st i;

%% organize by unique surveys
[C,IA,~] = unique([ss.dn]);
id=isnan(C); C(id)=[]; IA(id)=[]; %remove weird nans

pp=struct('dn',NaN*ones(length(C),1)); %preallocate 
for i=1:length(C)
    if i<length(C)
        pp(i).a=(IA(i):(IA(i+1)-1));        
        pp(i).dn=C(i);
        else
        pp(i).a=(IA(i):length(ss));        
        pp(i).dn=C(i);        
    end
end

% place variables into their own categories 
for i=1:length(pp)
    pp(i).st=[ss(pp(i).a).st]'; 
    pp(i).lat=[ss(pp(i).a).lat]'; 
    pp(i).lon=[ss(pp(i).a).lon]';     
    pp(i).d19=[ss(pp(i).a).d19]';     
    pp(i).sal=[ss(pp(i).a).sal]';         
    pp(i).chl=[ss(pp(i).a).chl]';
end
pp=rmfield(pp,'a');
clearvars C i IA ss id;

%% eliminate surveys without North Bay datapoints
for i=1:length(pp)
    id=isnan(pp(i).d19);
    pp(i).st(id)=[];
    pp(i).lat(id)=[];
    pp(i).lon(id)=[];
    pp(i).d19(id)=[];
    pp(i).sal(id)=[];
    pp(i).chl(id)=[];
end
pp(cellfun(@isempty,{pp.st}))=[]; %remove empty rows

% remove all rows with less than one datapoint
del=zeros(length(pp),1);
for i=1:length(pp)
    val=sum(~isnan(pp(i).d19));
    if val>1
    else
        del(i)=i;        
    end
end
del(del==0)=[]; pp(del)=[];

% make sure cruise tracks go from marine to freshwater
for i=1:length(pp) 
    if pp(i).d19(1) > pp(i).d19(end) %flip coordinates if doesn't go from marine to freshwater
        pp(i).st=flip(pp(i).st);        
        pp(i).lat=flip(pp(i).lat);
        pp(i).lon=flip(pp(i).lon);
        pp(i).d19=flip(pp(i).d19);        
        pp(i).sal=flip(pp(i).sal);
        pp(i).chl=flip(pp(i).chl);
    else
    end
end

clearvars i ib ic id suisun i phys row val del id;

%% insert existing data into new structure so 20 stations to facilitate pcolor
load(distance,'d19','st','lat','lon');
id=find(d19>0,1); d19(1:id-1)=[]; lat(1:id-1)=[]; lon(1:id-1)=[]; st(1:id-1)=[]; %remove points south of st 18

P=struct('dn',NaN*ones(length(pp),1)); %preallocate 
for i=1:length(pp)
    P(i).dn=pp(i).dn;
    P(i).st=st; 
    P(i).lat=lat;
    P(i).lon=lon;
    P(i).d19=d19;
    P(i).sal=NaN*st; 
    P(i).chl=NaN*st;       
end

% insert existing data into new structure
for i=1:length(pp)
    [ia,~]=ismember(st,pp(i).st);
    P(i).sal(ia)=pp(i).sal;
    P(i).chl(ia)=pp(i).chl;    
end

% interpolate
Pi=P;
for i=1:length(P)
    Pi(i).chl=fillmissing([P(i).chl],'movmean',5);
    Pi(i).sal=fillmissing([P(i).sal],'movmean',5);
end

clearvars d19 i lat lon st ia id distance;

save([filepath 'Data/salPOD_' num2str(depth) 'm'],'P','Pi');

end