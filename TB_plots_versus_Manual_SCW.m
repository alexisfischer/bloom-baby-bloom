class2do_string = 'Chaetoceros'; 

resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
load([resultpath 'Data\Coeff_' class2do_string]);

load('F:\IFCB104\manual\summary\count_biovol_manual_30Mar2018'); %USER
summary_path = 'F:\IFCB104\class\summary\'; %load automated count file with all thresholds you made from running 'countcells_allTB_class_by_thre_user.m'
load([summary_path 'summary_allTB_bythre_' class2do_string]);

load([resultpath 'Data\RAI_SCW'],'r');
%load([resultpath 'Data\SCW_microscopydata.mat']); %load cell count data

for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files

% Makes day bins for the matched automated counts. I've used column 6 because this is for the 0.5 threshold. 
[matdate_bin_match, classcount_bin_match, ml_analyzed_mat_bin_match] =...
    make_day_bins(mdateTB(it),classcountTB_above_thre(it,bin),ml_analyzedTB(it)); 

% Takes the series of day bins for automated counts and puts it into a year x day matrix.
[ mdate_mat_match, y_mat_match, yearlist, yd ] =...
    timeseries2ydmat(matdate_bin_match,classcount_bin_match./ml_analyzed_mat_bin_match ); 

y_mat=classcountTB_above_thre(:,bin)./ml_analyzedTB(:);
y_mat((y_mat<0)) = 0; % cannot have negative numbers 

ind2 = strmatch(class2do_string, class2use); %change this for whatever class you are analyzing

% Makes day bins for the matched manual counts.
[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] =...
    make_day_bins(matdate(im),classcount(im,ind2), ml_analyzed(im)); 

% Takes the series of day bins and puts it into a year x day matrix.
[mdate_mat_manual, y_mat_manual, yearlist, yd ] =...
    timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto); 

ind=(find(y_mat)); % find dates associated with nonzero elements
mdate_val=[mdateTB(ind),y_mat(ind)];

%% Winter/Spring 2018
figure('Units','inches','Position',[1 1 8 2.5],'PaperPositionMode','auto');

%auto
h1=stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
hold on

%manual
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
end
hold on

% ymax=400; tick=100; %Akashiwo
% ymax=150; tick=50; %Prorocentrum
% ymax=25; tick=10; %Pseudo-nitzschia
ymax=150; tick=50; %Chaetoceros

set(gca,'xgrid', 'on','ylim',[0 ymax],'ytick',0:tick:ymax,... 
    'xlim',[datenum('2018-01-01') datenum('2018-07-01')],...
    'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01')],...    
    'Xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul'},'tickdir','out');          
    ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
        'fontsize',12, 'fontname', 'Arial');    
 
hold on
vfill([datenum('2018-01-28'),0,datenum('2018-02-01'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2018-02-09'),0,datenum('2018-02-15'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2018-03-02'),0,datenum('2018-03-06'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2018-04-14'),0,datenum('2018-04-17'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2018-04-28'),0,datenum('2018-05-11'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification');
set(lh,'fontsize',9,'Location','NorthEast');

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% Akashiwo (Autumn 2016)
figure('Units','inches','Position',[1 1 8 2.5],'PaperPositionMode','auto');

h1=stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
hold on

%manual
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
end
hold on

%microscopy
h3=plot(mcr.akashiwo.dn, mcr.akashiwo.avg,'b^','Markersize',3,'linewidth',1,'markerfacecolor','w');
hold all

datetick('x','m')
set(gca,'xgrid', 'on','ylim',[0 800],'ytick',0:200:800,...
    'xlim',[datenum('2016-08-01') datenum('2016-11-06')],'tickdir','out');    
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
        'fontsize',12, 'fontname', 'Arial');    
    hold on
 
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');

lh = legend([h1,h2,h3], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy');
set(lh,'fontsize',9,'Location','NorthWest');

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off