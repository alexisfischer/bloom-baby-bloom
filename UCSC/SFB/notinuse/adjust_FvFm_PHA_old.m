%% plot FvFm vs Phaeocystin
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

clear;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/physical_param'],'S'); % parameters
load([filepath 'Data/Phytoflash_summary'],'P'); % parameters

% FORMAT DATA
[~,ia,ib]=intersect([P.dn],[S.dn]); P=P(ia); S=S(ib); % add FvFm data to S
for i=1:length(S)    
    S(i).Fo=NaN*ones(size(S(i).st));            
    S(i).Fm=NaN*ones(size(S(i).st));    
    S(i).FvFm=NaN*ones(size(S(i).st));            
    [~,ia,ib]=intersect(P(i).st,S(i).st); 
    S(i).Fo(ib)=P(i).Fo(ia); 
    S(i).Fm(ib)=P(i).Fm(ia);    
    S(i).FvFm(ib)=P(i).FvFm(ia); 
end

% SELECT DATA  OF INTEREST
[Y,~]=datevec([S.dn]); S=S(ismember(Y,2013:2019));

%%%% GOOD Non-affected dry season data
Glabel='Apr-Dec';
[~,M]=datevec([S.dn]); SG=S(ismember(M,4:12));    
phaG=[SG.chlpha]; phaG=1-phaG(:);     
FoG=[SG.Fo]; FoG=FoG(:); 
FmG=[SG.Fm]; FmG=FmG(:); 

%%%% BAD Affected rainy season data
Blabel='Jan-Mar';
[~,M]=datevec([S.dn]); SB=S(ismember(M,1:3));    
phaB=[SB.chlpha]; phaB=1-phaB(:);     
FoB=[SB.Fo]; FoB=FoB(:); 
FmB=[SB.Fm]; FmB=FmB(:); 

id=isnan(FoG); FoG(id)=[]; FmG(id)=[]; phaG(id)=[]; %reFo.mve nans
id=isnan(phaG); FoG(id)=[]; FmG(id)=[]; phaG(id)=[]; 
id=isnan(FoB); FoB(id)=[]; FmB(id)=[]; phaB(id)=[]; 
id=isnan(phaB); FoB(id)=[]; FmB(id)=[]; phaB(id)=[]; 

clearvars i j ia ib P idx S M Y DN OUT X2 id SB SG;

%% plot adjusted scores
figure('Units','inches','Position',[1 1 9.5 10],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.03], [0.06 0.04], [0.08 0.01]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

% DRY SEASON (GOOD)
Lfit = fitlm(phaG,FoG,'RobustOpts','on');
[~,outliers] = maxk((Lfit.Residuals.Raw),4);
FoG(outliers)=[]; FmG(outliers)=[]; phaG(outliers)=[];

subplot(3,3,1); %Fo
    Lfit = fitlm(phaG,FoG,'RobustOpts','on');
    Fo.b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    Fo.m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
    err = round(immse(phaG,FoG),2,'significant');
    xfit = linspace(0,1,100); yfit = Fo.m*xfit+Fo.b; 
scatter(phaG,FoG,8,'b','linewidth',2,'marker','o'); hold on 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','xlim',[0 .8],...
        'xtick',0:.2:.8,'ylim',[500 2500],'xticklabel',{}); box on;
    legend(L,['slope=' num2str(Fo.m) '; Int=' num2str(Fo.b) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff
    ylabel('Fo','fontsize',14); title(Glabel);

subplot(3,3,4); %Fm
    Lfit = fitlm(phaG,FmG,'RobustOpts','on');
    Fm.b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    Fm.m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
    err = round(immse(phaG,FmG),2,'significant');
    xfit = linspace(0,1,100); yfit = Fm.m*xfit+Fm.b; 
scatter(phaG,FmG,8,'b','linewidth',2,'marker','o'); hold on 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','xlim',[0 .8],...
        'xtick',0:.2:.8,'ylim',[500 5000],'xticklabel',{}); box on;
    legend(L,['slope=' num2str(Fm.m) '; Int=' num2str(Fm.b) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff
    ylabel('Fm','fontsize',14); 

subplot(3,3,7); %FvFm
scatter(phaG,((FmG-FoG)./FmG),8,'b','linewidth',2,'marker','o'); hold on 
    set(gca,'fontsize',12,'tickdir','out','ylim',[.1 .75],...
    'ytick',.1:.2:.7,'xlim',[0 .8],...
        'xtick',0:.2:.8);  box on;
    ylabel('Fv/Fm','fontsize',14); 
    xlabel('fraction Phaeophytin','fontsize',14);

% RAINY SEASON (BAD)
subplot(3,3,2); %Fo
    Lfit = fitlm(phaB,FoB,'RobustOpts','on');
    b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
    err = round(immse(phaB,FoB),2,'significant');
    xfit = linspace(0,1,100); yfit = m*xfit+b; 
scatter(phaB,FoB,8,'r','linewidth',2,'marker','o'); hold on 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','xlim',[0 .8],...
        'xtick',0:.2:.8,'ylim',[500 2500],'yticklabel',{},'xticklabel',{}); box on;
    legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff
    title(Blabel);
    
subplot(3,3,5); %Fm
    Lfit = fitlm(phaB,FmB,'RobustOpts','on');
    b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
    err = round(immse(phaB,FmB),2,'significant');
    xfit = linspace(0,1,100); yfit = m*xfit+b; 
scatter(phaB,FmB,8,'r','linewidth',2,'marker','o'); hold on 
    L=plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','xlim',[0 .8],...
        'xtick',0:.2:.8,'ylim',[500 5000],'yticklabel',{},'xticklabel',{}); box on;
    legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; MSE=' num2str(err) ''],...
        'Location','NorthWest'); legend boxoff

