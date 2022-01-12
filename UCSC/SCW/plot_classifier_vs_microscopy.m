clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SCW/';
error=0.7;

%for PRESENTATION
% class2do_string = 'Akashiwo'; chain=1; ymax=100; yyax2=1; yystep=0.5; step=50; max=100;
% class2do_string = 'Alexandrium_singlet'; chain=2; ymax=10.5; yyax2=0.1; yystep=0.05; step=5; max=10;
% class2do_string = 'Ceratium'; chain=1; ymax=16; yyax2=.8; yystep=0.4; step=4; max=16;
% class2do_string = 'Dinophysis'; chain=1;  ymax=9.2; yyax2=.32; yystep=.1; step=3; max=9;
% class2do_string = 'Cochlodinium'; chain=1; ymax=55;  yyax2=.36; yystep=0.1; step=25; max=50;
 class2do_string = 'Pseudo-nitzschia'; chain=4; ymax=75; yyax2=.8; yystep=0.4; step=25; max=75;

%for PUBLICATION
% class2do_string = 'Akashiwo'; chain=1; ymax=100; yyax2=0.8; yystep=0.4; step=50; max=100;
% class2do_string = 'Alexandrium_singlet'; chain=2; ymax=10.5; yyax2=0.1; yystep=0.05; step=5; max=10;
% class2do_string = 'Ceratium'; chain=1; ymax=16; yyax2=.8; yystep=0.4; step=8; max=16;
% class2do_string = 'Dinophysis'; chain=1;  ymax=9; yyax2=.1; yystep=.05; step=3; max=9;
% class2do_string = 'Cochlodinium'; chain=1; ymax=60;  yyax2=.34; yystep=0.1; step=20; max=60;
% class2do_string = 'Pseudo-nitzschia'; chain=4; ymax=75; yyax2=.8; yystep=0.4; step=25; max=75;

[class2do_string,mdate,y_mat,~,iraifx,fish,mcrpy,RAI]=matchClassifierwMicroscopy(filepath,class2do_string,chain,error,'2018');

load([filepath 'Data/SCW_master'],'SC');
id=~isnan(SC.CHL); chl.dn=SC.dn(id); chl.c=SC.CHL(id); clearvars id SC;

