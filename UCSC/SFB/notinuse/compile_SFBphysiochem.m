function [S,Si] = compile_SFBphysiochem(out_dir,cruises,deltaflow,distance_st18,phytoflash,correction)
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
% place variables into their own categories 
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

%% eliminate surveys without North Bay datapoints
for i=1:length(p)
    id=isnan(p(i).d18);
    p(i).st(id)=[];
    p(i).lat(id)=[];
    p(i).lon(id)=[];
    p(i).d18(id)=[];
    p(i).sal(id)=[];
    p(i).chl(id)=[];   
    p(i).chlpha(id)=[];
    p(i).light(id)=[];
    p(i).temp(id)=[];
    p(i).obs(id)=[];
    p(i).spm(id)=[];
    p(i).o2(id)=[];
    p(i).ni(id)=[];
    p(i).nina(id)=[];    
    p(i).amm(id)=[];    
    p(i).phos(id)=[];    
end
p(cellfun(@isempty,{p.st}))=[]; %remove empty rows

% remove all rows with less than one datapoint
del=zeros(length(p),1);
for i=1:length(p)
    val=sum(~isnan(p(i).d18));
    if val>1
    else
        del(i)=i;        
    end
end
del(del==0)=[]; p(del)=[];

% make sure cruise tracks go from marine to freshwater
for i=1:length(p) 
    if p(i).d18(1) > p(i).d18(end) %flip coordinates if doesn't go from marine to freshwater
        p(i).st=flip(p(i).st);        
        p(i).lat=flip(p(i).lat);
        p(i).lon=flip(p(i).lon);
        p(i).d18=flip(p(i).d18);        
        p(i).sal=flip(p(i).sal);
        p(i).chl=flip(p(i).chl);
        p(i).chlpha=flip(p(i).chlpha);        
        p(i).light=flip(p(i).light);
        p(i).temp=flip(p(i).temp);
        p(i).obs=flip(p(i).obs);        
        p(i).spm=flip(p(i).spm);
        p(i).o2=flip(p(i).o2);
        p(i).ni=flip(p(i).ni);        
        p(i).nina=flip(p(i).nina);
        p(i).amm=flip(p(i).amm);
        p(i).phos=flip(p(i).phos);                  
    else
    end
end

clearvars i ib ic id suisun i phys row val del id;

%% insert X2
load(deltaflow,'DN','X2','OUT');
for i=1:length(p)
    for j=1:length(DN)
        if DN(j) == datenum(p(i).dn)
            p(i).OUT=OUT(j)*60*60*24; %convert from m^3/s to m^3/day
            p(i).X2=X2(j);            
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

for i=1:length(p)
    if any(p(i).X2) %if there is an X2 value at that index
        id = find(round(p(i).X2) == (D18+4), 1); %add 4miles because distance from GG to Angel Island
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

clearvars i j X2 DN id OUT id LAT LON D18 deltaflow distance_st18;

%% insert existing data into new structure so 37 stations to facilitate pcolor
S=struct('dn',NaN*ones(length(p),1)); %preallocate 
for i=1:length(p)
    S(i).dn=datenum(p(i).dn);
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
    S(i).OUT=p(i).OUT;
    S(i).X2=p(i).X2;
    S(i).latX2=p(i).latX2;
    S(i).lonX2=p(i).lonX2;       
end
%%
for i=1:length(p)
    [id,~]=ismember(st,p(i).st);
    S(i).chl(id)=p(i).chl;
    S(i).phachl(id)=1-p(i).chlpha;  %change chlpha to phachl
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
    clearvars id
end

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
    Si(i).nina=fillmissing([S(i).nina],'movmean',5);
    Si(i).amm=fillmissing([S(i).amm],'movmean',5);
end

%%
save([out_dir 'Data/physical_param'],'S','Si');

end
