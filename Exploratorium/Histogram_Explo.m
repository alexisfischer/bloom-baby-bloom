%%

year=2018;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/Exploratorium/';
load([filepath 'Data/IFCB_summary/class/summary_biovol_allcells' num2str(year)],...
    'matdate', 'ml_analyzed', 'biovol_sum', 'filelist','eqdiam',...
    'notes1', 'notes2');

diambins=0:5:40; %decide what kind of size bins you want to look at
clear bincount
bincount=NaN(length(eqdiam),length(diambins));

%bincount is a matrix of counts/ml for each diameter bin (as specified in
%diambin) by each file....or essentially histogram values
for i=1:length(eqdiam)
    [d,bins]=hist(eqdiam{i,1},diambins); %This looks at equivalent spherical diameter, change this if you want to look at something else
    bincount(i,:)=d./ml_analyzed(i);
end

%creates your daybins for each diambin
for i=1:length(diambins)
    [matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_day_bins(matdate,bincount(:,i),ml_analyzed);
    daybin_perml(:,i)=classcount_bin./ml_analyzed_mat_bin; 
end


%% summary figure by bin
figure('Units','inches','Position',[1 1 8 5],'PaperPositionMode','auto');

xax1=datenum(['' num2str(year) '-05-20']); xax2=datenum(['' num2str(year) '-07-10']);     
plot(matdate_bin,[daybin_perml],'linewidth',3);

cstr=[brewermap(8,'Spectral');[0 0 0]/255];
ax=get(gca); cat = ax.Children;
for ii = 1:length(cat)
    set(cat(ii), 'Color', cstr(ii,:))
end

datetick('x', 3, 'keeplimits')
set(gca,'xgrid','on','ylim',[0 150],'ytick',0:50:150,'xlim',[xax1 xax2],...
     'FontSize',14,'XAxisLocation','bottom','TickDir','out'); 

ylabel('Counts mL^{-1}', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
h=legend('0-5 \mum','5-10 \mum','10-15 \mum','15-20 \mum','20-25 \mum',...
    '25-30 \mum','30-35 \mum','35-40 \mum');
set(h,'FontSize',12,'Location','EastOutside');
hold on

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/Eqdiam_Histogram_Explo' num2str(year) '.tif']);
hold off

%% Plots histograms by day on one plot, the colors of the line are associated with time of year
figure
t=colormap(jet);
t=t(1:64/366:end,:); %There are possibly 366 days in a year, so there need to be 366 colors to choose from
set(gca, 'colororder', t)
hold on

for i=1:length(matdate_bin)
    day=datenum2yearday(matdate_bin(i)); %finds the yearday of that line to plot
    plot(diambins, daybin_perml(i,:), 'linewidth', 2.5,'color',t(day,:)) %plots the histogram for that day and the color associated with that day of the year
    hold on
end

xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 18, 'FontName', 'Times')
ylabel('Abundance (Cell L^{-1} \mum ^{-1})', 'FontSize', 18, 'FontName', 'Times')
xlim([0 120])
set(gca,  'FontSize', 18, 'FontName', 'Times','xtick',0:20:120,...
    'xticklabel',{'0','20','40','60','80','100','120'})
title('All Cells','fontsize',18,'fontname','times');

ticks=[datenum('2-1-2008') datenum('4-1-2008') datenum('6-1-2008') ...
    datenum('8-1-2008') datenum('10-1-2008') datenum('12-1-2008')]-datenum('1-0-2008');
h=colorbar; caxis([1 366])
set(h,'Ytick',ticks,'Yticklabel',{'Feb','Apr','Jun','Aug','Oct','Dec'},...
    'Ydir','reverse','fontname','times','fontsize',16,'linewidth',1,...
    'TickLength',[0.015  0.025]) %[1 8.57 17.43 26.14 34.86 43.71 52]{'Jan','Mar','May','Jul','Sept','Nov','Jan'}

%% summary figure from one folder
figure('Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto');

S=std(bincount,1);
bar(diambins,mean(bincount,1));
 set(gca,'ylim',[0 400],'ytick',0:50:400,'xlim',[0 55],...
     'FontSize',10,'XAxisLocation','bottom','TickDir','out'); 

ylabel('Concentration (counts mL^{-1})', 'FontSize', 12,'FontName', 'Arial')
xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 12,'FontName', 'Arial')
t = char(datetime(matdate(1),'ConvertFrom','datenum'));
title_date=t(1:11);
title(title_date,'FontSize', 12, 'FontName', 'Arial');

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/Eqdiam_Histogram_Explo' num2str(year) '.tif']);
hold off

%% new figure for each date 
%Click enter to see each day go through the figure
figure('Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto');
for i=1:length(matdate_bin)
    bar(diambins,daybin_perml(i,:));
    set(gca,'xlim',[0 55],'xtick',0:5:55,...
    'FontSize',10,'XAxisLocation','bottom','TickDir','out');     
    ylabel('Concentration (L^{-1} \mum ^{-1})', 'FontSize', 12,'FontName', 'Arial');
    xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 12,'FontName', 'Arial');
    t = char(datetime(matdate_bin(i),'ConvertFrom','datenum'));
    title_date=t(1:11);
    title(title_date,'FontSize', 12, 'FontName', 'Arial');
    pause
end
