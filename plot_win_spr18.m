
[AKA]=summarize_Man_Auto_TB('Akashiwo');
[ALE]=summarize_Man_Auto_TB('Alexandrium_singlet');
[CER]=summarize_Man_Auto_TB('Ceratium');
[CHA]=summarize_Man_Auto_TB('Chaetoceros');
[DIN]=summarize_Man_Auto_TB('Dinophysis');
[PRO]=summarize_Man_Auto_TB('Prorocentrum');
[PSE]=summarize_Man_Auto_TB('Pseudo-nitzschia');

resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
load([resultpath 'Data\RAI_SCW']);
load([resultpath 'Data\SCW_microscopydata.mat']); %load cell count data
load([resultpath 'Data\WeeklySampling_SCW.mat']);
load([resultpath 'Data\wind_SCW_M1_2016_2018']);

%% Akashiwo Fall 2016 Automated vs. Manual vs. Microscopy
figure('Units','inches','Position',[1 1 8 2.5],'PaperPositionMode','auto');

%automatic
h1=stem(AKA.dn_auto,AKA.y_auto./AKA.slope,'ko-','Linewidth',1.2,'markersize',4); %This adjusts the automated counts by the chosen slope. 
hold on

%manual
for i=1:length(AKA.yearlist)
    ind_nan=find(~isnan(AKA.y_man(:,i)));
    h2=plot(AKA.dn_man(ind_nan,i), AKA.y_man(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
end
hold on

%microscopy
h3=plot(mcr.akashiwo.dn, mcr.akashiwo.avg,'b^','Markersize',3,'linewidth',1,'markerfacecolor','w');
hold all

datetick('x','m')
set(gca,'xgrid', 'on','ylim',[0 800],'ytick',0:200:800,...
    'xlim',[datenum('2016-08-01') datenum('2016-11-06')],'tickdir','out');    
ylabel('cells mL^{-1}\bf','fontsize',12, 'fontname', 'Arial');    
hold on
     
ylabel('cells mL^{-1}\bf','fontsize',12, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

lh = legend([h1,h2,h3], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification','Microscopy');
hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Akashiwo_Fall2016.tif']);
hold off

%% Spring 2018 Akashiwo, Chaetoceros, Prorocentrum, Pseudo-nitzschia
% with wind and temperature
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.07 0.04], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(4,1,1); %wind
[U,~]=plfilt(SC(3).U,SC(3).DN);
[V,DN]=plfilt(SC(3).V,SC(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-18'); xax2=datenum('2018-05-01');
yax1=-2; yax2=2;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018');

subplot(4,1,2); %temp
plot(a.dn,a.temp,'o-','Markersize',3,'color',[0,0.4470,0.7410]);
set(gca,'xgrid', 'on','ylim',[10 17],'ytick',10:2:16,'xlim',[xax1 xax2],...
    'xtick',[datenum('2018-02-01'),datenum('2018-03-01'),datenum('2018-04-01'),...
    datenum('2018-05-01')],'Xticklabel',{},'tickdir','out');      
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(4,1,3); %Chl
plot(a.dn,a.chl,'*-','Markersize',3,'color',[0.8500,0.3250,0.0980]);
set(gca,'xgrid', 'on','ylim',[0 15],'ytick',0:5:15,'xlim',[xax1 xax2],...
    'xtick',[datenum('2018-02-01'),datenum('2018-03-01'),datenum('2018-04-01'),...
    datenum('2018-05-01')],'xticklabel',{},'tickdir','out');      
ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(4,1,4); %IFCB
h1=plot(AKA.dn_auto,AKA.y_auto./AKA.slope,'ko-','Linewidth',1,'markersize',3); %This adjusts the automated counts by the chosen slope. 
hold on
h2=plot(PRO.dn_auto,PRO.y_auto./PRO.slope,'kd-','Linewidth',1,'markersize',3); %This adjusts the automated counts by the chosen slope. 
hold on
h3=plot(CHA.dn_auto,CHA.y_auto./CHA.slope,'ko-','Linewidth',1,'markersize',3); %This adjusts the automated counts by the chosen slope. 
hold on
h4=plot(PSE.dn_auto,PSE.y_auto./PSE.slope,'k^-','Linewidth',1,'markersize',3); %This adjusts the automated counts by the chosen slope. 
hold on

set(h1,'color',[0.6350,0.0780,0.1840],'Markerfacecolor',[0.6350,0.0780,0.1840]);
set(h2,'color',[0.4940,0.1840,0.5560],'markerfacecolor',[0.4940,0.1840,0.5560]);
set(h3,'color',[0.3010,0.7450,0.9330]);
set(h4,'color',[0.4660,0.6740,0.1880]);

set(gca,'xgrid', 'on','ylim',[0 50],'ytick',0:10:50,'xlim',[xax1 xax2],...
    'xtick',[datenum('2018-02-01'),datenum('2018-03-01'),...
    datenum('2018-04-01'),datenum('2018-05-01')],...
    'Xticklabel',{'Feb','Mar','Apr','May'},'tickdir','out');      
ylabel('Cells mL^{-1}\bf','fontsize',12, 'fontname', 'Arial');    
hold on

vfill([datenum('2018-01-28'),0,datenum('2018-02-01'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2018-02-09'),0,datenum('2018-02-15'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2018-03-02'),0,datenum('2018-03-06'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on
legend([h1,h2,h3,h4],'Akashiwo','Prorocentrum','Chaetoceros','Pseudo-nitzschia');

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Win-Spr2018.tif']);
hold off

%% Fall 2016 Akashiwo and Pro
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.07 0.04], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(4,1,1); %wind
[U,~]=plfilt(SC(1).U,SC(1).DN);
[V,DN]=plfilt(SC(1).V,SC(1).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2016-08-01'); xax2=datenum('2016-11-06');
yax1=-2; yax2=2;
stick(time,u,v,xax1,xax2,yax1,yax2,'2016');

subplot(4,1,2); %temp
plot(a.dn,a.temp,'o-','Markersize',3,'color',[0,0.4470,0.7410]);
set(gca,'xgrid', 'on','ylim',[13 18],'ytick',14:2:18,'xlim',[xax1 xax2],...
    'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
    datenum('2016-10-01'),datenum('2016-11-01')],...    
    'xticklabel',{},'tickdir','out');    
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(4,1,3); %Chl
plot(a.dn,a.chl,'*-','Markersize',3,'color',[0.8500,0.3250,0.0980]);
set(gca,'xgrid', 'on','ylim',[0 150],'ytick',0:50:150,'xlim',[xax1 xax2],...
    'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
    datenum('2016-10-01'),datenum('2016-11-01')],...    
    'xticklabel',{},'tickdir','out');      
ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(4,1,4); 
h1=plot(AKA.dn_auto,AKA.y_auto./AKA.slope,'ko-','Linewidth',1,'markersize',3); %This adjusts the automated counts by the chosen slope. 
hold on
h2=plot(PRO.dn_auto,PRO.y_auto./PRO.slope,'kd-','Linewidth',1,'markersize',3); %This adjusts the automated counts by the chosen slope. 
hold on

set(h1,'color',[0.6350,0.0780,0.1840],'Markerfacecolor',[0.6350,0.0780,0.1840]);
set(h2,'color',[0.4940,0.1840,0.5560],'markerfacecolor',[0.4940,0.1840,0.5560]);

set(gca,'xgrid', 'on','ylim',[0 410],'ytick',0:100:400,'xlim',[xax1 xax2],...
    'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
    datenum('2016-10-01'),datenum('2016-11-01')],...
    'xticklabel',{'Aug','Sep','Oct','Nov'},'tickdir','out');    
ylabel('cells mL^{-1}\bf','fontsize',12, 'fontname', 'Arial');    
hold on
     
ylabel('Cells mL^{-1}\bf','fontsize',12, 'fontname', 'Arial');    
hold on
vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
hold on

legend([h1,h2],'Akashiwo','Prorocentrum','location','nw');

hold on
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Fall2016.tif']);
hold off