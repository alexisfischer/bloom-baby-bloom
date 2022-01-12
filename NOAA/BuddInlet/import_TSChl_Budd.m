%% Import data from spreadsheet
clear;

sheet=["041221";"050521";"050521";"052621";"060221";"061621";"070121";"070721"];
range=["A2:D83";"A2:D197";"A2:D145";"A2:D98";"A2:D182";"A2:D129";"A2:D129";"A2:D104"];

for i=1:length(sheet)
    opts = spreadsheetImportOptions("NumVariables", 4);
    opts.Sheet = sheet(i);
    opts.DataRange = range(i);
    opts.VariableNames = ["C", "SALPSU", "ChlRFU", "VertPosM"];
    opts.VariableTypes = ["double", "double", "double", "double"];    
    T = readtable("/Users/afischer/Documents/NOAA_research/BuddInlet/Data/TSDChl_Data_Graphs.xlsx", opts, "UseExcel", false);
    
    edges=(0:.1:8)'; 
    ind=discretize(T.VertPosM,edges);
    
    B(i).dn=datenum(datetime(sheet(i),'InputFormat','MMddyy'));    
    B(i).depth_m=edges;
    B(i).temp_C = accumarray(ind,T.C,[length(edges) 1],@mean,NaN);
    B(i).sal_psu = accumarray(ind,T.SALPSU,[length(edges) 1],@mean,NaN);
    B(i).chl_rfu = accumarray(ind,T.ChlRFU,[length(edges) 1],@mean,NaN);

    clearvars opts T ind;    
end

clearvars i sheet range edges;

%% plot stuff
addpath(genpath('~/MATLAB/bloom-baby-bloom/Misc-Functions/')); % add new data to search path
filepath='~/MATLAB/NWFSC/BuddInlet/'; addpath(genpath(filepath));

figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.06], [0.04 0.1], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

col=flipud(brewermap(length(B),'Spectral'));  %col=parula(length(B));

subplot(1,3,1);
for i=1:length(B)
    idx = ~isnan(B(i).temp_C);    
    h(i)=plot(B(i).temp_C(idx),B(i).depth_m(idx),'-','Color',col(i,:),'linewidth',1.5); hold on
end
set(gca,'ylim',[0 7],'Ydir','reverse','xaxislocation','top','fontsize',10,'Tickdir','out');

xlabel('temp (^oC)','fontsize',12);
ylabel('depth (m)','fontsize',12);

subplot(1,3,2);
for i=1:length(B)
    idx = ~isnan(B(i).sal_psu);        
    h(i)=plot(B(i).sal_psu(idx),B(i).depth_m(idx),'-','Color',col(i,:),'linewidth',1.5); hold on
end
set(gca,'ylim',[0 7],'Ydir','reverse','xaxislocation','top',...
    'yticklabel',{},'fontsize',10,'Tickdir','out');
char=datestr([B.dn]);
legend(h,char(:,1:6),'location','SW','fontsize',10); legend boxoff;
xlabel('sal (psu)','fontsize',12);

subplot(1,3,3);
for i=1:length(B)
    idx = ~isnan(B(i).chl_rfu);            
    h(i)=plot(B(i).chl_rfu(idx),B(i).depth_m(idx),'-','Color',col(i,:),'linewidth',1.5); hold on
end
set(gca,'ylim',[0 7],'Ydir','reverse','xaxislocation','top',...
    'yticklabel',{},'fontsize',10,'Tickdir','out');
xlabel('chl (rfu)','fontsize',12);
 
% % mean chl line
% chl=nanmean([B.chl_rfu],2); idx = ~isnan(chl);         
% plot(chl(idx),B(1).depth_m(idx),':k','linewidth',1.5); hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'Figs/BuddInlet_TSC.tif']);
hold off   
