%% plot Dinophysis daily box and whisker plot
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

class2do_string='Dinophysis'; ymax=15;

load([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T','dtmax','ymatrix');
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
[~,label]=get_class_ind(class2do_string,'all',class_indices_path);

%% process data to only plot IFCB data when match with microscopy
dtmax.Format='dd-MMM-yyyy';
T(isnan(T.dinoML_microscopy),:)=[];
[dtt,ia,ib]=intersect(T.dt,dtmax);
m=T.dinoML_microscopy(ia);
ifcb=ymatrix(:,ib);

dt(1,:)=datetime('01-Jan-2021'):1:datetime('31-Dec-2021');
dt(2,:)=datetime('01-Jan-2022'):1:datetime('31-Dec-2022');
dt(3,:)=datetime('01-Jan-2023'):1:datetime('31-Dec-2023');
n=1:1:365;
micro=NaN*ones(3,365);
dmatrix1=NaN*ones(24,365);
dmatrix2=dmatrix1;
dmatrix3=dmatrix1;

%2021
[ia,ib]=find(dtt==dt(1,:));
dmatrix1(:,ib)=ifcb(:,ia);
micro(1,ib)=m(ia);

%2022
[ia,ib]=find(dtt==dt(2,:));
dmatrix2(:,ib)=ifcb(:,ia);
micro(2,ib)=m(ia);

%2023
[ia,ib]=find(dtt==dt(3,:));
dmatrix3(:,ib)=ifcb(:,ia);
micro(3,ib)=m(ia);

clearvars dtmax ia ib ymatrix T dtt ifcb m

%% process data to plot all data
dt(1,:)=datetime('01-Jan-2021'):1:datetime('31-Dec-2021');
dt(2,:)=datetime('01-Jan-2022'):1:datetime('31-Dec-2022');
dt(3,:)=datetime('01-Jan-2023'):1:datetime('31-Dec-2023');
n=1:1:365;
micro=NaN*ones(3,365);
dmatrix1=NaN*ones(24,365);
dmatrix2=dmatrix1;
dmatrix3=dmatrix1;

%2021
[ia,ib]=find(dtmax==dt(1,:));
dmatrix1(:,ib)=ymatrix(:,ia);
[ia,ib]=find(T.dt==dt(1,:));
micro(1,ib)=T.dinoML_microscopy(ia);

%2022
[ia,ib]=find(dtmax==dt(2,:));
dmatrix2(:,ib)=ymatrix(:,ia);
[ia,ib]=find(T.dt==dt(2,:));
micro(2,ib)=T.dinoML_microscopy(ia);

%2023
[ia,ib]=find(dtmax==dt(3,:));
dmatrix3(:,ib)=ymatrix(:,ia);
[ia,ib]=find(T.dt==dt(3,:));
micro(3,ib)=T.dinoML_microscopy(ia);

clearvars dtmax ia ib ymatrix T

%% plot
figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(3,1,1)
    boxchart(dmatrix1,'JitterOutliers','on','MarkerStyle','.','boxwidth',3); hold on
    plot(n,micro(1,:),'r^','markerfacecolor','r','Linewidth',.8,'markersize',4); hold on;            
    ylabel('2021','fontsize',11);     
    set(gca,'box','on','ylim',[0 6],'XLim',[string(120) string(270)],...
        'XTick',string(120:30:270),'tickdir','out','xticklabel',[])
    title([ char(label) ' cells/mL']);

subplot(3,1,2)
    boxchart(dmatrix2,'JitterOutliers','on','MarkerStyle','.','boxwidth',3); hold on
    plot(n,micro(2,:),'r^','markerfacecolor','r','Linewidth',.8,'markersize',4); hold on;            
    ylabel('2022','fontsize',11);     
    set(gca,'box','on','ylim',[0 15],'XLim',[string(120) string(270)],...
        'XTick',string(120:30:270),'tickdir','out','xticklabel',[])

subplot(3,1,3)
    hb=boxchart(dmatrix3,'JitterOutliers','on','MarkerStyle','.','boxwidth',3); hold on
    hm=plot(n,micro(3,:),'r^','markerfacecolor','r','Linewidth',.8,'markersize',4); hold on;            
    ylabel('2023','fontsize',11);     
    set(gca,'box','on','ylim',[0 6],'XLim',[string(120) string(270)],...
        'XTick',string(120:30:270),'tickdir','out','xticklabel',{'M','J','J','A','S','O'})
 
lh=legend([hb hm],'IFCB FL','microscopy','location','nw');  hp=get(lh,'pos');
    lh.Position=[hp(1)-.01 hp(2)+.6 hp(3) hp(4)]; hold on    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Boxchart_' class2do_string 'IFCB_fl_microscopy.png'],'Resolution',100)    
hold off