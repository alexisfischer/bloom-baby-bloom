
load('sfb.mat','sfb');

%[f] = prepbiovol4contour(filelist,eqdiam,biovol,sfb);

load list_st_filename.mat

%% contour biovolume in the San Francisco Bay

for i=1:length(f)
   
    yrok = f(i).dn(1);
    lat = f(i).lat; 
    lon = f(i).long; 
    biovol = f(i).biovol_ave;
    ii=~isnan(biovol+lat+lon);
    lonok=lon(ii); latok=lat(ii); vvok=biovol(ii);    

    % map limits and tics for SFB
    xax = [-122.56 -121.78]; yax=[37.42 38.22];
    xtic = -122.5:.2:-121.8; ytic=37.5:.1:38.2;  
    textsurv={datestr(yrok,'dd-mmm-yyyy')};

    % contour plot 
    x = -122.56:.001:-121.76; y = 37.4:.001:38.22;
    bathydata = load('C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\SFB_bathymetry.mat');
    xx = bathydata.lon; yy = bathydata.lat;
    F = scatteredInterpolant(lonok,latok,vvok,'nearest','nearest'); %F is a function
    zz = F(xx,yy); %must call scatteredInterp function in order to plot
    zz(bathydata.bathy==-9999) = nan;
    ccon=0:100:4000;

    fig1 = figure('Units','inches','Position',[1 1 6 6],'PaperPositionMode','auto'); clf;
    axes1 = axes('Parent',fig1);
    [C,h]=contour(xx,yy,zz,ccon); h.Fill='on';
    set(axes1, 'color', [0.83 0.816 0.78])
    cax=[0 4000];
    caxis(cax); hold on;
    set(gca,'xtick',xtic,'ytick',ytic,'fontsize',10,'TickDir','out');
    dasp(41); xlim(xax); ylim(yax);
    hp=get(gca,'pos');

    axes('pos',hp,'color','none'); axis off;
    dasp(41); xlim(xax); ylim(yax);
    caxis(cax);
    hold on;

    % plots outline of sfb
    coastline_SFB('k-'); 

    % add station locations
    plot(lon,lat,'ko','markerfacecolor','w','markersize',5);
    xlim(xax); ylim(yax);
    axis off; 

    % colorbar
    h=colorbar('east'); 
    h.Label.String= {'Ave. Biovolume (\mum^3)'};
    h.TickDirection = 'out';    
    hp=get(h,'pos'); hp(4)=.5*hp(4); hp(3)=.7*hp(3); 
    set(h,'pos',hp,'xaxisloc','top','fontsize',10); 
    h.Label.FontSize = 11;
    hold on;
    
    title(textsurv,'fontsize',14);
    str=['Biovol_contour_' datestr(yrok,'ddmmmyyyy') ''];

    % Set figure parameters
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r600',['C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Figs\' num2str(str) '.tif'])
    hold off

end 
