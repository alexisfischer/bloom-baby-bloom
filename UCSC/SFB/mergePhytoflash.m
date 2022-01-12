function [P,Pi] = mergePhytoflash(data1215,data1519,outdir)
%% merge Phytoflash data from 2012-2015 and 2015-2019 into one file

clear
% %Example inputs
% data1215='~/MATLAB/bloom-baby-bloom/SFB/Data/Phytoflash_2012-2015';
% data1519='~/MATLAB/bloom-baby-bloom/SFB/Data/Phytoflash_2015-2019';
% outdir='~/MATLAB/bloom-baby-bloom/SFB/';

%load in data
load(data1215,'p'); load(data1519,'PM');

%% merge 2012-2015 and 2015-2019 Phytoflash data
total=(length(p)+length(PM));
start=length(p);
for i=(start+1):total
    j=i-start;
    p(i).dn=PM(j).day;
    p(i).lat=PM(j).lat;
    p(i).lon=PM(j).lon;
    p(i).chl=PM(j).chl;
    p(i).tur=PM(j).tur;
    p(i).sal=PM(j).sal;
    p(i).temp=PM(j).temp;
    p(i).Fo=PM(j).Fo;
    p(i).Fm=PM(j).Fm;
end

% low pass filter Fo and Fm and calculate FvFm
for i=1:length(p)
    p(i).Fo=pl33tn(p(i).Fo);
    p(i).Fm=pl33tn(p(i).Fm);
    p(i).FvFm=(p(i).Fm-p(i).Fo)./p(i).Fm;
end

% eliminate surveys without North Bay datapoints
for i=1:length(p)
    if max(p(i).lat) >= 38 
        p(i).suisun=1;
    else
        p(i).suisun=0;
    end
end

