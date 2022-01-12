%% plot FvFm vs Phaeocystin
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

clear;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/physical_param'],'S','Si'); % parameters
load([filepath 'Data/Phytoflash_summary'],'P'); % parameters

%%%% FORMAT DATA
[~,ia,ib]=intersect([P.dn],[S.dn]); P=P(ia); S=S(ib); % add FvFm data to S
for i=1:length(S)               
    S(i).FvFm=NaN*ones(size(S(i).st));            
    [~,ia,ib]=intersect(P(i).st,S(i).st);  
    S(i).FvFm(ib)=P(i).FvFm(ia); 
end

for i=1:length(S)
    S(i).DN=S(i).dn*ones(size(S(i).st));
end

dn=[S.DN]; dn=dn(:);
d18=[S.d18]; d18=d18(:);
R=[S.chlpha]; R=1-R(:); %fraction of phaeocystin 
FvFm=[S.FvFm]; FvFm=FvFm(:); 

idx=isnan(R); R(idx)=[]; FvFm(idx)=[]; dn(idx)=[]; d18(idx)=[]; %remove nans
idx=isnan(FvFm); R(idx)=[]; FvFm(idx)=[]; dn(idx)=[]; d18(idx)=[]; 

clearvars i j ia ib P idx M Y DN OUT X2 Si thresh;

% MATHS
r=linspace(.01,1,100)'; %R theoretical

% two-term exponential model to fit the dataset
F=fit(R,FvFm,'exp2'); 
Fit1=F.a*exp(F.b*r)+F.c*exp(F.d*r); 

% ideal fit (no relationship between PHA and FvFm)
avF=mean(FvFm(R<.4));
Fit2=avF*ones(size(r));

% determine correction factor
corr=Fit2-Fit1;

% adjust dataset
R=round(R,2); r=round(r,2); %round to two decimal places
FvFmA=NaN*R;
for i=1:length(R)
    C=corr(R(i)==r);
    FvFmA(i)=FvFm(i)+C;
end

clearvars i id F C avF

save([filepath 'Data/correction_FvFm_PHA'],'corr','r');
    
%% plot histograms of FvFm before and after data correction
yrlabel='2013-2019';

%season=1:12; label='';
%season=4:12; label='Apr-Dec';
season=1:3; label='Jan-Mar';

[~,M]=datevec(dn); id=ismember(M,season); 
FVFM=FvFm(id); FVFMA=FvFmA(id);

edges=(0:.1:.8)'; 

% original FvFm dataset
Fbin=NaN*edges;
[Y,~]=discretize(FVFM,edges,edges(2:end));
for i=1:length(edges)
    id=find(Y==edges(i));
    Fbin(i)=length(id);
end

% adjusted FvFm dataset
FAbin=NaN*edges;
[YA,~]=discretize(FVFMA,edges,edges(2:end));
for i=1:length(edges)
    id=find(YA==edges(i));
    FAbin(i)=length(id);
end

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
bar(edges,[Fbin FAbin],'edgealpha',.1,'BarWidth',1)
    set(gca,'fontsize',12,'tickdir','out',...
        'xlim',[.1 .85],'xtick',.1:.1:.8); box on
    xlabel('FvFm','fontsize',14);
    ylabel('frequency','fontsize',14);    
    title([label ' ' yrlabel],'fontsize',14);
    legend('raw','corrected','Location','NW');
    legend boxoff; %lh.FontSize = 10; hp=get(lh,'pos');    

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Histogram_adjustedFvFm_PHA' label '.tif']);
hold off

%% plot correction factor
figure('Units','inches','Position',[1 1 3.8 3.8],'PaperPositionMode','auto');
plot(r,corr,'k-','linewidth',2); hold on 
set(gca,'fontsize',12,'tickdir','out','xlim',[0 .8],'xtick',0:.2:.8,...
    'ylim',[0 .7],'ytick',0:.1:.7); box on
xlabel('Phaeopigment to Chlorophyll ratio','fontsize',14);
ylabel('Correction factor','fontsize',14);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/CorrectionFactor_PHA_FvFm.tif']);
hold off

