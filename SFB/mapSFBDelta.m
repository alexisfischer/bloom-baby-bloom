%% plot contours of different variables in the SF Bay-Delta
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

filepath = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/SFBDelta_bathymetry'], 'LON', 'LAT', 'BATHY'); % map
load([filepath 'Data/physical_param'],'s'); % parameters
load([filepath 'Data/Phytoflash_summary'],'P'); % parameters
load([filepath 'Data/microscopy_SFB'],'BACI','CHLO','CHRY','CILI','CRYP',...
    'CYAN','DINO','ent','EUGL','EUST','HAPT','M','RAPH','tha');

%[phys]=import_USGS_cruisedata([filepath 'Data/sfb_raw_2013-present.xls']);
%['s','S','Si'] = compile_physicalparameters_v2(filepath,phys);

%% Phytoflash data
% uncomment variable to plot

label="FvFm"; str="FvFm"; cax=[0 .65]; 

for i=1:length(P)
      
    var = P(i).FvFm;            
    yrok = datenum(P(i).dn);
    xax = [-122.6 -121.6];
    yax = [37.79 38.29];
    textsurv={datestr(yrok,'dd-mmm-yyyy')};
    
    figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto'); clf;
    contour(LON, LAT, BATHY, [0,0], '-k'); hold on
    set(gca,'xtick',xax(1):.3:xax(2),'ytick',yax(1):.2:yax(2),'fontsize',12,'TickDir','out');
    dasp(41); xlim(xax); ylim(yax);
    hp=get(gca,'pos'); hold on
    axes('pos',hp,'color','none'); axis off;
    dasp(41); xlim(xax); ylim(yax); hold on
    
    %find matching x2
    for j=1:length(s)
        if datenum(s(j).dn) == P(i).dn
            lonX2=s(j).lonX2;
            latX2=s(j).latX2;
        else
        end
    end
    
    line([lonX2 lonX2],[(latX2-.07) (latX2+.04)],'Color','k','Linewidth',3)
    text(lonX2,(latX2-.07),'X2','VerticalAlignment','cap',...
        'HorizontalAlignment','center','fontsize',12,'color','k','fontweight','bold');
    axis off; hold on
    
    %  plot variables as circles with colors proporational to concentration 
    latk = P(i).lat; lonk = P(i).lon; ii=~isnan(var+latk+lonk);
    lonok=lonk(ii); latok=latk(ii); vok=var(ii);    

    if str == "Sal"    
        color=brewermap([],'YlGnBu');
    elseif str == "Temp"
        color=(brewermap([],'YlOrRd'));
    elseif str == "Chl"
        color=(brewermap([],'YlGn'));        
    else
        color=(brewermap([],'RdYlGn'));        
    end   
        
    colormap(color);
    d=(vok-cax(1))/(cax(2)-cax(1));%scale of 0:1, divide by upper limit
    d(d>1)=1; 
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for j=1:length(d)  
        dcol(j,:)=color(round(d(j)*length(color)),:);
    end    
    
    for j=1:length(lonok) % plot each point separately with a special color
        scatter(lonok(j),latok(j),200,dcol(j,:),'filled');
    end
    hold on
    
    caxis(cax);    
    h=colorbar('south'); 
    h.TickDirection = 'out';    
    h.Label.String = label;
    h.Ticks=linspace(cax(1),cax(2),3);   
    hp=get(h,'pos'); hp(1)=3.3*hp(1); hp(3)=.54*hp(3); hp(4)=.6*hp(4);
    set(h,'pos',hp,'xaxisloc','top','fontsize',12); 
    title(textsurv,'fontsize',14);    
    hold on;
    
    % Set figure parameters
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r100',...
        [filepath 'Figs/' num2str(str) '_map_' datestr(yrok,'ddmmmyyyy') '.tif'])
    hold off
    
    clearvars var dcol latk lonk latok lonok vok d;
end
    
