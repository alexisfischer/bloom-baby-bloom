%% find lat lon coordinates of each IFCB sample on 2021 Shimada cruise GPS data
% match IFCB timestamps with underway timestamps 
% Alexis D. Fischer, NWFSC, May 2022

clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; 
addpath(genpath(filepath)); 

load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB2021'],'filelistTB');
load([filepath 'NOAA/Shimada/Data/environ_Shimada2021'],'DT','LON','LAT','TEMP');

dtIFCB=cellfun(@(x) x(2:16),filelistTB,'UniformOutput',false);
dtI=datetime(cell2mat(dtIFCB),"InputFormat","yyyyMMdd'T'HHmmss");
dtI.Format='yyyy-MM-dd HH:mm:ss';        

idx=NaN*ones(size(dtI));
for i=1:length(dtI)
    ia=find(dtI(i)==DT,1);
    if isempty(ia)
        ib=find(dtI(i)<=DT,1);
        ic=find(dtI(i)>=DT,1);
        d1=abs(minus(dtI(i),DT(ib))); %find difference
        d2=abs(minus(dtI(i),DT(ic)));
        if d1<d2
            disp('prior underway coordinate')
            idx(i)=ib;
        elseif d1>d2
            disp('next underway coordinate')            
            idx(i)=ic;
        end
    else
        disp('perfect match w an underway coordinate')
        idx(i)=ia;
    end
    disp(dtI(i));

    clearvars ia ib ic d1 d2
end

id=isnan(idx); idx(id)=[]; filelistTB(id)=[];
latI=LAT(idx);
lonI=LON(idx);
tempI=TEMP(idx);

figure; plot(lonI,latI,'o'); %sanity check plot
%figure; plot(LON,LAT)

save([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2021'],'dtI','lonI','latI','tempI','filelistTB');
