%% plot linear relationship of D fortii and D acuminata vs toxin
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

load([filepath 'Data/BuddInlet_data_summary'],'T');

T(isnan(T.DinoML_micro),:)=[]; %remove nans from microscopy dataset
col=flipud(brewermap(4,'PuBuGn'));
col(4,:)=[];

%% Example MATLAB script

% Log-transform variables to normalize
logCells = log10(T.DAcumML+0.5*min(T.DAcumML(T.DAcumML>0)));
logDST   = log10(T.DST_pgML+0.5*min(T.DST_pgML(T.DST_pgML>0)));
time=T.dt;

%% Step 1: Visualize and check correlation
figure;
subplot(2,1,1);
plot(time, logCells, '-o');
ylabel('log10(D. acuminata cells/L)');

subplot(2,1,2);
plot(time, logDST, '-o');
ylabel('log10(Particulate DST)');
xlabel('Time');

% Initial correlation
[r, p] = corr(logCells, logDST, 'Rows','complete');
fprintf('Simple correlation: r = %.2f (p = %.3f)\n', r, p);


%% Step 2: Fit a regression with AR(1) residuals using regARIMA
% Model: logDST_t = β0 + β1*logCells_t + AR(1) errors

Mdl = regARIMA('Intercept',NaN,'ARLags',1,'Beta',NaN,'Variance',NaN);
% Fit model
EstMdl = estimate(Mdl, logDST, 'X', logCells);

% Display results
disp(EstMdl)

%% Step 3: Check model diagnostics
res = infer(EstMdl, logDST, 'X', logCells);

figure;
subplot(2,1,1);
plot(res);
ylabel('Residuals');

subplot(2,1,2);
autocorr(res);
title('ACF of residuals');

%% Step 4: Interpret results
% β1 = effect of log10(cell abundance) on log10(particulate DST)
beta = EstMdl.Beta;
fprintf('Estimated slope (β1): %.3f\n', beta);

% To test significance:
[~,~,logL,info] = estimate(Mdl, logDST, 'X', logCells, 'Display','off');
disp(info)



%%
figure('Units','inches','Position',[1 1 5 2.4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.15 0.15], [0.13 0.03], [0.11 0.03]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

mdlDST=fitlm(T.DAcumML,T.DST_pgML);
mdlPTX=fitlm(T.DFortML,T.PTX2_pgML);
yr=2021:2023;

subplot(1,2,1)
for i=1:length(yr)
    idx=find(T.dt.Year==yr(i));
    scatter(T.DAcumML(idx),T.DST_pgML(idx),20,col(i,:),'filled'); hold on
end
plot(T.DAcumML,mdlDST.Fitted,'r--'); hold on;
    set(gca,'xlim',[0 12],'xtick',0:6:12,'ylim',[0 100],'ytick',0:50:100,...
        'fontsize',9,'fontname', 'arial','tickdir','out','ycolor','k');
    xlabel('{\itD. acuminata} (cells/mL)','fontsize',10); hold on;       
    ylabel('DST (pg/mL)','fontsize',10); 
    axis square; box on;
    lh=legend('2021','2022','2023','Location','NorthWest','fontsize',9);
    legend boxoff; hp=get(lh,'pos');
    lh.Position=[hp(1)-.04 hp(2)+.03 hp(3) hp(4)]; hold on   

subplot(1,2,2)
for i=1:length(yr)
    idx=find(T.dt.Year==yr(i));
    scatter(T.DFortML(idx),T.PTX2_pgML(idx),20,col(i,:),'filled'); hold on
end
plot(T.DFortML,mdlPTX.Fitted,'r--'); hold on;
    set(gca,'xlim',[0 8],'xtick',0:4:8,'ylim',[0 400],'ytick',0:200:400,...
        'fontsize', 9,'fontname', 'arial','tickdir','out','ycolor','k');
    xlabel('{\itD. fortii} (cells/mL)','fontsize',10); hold on;       
    ylabel('PTX2 (pg/mL)','fontsize',10); 
    axis square; box on;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/LM_SpeciesvsTox.png'],'Resolution',300)    
hold off    
