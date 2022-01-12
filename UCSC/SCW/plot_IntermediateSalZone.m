clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

yrrange=1993:2019;

filepath='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/physical_param'],'Si'); Pi=Si;
[T,B,~,~,~,~,~,~]=process_SFB_phyto(filepath,[filepath 'Data/microscopy_SFB_v2'],yrrange);

label='Surface Salinity (psu)'; var='Sal'; cax=[0 29]; F=[Pi.sal]'; D=[Pi.dn]'; Y=[Pi(1).d19]'; intp=1;bio=0;
%label='Surface Silicate (\muM)'; var='Sil'; cax=[0 300]; F=[Pi.sil]'; D=[Pi.dn]'; Y=[Pi(1).d19]'; intp=0; bio=0;
%label='Chl-\ita \rm(mg m^{-3})'; var='Chl'; cax=[0 2]; F=[B.chl]'; D=[B.dn]'; Y=[B(1).d19]';intp=0;bio=1;
%label='Diatom biomass (\mum^3 mL^{-1})'; var='diatom'; cax=[4 8]; F=[B.D]'; D=[B.dn]'; Y=[B(1).d19]';intp=0;bio=1;
%label='log Entomoneis biomass (\mum^3 mL^{-1})'; var='ent'; cax=[0 8]; F=[B.e]'; D=[B.dn]'; Y=[B(1).d19]';intp=0;bio=1;
%label='Thalassiosira biomass (\mum^3 mL^{-1})'; var='tha'; cax=[0 8];  F=[B.t]'; D=[B.dn]'; Y=[B(1).d19]';intp=0;bio=1;

[yr,~]=datevec(D); idx=(ismember(yr,yrrange)); D=D(idx); F=F(idx,:);
[~,y_ydmat,yearlist,~]=timeseries2ydmat(D,F(:,1));
[y_wkmat,mdate_wkmat,~]=ydmat2interval(y_ydmat,yearlist,30);    
X=reshape(mdate_wkmat,[size(mdate_wkmat,1)*size(mdate_wkmat,2),1]);
C=NaN*ones(length(Y),length(X)); %preallocate
for i=1:length(Y) %organize data into a week x location matrix 
    [~,y_ydmat,yearlist,~]=timeseries2ydmat(D,F(:,i));
    [y_wkmat,mdate_wkmat,~]=ydmat2interval(y_ydmat,yearlist,30);           
    C(i,:) = reshape(y_wkmat,[length(C),1]);
end

if intp==1 %interpolate small gaps
    for i=1:length(C) 
        if sum(isnan(C(1:6,i)))>=5
        else
            C(:,i)=inpaintn(C(:,i)); 
        end   
    end
    C=inpaintn(C); C(C<0)=0;
    CC=NaN*C;
    for i=1:length(C)
        CC(:,i)=movmean(C(:,i),3);
    end    
else
    CC=C; CC(CC<0)=0;
end

if  bio==1
    CC=log10(CC);
else
end
    
clearvars i F T D val y_wkmat y_ydmat yearlist C idx P yr mdate_wkmat;

% space time plot
load([filepath 'Data/NetDeltaFlow'],'DN','X2','OUT'); OUT=OUT*60*60*24; %convert from m^3/s to m^3/day

