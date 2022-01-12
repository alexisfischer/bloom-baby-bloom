clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
addpath(genpath('~/MATLAB/UCSC/')); % add new data to search path

filepath1 = '~/MATLAB/bloom-baby-bloom/IFCB-Data/SCW/class/';
filepath2 = '~/MATLAB/UCSC/SCW/Data/';
class2do_string = 'Pseudo-nitzschia'; chain=4; yr='2018'; error=0.7;
[class2do_string,mdate,~,~,iraifx,fish,mcrpy,RAI]=matchClassifierwMicroscopy(filepath1,filepath2,class2do_string,chain,error,'2018');

load([filepath1 'summary_allTB_' yr],'class2useTB','ml_analyzedTB','mdateTB','classcountTB_above_optthresh');
y_mat=classcountTB_above_optthresh(:,strcmp(class2do_string, class2useTB)).*chain; %class
y_mat=y_mat./ml_analyzedTB;

clearvars classcountTB_above_optthresh ml_analyzedTB class2useTB;

figure('Units','inches','Position',[1 1 7 3],'PaperPositionMode','auto');
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     

bar(mdateTB, y_mat,'FaceColor','k','Barwidth',12); hold on
h1=plot(datenum('01-Jan-2019'),2,'linewidth',2,'color','k'); hold on     
h3 = errorbar(fish.dn,fish.cells,fish.err,'o','Linestyle','none','Linewidth',1.5,...
'Color','r','MarkerFaceColor','r','Markersize',4); hold on  

  %  errorbar(mcrpy.dn,mcrpy.cells,mcrpy.err,'^','Color',col(1,:),'Linestyle','none','Linewidth',1.5,'Markersize',4); hold on    
    set(gca,'xlim',[xax1 xax2],'xaxislocation','bottom','ytick',0:20:100,'fontsize',14,'Ylim',[0 110],'tickdir','out');  
    datetick('x','m','keeplimits');       
    ylabel(['\it' class2do_string ' \rmcells/mL'],'fontsize',16); hold on    

    legend([h1,h3],'Classified IFCB','FISH Microscopy','Location','E','fontsize',13);
    legend boxoff
%%
set(gcf,'color','w');
print(gcf,'-dtiff','-r400',['~/MATLAB/UCSC/SCW/Figs/' num2str(class2do_string) '_cells_SCW2018.tif']);
hold off