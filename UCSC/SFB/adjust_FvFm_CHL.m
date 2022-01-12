%% plot Fm vs extracted chlorophyll
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

clear;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/physical_param'],'S'); % parameters
load([filepath 'Data/Phytoflash_summary'],'P'); % parameters
    
[~,ia,ib]=intersect([P.dn],[S.dn]); P=P(ia); S=S(ib); %find intersecting dates

for i=1:length(S)
    S(i).Fo=NaN*ones(size(S(i).st));        
    S(i).Fm=NaN*ones(size(S(i).st));        
    S(i).FvFm=NaN*ones(size(S(i).st));            
    
    [~,ia,ib]=intersect(P(i).st,S(i).st); 
    S(i).Fo(ib)=P(i).Fo(ia); 
    S(i).Fm(ib)=P(i).Fm(ia); 
    S(i).FvFm(ib)=P(i).FvFm(ia); 
end

%split dataset into 2013-2015 and 2016-2019
ia=find([S.dn]>datenum('01-Jan-2016'),1); S1=S(1:ia-1); S2=S(ia:end);

FvFm1=[S1.FvFm]; FvFm1=FvFm1(:); FvFm2=[S2.FvFm]; FvFm2=FvFm2(:);
Fo1=[S1.Fo]; Fo1=Fo1(:); Fo2=[S2.Fo]; Fo2=Fo2(:);
Fm1=[S1.Fm]; Fm1=Fm1(:); Fm2=[S2.Fm]; Fm2=Fm2(:);
chl1=[S1.chl]; chl1=chl1(:); chl2=[S2.chl]; chl2=chl2(:);

id=isnan(FvFm1); FvFm1(id)=[]; Fo1(id)=[]; Fm1(id)=[]; chl1(id)=[]; 
id=isnan(chl1); FvFm1(id)=[]; Fo1(id)=[]; Fm1(id)=[]; chl1(id)=[]; 
id=isnan(FvFm2); FvFm2(id)=[]; Fo2(id)=[]; Fm2(id)=[]; chl2(id)=[]; 
id=isnan(chl2); FvFm2(id)=[]; Fo2(id)=[]; Fm2(id)=[]; chl2(id)=[]; 

id=find(Fo1<50); FvFm1(id)=[]; Fo1(id)=[]; Fm1(id)=[]; chl1(id)=[]; %remove weirdly low points

clearvars Pi Si ia ib i id P S;

%% plot adjusted scores
figure('Units','inches','Position',[1 1 9.5 10],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.03], [0.06 0.04], [0.06 0.01]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%2013-2015
Lfit = fitlm(Fo1,chl1,'RobustOpts','on');
[~,outliers] = maxk((Lfit.Residuals.Raw),4);
Fo1(outliers)=[]; Fm1(outliers)=[]; chl1(outliers)=[];

subplot(3,3,1); %Fo
    Lfit = fitlm(Fo1,chl1,'RobustOpts','on');
    bO = round(Lfit.Coefficients.Estimate(1),2,'significant');
    mO = round(Lfit.Coefficients.Estimate(2),2,'significant');    
    err = round(immse(Fo1,chl1),2,'significant');
    xfit = linspace(0,3000,100); yfit = mO*xfit+bO; 
