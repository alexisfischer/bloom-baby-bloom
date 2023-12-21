%% plot Dinophysis microscopy in Budd Inlet and vs other sites
clear;
fprint=0;
class2do_string='Dinophysis_grouped'; ymax=20; class2do_full='Dinophysis_acuminata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_parva';

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));

load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy'],'T');
load([filepath 'IFCB-Data/BuddInlet/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');

imclass=find(contains(class2use,'Dinophysis'));
man=sum(classcount(:,imclass),2)./ml_analyzed;
dt=datetime(matdate,'convertfrom','datenum');

%%% plot BI 
figure('Units','inches','Position',[1 1 5 3],'PaperPositionMode','auto'); 

xax1=datetime('2021-07-20'); xax2=datetime('2022-9-20');     

plot(T.SampleDate,.001*T.DinophysisConcentrationcellsL,'ko-',...
    dt,man,'b*','MarkerSize',5); hold on

    set(gca,'xlim',[xax1 xax2],...
        'fontsize', 11,'fontname', 'arial','tickdir','out');  
    datetick('x', 'mm/yy', 'keeplimits');        
    ylabel('Dinophysis (cells/mL)','fontsize',11);
    legend('Microscopy','IFCB','Location','NW')


% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/BI_Dinophysis_Microscopy_IFCB.png'],'Resolution',100)    
hold off