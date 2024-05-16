%% match up t45 temperature (Sci sw system) with pco2 intake temperature to assess offset

clear;
filepath= '~/Documents/MATLAB/bloom-baby-bloom/'; 
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'Shimada/Data/environ_Shimada2019'],'DT','LON','LAT','TEMP','TEMPi','PCO2');

% matchup
idx=isnan(TEMPi); TEMP(idx)=NaN;
idx=isnan(TEMP); TEMPi(idx)=NaN;

dif=(TEMP-TEMPi);

%%
figure;
plot(DT,dif,'o');
title('TSG45 - pCO2IntakeTemp');
ylabel('temperature offset')
%plot(DT,TEMP,'-',DT,TEMPi,'-');
%legend('TSG 45','pCO2IntakeTemp')
%%
figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto'); 

mdl = fitlm(TEMP,(TEMPi-TEMP));
%plot(TEMPi,dif,'o'); hold on;
plot(mdl);
%set(gca,'xlim',[9 20],'ylim',[-3 3])
ylabel('TSG45 - pCO2IntakeTemp');
xlabel('TSG45')

m=mdl.Coefficients(2,1)
%%
figure('Units','inches','Position',[1 1 7 3],'PaperPositionMode','auto'); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.15 0.07], [0.07 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(1,2,1)
mdl = fitlm(TEMPi,dif);
%plot(TEMPi,dif,'o'); hold on;
plot(mdl);
set(gca,'xlim',[9.5 20],'ylim',[-3 3])
ylabel('temperature offset')
xlabel('pCO2IntakeTemp')

subplot(1,2,2)
mdl = fitlm(TEMP,dif);
%plot(TEMPi,dif,'o'); hold on;
plot(mdl);
%plot(TEMP,dif,'o');
set(gca,'xlim',[9.5 20],'ylim',[-3 3],'yticklabel',{})
xlabel('TSG45')
