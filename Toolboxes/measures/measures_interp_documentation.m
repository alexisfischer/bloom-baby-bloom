%% |measures_interp| documentation
% The |measures_interp| interpolates MEaSUREs ice surface velocity data at
% any location(s), along a path, or onto a new grid.  
% 
%% Before you use this function: 
% 
% This function requires the MEaSUREs InSAR-Based Antarctica Ice Velocity Map, Version 2
% netcdf dataset which can be downloaded here: <https://nsidc.org/data/NSIDC-0484>. 
% 
%% Syntax 
% 
%  speedi = measures_interp('speed',lati_or_xi,loni_or_yi)
%  [vxi,vyi] = measures_interp('velocity',lati_or_xi,loni_or_yi)
%  err = measures_interp('error',lati_or_xi,loni_or_yi)
%  count = measures_interp('count',lati_or_xi,loni_or_yi)
%  [u,v] = measures_interp('uv',lati_or_xi,loni_or_yi)
%  [along,across] = measures_interp('track',lati_or_xi,loni_or_yi)
%  [...] = measures_interp(...,'method',interpMethod) 
%  [...] = measures_interp(...,'fill') 
%
%% Description
% 
% |speedi = measures_interp('speed',lati_or_xi,loni_or_yi)| returns local
% surface velocity at the location(s) given by |lati,loni| or |xi,yi|. Input
% coordinates are determined as geographic or polar stereographic
% automatically by the |islatlon| function. 
% 
% |[vxi,vyi] = measures_interp('velocity',lati_or_xi,loni_or_yi)| returns the
% polar stereographic (true latitude 71S) x and y components of velocity. 
% 
% |err = measures_interp('error',lati_or_xi,loni_or_yi)| returns a scalar value
% of uncertainty estimates presented with the dataset. 
% 
% |count = measures_interp('count',lati_or_xi,loni_or_yi)| returns the count
% of scenes used per pixel. 
% 
% |[u,v] = measures_interp('uv',lati_or_xi,loni_or_yi)| returns the geographic 
% zonal (positive eastward) and meridional (positive northward) components
% of velocity. 
% 
% |[along,across] = measures_interp('track',lati_or_xi,loni_or_yi)| returns 
% velocity components along or across a specified track. This can be used to 
% estimate flow through (the across component) a flux gate or grounding line.  
% For the across-track component, positive values are to the right. 
% 
% |[...] = measures_interp(...,'method',interpMethod)| specifies any interpolation 
% supported by interp2. Default |interpMethod| is |'linear'|. 
% 
%% Example 1: South Pole station drift
% For a single location, interpolation is easy: 

measures_interp('speed',-90,0)

%% 
% which of course is exactly the same as 

measures_interp('speed',-90,100)

%% 
% and is very similar to 

measures_interp('speed',-90,0,'method','cubic')

%% 
% But differences in interpolation methods are tiny compared to the uncertainty 
% of InSAR or any satellite-based surface velocity measurements. The self-reported
% uncertainty at the South Pole is about 11 m/yr, see: 

measures_interp('error',-90,100)

%% Example 2: Ice speed on a custom grid
% You may be working with some other data set that has its own lat/lon
% grid. Here we consider a 500 km wide grid at 300 m resolution centered 
% on the Siple Coast:

% Create a grid: 
[x,y] = psgrid('siple coast',500,0.3,'xy'); 

% Get speed data at each grid point: 
speed = measures_interp('speed',x,y); 

% Plot: 
pcolor(x,y,log10(speed))
shading interp
axis equal
hold on

%% 
% It might also be nice to overlay some velocity vectors. Simply use
% Matlab's built-in |quiver| function.  But before we call |quiver|, let's 
% downsample the dataset because 1667x1667 little arrows would just end up 
% looking like a big black square, as each arrow would have to be less than
% a pixel wide.  There are a few ways to downsample.  You can simply create
% a much more coarse grid with |psgrid|, however there would be one tiny
% problem with that, which is aliasing--probably not much of an issue, but
% a proper way to deal with aliasing is to perform a low-pass filter before
% sampling.  If you have Matlab's Image Processing Toolbox, the |imresize|
% function automatically performs antialiasing that way, so we'll use
% |imresize| and to scale the 300 m grid to 2% of its resolution, or 15 km
% resolution.  Like this: 

% Get velocity components: 
[vx,vy] = measures_interp('velocity',x,y); 

% Plot quiver arrows on a 15 km grid: 
quiver(imresize(x,0.02),imresize(y,0.02),imresize(vx,0.02),imresize(vy,0.02),'k'); 

