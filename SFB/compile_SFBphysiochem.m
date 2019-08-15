function [s] = compile_SFBphysiochem(out_dir,cruises,deltaflow,distance_st18)
% load in Delta Flow data
% organize SFB data into structures for each cruise

% Example inputs
% out_dir = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
% cruises='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/parameters';
% deltaflow='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/NetDeltaFlow';
% distance_st18='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/distance_st18';

load(cruises,'phys');
load(deltaflow,'DN','X2');
load(distance_st18,'d18','d19','st');

for i=1:length(phys)
    for j=1:length(st)
        if st(j) == phys(i).st
            phys(i).d18 = d18(j); %insert distance from Angel Island (aka st 18)
            phys(i).d19 = d19(j); %insert distance from Golden Gate (aka st 19)
        else
        end
    end
end

%find unique surveys
[C,IA,~] = unique([phys.dn]);
for i=1:length(C)
    if i<length(C)
        p(i).a=(IA(i):(IA(i+1)-1));        
        p(i).dn=datestr(C(i));
        else
        p(i).a=(IA(i):length(phys));        
        p(i).dn=datestr(C(i));        
    end
end

%% organize station data into structures based on survey date
for i=1:length(p)
    p(i).st=[phys(p(i).a).st]'; 
    p(i).lat=[phys(p(i).a).lat]'; 
    p(i).lon=[phys(p(i).a).lon]';     
    p(i).chl=[phys(p(i).a).chl]';
    p(i).chlpha=[phys(p(i).a).chlpha]';
    p(i).light=[phys(p(i).a).light]';    
    p(i).d36=[phys(p(i).a).d36]';   
    p(i).d19=[phys(p(i).a).d19]';            
    p(i).d18=[phys(p(i).a).d18]';        
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

% eliminate surveys without delta datapoints
for i=1:length(p)
    suisun=ismember(p(i).st,6);
    p(i).suisun=sum(suisun);
end
[row,~]=find([p.suisun]');
s=p(row); s=rmfield(s,'suisun');

%% make sure all cruise data is in ascending order
for i=1:length(s)
    TF=issorted(s(i).d19);
    if TF == 0    
        [~,I]=sort(s(i).d19);
        s(i).st=s(i).st(I);
        s(i).lat=s(i).lat(I);
        s(i).lon=s(i).lon(I);  
        s(i).chl=s(i).chl(I);
        s(i).chlpha=s(i).chlpha(I);        
        s(i).light=s(i).light(I);        
        s(i).d36=s(i).d36(I);
        s(i).d19=s(i).d19(I);          
        s(i).d18=s(i).d18(I);     
        s(i).temp=s(i).temp(I);
        s(i).sal=s(i).sal(I);
        s(i).obs=s(i).obs(I);
        s(i).spm=s(i).spm(I);
        s(i).o2=s(i).o2(I);        
        s(i).ni=s(i).ni(I);
        s(i).nina=s(i).nina(I);
        s(i).amm=s(i).amm(I);
        s(i).phos=s(i).phos(I);
    else
    end
end

%insert X2
for i=1:length(s)
    for j=1:length(DN)
        if DN(j) == datenum(s(i).dn)
            s(i).X2=X2(j);
        else
        end
    end
end    

%% find lat lon coordinates of X2
d19=s(30).d19; lat=s(30).lat; lon=s(30).lon; %use longest dataset
D19=(round(d19(1)):1:round(d19(end)))';
LAT=interp1(d19,lat,D19); LAT(end)=lat(end);
LON=interp1(d19,lon,D19); LON(end)=lon(end);

for i=1:length(s)
    if any(s(i).X2) %if there is an X2 value at that index
        id = find(round(s(i).X2) == D19, 1);
        s(i).latX2 = LAT(id);
        s(i).lonX2 = LON(id);
        clearvars id
    else
    end
end

% fill in gaps w NaNs so 37 stations are represented (facilitate pcolor)
for i=1:length(s)
    S(i).dn=datenum(s(i).dn);
    S(i).st=st; 
    S(i).lat=lat;
    S(i).lon=lon;
    S(i).d18=d18;
    S(i).d19=d19;
    S(i).chl=NaN*st; 
    S(i).chlpha=NaN*st;     
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
    S(i).X2=s(i).X2;
    S(i).latX2=s(i).latX2;
    S(i).lonX2=s(i).lonX2;
end

%insert existing data into new structure
for i=1:length(s)
    [~,id]=ismember(s(i).st,S(i).st);
    S(i).chl(id)=s(i).chl;
    S(i).chlpha(id)=s(i).chlpha;    
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
end

Si=S;
%interpolate
for i=1:length(S)
    Si(i).chl=fillmissing([S(i).chl],'movmean',5);
    Si(i).chlpha=fillmissing([S(i).chlpha],'movmean',5);
    Si(i).temp=fillmissing([S(i).temp],'movmean',5);
    Si(i).sal=fillmissing([S(i).sal],'movmean',5);
    Si(i).light=fillmissing([S(i).light],'movmean',5);    
    Si(i).obs=fillmissing([S(i).obs],'movmean',5);
    Si(i).spm=fillmissing([S(i).spm],'movmean',5);
    Si(i).ni=fillmissing([S(i).ni],'movmean',5);
    Si(i).nina=fillmissing([S(i).nina],'movmean',6);
    Si(i).amm=fillmissing([S(i).amm],'movmean',5);
end
    
save([out_dir 'Data/physical_param'],'s','S','Si');

end

%% old school way to calculate X2
% for i=1:length(s)
%     D36 = linspace(s(i).d36(1),s(i).d36(end),200)'; %interpolate the d36 (km from south bay st 36)
%     ST = linspace(s(i).st(1),s(i).st(end),200)'; %interpolate station
%     SAL_i = interp1(s(i).d36, s(i).sal, D36);
%     id=find(round(SAL_i) == 2,1);    
%     s(i).X2=D36(id);
%     s(i).X2_st=round(ST(id));
% end