%% PUBLICATION: TOP) chlorophyll BOTTOM) classifier and microscopy
figure('Units','inches','Position',[1 1 8.5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.1], [0.11 -0.5], [0.08 0.17]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
col=(brewermap(3,'Dark2'));

subplot(2,1,1);
    pcolor(chl.dn,[1,2],[chl.c';0*chl.c']); 
    cax=[0 20]; caxis(cax); colormap(flipud(gray)); shading flat;
    datetick('x','m','keeplimits'); 
    set(gca,'xlim',[xax1 xax2],'ylim',[1 2],'ytick',1:1:2,'xticklabel',{},'yticklabel',{}); box on
    h=colorbar('south'); hp=get(h,'pos'); 
    hp(1)=.75+hp(1); hp(2)=hp(2)+.03; hp(3)=.16*hp(3); hp(4)=hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    h.Ticks=linspace(cax(1),cax(2),3); h.Label.FontSize = 11; h.Label.FontWeight = 'bold';       
    hold on

subplot(2,1,2);
yyaxis left
plot(mdate, y_mat,'ko','Linewidth',1,'markersize',5); hold on  
idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
if idx == 1       
    h3 = errorbar(fish.dn,fish.cells,fish.err,'o','Linestyle','none','Linewidth',1.5,...
    'Color',col(1,:),'MarkerFaceColor',col(1,:),'Markersize',6); hold on  
else
end
errorbar(mcrpy.dn,mcrpy.cells,mcrpy.err,'^','Color',col(2,:),'Linestyle','none','Linewidth',1.5,'Markersize',6); hold on    

    datetick('x','m','keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ytick',step:step:max,'fontsize',12,...
        'Ylim',[0 ymax],'xticklabel',{},'ycolor','k');  
    ylabel('cells mL^{-1}','fontsize',14);   
    hold on

yyaxis right
plot(RAI.dn,RAI.fx,'k*','color',col(3,:),'markersize',7,'Linewidth',1.5); hold on
    set(gca,'xlim',[xax1 xax2],'ylim',[0 yyax2],'ytick',yystep:yystep:yyax2,...
        'ycolor',col(3,:),'fontsize',12,'xaxislocation','bottom');
    datetick('x','m','keeplimits');
    ylabel({'fraction of biomass'},'fontsize',14);  hold on

    %%
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Classifier_vs_microscopy_pub_' num2str(class2do_string) '.tif']);
hold off

%% PRESENTATION: TOP)  classifier vs FISH vs Utermols BOTTOM) fx classifier vs RAI 
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03],[0.08 0.08], [0.1 .02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
col=(brewermap(3,'Dark2'));

onlyClassifier=1; %if making a special plot for PN
%onlyClassifier=0; %normal

subplot(2,1,1);
plot(mdate, y_mat,'ko','Linewidth',1,'markersize',5); hold on
    
if onlyClassifier==1
else
    idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
    if idx == 1       
        h3 = errorbar(fish.dn,fish.cells,fish.err,'o','Linestyle','none','Linewidth',1.5,...
        'Color',col(1,:),'MarkerFaceColor',col(1,:),'Markersize',6); hold on  
    else
    end
    errorbar(mcrpy.dn,mcrpy.cells,mcrpy.err,'^','Color',col(2,:),'Linestyle','none','Linewidth',1.5,'Markersize',6); hold on    
end
    datetick('x','m','keeplimits');    
    set(gca,'xlim',[xax1 xax2],'xaxislocation','top','ytick',step:step:max,...
        'fontsize',12,'Ylim',[0 ymax]);  
    ylabel('cells mL^{-1}','fontsize',14); hold on

subplot(2,1,2);
h=plot(mdate,iraifx,'ko',RAI.dn,RAI.fx,'k*','markersize',4,'Linewidth',1.5); hold on
    set(h(1),'MarkerFacecolor','k');
    set(h(2),'Color',col(3,:),'markersize',7);
    set(gca,'xlim',[xax1 xax2],'ylim',[0 yyax2],'ytick',yystep:yystep:yyax2,'fontsize',12);
    datetick('x','m','keeplimits');
    ylabel({'fraction of biomass'},'fontsize',14);  hold on
 
set(gcf,'color','w');
if onlyClassifier==1
    print(gcf,'-dtiff','-r200',[filepath 'Figs/Classifier_vs_FXrai' num2str(class2do_string) '.tif']);
else
    print(gcf,'-dtiff','-r200',[filepath 'Figs/Classifier_vs_microscopy_FXrai' num2str(class2do_string) '.tif']);
end
hold off


%% chi squared test 
% chi2 is the value of the chi-squared test statistic for a Pearson's chi-squared test of independence. 
% p is an approximate p-value based on the chi-squared distribution
% at the 5% significance level, crosstab fails to reject the null hypothesis that table is independent in each dimension.
% therefore the data are the same

% IFCB vs FISH
[~,ia,ib] = intersect(fish.dn,mdate); x1=fish.cells(ia); x2=y_mat(ib); [~,chi2stat,pval] = crosstab(x1,x2)

% IFCB vs Microscopy
[~,ia,ib] = intersect(mcrpy.dn,mdate); x1=mcrpy.cells(ia); x2=y_mat(ib); [~,chi2stat,pval] = crosstab(x1,x2)

% IFCB vs RAI
[~,ia,ib] = intersect(DN,mdate); x1=rai(ia); x2=y_mat(ib); [~,chi2stat,pval] = crosstab(x1,x2)

% fx IFCB vs fx RAI
[~,ia,ib] = intersect(DN,mdate); x1=fx(ia); x2=iraifx(ib); [~,chi2stat,pval] = crosstab(x1,x2)

% car IFCB vs chl RAI
[~,ia,ib] = intersect(DN,mdate); x1=rai(ia); x2=iraicar(ib); [~,chi2stat,pval] = crosstab(x1,x2)
