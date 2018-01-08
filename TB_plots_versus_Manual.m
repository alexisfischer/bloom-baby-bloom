class2do_string = 'Akashiwo'; %USER 
bin=3;
slope = Coeffs(bin,2);

load 'F:\IFCB104\manual\summary\count_biovol_manual_08Jan2018' %load manual count result file that you made from running 'biovolume_summary_manual_user_training.m'
summary_path = 'F:\IFCB104\class\summary\'; %load automated count file with all thresholds you made from running 'countcells_allTB_class_by_thre_user.m'
load([summary_path 'summary_allTB_bythre_' class2do_string]);

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
save('C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Data\need_more_manual_Akashiwo.mat','mdate_val');

%%
figure('Units','inches','Position',[1 1 6 3],'PaperPositionMode','auto');

h1=plot(mdateTB, y_mat/slope,'k-','Linewidth',1.2); %This adjusts the automated counts by the chosen slope. 
%plot(mdateTB(:), classcountTB_above_thre(:,6)/.65*1000,'k-') %This adjusts the automated counts by the chosen slope. 
% 
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(y_mat_match(:,i)));
%     h1=stem(mdate_mat_match(ind_nan,i), y_mat_match(ind_nan,i)/.8,'kd-','Markersize',4); %This adjusts the automated counts by the chosen slope.     
%     hold on
% end

hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',10,'linewidth',1.2);
end

hold all
datetick,set(gca, 'xgrid', 'on')
ylabel(['\it' num2str(class2do_string) '\rm concentration (mL^{-1})\bf'],...
    'fontsize',12, 'fontname', 'Arial');
title('2016', 'fontsize',14, 'fontname', 'Arial');

set(gca, 'fontsize', 12, 'fontname', 'Arial')
lh = legend([h1,h2], 'Automated classification','Manual classification','Location','Northwest');
hold on

set(lh,'fontsize',12)
%set(gcf,'PaperOrientation','landscape');
set(gcf,'units','inches')
set(gcf,'position',[5 6 8 3],'paperposition', [-0.5 3 12 4]);
set(gcf,'color','w')
set(gca,'xlim',[datenum('2016-01-01') datenum('2017-01-01')],...
        'xtick',[datenum('2016-01-01'),...
        datenum('2016-02-01'),datenum('2016-03-01'),...
        datenum('2016-04-01'),datenum('2016-05-01'),...
        datenum('2016-06-01'),datenum('2016-07-01'),...
        datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01'),...
        datenum('2016-12-01')],...
        'XTickLabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug',...
        'Sep','Oct','Nov','Dec'},'tickdir','out');
%datetick('x', 'keeplimits', 'keepticks')
%ylim([-1 2])

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    ['C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Figs\SCW_manual_automated_' num2str(class2do_string) '.tif']);
hold off
