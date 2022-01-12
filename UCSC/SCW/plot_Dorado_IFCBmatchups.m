%% plot optical and microscopy matchups
addpath(genpath('~/MATLAB/bloom-baby-bloom/Misc-Functions/')); % add new data to search path
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path

clear;

file="/Users/afischer/Documents/Proposals/NSF_2020/matchups_Bathy_RAI_IFCB.xlsx";
%%%% load in North DD data
opts = spreadsheetImportOptions("NumVariables", 20);
opts.Sheet = "NorthernDD";
opts.DataRange = "A4:T36";
opts.VariableNames = ["Date", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "pctadinosfluo0001", "Var13", "Var14", "Var15", "RAIdinofraction", "Var17", "Var18", "Var19", "pctadinos"];
opts.SelectedVariableNames = ["Date", "pctadinosfluo0001", "RAIdinofraction", "pctadinos"];
opts.VariableTypes = ["datetime", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "char", "char", "char", "double", "char", "char", "char", "double"];
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var13", "Var14", "Var15", "Var17", "Var18", "Var19"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var13", "Var14", "Var15", "Var17", "Var18", "Var19"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Date", "InputFormat", "");
T = readtable(file, opts, "UseExcel", false);
    AUV=T.pctadinosfluo0001;
    RAI=T.RAIdinofraction;
    IFCB=T.pctadinos;
    dt=T.Date;
    [~,month] = datevec(dt);
    ND=table(dt,month,AUV,RAI,IFCB);

clear opts T AUV RAI IFCB dt month;

