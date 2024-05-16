%% match 2021 MHW calculation grids with survey dates and grid
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'Shimada/data/OISST_MHW_2019_2021_raw.mat'],'M','MHW21');

%%%% load in survey data 
load([filepath 'Shimada/Data/environ_Shimada2021'],'DT','LAT','LON');
P=table(DT,LAT,LON); P=P(P.DT>datetime('01-Jan-2020'),:);
P(P.LAT<40,:)=[];% remove data south of 40N
P(P.LAT>47.5 & P.LON>-124.7,:)=[]; % remove data from the Strait

%%%% remove cruise legs to port
P((P.DT<datetime('26-Jul-2021')),:)=[];
P((P.DT>=datetime('08-Aug-2021') & P.DT<datetime('06-Sep-2021')),:)=[];
P((P.DT>=datetime('22-Sep-2021')),:)=[];
%figure; plot(P.DT,P.LAT,'o');
%figure; plot(P.DT,smooth(P.LAT,.2),'o');

P.LATs=smooth(P.LAT,.2);
[y,m,d]=ymd(P.DT); P.DT=datetime(y,m,d); P.DT.Format='yyyy-MM-dd';

%%%% find when survey encounted specific latitudinal range
Y=(39.875:.25:48.875)'; 
H=NaT(length(Y)-1,2); 
H.Format='yyyy-MM-dd';
for i=1:length(Y)-1
    irange=find(P.LATs>=Y(i) & P.LATs<Y(i+1));
    dt=P.DT(irange);
    H(i,1)=dt(1); H(i,2)=dt(end);
end
clearvars i irange opts y m d dt LAT LON P DT

%% find where survey matches with Anomaly dataset

% preallocate arrays
sst=NaN*ones(length(Y),length(M.lon)); clm=sst; mhw=sst; m90=sst;
for i=1:length(H)
    % find where the MHW dataset matches for (ia) lats and (ib) dates
    ia=find(M.lat==Y(i));
    ib=find(M.dt21>=H(i,1) & M.dt21<=H(i,2));

    ssti=(squeeze(M.sst21(ia,:,ib)))';
    clmi=(squeeze(M.clim(ia,:,ib)))';
    mhwi=(squeeze(M.mhw21(ia,:,ib)))';
    m90i=(squeeze(M.m90(ia,:,ib)))';
    
    if length(ib)>1 %take the mean if more than 1 value
        ssti=mean(ssti,1);
        clmi=mean(clmi,1);
        mhwi=mean(mhwi,1);
        m90i=mean(m90i,1);        
    end

    sst(i,:)=ssti;
    clm(i,:)=clmi;
    mhw(i,:)=mhwi;
    m90(i,:)=m90i;

    clearvars ia ib ssti clmi mhwi m90i
end

lat=Y;
lon=M.lon;
save([filepath 'Shimada/data/MHW_2021.mat'],'lat','lon','sst','clm','mhw','m90');
