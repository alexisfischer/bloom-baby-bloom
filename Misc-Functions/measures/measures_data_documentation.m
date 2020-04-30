%% |measures_data| documentation
% |measures_data| imports MEaSUREs Antarctic surface velocity or grounding line data
% into your current Matlab workspace. 
% 
%% Before you use this function: 
% 
% This function requires the MEaSUREs InSAR-Based Antarctica Ice Velocity Map, Version 2
% netcdf dataset which can be downloaded here: <https://nsidc.org/data/NSIDC-0484>. 
% 
%% Citing these datasets: 
% 
% VELOCITY DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2017. MEaSUREs InSAR-Based Antarctica Ice Velocity Map,
% Version 2. [Indicate subset used]. Boulder, Colorado USA. NASA National Snow and Ice Data Center 
% Distributed Active Archive Center. doi: http://dx.doi.org/10.5067/D7GK8F5J8M8R. 
% 
% TWO LITERARY REFERENCES FOR THE VELOCITY DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011. Ice Flow of the Antarctic Ice Sheet, Science, 
% Vol. 333(6048): 1427-1430. doi:10.1126/science.1208336.
% 
% Mouginot, J., B. Scheuchl, and E. Rignot. 2012. Mapping of Ice Motion in Antarctica Using Synthetic-
% Aperture Radar Data, Remote Sensing. 4. 2753-2767. http://dx.doi.org/10.3390/rs4092753
% 
% GROUNDING LINE DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011. MEaSUREs Antarctic Grounding Line from Differential 
% Satellite Radar Interferometry. Boulder, Colorado USA: National Snow and Ice Data Center. 
% http://dx.doi.org/10.5067/MEASURES/CRYOSPHERE/nsidc-0498.001. 
% 
% A LITERARY REFERENCE FOR THE GROUNDING LINE DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011. Antarctic Grounding Line Mapping from Differential 
% Satellite Radar Interferometry. Geophyical Research Letters 38: L10504. doi:10.1029/2011GL047109.
% 
% ANTARCTIC MAPPING TOOLS: 
% Greene, C.A., Gwyther, D.E. and Blankenship, D.D. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences.  http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% Syntax 
% 
%  [lat,lon,V] = measures_data('speed')
%  [lat,lon,vx,vy] = measures_data('velocity')
%  [lat,lon,errx,erry] = measures_data('error')
%  [lat,lon,err] = measures_data('error')
%  [lat,lon,count] = measures_data('count')
%  [gllat,gllon,year] = measures_data('gl')
%  [...] = measures_data(...,lati,loni)
%  [...] = measures_data(...,lati,loni,extrakm)
%  [...] = measures_data(...,xi,yi)
%  [...] = measures_data(...,xi,yi,extrakm)
%  [x,y,...] = measures_data(...,'xy') 
%  [...] = measures_data(...,'v1')
% 
%% Description 
% 
% |[lat,lon,V] = measures_data('speed')| gives the surface speed (m/yr) grid corresponding
% to georeferenced coordinates |lat,lon|. 
% 
% |[lat,lon,vx,vy] = measures_data('velocity')| gives the surface velocity as x and y 
% components on a polar stereographic grid referenced to the geographic locations |lat,lon|. 
% Note: you can convert |vx| and |vy| to zonal and meridional components of velocity with 
% the AMT function |vxvy2uv|. 
% 
% |[lat,lon,errx,erry] = measures_data('error')| gives the polar stereographic x and y 
% components of the estimated error in m/yr. 
% 
% |[lat,lon,err] = measures_data('error')| gives the scalar value of estimated error in m/yr 
% (computed as the hypotenuse of |errx| and |erry|). 
% 
% |[lat,lon,count] = measures_data('count')| gives the count of scenes used per pixel. 
% 
% |[gllat,gllon,year] = measures_data('gl')| loads grounding line locations measured by InSAR. 
% The year corresponding to each datapoint is an optional output.  
% 
% |[...] = measures_data(...,lati,loni)| only loads data within the smallest polar stereographic 
% quadrangle bounding any data in |lati,loni|. This is convenient for loading only the data within
% current map extents or near some airborne survey lines. 
% 
% |[...] = measures_data(...,lati,loni,extrakm)| adds a specified number of kilometers to each side 
% of the quadrangle described above. The |extrakm| option can be a scalar to add, say, a 20 km frame 
% around your flight line, or it can have two elements such as [20 10] to specify 20 extra kilometers
% on the sides and 10 extra kilometers on the top and bottom. 
% 
% |[...] = measures_data(...,xi,yi)| same as above, but with polar stereographic meters (true lat 71 S)
% as inputs instead of geo coordinates.  Coordinates are automatically parsed by the |islatlon| function. 
% 
% |[...] = measures_data(...,xi,yi,extrakm)| again, as above, but with polar stereographic coordinates.  
% 
% |[x,y,...] = measures_data(...,'xy')| returns geolocation data as polar stereographic (true latitude 71 S) meters.  
% 
% |[...] = measures_data(...,'v1')| uses MEaSUREs version 1 gridded data if you have it. 
% 
%% Example 1a: Lambert Glacier speed
% Plot a 1000 km wide by 600 km high map of Lambert Glacier surface 
% speed. Start by getting the coordinates of Lambert Glacier: 

