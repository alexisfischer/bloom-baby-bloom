close all; clear all;

resultpath = 'F:\IFCB104\manual\'; %Where you want the summary file to go
load ([resultpath 'summary\biovol_size_allcells_23Dec2017']);

%
diambins=0:5:50; %decide what kind of size bins you want to look at
clear bincount
bincount=NaN(length(eqdiam),length(diambins));

%bincount is a matrix of counts/ml for each diameter bin (as specified in
%diambin) by each file....or essentially histogram values
for i=1:length(eqdiam)
    [d,bins]=hist(eqdiam(i),diambins); %This looks at equivalent spherical diameter, change this if you want to look at something else
    bincount(i,:)=d./ml_analyzed(i);
end

%creates your daybins for each diambin
for i=1:length(diambins)
    [matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_day_bins(matdate,bincount(:,i),ml_analyzed);
    daybin_perml(:,i)=classcount_bin./ml_analyzed_mat_bin; 
end


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
set(gca,'ylim',[0 12],'ytick',0:2:12,'xlim',[0 55],'xtick',0:5:55,...
    'FontSize',10,'XAxisLocation','bottom','TickDir','out'); 

ylabel('Concentration (L^{-1} \mum ^{-1})', 'FontSize', 12,'FontName', 'Arial')
xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 12,'FontName', 'Arial')
t = char(datetime(matdate(1),'ConvertFrom','datenum'));
title_date=t(1:11);
title(title_date,'FontSize', 12, 'FontName', 'Arial');

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600','~/Documents/MATLAB/SantaCruz/Figs/HistogramTest.tif')
hold off