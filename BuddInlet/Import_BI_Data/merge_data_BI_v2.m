%% merge Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
ifcbpath = '~/Documents/MATLAB/ifcb-data-science/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath(ifcbpath));

%%%% merge continuous data (IFCB, Hobo T and S, Deschutes R)
%%%% load in and process IFCB data
%%%% match up manual meso data with dinophysis data

%%%% load in summary file of Dinophysis small and large
load([ifcbpath 'IFCB-Data/BuddInlet/class/summary_Dinophysis_allTB'],'filelistTB',...
    'mdateTB','ml_analyzedTB','filecommentTB','runtypeTB','dinobiovol_above_adhocthreshTB',...
    'dinocount_above_adhocthreshTB','dinoESD_above_adhocthreshTB','dinogray_above_adhocthreshTB',...
    'largecount_above_adhocthreshTB','smallcount_above_adhocthreshTB');

dBvol=dinobiovol_above_adhocthreshTB./ml_analyzedTB;
dSize=dinoESD_above_adhocthreshTB;
dGray=dinogray_above_adhocthreshTB;

% adjust data by calculated slopes
load([ifcbpath 'IFCB-Data/BuddInlet/class/summary_adjustedTB_Dinophysis'],'slope');
dino=dinocount_above_adhocthreshTB./ml_analyzedTB./slope;
dinoSmall=smallcount_above_adhocthreshTB./ml_analyzedTB./slope;
dinoLarge=largecount_above_adhocthreshTB./ml_analyzedTB./slope;