scatter(Fo1,chl1,8,'b','linewidth',2,'marker','o'); hold on 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','ylim',[0 9],'ytick',0:3:9,...
         'xlim',[0 3000],'xticklabel',{}); box on;
    legend(L,['slope=' num2str(mO) '; Int=' num2str(bO) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff
    ylabel('Extracted Chl (\mug L^{-1})','fontsize',14);
    title('2013-2015');

subplot(3,3,2); %Fm
    Lfit = fitlm(Fm1,chl1,'RobustOpts','on');
    bM = round(Lfit.Coefficients.Estimate(1),2,'significant');
    mM = round(Lfit.Coefficients.Estimate(2),2,'significant');    
    err = round(immse(Fm1,chl1),2,'significant');
    xfit = linspace(0,4000,100); yfit = mM*xfit+bM; 
scatter(Fm1,chl1,8,'b','linewidth',2,'marker','o'); hold on 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','ylim',[0 9],'ytick',0:3:9,...
         'xlim',[0 4000],'xticklabel',{},'yticklabel',{}); box on;
    legend(L,['slope=' num2str(mM) '; Int=' num2str(bM) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff     
     title('2013-2015');

subplot(3,3,3); %FvFm
scatter(((Fm1-Fo1)./Fm1),chl1,8,'b','linewidth',2,'marker','o'); hold on 
    set(gca,'fontsize',12,'tickdir','out','ylim',[0 9],'ytick',0:3:9,...
         'xlim',[0.1 0.7],'xticklabel',{},'yticklabel',{}); box on;
     title('2013-2015');

%2016-2019
Lfit = fitlm(Fo2,chl2,'RobustOpts','on');
[~,outliers] = maxk((Lfit.Residuals.Raw),4);
Fo2(outliers)=[]; Fm2(outliers)=[]; chl2(outliers)=[];
    
subplot(3,3,4);  %Fo
    Lfit = fitlm(Fo2,chl2,'RobustOpts','on');
    b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    m = round(Lfit.Coefficients.Estimate(2),2,'significant'); 
    err = round(immse(Fo2,chl2),2,'significant');    
    xfit = linspace(0,3000,100); yfit = m*xfit+b; 
scatter(Fo2,chl2,8,'r','linewidth',2,'marker','o'); hold on 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','ylim',[0 9],'ytick',0:3:9,...
        'xlim',[0 3000],'xticklabel',{}); box on;
    legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff
    ylabel('Extracted Chl (\mug L^{-1})','fontsize',14);
    title('2016-2019');

subplot(3,3,5); %Fm
    Lfit = fitlm(Fm2,chl2,'RobustOpts','on');
    b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    m = round(Lfit.Coefficients.Estimate(2),2,'significant'); 
    err = round(immse(Fm2,chl2),2,'significant');    
    xfit = linspace(0,4000,100); yfit = m*xfit+b; 
scatter(Fm2,chl2,8,'r','linewidth',2,'marker','o'); hold on 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','ylim',[0 9],'ytick',0:3:9,...
         'xlim',[0 4000],'yticklabel',{},'xticklabel',{}); box on;
    legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff     
     title('2016-2019');
     
subplot(3,3,6)
scatter((Fm2-Fo2)./Fm2,chl2,8,'r','linewidth',2,'marker','o'); hold on 
    set(gca,'fontsize',12,'tickdir','out','ylim',[0 9],'ytick',0:3:9,...
        'xlim',[0.1 0.7],'yticklabel',{},'xticklabel',{}); box on;
    title('2016-2019');
    
% 2016-2019 (adjusted)
subplot(3,3,7);  %Fo 
    y=chl2; Fofit=NaN*chl2; %preallocate
    for i=1:length(y)
        Fofit(i)=(y(i)-bO)./mO;
    end

    Lfit = fitlm(Fo2,Fofit,'RobustOpts','on');
    FoAdjust.b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    FoAdjust.m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
	FoA=(Fo2*FoAdjust.m)+FoAdjust.b;

scatter(FoA,chl2,8,'k','linewidth',2,'marker','o'); hold on 
    Lfit = fitlm(FoA,chl2,'RobustOpts','on');
    b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
    err = round(immse(Fm2,chl2),2,'significant');        
    xfit = linspace(0,3000,100); yfit = m*xfit+b; 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','ylim',[0 9],'ytick',0:3:9,...
        'xlim',[0 3000]); box on;
    legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff
    xlabel('Fo','fontsize',14,'fontweight','bold');
    ylabel('Extracted Chl (\mug L^{-1})','fontsize',14);
    title('2016-2019^* adjusted');

subplot(3,3,8); %Fm adjusted
    Fmfit=NaN*chl2; %preallocate
    for i=1:length(chl2)
        Fmfit(i)=(chl2(i)-bM)./mM;
    end

    Lfit = fitlm(Fm2,Fmfit,'RobustOpts','on');
    FmAdjust.b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    FmAdjust.m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
    FmA=(Fm2*FmAdjust.m)+FmAdjust.b;

scatter(Fm2,chl2,8,'k','linewidth',2,'marker','o'); hold on     
    Lfit = fitlm(FmA,chl2,'RobustOpts','on');
    b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
    err = round(immse(Fm2,chl2),2,'significant');        
    xfit = linspace(0,4000,100); yfit = m*xfit+b; 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','ylim',[0 9],'ytick',0:3:9,...
         'xlim',[0 4000],'yticklabel',{}); box on;
    legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff     
    xlabel('Fm','fontsize',14,'fontweight','bold');     
     title('2016-2019^* adjusted');
   
subplot(3,3,9)
scatter((FmA-FoA)./FmA,chl2,8,'k','linewidth',2,'marker','o'); hold on 
    set(gca,'fontsize',12,'tickdir','out','ylim',[0 9],'ytick',0:3:9,...
        'xlim',[0.1 0.7],'yticklabel',{}); box on;
    xlabel('FvFm','fontsize',14,'fontweight','bold');
    title('2016-2019^* adjusted');    
    
save([filepath 'Data/Adjustment_FoFm'],'FoAdjust','FmAdjust');
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/FvFm_vs_ChlExtracted_adjusted.png']);
hold off

%% plot correction factors

figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
plot(Fo2,Fofit,'ko'); hold on
xfit = linspace(0,3000,100); yfit = FoAdjust.m*xfit+FoAdjust.b;     
xlabel('Fo','fontsize',14,'fontweight','bold');
ylabel('Fo fitted to 2013-2015 parameters','fontsize',14,'fontweight','bold');
L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
legend(L,['slope=' num2str(FoAdjust.m) '; Int=' num2str(FoAdjust.b) ''],...
    'Location','NorthWest'); legend boxoff; 
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/Fo_fitted.png']);
hold off

figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
plot(Fm2,Fmfit,'ko'); hold on
xfit = linspace(0,4000,100); yfit = FmAdjust.m*xfit+FmAdjust.b;     
xlabel('Fm','fontsize',14,'fontweight','bold');
ylabel('Fm fitted to 2013-2015 parameters','fontsize',14,'fontweight','bold');
L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
legend(L,['slope=' num2str(FmAdjust.m) '; Int=' num2str(FmAdjust.b) ''],...
    'Location','NorthWest'); legend boxoff; 
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/Fm_fitted.png']);
hold off
