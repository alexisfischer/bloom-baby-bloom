% resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
% load([resultpath 'Data\RAI_SCW.mat']);

resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([resultpath 'Data/RAI_SCW.mat'],'r');
load([resultpath 'Data/SCW_SCOOS.mat'],'a');
load([resultpath 'Data/TempChlTurb_SCW'],'S');
load([resultpath 'Data/Weatherstation_SCW'],'SC');

%[r] = import_RAI();
%[a] = import_SCOOS_weeklySCW();


%% Seasonality 2012-2019 dinoflagellates and diatoms with Chlorophyll Threshold
clearvars class2do_string dnok dnchl dnk h i ii j rk rok y_mat y_wkmat yd_wk yearlist;

% class2do_string = 'Dinoflagellates';
% i=find(a.chl>=3); dnchl=a.dn(i); %find the dates with chlorophyll exceeding a threshold
% for i=1:length(dnchl) %find corresponding dates in rai dataset
%     for j=1:length(r(60).dn)
%         if dnchl(i) == r(60).dn(j)
%             dnk(i) = r(60).dn(j);
%             rk(i) = r(60).rai(j);           
%         else
%         end
%     end
% end
% ii=find(rk); rok=rk(ii)'; dnok=dnk(ii)'; %remove NaNs

class2do_string = 'Diatoms';
i=find(a.chl>=3); dnchl=a.dn(i); %find the dates with chlorophyll exceeding a threshold
for i=1:length(dnchl) %find corresponding dates in rai dataset
    for j=1:length(r(61).dn)
        if dnchl(i) == r(61).dn(j)
            dnk(i) = r(61).dn(j);
            rk(i) = r(61).rai(j);           
        else
        end
    end
end
ii=find(rk); rok=rk(ii)'; dnok=dnk(ii)'; %remove NaNs

[~,y_mat,yearlist,~]=timeseries2ydmat(dnok,rok); %takes a timeseries and makes it into a year x day matrix

