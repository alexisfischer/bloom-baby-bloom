%% make 2019 and 2021 summary file for Emilie's niche analysis
% merge IFCB data, sensor data, and discrete data
%
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

%% match timestamps of sensor data and HAB data
%%%% merge 2019 and 2021 data
S19=load([filepath 'NOAA/Shimada/Data/environ_Shimada2019'],'DT','LON','LAT','TEMP','SAL','PCO2');
S21=load([filepath 'NOAA/Shimada/Data/environ_Shimada2021'],'DT','LON','LAT','TEMP','SAL','PCO2');
DT=[S19.DT;S21.DT]; LON=[S19.LON;S21.LON]; LAT=[S19.LAT;S21.LAT];
TEMP=[S19.TEMP;S21.TEMP]; SAL=[S19.SAL;S21.SAL]; PCO2=[S19.PCO2;S21.PCO2];
T=timetable(DT,LAT,LON,TEMP,SAL,PCO2);

load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA'); %GMT time
HA.dt.Format='yyyy-MM-dd HH:mm:ss'; HA.dt=dateshift(HA.dt,'start','minute');
H=table2timetable(HA); H=removevars(H,{'st','lat','lon','PNcellsmL'});
H.pDA_ngL(H.pDA_ngL<0)=0; H=sortrows(H);
T = synchronize(T,H,'first','fillwithmissing');

%%%% duplicate HA data for 11 minutes before and after data collection
val=11;
idx=find(~isnan(T.chlA_ugL));
for i=1:length(idx)
    T.chlA_ugL(idx(i)-val:idx(i)+val)=T.chlA_ugL(idx(i));
    T.pDA_ngL(idx(i)-val:idx(i)+val)=T.pDA_ngL(idx(i));
    T.NitrateM(idx(i)-val:idx(i)+val)=T.NitrateM(idx(i));
    T.PhosphateM(idx(i)-val:idx(i)+val)=T.PhosphateM(idx(i));
    T.SilicateM(idx(i)-val:idx(i)+val)=T.SilicateM(idx(i));
end

clearvars S19 S21 LON LAT TEMP SAL PCO2 H HA DT idx i

%% format IFCB data
classifiername='CCS_NOAA-OSU_v7';
load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB_' classifiername],...
    'class2useTB','classcountTB_above_optthresh','filelistTB','mdateTB','ml_analyzedTB');

dt=datetime(mdateTB,'convertfrom','datenum'); dt.Format='yyyy-MM-dd HH:mm:ss';        
cellsmL = classcountTB_above_optthresh./ml_analyzedTB;    

%%%% sum up PN
id1=find(strcmp('Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell',class2useTB));
id2=find(strcmp('Pseudo-nitzschia_large_2cell,Pseudo-nitzschia_small_2cell',class2useTB));
id3=find(strcmp('Pseudo-nitzschia_large_3cell,Pseudo-nitzschia_large_4cell,Pseudo-nitzschia_small_3cell,Pseudo-nitzschia_small_4cell',class2useTB));

cellsmL(:,id1)=sum([cellsmL(:,id1),2*cellsmL(:,id2),3.5*cellsmL(:,id3)],2);
cellsmL(:,[id2,id3])=[];
class2useTB([id2,id3])=[];

%%%% rename grouped classes 
class2useTB(strcmp('Cerataulina,Dactyliosolen,Detonula,Guinardia',class2useTB))={'Cera_Dact_Deto_Guin'};
class2useTB(strcmp('Chaetoceros_chain,Chaetoceros_single',class2useTB))={'Chaetoceros'};
class2useTB(strcmp('Dinophysis_acuminata,Dinophysis_acuta,Dinophysis_caudata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_odiosa,Dinophysis_parva,Dinophysis_rotundata,Dinophysis_tripos',class2useTB))={'Dinophysis'};
class2useTB(strcmp('Heterocapsa_triquetra,Scrippsiella',class2useTB))={'Hete_Scri'};
class2useTB(strcmp('Thalassiosira_chain',class2useTB))={'Thalassiosira'};
class2useTB(strcmp('Proboscia,Rhizosolenia',class2useTB))={'Prob_Rhiz'};
class2useTB(strcmp('Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell',class2useTB))={'Pseudonitzschia'};

%%%% round IFCB data to nearest minute and match with environmental data
dt=dateshift(dt,'start','minute'); 
TT = array2timetable(cellsmL(:,1:end-1),'RowTimes',dt,'VariableNames',class2useTB(1:end-1));
TT=addvars(TT,filelistTB,'Before',class2useTB(1));
clearvars ia ib S cellsmL filelistTB dt classcountTB_above_optthresh class2useTB ml_analyzedTB class_indices_path id1 id2 id3 id4 mdateTB