%% Example 3: Flux gate calculation of Thwaites Glacier mass loss
% To calculate mass flux across a grounding line, we first define a grounding line. 
% Here we use the grounding line from the Bedmap2 Toolbox and clip the data to include 
% only the region of Thwaites Glacier: 

load bedmap2gl

gllat = flipud(gllat{1}); 
gllon = flipud(gllon{1}); 
gllat = gllat(gllon>-108.5&gllon<-104.5); 
gllon = gllon(gllon>-108.5&gllon<-104.5); 

%% 
% For context, we can plot this grounding line on a |lima| image with
% velocity vectors overlaid. 

% Initialize a base map: 
figure
lima('thwaites glacier',150,'xy')
hold on

% Overlay black velocity vectors: 
measuresps('vel','k')

% Plot the segment of grounding line we're using: 
plotps(gllat,gllon,'g','linewidth',2) 

% Add text labels: 
textps(gllat(1),gllon(1),'start','color','g',...
    'fontweight','bold','backgroundcolor','w')
textps(gllat(end),gllon(end),'end','color','r',...
    'fontweight','bold','backgroundcolor','w')

%% 
% If we think of the grounding line as a path along which you might walk,
% the only component of ice flow that contributes to continental mass loss is the
% cross-path component. To estimate the volume of ice crossing the grounding line,
% interpolate the cross-track component of ice velocity along the entire path of 
% the grounding line, then multiply velocity by thickness for each unit length along the
% grounding line. 
% 
% First we define |x| as the distance you'd walk along the
% grounding line and |dx| is the approximate distance between points along
% the grounding line.  Here we use the <https://www.mathworks.com/matlabcentral/fileexchange/47638-antarctic-mapping-tools/content/AntarcticMappingTools/Documentation/html/pathdistps_documentation.html
% |pathdistps|> function to calculate the distance traveled along the
% grounding line. 

% Distance along grounding line: 
d = pathdistps(gllat,gllon); 

% Distance between each grounding line data point:
dx = gradient(d); 

crossTrackVelocity = measures_interp('cross',gllat,gllon);

thickness = bedmap2_interp(gllat,gllon,'thickness'); 
thickness(isnan(thickness))=0; % zero thickness where undefined

flowAcrossGL = crossTrackVelocity.*thickness;

figure 
plot(d/1000,flowAcrossGL)
xlabel('distance along grounding line (km)')
ylabel('flow across gl (m^3/yr per meter along grounding line)')
box off; axis tight; 

%% 
% Above, we see that sometimes ice flow is negative--that happens where a sinuous
% grounding line lets ice go over the ocean, then reground, then cross the grounding line
% again. 
% We can easily distill all this rich information down to a single value of mass
% loss if we ignore firn density and say that everything flowing across the
% grounding line is pure ice.  |massBalanceGT| is taken as the negative to
% indicate mass loss and multiplied by |1e-12| to convert from kg to GT. 

totalVolFlow = sum(flowAcrossGL.*dx);
iceDensity = 917; % kg/m3

massBalanceGT = totalVolFlow*iceDensity*1e-12 

%%
% This value is in close agreement with 113.5 GT/yr found by <http://www.sciencemag.org/content/341/6143/266
% Rignot et al., 2013>. 

%% Citing these datasets
% 
% VELOCITY DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2017. MEaSUREs InSAR-Based Antarctica Ice Velocity Map,
% Version 2. [Indicate subset used]. Boulder, Colorado USA. NASA National Snow and Ice Data Center 
% Distributed Active Archive Center. doi: http://dx.doi.org/10.5067/D7GK8F5J8M8R.
% 
% A LITERARY REFERENCE FOR THE VELOCITY DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011.Ice Flow of the Antarctic Ice Sheet, Science, 
% Vol. 333(6048): 1427-1430. doi:10.1126/science.1208336.
% 
% ANTARCTIC MAPPING TOOLS: 
% Greene, C.A., Gwyther, D.E. and Blankenship, D.D., 2016. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences.  http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% File history
% July 2014: First version written. 
% 
% August 2014: Updated as a plugin for Antarctic Mapping Tools. 
% 
% October 2016: Fully rewritten--Now reads data from the new measures_data 
% function, which reads the .nc file directly.
% 
% May 2017: Updated for data version 2. 
% 
%% Author Info 
% This function was written by <http://www.chadagreene.com Chad A. Greene> of the University of Texas
% Institute for Geophysics (<http://www.ig.utexas.edu/ UTIG>), July 2014. Rewritten October 2016 for
% efficiency and usability. 
