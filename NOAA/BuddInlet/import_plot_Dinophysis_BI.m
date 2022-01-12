%plot dinophysis
clear
opts = spreadsheetImportOptions("NumVariables", 20);
opts.Sheet = "Data";
opts.DataRange = "A2:T27";
opts.VariableNames = ["SampleDate", "Var2", "Var3", "Var4", "ChlMaxDepthm", "Var6", "Var7", "Var8", "Var9", "DinophysisConcentrationcellsL", "Var11", "Var12", "Var13", "Var14", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva"];
opts.SelectedVariableNames = ["SampleDate", "ChlMaxDepthm", "DinophysisConcentrationcellsL", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva"];
opts.VariableTypes = ["datetime", "char", "char", "char", "categorical", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13", "Var14"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "ChlMaxDepthm", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13", "Var14"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "SampleDate", "InputFormat", "");
T = readtable("/Users/afischer/MATLAB/NOAA/BuddInlet/Data/Phyto-Enviro Data.xlsx", opts, "UseExcel", false);
T(1:3,:)=[];

clearvars opts

save('/Users/afischer/MATLAB/NOAA/BuddInlet/Data/DinophysisMicroscopy','T');
%%
figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.08], [0.09 0.21]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datetime('2021-05-01'); xax2=datetime('2021-11-10');     

subplot(2,1,1);
plot(T.SampleDate,0.001*T.DinophysisConcentrationcellsL,'k*-')
    set(gca,'xlim',[xax1 xax2],...
        'fontsize', 11,'fontname', 'arial','tickdir','out','xaxislocation','top');   
    ylabel('Dinophysis (cells/mL)','fontsize',11);

subplot(2,1,2);
h = bar(T.SampleDate,0.01*[T.DAcuminata T.DFortii T.DNorvegica T.DOdiosa...
    T.DRotundata T.DParva],'stack','Barwidth',4);
c=brewermap(6,'Spectral');
    for i=1:length(h)
        set(h(i),'FaceColor',c(i,:));
    end  

%    datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 11,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'});   
        ylabel('Fx Dinophysis','fontsize',11);


    lh=legend('acuminata','fortii','norvegica','odiosa','rotundata','parva');
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)+.23 hp(2) hp(3) hp(4)]; hold on    
    lh.Title.String='Species';

set(gcf,'color','w');
print(gcf,'-dtiff','-r300','/Users/afischer/MATLAB/NOAA/BuddInlet/Figs/Dinophysis_microscopy_BI.tif');
hold off