subplot(3,3,8); %FvFm
scatter(phaB,((FmB-FoB)./FmB),8,'r','linewidth',2,'marker','o'); hold on 
    set(gca,'fontsize',12,'tickdir','out','ylim',[.1 .75],...
    'ytick',.1:.2:.7,'xlim',[0 .8],...
        'xtick',0:.2:.8,'yticklabel',{}); box on; hold on
    xlabel('fraction Phaeophytin','fontsize',14);
    
% RAINY SEASON (ADJUSTED)
subplot(3,3,3);  %Fo 
    Fofit=NaN*phaB; %preallocate
    for i=1:length(phaB)
        Fofit(i)=Fo.m*phaB(i)+Fo.b;
    end

    Lfit = fitlm(FoB,Fofit,'RobustOpts','on');
    FoAdjust.b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    FoAdjust.m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
	FoA=(FoB*FoAdjust.m)+FoAdjust.b;

scatter(phaB,FoA,8,'m','linewidth',2,'marker','o'); hold on 
    set(gca,'fontsize',12,'tickdir','out','xlim',[0 .8],...
        'xtick',0:.2:.8,'ylim',[500 2500],'yticklabel',{},'xticklabel',{});  box on;
    xfit = linspace(0,1,100); yfit = Fo.m*xfit+Fo.b; 
    plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    title([Blabel ' adjusted']); hold on
 
subplot(3,3,6);  %Fm
    Fmfit=NaN*phaB; %preallocate
    for i=1:length(phaB)
        Fmfit(i)=Fm.m*phaB(i)+Fm.b;
    end
    Lfit = fitlm(FmB,Fmfit,'RobustOpts','on');
    FmAdjust.b = round(Lfit.Coefficients.Estimate(1),2,'significant');
    FmAdjust.m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
	FmA=(FmB*FmAdjust.m)+FmAdjust.b;
    
scatter(phaB,FmA,8,'m','linewidth',2,'marker','o'); hold on 
    Lfit = fitlm(phaB,FmA,'RobustOpts','on');
    xfit = linspace(0,1,100); yfit = Fm.m*xfit+Fm.b; 
    plot(xfit,yfit,'-','Color','k','linewidth',1.5);
    set(gca,'fontsize',12,'tickdir','out','xlim',[0 .8],...
        'xtick',0:.2:.8,'ylim',[500 5000],'yticklabel',{},'xticklabel',{});  box on;
    
subplot(3,3,9)
scatter(phaB,((FmA-FoA)./FmA),8,'k','linewidth',2,'marker','o'); hold on 
    set(gca,'fontsize',12,'tickdir','out','ylim',[.1 .75],...
    'ytick',.1:.2:.7,'xlim',[0 .8],...
        'xtick',0:.2:.8,'yticklabel',{}); box on;
    xlabel('fraction Phaeophytin','fontsize',14);

%% analysis similar to Fuchs et al. 2002

%FvFm=FvFm_c*(1-R)./(0.9*(1-R)+.1);
FvFm_c=(FvFm.*(0.9*(1-R)+.1))./(1-R); %chlorophyll FvFm

% plot correction factor
[corr,id]=sort(FvFm_c./FvFm); RR=R(id);

figure('Units','inches','Position',[1 1 3.8 3.8],'PaperPositionMode','auto');

plot(RR,corr,'k-','linewidth',2); hold on 
set(gca,'fontsize',12,'tickdir','out','xlim',[0 .8],'xtick',0:.2:.8); box on
xlabel('Phaeopigment to Chlorophyll ratio','fontsize',14); ylabel('Correction factor','fontsize',14);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/CorrectionFactor_Pha_FvFm.tif']);
hold off