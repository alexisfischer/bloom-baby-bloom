%% Import and plot 2010 Totten Inlet (Calm Cove) data
clear;
filepath = '~/MATLAB/NWFSC/TottenInlet/'; 
addpath(genpath('~/MATLAB/bloom-baby-bloom/'));
addpath(genpath(filepath));

%% import
opts = spreadsheetImportOptions("NumVariables", 40);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:AN23";
opts.VariableNames = ["CO2SampleID", "date", "time", "tidalStage", "tidalHeight", "collectionDepth", "dateValue", "yearday", "WaterTempCDepth", "SalinpptDepth", "DOmglDepth", "inSituTemp", "pH", "pCO2", "OmegaCaOut", "OmegaArOut", "phytoplanktonSamplingDate", "ChaetocerosSppdiatomsCellsL", "ThalassiosiraSppdiatomsCellsL", "GuinardiaSpp", "Pseudonitzchialg", "Pseudonitzchiasm", "AkashiwoSanguinea", "AlexandriumSpp", "CeratiumSpp", "DinophysisSpp", "Tintinnids", "copepoda", "barnacleNauplii", "crustaceanNauplii", "rotifers", "tiarina", "Urochordata", "GastropodLarvae", "Fusopsis", "PolychaeteLarvae", "Eggs", "totalDinoflagellatescellsL", "totalZoopscellsL", "totalDiatomscellsL"];
opts.VariableTypes = ["string", "datetime", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "CO2SampleID", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["CO2SampleID", "tidalStage"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "date", "InputFormat", "");
opts = setvaropts(opts, "phytoplanktonSamplingDate", "InputFormat", "");
T = readtable("/Users/afischer/Documents/Proposals/NOAA-OAR-SG-2021/PrelimData/CompleteTottenData_2010.xlsx", opts, "UseExcel", false);
clear opts

%% plot

figure('Units','inches','Position',[1 1 4.5 4.5],'PaperPositionMode','auto'); clf;
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.06 0.06], [0.15 .31]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax=[datetime('01-May-2010') datetime('01-Oct-2010')];

subplot(5,1,1);
plot(T.date,T.WaterTempCDepth,'-ko','MarkerFaceColor','k','linewidth',1,'markersize',4);
set(gca,'xlim',xax,'Fontsize',10,'tickdir','out','xaxislocation','top')
ylabel({'T (^oC)'},'Fontsize',11)

subplot(5,1,2);
col=flipud(brewermap(3,'PuBuGn')); 
yyaxis left
plot(T.date,T.DOmglDepth','-k^','linewidth',1,'markersize',4);
set(gca,'xlim',xax,'Fontsize',10,'tickdir','out','xticklabel',{},'ycolor','k')
ylabel({'DO (mg/L)'},'Fontsize',11,'Color','k')

yyaxis right
plot(T.date,T.pH','-s','Color',col(1,:),'linewidth',1,'markersize',4);
set(gca,'xlim',xax,'Fontsize',10,'tickdir','out','xticklabel',{},'ycolor',col(1,:))
ylabel('pH','Fontsize',11,'Color',col(1,:))

subplot(5,1,3);
h=plot(T.date,T.OmegaCaOut,'-s',T.date,T.OmegaArOut,'-*','linewidth',1,'markersize',4); hold on
col=brewermap(2,'PrGn'); 
set(h(1),'MarkerFaceColor',col(1,:),'Color',col(1,:)); 
set(h(2),'MarkerFaceColor',col(2,:),'Color',col(2,:));
yline(1); hold on;
set(gca,'xlim',xax,'Fontsize',10,'tickdir','out','xticklabel',{})
ylabel('saturation','Fontsize',11)
lh=legend('\Omega_{calcite}','\Omega_{aragonite}'); legend boxoff
lh.FontSize = 10; hp=get(lh,'pos'); lh.Position=[1.65*hp(1) hp(2) hp(3) hp(4)]; 

subplot(5,1,4);
total=[T.totalDinoflagellatescellsL+T.totalDiatomscellsL];
dino=T.totalDinoflagellatescellsL./total;
diat=T.totalDiatomscellsL./total;
h = bar(T.phytoplanktonSamplingDate,[dino diat],'stack','Barwidth',.8);
col=brewermap(2,'RdBu');
set(h(1),'FaceColor',col(1,:),'EdgeColor',col(1,:));
set(h(2),'FaceColor',col(2,:),'EdgeColor',col(2,:));
set(gca,'xlim',xax,'Fontsize',10,'ylim',[0 1],'tickdir','out','xticklabel',{})
ylabel({'phytoplankton';'fraction'},'Fontsize',11)
lh=legend('dinoflagellates','diatoms'); legend boxoff
lh.FontSize = 10; hp=get(lh,'pos'); lh.Position=[1.95*hp(1) hp(2) hp(3) hp(4)]; 

subplot(5,1,5);
T.AkashiwoSanguinea(T.AkashiwoSanguinea==0)=1;
T.CeratiumSpp(T.CeratiumSpp==0)=1;
h=plot(T.phytoplanktonSamplingDate,T.AkashiwoSanguinea,'-o',...
    T.phytoplanktonSamplingDate,T.CeratiumSpp,'-x','linewidth',1,'markersize',4);
col=flipud(brewermap(4,'YlOrRd')); %idx=[2 4 6]; col(idx,:)=[];
for i=1:length(h)
    set(h(i),'Color',col(i,:),'MarkerFaceColor',col(i,:));
end

set(gca,'xlim',xax,'ylim',[10^2 10^6],'Fontsize',10,'Yscale','log','tickdir','out')
ylabel('Cells/L','Fontsize',11)
lh=legend('\itA. sanguinea','\itCeratium\rm spp.'); legend boxoff
lh.FontSize = 10; hp=get(lh,'pos'); lh.Position=[1.95*hp(1) hp(2) hp(3) hp(4)]; 
lh.Title.String='dinoflagellates';

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'Figs/Totten_2010.tif']);
hold off