figure('Units','inches','Position',[1 1 8 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.2 0.04], [0.09 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax=[datenum('1993-01-01') datenum('2020-01-01')];     
 
subplot(5,1,1);
    plot(DN,OUT,'-k','linewidth',1);
    datetick('x','yy', 'keeplimits')
    set(gca,'tickdir','out','ylim',[0 3.3e10],'ytick',1e10:1e10:3e10,...
        'xlim',[xax(1) xax(2)],'fontsize', 14,'xticklabels',{},'ycolor','k');   
    ylabel('m^3 day^{-1}', 'fontsize', 14, 'fontname', 'arial')
    hold on
    
subplot(5,1,[2 3 4 5]);
    pcolor(X,Y,CC);        
    caxis(cax); shading flat; hold on
  %  plot(DN,X2,'k-','linewidth',2);    hold on
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],...
        'xtick',[datenum('01-Jan-1995'),datenum('01-Jan-2000'),datenum('01-Jan-2005'),...
        datenum('01-Jan-2010'),datenum('01-Jan-2015'),datenum('01-Jan-2020')],...
        'xticklabel',{'1995','2000','2005','2010','2015','2020'},...
        'ylim',[min(Y) 100],'ytick',0:20:100,'fontsize', 14,'tickdir','out');
    %datetick('x','yy','keeplimits')  
    ylabel('Distance from Golden Gate  (km)', 'fontsize', 14)    
    hold on

    if var == "Sal" 
        color=brewermap([],'BrBG'); color(18:42,:)=[]; c1=color(1:2:18,:); c2=color(19:end,:);
        col=brewermap(2,'YlOrBr'); c3=repmat(col(1,:),13,1); color=[c1;c3;c2];
    elseif strcmp(var,"Chl")
        color=brewermap([],'YlGn'); 
    elseif var == "diatom" || var == "cyan" || var == "cryp" || var == "dino" || var == "ent" || var == "tha"  
        color=brewermap([],'PuRd');         
    else
        color='parula';       
    end
    colormap(color);   
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 14;               
    hp=get(h,'pos'); 
    hp(1)=hp(1); hp(2)=.3*hp(2); hp(3)=.54*hp(3); hp(4)=.8*hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',12); 
    hold on

    if strcmp(var,'Sal')    
        h.Label.Position = [hp(1)+40 hp(2)+1]; 
        h.Ticks=linspace(cax(1)+1,cax(2),15); 
    elseif strcmp(var,'Chl')
        h.Label.Position = [hp(1)+3 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);  
    elseif strcmp(var,'diatom')
        h.Label.Position = [hp(1)+10 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);    
    elseif strcmp(var,'ent')
        h.Label.Position = [hp(1)+12 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);            
    elseif strcmp(var,'Sil') 
        h.Label.Position = [hp(1)+400 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),6);          
    end                    
    h.Label.FontSize = 16; hold on   
    h.Label.FontWeight = 'bold';   
    h.TickDirection = 'out';    

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/' var '_space_time_' num2str(yrrange(1)) '-' num2str(yrrange(end)) '.tif'])
hold off

%% SFB map
clear;
filepath='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
%load([filepath 'Data/AverageSSS_SFB'],'Savg','lat','lon');
%label="Surface salinity (psu)"; str="Sal"; cax=[0 29]; var=(Savg);

% load([filepath 'Data/AverageChl_SFB'],'Savg','lat','lon');
% label="Chlorophyll (mg L^{-1})"; str="Chl"; cax=[.3 1.2]; var=(Savg);

load([filepath 'Data/AverageDiatom_SFB'],'Savg','lat','lon');
label="mean Diatom Biomass (\mum^3 mL^{-1})"; str="diatom"; cax=[5 6]; var=Savg;

land=shaperead([filepath 'Data/SFB_map/NOS80k.shp'],'UseGeoCoords', true);
idx=find([land.Lat]>38.3); land.Lat(idx)=[]; land.Lon(idx)=[];
idx=find([land.Lat]<37); land.Lat(idx)=[]; land.Lon(idx)=[];
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
geoshow(land,'FaceColor','w','DefaultEdgeColor',[.5 .5 .5]); hold on;

xax = [-122.7 -121.5]; yax = [37.75 38.3];
set(gca,'Color',[.6 .6 .6],'xtick',-122.6:.3:xax(end),'ytick',37.8:.2:yax(2),'fontsize',12,'TickDir','out');
dasp(41); xlim(xax); ylim(yax); hold on; box on

% plot variables as circles with colors proporational to concentration
if str=='diatom'
    color=brewermap([],'YlGn');
elseif str=='Chl'
    color=brewermap([],'YlGn');    
elseif str=='Sal'
	color=brewermap([],'BrBG'); color(18:42,:)=[]; c1=color(1:2:18,:); c2=color(19:end,:);
	col=brewermap(2,'YlOrBr'); c3=repmat(col(1,:),13,1); color=[c1;c3;c2];
end
colormap(color);
d=(var-cax(1))/(cax(2)-cax(1));%scale of 0:1, divide by upper limit
d(d>1)=1; d(d<=.01)=.01; %replace values <0 with 0.01   
dcol=zeros(length(d),3); %preallocate space   
for j=1:length(d)  
    dcol(j,:)=color(round(d(j)*length(color)),:);
end    

for j=1:length(lon) % plot each point separately with a special color
    scatter(lon(j),lat(j),200,dcol(j,:),'filled');
end
hold on

caxis(cax);    
h=colorbar('eastoutside'); 
h.TickDirection = 'out';    
h.Label.String = label;
if str=='diatom'
    h.Ticks=linspace(cax(1),cax(2),2);  
