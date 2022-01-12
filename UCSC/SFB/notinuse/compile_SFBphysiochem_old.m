function [s] = compile_SFBphysiochem(out_dir,cruises,deltaflow,distance_st18,phytoflash,correction)
% load in Delta Flow data
% organize SFB data into structures for each cruise

% Example inputs
%  out_dir = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
%  cruises='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/parameters';
%  deltaflow='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/NetDeltaFlow';
%  distance_st18='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/st_lat_lon_d18';
%  phytoflash='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/Phytoflash_summary';
%  correction='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/correction_FvFm_PHA';

load(cruises,'phys');

% organize by unique surveys
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

%% organize station data into structures based on survey date
for i=1:length(p)
    p(i).st=[phys(p(i).a).st]'; 
    p(i).lat=[phys(p(i).a).lat]'; 
    p(i).lon=[phys(p(i).a).lon]';     
    p(i).d18=[phys(p(i).a).d18]';     
    p(i).chl=[phys(p(i).a).chl]';
    p(i).chlpha=[phys(p(i).a).chlpha]';
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
end
p=rmfield(p,'a');

% eliminate surveys without North Bay datapoints
for i=1:length(p)
    if max(p(i).d18) >= 20 
        p(i).suisun=1;
    else
        p(i).suisun=0;
    end
end
[row,~]=find([p.suisun]');
s=p(row); s=rmfield(s,'suisun');
clearvars suisun i phys row p;

% make sure cruise tracks go from marine to freshwater
for i=1:length(s) 
    if s(i).lat(1) > s(i).lat(end) %flip coordinates if doesn't go from marine to freshwater
        s(i).st=flip(s(i).st);        
        s(i).lat=flip(s(i).lat);
        s(i).lon=flip(s(i).lon);
        s(i).d18=flip(s(i).d18);        
        s(i).chl=flip(s(i).chl);
        s(i).chlpha=flip(s(i).chlpha);
        s(i).light=flip(s(i).light);
        s(i).temp=flip(s(i).temp);
        s(i).sal=flip(s(i).sal);
        s(i).obs=flip(s(i).obs);
        s(i).spm=flip(s(i).spm);
        s(i).o2=flip(s(i).o2);
        s(i).ni=flip(s(i).ni);
        s(i).nina=flip(s(i).nina);
        s(i).amm=flip(s(i).amm);
        s(i).phos=flip(s(i).phos);
    else
    end
end

% remove points before station 18
for i=1:length(s)
    id=find(s(i).d18==min(s(i).d18));
    s(i).st(1:id-1)=[]; 
    s(i).lat(1:id-1)=[]; 
    s(i).lon(1:id-1)=[]; 
    s(i).d18(1:id-1)=[];         
    s(i).chl(1:id-1)=[]; 
    s(i).chlpha(1:id-1)=[]; 
    s(i).light(1:id-1)=[]; 
    s(i).temp(1:id-1)=[]; 
    s(i).sal(1:id-1)=[]; 
    s(i).obs(1:id-1)=[]; 
    s(i).spm(1:id-1)=[]; 
    s(i).o2(1:id-1)=[]; 
    s(i).ni(1:id-1)=[]; 
    s(i).nina(1:id-1)=[]; 
    s(i).amm(1:id-1)=[]; 
    s(i).phos(1:id-1)=[]; 
end

clearvars 18 i ib ic id;

%% insert X2
load(deltaflow,'DN','X2','OUT');
for i=1:length(s)
    for j=1:length(DN)
        if DN(j) == datenum(s(i).dn)
            s(i).OUT=OUT(j)*60*60*24; %convert from m^3/s to m^3/day
            s(i).X2=X2(j);            
        else                
        end
    end
end    

% find lat lon coordinates of X2
load(distance_st18,'d18','st','lat','lon');
id=find(d18==0); d18(1:id-1)=[]; lat(1:id-1)=[]; lon(1:id-1)=[]; st(1:id-1)=[];
D18=(round(d18(1)):1:round(d18(end)))';
LAT=interp1(d18,lat,D18); LAT(end)=lat(end);
LON=interp1(d18,lon,D18); LON(end)=lon(end);

for i=1:length(s)
    if any(s(i).X2) %if there is an X2 value at that index
        id = find(round(s(i).X2) == (D18+4), 1); %add 4miles because distance from GG to Angel Island
        s(i).latX2 = LAT(id);
        s(i).lonX2 = LON(id);
        clearvars id
    else
    end
end

for i=1:length(s)
   if isempty(s(i).X2) 
    s(i).X2=NaN;
    s(i).OUT=NaN;
    s(i).latX2=NaN;
    s(i).lonX2=NaN;
   else
   end
end

clearvars i j X2 DN id OUT id LAT LON D18 deltaflow distance_st18;

%% insert existing data into new structure so 37 stations to facilitate pcolor
S=struct('dn',NaN*ones(length(s),1)); %preallocate 
for i=1:length(s)
    S(i).dn=datenum(s(i).dn);
    S(i).st=st; 
    S(i).lat=lat;
    S(i).lon=lon;
    S(i).d18=d18;
    S(i).chl=NaN*st; 
    S(i).phachl=NaN*st; %add phachl instead of chlpha    
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
    S(i).OUT=s(i).OUT;
    S(i).X2=s(i).X2;
    S(i).latX2=s(i).latX2;
    S(i).lonX2=s(i).lonX2;       
end

for i=1:length(s)
    [~,id]=ismember(st,s(i).st);
    S(i).chl(id)=s(i).chl;
    S(i).phachl(id)=1-s(i).chlpha;  %change chlpha to phachl
    S(i).temp(id)=s(i).temp;
    S(i).sal(id)=s(i).sal;
    S(i).light(id)=s(i).light;    
    S(i).obs(id)=s(i).obs;
    S(i).spm(id)=s(i).spm;
    S(i).o2(id)=s(i).o2;    
    S(i).ni(id)=s(i).ni;
    S(i).nina(id)=s(i).nina;
    S(i).amm(id)=s(i).amm;
    S(i).phos(id)=s(i).phos;
    clearvars id
end

S([S.dn]==datenum('11-Jan-2017'))=[]; %remove bad datapoint

clearvars d18 i lat lon st ;

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
    Si(i).nina=fillmissing([S(i).nina],'movmean',6);
    Si(i).amm=fillmissing([S(i).amm],'movmean',5);
end

%%
save([out_dir 'Data/physical_param'],'s','S','Si');

end
