function[S,Si]=import_USGS_cruisedata(filepath,filename,deltaflow,distance,phytoflash,correction,DepthMLD)
%% import USGS cruise data for 2013-present
% Example inputs
%  filepath='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
%  filename="/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/sfb_raw_2013-present.xlsx";
%  deltaflow='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/NetDeltaFlow';
%  distance='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/st_lat_lon_distance';
%  phytoflash='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/Phytoflash_summary';
%  correction='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/correction_FvFm_PHA';
%  DepthMLD='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/integratedSal_MLD';

%% Import data from excel
opts = spreadsheetImportOptions("NumVariables", 17);
opts.Sheet = "new";
opts.DataRange = "A3:Q3797";
opts.VariableNames = ["Date", "IFCB", "StationNumber", "Distancefrom36", "CalculatedChlorophyll", "ChlorophyllaaPHA", "CalculatedOxygen", "OpticalBackscatter", "CalculatedSPM", "MeasuredExtinctionCoefficient", "Salinity", "Temperature", "Nitrite", "NitrateNitrite", "Ammonium", "Phosphate", "Silicate"];
opts.SelectedVariableNames = ["Date", "IFCB", "StationNumber", "Distancefrom36", "CalculatedChlorophyll", "ChlorophyllaaPHA", "CalculatedOxygen", "OpticalBackscatter", "CalculatedSPM", "MeasuredExtinctionCoefficient", "Salinity", "Temperature", "Nitrite", "NitrateNitrite", "Ammonium", "Phosphate", "Silicate"];
opts.VariableTypes = ["datetime", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, 1, "InputFormat", "");
opts = setvaropts(opts, 2, "WhitespaceRule", "preserve");
opts = setvaropts(opts, 2, "EmptyFieldRule", "auto");
tbl = readtable(filename, opts, "UseExcel", false);

Date = tbl.Date;
IFCB = tbl.IFCB;
StationNumber = tbl.StationNumber;
Distancefrom36 = tbl.Distancefrom36;
CalculatedChlorophyll = tbl.CalculatedChlorophyll;
PhaChl = 1-tbl.ChlorophyllaaPHA;
CalculatedOxygen = tbl.CalculatedOxygen;
OpticalBackscatter = tbl.OpticalBackscatter;
CalculatedSPM = tbl.CalculatedSPM;
Salinity = tbl.Salinity;
Temperature = tbl.Temperature;
Nitrite = tbl.Nitrite;
NitrateNitrite = tbl.NitrateNitrite;
Ammonium = tbl.Ammonium;
Phosphate = tbl.Phosphate;
Silicate = tbl.Silicate;
Light = tbl.MeasuredExtinctionCoefficient;
Date=datenum(Date);
[Latitude,Longitude,D19] = match_st_lat_lon(StationNumber);

clearvars opts tbl

%% put in structure
phys=struct('dn',NaN*ones(length(Date),1)); %preallocate
for i=1:length(Date)
    phys(i).dn=Date(i);
    phys(i).filename=IFCB(i);
    phys(i).st=StationNumber(i);
    phys(i).lat=Latitude(i);
    phys(i).lon=Longitude(i);
    phys(i).d19=D19(i);    
    phys(i).d36=Distancefrom36(i);    
    phys(i).sal=pl33tn(Salinity(i));    
    phys(i).light=pl33tn(Light(i));
    phys(i).chl=pl33tn(CalculatedChlorophyll(i));
    phys(i).phachl=pl33tn(PhaChl(i));
    phys(i).o2=pl33tn(CalculatedOxygen(i));    
    phys(i).temp=pl33tn(Temperature(i));
    phys(i).obs=pl33tn(OpticalBackscatter(i));
    phys(i).spm=CalculatedSPM(i);
    phys(i).ni=Nitrite(i);
    phys(i).nina=NitrateNitrite(i);
    phys(i).amm=Ammonium(i);
    phys(i).phos=Phosphate(i);
    phys(i).sil=Silicate(i);
end

clearvars Ammonium CalculatedChlorophyll CalculatedOxygen CalculatedSPM...
    PhaChl D19 Date Distancefrom36 filename IFCB Latitude Light Longitude...
    NitrateNitrite Nitrite OpticalBackscatter Phosphate Salinity StationNumber...
    Temperature i Silicate;

%% organize by unique surveys
[C,IA,~] = unique([phys.dn]);
p=struct('dn',NaN*ones(length(C),1)); %preallocate 
for i=1:length(C)
    if i<length(C)
        p(i).a=(IA(i):(IA(i+1)-1));        
        p(i).dn=datestr(C(i));
        else
        p(i).a=(IA(i):length(phys));        
        p(i).dn=datestr(C(i));        
    end