figure;
[y_wkmat,~,yd_wk]=ydmat2weeklymat(y_mat,yearlist); %takes a year x day matrix and makes it a year x 2 week matrix
pcolor([yd_wk ;yd_wk(end)+7],[yearlist(1:8) yearlist(8)+1],[[y_wkmat(:,1:8)';zeros(1,52)] zeros(9,1)]) %for just 2006:2014
caxis([0 .7]) %RAI
%colormap(flipud(hot));

ylabel('Year', 'fontsize',14, 'fontname', 'arial');
xlabel('Month', 'fontsize',14, 'fontname', 'arial');

title(num2str(class2do_string), 'fontsize',16, 'fontname', 'arial','fontweight','bold');

set(gca,'ylim',[2012 2019],'tickdir','out');
h=colorbar;
set(get(h,'ylabel'),'string','RAI (fraction)','fontsize',14,'fontname','arial');
%set(get(h,'ylabel'),'string','RAI','fontsize',14,'fontname','arial');
 h.TickDirection = 'out';
datetick('x',4)
axis square
shading flat

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Seasonality_RAI_ChlThr_' num2str(class2do_string) '_2012-2019.tif']);
hold off

%% Dino Diatom test 2018
clearvars class2do_string dnok dnchl dnk h i ii j rk rok y_mat y_wkmat yd_wk yearlist;

figure('Units','inches','Position',[1 1 8 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.04], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(4,1,1);
class2do_string = 'Dinoflagellates';
i=find(a.chl>=3); dnchl=a.dn(i); %find the dates with chlorophyll exceeding a threshold
for i=1:length(dnchl) %find corresponding dates in rai dataset
    for j=1:length(r(60).dn)
        if dnchl(i) == r(60).dn(j)
            dnk(i) = r(60).dn(j);
            rk(i) = r(60).rai(j);           
        else
        end
    end
end
ii=find(rk); rok=rk(ii)'; dnok=dnk(ii)'; %remove NaNs
[~,y_mat,yearlist,~]=timeseries2ydmat(dnok,rok);
[y_wkmat,~,yd_wk]=ydmat2weeklymat(y_mat,yearlist);

pcolor(yd_wk(1:24),[1,2],[y_wkmat(1:24,8)'; zeros(1,24)]) %01jan-01jul2018
caxis([0 0.6]) %RAI
shading flat
datetick('x',4)
set(gca,'ylim',[1 2],'ytick',[1,2],'yticklabel',{},'xticklabel',{},'tickdir','out');
ylabel('Dinoflagellate','fontsize',12, 'fontname', 'Arial');    
% h=colorbar;
% set(get(h,'ylabel'),'string','fraction','fontsize',14,'fontname','arial');
% h.TickDirection = 'out';
% h.Location='NorthOutside';
hold on

subplot(4,1,2)
class2do_string = 'Diatoms';
i=find(a.chl>=3); dnchl=a.dn(i); %find the dates with chlorophyll exceeding a threshold
for i=1:length(dnchl) %find corresponding dates in rai dataset
    for j=1:length(r(61).dn)
        if dnchl(i) == r(61).dn(j)
            dnk(i) = r(61).dn(j);
            rk(i) = r(61).rai(j);           
        else
        end
    end
end
ii=find(rk); rok=rk(ii)'; dnok=dnk(ii)'; %remove NaNs
[~,y_mat,yearlist,~]=timeseries2ydmat(dnok,rok);
[y_wkmat,~,yd_wk]=ydmat2weeklymat(y_mat,yearlist);

pcolor(yd_wk(1:24),[1,2],[y_wkmat(1:24,8)'; zeros(1,24)]) %01jan-01jul2018
caxis([0 0.7]) %RAI
shading flat
datetick('x',4)
set(gca,'ylim',[1 2],'ytick',[1,2],'yticklabel',{},'xticklabel',{},'tickdir','out');
ylabel('Diatom','fontsize',12, 'fontname', 'Arial');    
 
hold on

subplot(4,1,3); %chlorophyll
    plot(a.dn,(a.chl),'*','Color','k');
    hold on
    plot(S.dn,(S.chl),'-','Color','k');
    xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
    set(gca,'xgrid', 'on','ylim',[0 20],'ytick',0:10:20,'xlim',[xax1 xax2],...
        'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
        datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
        datenum('2018-06-01'),datenum('2018-07-01')],'Xticklabel',{},...
        'tickdir','out');      
    ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
    hold on
    
subplot(4,1,4);
[U,~]=plfilt(SC(7).U,SC(7).DN);
[V,DN]=plfilt(SC(7).V,SC(7).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
yax1=-3; yax2=3;
stick(time,u,v,xax1,xax2,yax1,yax2,' ');
hold on
set(gca,'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01')],...
    'Xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul'},'fontsize',12);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Diatom_Dino_2018.tif']);
hold off

%% Plot wind pcolor panel plot

time=[SC(1).DN;SC(2).DN;SC(3).DN;SC(4).DN;SC(5).DN;SC(6).DN;SC(7).DN];
windspeed=[SC(1).WINDSPEED;SC(2).WINDSPEED;SC(3).WINDSPEED;SC(4).WINDSPEED;...
    SC(5).WINDSPEED;SC(6).WINDSPEED;SC(7).WINDSPEED];
[dn,wsp,~] = ts_aggregation(time,windspeed,1,'day',@mean);

param_string = 'Windspeed';
ii=find(wsp); rok=wsp(ii); dnok=dn(ii); %remove NaNs

[~,y_mat,yearlist,~]=timeseries2ydmat(dnok,rok); %takes a timeseries and makes it into a year x day matrix

figure;
[y_wkmat,~,yd_wk]=ydmat2weeklymat(y_mat,yearlist); %takes a year x day matrix and makes it a year x 2 week matrix
pcolor([yd_wk ;yd_wk(end)+7],[yearlist(1:7) yearlist(7)+1],[[y_wkmat(:,1:7)';zeros(1,52)] zeros(8,1)]) %for just 2006:2014
caxis([0 5]) 

colormap(flipud(hot));

ylabel('Year', 'fontsize',14, 'fontname', 'arial');
xlabel('Month', 'fontsize',14, 'fontname', 'arial');

title(num2str(param_string), 'fontsize',16, 'fontname', 'arial','fontweight','bold');

set(gca,'ylim',[2012 2019],'tickdir','out');
h=colorbar;
set(get(h,'ylabel'),'string','m s^{-1}','fontsize',14,'fontname','arial');
 h.TickDirection = 'out';
datetick('x',4)
axis square
shading flat

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Seasonality_' num2str(param_string) '_2012-2019.tif']);
hold off

%% Seasonality 2012-2019 Chlorophyll, Temperature, Nitrate, Silicate

% param_string = 'Silicate';
% ii=find(a.SilicateuM); rok=a.SilicateuM(ii); dnok=a.dn(ii); %remove NaNs

% param_string = 'Nitrate';
% ii=find(a.NitrateuM); rok=a.NitrateuM(ii); dnok=a.dn(ii); %remove NaNs

% param_string = 'Temperature';
% ii=find(a.temp); rok=a.temp(ii); dnok=a.dn(ii); %remove NaNs

param_string = 'Chlorophyll';
ii=find(a.chl); rok=a.chl(ii); dnok=a.dn(ii); %remove NaNs

[~,y_mat,yearlist,~]=timeseries2ydmat(dnok,rok); %takes a timeseries and makes it into a year x day matrix

figure;
[y_wkmat,~,yd_wk]=ydmat2weeklymat(y_mat,yearlist); %takes a year x day matrix and makes it a year x 2 week matrix
pcolor([yd_wk ;yd_wk(end)+7],[yearlist(1:8) yearlist(8)+1],[[y_wkmat(:,1:8)';zeros(1,52)] zeros(9,1)]) %for just 2006:2014
%caxis([0 50]) %Silicate
%caxis([0 20]) %Nitrate
%caxis([11 18]) %Temperature
caxis([0 30]) %Chlorophyll

colormap(flipud(hot));

ylabel('Year', 'fontsize',14, 'fontname', 'arial');
xlabel('Month', 'fontsize',14, 'fontname', 'arial');

title(num2str(param_string), 'fontsize',16, 'fontname', 'arial','fontweight','bold');

set(gca,'ylim',[2012 2019],'tickdir','out');
h=colorbar;
%set(get(h,'ylabel'),'string','uM','fontsize',14,'fontname','arial');
%set(get(h,'ylabel'),'string','^oC','fontsize',14,'fontname','arial');
set(get(h,'ylabel'),'string','mg m^{-3}','fontsize',14,'fontname','arial');
 h.TickDirection = 'out';
datetick('x',4)
axis square
shading flat

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Seasonality_' num2str(param_string) '_2012-2019.tif']);
hold off

%% Seasonality 2016 all species
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');        

for i=1:13
    A=r(i).rai; ii=find(A); Aok=A(ii); y = Aok;
    x = r(i).dn(ii);
    [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat(x,y); %takes a timeseries and makes it into a year x day matrix
    [ y_wkmat, mdate_wkmat, yd_wk ] = ydmat2weeklymat( y_mat, yearlist ); %takes a year x day matrix and makes it a year x 1 week matrix
    pcolor([yd_wk ;yd_wk(end)+7],[i i+1],[[y_wkmat(:,10)';zeros(1,52)] zeros(2,1)]); 
    hold on
end

caxis([0 0.6])
colormap(flipud(hot));
xlabel('Month', 'fontsize',14, 'fontname', 'arial');

set(gca,'ylim',[1 14],'ytick',1:1:14,'fontsize',13,'tickdir','out',...
    'YTickLabel',[' ',flipud({r(1:13).name})]);
h=colorbar;
set(get(h,'ylabel'),'string','RAI','fontsize',13,'fontname','arial');
 h.TickDirection = 'out';
datetick('x',4)
axis square
shading flat

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Seasonality_RAI_group_compare_2016.tif']);
hold off


%% RAI for select species by circle size

figure('Units','inches','Position',[1 1 8 3],'PaperPositionMode','auto');        

for i=1:13
    sz=linspace(0,100,50); 
    A=r(i).rai';
    ii=~isnan(A); %which values are not NaNs
    Aok=A(ii);
    iii=find(Aok);
    Aook=Aok(iii);
    Asz=zeros(length(Aook),1); %preallocate space   
    for j=1:length(Asz)  % define sizes according to cyst abundance
         Asz(j)=sz(round(Aook(j)*length(sz)));
    end
    scatter(r(i).dn(iii)',i*ones(size(Asz)),Asz,'m','filled');
    hold on    
end  

datetick('x','yyyy')
set(gca,'xgrid', 'on','ylim',[0 13],'ytick',0:1:13,...
    'xlim',[datenum('2007-09-01') datenum('2018-03-01')],...
        'YTickLabel',['0', {r.name}],'tickdir','out');   
    
    % set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\RAI_2007-2018.tif']);
hold off

%% diatoms vs. dinos dot RAI plot
figure('Units','inches','Position',[1 1 8 1],'PaperPositionMode','auto');        

%dinoflagellate
    sz=linspace(1,70,100); 
    A=r(15).rai';
    ii=~isnan(A); Aok=A(ii);
    iii=find(Aok); Aook=Aok(iii);
    Aook(Aook>1)=1;
    Asz=zeros(length(Aook),1); 
    for j=1:length(Asz)  
         Asz(j)=sz(round(Aook(j)*length(sz)));
    end
    scatter(r(15).dn(iii)',15*ones(size(Asz)),Asz,'r','filled');
    hold on    
%diatoms
    sz=linspace(1,50,100); 
    A=r(16).rai';
    ii=~isnan(A); Aok=A(ii);
    iii=find(Aok); Aook=Aok(iii);
    Aook(Aook>1)=1;
    Asz=zeros(length(Aook),1); 
    for j=1:length(Asz)  
         Asz(j)=sz(round(Aook(j)*length(sz)));
    end
    scatter(r(15).dn(iii)',16*ones(size(Asz)),Asz,'b','filled');
    hold on        

datetick('x','yyyy')
set(gca,'xgrid', 'on','ylim',[14 16],'ytick',14:1:16,...
    'xlim',[datenum('2008-01-01') datenum('2018-03-01')],...
        'YTickLabel',['0',{'Dinoflagellates','Diatoms'}],'tickdir','out');   
    
    % set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\RAI_Dino_Diat_2007-2018.tif']);
hold off
