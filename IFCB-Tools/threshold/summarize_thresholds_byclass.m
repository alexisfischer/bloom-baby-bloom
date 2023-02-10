%% This is the analysis that will help you evaluate the right threshold to use for your class files
% Alexis Fischer, February 2023
% When choosing a threshold, you want to look at the plots and determine which threshold 
% gives you a slope closest to 1, an R^2 closest to 1, and a y-intercept closest to 0.

% %% Example inputs
clf; clear; close all;
class2do_string = 'Akashiwo'; %USER
summarydir = '~/Documents/MATLAB/bloom-baby-bloom/';
biovolmanual = [summarydir 'IFCB-Data/Shimada/manual/count_class_biovol_manual'];
thsummary=[summarydir 'IFCB-Data/Shimada/threshold/summary_allTB_bythre_' class2do_string];
chosen_threshold=0.7;

[~,label]=get_class_ind(class2do_string, 'all',[summarydir 'IFCB-Tools/convert_index_class/class_indices.mat']);

%summarydir = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
%biovolmanual = [summarydir 'manual\count_class_biovol_manual'];
%thsummary= 'threshold\summary_allTB_bythre_' class2do_string];

m = load(biovolmanual);
load(thsummary,'classcountTB_above_thre','filelistTB','threlist');

ind = strfind(class2do_string, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_string)];
    for c = 1:length(ind)-1
        imclass(c) = strmatch(class2do_string(ind(c)+1:ind(c+1)-1), m.class2use);
    end
else
    imclass = strmatch(class2do_string, m.class2use);
end

if isfield(m, 'ml_analyzed_mat')
    goodm = find(~isnan(m.ml_analyzed_mat(:,imclass(1))));
    m.filelist = regexprep(m.filelist,'.mat', '')';
else
    goodm = find(~isnan(m.classcount(:,imclass(1))));
    m.filelist = regexprep({m.filelist.name},'.mat', '')';
end
[~,im,it] = intersect(m.filelist(goodm), filelistTB);
im = goodm(im);