end
clearvars i IA j C cruises ;

% organize station data into structures based on survey date and place variables into their own categories 
for i=1:length(p)
    p(i).st=[phys(p(i).a).st]'; 
    p(i).lat=[phys(p(i).a).lat]'; 
    p(i).lon=[phys(p(i).a).lon]';     
    p(i).d19=[phys(p(i).a).d19]';     
    p(i).chl=[phys(p(i).a).chl]';
    p(i).phachl=[phys(p(i).a).phachl]';
    p(i).light=[phys(p(i).a).light]';        
    p(i).temp=[phys(p(i).a).temp]';    
    p(i).sal=[phys(p(i).a).sal]';  
    p(i).obs=[phys(p(i).a).obs]';
    p(i).spm=[phys(p(i).a).spm]';
    p(i).o2=[phys(p(i).a).o2]';  
    p(i).ni=[phys(p(i).a).ni]';
    p(i).nina=[phys(p(i).a).nina]';
    p(i).amm=[phys(p(i).a).amm]';
    p(i).phos=[phys(p(i).a).phos]';
    p(i).sil=[phys(p(i).a).sil]';
end
p=rmfield(p,'a');

%% eliminate surveys without North Bay datapoints
for i=1:length(p)
    id=isnan(p(i).d19);
    p(i).st(id)=[];
    p(i).lat(id)=[];
    p(i).lon(id)=[];
    p(i).d19(id)=[];
    p(i).sal(id)=[];
    p(i).chl(id)=[];   
    p(i).phachl(id)=[];
    p(i).light(id)=[];
    p(i).temp(id)=[];
    p(i).obs(id)=[];
    p(i).spm(id)=[];
    p(i).o2(id)=[];
    p(i).ni(id)=[];
    p(i).nina(id)=[];    
    p(i).amm(id)=[];    
    p(i).phos(id)=[];    
    p(i).sil(id)=[];        
end
p(cellfun(@isempty,{p.st}))=[]; %remove empty rows

% remove all rows with less than one datapoint
del=zeros(length(p),1);
for i=1:length(p)
    val=sum(~isnan(p(i).d19));
    if val>1
    else
        del(i)=i;        
    end
end
del(del==0)=[]; p(del)=[];

% make sure cruise tracks go from marine to freshwater
for i=1:length(p) 
    if p(i).d19(1) > p(i).d19(end) %flip coordinates if doesn't go from marine to freshwater
        p(i).st=flip(p(i).st);        
        p(i).lat=flip(p(i).lat);
        p(i).lon=flip(p(i).lon);
        p(i).d19=flip(p(i).d19);        
        p(i).sal=flip(p(i).sal);
        p(i).chl=flip(p(i).chl);
        p(i).phachl=flip(p(i).phachl);        
        p(i).light=flip(p(i).light);
        p(i).temp=flip(p(i).temp);
        p(i).obs=flip(p(i).obs);        
        p(i).spm=flip(p(i).spm);
        p(i).o2=flip(p(i).o2);
        p(i).ni=flip(p(i).ni);        
        p(i).nina=flip(p(i).nina);
        p(i).amm=flip(p(i).amm);
        p(i).phos=flip(p(i).phos);                  
        p(i).sil=flip(p(i).sil);                  
    else
    end
end

clearvars i ib ic id suisun i phys row val del id;

%% insert X2
load(deltaflow,'DN','X2','OUT');
for i=1:length(p)
    for j=1:length(DN)
        if DN(j) == datenum(p(i).dn)
            p(i).OUT=OUT(j);
            p(i).X2=X2(j);            
        else                
        end
    end
end    

% find lat lon coordinates of X2
load(distance,'d19','st','lat','lon');
id=find(d19>0,1); d19(1:id-1)=[]; lat(1:id-1)=[]; lon(1:id-1)=[]; st(1:id-1)=[];
D19=(round(d19(1)):1:round(d19(end)))';
LAT=interp1(d19,lat,D19); LAT(end)=lat(end);
LON=interp1(d19,lon,D19); LON(end)=lon(end);

for i=1:length(p)
    if any(p(i).X2) %if there is an X2 value at that index
        id = find(round(p(i).X2) == D19,1);
        p(i).latX2 = LAT(id);
        p(i).lonX2 = LON(id);
        clearvars id
    else
    end
end

for i=1:length(p)
   if isempty(p(i).X2) 
    p(i).X2=NaN;
    p(i).OUT=NaN;
    p(i).latX2=NaN;
    p(i).lonX2=NaN;
   else
   end
end

