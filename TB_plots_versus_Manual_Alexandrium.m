%% code to plot both SFB and SCW here. Cannot plot both at same time.

resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
%resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\';

load([resultpath 'Data\rai_data']);

all_files=dir([resultpath 'Data\Alexandrium\']);
all_files(1:2) = [];

for j = 1:length(all_files)
    load([resultpath 'Data\Alexandrium\' all_files(j).name]);
        
load('F:\IFCB104\manual\summary\count_biovol_manual_27Feb2018'); %USER
% load('F:\IFCB113\manual\summary\count_biovol_manual_07Mar2018'); %USER

summary_path = 'F:\IFCB104\class\summary\'; %load automated count file with all 
% summary_path = 'F:\IFCB113\class\summary\'; %load automated count file with all thresholds you made from running 'countcells_allTB_class_by_thre_user.m'

load([summary_path 'summary_allTB_bythre_' class2do_string]);

for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files

% Makes day bins for the matched automated counts. I've used column 6 because this is for the 0.5 threshold. 
[matdate_bin_match, classcount_bin_match, ml_analyzed_mat_bin_match] = make_day_bins(mdateTB(it),classcountTB_above_thre(it,bin),ml_analyzedTB(it)); 

% Takes the series of day bins for automated counts and puts it into a year x day matrix.
[ mdate_mat_match, y_mat_match, yearlist, yd] = timeseries2ydmat(matdate_bin_match,classcount_bin_match./ml_analyzed_mat_bin_match ); 

y_mat=classcountTB_above_thre(:,bin)./ml_analyzedTB(:);
y_mat((y_mat<0)) = 0; % cannot have negative numbers 

ind2 = strmatch(class2do_string, class2use); %change this for whatever class you are analyzing

% Makes day bins for the matched manual counts.
[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] = make_day_bins(matdate(im),classcount(im,ind2), ml_analyzed(im)); 

% Takes the series of day bins and puts it into a year x day matrix.
[mdate_mat_manual, y_mat_manual, yearlist, yd] = timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto); 

ind=(find(y_mat)); % find dates associated with nonzero elements
mdate_val=[mdateTB(ind),y_mat(ind)];

Alex(j).name=class2do_string;
Alex(j).bin=bin;
Alex(j).slope=slope;
Alex(j).chosen_threshold=chosen_threshold;
Alex(j).mdateTB=mdateTB;
Alex(j).y_mat=y_mat;
Alex(j).mdate_mat_manual=mdate_mat_manual;
Alex(j).y_mat_manual=y_mat_manual;
end

Alex(5).name = 'Alexandrium';
Alex(5).chosen_threshold=chosen_threshold;
Alex(5).bin=bin;
Alex(5).slope=slope;
Alex(5).y_mat=sum([2*Alex(1).y_mat,4*Alex(2).y_mat,Alex(3).y_mat,3*Alex(4).y_mat],2);
Alex(5).y_mat_manual(:,1)=sum([2*Alex(1).y_mat_manual(:,1),4*Alex(2).y_mat_manual(:,1),Alex(3).y_mat_manual(:,1),3*Alex(4).y_mat_manual(:,1)],2);
Alex(5).y_mat_manual(:,2)=sum([2*Alex(1).y_mat_manual(:,2),4*Alex(2).y_mat_manual(:,2),Alex(3).y_mat_manual(:,2),3*Alex(4).y_mat_manual(:,2)],2);
Alex(5).mdateTB=datenum(datestr(Alex(4).mdateTB),'dd-mm-yyyy');
Alex(5).mdate_mat_manual=Alex(4).mdate_mat_manual;
Alex(5).filelist=string(filelistTB);

save([resultpath 'Data\Alexandrium_summary'],'Alex');

%% plot Santa Cruz Wharf
load 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\Data\SCW_microscopydata.mat' %load cell count data

figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.07 0.04], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

% rai
subplot(2,1,1) 
sz=linspace(1,150,100); 
A=r(12).species';
A(A<=.01)=.01; %replace values <0 with 0.01       
Asz=zeros(length(A),1); %preallocate space   
for j=1:length(Asz)  % define sizes according to cyst abundance
     Asz(j)=sz(round(A(j)*length(sz)));
end
h4=scatter(r(13).dn',ones(size(r(13).dn')),Asz,'b','filled');
hold on