%% plot phaeocystins vs Fv/Fm
figure('Units','inches','Position',[1 1 3.8 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.09 0.02], [.17 0.03]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[0 .75]; yax=[0 .75];

subplot(2,1,1);
h=plot(R,FvFm,'ko',r,Fit1,'b-','linewidth',1,'markersize',3); 
    set(gca,'fontsize',12,'tickdir','out','ylim',[yax(1) yax(2)],...
        'ytick',yax(1):.1:yax(2),'xlim',[xax(1) xax(2)],...
        'xtick',xax(1):.1:xax(2),'xticklabel',{}); box on
    ylabel('Fv/Fm','fontsize',14);
   % legend(h(2),'fit'); legend boxoff; hold on
   % s = sprintf('y = %.1fx^4 + %.1fx^3 + %.1fx^2 + %.1f x + %.1f',p(1),p(2),p(3),p(4),p(5));
   % title(s,'fontsize',11,'fontweight','normal')

subplot(2,1,2);
h=plot(R,FvFmA,'ko',r,Fit2,'r-','linewidth',1,'markersize',3); 
    set(gca,'fontsize',12,'tickdir','out','ylim',[yax(1) yax(2)],...
        'ytick',yax(1):.1:yax(2),'xlim',[xax(1) xax(2)],'xtick',...
        xax(1):.1:xax(2)); box on
 %   legend(h(2),'fit'); legend boxoff; hold on
    ylabel('Fv/Fm corrected','fontsize',14);
    xlabel('Phaeopigment to Chlorophyll ratio','fontsize',14); hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/PHA_FvFm_corrected.tif']);
hold off

%% seasonal phaophytin/total pigments
figure('Units','inches','Position',[1 1 6 3.8],'PaperPositionMode','auto');

dt=datetime(dn,'ConvertFrom','datenum');
dt.Year=2019;

plot(dt,R,'ko','markersize',3,'linewidth',1);    
set(gca,'fontsize',12,'tickdir','out','ylim',[0 .72],'ytick',0:.1:.7); box on
ylabel('Phaeopigment to Chlorophyll ratio','fontsize',14); hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/PHA_seasonal.tif']);
hold off

%% put the data back in the spreadsheet
%or apply correction to data in the spreadsheet

for i=1:length(S)
    S(i).phachl=inpaintn(1-S(i).chlpha); %fill in phaeopigment gaps
    S(i).phachl=round(S(i).phachl,2);  
    S(i).FvFmA=S(i).FvFm;
end

for i=1:length(S)
    for j=1:length(S(i).phachl)
        R=S(i).phachl(j);
        if ~isnan(R)
            C=corr(R==r);
            S(i).FvFmA(j)=S(i).FvFm(j)+C;
        else %if it's a nan, skip it
        end
    end
end

clearvars i j C R

%% waterfall plot of before and after FvFm
load([filepath 'Data/NetDeltaFlow'],'DN','X2','OUT');
OUT=OUT*60*60*24; %convert from m^3/s to m^3/day

%adjust='adjust';  F=[S.FvFmA]'; label="FvFm adjusted";
adjust='raw'; F=[S.FvFm]'; label="FvFm raw";

str="FvFm"; cax=[.1 .7];  D = [S.dn]'; Y=[S(1).d18]';

for i=1:size(F,2) %organize data into a week x location matrix   
    [ ~, y_ydmat, yearlist, ~ ] = timeseries2ydmat( D, F(:,i));
    [  y_wkmat, mdate_wkmat, yd_wk ] = ydmat2interval( y_ydmat, yearlist, 30 );
    C(i,:) = reshape(y_wkmat,[length(y_wkmat)*size(y_wkmat,2),1]);
    X = reshape(mdate_wkmat,[length(mdate_wkmat)*size(mdate_wkmat,2),1]);
end

figure('Units','inches','Position',[1 1 6. 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.2 0.04], [0.13 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax=[datenum('2013-01-01') datenum('2019-12-31')];     

subplot(5,1,1);
    plot(DN,smooth(OUT,4),'-k','linewidth',1.5);
    datetick('x', 'yyyy', 'keeplimits')
    set(gca,'tickdir','out','ylim',[0 3.3e10],'ytick',1e10:1e10:3e10,...
        'xlim',[xax(1) xax(2)],'fontsize', 14,'xticklabels',{},'ycolor','k');   
    ylabel('m^3 day^{-1}', 'fontsize', 14, 'fontname', 'arial')
    hold on
    
subplot(5,1,[2 3 4 5]);
    pcolor(X,Y,C);        
    caxis(cax); shading flat; 
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],...
        'ylim',[0 87],'ytick',0:20:80,'fontsize', 14,'tickdir','out');
    datetick('x', 'yyyy', 'keeplimits')  
    ylabel('Distance (km) from Angel Island)', 'fontsize', 14)    
    hold on

    color=(brewermap([],'RdYlGn')); colormap(color);    
      
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 14;               
    hp=get(h,'pos'); 
    hp(1)=hp(1); hp(2)=.3*hp(2); hp(3)=.54*hp(3); hp(4)=.8*hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on

    h.Label.Position = [hp(1)+.7 hp(2)+1]; 
    h.Ticks=linspace(cax(1),.7,7);                        
        
    h.Label.FontSize = 14;           
    hold on   
    plot([datenum('01-Jan-2014') datenum('01-Jan-2014')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2014') datenum('01-Jan-2014')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2015') datenum('01-Jan-2015')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2016') datenum('01-Jan-2016')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2017') datenum('01-Jan-2017')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2018') datenum('01-Jan-2018')],[0 100],'k-','linewidth',1);    
    plot([datenum('01-Jan-2019') datenum('01-Jan-2019')],[0 100],'k-','linewidth',1);    

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/' adjust '' num2str(str) '_RT_space_time_2013-2019.tif'])
hold off