clearvars i j X2 DN id OUT id LAT LON D19 deltaflow distance;

%% insert existing data into new structure so 20 stations to facilitate pcolor
S=struct('dn',NaN*ones(length(p),1)); %preallocate 
for i=1:length(p)
    S(i).dn=datenum(p(i).dn);
    S(i).st=st; 
    S(i).lat=lat;
    S(i).lon=lon;
    S(i).d19=d19;
    S(i).chl=NaN*st; 
    S(i).phachl=NaN*st; 
    S(i).FvFm=NaN*st;        
    S(i).FvFmA=NaN*st;        
    S(i).light=NaN*st;     
    S(i).temp=NaN*st; 
    S(i).sal=NaN*st; 
    S(i).obs=NaN*st; 
    S(i).spm=NaN*st; 
    S(i).o2=NaN*st;     
    S(i).ni=NaN*st; 
    S(i).nina=NaN*st; 
    S(i).amm=NaN*st; 
    S(i).phos=NaN*st; 
    S(i).sil=NaN*st;     
    S(i).OUT=p(i).OUT;
    S(i).X2=p(i).X2;
    S(i).latX2=p(i).latX2;
    S(i).lonX2=p(i).lonX2;       
end

for i=1:length(p)
    [id,~]=ismember(st,p(i).st);
    S(i).chl(id)=p(i).chl;
    S(i).phachl(id)=p(i).phachl; 
    S(i).temp(id)=p(i).temp;
    S(i).sal(id)=p(i).sal;
    S(i).light(id)=p(i).light;    
    S(i).obs(id)=p(i).obs;
    S(i).spm(id)=p(i).spm;
    S(i).o2(id)=p(i).o2;    
    S(i).ni(id)=p(i).ni;
    S(i).nina(id)=p(i).nina;
    S(i).amm(id)=p(i).amm;
    S(i).phos(id)=p(i).phos;
    S(i).sil(id)=p(i).sil;    
    clearvars id
end

clearvars d19 i lat lon st ;

%% merge phytoflash data
load(phytoflash,'P'); 
load(correction,'cf','r');
r=round(r,2);

for i=1:length(S)
    if length(~isnan(S(i).phachl))>2
         S(i).phachl=fillmissing([S(i).phachl],'movmean',5);        
    else
    end
    for j=1:length(P)    
        if P(j).dn == S(i).dn
            S(i).FvFm=NaN*ones(size(S(i).st));            
            [~,ia,ib]=intersect(P(j).st,S(i).st);  
            S(i).FvFm(ib)=P(j).FvFm(ia); 
            S(i).phachl=round(S(i).phachl,2); %round to two decimal places                           
        else
        end
    end
end    

[~,~,ib]=intersect([P.dn],[S.dn]);
for i=1:length(ib)
    ii=ib(i);
    for j=1:length(S(ii).phachl)
        R=S(ii).phachl(j);
        if isnan(R)
        else
            S(ii).FvFmA(j)=S(ii).FvFm(j)+cf(R==r);
        end
    end
end
      
clearvars i j ia ib ii cf r P R id phytoflash correction;

%% add MLD and integrated salinity and chlorophyll to S
load(DepthMLD,'Mi');

for i=1:length(S)
    for j=1:length(Mi)        
        if Mi(j).dn == S(i).dn
            S(i).mld=Mi(j).mld1;
            S(i).salI=Mi(j).salI;
            S(i).chlI=Mi(j).chlI;
        else
        end
    end
end

clearvars i idx Mi DepthMLD

%% interpolate
Si=S;
for i=1:length(S)
    Si(i).chl=fillmissing([S(i).chl],'movmean',5);
    Si(i).FvFm=fillmissing([S(i).FvFm],'movmean',5);
    Si(i).FvFmA=fillmissing([S(i).FvFmA],'movmean',5);
    Si(i).temp=fillmissing([S(i).temp],'movmean',5);
    Si(i).sal=fillmissing([S(i).sal],'movmean',5);
    Si(i).light=fillmissing([S(i).light],'movmean',5);    
    Si(i).obs=fillmissing([S(i).obs],'movmean',5);
    Si(i).spm=fillmissing([S(i).spm],'movmean',5);
    Si(i).ni=fillmissing([S(i).ni],'movmean',5);
    Si(i).nina=fillmissing([S(i).nina],'movmean',5);
    Si(i).amm=fillmissing([S(i).amm],'movmean',5); 
    Si(i).phos=fillmissing([S(i).phos],'movmean',5); 
    Si(i).sil=fillmissing([S(i).sil],'movmean',5); 
end

%%
save([filepath 'Data/physical_param'],'S','Si');

end