resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\';

[phys,s] = compile_physicalparameters([resultpath 'Data\sfb_raw.csv']);

%% contours salinity, chlorophyll, nitrogen, or temperature

%uncomment variable to plot

% str='Sal';
% label='Salinity (psu)';
% ccon=0:.5:35;
% cax=[0 35];    

% str='Chl';
% label='Chlorophyll (\mug L^{-1})';
% cax=[0 12];
% ccon=0:.5:12;
% 
% str='Temp';
% label='Temperature (^oC)';
% cax=[10 22];
% ccon=10:.5:22;
% 
% str='SPM';
% label='Suspended Sediments (mg L^{-1})';   
% cax=[0 400];
% ccon=0:100:400;
%         
% str='Ammonium';
% label='Ammonium (\muM)';   
% cax=[0 20];
% ccon=0:.5:20;    

str='Nitrate+Nitrite';
label='Nitrate+Nitrite (\muM)';
ccon=10:1:100;
cax=[10 100];    

for i=1:length(s)
    
%     var = s(i).sal;  
%     var = s(i).chl;    
%     var = s(i).temp;    
%     var = s(i).spm;    
%     var = s(i).amm;    
    var = s(i).nina;    
    
    yrok = datenum(s(i).dn);
    lat = s(i).lat; 
    lon = s(i).lon; 
    ii=~isnan(var+lat+lon);
    lonok=lon(ii); latok=lat(ii); vvok=var(ii);    

    % map limits and tics for SFB
    xax = [-122.56 -121.78]; yax=[37.42 38.22];
    xtic = -122.5:.2:-121.8; ytic=37.5:.1:38.2;  
    textsurv={datestr(yrok,'dd-mmm-yyyy')};

    % contour plot 
    x = -122.56:.001:-121.76; y = 37.4:.001:38.22;
    bathydata = load([resultpath 'Data\SFB_bathymetry.mat']);
    xx = bathydata.lon; yy = bathydata.lat;
    F = scatteredInterpolant(lonok,latok,vvok,'nearest','nearest'); %F is a function
    zz = F(xx,yy); %must call scatteredInterp function in order to plot
    zz(bathydata.bathy==-9999) = nan;

    fig1 = figure('Units','inches','Position',[1 1 6 6],'PaperPositionMode','auto'); clf;
    axes1 = axes('Parent',fig1);
    [C,h]=contour(xx,yy,zz,ccon); h.Fill='on';
    set(axes1, 'color', [0.83 0.816 0.78])
    caxis(cax); hold on;
    set(gca,'xtick',xtic,'ytick',ytic,'fontsize',10,'TickDir','out');
    dasp(41); xlim(xax); ylim(yax);
    hp=get(gca,'pos');

    axes('pos',hp,'color','none'); axis off;
    dasp(41); xlim(xax); ylim(yax);
    caxis(cax); hold on;

    % plots outline of sfb
    coastline_SFB('k-'); 

    % add station locations
    plot(lon,lat,'ko','markerfacecolor','w','markersize',12,'linewidth',.5);
    xlim(xax); ylim(yax);
    labels = num2str(s(i).st,'%d'); 
    text(lon,lat,labels,'horizontal','center','vertical','middle',...
        'fontsize',8,'color','k');
    axis off; 

    % colorbar
    h=colorbar('east'); 
    h.TickDirection = 'out';    
    h.Label.String = label;
    hp=get(h,'pos'); hp(4)=.5*hp(4); hp(3)=.6*hp(3); 
    set(h,'pos',hp,'xaxisloc','top','fontsize',11); 
    hold on;

    title(textsurv,'fontsize',14);

    % Set figure parameters
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r600',...
        [resultpath 'Figs\' num2str(str) '_contour_' datestr(yrok,'ddmmmyyyy') '.tif'])
    hold off

end 