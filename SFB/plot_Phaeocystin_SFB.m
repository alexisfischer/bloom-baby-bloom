clear;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/physical_param'],'Si'); % parameters
load([filepath 'Data/Phytoflash_summary'],'Pi'); % parameters
load([filepath 'Data/NetDeltaFlow'],'DN','OUT');

% back-of-the-envelope Suisun Bay daily residence time calculation
OUT=OUT*60*60*24; %convert from m^3/s to m^3/day
RT=.001*6.54e11./OUT; % days

% eliminate unnessary variables
Si = rmfield(Si, {'d19','temp','obs','spm','o2','ni','nina','phos'});

%eliminate data below st 18
for i=1:length(Si)
   idx=find(Si(i).d18 >=0);
   Si(i).st=Si(i).st(idx:end);
   Si(i).lat=Si(i).lat(idx:end);
   Si(i).lon=Si(i).lon(idx:end);
   Si(i).d18=Si(i).d18(idx:end);
   Si(i).chl=Si(i).chl(idx:end);
   Si(i).chlpha=Si(i).chlpha(idx:end);
   Si(i).light=Si(i).light(idx:end);
   Si(i).sal=Si(i).sal(idx:end);
   Si(i).amm=Si(i).amm(idx:end);
end

[~,ipx,isx]=intersect([Pi.dn],[Si.dn]); Pi=Pi(ipx); Si=Si(isx);

%eliminate non-matching dates
for i=1:length(Si)
    Si(i).FvFm = interp1(Pi(i).d18,Pi(i).FvFm,Si(i).d18,'linear');
end

%assign 1 if SB and 0 if not
ST=Si(1).st; sb=0*ST;
for i=1:length(ST)
    if ST(i)==4 || ST(i)==5 || ST(i)==6 || ST(i)==7 %SB st 4-7
       sb(i)=1;
    else
    end
end

for i=1:length(Si)
   Si(i).sb=sb;
end

%%take average of SB FvFm scores
for i=1:length(Si)
    idx=Si(i).sb==1; %find all the SB scores
    Si(i).FvFm_SB=nanmean(Si(i).FvFm(idx));
end

clearvars ipx isx idx i sb ST

%%

%pre-drought 2013-2015
idx=[Si.dn]>=datenum('01-Jan-2017');

chl=[Si(idx).chl]; chl=(chl(:)); 
FvFm=[Si(idx).FvFm]; FvFm=FvFm(:); 
sal=[Si(idx).sal]; sal=sal(:); 
light=[Si(idx).light]; light=light(:);