% %%% loading in original summary file with other taxa besides Dinophysis
% load([ifcbpath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB'],'filelistTB',...
%     'class2useTB','mdateTB','ml_analyzedTB','filecommentTB','runtypeTB','classcount_above_adhocthreshTB',...
%     'classbiovol_above_adhocthreshTB','ESD_above_adhocthreshTB','graylevel_above_adhocthreshTB');
% dind=contains(class2useTB,'Dinophysis');
% dBvol=classbiovol_above_adhocthreshTB(:,dind)./ml_analyzedTB;
% dSize=ESD_above_adhocthreshTB(:,dind);
% dGray=graylevel_above_adhocthreshTB(:,dind);
% 
% % adjust data by respective slopes
% load([ifcbpath 'IFCB-Data/BuddInlet/class/summary_adjustedTB_Dinophysis'],'slope');
% dino=classcount_above_adhocthreshTB(:,dind)./ml_analyzedTB./slope;

% load in Mesodinium manual
load([ifcbpath 'IFCB-Data/BuddInlet/manual/summary_meso_width_manual'],...
    'large','small','ml_analyzed','filelist');

mesoml=(small+large)./ml_analyzed;
smallml=small./ml_analyzed;
largeml=large./ml_analyzed;

[~,im,it] = intersect(filelist, filelistTB); %finds the matched files between automated and manually classified files
meso=nan*dino; mesoSmall=nan*dino; mesoLarge=nan*dino; 
meso(it)=mesoml(im); mesoSmall(it)=smallml(im); mesoLarge(it)=largeml(im); 

clearvars im it mesoS mesoL slope ml_analyzed* dind small large filelist 

%%%% put in timetable
dt=datetime(mdateTB,'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss');
TT=timetable(dt,dino,dinoSmall,dinoLarge,dBvol,dSize,dGray,meso,mesoSmall,mesoLarge,filecommentTB,runtypeTB);

%remove that outlier
idx=find(TT.dt==datetime('09-Jul-2023 19:24:00')); 
TT.mesoLarge(idx)=TT.mesoLarge(idx)-30;
TT.meso(idx)=TT.meso(idx)-30;

clearvars classcount ml_analyzed class2use i mesoi im it filelist slope dind *TB
   
% remove discrete samples (data with file comment)
TT(contains(TT.filecommentTB,'trigger'),:)=[];

% split dataset by PMTA and PMTB triggers
idf=contains(TT.runtypeTB,{'NORMAL','Normal'});
ida=contains(TT.runtypeTB,{'ALT','Alternative'});
fli=TT(idf,:); sci=TT(ida,:);

% clean up tables by removing specific variables
TT=removevars(TT,{'filecommentTB','runtypeTB'});
fli=removevars(fli,{'filecommentTB','runtypeTB'});
sci=removevars(sci,{'filecommentTB','runtypeTB'});

% daily average/max
fl=retime(fli,'daily','median');
sc=retime(sci,'daily','median');
TTT=synchronize(fl,sc);

%%%% Include Max hourly average
flii=retime(fli,'regular','mean','TimeStep',hours(1)); %take hourly average
imax=@(x) find(x==max(x),1);  % anonymous function for index to maximum in group
dinomax=[];  % empty accumulator for results
dinomean=[];
dinostd=[];
dmatrix=[];
ymatrix=[];
yrlist=[2021;2022;2023];

for j=1:length(yrlist)
    DM=flii(flii.dt.Year==yrlist(j),:); %only take data for 1 year
    DM.DOY=day(DM.dt,'dayofyear');
    ttMAX=varfun(imax,DM,'InputVariables','dino','GroupingVariables','DOY');

    for i=1:height(ttMAX)  
        idx=find(DM.DOY==ttMAX.DOY(i)); %get daily index

        val=DM.dino(idx);
        nanday=[val;NaN*ones(24-length(val),1)];
        ymatrix=[ymatrix,nanday];

        [vald,idd]=max(DM.dino(idx)); %find max value/day from daily subset
        dinomax=[dinomax;vald]; % accumulate rows in the output table

        dinomean=[dinomean;mean(DM.dino(idx))];        
        dinostd=[dinostd;std(DM.dino(idx),1)];

        dti=DM.dt(idx(idd)); %find corresponding date back in full dataset        
        dmatrix=[dmatrix;dti];        

    end

end
dmatrix=dateshift(dmatrix,'start','day');
% D=timetable(dmatrix,dinomax,dinomean,dinostd);
% TTT=synchronize(TTT,D,'first');

clearvars D m idm imax dino* DM dMAX i j yrlist flii meso* i* nanday val* ttMAX dBvol dGray dSize dti

%% fill gaps of 3 days or less
TTT.dino_fl = fillmissing(TTT.dino_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.dinoSmall_fl = fillmissing(TTT.dinoSmall_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.dinoLarge_fl = fillmissing(TTT.dinoLarge_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));

TTT.dino_sc = fillmissing(TTT.dino_sc,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.dinoSmall_sc = fillmissing(TTT.dinoSmall_sc,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.dinoLarge_sc = fillmissing(TTT.dinoLarge_sc,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));

TTT.dBvol_fl = fillmissing(TTT.dBvol_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.dSize_fl = fillmissing(TTT.dSize_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.dGray_fl = fillmissing(TTT.dGray_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));

idx=find(TTT.dino_fl==0);
TTT.dGray_fl(idx)=NaN;
TTT.dSize_fl(idx)=NaN;

%%%% merge IFCB, temperature, salinity, Deschutes R discharge data
load([filepath 'BuddInlet/Data/temp_sal_1m_3m_BuddInlet'],'H');
load([filepath 'BuddInlet/Data/DeschutesR_discharge'],'DR');
load([filepath 'BuddInlet/Data/OlympiaWeather'],'W');

% daily average
HD = synchronize(DR,W,H,'first');
HD=retime(HD,'daily','mean');
T=synchronize(TTT,HD);
T.dt=datetime(T.dt,'Format','dd-MMM-yyyy');

clearvars HD Hc fl sc idx TT TTT idf ida dt *TB 

%%%% match up IFCB continuous data with manual data
load([ifcbpath 'IFCB-Data/BuddInlet/manual/count_class_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');
dt=datetime(matdate,'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss');

M_dacum=classcount(:,contains(class2use,'Dinophysis_acuminata'))./ml_analyzed;
M_dfort=classcount(:,contains(class2use,'Dinophysis_fortii'))./ml_analyzed;
M_dnorv=classcount(:,contains(class2use,'Dinophysis_norvegica'))./ml_analyzed;
M_dparv=classcount(:,contains(class2use,'Dinophysis_parva'))./ml_analyzed;

imclass=find(contains(class2use,'Mesodinium'));
M_meso=sum(classcount(:,imclass),2)./ml_analyzed;

M=timetable(dt,M_dacum,M_dfort,M_dnorv,M_dparv,M_meso);

Tc=synchronize(fli,M);

clearvars M* filelist class2use dt classcount matdate ml_analyzed imclass classcount_adjust_TB

%%%% match up continuous data with exact IFCB data
Hc = synchronize(DR,W,H,'first');
Hc.AWND = fillmissing(Hc.AWND,'linear','SamplePoints',Hc.dt,'MaxGap',days(3));
Hc.PRCP = fillmissing(Hc.PRCP,'linear','SamplePoints',Hc.dt,'MaxGap',days(3));
Hc.TAVG = fillmissing(Hc.TAVG,'linear','SamplePoints',Hc.dt,'MaxGap',days(3));
Tc.dt=dateshift(Tc.dt,'start','minute');
Tc=synchronize(Tc,Hc,'first');

clearvars Hc H DR 

%% merge discrete data (DST, microscopy, nutrients, cell quota)
%%%% add stratification depth to Discrete dataset
load([filepath 'BuddInlet/Data/DinophysisMicroscopy_BI'],'TT'); 
load([filepath 'BuddInlet/Data/BuddInlet_TSChl_profiles'],'B','dt');

%%%% merge discrete data
load([filepath 'BuddInlet/Data/DSP_BI'],'D');
D.dt=dateshift(D.dt,'start','day');
TT.dt=dateshift(TT.dt,'start','day');

D=synchronize(TT,D);
D.dt=datetime(D.dt,'Format','dd-MMM-yyyy');

%remove data gaps but allow for DST lag
idx=find(~isnan(D.SampleDepthm),1); D(1:idx-1,:)=[];
D((D.dt>datetime('30-Nov-2021') & D.dt<datetime('02-Mar-2022')),:)=[];
D((D.dt>datetime('15-Oct-2022') & D.dt<datetime('23-Mar-2023')),:)=[];
D(D.dt>datetime('16-Oct-2023'),:)=[];

D=removevars(D,{'ChlMaxDepthm','ChlMaxLower1','ChlMaxUpper1','ChlMaxLower2','ChlMaxUpper2','AmmoniaM'});
D=movevars(D,{'dinoML_microscopy','mesoML_microscopy','DST'},'After','IFCBDepthm');
T=synchronize(T,D);

%%%% merge with nutrient data
load([filepath 'BuddInlet/Data/Data_nutrients_BI'],'N');
T=synchronize(T,N);

%%%% merge with toxicity cell quota data
load([filepath 'BuddInlet/Data/ToxinCellQuota_BI.mat'],'Q');
QT=table2timetable(Q);
T=synchronize(T,QT);

%%%% change very low microscopy values to 0
idx=(T.dinoML_microscopy<=0.15);
T.dinoML_microscopy(idx)=0;
T.fx_Dacuminata(idx)=0;
T.fx_Dfortii(idx)=0;
T.fx_Dnorvegica(idx)=0;
T.fx_Dodiosa(idx)=0;
T.fx_Drotundata(idx)=0;
T.fx_Dparva(idx)=0;
T.fx_Dacuta(idx)=0;
T.DST_pgcell(idx)=0;
T.PTX2_pgcell(idx)=0;
T.DSTng(idx)=0;
T.PTX2Ng(idx)=0;

clearvars idx TT Q NT

% remove data before Apr 1 or afer Oct 1
T((T.dt.Month<=3 | T.dt.Month>=10),:)=[];
Tc((Tc.dt.Month<=3 | Tc.dt.Month>=10),:)=[];
fli((fli.dt.Month<=3 | fli.dt.Month>=10),:)=[];
sci((sci.dt.Month<=3 | sci.dt.Month>=10),:)=[];

save([filepath 'BuddInlet/Data/BuddInlet_data_summary'],'T','Tc','fli','sci','dmatrix','ymatrix');