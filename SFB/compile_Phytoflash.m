filepath = '~/Documents/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/Phytoflash_2012-2015'],'p');
load([filepath 'Data/Phytoflash_2015-2018'],'PM');

%% merge 2012-2015 and 2015-2018 Phytoflash data
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
    p(i).Fv=PM(j).Fv;
    p(i).FvFm=(PM(j).FvFm);
end

% eliminate surveys without North Bay datapoints
suisun=zeros(length(p),1); 
for i=1:length(p)
    if max(p(i).lon) >= -122.0 %-121.9 
        p(i).suisun=1;
    else
        p(i).suisun=0;
    end
end

[row,~]=find([p.suisun]');
P=p(row); P=rmfield(P,'suisun');

%% eliminate data below st 18
for i=1:length(P) 
    TF=issorted(P(i).lat); % sort all latitudes so ascending South to North
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
        P(i).Fv=P(i).Fv(idx);
        P(i).FvFm=P(i).FvFm(idx);
    else
    end
end       

for i=1:length(P)
   idx=find(P(i).lat >=37.835556,1);
   P(i).lat=P(i).lat(idx:end);
   P(i).lon=P(i).lon(idx:end);
   P(i).chl=P(i).chl(idx:end);
   P(i).tur=P(i).tur(idx:end);
   P(i).sal=P(i).sal(idx:end);
   P(i).temp=P(i).temp(idx:end);
   P(i).Fo=P(i).Fo(idx:end);
   P(i).Fm=P(i).Fm(idx:end);
   P(i).Fv=P(i).Fv(idx:end);
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
        P(i).Fv=P(i).Fv(idx);
        P(i).FvFm=P(i).FvFm(idx);
    else
    end
end       
        
% eliminate duplicate Longitudes
for i=1:length(P)
    [~,idx,~]=unique(P(i).lon);
    P(i).lat=P(i).lat(idx);
    P(i).lon=P(i).lon(idx);
    P(i).chl=P(i).chl(idx);
    P(i).tur=P(i).tur(idx);
    P(i).sal=P(i).sal(idx);
    P(i).temp=P(i).temp(idx);
    P(i).Fo=P(i).Fo(idx);
    P(i).Fm=P(i).Fm(idx);
    P(i).Fv=P(i).Fv(idx);
    P(i).FvFm=P(i).FvFm(idx);
end

% smooth data
for i=1:length(P)
	P(i).FvFm=medfilt(medfilt(P(i).FvFm));
end

%% interpolate distance from Angel Island (D18)
LON=P(2).lon;
LAT=P(2).lat;

load([filepath 'Data/distance_st18'],'d18','lat','lon');
lon(18:19)=[-122.4400000000;-122.438000000000];
D18=interp1(lon(18:end),d18(18:end),LON,'linear'); 

idx=(~isnan(D18));
D18=D18(idx); %remove nans
LON=LON(idx);
LAT=LAT(idx);

[~,idx,~]=unique(LON);
D18=D18(idx);
LON=LON(idx);
LAT=LAT(idx);

% interpolate so can plot pcolor
for i=1:length(P)
    Pi(i).dn=P(i).dn;
    Pi(i).lat=LAT;
    Pi(i).lon=LON;
    Pi(i).d18=D18;
    Pi(i).chl=interp1(P(i).lon,P(i).chl,LON);    
    Pi(i).tur=interp1(P(i).lon,P(i).tur,LON);    
    Pi(i).sal=interp1(P(i).lon,P(i).sal,LON);    
    Pi(i).temp=interp1(P(i).lon,P(i).temp,LON);    
    Pi(i).FvFm=interp1(P(i).lon,P(i).FvFm,LON);    
end

% sort data as distance from d18
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
        P(i).Fv=P(i).Fv(idx);
        P(i).FvFm=P(i).FvFm(idx);
    else
    end
end   


%%
save([filepath 'Data/Phytoflash_summary'],'P','Pi');