%% merge environmental data with IFCB data
TT=synchronize(TT,T,'first');

% make 2019 and 2021 datasets equivalent
TT(TT.LAT<40,:)=[]; % remove data south of 40 N
TT(TT.LAT>47.5 & TT.LON>-124.7,:)=[]; %remove data from the Strait
P=TT;

%%%% remove sensor data gaps
idx=ismissing(TT.TEMP); TT(idx,:)=[];
idx=ismissing(TT.PCO2); TT(idx,:)=[];

%% format for .csv file
writetimetable(TT,[filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.csv'])
save([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'TT','P');

clearvars I E T idx val

%%
% %% test plots
% % clear
% % filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% % load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis'],...
% %     'dt','filelistTB','lat','lon','class2useTB','cellsmL','temp','sal','pco2',...
% %     'chlA_ugL','pDA_ngL','NitrateM','PhosphateM','SilicateM','PNcellsmL_mcpy');
% 
% 
% figure('Units','inches','Position',[1 1 4 3.5],'PaperPositionMode','auto');
% subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.15 0.15]);
% %subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
% %where opt = {gap, width_h, width_w} describes the inner and outer spacings.
% 
% subplot(2,1,1);
% yyaxis left
%     idx=dt<datetime('01-Jan-2020');
% stem(lat(idx),T.Pseudonitzschia(idx),'-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
%     ylabel('PN cells/mL','fontsize',12); 
%     title('Hake: 2019 (top) & 2021 (bottom)')
% yyaxis right
%     plot(lat(idx),pco2(idx),'-','Markersize',6,'linewidth',.8);
%     set(gca,'xgrid','on','tickdir','out','xlim',[34 49],'xticklabel',{},'fontsize',10); 
%     ylabel('temperature','fontsize',12);        
% 
%     l=lat(idx);
%     p=pco2(idx);
% 
%     id=isnan(p);
%     l(id)=[];
%     p(id)=[];
%     %%
% subplot(2,1,2);
% yyaxis left
%     idx=dt>datetime('01-Jan-2020');
% stem(lat(idx),T.Pseudonitzschia(idx),'-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
%     ylabel('PN cells/mL','fontsize',12);    
% yyaxis right
%     plot(lat(idx),pco2(idx),'-','Markersize',6,'linewidth',.8);
%     set(gca,'xgrid','on','tickdir','out','xlim',[34 49],'fontsize',10); 
%     ylabel('temperature','fontsize',12);         
% 
% % %% set figure parameters
% % exportgraphics(gcf,[outpath 'Manual_automated_' num2str(class2do_string) '.png'],'Resolution',100)    
% % hold off
% 
% %% test plots
% % clear
% % filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% % load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis'],...
% %     'dt','filelistTB','lat','lon','class2useTB','cellsmL','temp','sal','pco2',...
% %     'chlA_ugL','pDA_ngL','NitrateM','PhosphateM','SilicateM','PNcellsmL_mcpy');
% 
% 
% figure('Units','inches','Position',[1 1 4 3.5],'PaperPositionMode','auto');
% subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.15 0.15]);
% %subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
% %where opt = {gap, width_h, width_w} describes the inner and outer spacings.
% 
% subplot(2,1,1);
% yyaxis left
% stem(dt,T.Pseudonitzschia,'-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
%     ylabel('PN cells/mL','fontsize',12); 
%     title('Hake: 2019 (top) & 2021 (bottom)')
% yyaxis right
%     plot(dt,pco2,'-','Markersize',6,'linewidth',.8);
%     datetick('x', 'mmm', 'keeplimits');        
%     set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2019-06-01') datetime('2019-09-15')],...
%         'xticklabel',{},'fontsize',10); 
%     ylabel('temperature','fontsize',12);        
% 
% subplot(2,1,2);
% yyaxis left
% stem(dt,T.Pseudonitzschia,'-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
%     ylabel('PN cells/mL','fontsize',12);    
% yyaxis right
%     plot(dt,pco2,'-','Markersize',6,'linewidth',.8);
%     set(gca,'xgrid','on','tickdir','out',...
%         'xlim',[datetime('2021-06-01') datetime('2021-09-15')],'fontsize',10); 
%     datetick('x', 'mmm', 'keeplimits');    
%     ylabel('temperature','fontsize',12);         
% 
% % %% set figure parameters
% % exportgraphics(gcf,[outpath 'Manual_automated_' num2str(class2do_string) '.png'],'Resolution',100)    
% % hold off
% 


