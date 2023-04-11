%% make 2019 and 2021 summary file for Emilie's niche analysis
% merge IFCB data, sensor data, and discrete data
%
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

%%%% format IFCB data
classifiername='CCS_v16';
load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB_' classifiername],...
    'class2useTB','classcountTB_above_optthresh','filelistTB','mdateTB','ml_analyzedTB');

dt=datetime(mdateTB,'convertfrom','datenum'); dt.Format='yyyy-MM-dd HH:mm:ss';        
cellsmL = classcountTB_above_optthresh./ml_analyzedTB;    

%%%% sum up PN
id1=find(strcmp('Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell',class2useTB));
id2=find(strcmp('Pseudo-nitzschia_large_2cell,Pseudo-nitzschia_small_2cell',class2useTB));
id3=find(strcmp('Pseudo-nitzschia_large_3cell,Pseudo-nitzschia_small_3cell',class2useTB));
id4=find(strcmp('Pseudo-nitzschia_large_4cell,Pseudo-nitzschia_small_4cell',class2useTB));

cellsmL(:,id1)=sum([cellsmL(:,id1),2*cellsmL(:,id2),3*cellsmL(:,id3),4*cellsmL(:,id4)],2);
cellsmL(:,[id2,id3,id4])=[];
class2useTB([id2,id3,id4])=[];

%%%% rename grouped classes 
class2useTB(strcmp('Cerataulina,Dactyliosolen,Detonula,Guinardia',class2useTB))={'Cera_Dact_Deto_Guin'};
class2useTB(strcmp('Chaetoceros_chain,Chaetoceros_single',class2useTB))={'Chaetoceros'};
class2useTB(strcmp('Dinophysis_acuminata,Dinophysis_acuta,Dinophysis_caudata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_odiosa,Dinophysis_parva,Dinophysis_rotundata,Dinophysis_tripos',class2useTB))={'Dinophysis'};
class2useTB(strcmp('Heterocapsa_triquetra,Scrippsiella',class2useTB))={'Hete_Scri'};
class2useTB(strcmp('Thalassiosira_chain',class2useTB))={'Thalassiosira'};
class2useTB(strcmp('Proboscia,Rhizosolenia',class2useTB))={'Prob_Rhiz'};
class2useTB(strcmp('Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell',class2useTB))={'Pseudonitzschia'};

%%%% merge IFCB data with PN cell width data
S=load([filepath 'IFCB-Data/Shimada/class/summary_PN_allTB.mat'],'PNwidth_opt','filelistTB');
[~,~,ib]=intersect(filelistTB,S.filelistTB); PN_width=[S.PNwidth_opt(ib).mean]';

clearvars ia ib S classcountTB_above_optthresh ml_analyzedTB class_indices_path id1 id2 id3 id4 mdateTB

%% match timestamps of IFCB and sensor data
%%%% merge 2019 and 2021 data
S19=load([filepath 'NOAA/Shimada/Data/environ_Shimada2019'],'DT','LON','LAT','TEMP','SAL','FL','PCO2');
S21=load([filepath 'NOAA/Shimada/Data/environ_Shimada2021'],'DT','LON','LAT','TEMP','SAL','FL','PCO2');
S.DT=[S19.DT;S21.DT]; S.LON=[S19.LON;S21.LON]; S.LAT=[S19.LAT;S21.LAT];
S.TEMP=[S19.TEMP;S21.TEMP]; S.SAL=[S19.SAL;S21.SAL]; S.PCO2=[S19.PCO2;S21.PCO2];

%%%% round IFCB data to nearest minute and match with environmental data
dtI=dateshift(dt,'start','minute');
[idI,idS]=match_timestamps_IFCB_Shimada(dtI,S.DT);
filelistTB(idI)=[]; dt(idI)=[]; cellsmL(idI,:)=[]; PN_width(idI)=[];
lat=S.LAT(idS); lon=S.LON(idS); temp=S.TEMP(idS); sal=S.SAL(idS); pco2=S.PCO2(idS);
%figure; plot(lon,lat,'o'); %sanity check plot

clearvars S19 S21 idI idS S dtI

%% match HAB data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA'); %GMT time
HA.dt.Format='yyyy-MM-dd HH:mm:ss'; dtH=dateshift(HA.dt,'start','minute');
dtI=dateshift(dt,'start','minute');

