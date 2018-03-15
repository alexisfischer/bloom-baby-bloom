class2do_string = 'Alexandrium_singlet'; %USER %'Karenia,pennate_diatom,misc_nano'; %'Guinardia_striata'; %USER
chosen_threshold = 0.7; %USER

resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
%resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\';

summary_path = 'F:\IFCB104\class\summary\'; %USER
m = load('F:\IFCB104\manual\summary\count_biovol_manual_27Feb2018'); %USER

hi=60;

load([summary_path 'summary_allTB_bythre_' class2do_string]);
ind = strfind(class2do_string, ',');
if ~isempty(ind)s
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
figure(1), clf

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
    plot(x,y, '.')
    axis square
    line(xlim, xlim)
    lin_fit{ii} = fitlm(x,y);
    Rsq(ii) = lin_fit{ii}.Rsquared.ordinary;
    Coeffs(ii,:) = lin_fit{ii}.Coefficients.Estimate;
    coefPs(ii,:) = lin_fit{ii}.Coefficients.pValue;
    RMSE(ii) = lin_fit{ii}.RMSE;
    eval(['fplot(@(x)x*' num2str(Coeffs(ii,2)) '+' num2str(Coeffs(ii,1)) ''' , xlim, ''color'', ''r'')'])
    set(gca,'ylim',[0 hi],'xlim',[0 hi],'TickDir','out');
   
end;

%class2do_string.bin=(chosen_threshold*10+1);
bin=chosen_threshold*10+1;
slope = Coeffs(bin,2);
save([resultpath 'Data\Alexandrium\Coeff_' num2str(class2do_string) ' '],'class2do_string','slope','bin','chosen_threshold');

%set(gcf,'Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto');

figure(1)
subplot(3,4,5), ylabel('Automated')
subplot(3,4,10), xlabel('Manual')
set(gca, 'fontsize',12);

a = axes;
t1 = title(['\it' num2str(class2do_string) '\rm spp.'],'fontsize',12, 'fontname', 'Arial');
a.Visible = 'off'; % set(a,'Visible','off');
t1.Visible = 'on'; % set(t1,'Visible','on');

print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Threshold_range_'  num2str(class2do_string) '.tif']);
hold off

%%
figure 
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
t1 = title(['\it' num2str(class2do_string) '\rm spp.'],'fontsize',12, 'fontname', 'Arial');
a.Visible = 'off'; % set(a,'Visible','off');
t1.Visible = 'on'; % set(t1,'Visible','on');


%%
figure

for count = ii;
    handle_1=subplot(2,2,1);
    set(handle_1,'fontsize',12,'fontname','arial')
%     [matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_hour_bins(mdateTB(it), classcountTB_above_thre(it,ii), ml_analyzedTB(it));
%     y=classcount_bin;
    plot(x,y, '.')
    hold on
    %axis square
    line(xlim, xlim,'linewidth',1.5) % line w/ .5 slope
    eval(['fplot(@(x)x*' num2str(Coeffs(ii,2)) '+' num2str(Coeffs(ii,1)) ''' , xlim, ''color'', ''r'', ''linewidth'', 1.5)'])
    %legend(' ','1:1 line','line of best fit')
    subplot(2,2,1), ylabel('Automated counts','fontsize',12','fontname','arial')
    subplot(2,2,1), xlabel('Manual counts','fontsize',12','fontname','arial')
    set(gca,'xlim',[0 hi],'ylim',[0 hi],'TickDir','out'); %
    box(handle_1,'on');
end;
set(gca, 'fontsize',11);

handle_2=subplot(2,2,2); plot(threlist, Rsq, '.-','linewidth',1.5),...
    xlabel('threshold score','fontsize',12,'fontname','arial'),...
    ylabel('r^2','fontsize',12,'fontname','arial'),...
    line([chosen_threshold chosen_threshold], [0 1], 'color', 'g','linewidth',1.5)
    set(handle_2,'fontsize',12,'fontname','arial','TickDir','out')
 
handle_3=subplot(2,2,3); plot(threlist, Coeffs(:,1), '.-','linewidth',1.5),...
    xlabel('threshold score','fontsize',12,'fontname','arial'),...
    ylabel('y-intercept','fontsize',12,'fontname','arial'),...
    line([chosen_threshold chosen_threshold],[-1 1], 'color', 'g','linewidth',1.5)
    set(handle_3,'ylim',[-.5 1],'fontsize',12,'fontname','arial','TickDir','out')

handle_4=subplot(2,2,4); plot(threlist, Coeffs(:,2), '.-','linewidth',1.5),...
    xlabel('threshold score','fontsize',12,'fontname','arial'),...
    ylabel('slope','fontsize',12,'fontname','arial'),...
    line([chosen_threshold chosen_threshold], [0 2], 'color', 'g','linewidth',1.5)
set(handle_4,'ylim',[0 2],'fontsize',12','fontname','arial','TickDir','out')

a = axes;
t1 = title(['\it' num2str(class2do_string) '\rm spp.'],'fontsize',12, 'fontname', 'Arial');
a.Visible = 'off'; % set(a,'Visible','off');
t1.Visible = 'on'; % set(t1,'Visible','on');

set(gca, 'fontsize',11);
print(gcf,'-dtiff','-r600',...
    [resultpath 'Figs\Threshold' num2str(chosen_threshold) '_'  num2str(class2do_string) '.tif']);
hold off