%% Microscopy data
% uncomment variable to plot

%str='Thalassiosira'; S=tha; cax=[10^2 10^6]; label = 'biovol (\mu^{-3} mL^{-1})';
%str='Entomoneis'; S=ent; cax=[10^1 10^5]; label = 'biovol (\mu^{-3} mL^{-1})';
str='BACILLARIOPHYTA'; cax=[10^2 10^6]; S=BACI; label = 'biovol (\mu^{-3} mL^{-1})';

for i=1:length(S)
 %   var=(S(i).cellsmL);   
   var=(S(i).biovol);   
        
    yrok = datenum(S(i).dn);
    xax = [-122.6 -121.6];
    yax = [37.79 38.29];
    textsurv={datestr(yrok,'dd-mmm-yyyy')};
    
    figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto'); clf;
    contour(LON, LAT, BATHY, [0,0], '-k');
    hold on
    set(gca,'xtick',xax(1):.3:xax(2),'ytick',yax(1):.2:yax(2),'fontsize',12,'TickDir','out');
    dasp(41); xlim(xax); ylim(yax);
    hp=get(gca,'pos'); hold on
    axes('pos',hp,'color','none'); axis off;
    dasp(41); xlim(xax); ylim(yax);  hold on
    
    %find matching x2
    for j=1:length(s)
        if datenum(s(j).dn) == S(i).dn
            lonX2=s(j).lonX2;
            latX2=s(j).latX2;
        else
        end
    end
    
    red=brewermap(6,'Reds');
    line([lonX2 lonX2],[(latX2-.07) (latX2+.04)],'Color',red(6,:),'Linewidth',3)
    text(lonX2,(latX2-.07),'X2','VerticalAlignment','cap',...
        'HorizontalAlignment','center','fontsize',12,'color',red(6,:),'fontweight','bold');
    axis off; hold on
    
    %  plot variables as circles with colors proporational to concentration 
    latk = S(i).lat; lonk = S(i).lon; 
    ii=~isnan(var+latk+lonk);
    lonok=lonk(ii); latok=latk(ii); vok=var(ii);    

    color=brewermap([],'Greens');
    colormap(color);
    d=(vok-cax(1))/(cax(2)-cax(1));%scale of 0:1, divide by upper limit
    d(d>1)=1; 
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for j=1:length(d)  
        dcol(j,:)=color(round(d(j)*length(color)),:);
    end
    hold on
    
    for j=1:length(lonok) % plot each point separately with a special color
        scatter(lonok(j),latok(j),200,dcol(j,:),'filled');
    end
    hold on
    
    caxis(cax);    
    h=colorbar('south'); 
    h.TickDirection = 'out';    
    h.Label.String = {str; label};
    h.Ticks=linspace(cax(1),cax(2),3);   
    hp=get(h,'pos'); hp(1)=3.3*hp(1); hp(3)=.54*hp(3); hp(4)=.6*hp(4);
    set(h,'pos',hp,'xaxisloc','top','fontsize',12); 
    title(textsurv,'fontsize',14);    
    hold on;

%   Set figure parameters
    set(gcf,'color','w'); print(gcf,'-dtiff','-r100',...
        [filepath 'Figs/' num2str(str) '_contour_' datestr(yrok,'ddmmmyyyy') '.tif'])
    hold off
    
    clearvars var dcol latk lonk latok lonok vok d;
end 

%% Chemical and Physical data
% uncomment variable to plot

% label="Salinity (psu)"; str="Sal"; cax=[0 30]; 
 label="Chlorophyll (mg m^{-3})"; str="Chl"; cax=[0 20];
% label="Temperature (^oC)"; str="Temp"; cax=[12 22];
% label="Suspended Sediments (mg L^{-1})"; str="SPM"; cax=[0 100];
% label="Ammonium (\muM)"; str="Amm"; cax=[0 20];
% label="Nitrate+Nitrite (\muM)"; str="nit"; cax=[10 50];    

