%% An Overview
% The MEaSUREs Toolbox is a plugin for Antarctic Mapping Tools for Matlab. 
% 
%% Functions in this toolbox 
% This toolbox contains the the following functions: 
% 
% * <measures_data_documentation.html |measures_data|> is a low-level function for loading MEaSUREs 
% surface velocity and grounding line data. 
% 
% * <measures_interp_documentation.html |measures_interp|> interpolates surface velocities to any location(s). 
% There are a few fancy interpolation options, including the ability to return zonal and meridional components
% of ice velocity, or the ability to return along-track and cross-track components of velocity relative to any
% arbitrary path.  
% 
% * <measures_displacement_documentation.html |measures_displacement|> estimates the location of ice parcel(s) after being
% advected for any amount of time. This is similar to the <https://www.mathworks.com/matlabcentral/fileexchange/53152-ice-flowlines/content/flowline/html/flowline_documentation.html 
% |flowline|> function, but |flowline| helps you figure out _when_ a parcel of ice will pass a point, whereas |measures_displacement|
% helps you figure out _where_ the ice will be after a given amount of time. 
% 
% * <measuresps_documentation.html |measuresps|> plots ice speed as color, ice velocity as vectors (quiver plot),
% or grounding line as line or marker objects. The |measuresps| function does not require any special toolboxes. 
% 
% * <measures_documentation.html |measures|> is the original measures plotting function, but it relies
% on Matlab's Mapping Toolbox, which is expensive and not terribly useful.  I'm trying to move away from dependence on the Mapping
% Toolbox, so expect dwindling support for this function in times to come. 
% 
% * <measuresann_interp_documentation.html |measuresann_interp|> interpolates Mouginot et al.'s MEaSUREs Annual Antarctic Ice 
% Velocity Maps 2005-2016, Version 1.
% 
%% Related functions
% Here are some related functions that are not in the MEaSUREs toolbox, but are also freely available
% plugins for Antarctic Mapping Tools: 
% 
% * <https://www.mathworks.com/matlabcentral/fileexchange/53152 |flowline|> is quite similar to the 
% |measures_displacement| function described above, but calculates flowlines rather than discrete points. 
% 
% * <https://www.mathworks.com/matlabcentral/fileexchange/60246 Antarctic Boundaries> comes from the same
% research group as the MEaSUREs InSAR data, but provides a consistent, nonbreaking grounding line around
% the continent. 
% 
% * MEaSUREs Annual Antarctic Ice Velocity Maps 2005-2016, Version 1. I have started on a Matlab implementation
% for this dataset, and by the time you read this, it will probably be on the Matlab File Exchange site. 
% 
% * Other grounding lines. Check File Exchange for other grounding lines because there are many, measured by
% different methods, and each has a slightly different meaning. Current grounding lines are listed <https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/47638/versions/20/previews/AntarcticMappingTools/Documentation/html/List_of_Functions.html?access_key=
% here>. 
% 
%% Installation 
% This toolbox does not require running any installation scripts, but you will need to download
% the surface velocity data and you'll need to make sure Matlab can find the data and these functions. 
% 
% 1. *Download the data:* Get the data from here: <https://nsidc.org/data/NSIDC-0484>. It's a file called
% antarctica_ice_velocity_450m_v2.nc. 
% 
% 2. *Add a path to the data and toolboxes:*  Different distributions of Matlab have different ways of 
% telling Matlab where to look for files.  There's one way to do it that works on all versions of Matlab, 
% but it requres a couple of steps: First, put all your AMT files into a directory, for me the filepath
% is |'/Users/chadgreene/Documents/MATLAB/AMT'| and in the |AMT| folder I have many subfolders with all the
% different AMT plugins.  To tell Matlab that it should always look in the |AMT| folder for data and functions, 
% create, go to your |MATLAB| directory and create a file called |startup.m|.  It must be called |startup.m|, 
% no other name will work, and it must be in the MATLAB folder.  In the |startup.m| file write a line like this: 
% 
%  addpath(genpath('/Users/chadgreene/Documents/MATLAB/AMT'));
% 
% But of course you'll want to make sure you change the filepath to match your own file structure. 
% 
%% Citing these datasets and functions 
% 
% VELOCITY DATA: 
% Rignot, E., J. Mouginot, and B. Scheuchl. 2017. MEaSUREs InSAR-Based Antarctica Ice Velocity Map,
% Version 2. [Indicate subset used]. Boulder, Colorado USA. NASA National Snow and Ice Data Center 
% Distributed Active Archive Center. doi: http://dx.doi.org/10.5067/D7GK8F5J8M8R. 
% 
% Mouginot, J., B. Scheuchl, and E. Rignot. 2017. MEaSUREs Annual Antarctic Ice Velocity Maps 2005-2016, Version 1.
% Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed Active Archive Center.
% http://dx.doi.org/10.5067/9T4EPQXTJYW9.
% 
% Literature Citations:
% Mouginot, J., E. Rignot, B. Scheuchl, and R. Millan. 2017. Comprehensive Annual Ice Sheet Velocity Mapping Using 
% Landsat-8, Sentinel-1, and RADARSAT-2 Data, Remote Sensing. 9. Art. #364. http://dx.doi.org/10.3390/rs9040364
% 
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
% Computers & Geosciences. <http://dx.doi.org/10.1016/j.cageo.2016.08.003 doi:10.1016/j.cageo.2016.08.003>.
% 
