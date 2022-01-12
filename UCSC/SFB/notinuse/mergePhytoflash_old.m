function [P,Pi] = mergePhytoflash(data1215,data1519,outdir)
%% merge Phytoflash data from 2012-2015 and 2015-2019 into one file

clear
% %Example inputs
data1215='~/MATLAB/bloom-baby-bloom/SFB/Data/Phytoflash_2012-2015';
data1519='~/MATLAB/bloom-baby-bloom/SFB/Data/Phytoflash_2015-2019';
outdir='~/MATLAB/bloom-baby-bloom/SFB/';

%%
%load in data
load(data1215,'p');
load(data1519,'PM');

% merge 2012-2015 and 2015-2019 Phytoflash data
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






%%
% sort all latitudes so ascending South to North
for i=1:length(P) 
    TF=issorted(P(i).lat); 
    if TF == 0   
        [~,idx]=sort(P(i).lat);
        P(i).lat=P(i).lat(idx);
        P(i).lon=P(i).lon(idx);
        P(i).chl=P(i).chl(idx);
        P(i).tur=P(i).tur(idx);
        P(i).sal=P(i).sal(idx);
        P(i).temp=P(i).temp(idx);
        P(i).Fo=P(i).Fo(idx);
        P(i).Fm=P(i).Fm(idx);
        P(i).FvFm=P(i).FvFm(idx);
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

% eliminate data below Angel Island
for i=1:length(P)
   idx=find(P(i).lat >=37.80,1);
   P(i).lat=P(i).lat(idx:end);
   P(i).lon=P(i).lon(idx:end);
   P(i).chl=P(i).chl(idx:end);
   P(i).tur=P(i).tur(idx:end);
   P(i).sal=P(i).sal(idx:end);
   P(i).temp=P(i).temp(idx:end);
   P(i).Fo=P(i).Fo(idx:end);
   P(i).Fm=P(i).Fm(idx:end);
   P(i).FvFm=P(i).FvFm(idx:end);
end
P = P(~cellfun(@isempty,{P.lat})); %eliminate empty rows       

% sort all longitudes so West to East
for i=1:length(P)
    TF=issorted(P(i).lon);
    if TF == 0   
        [~,idx]=sort(P(i).lon);
        P(i).lat=P(i).lat(idx);
        P(i).lon=P(i).lon(idx);
        P(i).chl=P(i).chl(idx);
        P(i).tur=P(i).tur(idx);
        P(i).sal=P(i).sal(idx);
        P(i).temp=P(i).temp(idx);
        P(i).Fo=P(i).Fo(idx);
        P(i).Fm=P(i).Fm(idx);
        P(i).FvFm=P(i).FvFm(idx);
    else
    end
end       
        
% % eliminate duplicate Longitudes
% for i=1:length(P)
%     [~,idx,~]=unique(P(i).lon);
%     P(i).lat=P(i).lat(idx);
%     P(i).lon=P(i).lon(idx);
%     P(i).chl=P(i).chl(idx);
%     P(i).tur=P(i).tur(idx);
%     P(i).sal=P(i).sal(idx);
%     P(i).temp=P(i).temp(idx);
%     P(i).Fo=P(i).Fo(idx);
%     P(i).Fm=P(i).Fm(idx);
%     P(i).FvFm=P(i).FvFm(idx);
% end

clearvars TF i ia id idx

%% interpolate distance from Angel Island (D18) and match to stations
load([outdir 'Data/st_lat_lon_d18'],'st','lat','lon','d18');

id=find(d18==0); lon=lon(id:end); lat=lat(id:end); d18=d18(id:end); st=st(id:end);
lon(1:2)=[-122.4400000000;-122.438000000000];

LON=P(24).lon; LAT=P(24).lat;
D18=interp1(lon,d18,LON,'linear'); 

idx=(~isnan(D18)); %remove nans
D18=D18(idx); LON=LON(idx); LAT=LAT(idx);

[~,idx,~]=unique(LON); %only unique data
D18=D18(idx); LON=LON(idx); LAT=LAT(idx);

ST=nan*D18;
for i=1:length(st)
    latlonMatch = ismembertol(LAT,lat(i),0.0001) & ismembertol(LON,lon(i),0.0001);
    idx=find(latlonMatch,1);
    ST(idx)=st(i);
end

%% interpolate so can plot pcolor
for i=1:length(P)
    Pi(i).dn=P(i).dn;
    Pi(i).lat=LAT;
    Pi(i).lon=LON;
    Pi(i).d18=D18;    
    Pi(i).chl=interp1(P(i).lon,P(i).chl,LON);    
    Pi(i).tur=interp1(P(i).lon,P(i).tur,LON);    
    Pi(i).sal=interp1(P(i).lon,P(i).sal,LON);    
    Pi(i).temp=interp1(P(i).lon,P(i).temp,LON);    
    Pi(i).Fo=interp1(P(i).lon,P(i).Fo,LON);    
    Pi(i).Fm=interp1(P(i).lon,P(i).Fm,LON);    
    Pi(i).FvFm=interp1(P(i).lon,P(i).FvFm,LON);    
end

%% sort data as distance from d18
for i=1:length(Pi)
    TF=issorted(Pi(i).d18);
    if TF == 0   
        [~,idx]=sort(P(i).lon);
        P(i).lat=P(i).lat(idx);
        P(i).lon=P(i).lon(idx);
        P(i).chl=P(i).chl(idx);
        P(i).tur=P(i).tur(idx);
        P(i).sal=P(i).sal(idx);
        P(i).temp=P(i).temp(idx);
        P(i).Fo=P(i).Fo(idx);
        P(i).Fm=P(i).Fm(idx);
        P(i).FvFm=P(i).FvFm(idx);
    else
    end
end   

clearvars ia id idx p TF i suisun;

%% find station matchup for non-interpolated dataset

for i=1:length(P)
    P(i).st=NaN*ones(size(P(i).lat));    
    for j=1:length(st)
        latMatch = ismembertol(P(i).lat, lat(j), 0.0001);
        lonMatch = ismembertol(P(i).lon, lon(j), 0.0001) ;
        latlonMatch = latMatch & lonMatch;  %of course the these 3 lines can be put into 1
        id=find(latlonMatch,1);
        P(i).st(id)=st(j);
        clearvars latMatch lonMatch latlonMatch;
    end
end

%%
save([outdir 'Data/Phytoflash_summary'],'P','Pi');

end
