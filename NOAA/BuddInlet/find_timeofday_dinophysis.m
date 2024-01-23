%% find when Dinophysis concentrations are highest
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

load([filepath 'Data/BuddInlet_data_summary'],'fli');
fli.dt=fli.dt-hours(8); % convert from GMT to PST

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
dt0=datetime('01-May-2022'); dt1=dt0+days(1);
for i=1:500
    idx=find(fli.dt>=dt0+i & fli.dt<dt1+i);
    plot(fli.dt(idx)-days(i),fli.dino(idx)); hold on;
end
%figure;
%plot(fli.dt.Hour,fli.dino,'o')
set(gca,'ylim',[0 18])
ylabel('Dinophysis (cells/mL)')
title('2022-2023 Budd Inlet')

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