for i=1:length(s) 
%    var = s(i).sal;
    var = s(i).chl;    
%    var = s(i).temp;    
%    var = s(i).spm;    
%    var = s(i).amm;    
%    var = s(i).nina;        

    yrok = datenum(s(i).dn);
    xax = [-122.6 -121.6];
    yax = [37.79 38.29];
    textsurv={datestr(yrok,'dd-mmm-yyyy')};
    
    figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto'); clf;
    contour(LON, LAT, BATHY, [0,0], '-k'); hold on
    set(gca,'xtick',xax(1):.3:xax(2),'ytick',yax(1):.2:yax(2),'fontsize',12,'TickDir','out');
    dasp(41); xlim(xax); ylim(yax);
    hp=get(gca,'pos'); hold on
    axes('pos',hp,'color','none'); axis off;
    dasp(41); xlim(xax); ylim(yax); hold on
    
    %plot x2
     red=brewermap(6,'Reds');   
    line([s(i).lonX2 s(i).lonX2],[(s(i).latX2-.07) (s(i).latX2+.04)],...
        'Color',red(6,:),'Linewidth',3)
    text(s(i).lonX2,(s(i).latX2-.07),'X2','VerticalAlignment','cap',...
        'HorizontalAlignment','center','fontsize',12,'color',red(6,:),'fontweight','bold');
    axis off; hold on
    
    %  plot variables as circles with colors proporational to concentration 
    latk = s(i).lat; lonk = s(i).lon; ii=~isnan(var+latk+lonk);
    lonok=lonk(ii); latok=latk(ii); vok=var(ii);    

    if str == "Sal"    
        color=brewermap([],'YlGnBu');
    elseif str == "Temp"
        color=(brewermap([],'YlOrRd'));
    elseif str == "Chl"
        color=(brewermap([],'YlGn'));        
    else
        color=(brewermap([],'Greens'));        
    end   
        
    colormap(color);
    d=(vok-cax(1))/(cax(2)-cax(1));%scale of 0:1, divide by upper limit
    d(d>1)=1; 
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for j=1:length(d)  
        dcol(j,:)=color(round(d(j)*length(color)),:);
    end    
    
    for j=1:length(lonok) % plot each point separately with a special color
        scatter(lonok(j),latok(j),200,dcol(j,:),'filled');
    end
    hold on
    
    caxis(cax);    
    h=colorbar('south'); 
    h.TickDirection = 'out';    
    h.Label.String = label;
    h.Ticks=linspace(cax(1),cax(2),3);   
    hp=get(h,'pos'); hp(1)=3.3*hp(1); hp(3)=.54*hp(3); hp(4)=.6*hp(4);
    set(h,'pos',hp,'xaxisloc','top','fontsize',12); 
    title(textsurv,'fontsize',14);    
    hold on;
    
    % Set figure parameters
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r100',...
        [filepath 'Figs/' num2str(str) '_contour_' datestr(yrok,'ddmmmyyyy') '.tif'])
    hold off
    
    clearvars var dcol latk lonk latok lonok vok d;
end 

%% Microscopy data
% uncomment variable to plot

%str='Thalassiosira'; cax=[0 6]; S=tha; label = 'log(cells mL^{-1})';
%str='Entomoneis'; cax=[0 6]; S=ent; label = 'log(cells mL^{-1})';
str='BACILLARIOPHYTA'; cax=[10^2 10^6]; S=BACI; label = 'biovol (\mu^{-3} mL^{-1})';

