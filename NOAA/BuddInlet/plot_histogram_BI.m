clear
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
% addpath(genpath(filepath));
% addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

filepath = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';

%%%% load in data and format dataset
%remove: discrete samples, PMTA triggers, and data from October-March
load([filepath 'IFCB-Data/BuddInlet/eqdiam_biovol_2021'],'ESD','matdate','filecomment','runtype');
dt=datetime(matdate,'convertfrom','datenum');
idx=find(contains(filecomment,'trigger')); ESD(idx)=[]; dt(idx)=[]; runtype(idx)=[]; 
idx=find(contains(runtype,{'ALT','Alternative'})); ESD(idx)=[];  dt(idx)=[];
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12); ESD(idx)=[]; dt(idx)=[]; 
E1=ESD;
clearvars runtype filecomment dt idx matdate ESD

load([filepath 'IFCB-Data/BuddInlet/eqdiam_biovol_2022'],'ESD','matdate','filecomment','runtype');
dt=datetime(matdate,'convertfrom','datenum');
idx=find(contains(filecomment,'trigger')); ESD(idx)=[]; dt(idx)=[]; runtype(idx)=[]; 
idx=find(contains(runtype,{'ALT','Alternative'})); ESD(idx)=[];  dt(idx)=[];
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12); ESD(idx)=[]; dt(idx)=[]; 
E2=ESD;
clearvars runtype filecomment dt idx matdate ESD

load([filepath 'IFCB-Data/BuddInlet/eqdiam_biovol_2023'],'ESD','matdate','filecomment','runtype');
dt=datetime(matdate,'convertfrom','datenum');
idx=find(contains(filecomment,'trigger')); ESD(idx)=[]; dt(idx)=[]; runtype(idx)=[]; 
idx=find(contains(runtype,{'ALT','Alternative'})); ESD(idx)=[];  dt(idx)=[];
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12); ESD(idx)=[]; dt(idx)=[]; 
E3=ESD;
clearvars runtype filecomment dt idx matdate ESD
% 
% e1=length(cell2mat(E1)); %3493761 %2483 samples
% e2=length(cell2mat(E2)); %5873360 %7370 samples 
% e3=length(cell2mat(E3)); %26575589 %8969 samples

%% plot all particles
c=brewermap(3,'Set2'); 

figure('Units','inches','Position',[1 1 3.5 2],'PaperPositionMode','auto');
    histogram(cell2mat(E1),0:1:70,'DisplayStyle','stairs','edgecolor',c(1,:)); hold on
    histogram(cell2mat(E2),0:1:70,'DisplayStyle','stairs','edgecolor',c(2,:)); hold on
    histogram(cell2mat(E3),0:1:70,'DisplayStyle','stairs','edgecolor',c(3,:)); hold on
    set(gca,'xlim',[0 50],'fontsize',10,'tickdir','out');
    ylabel('particle count','fontsize',11)
    xlabel('ESD (\mum)')    
    legend('2021 (g.63, t.138)','2022 (g.60, t.125)','2023 (g.70, t.140)'); legend boxoff;

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA\BuddInlet\Figs\BI_particle_size_distribution.png'],'Resolution',100)    
%exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/BI_particle_size_distribution.png'],'Resolution',100)    
hold off

%%%% plot Mesodinium and all particles ESD together
%load([filepath 'IFCB-Data/BuddInlet/manual/summary_meso_width_manual'],'mdate','ESD');
load([filepath 'IFCB-Data\BuddInlet\manual\summary_meso_width_manual'],'mdate','ESD');
%remove: discrete samples and PMTA triggers
idx=find(contains(filecomment,'trigger')); ESD(idx)=[]; mdate(idx)=[]; filecomment(idx)=[]; runtype(idx)=[];
idx=find(contains(runtype,{'ALT','Alternative'})); ESD(idx)=[]; mdate(idx)=[]; filecomment(idx)=[]; runtype(idx)=[];
dt=datetime(mdate,'convertfrom','datenum')';

% remove data from October-March
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12);
dt(idx)=[]; ESD(idx)=[];

c=brewermap(3,'Set2'); 
figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.05], [0.19 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1)
    histogram(cell2mat(E1),0:1:70,'DisplayStyle','stairs','edgecolor',c(1,:)); hold on
    histogram(cell2mat(E2),0:1:70,'DisplayStyle','stairs','edgecolor',c(2,:)); hold on
    histogram(cell2mat(E3),0:1:70,'DisplayStyle','stairs','edgecolor',c(3,:)); hold on
    set(gca,'ylim',[0 5*10^6],'xlim',[0 50],'xticklabel',{},'fontsize',10,'tickdir','out');
    ylabel('particle count','fontsize',11)
    xline(19,':','linewidth',1.5); hold on;    
    legend('2021 (g.63, t.138)','2022 (g.60, t.125)','2023 (g.70, t.140)'); legend boxoff;

subplot(2,1,2)
yrlist=[2021;2022;2023];
for i=1:length(yrlist)
    idx=(dt.Year==yrlist(i));
    histogram(cell2mat([ESD(idx)]),0:1:70,'DisplayStyle','stairs','edgecolor',c(i,:)); hold on
    set(gca,'xlim',[0 50],'xtick',0:10:50,'ylim',[0 550],'ytick',0:250:500, ...
       'fontsize',10,'tickdir','out'); hold on;    
    ylabel('particle count','fontsize',11)
end
    xline(19,':',{'19 \mum'},'linewidth',1.5); hold on;
    ylabel('Mesodinium count','fontsize',11)    
    xlabel('ESD (\mum)')    

% set figure parameters
%exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Mesodinium_ESD_histogram_yr.png'],'Resolution',100)    
exportgraphics(gcf,[filepath 'NOAA\BuddInlet\Figs\Mesodinium_ESD_histogram_yr.png'],'Resolution',100)    
hold off
