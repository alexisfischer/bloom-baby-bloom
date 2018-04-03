class2do_string = 'Akashiwo'; 

resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
load([resultpath 'Data\Coeff_' class2do_string]);

load('F:\IFCB104\manual\summary\count_biovol_manual_30Mar2018'); %USER
summary_path = 'F:\IFCB104\class\summary\'; %load automated count file with all thresholds you made from running 'countcells_allTB_class_by_thre_user.m'
load([summary_path 'summary_allTB_bythre_' class2do_string]);

load([resultpath 'Data\RAI_SCW']);
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
figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.07], [0.07 0.04], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

%fall period
subplot(2,3,1) 
    sz=linspace(1,150,100); 
    A=r(13).rai';
    ii=~isnan(A); Aok=A(ii);
    iii=find(Aok); Aook=Aok(iii);
    Asz=zeros(length(Aook),1); %preallocate space   
    for j=1:length(Asz)  % define sizes according to cyst abundance
         Asz(j)=sz(round(Aook(j)*length(sz)));
    end
    h4=scatter(r(13).dn(iii)',ones(size(Asz)),Asz,'m','filled');
    hold on
    set(gca,'ylim',[0 10],'Visible','off',...
        'xlim',[datenum('2016-08-01') datenum('2016-11-05')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01')],...
        'YTickLabel',{},'XTickLabel',{},'tickdir','out');  
    hold on
subplot(2,3,4);
    h1=stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
    hold on
    for i=1:length(yearlist)
        ind_nan=find(~isnan(y_mat_manual(:,i)));
        h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
    end
    hold on
    h3=plot(mcr.akashiwo.dn, mcr.akashiwo.avg,'b^','Markersize',3,'linewidth',1,'markerfacecolor','w');
    hold all
    set(gca,'ylim',[0 800],'ytick',0:200:800,...
        'xlim',[datenum('2016-08-01') datenum('2016-11-05')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01')],...
            'XTickLabel',{'Aug','Sep','Oct','Nov'},'tickdir','out');    
    ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],'fontsize',12, 'fontname', 'Arial');    
    hold on
    vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
    vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
    lh = legend([h1,h2,h3,h4], ['Automated classification (' num2str(threlist(bin)) ')'],...
        'Manual classification','Microscopy','Relative abundance index');
    set(lh,'fontsize',7);
    hold on
    
%spring period
subplot(2,3,2) 
    sz=linspace(1,150,100); 
    A=r(13).rai';
    ii=~isnan(A); Aok=A(ii);
    iii=find(Aok); Aook=Aok(iii);
    Asz=zeros(length(Aook),1); %preallocate space   
    for j=1:length(Asz)  % define sizes according to cyst abundance
         Asz(j)=sz(round(Aook(j)*length(sz)));
    end
    h4=scatter(r(13).dn(iii)',ones(size(Asz)),Asz,'m','filled');
    hold on
    set(gca,'ylim',[0 10],'Visible','off',...
        'xlim',[datenum('2016-08-01') datenum('2016-11-05')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01')],...
        'YTickLabel',{},'XTickLabel',{},'tickdir','out');  
    hold on
subplot(2,3,5);
    h1=stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
    hold on
    for i=1:length(yearlist)
        ind_nan=find(~isnan(y_mat_manual(:,i)));
        h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
    end
    hold on
    h3=plot(mcr.akashiwo.dn, mcr.akashiwo.avg,'b^','Markersize',3,'linewidth',1,'markerfacecolor','w');
    hold all
    set(gca,'ylim',[0 800],'ytick',0:200:800,...
        'xlim',[datenum('2017-04-20') datenum('2017-06-24')],...
        'xtick',[datenum('2017-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01')],...
            'XTickLabel',{'Aug','Sep','Oct','Nov'},'tickdir','out');    
    ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],'fontsize',12, 'fontname', 'Arial');    
    hold on
    vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
    vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
    lh = legend([h1,h2,h3,h4], ['Automated classification (' num2str(threlist(bin)) ')'],...
        'Manual classification','Microscopy','Relative abundance index');
    set(lh,'fontsize',7);
    hold on
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Manual_auto_' num2str(class2do_string) '_v2.tif']);
hold off

%% plot Alexandrium
figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.07 0.04], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

% rai
subplot(2,1,1) 
sz=linspace(1,150,100); 
A=r(12).rai';
ii=~isnan(A); %which values are not NaNs
Aok=A(ii);
iii=find(Aok);
Aook=Aok(iii);
Asz=zeros(length(Aook),1); %preallocate space   
for j=1:length(Asz)  % define sizes according to cyst abundance
     Asz(j)=sz(round(Aook(j)*length(sz)));
