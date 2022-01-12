
%% anova can salinity, FvFm, and light limitation explain chlorophyll
tbl=table(chl,FvFm,sal,light,amm,spm,'VariableNames',{'Chl','FvFm','Sal','Light','Amm','SPM'});
lm = fitlm(tbl,'Chl~FvFm+Sal+Light+Amm+SPM')
%anova(lm,'summary')


%%
figure('Units','inches','Position',[1 1 9 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.16 0.04], [0.09 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(1,2,1)
scatter(sal,chl,8,'b','linewidth',2); hold on 
set(gca,'fontsize',12,'tickdir','out',...
     'xlim',[0 33],'xtick',0:5:35,'ylim',[0 15]); box on
xlabel('Salinity (psu)','fontsize',14);
ylabel('Extracted Chl (\mug L^{-1})','fontsize',14);

subplot(1,2,2)
scatter(light,chl,8,'b','linewidth',2); hold on 
set(gca,'fontsize',12,'tickdir','out','yticklabel',{},...
     'xlim',[0 9],'xtick',0:2:8,'ylim',[0 15]); box on
xlabel('Light Attenuation Coefficient (m^{-1})','fontsize',14);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/chl_Sal_Light_' yrrange '.tif']);
hold off

%%
figure('Units','inches','Position',[1 1 9 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.16 0.04], [0.09 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

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
print(gcf,'-dtiff','-r200',[filepath 'Figs/FvFm_Sal_Light_' yrrange '.tif']);
hold off


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