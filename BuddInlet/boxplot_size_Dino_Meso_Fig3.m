% plot Dinophysis box and whiskers chart
clear

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
ifcbpath = '~/Documents/MATLAB/ifcb-data-science/';
addpath(genpath(filepath));
addpath(genpath(ifcbpath));

% eliminated odiosa, acuta, rodundata bc <10 cells were observed
load([ifcbpath 'IFCB-Data/BuddInlet/manual/summary_dinophysis_species_width_manual'],'mdate',...
    'acuminata','fortii','norvegica','parva','unknownDinophysis');
load([ifcbpath 'IFCB-Data/BuddInlet/manual/summary_meso_width_manual'],'ESD');

% remove data from October-March
dt=datetime(mdate,'convertfrom','datenum');
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12);
dt(idx)=[]; acuminata(idx)=[]; fortii(idx)=[]; norvegica(idx)=[]; parva(idx)=[]; ESD(idx)=[];

acuminata=cell2mat(acuminata);
fortii=cell2mat(fortii);
norvegica=cell2mat(norvegica);
parva=cell2mat(parva);
ESD=cell2mat(ESD);

%split into small and large Mesodinium
idx=(ESD<=19);
smallM=NaN*(ESD); largeM=NaN*(ESD);
smallM=ESD(idx); largeM=ESD(~idx);
clearvars ESD idx mdate

ESD=[fortii;norvegica;acuminata;parva;largeM;smallM];
species=([repmat({'fortii'},length(fortii),1);...
    repmat({'norvegica'},length(norvegica),1);...
    repmat({'acuminata'},length(acuminata),1);...    
    repmat({'parva'},length(parva),1);...
    repmat({'largeM'},length(largeM),1);...    
    repmat({'smallM'},length(smallM),1)]);

figure('Units','inches','Position',[1 1 6.7 3.5],'PaperPositionMode','auto');
boxplot(ESD,species); hold on;
    set(gca,'ylim',[8 70],'ytick',10:20:70,'fontsize',11,'tickdir','out');
    ylabel('Equivalent spherical diameter (μm)','fontsize',12)
%xtickangle(0);

% set figure parameters
exportgraphics(gcf,[filepath 'BuddInlet/Figs/Dinophysis_Mesodinium_BoxWhiskers.png'],'Resolution',300)    
hold off