for i=1:length(S)
%    var=(S(i).cellsmL);   
    var=(S(i).biovol);   
        
    yrok = datenum(S(i).dn);
    xax = [-122.6 -121.6];
    yax = [37.79 38.29];
    textsurv={datestr(yrok,'dd-mmm-yyyy')};
    
    figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto'); clf;
    contour(LON, LAT, BATHY, [0,0], '-k');
    hold on
    set(gca,'xtick',xax(1):.3:xax(2),'ytick',yax(1):.2:yax(2),'fontsize',12,'TickDir','out');
    dasp(41); xlim(xax); ylim(yax);
    hp=get(gca,'pos'); hold on
    axes('pos',hp,'color','none'); axis off;
    dasp(41); xlim(xax); ylim(yax);  hold on
    
    %find matching x2
    for j=1:length(s)
        if datenum(s(j).dn) == S(i).dn
            lonX2=s(j).lonX2;
            latX2=s(j).latX2;
        else
        end
    end
    
    red=brewermap(6,'Reds');
    line([lonX2 lonX2],[(latX2-.07) (latX2+.04)],'Color',red(6,:),'Linewidth',3)
    text(lonX2,(latX2-.07),'X2','VerticalAlignment','cap',...
        'HorizontalAlignment','center','fontsize',12,'color',red(6,:),'fontweight','bold');
    axis off; hold on
    
    %  plot variables as circles with colors proporational to concentration 
    latk = S(i).lat; lonk = S(i).lon; 
    ii=~isnan(var+latk+lonk);
    lonok=lonk(ii); latok=latk(ii); vok=var(ii);    

    color=brewermap([],'Greens');
    colormap(color);
    d=(vok-cax(1))/(cax(2)-cax(1));%scale of 0:1, divide by upper limit
    d(d>1)=1; 
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for j=1:length(d)  
        dcol(j,:)=color(round(d(j)*length(color)),:);
    end
    hold on
    
    for j=1:length(lonok) % plot each point separately with a special color
        scatter(lonok(j),latok(j),200,dcol(j,:),'filled');
    end
    hold on
    
    caxis(cax);    
    h=colorbar('south'); 
    h.TickDirection = 'out';    
    h.Label.String = {str; label};
    h.Ticks=linspace(cax(1),cax(2),3);   
    hp=get(h,'pos'); hp(1)=3.3*hp(1); hp(3)=.54*hp(3); hp(4)=.6*hp(4);
    set(h,'pos',hp,'xaxisloc','top','fontsize',12); 
    title(textsurv,'fontsize',14);    
    hold on;

%   Set figure parameters
    set(gcf,'color','w'); print(gcf,'-dtiff','-r100',...
        [filepath 'Figs/' num2str(str) '_contour_' datestr(yrok,'ddmmmyyyy') '.tif'])
    hold off
    
    clearvars var dcol latk lonk latok lonok vok d;
end 

%% plot map of sfb-delta
%(2 psu bottom salinity value measured along the axis of the estuary in km
%from the Golden Gate)
xax = [-122.62 -121.46];
yax = [37.42 38.47];

figure('Units','inches','Position',[1 1 6 6],'PaperPositionMode','auto'); clf;
contour(LON, LAT, BATHY, [0,0], '-k'); hold on
set(gca,'xtick',xax(1):.3:xax(2),'ytick',yax(1):.3:yax(2),'fontsize',12,'TickDir','out');
dasp(41); xlim(xax); ylim(yax);
hp=get(gca,'pos'); hold on
axes('pos',hp,'color','none'); axis off;
dasp(41); xlim(xax); ylim(yax); hold on

hold on
plot(-121.489183, 38.440763,'bd','Markersize',12,'Markerfacecolor','b'); %SWTP

% add station locations
%plot(s(30).lon,s(30).lat,'y-','linewidth',2);
hold on
lon=s(30).lon(1:3:end); lat=s(30).lat(1:3:end); st=s(30).st(1:3:end);
plot(s(30).lon,s(30).lat,'ro','markerfacecolor','y','markersize',5,'linewidth',.5);
labels = num2str(st,'%d'); 
text(lon,lat,labels,'fontsize',11,'color','k','fontweight','bold');
axis off; 

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs\SFB_station_map.tif'])
hold off