%%%% load in North DD data
opts = spreadsheetImportOptions("NumVariables", 17);
opts.Sheet = "M1";
opts.DataRange = "A4:Q38";
opts.VariableNames = ["Date", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "pctadinosfluo0001", "Var13", "Var14", "Var15", "Var16", "pctdino"];
opts.SelectedVariableNames = ["Date", "pctadinosfluo0001", "pctdino"];
opts.VariableTypes = ["datetime", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double"];
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var13", "Var14", "Var15", "Var16"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var13", "Var14", "Var15", "Var16"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Date", "InputFormat", "");
T = readtable(file, opts, "UseExcel", false);
    AUV=T.pctadinosfluo0001;
    RAI=T.pctdino;
    dt=T.Date;
    [~,month] = datevec(dt);
    M1=table(dt,month,AUV,RAI);

clear opts T AUV RAI dt month;

%% 
filepath = '~/MATLAB/UCSC/'; 

figure('Units','inches','Position',[1 1 5.8 5.8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.12 0.05], [0.07 0.01], [0.09 0.09]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
    
subplot(2,2,1);
    ND1=ND; ND1.month(26)=2; ND1.month(1)=7;
    id = ismember(ND1.month,3:6); ND1(id,:)=[]; %remove all upwelling points
    x=ND1.RAI; y=ND1.AUV;
    
    scatter(x,y,40,'r','filled','MarkerEdgeColor','k','linewidth',.25); hold on; box on;
    set(gca,'ylim',[0 1],'xlim',[0 1],'ytick',0:.5:1,'xtick',0:.5:1,'fontsize',9);    
    xlabel('Microscopy','fontsize',11)
    ylabel('Optical Proxy','fontsize',11)

    Lfit = fitlm(x,y,'linear');
    b = Lfit.Coefficients.Estimate(1); m = Lfit.Coefficients.Estimate(2); 
    xfit = linspace(0,1,20); yfit = m*xfit+b; 
    plot(xfit,yfit,':k'); axis square; hold on
    %correlation coefficient
    r = corrcoef(x,y,'Alpha',.1,'Rows','complete');
    str=['r= ',num2str(round(r(1,2),2))];
    T = text(max(get(gca, 'xlim')), min(get(gca, 'ylim')), str); 
    set(T, 'fontsize',11,'verticalalignment', 'bottom', 'horizontalalignment', 'right');    

subplot(2,2,2);
    id = ismember(ND.month,3:5); ND(id,:)=[]; %remove all upwelling points
    x=ND.IFCB; y=ND.AUV;
    
    h=scatter(x,y,40,'r','filled','MarkerEdgeColor','k','linewidth',.25); hold on; box on;
    set(gca,'ylim',[0 1],'xlim',[0 1],'ytick',0:.5:1,'xtick',0:.5:1,'yticklabel',{},'fontsize',9);
    xlabel('IFCB','fontsize',11);
    
    Lfit = fitlm(x,y,'linear');
    b = Lfit.Coefficients.Estimate(1); m = Lfit.Coefficients.Estimate(2); 
    xfit = linspace(0,1,20); yfit = m*xfit+b; 
    plot(xfit,yfit,':k'); axis square; hold on
    %correlation coefficient
    r = corrcoef(x,y,'Alpha',.1,'Rows','complete');
    str=['r= ',num2str(round(r(1,2),2))];
    T = text(max(get(gca, 'xlim')), min(get(gca, 'ylim')), str); 
    set(T, 'fontsize',11,'verticalalignment', 'bottom', 'horizontalalignment', 'right');    

subplot(2,2,3);
    x=M1.RAI; y=M1.AUV;
    scatter(x,y,40,'b','filled','MarkerEdgeColor','k','linewidth',.25); hold on; box on;
    set(gca,'ylim',[0 1],'xlim',[0 1],'ytick',0:.5:1,'xtick',0:.5:1,'fontsize',9);    
    xlabel('Microscopy','fontsize',11)
    ylabel('Optical Proxy','fontsize',11)
    Lfit = fitlm(M1.RAI,M1.AUV,'linear');
    b = Lfit.Coefficients.Estimate(1); m = Lfit.Coefficients.Estimate(2); 
    xfit = linspace(0,1,20); yfit = m*xfit+b; 
    plot(xfit,yfit,':k'); axis square; hold on
            
    %correlation coefficient
    r = corrcoef(x,y,'Alpha',.1,'Rows','complete');
    str=['r= ',num2str(round(r(1,2),2))];
    T = text(max(get(gca, 'xlim')), min(get(gca, 'ylim')), str); 
    set(T, 'fontsize',11,'verticalalignment', 'bottom', 'horizontalalignment', 'right'); hold on;
 
subplot(2,2,4);    
    C=brewermap(3,'Blues');
    load([filepath 'SCW/Data/coast_montereybay'],'ncst');

    m_proj('albers equal-area','lat',[36.59 37.01],'long',[-122.25 -121.77]);
    m_gshhs_f('patch',[.7 .7 .7],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',.5,'tickdir','out',...
         'xaxisloc','bottom','yaxisloc','right','fontsize',11,'backcolor',C(1,:));  

    m_line(-122.017,36.96,'marker','o','markersize',5,'color','k','markerfacecolor','r','linewidth',.5); %SCMW
    m_line(-121.9636,36.9026,'marker','o','markersize',5,'color','k','markerfacecolor','r','linewidth',.5); %N DD
    m_line(-122.029,36.751,'marker','o','markersize',5,'color','k','markerfacecolor','b','linewidth',.5); %M1
    axis square; hold on;
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'SCW/Figs/Dorado_RAI_IFCB_matchup_2color.tif']);
hold off

%% Dorado vs IFCB and RAI
figure('Units','inches','Position',[1 1 7.5 7],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.04], [0.08 0.02], [0.09 0.12]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

id = find(~ismember(M,3:6)); %only select Jan-May months

ax1=subplot(2,2,1);
    scatter(RAI,DD,80,M,'filled','MarkerEdgeColor','k','linewidth',.25); hold on; box on;
    ylabel('Dorado Diamond Bathyphotometer','fontsize',12)
    set(gca,'ylim',[0 1],'xlim',[0 1],'ytick',0:.2:1,'xtick',0:.2:1,'xticklabel',{});
    colormap(ax1,jet);

    Lfit = fitlm(RAI(id),DD(id),'linear');
    b = Lfit.Coefficients.Estimate(1); m = Lfit.Coefficients.Estimate(2); 
    Rsq = Lfit.Rsquared.Ordinary
    xfit = linspace(0,1,20); yfit = m*xfit+b; 
    plot(xfit,yfit,':k'); hold on