set(gca,'ylim',[0 10],'Visible','off',...
    'xlim',[datenum('2016-08-01') datenum('2017-06-30')],...
    'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
    datenum('2016-10-01'),datenum('2016-11-01'),...
    datenum('2016-12-01'),datenum('2017-01-01'),...
    datenum('2017-02-01'),datenum('2017-03-01'),...
    datenum('2017-04-01'),datenum('2017-05-01'),...
    datenum('2017-06-01')],...
    'XTickLabel',{'Aug','Sep','Oct','Nov','Dec','Jan17',...
    'Feb','Mar','Apr','May','Jun'},...
    'YTickLabel',{},'XTickLabel',{},'tickdir','out');  
hold on

subplot(2,1,2);
h1=stem(mdateTB, Alex(5).y_mat,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 

% %plots only matching MC
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(y_mat_match(:,i)));
%     h1=stem(mdate_mat_match(ind_nan,i), y_mat_match(ind_nan,i)/slope,'kd-','Markersize',4); %This adjusts the automated counts by the chosen slope.     
%     hold on
% end

hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(Alex(5).y_mat_manual(:,i)));
    h2=plot(Alex(5).mdate_mat_manual(ind_nan,i), Alex(5).y_mat_manual(ind_nan,i),'r*','Markersize',5,'linewidth',1.2);
end

hold on
h3=plot(mcr.alexandrium.dn, mcr.alexandrium.avg,'bo','Markersize',4,'linewidth',1.2,'markerfacecolor','w');

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
ylabel(['\it' 'Alexandrium' '\rm cells mL^{-1}\bf'],...
    'fontsize',12, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-11-05'),0,datenum('2017-02-22'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2017-03-28'),0,datenum('2017-04-20'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
lh = legend([h1,h2,h3,h4], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy','Relative abundance index');
set(lh,'fontsize',9,'Position',[0.4101562530653 0.621961804895869 0.27213541053546 0.18098957836628]);

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Manual_automated_Alexandrium.tif']);
hold off

%% plot SFB
figure('Units','inches','Position',[1 1 5 3],'PaperPositionMode','auto');

h1=stem(mdateTB, Alex(5).y_mat,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
%plot(mdateTB(:), classcountTB_above_thre(:,6)/.65*1000,'k-') %This adjusts the automated counts by the chosen slope. 

% %plots only matching MC
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(y_mat_match(:,i)));
%     h1=stem(mdate_mat_match(ind_nan,i), y_mat_match(ind_nan,i)/slope,'kd-','Markersize',4); %This adjusts the automated counts by the chosen slope.     
%     hold on
% end

% hold on
% plots MC
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(A_manual(:,i)));
%     h2=plot(mdate_mat_manual(ind_nan,i), A_manual(ind_nan,i),'r*','Markersize',4,'linewidth',1.2);
% end

hold all
datetick,set(gca, 'xgrid', 'on')

set(gca, 'fontsize', 11, 'fontname', 'Arial')
set(gcf,'units','inches')
set(gcf,'position',[5 6 8 3],'paperposition', [-0.5 3 12 4]);
set(gcf,'color','w')
set(gca,'ylim',[0 12],'ytick',0:4:12,...
    'xlim',[datenum('2017-07-30') datenum('2018-03-30')],...
        'xtick',[datenum('2017-08-01'),datenum('2017-09-01'),...
        datenum('2017-10-01'),datenum('2017-11-01'),...
        datenum('2017-12-01'),datenum('2018-01-01'),...
        datenum('2018-02-01'),datenum('2018-03-01')],...
        'XTickLabel',{'Aug','Sep','Oct','Nov','Dec','Jan18',...
        'Feb','Mar'},'tickdir','out');
ylabel(['\it' 'Alexandrium' '\rm cells mL^{-1}\bf'],...
    'fontsize',12, 'fontname', 'Arial');   
hold on

% lh = legend([h1,h2,h3], ['Automated classification'],...
%     'Manual classification','Location','NorthOutside');
% set(lh,'fontsize',10);
hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Manual_automated_Alexandrium.tif']);
hold off