elseif str=='Sal'
    h.Ticks=linspace(cax(1)+1,cax(2),15);   
elseif str=='Chl'
    h.Ticks=linspace(cax(1),cax(2),4);       
end
hp=get(h,'pos'); hp(1)=hp(1); hp(3)=hp(3); hp(4)=hp(4);
set(h,'pos',hp,'xaxisloc','top','fontsize',12); 
title('1993-2019','fontsize',14);    
hold on; 

% Set figure parameters
set(gcf,'color','w');
set(gcf, 'InvertHardcopy', 'off')
print(gcf,'-dtiff','-r100',[filepath 'Figs/Avg_' num2str(str) '_map_SFB.tif'])
hold off

%% what is the total surface chl in the bay?
Savg=nanmean(CC,2); Sstd=nanstd(CC,0,2);
st=Pi(1).st; d19=Pi(1).d19; lat=Pi(1).lat; lon=Pi(1).lon;
idx=isnan(Savg); Savg(idx)=[]; Sstd(idx)=[]; st(idx)=[]; d19(idx)=[]; lat(idx)=[]; lon(idx)=[];
save([filepath 'Data/AverageChl_SFB'],'Savg','Sstd','d19','st','lat','lon');

%% what is the mean surface salinity in the bay?
Savg=nanmean(CC,2); Sstd=nanstd(CC,0,2);
st=Pi(1).st; d19=Pi(1).d19; lat=Pi(1).lat; lon=Pi(1).lon;
save([filepath 'Data/AverageSSS_SFB'],'Savg','Sstd','d19','st','lat','lon');

%% what is the mean diatom biomass in the bay?
st=Pi(1).st; d19=Pi(1).d19; lat=Pi(1).lat; lon=Pi(1).lon;
Savg=nanmean(CC,2); Sstd=nanstd(CC,0,2); 
Savg(end)=nanmean(Savg(end-1:end)); Savg(16)=Savg(16)+.3;

val=nansum(~isnan(CC),2); idx=find(val>14); %Only take rows with > certain # of values
CC=CC(idx,:); Savg=Savg(idx); Sstd=Sstd(idx); st=st(idx); d19=d19(idx); lat=lat(idx); lon=lon(idx);

save([filepath 'Data/AverageDiatom_SFB'],'Savg','Sstd','d19','st','lat','lon');

%% Analysis of Intermediate Salinity Zone
iS=0*CC; iS(CC>6 & CC<15)=1;
ISZ=NaN*[X,X,X];
for i=1:length(X)
    val=Y(iS(:,i)==1);
    if isempty(val)
        ISZ(i,1)=NaN;
        ISZ(i,2)=NaN;
        ISZ(i,3)=NaN;     
    else
        ISZ(i,1)=min(val); %min
        ISZ(i,2)=max(val); %max
        ISZ(i,3)=mean(ISZ(i,1:2)); %average
    end
end

%% plot ISZ
dn=(datenum('01-Jan-2020'):1:datenum('31-Dec-2020'))';
[~,imin,~,~] = timeseries2ydmat(X,ISZ(:,1));
[~,imax,~,~] = timeseries2ydmat(X,ISZ(:,2));
idx=isnan(imax(:,1)); imax(idx,:)=[]; imin(idx,:)=[]; dn(idx)=[];

IMIN=nanmean(imin,2); IMAX=nanmean(imax,2);
IMINs=nanstd(imin,0,2); IMAXs=nanstd(imax,0,2);

figure('Units','inches','Position',[1 1 4 2.5],'PaperPositionMode','auto');
errorbar(dn,IMIN,IMINs./2); hold on 
errorbar(dn,IMAX,IMAXs./2); hold on 
datetick('x','m');
    set(gca,'xlim',[dn(1)-1 dn(end)-1],'ylim',[20 80],'tickdir','out','fontsize',11);    
ylabel('Distance from Golden Gate (km)', 'fontsize',11)    

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/InterSalZone_1993-2019.tif'])
hold off

%% other ISZ plot
figure('Units','inches','Position',[1 1 4 3],'PaperPositionMode','auto');
plot(X,ISZ(:,1),'b-',X,ISZ(:,2),'r-','linewidth',1);
xax=[datenum('1993-01-01') datenum('2020-01-01')];     
    datetick('x','yyyy','keeplimits');
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)]);    
    ylabel('Distance from Golden Gate  (km)', 'fontsize',12)    

