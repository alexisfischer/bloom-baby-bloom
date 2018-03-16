class2do_string = 'Pseudo-nitzschia'; 

resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
load([resultpath 'Data\Coeff_' class2do_string]);

load('F:\IFCB104\manual\summary\count_biovol_manual_27Feb2018'); %USER
summary_path = 'F:\IFCB104\class\summary\'; %load automated count file with all thresholds you made from running 'countcells_allTB_class_by_thre_user.m'
load([summary_path 'summary_allTB_bythre_' class2do_string]);

load([resultpath 'Data\SCW_microscopydata.mat']); %load cell count data

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

%% Akashiwo
figure('Units','inches','Position',[1 1 7 2.5],'PaperPositionMode','auto');

h1=stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
%plot(mdateTB(:), classcountTB_above_thre(:,6)/.65*1000,'k-') %This adjusts the automated counts by the chosen slope. 

% %plots only matching MC
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(y_mat_match(:,i)));
%     h1=stem(mdate_mat_match(ind_nan,i), y_mat_match(ind_nan,i)/slope,'kd-','Markersize',4); %This adjusts the automated counts by the chosen slope.     
%     hold on
% end

hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',5,'linewidth',1.2);
end

hold on

h3=plot(mcr.akashiwo.dn, mcr.akashiwo.avg,'bo','Markersize',4,'linewidth',1.2,'markerfacecolor','w');

hold all
datetick,set(gca, 'xgrid', 'on')
set(gca,'ylim',[0 800],'ytick',0:200:800,...
    'xlim',[datenum('2016-08-01') datenum('2017-06-30')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01'),...
        datenum('2016-12-01'),datenum('2017-01-01'),...
        datenum('2017-02-01'),datenum('2017-03-01'),...
        datenum('2017-04-01'),datenum('2017-05-01'),...
        datenum('2017-06-01')],...
        'XTickLabel',{'Aug','Sep','Oct','Nov','Dec','Jan17',...
        'Feb','Mar','Apr','May','Jun'},'tickdir','out');    
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
        'fontsize',13, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-11-05'),0,datenum('2017-02-22'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2017-03-28'),0,datenum('2017-04-20'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2,h3], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy','Location','North');
set(lh,'fontsize',10)

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% Dinophysis
figure('Units','inches','Position',[1 1 7 2.5],'PaperPositionMode','auto');

h1=stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
%plot(mdateTB(:), classcountTB_above_thre(:,6)/.65*1000,'k-') %This adjusts the automated counts by the chosen slope. 

% %plots only matching MC
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(y_mat_match(:,i)));
%     h1=stem(mdate_mat_match(ind_nan,i), y_mat_match(ind_nan,i)/slope,'kd-','Markersize',4); %This adjusts the automated counts by the chosen slope.     
%     hold on
% end

hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',5,'linewidth',1.2);
end

hold on

h3=plot(mcr.dinophysis.dn, mcr.dinophysis.avg,'bo','Markersize',4,'linewidth',1.2,'markerfacecolor','w');

hold all
datetick,set(gca, 'xgrid', 'on')
set(gca,'ylim',[0 12],'ytick',0:4:12,...
    'xlim',[datenum('2016-08-01') datenum('2017-06-30')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01'),...
        datenum('2016-12-01'),datenum('2017-01-01'),...
        datenum('2017-02-01'),datenum('2017-03-01'),...
        datenum('2017-04-01'),datenum('2017-05-01'),...
        datenum('2017-06-01')],...
        'XTickLabel',{'Aug','Sep','Oct','Nov','Dec','Jan17',...
        'Feb','Mar','Apr','May','Jun'},'tickdir','out');    
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
        'fontsize',13, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-11-05'),0,datenum('2017-02-22'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2017-03-28'),0,datenum('2017-04-20'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2,h3], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy','Location','North');
set(lh,'fontsize',10)

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% Prorocentrum
figure('Units','inches','Position',[1 1 7 2.5],'PaperPositionMode','auto');

h1=stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
%plot(mdateTB(:), classcountTB_above_thre(:,6)/.65*1000,'k-') %This adjusts the automated counts by the chosen slope. 

% %plots only matching MC
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(y_mat_match(:,i)));
%     h1=stem(mdate_mat_match(ind_nan,i), y_mat_match(ind_nan,i)/slope,'kd-','Markersize',4); %This adjusts the automated counts by the chosen slope.     
%     hold on
% end

hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',5,'linewidth',1.2);
end

hold on

h3=plot(mcr.prorocentrum.dn, mcr.prorocentrum.avg,'bo','Markersize',4,'linewidth',1.2,'markerfacecolor','w');

hold all
datetick,set(gca, 'xgrid', 'on')
set(gca,'ylim',[0 200],'ytick',0:50:200,...
    'xlim',[datenum('2016-08-01') datenum('2017-06-30')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01'),...
        datenum('2016-12-01'),datenum('2017-01-01'),...
        datenum('2017-02-01'),datenum('2017-03-01'),...
        datenum('2017-04-01'),datenum('2017-05-01'),...
        datenum('2017-06-01')],...
        'XTickLabel',{'Aug','Sep','Oct','Nov','Dec','Jan17',...
        'Feb','Mar','Apr','May','Jun'},'tickdir','out');    
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
        'fontsize',13, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-11-05'),0,datenum('2017-02-22'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2017-03-28'),0,datenum('2017-04-20'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2,h3], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy','Location','North');
set(lh,'fontsize',10)

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% Pseudo-nitzschia
figure('Units','inches','Position',[1 1 7 2.5],'PaperPositionMode','auto');

h1=stem(mdateTB, 4*y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
%plot(mdateTB(:), classcountTB_above_thre(:,6)/.65*1000,'k-') %This adjusts the automated counts by the chosen slope. 

% %plots only matching MC
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(y_mat_match(:,i)));
%     h1=stem(mdate_mat_match(ind_nan,i), y_mat_match(ind_nan,i)/slope,'kd-','Markersize',4); %This adjusts the automated counts by the chosen slope.     
%     hold on
% end

hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',5,'linewidth',1.2);
end

hold on

h3=plot(mcr.pseudonitzschia.dn, mcr.pseudonitzschia.avg,'bo','Markersize',4,'linewidth',1.2,'markerfacecolor','w');

hold all
datetick,set(gca, 'xgrid', 'on')
set(gca,'ylim',[0 60],'ytick',0:20:60,...
    'xlim',[datenum('2016-08-01') datenum('2017-06-30')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01'),...
        datenum('2016-12-01'),datenum('2017-01-01'),...
        datenum('2017-02-01'),datenum('2017-03-01'),...
        datenum('2017-04-01'),datenum('2017-05-01'),...
        datenum('2017-06-01')],...
        'XTickLabel',{'Aug','Sep','Oct','Nov','Dec','Jan17',...
        'Feb','Mar','Apr','May','Jun'},'tickdir','out');    
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
        'fontsize',13, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-11-05'),0,datenum('2017-02-22'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2017-03-28'),0,datenum('2017-04-20'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2,h3], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy','Location','North');
set(lh,'fontsize',10)

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off