ax2=subplot(2,2,2);
    scatter(IFCB,DD,80,M,'filled','MarkerEdgeColor','k','linewidth',.25); hold on; box on;
    set(gca,'ylim',[0 1],'xlim',[0 1],'ytick',0:.2:1,'xtick',0:.2:1,'yticklabel',{},'xticklabel',{});
    colormap(ax2,jet);

    Lfit = fitlm(IFCB(id),DD(id),'linear');
    b = Lfit.Coefficients.Estimate(1); m = Lfit.Coefficients.Estimate(2); 
    Rsq = Lfit.Rsquared.Ordinary
    xfit = linspace(0,1,20); yfit = m*xfit+b; 
    plot(xfit,yfit,':k'); hold on
    
    h=colorbar;
    h.TickDirection = 'out';         
    h.FontSize = 10;
    h.Label.String = 'month of year';     
    h.Label.FontSize = 12;
    h.Ticks=linspace(1,12,12);    
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.08 hp(2) hp(3) hp(4)];    
    hold off
 
ax3=subplot(2,2,3);
    id = ~ismember(M,3:6); %only select Jan-May months
    col=double(id);
    cax=[0 1]; caxis(cax); grid on; 

    ax3=scatter(RAI,DD,80,col,'filled','MarkerEdgeColor','k','linewidth',.25); hold on; box on;
    xlabel('wharf RAI','fontsize',12)
    ylabel('Dorado Diamond Bathyphotometer','fontsize',12)
    set(gca,'ylim',[0 1],'xlim',[0 1],'ytick',0:.2:1,'xtick',0:.2:1);

    Lfit = fitlm(RAI(id),DD(id),'linear');
    b = Lfit.Coefficients.Estimate(1); m = Lfit.Coefficients.Estimate(2); 
    Rsq = Lfit.Rsquared.Ordinary
    xfit = linspace(0,1,20); yfit = m*xfit+b; 
    plot(xfit,yfit,':k'); hold on

ax4=subplot(2,2,4);
    scatter(IFCB,DD,80,col,'filled','MarkerEdgeColor','k','linewidth',.25); hold on; box on;
    xlabel('wharf IFCB','fontsize',12);
    set(gca,'ylim',[0 1],'xlim',[0 1],'ytick',0:.2:1,'xtick',0:.2:1,'yticklabel',{});

    Lfit = fitlm(IFCB(id),DD(id),'linear');
    b = Lfit.Coefficients.Estimate(1); m = Lfit.Coefficients.Estimate(2); 
    Rsq = Lfit.Rsquared.Ordinary
    xfit = linspace(0,1,20); yfit = m*xfit+b; 
    plot(xfit,yfit,':k'); hold on    

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200','~/MATLAB/UCSC/SCW/Figs/Dorado_RAI_IFCB_matchup.tif');
hold off

%% RAI vs IFCB
    id = ~ismember(M,6:7); 
    col=double(id);
    cax=[0 1]; caxis(cax); grid on; 
    
figure('Units','inches','Position',[1 1 4 3.3],'PaperPositionMode','auto');
scatter(RAI,IFCB,50,col,'filled','MarkerEdgeColor','k','linewidth',.25); hold on; box on;
xlabel('RAI fraction adino','fontsize',12)
ylabel('IFCB fraction adino','fontsize',12)
set(gca,'ylim',[0 1],'xlim',[0 1],'ytick',0:.2:1,'xtick',0:.2:1);


    %%
h=colorbar;
    h.TickDirection = 'out';         
    h.FontSize = 10;
    h.Label.String = 'month of year';     
    h.Label.FontSize = 12;
    h.Ticks=linspace(0,1,12);       
    hold on
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200','~/MATLAB/UCSC/SCW/Figs/IFCB_RAI_matchup.tif');
hold off