end
h4=scatter(r(13).dn(iii)',ones(size(Asz)),Asz,'m','filled');
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
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
end

hold on
h3=plot(mcr.alexandrium.dn, mcr.alexandrium.avg,'b^','Markersize',3,'linewidth',1,'markerfacecolor','w');

hold all
datetick,set(gca, 'xgrid', 'on')

set(gca,'ylim',[0 3],'ytick',0:1:3,...
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
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-11-05'),0,datenum('2017-02-22'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2017-03-28'),0,datenum('2017-04-20'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2,h3,h4], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy','Relative abundance index');
set(lh,'fontsize',9,'Position',[0.4101562530653 0.621961804895869 0.27213541053546 0.18098957836628]);

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% Dinophysis
figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.07 0.04], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

% rai
subplot(2,1,1) 
sz=linspace(1,150,100); 
A=r(11).rai';
ii=~isnan(A); %which values are not NaNs
Aok=A(ii);
iii=find(Aok);
Aook=Aok(iii);
Asz=zeros(length(Aook),1); %preallocate space   
for j=1:length(Asz)  % define sizes according to cyst abundance
     Asz(j)=sz(round(Aook(j)*length(sz)));
end
h4=scatter(r(13).dn(iii)',ones(size(Asz)),Asz,'m','filled');
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
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
end

hold on

h3=plot(mcr.dinophysis.dn, mcr.dinophysis.avg,'b^','Markersize',3,'linewidth',1,'markerfacecolor','w');

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
        'fontsize',12, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-11-05'),0,datenum('2017-02-22'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2017-03-28'),0,datenum('2017-04-20'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2,h3,h4], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy','Relative abundance index');
set(lh,'fontsize',9,'Position',[0.4101562530653 0.621961804895869 0.27213541053546 0.18098957836628]);

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% Prorocentrum
figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.07 0.04], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

% rai
subplot(2,1,1) 
sz=linspace(1,150,100); 
A=r(10).rai'; 
ii=~isnan(A); %which values are not NaNs
Aok=A(ii);
iii=find(Aok);
Aook=Aok(iii);
Asz=zeros(length(Aook),1); %preallocate space   
for j=1:length(Asz)  % define sizes according to cyst abundance
     Asz(j)=sz(round(Aook(j)*length(sz)));
end
h4=scatter(r(13).dn(iii)',ones(size(Asz)),Asz,'m','filled');
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
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
end

hold on

h3=plot(mcr.prorocentrum.dn, mcr.prorocentrum.avg,'b^','Markersize',3,'linewidth',1,'markerfacecolor','w');

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
        'fontsize',12, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-11-05'),0,datenum('2017-02-22'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2017-03-28'),0,datenum('2017-04-20'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2,h3,h4], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy','Relative abundance index');
set(lh,'fontsize',9,'Position',[0.4101562530653 0.621961804895869 0.27213541053546 0.18098957836628]);

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% Pseudo-nitzschia
figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.07 0.04], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

% rai
subplot(2,1,1) 
sz=linspace(1,150,100); 
A=r(5).rai';
ii=~isnan(A); %which values are not NaNs
Aok=A(ii);
iii=find(Aok);
Aook=Aok(iii);
Asz=zeros(length(Aook),1); %preallocate space   
for j=1:length(Asz)  % define sizes according to cyst abundance
     Asz(j)=sz(round(Aook(j)*length(sz)));
end
h4=scatter(r(13).dn(iii)',ones(size(Asz)),Asz,'m','filled');
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
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
end

hold on

h3=plot(mcr.pseudonitzschia.dn, mcr.pseudonitzschia.avg,'b^','Markersize',3,'linewidth',1,'markerfacecolor','w');

hold all
datetick,set(gca, 'xgrid', 'on')
set(gca,'ylim',[0 30],'ytick',0:10:30,...
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
        'fontsize',12, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2016-11-05'),0,datenum('2017-02-22'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
vfill([datenum('2017-03-28'),0,datenum('2017-04-20'),500],...
    [200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2,h3,h4], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy','Relative abundance index');
set(lh,'fontsize',9,'Position',[0.4101562530653 0.621961804895869 0.27213541053546 0.18098957836628]);

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Manual_automated_' num2str(class2do_string) '.tif']);
hold off