%% plot histogram of particles and Mesodinium in BI 
% used to evaluate if differences in IFCB detection settings affected
% detection of small Mesodinum
% must be executed on Desktop computer because files are too big

clear

filepath = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
ifcbpath = 'C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\';
addpath(genpath(filepath));
addpath(genpath(ifcbpath));

%%%% load in data and format dataset
load([ifcbpath 'IFCB-Data\BuddInlet\eqdiam_biovol_2021'],'ESD','matdate','filecomment','runtype');
dt=datetime(matdate,'convertfrom','datenum');
idx=(contains(filecomment,'trigger')); ESD(idx)=[]; dt(idx)=[]; runtype(idx)=[]; 
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12); ESD(idx)=[]; runtype(idx)=[]; 
idx=(contains(runtype,{'ALT','Alternative'})); E1a=ESD(idx); E1b=ESD(~idx);  

load([ifcbpath 'IFCB-Data\BuddInlet\eqdiam_biovol_2022'],'ESD','matdate','filecomment','runtype');
dt=datetime(matdate,'convertfrom','datenum');
idx=(contains(filecomment,'trigger')); ESD(idx)=[]; dt(idx)=[]; runtype(idx)=[]; 
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12); ESD(idx)=[]; runtype(idx)=[]; 
idx=(contains(runtype,{'ALT','Alternative'})); E2a=ESD(idx); E2b=ESD(~idx);  

load([ifcbpath 'IFCB-Data\BuddInlet\eqdiam_biovol_2023'],'ESD','matdate','filecomment','runtype');
dt=datetime(matdate,'convertfrom','datenum');
idx=(contains(filecomment,'trigger')); ESD(idx)=[]; dt(idx)=[]; runtype(idx)=[]; 
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12); ESD(idx)=[]; runtype(idx)=[]; 
idx=(contains(runtype,{'ALT','Alternative'})); E3a=ESD(idx); E3b=ESD(~idx);  

% e1=length(cell2mat(E1b)); %3493761 %2483 samples
% e2=length(cell2mat(E2b)); %5873360 %7370 samples 
% e3=length(cell2mat(E3b)); %26575589 %8969 samples

%%%% plot Mesodinium and all particles ESD together
load([ifcbpath 'IFCB-Data\BuddInlet\manual\summary_meso_width_manual'],'filecomment','runtype','mdate','ESD');
%remove: discrete samples, PMTA triggers, and data from October-March
dt=datetime(mdate,'convertfrom','datenum')';
idx=(contains(filecomment,'trigger')); ESD(idx)=[]; dt(idx)=[]; runtype(idx)=[];
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12); ESD(idx)=[]; runtype(idx)=[]; dt(idx)=[]; 
idx=(contains(runtype,{'ALT','Alternative'})); Ma=ESD(idx); Mb=ESD(~idx); dta=dt(idx); dtb=dt(~idx);

clearvars runtype filecomment dt idx matdate ESD

c=brewermap(3,'Set2'); 

%%%% plot PMTB
figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.05], [0.19 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1)
    histogram(cell2mat(E1b),0:1:70,'DisplayStyle','stairs','edgecolor',c(1,:),'linewidth',1.5); hold on
    histogram(cell2mat(E2b),0:1:70,'DisplayStyle','stairs','edgecolor',c(2,:),'linewidth',1.5); hold on
    histogram(cell2mat(E3b),0:1:70,'DisplayStyle','stairs','edgecolor',c(3,:),'linewidth',1.5); hold on
    set(gca,'xlim',[0 50],'xticklabel',{},'fontsize',10,'tickdir','out');
    ylabel('particle count','fontsize',11)
    xline(19,':',{'19 \mum'},'linewidth',1.5); hold on;   

subplot(2,1,2)
hx=histogram(cell2mat(Ma(dta.Year==2022)),0:1:70,'DisplayStyle','stairs','edgecolor','k','linewidth',1.5); hold on    
yrlist=[2021;2022;2023];
for i=1:length(yrlist)
    idx=(dtb.Year==yrlist(i));
    h(i)=histogram(cell2mat([Mb(idx)]),0:1:70,'DisplayStyle','stairs','edgecolor',c(i,:),'linewidth',1.5); hold on
end
    xline(19,':','linewidth',1.5); hold on;    
    set(gca,'xlim',[0 50],'xtick',0:10:50,'fontsize',10,'tickdir','out'); hold on;    
    ylabel('Mesodinium count','fontsize',11)    
    xlabel('ESD (\mum)')  
    legend([h(1) h(2) hx h(3)],'2021 (B.63, t.138)','2022 (B.60, t.125)','2022 (A.50, t.250)','2023 (B.70, t.140)'); legend boxoff;    

% set figure parameters
exportgraphics(gcf,[filepath 'BuddInlet\Figs\Mesodinium_ESD_histogram.png'],'Resolution',100)    
hold off

%% plot all particles
figure('Units','inches','Position',[1 1 3.5 2],'PaperPositionMode','auto');
    histogram(cell2mat(E1b),0:1:70,'DisplayStyle','stairs','edgecolor',c(1,:)); hold on
    histogram(cell2mat(E2b),0:1:70,'DisplayStyle','stairs','edgecolor',c(2,:)); hold on
    histogram(cell2mat(E3b),0:1:70,'DisplayStyle','stairs','edgecolor',c(3,:)); hold on
    set(gca,'xlim',[0 50],'fontsize',10,'tickdir','out');
    ylabel('particle count','fontsize',11)
    xlabel('ESD (\mum)')    
    legend('2021 (PMTB: .63, t.138)','2022 (PMTB: .60, t.125)','2023 (PMTB: .70, t.140)'); legend boxoff;

% set figure parameters
exportgraphics(gcf,[filepath 'BuddInlet\Figs\BI_particle_size_distribution_PMTA.png'],'Resolution',100)    
hold off