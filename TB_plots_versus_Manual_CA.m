class2do_string = 'Cryptophyte'; 

resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
load([resultpath 'Data\Coeff_' class2do_string]);

load('F:\IFCB104\manual\summary\count_biovol_manual_22Jun2018'); %USER
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
% ymax=1000; tick=100; %Akashiwo
% ymax=150; tick=50; %Prorocentrum
%ymax=5; tick=10; %Pseudo-nitzschia
%ymax=150; tick=50; %Chaetoceros

% Cryptophyte
%     '26-Feb-2018 15:51:56'
%     '08-Mar-2018 06:37:01'   
% Centric
%     '28-Apr-2017 04:41:44'
%     '26-Feb-2018 15:51:56'
% Det_Cer_Lau
%     '05-May-2017 05:01:11'
%     '08-Feb-2018 09:45:29'    
%     '26-Feb-2018 15:51:56'
% Eucampia
%     '26-May-2017 01:13:17'
%     '26-Feb-2018 15:51:56'
% Lingulodinium
%     '22-Jan-2018 20:57:57'
%     '23-Jan-2018 00:04:48'
% PN
%     '13-Jun-2017 07:48:32'
%     '26-Feb-2018 15:51:56'
%     '27-Feb-2018 10:48:12'
%     '01-Mar-2018 06:18:05'
% Chaetoceros
%     '26-Apr-2017 21:51:35'
%     '27-Apr-2017 00:13:44'
%     '07-Feb-2018 11:33:13'
%     '08-Feb-2018 09:45:29'
%     '26-Feb-2018 15:51:56'
% Ceratium
%     '18-Aug-2016 03:49:55'
%     '02-Feb-2018 20:34:36'
%     '26-Feb-2018 15:51:56'
%     '14-May-2018 02:07:06'
% Dinophysis
%     '04-Aug-2016 05:59:00'    
%     '01-Apr-2018 02:07:37'
%     '28-Apr-2017 04:18:03'
%     '01-Nov-2016 23:12:59'
% Akashiwo
%     '15-Oct-2016 20:16:06'
%     '01-Nov-2016 22:25:30'   
%     '26-Feb-2018 15:51:56'
%     '13-May-2018 06:38:36'
%     '15-May-2018 23:22:07'
%     '17-May-2018 04:11:58'   
%     '26-May-2018 05:52:22'
% Prorocentrum
%     '11-Aug-2016 22:21:58'
%     '21-Aug-2016 00:51:16'   
%     '26-Feb-2018 15:51:56'
%     '12-May-2018 03:23:09'
%     '14-May-2018 22:45:36'     
% Thalassiosira
%     '04-Aug-2016 01:38:29'
% Skeletonema
%     '26-Apr-2017 23:26:22'
%     '26-Feb-2018 15:51:56'

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

datetick('x', 'm', 'keeplimits')
xlim(datenum(['01-Aug-2016';'01-Jul-2018']))

set(gca,'xgrid','on','fontsize', 10, 'fontname', 'arial','tickdir','out')
hold on

%set(gca,'xgrid', 'on','ylim',[0 2000]);

% set(gca,'xgrid', 'on','ylim',[0 ymax],'ytick',0:tick:ymax,... 
%     'xlim',[datenum('2018-01-01') datenum('2018-07-01')],...
%     'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
%     datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
%     datenum('2018-06-01'),datenum('2018-07-01')],...    
%     'Xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul'},'tickdir','out');  

ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
    'fontsize',12, 'fontname', 'Arial');    
 
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');

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