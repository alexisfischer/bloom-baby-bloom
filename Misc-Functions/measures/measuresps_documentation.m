%% |measuresps| documentation
% The |measuresps| function plots Antarctic ice surface speed as an imagesc plot in polar stereographic 
% coordinates (meters, true lat 71 S) or velocity vectors as a quiver plot. 
% 
%% Syntax 
% 
%  measuresps('gl') 
%  measuresps('gl',PropertyName,PropertyValue)
%  measuresps('speed') 
%  measuresps('speed','log') 
%  measuresps('speed','alpha',AlphaValue) 
%  measuresps('velocity') 
%  measuresps('velocity',QuiverProperty,QuiverValue) 
%  measuresps(...,'autoscale',false) 
%  measuresps(...,'km') 
%  h = measuresps(...)
% 
%% Description 
% 
% |measuresps('gl')| plots the InSAR-derived point of surface flexure, which is one way to 
% interpret the grounding line. 
% 
% |measuresps('gl',PropertyName,PropertyValue)| formats the grounding line with any properties
% recognized by the plot function (e.g., linewidth, markerstyle, color, etc.) 
% 
% |measuresps('speed')| plots gridded surface speed as an imagesc plot. 
% 
% |measuresps('speed','log')| plots surface speed as an imagesc plot using log base 10. 
% 
% |measuresps('speed','alpha',AlphaValue)| plots surface speed as a semitransparent imagesc plot,
% which can be useful when overlaying. 
% 
% |measuresps('velocity')| plots quiver arrows of velocity.  
% 
% |measuresps('velocity',QuiverProperty,QuiverValue)| specifies quiver properties such as color, 
% linewidth, etc. 
% 
% |measuresps(...,'autoscale',false)| turns off automatic downsampling of large datasets.  The 
% full MEaSUREs grid is over 12,000 x 12,000 grid cells, which is probably more pixels than 
% your screen can depict, so by default the measuresps function scales the dataset to be closer
% to about 3000x3000 pixels.  You're welcome to turn off the autoscaling, but plotting may be
% real slow. 
% 
% |measuresps(...,'km')| plots in polar stereographic kilometers rather than meters. 
% 
% |h = measuresps(...)| returns a handle |h| of plotted objects. 
% 
%% Example 1: Whole continent
% It's real easy make a continent-wide map of ice speed. This should do it: 

measuresps speed 

%% 
% And you can overlay things like the grounding line just as easily.  We'll make it a red
% grounding line by specifying |'r'|: 

measuresps('gl','r')

%% Example 2: Small region
% If you try to zoom in on the map created in Example 1, you'll see that the resolution is low.  If 
% you have a small region of interest, zoom a map to the region *before* calling |measuresps|, and that
% way |measuresps| will know to plot high-res data.  You can initialize a map like this:

figure
mapzoomps('george vi ice shelf')

%% 
% Or if you happen to have the |lima| plugin for Antarctic Mapping Tools, you can use
% LIMA as a base layer: 

lima('george vi ice shelf','xy')

%% 
% Add a layer of semitransparent (alpha = 0.5) ice speed, log-scaled:

measuresps('speed','log','alpha',0.5)

%% 
% Overlay a black grounding line: 

measuresps('gl','k')

%% 
% Add red velocity vectors and a scalebar

measuresps('velocity','color','r')
scalebarps('location','nw')

%% Citing these datasets: 
% 
% VELOCITY DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011. MEaSUREs InSAR-Based Antarctica Ice Velocity Map. 
% Boulder, Colorado USA: NASA DAAC at the National Snow and Ice Data Center. 
% doi:10.5067/MEASURES/CRYOSPHERE/nsidc-0484.001 
% 
% A LITERARY REFERENCE FOR THE VELOCITY DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011.Ice Flow of the Antarctic Ice Sheet, Science, 
% Vol. 333(6048): 1427-1430. doi:10.1126/science.1208336.
% 
% GROUNDING LINE DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011.  MEaSUREs Antarctic Grounding Line from Differential 
% Satellite Radar Interferometry. Boulder, Colorado USA: National Snow and Ice Data Center. 
% http://dx.doi.org/10.5067/MEASURES/CRYOSPHERE/nsidc-0498.001. 
% 
% A LITERARY REFERENCE FOR THE GROUNDING LINE DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011. Antarctic Grounding Line Mapping from Differential 
% Satellite Radar Interferometry. Geophyical Research Letters 38: L10504. doi:10.1029/2011GL047109.
% 
% ANTARCTIC MAPPING TOOLS: 
% Greene, C.A., Gwyther, D.E. and Blankenship, D.D., 2016. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences.  http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% Author Info 
% The |measuresps| function and supporting documentation were written by <http://www.chadagreene 
% Chad A. Greene> of the University of Texas Institute for Geophysics (UTIG), October 2016. 