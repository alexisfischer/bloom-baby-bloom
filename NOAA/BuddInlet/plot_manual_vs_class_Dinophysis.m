% plot Dinophysis in Budd Inlet
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;
fprint=0;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); 

%%%% load in manual data
load([filepath 'IFCB-Data/BuddInlet/manual/count_class_manual'],...
   'class2use','ml_analyzed','matdate','classcount','filecomment','runtype');
idx=~strcmp(filecomment,{' '}); % remove discrete samples
ml_analyzed(idx)=[]; matdate(idx)=[]; classcount(idx,:)=[]; runtype(idx)=[];

%%%% load in classified data
load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB_2021-2022'],...
    'mdateTB','class2useTB','ml_analyzedTB','classcountTB_above_adhocthresh','filecommentTB','runtypeTB');
classcountTB=classcountTB_above_adhocthresh;

% remove backscatter triggered samples from data
idx=contains(runtypeTB,'ALT'); ml_analyzedTB(idx)=[]; mdateTB(idx)=[]; filecommentTB(idx)=[]; classcountTB(idx,:)=[];
idx=contains(runtype,'ALT'); ml_analyzed(idx)=[]; matdate(idx)=[]; filecomment(idx)=[]; classcount(idx,:)=[];

% separate discrete samples (data with file comment)
idx=contains(filecommentTB,' BS_trigger'); ml_analyzedBS=ml_analyzedTB(idx); mdateBS=mdateTB(idx); classcountBS=classcountTB(idx,:);
idx=contains(filecommentTB,' FL_trigger'); ml_analyzedFL=ml_analyzedTB(idx); mdateFL=mdateTB(idx); classcountFL=classcountTB(idx,:);

% delete all discrete from in situ data
idx=~strcmp(filecommentTB,{' '}); %classifier files
ml_analyzedTB(idx)=[]; mdateTB(idx)=[]; filecommentTB(idx)=[]; classcountTB(idx,:)=[];

%%%% load in microscopy data
load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy'],'T');

%%%% prepare for plotting
idc=(strcmp('Dinophysis,Dinophysis_acuminata,Dinophysis_acuta,Dinophysis_caudata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_odiosa,Dinophysis_parva,Dinophysis_rotundata,Dinophysis_tripos',class2useTB));
dinoC=(classcountTB(:,idc)./ml_analyzedTB);
idc=(strcmp('cryptophyta',class2useTB));
dtTB=datetime(mdateTB,'ConvertFrom','datenum');

idm=find(ismember(class2use,{'D_acuminata' 'D_acuta' 'D_caudata' 'D_fortii'...
    'D_norvegica' 'D_odiosa' 'D_parva' 'D_rotundata' 'D_tripos' 'Dinophysis'}));
dinoM=sum(classcount(:,idm),2)./ml_analyzed;
dt=datetime(matdate,'ConvertFrom','datenum');

%%%% plot Dinophysis manual vs classifier
%% full temporal resolution on 2022
figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto'); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.12], [0.2 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datetime('2022-06-20'); xax2=datetime('2022-09-28');     

subplot(2,1,1)
plot(T.SampleDate,T.IFCBSampleDepthm,'r--','linewidth',2);hold on;
plot(T.SampleDate,T.SampleDepths,'b:','linewidth',2);hold on;
plot([T.SampleDate';T.SampleDate'],[T.ChlMaxLower1';T.ChlMaxUpper1'],'g','linewidth',5);hold on;
plot([T.SampleDate';T.SampleDate'],[T.ChlMaxLower2';T.ChlMaxUpper2'],'g','linewidth',5);hold on;
    set(gca,'xaxislocation','top','xlim',[xax1 xax2],'ylim',[0 7],'YDir','reverse');
   % datetick('x', 'mm/dd', 'keeplimits');            
    ylabel('Depth (m)','fontsize',12);
    legend('IFCB samples','Discrete samples','Chl Max','Location','SE'); legend boxoff;
    hold on

subplot(2,1,2)
%dtTB(:),dinoC(:),'k-',
plot(dt,dinoM,'r*',T.SampleDate,.001*T.DinophysisConcentrationcellsL,'b^','markersize',5,'linewidth',1.5); hold on;
    set(gca,'xlim',[xax1 xax2],'ylim',[0 20]);
    %datetick('x', 'mm/dd', 'keeplimits');    
    ylabel({'Dinophysis';'(cells/mL)'},'fontsize',12);
    legend('IFCB (manual)','Microscopy','Location','N'); legend boxoff

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'NOAA/BuddInlet/Figs/BI_Discrete_vs_IFCB.png']);
hold off

%% manual vs classifier
figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.12], [0.2 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datetime('2021-08-01'); xax2=datetime('2022-09-28');     

subplot(2,1,1)
idx=(strcmp('Dinophysis_acuminata,Dinophysis_acuta,Dinophysis_caudata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_odiosa,Dinophysis_parva,Dinophysis_rotundata,Dinophysis_tripos', class2useTB));
plot(datetime(mdateTB,'convertfrom','datenum'),classcountTB(:,idx)./ml_analyzedTB,'k-',...
    dt,dinoM,'r*');
set(gca,'xaxislocation','top','ylim',[0 20],'xlim',[xax1 xax2])
%datetick('x', 'm', 'keeplimits');    
    ylabel({'Dinophysis';'(cells/mL)'},'fontsize',12);

subplot(2,1,2)
idx=(strcmp('Mesodinium', class2useTB));
h=plot(datetime(mdateTB,'convertfrom','datenum'),classcountTB(:,idx)./ml_analyzedTB,'k-',...
    dt,classcount(:,strcmp('Mesodinium',class2use))./ml_analyzed,'r*');
set(gca,'ylim',[0 20],'xlim',[xax1 xax2])
%datetick('x', 'm', 'keeplimits');    
    ylabel({'Mesodinium';'(cells/mL)'},'fontsize',12);
legend([h(2),h(1)],'manual','classifier','Location','NE'); legend boxoff;

% subplot(4,1,3)
% load([filepath 'NOAA/BuddInlet/Data/temp_sal_1m_3m_BuddInlet'],'H1m','H3m');
% c=brewermap(4,'Paired');
% 
% h=plot(H1m.dt,H1m.temp,'-',H3m.dt,H3m.temp,'-'); hold on
% set(h(1),'color',c(1,:)); 
% set(h(2),'color',c(2,:));
% set(gca,'xlim',[xax1 xax2],'xticklabel',{})
% ylabel({'temperature';'(^oC)'},'fontsize',12);
% legend('1m','3m','Location','NE'); legend boxoff;
% 
% subplot(4,1,4)
% h=plot(H1m.dt,H1m.sal,'-',H3m.dt,H3m.sal,'-'); hold on
% set(h(1),'color',c(3,:)); set(h(2),'color',c(4,:));
% set(gca,'xlim',[xax1 xax2])
% ylabel({'salinity';'(psu)'},'fontsize',12)
% legend('1m','3m','Location','SE'); legend boxoff;

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'NOAA/BuddInlet/Figs/BI_IFCB_ManualvsClassifer.png']);
hold off

