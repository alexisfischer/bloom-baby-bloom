
resultpath = 'F:\IFCB113\class\'; %Where you want the summary file to go
load ([resultpath 'summary\biovol_size_allcells_27Dec2017']);

[filelist] = affix_metadata(filelist);

%
diambins=0:5:40; %decide what kind of size bins you want to look at
clear bincount
bincount=NaN(length(eqdiam),length(diambins));

%bincount is a matrix of counts/ml for each diameter bin (as specified in
%diambin) by each file....or essentially histogram values
for i=1:length(eqdiam)
    [d,bins]=hist(eqdiam{i},diambins); %This looks at equivalent spherical diameter, change this if you want to look at something else
    bincount(i,:)=d./ml_analyzed(i);
end

% make diambins for seasonality
for i=1:length(diambins)
    [matdate_bin, classcount_bin, ml_analyzed_mat_bin] =...
        make_day_bins(matdate,bincount(:,i),ml_analyzed);
    daybin_perml(:,i)=classcount_bin./ml_analyzed_mat_bin; 
end

% make diambins for salinity
for i=1:length(diambins)
    [sal_bin, classcount_bin, ml_analyzed_sal_bin] =...
        make_sal_bins(filelist,bincount(:,i),ml_analyzed);
    salbin_perml(:,i)=classcount_bin./ml_analyzed_sal_bin; 
end

% make diambins for suspended particulate matter 
for i=1:length(diambins)
    [spm_bin, classcount_bin, ml_analyzed_spm_bin] =...
        make_spm_bins(filelist,bincount(:,i),ml_analyzed);
    spmbin_perml(:,i)=classcount_bin./ml_analyzed_spm_bin; 
end

% make diambins for light extinction coefficient 
for i=1:length(diambins)
    [ext_bin, classcount_bin, ml_analyzed_ext_bin] =...
        make_ext_bins(filelist,bincount(:,i),ml_analyzed);
    extbin_perml(:,i)=classcount_bin./ml_analyzed_ext_bin; 
end

%% diameter vs cell/concentration for date
figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto');

t=colormap(parula);
t=t(1:64/366:end,:); %There are possibly 366 days in a year, so there need to be 366 colors to choose from
set(gca, 'colororder', t)
hold on

for i=1:length(matdate_bin)
    day=datenum2yearday(matdate_bin(i)); %finds the yearday of that line to plot
    plot(diambins, daybin_perml(i,:), 'linewidth', 2,'color',t(day,:)) %plots the histogram for that day and the color associated with that day of the year
    hold on
end

xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 10, 'FontName', 'arial')
ylabel('Abundance (cell L^{-1} \mum ^{-1})', 'FontSize', 10, 'FontName', 'arial')
xlim([0 40])
ylim([0 220])
set(gca,  'FontSize', 10, 'FontName', 'Arial','xtick',0:10:40,'ytick',0:50:200,...
    'TickDir','out')
title('All Cells - Seasonality','fontsize',12,'fontname','arial');

ticks=[datenum('1-1-2017') datenum('2-1-2017') datenum('3-1-2017')...
    datenum('4-1-2017') datenum('5-1-2017') datenum('6-1-2017')...
    datenum('7-1-2017') datenum('8-1-2017') datenum('9-1-2017') ...   
    datenum('10-1-2017') datenum('11-1-2017') datenum('12-1-2017')]-datenum('1-0-2017');

    h=colorbar; caxis([1 366])
set(h,'Ytick',ticks,'Yticklabel',{'Jan' 'Feb','Mar','Apr','May','Jun',...
    'Jul','Aug','Sep','Oct','Nov','Dec'},...
    'Ydir','reverse','fontname','arial','fontsize',10,'linewidth',1,...
    'TickLength',[0.015  0.025]);
    h.TickDirection = 'out';
    box on
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Figs\SFbay_biovolume_date.tif');
hold off

%% diameter vs cell/concentration for salinity
figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto');

t=colormap(parula);
t=t(1:64/35:end,:); %need to be 35 colors to choose from
set(gca, 'colororder', t)
hold on

%current dataset includes nans associated with dec 2017 data, so we are
%excluding those for the time being
salbin_perml=salbin_perml(1:12,:);
sal_bin=sal_bin(1:12,:);
for i=1:length(sal_bin)
    sal=sal_bin(i); %finds the salinity to plot
    plot(diambins, salbin_perml(i,:), 'linewidth',2,'color',t(sal,:)) %plots the histogram for that day and the color associated with that day of the year
    hold on
end

xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 10, 'FontName', 'arial');
ylabel('Abundance (cell L^{-1} \mum ^{-1})', 'FontSize', 10, 'FontName', 'arial');
xlim([0 40]); ylim([0 220]);
set(gca,'FontSize', 10, 'FontName', 'Arial','xtick',0:10:40,'ytick',0:50:200,...
     'TickDir','out')