scarloc 'lambert glacier' 

%% 
% So we'll enter -71.5,69 into |measures_data| to get MEaSUREs data near
% Lambert Glacier. Note that for a 1000 km wide and 600 km tall dataset, you specify
% the center coordinates plus 500 on each side and 300 km on top and bottom: 

[lat,lon,speed] = measures_data('speed',-71.5,69,[500 300]); 

%% 
% The easiest way to plot this dataset is with the AMT function |pcolorps|: 

h = pcolorps(lat,lon,speed); 
axis tight

%% Example 1b: Overlay a grounding line
% Want a black grounding line?  You can get all the grounding line data within the 
% current limits of the figure simply by passing |xlim| and |ylim| to the |measures_data| 
% function, then plot with |plotps|: 

% Load the grounding line data: 
[gllat,gllon] = measures_data('gl',xlim,ylim); 

% Plot the grounding line data: 
hold on
plotps(gllat,gllon,'k-')
axis tight
scalebarps 

%% Example 2: A continent of uncertainty 
% If you don't want to subset the data, you can load the entire MEaSUREs dataset
% pretty easily.  However, it's a huge dataset, so it will take a second to load. 
% The best plotting function to can handle such a large dataset is |imagesc|, so
% we'll have to get the reference coordinates in x and y, which is always faster than
% plotting lats and lons for polar stereographic grids.

[x,y,err] = measures_data('error','xy'); 

%% 
% If you plot with |imagesc| you'll usually want to follow it with the |axis xy| command to make the
% up/down orientation correct.  I also use |axis image|, which properly sets the aspect ratio and 
% trims up any extra space.  

figure
h=imagesc(x,y,err); 
axis xy image

%% 
% To make it like Figure 3 in the <https://nsidc.org/data/docs/measures/nsidc0484_rignot/ documentation>, 
% simply add a colorbar and set the colorbar to jet (<https://twitter.com/hashtag/endrainbow #endtherainbow>).
% Unfortunately, this dataset does not distinguish between open ocean and
% bad data--it all has an uncertainty of zero.  We can make all the zero 
% values transparent.  

cb = colorbar;
ylabel(cb,'Error [m/yr]') 
colormap(jet(10))
caxis([1 17])
set(h,'alphadata',err>0)

%% 
% and as in Example 1 we can add a grounding line: 

[gllat,gllon] = measures_data('gl'); 
hold on
plotps(gllat,gllon,'k-')

%% Example 3: Grounding line migration
% Let's take a look at Pine Island Glacier.  Start by initializing a 100 km wide map 
% then load all the grounding line data within the extents of the map: 

figure
mapzoomps('pine island glacier','size',100)

[gllat,gllon,year] = measures_data('gl',xlim,ylim); 

%% 
% Use |scatterps| to plot the time dependence of the grounding line
% location: 

scatterps(gllat,gllon,6,year,'filled')
colorbar

%% 
% Perhaps you'd also like to add a quiver plot showing surface velocity.
% Start by getting the x and y components of velocity: 

[x,y,vx,vy] = measures_data('vel',xlim,ylim,'xy'); 

%% 
% And a grid of hundreds of arrows will be too cluttered to make any sense
% of, so I suggest downsampling the data.  Downsampling can be performed in a 
% cheap-and-dirty way by taking every Nth row and colum of data, but it's
% often easier to use the Image Processing Toolbox function |imresize|,
% which has the added benefit of automatic anti-aliasing. Let's only plot about
% 20% of the the data: 

scale = 0.2; % for 20%
x = imresize(x,scale); 
y = imresize(y,scale); 
vx = imresize(vx,scale); 
vy = imresize(vy,scale); 

%% 
% With a scaled-down dataset, plotting is easy with Matlab's built-in
% |quiver| function: 

hold on
quiver(x,y,vx,vy,'r') 

%% Citing these datasets: 
% If you use these datasets, please be sure to cite the following:
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
% GROUNDING LINE DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011.  MEaSUREs Antarctic Grounding Line from Differential 
% Satellite Radar Interferometry. Boulder, Colorado USA: National Snow and Ice Data Center. 
% doi: 10.5067/MEASURES/CRYOSPHERE/nsidc-0498.001. 
% 
% A LITERARY REFERENCE FOR THE GROUNDING LINE DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2011. Antarctic Grounding Line Mapping from Differential 
% Satellite Radar Interferometry. Geophyical Research Letters 38: L10504. doi:10.1029/2011GL047109.
% 
% ANTARCTIC MAPPING TOOLS: 
% Greene, C.A., Gwyther, D.E. and Blankenship, D.D., 2016. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences.  <http://dx.doi.org/10.1016/j.cageo.2016.08.003>
% 
%% Author Info
% This function and supporting documentation were written by <http://www.chadagreene.com Chad A. Greene> of 
% the University of Texas Institute for Geophysics (UTIG), October 2016.  Updated for Version 2 gridded data
% May 2017. 