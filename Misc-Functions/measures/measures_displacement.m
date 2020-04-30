function [lat1_or_x1,lon1_or_y1] = measures_displacement(lat0_or_x0,lon0_or_y0,dt_years,varargin) 
% measures_displacement estimates the horizontal location of a parcel of ice after a specified
% amount of time, based on InSAR surface velocities.  This function does not account for the vertical structure
% of ice velocity. 
% 
%% Before you use this function: 
% 
% This function requires the MEaSUREs InSAR-Based Antarctica Ice Velocity Map, Version 2
% netcdf dataset which can be downloaded here: https://nsidc.org/data/NSIDC-0484. 
% 
%% Syntax 
% 
%  [lat_end,lon_end] = measures_displacement(lat_start,lon_start,dt) 
%  [x_end,y_end] = measures_displacement(x_start,y_start,dt) 
%  
%% Description 
% 
% [lat_end,lon_end] = measures_displacement(lat_start,lon_start,dt) gives the geographic locations of points given by 
% lat_start,lon_start after dt years.  The dt variable can be negative if you'd like to estimate where a parcel
% of ice was dt years ago.
% 
% [x_end,y_end] = measures_displacement(x_start,y_start,dt) performs the same function described above, but returns
% values in polar stereographic meters if input coordinates are polar stereographic meters.  Coordinates are automatically 
% determined by the islatlon function. 
% 
%% Examples
% 
% Example 1: A grid after five years:
%
%    [lat0,lon0] = psgrid('pine island glacier',150,10); 
%    [lat5,lon5] = measures_displacement(lat0,lon0,5); 
% 
% Example 2: A single parcel of ice at different times in its life: 
%
%    t = -16:4:16; % every four years from 16 yr ago to 16 yr from now.
%    [x_t,y_t] = measures_displacement(-1587645,-257033,t); 
% 
%% Citing these datasets
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
% ANTARCTIC MAPPING TOOLS: 
% Greene, C.A., Gwyther, D.E. and Blankenship, D.D. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences.  http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% Author Info
% This function was written by Chad A. Greene of the University of Texas at Austin Institute for 
% Geophyisics (UTIG), December 2016.  Feel free to email me if you have any questions. 
% 
% See also measures_interp, measures_data, measuresps, and flowline. 

%% Error checks: 

narginchk(3,4)
nargoutchk(2,2) 
assert(isequal(size(lat0_or_x0),size(lon0_or_y0))==1,'Input error: Dimensions of input coordinates must agree.') 

if any(abs(dt_years(:))>1000)
   error('You are trying to solve for more than a millennium of ice displacement. I have a feeling you either entered days instead of years, or you''re seeking a solution which may be questionable.  A thousand years seems like too much.  I have not performed any sort of rigorous analysis to deem a thousand years too much, but it sure seems like errors in the velocity field would integrate, plus it would call the measures_interp function more than a thousand times, and that is computationally slow.  I recommend using the flowline function instead. Or, if you really want to, you can delete this error message and also change the years_of_simulation loop to a larger number. Good luck.')
end

if any(abs(dt_years(:))>365)
   warning('Just a heads up - you''re solving for more than 365 years of displacement. That''s fine, I''m working on a solution right now, but if you accidentally entered days instead of years, hit Ctrl+C to stop the solution, then retry with dt/365.') 
end
      
%% Parse inputs: 

if islatlon(lat0_or_x0,lon0_or_y0) 
   geo = true; % If geo is true, we'll convert back to geo at the end.  
   [x0,y0] = ll2ps(lat0_or_x0,lon0_or_y0); 
else
   geo = false; 
   x0 = lat0_or_x0; 
   y0 = lon0_or_y0; 
end

%% Perform mathematics: 

% Preallocate outputs by starting with initial condition: 
if isscalar(x0)
   x1 = x0*ones(size(dt_years)); 
   y1 = y0*ones(size(dt_years)); 
else
   x1 = x0; 
   y1 = y0; 
end

if isscalar(dt_years); 
   tminus = dt_years*ones(size(x1)); 
else
   tminus = dt_years; 
end


for years_of_simulation = 1:1000; 
   
   if any(abs(tminus(:))>0)
   
      % How big of a time step will we do this time through the loop?
      t_step = tminus; % Use the remaining time. 

      % Limit steps to one year, and we'll lose the sign, but that's okay we'll account for it later: 
      t_step(abs(t_step)>1) = sign(t_step(abs(t_step)>1)); 
   
      % Get the local velocity at each point: 
      [vx,vy] = measures_interp('velocity',x1,y1); 
         
      % Update coordinates as original coordinates plus 1 year's displacement (or less than 1 yr for any points with less than 1 year remaining in tminus) 
      x1 = x1 + vx.*t_step; 
      y1 = y1 + vy.*t_step; 
      
      % Update the amount of time remaining: 
      tminus = tminus-t_step; 
   
   else 
      break
   end
   
end

%% Clean up: 

if geo 
   [lat1_or_x1,lon1_or_y1] = ps2ll(x1,y1); 
else
   lat1_or_x1 = x1; 
   lon1_or_y1 = y1; 
end


end