function [P,Pi] = merge_Phytoflash(data1215,data1519,outdir)
%% merge Phytoflash data from 2012-2015 and 2015-2019 into one file

%Example inputs
% data1215='~/MATLAB/bloom-baby-bloom/SFB/Data/Phytoflash_2012-2015';
% data1519='~/MATLAB/bloom-baby-bloom/SFB/Data/Phytoflash_2015-2019';
% outdir='~/MATLAB/bloom-baby-bloom/SFB/';

%load in data
load(data1215,'p');
load(data1519,'PM');

%dt=datetime([P.dn]','ConvertFrom','datenum')

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
    p(i).FvFm=(PM(j).FvFm);
end

% eliminate surveys without North Bay datapoints
suisun=zeros(length(p),1); 
for i=1:length(p)
    if max(p(i).lat) >= 37.9 
        p(i).suisun=1;
    else
        p(i).suisun=0;
    end
end

[row,~]=find([p.suisun]');
P=p(row); P=rmfield(P,'suisun');

clearvars PM i j start total data1215 data1519

%% sort all latitudes so ascending South to North
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
    P(i).FvFm(ia)=[];

    id=isnan(P(i).lon);    
    P(i).lat(id)=[];
    P(i).lon(id)=[];
    P(i).chl(id)=[];
    P(i).tur(id)=[];
    P(i).sal(id)=[];
    P(i).temp(id)=[];
    P(i).FvFm(id)=[];
    
end

% eliminate data below Angel Island
for i=1:length(P)
   idx=find(P(i).lat >=37.835556,1);
   P(i).lat=P(i).lat(idx:end);
   P(i).lon=P(i).lon(idx:end);
   P(i).chl=P(i).chl(idx:end);
   P(i).tur=P(i).tur(idx:end);
   P(i).sal=P(i).sal(idx:end);
   P(i).temp=P(i).temp(idx:end);
   P(i).FvFm=P(i).FvFm(idx:end);
end
P = P(~cellfun(@isempty,{P.lat})); %eliminate empty rows       


%%
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
    P(i).FvFm=P(i).FvFm(idx);
end

% % smooth data
% for i=1:length(P)
% 	P(i).FvFm=medfilt(medfilt(P(i).FvFm));
% end

%% interpolate distance from Angel Island (D18)
LON=P(2).lon; LAT=P(2).lat;

load([outdir 'Data/distance_st18'],'d18','lat','lon');
lon(18:19)=[-122.4400000000;-122.438000000000];
D18=interp1(lon(18:end),d18(18:end),LON,'linear'); 

idx=(~isnan(D18)); %remove nans
D18=D18(idx); LON=LON(idx); LAT=LAT(idx);

[~,idx,~]=unique(LON);
D18=D18(idx); LON=LON(idx); LAT=LAT(idx);

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
        P(i).FvFm=P(i).FvFm(idx);
    else
    end
end   

%%
save([outdir 'Data/Phytoflash_summary'],'P','Pi');

end
