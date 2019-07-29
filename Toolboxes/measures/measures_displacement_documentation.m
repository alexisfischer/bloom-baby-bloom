%% |measures_displacement| documentation
% The |measures_displacement| function predicts the horizontal location of a parcel of ice after a specified
% amount of time, based on InSAR surface velocities.  This function does not account for the vertical structure
% of ice velocity. 
% 
%% Before you use this function: 
% 
% This function requires the MEaSUREs InSAR-Based Antarctica Ice Velocity Map, Version 2
% netcdf dataset which can be downloaded here: <https://nsidc.org/data/NSIDC-0484>. 
% 
%% Syntax 
% 
%  [lat_end,lon_end] = measures_displacement(lat_start,lon_start,dt) 
%  [x_end,y_end] = measures_displacement(x_start,y_start,dt) 
% 
%% Description 
% 
% |[lat_end,lon_end] = measures_displacement(lat_start,lon_start,dt)| gives the geographic locations of points given by 
% |lat_start,lon_start| after |dt| years. The |dt| variable can be negative if you'd like to estimate where a parcel
% of ice was |dt| years ago.
% 
% [x_end,y_end] = measures_displacement(x_start,y_start,dt) performs the same function described above, but returns
% values in polar stereographic meters if input coordinates are polar stereographic meters. Coordinates are automatically 
% determined by the |islatlon| function. 
% 
%% Example 1: A grid after five years
% Consider this 10 km resolution grid, 150 km wide, centered on Pine Island Glacier.  

[lat0,lon0] = psgrid('pine island glacier',150,10); 

plotps(lat0,lon0,'kx')
axis tight off
hold on

%% 
% For context let's add a low-contrast MODIS MOA image with <http://www.mathworks.com/matlabcentral/fileexchange/47282-modis-mosaic-of-antarctica/content/modismoa/html/modismoaps_documentation.html |modismoaps|> and Mouginot et al's grounding line and coastline 
% with <http://www.mathworks.com/matlabcentral/fileexchange/60246-antarctic-boundaries--grounding-line--and-masks-from-insar/content/antbounds/html/antbounds_documentation.html |antbounds|>. 

modismoaps('contrast','low')
antbounds('gl','b')
antbounds('coast','b') 
scalebarps('color','w') 

%%
% Where will each of those black x marks be in five years?  

[lat5,lon5] = measures_displacement(lat0,lon0,5); 

plotps(lat5,lon5,'go')

%% 
% Having trouble linking the starting points to the end points?  Try this: 

plotps([lat0(:) lat5(:)]',[lon0(:) lon5(:)]','g-')

%% 
% It may be important to note, although I've just linked starting points with ending points using by single line segments, 
% the |measures_displacement| function actually solves for each year, so in the underlying math, there's actually five line
% segments connecting each starting point to each ending point.  The difference may be significant in fast-flowing regions
% with curving flow or over long periods of time.  

%% Example 2: A parcel of ice at specified times  
% Now consider this point near the grounding line of PIG.  I'll specify its location in polar stereographic 
% meters: 

x = -1587645; 
y = -257033; 

plot(x,y,'ro','linewidth',3)

%% 
% Its position as a function of time |t| is then: 

t = -16:4:16; % every four years from 16 yr ago to 16 yr from now.

[x_t,y_t] = measures_displacement(x,y,t); 

plot(x_t,y_t,'ro','linewidth',3)
text(x_t,y_t,num2str(t'),'fontsize',15,'color','r',...
   'fontweight','bold','vert','top')

%% 
% Above, you can see the ice stretching out as it speeds up.  You can also see that this function does *not* compute straight-line
% paths based purely on the velocity at the initial position. 

%% Comparison to the |flowline| function 
% There's another function on File Exchange called <https://www.mathworks.com/matlabcentral/fileexchange/53152-ice-flowlines/content/flowline/html/flowline_documentation.html |flowline|>,
% which is somewhat similar to this one and uses the same velocity data.  I'm not sure why I put it online as a separate function of its own, but that's the way it goes
% sometimes.  Here's a |flowline| solution starting at the x(t=-16),y(t=-16) location: 

[lat,lon] = flowline(x_t(1),y_t(1)); 
plotps(lat,lon,'r-','linewidth',3)

%% Example 3: Many locations, many times
% If neither the starting locations nor |dt| are scalars, |measures_displacement| will assume
% you want the displacement of many points, each with their own distinct |dt| value.  This might
% be for laser altimetry collected over multiple years, each data point collected at a different
% time.  
% 
% Here's a case that doesn't make much sense physically, but is a convenient example because 
% you already have the data.  I'm using the grounding line data and saying, let's look at the 
% location of each point advected some amount between minus five and plus five years.  I'll
% use the <https://www.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps/content/cmocean/html/cmocean_documentation.html |cmocean|> 
% function for a balanced colormap (Thyng et al. 2016). 

[gllat,gllon] = measures_data('gl',x,y,15); 
dt = linspace(5,-5,length(gllat))'; 
[lat,lon] = measures_displacement(gllat,gllon,dt); 
scatterps(lat,lon,20,dt,'linewidth',2)

cmocean('delta','pivot',0)
cb = colorbar; 
ylabel(cb,'years dt')

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
%% Author Info 
% This function and supporting documentation were written by <http://www.chadagreene.com Chad A. Greene> of the University of Texas
% Institute for Geophysics (UTIG), December 2016. 