%
figure('Units','inches','Position',[1 1 9 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.16 0.04], [0.09 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(1,2,1)
scatter(sal,chl,8,'b','linewidth',2); hold on 
set(gca,'fontsize',12,'tickdir','out',...
     'xlim',[0 33],'xtick',0:5:35,'ylim',[0 15]); box on
xlabel('Salinity (psu)','fontsize',14);
ylabel('Chl','fontsize',14);

subplot(1,2,2)
scatter(light,chl,8,'b','linewidth',2); hold on 
set(gca,'fontsize',12,'tickdir','out','yticklabel',{},...
     'xlim',[0 9],'xtick',0:2:8,'ylim',[0 15]); box on
xlabel('Light Attenuation Coefficient (m^{-1})','fontsize',14);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/chl_Sal_Light_2017-2019.tif']);
hold off


%%
subplot(1,2,1)
scatter(sal,FvFm,8,'r','linewidth',2); hold on 
set(gca,'fontsize',12,'tickdir','out',...
     'xlim',[0 33],'xtick',0:5:35,'ylim',[.1 .7],'ytick',.1:.1:1); box on
xlabel('Salinity (psu)','fontsize',14);
ylabel('FvFm','fontsize',14);

subplot(1,2,2)
scatter(light,FvFm,8,'r','linewidth',2); hold on 
set(gca,'fontsize',12,'tickdir','out','yticklabel',{},...
     'xlim',[0 9],'xtick',0:2:8,'ylim',[.1 .7],'ytick',.1:.1:1); box on
xlabel('Light Attenuation Coefficient (m^{-1})','fontsize',14);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/FvFm_Sal_Light_2013-2016.tif']);
hold off

%%  Fv/Fm and Delta Outflow
%[~,ipx,isx]=intersect(DN,[Si.dn]); RT=RT(ipx); OUT=OUT(ipx); Si=Si(isx); 
x=RT; y=[Si.FvFm_SB]';
[rho,pval] = corr(x,y,'Type','Pearson','Rows','complete')

%%  correlation testing
% x=[Si.FvFm]; y=log([Si.chl]); x=x(:);  y=y(:); % Fv/Fm and chlorophyll?  
% x=[Si.sal]; x=x(:); y=[Si.FvFm]; y=y(:); % Fv/Fm and salinity?  
% x=[Si.light]; x=x(:); y=[Si.FvFm]; y=y(:); % Fv/Fm and light?  
% x=[Si.sb]; x=x(:); y=[Si.FvFm]; y=y(:); % Fv/Fm and Suisun Bay? no 
 x=[Si.amm]; x=x(:); y=[Si.FvFm]; y=y(:); % Fv/Fm and ammonium? weak
% x=[Si.chlpha]; x=x(:); y=[Si.FvFm]; y=y(:); % Pha and Fv/Fm? weak 

idx=isnan(x); x(idx)=[]; y(idx)=[];
idx=isnan(y); x(idx)=[]; y(idx)=[];
xx=normalize(x); yy=normalize(y); 
[rho,pval] = corr(xx,yy,'Type','Pearson')

%%
Lfit = fitlm(x,y,'RobustOpts','on');
b = round(Lfit.Coefficients.Estimate(1),2,'significant');
m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
Rsq = round(Lfit.Rsquared.Ordinary,2,'significant')
xfit = linspace(min(x),max(x),100); 
yfit = m*xfit+b; 

figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
scatter(x,y,8,'k','linewidth',2); hold on 
L=plot(xfit,yfit,'-r','linewidth',1.5);
legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; r^2=' num2str(Rsq) ''],...
    'Location','NorthOutside'); legend boxoff
 set(gca,'fontsize',12,'tickdir','out',...
     'ylim',[.07 .7],'ytick',.1:.2:.7,'xlim',[.2 1],'xtick',.2:.2:1); box on
xlabel('Chl:(Chl+PHA)','fontsize',14);
ylabel('FvFm','fontsize',14);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/FvFm_Phaeocystin.tif']);
hold off

%%
label="Chl:(Chl+PHA)"; str="ChlPha"; cax=[.3 1]; F=[Si.chlpha]';

id1=find([Si.dn]>=datenum('13-Aug-2013'),1);
id2=find([Si.dn]>=datenum('16-Oct-2013'),1);
id3=find([Si.dn]>=datenum('28-Jan-2014'),1);
id4=find([Si.dn]>=datenum('30-Apr-2014'),1);

figure('Units','inches','Position',[1 1 6.5 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.16 0.04], [0.13 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax=[datenum('2013-08-01') datenum('2014-05-31')];     

    pcolor(X,Y,C);        
    caxis(cax); shading flat; 
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],...
        'ylim',[0 max(Y)],'ytick',0:20:80,'fontsize', 14,'tickdir','out');
    datetick('x', 'yyyy', 'keeplimits')  
    ylabel('Distance (km) from Angel Island)', 'fontsize', 14)    
    hold on
    
    color=(brewermap([],'RdYlGn'));            
    colormap(color);    
      
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 14;               
    hp=get(h,'pos'); 
    hp(1)=hp(1); hp(2)=.2*hp(2); hp(3)=.54*hp(3); hp(4)=.8*hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on

        h.Label.Position = [hp(1)+1.1 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),8);          
        
    h.Label.FontSize = 14;           
    hold on   
    plot([datenum('01-Jan-2014') datenum('01-Jan-2014')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2014') datenum('01-Jan-2014')],[0 100],'k-','linewidth',1);
   
    plot(DN,(X2-6.43738),'k-','linewidth',2); %adjust X2 so distance from Angel island, not GG

%% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/' num2str(str) '_RT_space_time_2013-2019.tif'])
hold off