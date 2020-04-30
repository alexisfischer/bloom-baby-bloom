%% |measures| documentation
% This function plots Antarctic surface velocity or grounding line data in a coordinate 
% system that requires Matlab's Mapping Toolbox.  If you don't have Matlab's Mapping Toolbox, 
% or even if you do, I recommend using <measuresps_documentation.html |measuresps|> instead--it's a better-written 
% function and does not require any toolboxes.  
% 
%% Syntax 
%
%  measures 'gltype'
%  measures('gltype','markerProperty',markerValue)
%  measures 'speed'
%  measures('speed',lat,lon)
%  measures('speed','locationString')
%  measures('speed',...,'mapwidth',mapwidth_km)
%  measures('speed',...'alpha',alphaValue) 
%  measures('speed',...'colormap',cmap)
%  measures('speed',...'colorbar',ColorbarOption)
%  measures('vel',lat,lon)
%  measures('vel','locationString')
%  measures('vel',...,'mapwidth',mapwidth_km)
%  measures('vel',...,'quivermcProperty',quivermcValue)
%  measures(...,'inset','insetLocation') 
%  h = measures(...)

%% Description 
%
% |measures 'gltype'| plots grounding lines specified by |'gl'|, which
% plots all grounding line data from the Measures project, or any of the
% following strings to specify a grounding line from a specific year:
% |'gl1992'|, |'gl1994'|, |'gl1995'|, |'gl1996'|, |'gl1999'|, or
% |'gl2007'|.
%
% |measures('gltype','markerProperty',markerValue)| formats the grounding
% line markerstyle properties with name-value pairs. 
%
% |measures 'speed'| plots a full continentsworth of ice speed data,
% downsampled to 4.5 km resolution. 
%
% |measures('speed',lat,lon)| plots a 500-kilometer-wide map of ice speed at 450 meter 
% resolution, centered at the location given by |lat|,|lon|.
%
% |measures('speed','locationString')| plots a 500-kilometer-wide map of ice speed at 450 meter 
% resolution, centered at the location given by |'locationString'|. With this
% syntax, |measures| uses the |scarloc| function to search the SCAR
% database for |'locationString'|. 
%
% |measures('speed',...,'mapwidth',mapwidth_km)| specifies the map width in
% kilometers. 
% 
% |measures('speed',...'alpha',alphaValue)| sets transparency of speed plot
% to an alpha value of 0 to 1.  0 is fully transparent; 1 is fully opaque. 
% 
% |measures('speed',...'colormap',cmap)| specifies a colormap (e.g.,
% |autumn(256)| )
% 
% |measures('speed',...'colorbar',ColorbarOption)| turns off colorbar if
% |'colorbar', 'off'| is declared. Alternatively, colorbar placement may be
% specified with any of the following |ColorbarOption| arguments: 
% 
% * |'EastOutside'|, |'vertical'|, or |'on'| Outside right
% * |'SouthOutside'| or |'horizontal'|  Outside bottom
% * |'North Inside'| plot box near top
% * |'South Inside'| bottom
% * |'East Inside'| right
% * |'West Inside'| left
% * |'NorthOutside'| Outside plot box near top
% * |'SouthOutside'| Outside bottom
% * |'WestOutside'| Outside left
%
% |measures('vel',lat,lon)| plots velocity vectors using the <http://www.mathworks.com/matlabcentral/fileexchange/47314-quivermc-colored-georeferenced-field-vectors/content/quivermc_documentation/html/quivermc_documentation.html 
% |quivermc|> function. 
%
% |measures('vel','locationString')| specifies map center location by its
% SCAR name. 
%
% |measures('vel',...,'mapwidth',mapwidth_km)| specifies width of a
% velocity map. 
%
% |measures('vel',...,'quivermcProperty',quivermcValue)| formats velocity
% vectors with |quivermc| name-value pairs. 
%
% |measures(...,'inset','insetLocation')| places an inset in a corner of
% the map given by cardinal location string (e.g. 'northwest' places an
% inset in the upper left hand corner of the map.) 
%
% |h = measures(...)| returns handles(s) |h| of plotted object(s). 
%

%% Requirements 
% This particular function requires Matlab's Mapping Toolbox and the
% Antarctic Mapping Tools package. 

%% Example 1: Mimic that plot we see all over the place
% Plotting continent-scale ice speed is simple (albeit somewhat slow). You can do it just like this:

measures speed 

%% 
% If you'd like to mimic Rignot et al.'s plot from their 2011 _Science_ paper, you can do it with
% <http://www.mathworks.com/matlabcentral/fileexchange/46874 |rgbmap|> and
% the |basins| function from the Bedmap2 Toolbox. Note that
% |measures| plots ice speed on a log10 scale, so the color bar needs some
% maual tweaks to get it right. In my use of the |rgbmap| function below, please 
% note that I'm guessing Rignot's colors the best that a colorblind person can...

rgbmap('pinkish brown','tan','light yellow','light grass green',...
    'aqua','dark blue','magenta','red',455);
basins

% fix the colorbar tick marks: 
cb = colorbar; 
set(cb,'location','north','position',[.15 .9 .35 .04],...
    'xtick',[log10(1.5) 1 2 3]','xticklabel',{num2str([1.5 10 100 1000]')},...
    'xgrid','on','gridlinestyle','-')
xlabel(cb,'velocity magnitude [m/yr]')

%% Example 2: Plot the speed of a specific region
% How fast is Totten Glacier moving?  

close % closes the plot we made in Example 1

measures('speed','totten glacier')

%% 
% Now let's overlay some velocity vectors

measures('velocity','totten glacier','units','m/a','inset','northwest') 

%% Example 3: Overlay |measures| velocity vectors on a |modismoa| image
% The |measures| function was designed to mate with the functions in the
% Bedmap2 Toolbox as well as <http://www.mathworks.com/matlabcentral/fileexchange/47282-modis-mosaic-of-antarctica/content/html/modismoa_demo.html
% |modismoa|>. Here we plot a 200-km-wide MODIS MOA image of Mertz Glacier
% Tongue and overlay velocity vectors.  For information on formatting
% velocity vectors, see the documentation for <http://www.mathworks.com/matlabcentral/fileexchange/47314-quivermc-colored-georeferenced-field-vectors/content/quivermc_documentation/html/quivermc_documentation.html 
% |quivermc|>.

close % closes the plot we made in Example 2

modismoa('mertz glacier tongue',200)
measures('velocity','mertz glacier tongue','mapwidth',200,...
    'colormap',jet(256),'arrowdensity',8)
scalebar('length',50,'color','w')

%% Example 4: Overlay semitransparent speed data on a MOA image
% The |modismoa| function takes over a figure's colormap with its
% grayscale, so overlaying another colormap requires help from the 
% <http://www.mathworks.com/matlabcentral/fileexchange/7943 |freezeColors|>
% function.  Here we overlay semitransparent speed data and some green
% velocity vectors on a |modismoa| image: 

figure
modismoa('pine island glacier',150)
freezeColors;
measures('speed','pine island glacier','mapwidth',150,'alpha',.15)
measures('vel','pine island glacier','mapwidth',150,'density',6,'color','g');
scalebar('length',25,'location','southeast','color','w')

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
% Computers & Geosciences. <http://dx.doi.org/10.1016/j.cageo.2016.08.003 doi:10.1016/j.cageo.2016.08.003>

%% Author Info 
% This function was written by Chad A. Greene of the Institute for
% Geophysics at the University of Texas in Austin (<http://www.ig.utexas.edu/research/cryosphere/ 
% UTIG>), July 2014. Updated August 2014 as a plugin for Antarctic Mapping
% Tools. 
