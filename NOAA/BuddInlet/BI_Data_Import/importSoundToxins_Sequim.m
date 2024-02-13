%% import Soundtoxins
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "My Observations";
opts.DataRange = "A2:H1251";
opts.VariableNames = ["Var1", "Site", "Date", "Var4", "Genus", "Species", "Abundance", "CellPerLiter"];
opts.SelectedVariableNames = ["Site", "Date", "Genus", "Species", "Abundance", "CellPerLiter"];
opts.VariableTypes = ["char", "categorical", "datetime", "char", "categorical", "categorical", "categorical", "double"];
opts = setvaropts(opts, ["Var1", "Var4"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Site", "Var4", "Genus", "Species", "Abundance"], "EmptyFieldRule", "auto");
T = readtable("/Users/alexis.fischer/Documents/DinophysisProject/Data/SQ dinophysis all.xlsx", opts, "UseExcel", false);
clear opts

T(contains(cellstr(T.Abundance),'undefined'),:)=[]; %remove blanks
T(~contains(cellstr(T.Species),'sp'),:)=[]; %only look at bulk Dinophysis

T.month=T.Date.Month; Month=(1:1:12)';
Absent=NaN*ones(12,1);
Present=Absent;
Common=Absent;
Bloom=Absent;
n=Absent;
for i=1:length(Month)
    Absent(i)=sum(T.month==i & contains(cellstr(T.Abundance),'Absent'));
    Present(i)=sum(T.month==i & contains(cellstr(T.Abundance),'Present'));
    Common(i)=sum(T.month==i & contains(cellstr(T.Abundance),'Common'));
    Bloom(i)=sum(T.month==i & contains(cellstr(T.Abundance),'Bloom'));
    n(i)=sum(T.month==i);
end
SB=table(Month,n,Bloom,Common,Present,Absent);
SB(:,3:end)=SB(:,3:end)./SB.n;

T=table2array(SB(:,3:end));
clearvars Month n Absent Present Common Bloom i

%% plot
c=flipud(brewermap(4,'Greys')); c(4,:)=[1 1 1];

%%c(4,:)=[1 1 1];
figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
yyaxis left
b=bar(T,'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:4
    b(i).CData=c(i,:);
end
set(gca,'xlim',[0.5 12.5],'ycolor','k','fontsize',10)
ylabel('fraction of all samples','fontsize',11)

yyaxis right
plot(SB.Month,SB.n,'r*','linewidth',1); hold on;
set(gca,'xlim',[0.5 12.5],'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'},'ycolor','r','fontsize',10)

ylabel('# samples','fontsize',11)
xlabel('month','fontsize',11)
title('Sequim Bay','fontsize',12)

lh=legend([b(4) b(3) b(2) b(1)],'Absent','Present','Common','Bloom',...
    'Location','NorthOutside','fontsize',10); legend boxoff;
%lh.Title.String={'Dinophysis';'Relative';'Abundance'};

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/SequimBay_RelAbundance.png'],'Resolution',100)    
hold off


