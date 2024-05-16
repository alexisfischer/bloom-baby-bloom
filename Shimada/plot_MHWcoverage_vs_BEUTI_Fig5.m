%% imports data and plots timing of BEUTI relative to MHW coverage of the EEZ in 2015 and 2019
% Estimates of coastal upwelling-derived nitrate flux in WA, OR, and N.CA 
% are provided by BEUTI at 47ºN, 44ºN, and 41ºN, respectively. 
% The percentage of the EEZ off the coasts of WA (46–48ºN), OR (42–46ºN), 
% and N. CA (38–42ºN) that are in marine heatwave status is shown.
% Fig. 5 in Fischer et al. 2024, L&O
% A.D. Fischer, May 2024
%
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/Shimada/';
addpath(genpath(filepath)); % add new data to search path

%% import MHW coverage of EEZ
Tdir=dir([filepath 'Data/CCIEA/*2015.mat']);
for i=1:length(Tdir)   
    name=Tdir(i).name;    
    load([filepath 'Data/CCIEA/' name]);    
    disp(name);
    dt=datetime(unixtime2mat(cciea_OC_MHW_regions.time),'ConvertFrom','datenum'); % seconds since 1970-01-01T00:00:00Z;
    C.y2015(i).region=cciea_OC_MHW_regions.region(1,:);
    C.y2015(i).dt=dt(1:365);
    C.y2015(i).mhwcover=smoothdata(cciea_OC_MHW_regions.heatwave_cover(1:365),'movmean',14);
end

Tdir=dir([filepath 'Data/CCIEA/*2019.mat']);
for i=1:length(Tdir)   
    name=Tdir(i).name;    
    load([filepath 'Data/CCIEA/' name]);    
    disp(name);
    dt=datetime(unixtime2mat(cciea_OC_MHW_regions.time),'ConvertFrom','datenum'); % seconds since 1970-01-01T00:00:00Z;
    C.y2019(i).region=cciea_OC_MHW_regions.region(1,:);
    C.y2019(i).dt=dt(1:365);
    C.y2019(i).mhwcover=smoothdata(cciea_OC_MHW_regions.heatwave_cover(1:365),'movmean',14);
end
clearvars cciea_OC_MHW_regions i Tdir name dt