title('All Cells - Salinity','fontsize',12,'fontname','arial');

h=colorbar; caxis([1 35])
set(h,'fontname','arial','fontsize',10,'linewidth',1,'TickLength',[0.015  0.025]);
    h.TickDirection = 'out';
    h.Label.String = 'Salinity (psu)';
    h.Label.FontSize = 11;
    h.Label.FontName = 'arial';
    box on
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Figs\SFbay_biovolume_salinity.tif');
hold off

%% diameter vs cell/concentration for suspended particulate matter
figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto');

t=colormap(parula);
t=t(1:64/800:end,:); 
set(gca, 'colororder', t)
hold on

%current dataset includes nans associated with dec 2017 data, so we are
%excluding those for the time being
spmbin_perml=spmbin_perml(1:28,:);
spm_bin=spm_bin(1:28,:);
for i=1:length(spm_bin)
    spm=spm_bin(i); 
    plot(diambins,spmbin_perml(i,:),'linewidth',2,'color',t(spm,:)) 
    hold on
end

xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 10, 'FontName', 'arial');
ylabel('Abundance (cell L^{-1} \mum ^{-1})', 'FontSize', 10, 'FontName', 'arial');
xlim([0 40]); ylim([0 800]);
set(gca,'FontSize', 10, 'FontName', 'Arial','xtick',0:10:40,'ytick',0:100:800,...
     'TickDir','out')
title('All Cells - SPM','fontsize',12,'fontname','arial');

h=colorbar; caxis([1 35])
set(h,'fontname','arial','fontsize',10,'linewidth',1,'TickLength',[0.015  0.025]);
    h.TickDirection = 'out';
    h.Label.String = 'Suspended particulate matter (mg L^-1)';
    h.Label.FontSize = 11;
    h.Label.FontName = 'arial';
    box ons
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Figs\SFbay_biovolume_spm.tif');
hold off

%% diameter vs cell/concentration for light extinction
figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto');

t=colormap(parula);
t=t(1:64/6:end,:); 
set(gca, 'colororder', t)
hold on

%current dataset includes nans associated with dec 2017 data, so we are
%excluding those for the time being
extbin_perml=extbin_perml(1:6,:);
ext_bin=ext_bin(1:6,:);
for i=1:length(ext_bin)
    ext=ext_bin(i); 
    plot(diambins,extbin_perml(i,:),'linewidth',2,'color',t(ext,:)) 
    hold on
end

xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 10, 'FontName', 'arial');
ylabel('Abundance (cell L^{-1} \mum ^{-1})', 'FontSize', 10, 'FontName', 'arial');
xlim([0 40]); ylim([0 175]);
set(gca,'FontSize', 10, 'FontName', 'Arial','xtick',0:10:40,'ytick',0:25:175,...
     'TickDir','out')
title('All Cells - Light','fontsize',12,'fontname','arial');

h=colorbar; caxis([1 6])
set(h,'fontname','arial','fontsize',10,'linewidth',1,'TickLength',[0.015  0.025]);
    h.TickDirection = 'out';
    h.Label.String = 'Measured light extinction coefficient (per meter)';
    h.Label.FontSize = 11;
    h.Label.FontName = 'arial';
    box on
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Figs\SFbay_biovolume_lightextinct.tif');
hold off

%% new histogram for each date 
%Click enter to see each day go through the figure
figure('Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto');
for i=1:length(matdate_bin)
    bar(diambins,daybin_perml(i,:));
    set(gca,'ylim',[0 210],'ytick',0:50:200,'xlim',[0 55],'xtick',0:5:55,...
    'FontSize',10,'XAxisLocation','bottom','TickDir','out');     
    ylabel('Concentration (L^{-1} \mum ^{-1})', 'FontSize', 12,'FontName', 'Arial');
    xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 12,'FontName', 'Arial');
    t = char(datetime(matdate_bin(i),'ConvertFrom','datenum'));
    title_date=t(1:11);
    title(title_date,'FontSize', 12, 'FontName', 'Arial');
    pause
end

%% new histogram for each station 
%Click enter to see each day go through the figure
figure('Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto');
for i=1:length(st_bin)
    bar(diambins,stbin_perml(i,:));
    set(gca,'ylim',[0 210],'ytick',0:50:200,'xlim',[0 55],'xtick',0:5:55,...
    'FontSize',10,'XAxisLocation','bottom','TickDir','out');     
    ylabel('Concentration (L^{-1} \mum ^{-1})', 'FontSize', 12,'FontName', 'Arial');
    xlabel('Equivalent spherical diameter (\mum)', 'FontSize', 12,'FontName', 'Arial');
    t = (st_bin(i));
    %title_date=t(1:11);
    title(['station ' num2str(t) ''],'FontSize', 12, 'FontName', 'Arial');
    pause
end