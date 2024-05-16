%% plot Columbia River climatology during 2019 and 2021
% Fig. S2 in Fischer et al. 2024, L&O
% A.D. Fischer, May 2024
%
clear;

%%%%USER
filepath = '~/Documents/MATLAB/bloom-baby-bloom/Shimada/';

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/ColumbiaRiverDischarge'],'CR');

% format data
%%%% Turbidity climatology (2015-2022)
    [~,y_mat,~,~] = timeseries2ydmat(datenum(CR.dt),CR.turbidity_mean);
    m = mean(y_mat,2,'omitmissing'); m(60)=[];
    sd = std(y_mat,0,2,'omitmissing'); sd(60)=[]; 
    
    % Smooth using a span of 10% of the total number of data points
    Smi=smooth([m;m;m;m],.1,'rloess'); Sm=Smi(366:366+364);
    Ssdi=smooth([sd;sd;sd;sd],.1,'rloess'); Ssd=Ssdi(366:366+364);
    clearvars m sd Smi Ssdi mdate_mat y_mat

%%%% Discharge climatology (1990-2022)
    [mdate_mat,y_mat,~,~] = timeseries2ydmat(datenum(CR.dt),CR.discharge);
    m = mean(y_mat,2,'omitmissing'); m(60)=[];
    sd = std(y_mat,0,2,'omitmissing'); sd(60)=[]; 
    
    % Smooth using a span of 10% of the total number of data points
    Dmi=smooth([m;m;m;m],.1,'rloess'); Dm=Dmi(366:366+364);
    Dsdi=smooth([sd;sd;sd;sd],.1,'rloess'); Dsd=Dsdi(366:366+364);
    clearvars m sd Dmi Dsdi mdate_mat y_mat

%%%% Parse 2019 and 2021 data
    dt=(datetime('01-Jan-2019'):1:datetime('31-Dec-2019'))';
    yr=year(CR.dt); C19=CR((yr==2019),:); C21=CR((yr==2021),:);
    c=brewermap(6,'RdBu');

%% Discharge: 1 panel plot (Fig. S2)
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 5.5 2.2]); 
patch([dt;flip(dt)],[Dm+Dsd;flip(Dm-Dsd)],'k','FaceAlpha',.1,'EdgeColor','none'); hold on;
plot(dt,C19.discharge,'-','Color',c(1,:)); hold on;
plot(dt,C21.discharge,'-','Color',c(end,:)); hold on;
set(gca,'tickdir','out','ylim',[0 4.7*10^5],'ytick',[0 2*10^5 4*10^5],...
    'xlim',[datetime('01-May-2019') datetime('01-Oct-2019')]);
ylabel('Discharge (ft^3/s)'); 
box on;

exportgraphics(fig,[filepath 'Figs/ColumbiaRiverDischarge_1plot.png'],'Resolution',300)    


%% Discharge & Turbidity: 2 panel plot (not using)
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 5 4]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.07 0.07], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1)
patch([dt;flip(dt)],[Dm+Dsd;flip(Dm-Dsd)],'k','FaceAlpha',.1,'EdgeColor','none'); hold on;
plot(dt,C19.discharge,'-','Color',c(1,:)); hold on;
plot(dt,C21.discharge,'-','Color',c(end,:)); hold on;
set(gca,'tickdir','out','ylim',[0 4.7*10^5],'ytick',[0 2*10^5 4*10^5],'xaxislocation','top',...
    'xlim',[datetime('01-May-2019') datetime('01-Oct-2019')]);
ylabel('Discharge (ft^3/s)'); box on;

subplot(2,1,2)
patch([dt;flip(dt)],[Sm+Ssd;flip(Sm-Ssd)],'k','FaceAlpha',.1,'EdgeColor','none'); hold on;
plot(dt,inpaintn(C19.turbidity_mean),'-','Color',c(1,:)); hold on;
plot(dt,inpaintn(C21.turbidity_mean),'-','Color',c(end,:)); hold on;
set(gca,'tickdir','out','ylim',[0 15],...
    'xlim',[datetime('01-May-2019') datetime('01-Oct-2019')]);
ylabel('Turbidity (FNU)'); box on;

exportgraphics(fig,[filepath 'Figs/ColumbiaRiverDischarge_Turbidity.png'],'Resolution',300)    

%% Discharge: 2 panel plots (not using)
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.5 4]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.06 0.06], [0.12 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1)
patch([dt;flip(dt)],[Dm+Dsd;flip(Dm-Dsd)],'k','FaceAlpha',.1,'EdgeColor','none'); hold on;
plot(dt,C19.discharge,'-','Color',c(1,:)); hold on;
%title('Discharge (ft^3/s)'); 
ylabel('2019');box on;
set(gca,'tickdir','out','ylim',[7*10^4 6*10^5],...
    'xlim',[datetime('01-Jan-2019') datetime('31-Dec-2019')],'xticklabel',{})

subplot(2,1,2)
patch([dt;flip(dt)],[Dm+Dsd;flip(Dm-Dsd)],'k','FaceAlpha',.1,'EdgeColor','none'); hold on;
plot(dt,C21.discharge,'-','Color',c(end,:)); hold on;
ylabel('2021'); box on;
set(gca,'tickdir','out','ylim',[7*10^4 6*10^5],...
    'xlim',[datetime('01-Jan-2019') datetime('31-Dec-2019')])

exportgraphics(fig,[filepath 'Figs/ColumbiaRiverDischarge_2019-2021.png'],'Resolution',300)    
