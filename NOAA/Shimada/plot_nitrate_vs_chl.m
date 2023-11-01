%% plot nitrate vs chl
clear; %close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path


%%%% load in discrete data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
HA((HA.lat<40),:)=[]; %remove CA stations
%data=HA.chlA_ugL; cax=[0 20]; %label={'Chl a (ug/L)'}; name='CHL'; col=brewermap(256,'BuGn'); col(1:50,:)=[]; lim=.1;
%data=HA.Nitrate_uM; cax=[0 48]; ticks=[0,24,48]; label={'NO_3^- (\muM)'}; name='NIT'; col=brewermap(256,'BuGn'); col(1:50,:)=[]; lim=0.6;

i19=HA.dt<datetime('01-Jan-2020');

figure;
scatter(HA.Nitrate_uM(i19),HA.chlA_ugL(i19)); hold on;
scatter(HA.Nitrate_uM(~i19),HA.chlA_ugL(~i19)); hold on;
xlabel('nitrate')
ylabel('chl-a')
legend('2019','2021')

