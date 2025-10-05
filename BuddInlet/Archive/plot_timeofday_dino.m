%% find when Dinophysis concentrations are highest
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

load([filepath 'Data/BuddInlet_data_summary'],'fli');
fli.dt=fli.dt-hours(8); % convert from GMT to PST

%% plot Histograms of hour with highest cell count per day
yr=2021;
fl=fli(fli.dt.Year==yr,:); %only take 2022 data
%fl=retime(fli,'regular','mean','TimeStep',hours(1)); %take hourly average

imax=@(x) find(x==max(x),1);  % anonymous function for index to maximum in group
fl.DOY=day(fl.dt,'dayofyear');
ttMAX=varfun(imax,fl,'InputVariables','dino','GroupingVariables','DOY');
DailyMaxDino=[];  % empty accumulator for results
dtMax=[];

for i=1:height(ttMAX)    
    idx=find(fl.DOY==ttMAX.DOY(i)); %get daily index
    [m,idm]=max(fl.dino(idx)); %find max value/day from daily subset
    dtm=fl.dt(idx(idm)); %find corresponding date back in full dataset
    dtMax=[dtMax;dtm];
    DailyMaxDino=[DailyMaxDino;m]; % accumulate rows in the output ttable
end

[~,~,~,h,~,~]=datevec(dtMax);

figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.14 0.07], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1)
histogram(h);
set(gca,'xlim',[-.5 24],'xtick',0:4:24,'ylim',[0 13],'xticklabel',{});
ylabel('incidences')
title([num2str(yr) ' - Hour with highest [Dinophysis]'])

subplot(2,1,2)
plot(h,DailyMaxDino,'o')
set(gca,'xlim',[-.5 24],'xtick',0:4:24,'ylim',[0 20]);
xlabel('hour of day')
ylabel('cells/mL')

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/maxDinophysis_timeofday_' num2str(yr) '.png'],'Resolution',100)    
hold off

%%
fig=figure('Units','inches','Position',[1 1 5 3],'PaperPositionMode','auto');
boxplot(fli.dino,fli.dt.Hour,'PlotStyle','compact')
ylabel('Dinophysis (cells/mL)')
xlabel('hour of day')
title('2022-2023 Budd Inlet')

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Dinophysis_timeofday.png'],'Resolution',100)    
hold off

%%
figure('Units','inches','Position',[1 1 5 3],'PaperPositionMode','auto');
dt0=datetime('01-Jul-2023'); dt1=dt0+days(1);
for i=1:60
    idx=find(fli.dt>=dt0+i & fli.dt<dt1+i);
    plot(fli.dt(idx)-days(i),fli.dino(idx)); hold on;
end
%figure;
%plot(fli.dt.Hour,fli.dino,'o')
set(gca,'ylim',[0 15])
ylabel('Dinophysis (cells/mL)')
title('01 July 2023 Budd Inlet')

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Dinophysis_timeofday.png'],'Resolution',100)    
hold off

%%
figure('Units','inches','Position',[1 1 5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.09 0.09], [0.11 0.1]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1)
dt0=datetime('01-May-2022'); dt1=dt0+days(1);
for i=1:180
    idx=find(fli.dt>=dt0+i & fli.dt<dt1+i);
    plot(fli.dt(idx)-days(i),fli.dino(idx)); hold on;
end
set(gca,'xticklabel',{},'ylim',[0 20])
title('Dinophysis (cells/mL)')
ylabel('2022')

subplot(2,1,2)
dt0=datetime('01-May-2023'); dt1=dt0+days(1);
for i=1:180
    idx=find(fli.dt>=dt0+i & fli.dt<dt1+i);
    plot(fli.dt(idx)-days(i),fli.dino(idx)); hold on;
end
set(gca,'ylim',[0 20])
ylabel('2023')

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Dinophysis_timeofday.png'],'Resolution',100)    
hold off