%% import BEUTI
opts = delimitedTextImportOptions("NumVariables", 20);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["year", "month", "day", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "N10", "Var15", "Var16", "N13", "Var18", "Var19", "N16"];
opts.SelectedVariableNames = ["year", "month", "day", "N10", "N13", "N16"];
opts.VariableTypes = ["double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "char", "char", "double", "char", "char", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var15", "Var16", "Var18", "Var19"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var15", "Var16", "Var18", "Var19"], "EmptyFieldRule", "auto");
B = readtable([filepath 'Data/BEUTI_daily.csv'], opts);
BB=B;

%2015
B(~(B.year==2015),:)=[];
B=table2array(B(:,4:end));
C.y2015(1).BEUTI_lat=41;
C.y2015(2).BEUTI_lat=44;
C.y2015(3).BEUTI_lat=47;
C.y2015(1).BEUTI=smoothdata(B(:,1),'movmean',14);
C.y2015(2).BEUTI=smoothdata(B(:,2),'movmean',14);
C.y2015(3).BEUTI=smoothdata(B(:,3),'movmean',14);

%2019
BB(~(BB.year==2019),:)=[];
BB=smoothdata(table2array(BB(:,4:end)),'movmean',14);
C.y2019(1).BEUTI_lat=41;
C.y2019(2).BEUTI_lat=44;
C.y2019(3).BEUTI_lat=47;
C.y2019(1).BEUTI=smoothdata(BB(:,1),'movmean',14);
C.y2019(2).BEUTI=smoothdata(BB(:,2),'movmean',14);
C.y2019(3).BEUTI=smoothdata(BB(:,3),'movmean',14);

%% plot MHW vs BEUTI
col=flipud(brewermap(2,'Reds'));
brange=[-8 45];
btick=0:20:40;
x15=[datetime('01-Jan-2015') datetime('31-Dec-2015')];
x19=[datetime('01-Jan-2019') datetime('31-Dec-2019')];

figure('Units','inches','Position',[1 1 5.2 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.06 0.05], [0.11 0.1]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

% 2015
subplot(3,2,1)
    yyaxis left
    plot(C.y2015(3).dt,C.y2015(3).BEUTI,'k-','linewidth',1); hold on
    hline(0,'k:'); hold on        
    set(gca,'ylim',brange,'ytick',btick,'xlim',x15,'ycolor','k','tickdir','out','fontsize',9)
    ylabel({'\bfWA';'\rmBEUTI'},'fontsize',11)
    
    yyaxis right
    plot(C.y2015(3).dt,C.y2015(3).mhwcover,'-','Color',col(1,:),'linewidth',1); hold on
    set(gca,'xlim',x15,'tickdir','out')
    datetick('x','m','keeplimits');
    set(gca,'xticklabel',{},'yticklabel',{},'tickdir','out','ycolor',col(1,:),'fontsize',9)
    title('2015','fontsize',11);

subplot(3,2,3)
    yyaxis left
    plot(C.y2015(2).dt,C.y2015(2).BEUTI,'k-','linewidth',1); hold on
    hline(0,'k:'); hold on        
    set(gca,'ylim',brange,'ytick',btick,'xlim',x15,'ycolor','k','tickdir','out','fontsize',9)
    ylabel({'\bfOR';'\rmBEUTI'},'fontsize',11)
    
    yyaxis right
    plot(C.y2015(2).dt,C.y2015(2).mhwcover,'-','Color',col(1,:),'linewidth',1); hold on
    set(gca,'xlim',x15,'tickdir','out')
    datetick('x','m','keeplimits');
    set(gca,'xticklabel',{},'yticklabel',{},'tickdir','out','ycolor',col(1,:),'fontsize',9)

subplot(3,2,5)
    yyaxis left
    plot(C.y2015(1).dt,C.y2015(1).BEUTI,'k-','linewidth',1); hold on
    hline(0,'k:'); hold on        
    set(gca,'ylim',brange,'ytick',btick,'xlim',x15,'ycolor','k','tickdir','out','fontsize',9)
    ylabel({'\bfN. CA';'\rmBEUTI'},'fontsize',11)
    
    yyaxis right
    plot(C.y2015(1).dt,C.y2015(1).mhwcover,'-','Color',col(1,:),'linewidth',1); hold on
    set(gca,'xlim',x15,'ycolor',col(1,:),'fontsize',9,'yticklabel',{},'tickdir','out')
    datetick('x','m','keeplimits');
xtickangle(0);

%%%% 2019
subplot(3,2,2)
    yyaxis left
    plot(C.y2019(3).dt,C.y2019(3).BEUTI,'k-','linewidth',1); hold on
    hline(0,'k:'); hold on        
    set(gca,'ylim',brange,'ytick',btick,'xlim',x19,'yticklabel',{},'ycolor','k','tickdir','out','fontsize',9)
    
    yyaxis right
    plot(C.y2019(3).dt,C.y2019(3).mhwcover,'-','Color',col(1,:),'linewidth',1); hold on
    set(gca,'xlim',x19,'tickdir','out')
    datetick('x','m','keeplimits');
    set(gca,'xticklabel',{},'tickdir','out','ycolor',col(1,:),'fontsize',9)
    ylabel('% cover','fontsize',11)
    title('2019','fontsize',11);

subplot(3,2,4)
    yyaxis left
    plot(C.y2019(2).dt,C.y2019(2).BEUTI,'k-','linewidth',1); hold on
    hline(0,'k:'); hold on        
    set(gca,'ylim',brange,'ytick',btick,'xlim',x19,'yticklabel',{},'ycolor','k','tickdir','out','fontsize',9)
    
    yyaxis right
    plot(C.y2019(2).dt,C.y2019(2).mhwcover,'-','Color',col(1,:),'linewidth',1); hold on
    set(gca,'xlim',x19,'tickdir','out')
    datetick('x','m','keeplimits');
    set(gca,'xticklabel',{},'tickdir','out','ycolor',col(1,:),'fontsize',9,'fontsize',9)
    ylabel('% cover','fontsize',11)

subplot(3,2,6)
    yyaxis left
    plot(C.y2019(1).dt,C.y2019(1).BEUTI,'k-','linewidth',1); hold on
    hline(0,'k:'); hold on        
    set(gca,'ylim',brange,'ytick',btick,'xlim',x19,'yticklabel',{},'ycolor','k','tickdir','out','fontsize',9)
    
    yyaxis right
    plot(C.y2019(1).dt,C.y2019(1).mhwcover,'-','Color',col(1,:),'linewidth',1); hold on
    set(gca,'xlim',x19,'ycolor',col(1,:),'fontsize',9,'tickdir','out')
    datetick('x','m','keeplimits');
    ylabel('% cover','fontsize',11)
xtickangle(0);

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/MHWcover_BEUTI_2019_2021.png'],'Resolution',300)    
hold off