%%%% plot manual vs automated for each threshold
figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
x = sum(m.classcount(im,imclass),2); %all manually sorted time points
%[ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat_sum( m.matdate(im), m.classcount(im,imclass) );
%x = y_mat(:); %manually sorted time points-daily
%[matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_hour_bins(m.matdate(im),m.classcount(im,imclass), m.ml_analyzed_mat(im,imclass));
%x=classcount_bin; % manually sorted time points-hourly

for ii = 1:length(threlist)
    
    %all classifier time points
    y = classcountTB_above_thre(it,ii); 
    
    % classifier time points- daily
    %[ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat_sum( mdateTB(it), classcountTB_above_thre(it,ii) );
    %y = y_mat(:);
    
    %using concentration rather than counts
    % x = m.classcount(im,imclass)./m.ml_analyzed_mat(im,imclass); y = classcountTB_above_thre(it,ii)./ml_analyzedTB(it);

    % classifier time points- hourly
    % [matdate, classcount_bin, ml_analyzed_mat] = make_hour_bins(mdateTB(it), classcountTB_above_thre(it,ii), ml_analyzedTB(it));
    % y=classcount_bin;
    
    figure(1), subplot(3,4,ii), hold on
    plot(x,y, 'r.')
    axis square
    line(xlim, xlim,'color','k')
    lin_fit{ii} = fitlm(x,y);
    Rsq(ii) = lin_fit{ii}.Rsquared.ordinary;
    Coeffs(ii,:) = lin_fit{ii}.Coefficients.Estimate;
    coefPs(ii,:) = lin_fit{ii}.Coefficients.pValue;
    RMSE(ii) = lin_fit{ii}.RMSE;
    eval(['fplot(@(x)x*' num2str(Coeffs(ii,2)) '+' num2str(Coeffs(ii,1)) ''' , xlim, ''color'', ''r'')'])
    set(gca,'ylim',[0 max(x)],'xlim',[0 max(x)],'TickDir','out','fontsize',10,'box','on');
    addFigureLetter(gca,num2str(threlist(ii)),2); hold on
   
end

subplot(3,4,5), ylabel('Automated counts','fontsize',12)
subplot(3,4,10), xlabel('Manual counts','fontsize',12)

a = axes;
t1 = title(label,'fontsize',12);
a.Visible = 'off'; % set(a,'Visible','off');
t1.Visible = 'on'; % set(t1,'Visible','on');

bin=chosen_threshold*10+1;
slope = Coeffs(bin,2);
save([summarydir 'IFCB-Data/Shimada/threshold/Coeff_' num2str(class2do_string) ''],'class2do_string','slope','bin','chosen_threshold');

exportgraphics(gcf,[summarydir 'IFCB-Data/Shimada/threshold/Figs/Threshold_range_'  num2str(class2do_string) '.png'],'Resolution',100)    
hold off

%%%% test plot
figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
subplot(2,2,1), plot(threlist, Rsq, '.-'), xlabel('threshold score'), ylabel('r^2'), line([chosen_threshold chosen_threshold], ylim, 'color', 'r')
subplot(2,2,2), plot(threlist, Coeffs(:,1), '.-'), xlabel('threshold score'), ylabel('y-intercept'), line([chosen_threshold chosen_threshold], ylim, 'color', 'r')
subplot(2,2,3), plot(threlist, Coeffs(:,2), '.-'), xlabel('threshold score'), ylabel('slope'), line([chosen_threshold chosen_threshold], ylim, 'color', 'r')
subplot(2,2,4), plot(threlist, RMSE, '.-'), xlabel('threshold score'), ylabel('RMSE'), line([chosen_threshold chosen_threshold], ylim, 'color', 'r')

%to calculate what percentage of the classifier counts are within a poisson
%confidence interval of the manual counts

ii = find(threlist == chosen_threshold);
% [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat_sum( m.matdate(im), m.classcount(im,imclass) );
% x = y_mat(:);
%[matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_hour_bins(m.matdate(im),m.classcount(im,imclass), m.ml_analyzed_mat(im,imclass));
%x=classcount_bin;
% [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat_sum( mdateTB(it), classcountTB_above_thre(it,ii) );
% y = y_mat(:);
%[matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_hour_bins(mdateTB(it), classcountTB_above_thre(it,ii), ml_analyzedTB(it));
%y=classcount_bin;
y = classcountTB_above_thre(it,ii);
%x = m.classcount(im,imclass);
cix=poisson_count_ci(x,0.95);
good = length(find(y>=cix(:,1) & y <= cix(:,2)));
bad = length(find(y<cix(:,1) | y > cix(:,2)));
all = length(find(~isnan(x)));
%check good+bad = all
fraction_inside_ci=good/all; %fraction inside conf interval

a = axes;
t1 = title(label,'fontsize',12, 'fontname', 'Arial');
a.Visible = 'off'; % set(a,'Visible','off');
t1.Visible = 'on'; % set(t1,'Visible','on');

%%%% final plot
fh=figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
for count = ii
    handle_1=subplot(2,2,1);
    set(handle_1,'fontsize',12)
%     [matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_hour_bins(mdateTB(it), classcountTB_above_thre(it,ii), ml_analyzedTB(it));
%     y=classcount_bin;
    plot(x,y, 'r.')
    hold on
    line(xlim, xlim,'linewidth',1.5,'color','k') % line w/ .5 slope
    eval(['fplot(@(x)x*' num2str(Coeffs(ii,2)) '+' num2str(Coeffs(ii,1)) ''' , xlim, ''color'', ''r'', ''linewidth'', 1.5)'])
    %legend(' ','1:1 line','line of best fit')
    subplot(2,2,1), ylabel('Automated counts','fontsize',12)
    subplot(2,2,1), xlabel('Manual counts','fontsize',12)
    set(gca,'xlim',[0 max(x)],'ylim',[0 max(x)],'fontsize',10,'TickDir','out'); %
    box(handle_1,'on');
end
set(gca, 'fontsize',11);

handle_2=subplot(2,2,2); plot(threlist, Rsq, '.-','linewidth',1.5);
    line([chosen_threshold chosen_threshold], [0 1], 'color', 'g','linewidth',1.5)
    set(handle_2,'fontsize',10,'xlim',[0 1],'TickDir','out')
    xlabel('threshold score','fontsize',12);
    ylabel('r^2','fontsize',12);
handle_3=subplot(2,2,3); plot(threlist, Coeffs(:,1), '.-','linewidth',1.5);
    line([chosen_threshold chosen_threshold],[-2 4], 'color', 'g','linewidth',1.5)
    set(handle_3,'ylim',[0 1],'xlim',[0 1],'fontsize',10,'TickDir','out')
    xlabel('threshold score','fontsize',12);
    ylabel('y-intercept','fontsize',12);
handle_4=subplot(2,2,4); plot(threlist, Coeffs(:,2), '.-','linewidth',1.5);
    line([chosen_threshold chosen_threshold], [0 2], 'color', 'g','linewidth',1.5)
set(handle_4,'ylim',[0 2],'xlim',[0 1],'fontsize',10,'TickDir','out')
    xlabel('threshold score','fontsize',12);
    ylabel('slope','fontsize',12);

a = axes;
t1 = title(label,'fontsize',12, 'fontname', 'Arial');
a.Visible = 'off'; % set(a,'Visible','off');
t1.Visible = 'on'; % set(t1,'Visible','on');

axesHandles = findobj(get(fh,'Children'), 'flat','Type','axes');
axis(axesHandles,'square')

exportgraphics(gcf,[summarydir 'IFCB-Data/Shimada/threshold/Figs/' class2do_string 'Threshold' num2str(chosen_threshold) '.png'],'Resolution',100)    
hold off