[idH,idI] = match_timestamps_IFCB_Shimada(dtH,dtI);
HA(idH,:)=[]; %remove the nans

chlA_ugL=NaN*lat; chlA_ugL(idI)=HA.chlA_ugL;
pDA_ngL=NaN*lat; pDA_ngL(idI)=HA.pDA_ngL;
NitrateM=NaN*lat; NitrateM(idI)=HA.NitrateM;
PhosphateM=NaN*lat; PhosphateM(idI)=HA.PhosphateM;
SilicateM=NaN*lat; SilicateM(idI)=HA.SilicateM;
PNcellsmL_mcpy=NaN*lat; PNcellsmL_mcpy(idI)=HA.PNcellsmL;

clearvars dtH idH dtI idI

%% format for .csv file
I=array2table(cellsmL,'VariableNames',class2useTB);
I(:,end)=[]; %remove unclassified
E=table(dt,lat,lon,temp,sal,pco2,chlA_ugL,NitrateM,PhosphateM,SilicateM,pDA_ngL,PNcellsmL_mcpy);
T=[E I];

writetable(T,[filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.csv'])
save([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],...
    'dt','filelistTB','lat','lon','class2useTB','cellsmL','PN_width','temp','sal','pco2',...
    'chlA_ugL','pDA_ngL','NitrateM','PhosphateM','SilicateM','PNcellsmL_mcpy');

clearvars I E

%%
%% test plots
% clear
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis'],...
%     'dt','filelistTB','lat','lon','class2useTB','cellsmL','temp','sal','pco2',...
%     'chlA_ugL','pDA_ngL','NitrateM','PhosphateM','SilicateM','PNcellsmL_mcpy');


figure('Units','inches','Position',[1 1 4 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.15 0.15]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1);
yyaxis left
    idx=dt<datetime('01-Jan-2020');
stem(lat(idx),T.Pseudonitzschia(idx),'-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    ylabel('PN cells/mL','fontsize',12); 
    title('Hake: 2019 (top) & 2021 (bottom)')
yyaxis right
    plot(lat(idx),pco2(idx),'-','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','xlim',[34 49],'xticklabel',{},'fontsize',10); 
    ylabel('temperature','fontsize',12);        

    l=lat(idx);
    p=pco2(idx);

    id=isnan(p);
    l(id)=[];
    p(id)=[];
    %%
subplot(2,1,2);
yyaxis left
    idx=dt>datetime('01-Jan-2020');
stem(lat(idx),T.Pseudonitzschia(idx),'-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    ylabel('PN cells/mL','fontsize',12);    
yyaxis right
    plot(lat(idx),pco2(idx),'-','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','xlim',[34 49],'fontsize',10); 
    ylabel('temperature','fontsize',12);         

% %% set figure parameters
% exportgraphics(gcf,[outpath 'Manual_automated_' num2str(class2do_string) '.png'],'Resolution',100)    
% hold off

%% test plots
% clear
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis'],...
%     'dt','filelistTB','lat','lon','class2useTB','cellsmL','temp','sal','pco2',...
%     'chlA_ugL','pDA_ngL','NitrateM','PhosphateM','SilicateM','PNcellsmL_mcpy');


figure('Units','inches','Position',[1 1 4 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.15 0.15]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1);
yyaxis left
stem(dt,T.Pseudonitzschia,'-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    ylabel('PN cells/mL','fontsize',12); 
    title('Hake: 2019 (top) & 2021 (bottom)')
yyaxis right
    plot(dt,pco2,'-','Markersize',6,'linewidth',.8);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2019-06-01') datetime('2019-09-15')],...
        'xticklabel',{},'fontsize',10); 
    ylabel('temperature','fontsize',12);        

subplot(2,1,2);
yyaxis left
stem(dt,T.Pseudonitzschia,'-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    ylabel('PN cells/mL','fontsize',12);    
yyaxis right
    plot(dt,pco2,'-','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out',...
        'xlim',[datetime('2021-06-01') datetime('2021-09-15')],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('temperature','fontsize',12);         

% %% set figure parameters
% exportgraphics(gcf,[outpath 'Manual_automated_' num2str(class2do_string) '.png'],'Resolution',100)    
% hold off