[row,~]=find([p.suisun]');
P=p(row); P=rmfield(P,'suisun');

clearvars PM i j start total data1215 data1519 p row

%% make sure cruise tracks go from marine to freshwater
for i=1:length(P) 
    if P(i).lat(1) > P(i).lat(end) %flip coordinates if doesn't go from marine to freshwater
        P(i).lat=flip(P(i).lat);
        P(i).lon=flip(P(i).lon);
        P(i).chl=flip(P(i).chl);
        P(i).tur=flip(P(i).tur);
        P(i).sal=flip(P(i).sal);
        P(i).temp=flip(P(i).temp);
        P(i).Fo=flip(P(i).Fo);
        P(i).Fm=flip(P(i).Fm);
        P(i).FvFm=flip(P(i).FvFm);
    else
    end
end

%eliminate NaNs in lat and lon coordinates
for i=1:length(P) 
    ia=isnan(P(i).lat);    
        P(i).lat(ia)=[];
        P(i).lon(ia)=[];
        P(i).chl(ia)=[];
        P(i).tur(ia)=[];
        P(i).sal(ia)=[];
        P(i).temp(ia)=[];
        P(i).Fo(ia)=[];
        P(i).Fm(ia)=[];    
        P(i).FvFm(ia)=[];
    id=isnan(P(i).lon);    
        P(i).lat(id)=[];
        P(i).lon(id)=[];
        P(i).chl(id)=[];
        P(i).tur(id)=[];
        P(i).sal(id)=[];
        P(i).temp(id)=[];
        P(i).Fo(id)=[];
        P(i).Fm(id)=[];
        P(i).FvFm(id)=[];
end
clearvars TF i ia id idx

%% match lat lon coordinates with stations 
load([outdir 'Data/st_lat_lon_d18'],'st','lat','lon','d18');
id=find(d18==0); lon=lon(id:end); lat=lat(id:end); d18=d18(id:end); st=st(id:end);

for i=1:length(P)
    P(i).st=NaN*ones(size(P(i).lat));    
    for j=1:length(st)
        latMatch = ismembertol(P(i).lat, lat(j), 0.0001);
        lonMatch = ismembertol(P(i).lon, lon(j), 0.0001) ;
        latlonMatch = latMatch & lonMatch; 
        id=find(latlonMatch,1);
        P(i).st(id)=st(j);
        clearvars latMatch lonMatch latlonMatch;
    end
end

for i=1:length(P)
    P(i).d18=NaN*P(i).st; %preallocate 
    P(i).d18i=NaN*P(i).st;    
   
    [~,ib,ic]=intersect(P(i).st,st,'stable');
    P(i).d18(ib)=d18(ic);
    
    %remove points before station 18    
    id=find(P(i).d18==min(P(i).d18));
    P(i).lat(1:id-1)=[]; 
    P(i).lon(1:id-1)=[]; 
    P(i).chl(1:id-1)=[]; 
    P(i).tur(1:id-1)=[]; 
    P(i).sal(1:id-1)=[]; 
    P(i).temp(1:id-1)=[]; 
    P(i).Fo(1:id-1)=[]; 
    P(i).Fm(1:id-1)=[]; 
    P(i).FvFm(1:id-1)=[]; 
    P(i).st(1:id-1)=[]; 
    P(i).d18(1:id-1)=[]; 
    P(i).d18i(1:id-1)=[]; 
    
    %remove points after 657
    id=find(P(i).d18==max(P(i).d18));
    P(i).lat(id+1:end)=[];
    P(i).lon(id+1:end)=[]; 
    P(i).chl(id+1:end)=[]; 
    P(i).tur(id+1:end)=[]; 
    P(i).sal(id+1:end)=[]; 
    P(i).temp(id+1:end)=[]; 
    P(i).Fo(id+1:end)=[]; 
    P(i).Fm(id+1:end)=[]; 
    P(i).FvFm(id+1:end)=[]; 
    P(i).st(id+1:end)=[]; 
    P(i).d18(id+1:end)=[]; 
    P(i).d18i(id+1:end)=[];    
        
    P(i).d18i=inpaintn(P(i).d18); %interpolate
end
clearvars ib ic id i j st d18 lat lon;

%% apply 2016-2019 FvFm correction
load([outdir 'Data/Adjustment_FoFm'],'FoAdjust','FmAdjust');
for i=1:length(P)
    if P(i).dn<datenum('01-Jan-2016')
        P(i).FoA=P(i).Fo;
        P(i).FmA=P(i).Fm;
        P(i).FvFmA=P(i).FvFm;
    else 
        P(i).FoA=(P(i).Fo.*FoAdjust.m)+FoAdjust.b;
        P(i).FmA=(P(i).Fm.*FmAdjust.m)+FmAdjust.b;
        P(i).FvFmA=(P(i).FmA-P(i).FoA)./P(i).FmA;
    end
end
clearvars FoAdjust FmAdjust i;

%remove raw data versions
P=rmfield(P,'Fo'); P=rmfield(P,'Fm'); P=rmfield(P,'FvFm');
for i=1:length(P)
    P(i).Fo=P(i).FoA; %preallocate 
    P(i).Fm=P(i).FmA; %preallocate 
    P(i).FvFm=P(i).FvFmA; %preallocate 
end
P=rmfield(P,'FoA'); P=rmfield(P,'FmA'); P=rmfield(P,'FvFmA');

%% force data into uniform grid so can plot pcolor
D18i=P(1).d18i; LAT=P(1).lat; LON=P(1).lon; ST=P(1).st;

for i=1:length(P)
    Pi(i).dn=P(i).dn;
    Pi(i).lat=LAT;
    Pi(i).lon=LON;
    Pi(i).d18=D18i;    
    Pi(i).st=ST;        
    Pi(i).chl=interp1(P(i).d18i,P(i).chl,D18i);    
    Pi(i).tur=interp1(P(i).d18i,P(i).tur,D18i);    
    Pi(i).sal=interp1(P(i).d18i,P(i).sal,D18i);    
    Pi(i).temp=interp1(P(i).d18i,P(i).temp,D18i);    
    Pi(i).Fo=interp1(P(i).d18i,P(i).Fo,D18i);    
    Pi(i).Fm=interp1(P(i).d18i,P(i).Fm,D18i);    
    Pi(i).FvFm=interp1(P(i).d18i,P(i).FvFm,D18i);    
end

clearvars D18i LAT LON ST i;

%%
save([outdir 'Data/Phytoflash_summary'],'P','Pi');

end
