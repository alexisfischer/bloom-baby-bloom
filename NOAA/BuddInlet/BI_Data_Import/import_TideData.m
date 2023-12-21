% Import and plot tide data with IFCB biovolume data
%
%% Import tide data from text file
%https://tidesandcurrents.noaa.gov/noaatidepredictions.html?id=9446807&legacy=1
clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

% import all BI tide files in folder
indir='/Users/afischer/MATLAB/NOAA/BuddInlet/Data/Tides_monthly/';
filedir = dir([indir '9446807*']);

for i=1:length(filedir)
    disp(filedir(i).name);    
    filename = [indir filedir(i).name]; 
    
    opts = delimitedTextImportOptions("NumVariables", 5);
    opts.DataLines = [15, Inf];
    opts.Delimiter = "\t";
    opts.VariableNames = ["Date", "Var2", "Day", "Time", "Var5"];
    opts.SelectedVariableNames = ["Date", "Day", "Time"];
    opts.VariableTypes = ["datetime", "string", "datetime", "double", "string"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, ["Var2", "Var5"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var2", "Var5"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "Date", "InputFormat", "yyyy/MM/dd");
    opts = setvaropts(opts, "Day", "InputFormat", "HH:mm");   
    T = readtable(filename, opts);
    T.Date.Format = 'uuuu-MMM-dd HH:mm:ss';
    T.Day.Format = 'uuuu-MMM-dd HH:mm:ss';
    s(i).filename=filedir(i).name;
    s(i).dt=T.Date+timeofday(T.Day);
    s(i).tidem=T.Time;
    
    clearvars opts T
end

% merge files
dt=vertcat(s.dt);
tidem=vertcat(s.tidem);

clearvars filedir filename i indir s

%% load in classified IFCB data
filepath = '/Users/afischer/MATLAB/';
load([filepath 'bloom-baby-bloom/IFCB-Data/BuddInlet/class/summary_biovol_allTB2021'],...
    'class2useTB','classbiovolTB','ml_analyzedTB','mdateTB');

%convert from per cell to per mL
volB=zeros(size(classbiovolTB));
for i=1:length(ml_analyzedTB)
    volB(i,:)=classbiovolTB(i,:)./ml_analyzedTB(i);    
end
total = sum(volB,2);

%
% % Convert Biovolume (cubic microns/cell) to ug carbon/ml
% ind_diatom = get_diatom_ind_PNW(class2useTB);
% [pgCcell] = biovol2carbon(classbiovolTB,ind_diatom); 
% ugCml=NaN*pgCcell;
% for i=1:length(pgCcell)
%     ugCml(i,:)=.001*(pgCcell(i,:)./ml_analyzedTB(i)); %convert from pg/cell to pg/mL to ug/L 
% end  
% 
% [ind_phyto,~] = get_phyto_ind_PNW(class2useTB); 
% phytoTotal = sum(ugCml(:,ind_phyto),2);

[mdateTB,total,subs] = ts_aggregation(mdateTB,total,1,'hour',@mean);
dtTB=datetime(mdateTB,'ConvertFrom','datenum');
dtTB = dateshift(dtTB,'start','hour'); %round to nearest hour

clearvars class2useTB classbiovolTB ml_analyzedTB mdateTB i ind_diatom ugCml pgCcell ind_phyto subs

%% plot subplot style
figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.08 0.08], [0.1 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1)
plot(dt,tidem);
set(gca,'xlim',[datetime(2021,08,05) datetime(2021,10,06)],...
    'xaxislocation','top','tickdir','out'); hold on
ylabel('Tidal position (m)');
datetick('x', 'mm/dd', 'keeplimits');    

subplot(2,1,2)
plot(dtTB,(total));
set(gca,'xlim',[datetime(2021,08,05) datetime(2021,10,06)],...
    'xaxislocation','bottom','tickdir','out');
ylabel('cells & detritus (um^3/mL)')
datetick('x', 'mm/dd', 'keeplimits');    

set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'NOAA/BuddInlet/Figs/BuddInlet_tides_biomass.tif']);
hold off

%%
figure('Units','inches','Position',[1 1 3 3],'PaperPositionMode','auto');

[~,ia,ib]=intersect(dt,dtTB);
x=tidem(ia);
y=total(ib);
Lfit = fitlm(x,y,'RobustOpts','on');
b = round(Lfit.Coefficients.Estimate(1),2,'significant');
m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
Rsq = round(Lfit.Rsquared.Ordinary,2,'significant')
xfit = linspace(min(x),max(x),100); 
yfit = m*xfit+b; 

scatter(x,y,4,'linewidth',2,'marker','o','markerfacecolor','k'); hold on 
L=plot(xfit,yfit,'-','Color','r','linewidth',1);

set(gca,'xlim',[-3.2 2]);
xlabel('Tidal position (m)');
ylabel('cells & detritus (um^3/mL)')
axis square; box on;

set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'NOAA/BuddInlet/Figs/BuddInlet_tides_biomass_scatter.tif']);
hold off
