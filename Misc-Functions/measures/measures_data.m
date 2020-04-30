function [lat_or_x,lon_or_y,out3,out4] = measures_data(dataset,varargin)
% measures_data imports MEaSUREs Antarctic surface velocity or grounding line data
% into your current Matlab workspace. 
% 
%% Before you use this function: 
% 
% This function requires the MEaSUREs InSAR-Based Antarctica Ice Velocity Map, Version 2
% netcdf dataset which can be downloaded here: https://nsidc.org/data/NSIDC-0484. 
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
% [lat,lon,V] = measures_data('speed') gives the surface speed (m/yr) grid corresponding
% to georeferenced coordinates lat,lon. 
% 
% [lat,lon,vx,vy] = measures_data('velocity') gives the surface velocity as x and y 
% components on a polar stereographic grid referenced to the geographic locations lat,lon. 
% Note: you can convert vx and vy to zonal and meridional components of velocity with 
% the AMT function vxvy2uv. 
% 
% [lat,lon,errx,erry] = measures_data('error') gives the polar stereographic x and y 
% components of the estimated error in m/yr. 
% 
% [lat,lon,err] = measures_data('error') gives the scalar value of estimated error in m/yr 
% (computed as the hypotenuse of errx and erry). 
% 
% [lat,lon,count] = measures_data('count') gives the count of scenes used per pixel. 
% 
% [gllat,gllon,year] = measures_data('gl') loads grounding line locations measured by InSAR. 
% The year corresponding to each datapoint is an optional output.  
% 
% [...] = measures_data(...,lati,loni) only loads data within the smallest polar stereographic 
% quadrangle bounding any data in lati,loni. This is convenient for loading only the data within
% current map extents or near some airborne survey lines. 
% 
% [...] = measures_data(...,lati,loni,extrakm) adds a specified number of kilometers to each side 
% of the quadrangle described above. The extrakm option can be a scalar to add, say, a 20 km frame 
% around your flight line, or it can have two elements such as [20 10] to specify 20 extra kilometers
% on the sides and 10 extra kilometers on the top and bottom. 
% 
% [...] = measures_data(...,xi,yi) same as above, but with polar stereographic meters (true lat 71 S)
% as inputs instead of geo coordinates.  Coordinates are automatically parsed by the islatlon function. 
% 
% [...] = measures_data(...,xi,yi,extrakm) again, as above, but with polar stereographic coordinates.  
% 
% [x,y,...] = measures_data(...,'xy') returns geolocation data as polar stereographic (true latitude 71 S) meters.  
% 
% [...] = measures_data(...,'v1') uses MEaSUREs version 1 gridded data if you have it. 
% 
%% Example 1: Lambert Glacier speed
% Plot a 1000 km wide by 600 km high map of Lambert Glacier (71.5S,69E) surface 
% speed. Start by getting the coordinates of Lambert Glacier.  Note that for a 
% 1000 km wide and 600 km tall dataset, you specify the center coordinates plus 
% 500 on each side and 300 km on top and bottom:
% 
%     [lat,lon,speed] = measures_data('speed',-71.5,69,[500 300]); 
%     pcolorps(lat,lon,speed)
%     axis tight
% 
% Now load grounding line data, but only load the data corresponding to the
% limits of the plot we just created above by passing xlim and ylim to the 
% measures_data function: 
% 
%     [gllat,gllon] = measures_data('gl',xlim,ylim); 
%     hold on
%     plotps(gllat,gllon,'k-')
%     axis tight
%     scalebarps 
% 
%% Example 2: A continent of uncertainty 
% If you don't want to subset the data, you can load the entire MEaSUREs dataset
% pretty easily.  However, it's a huge dataset, so it will take a second to load. 
% The best plotting function to can handle such a large dataset is imagesc, so
% we'll have to get the reference coordinates in x and y, which is always faster than
% plotting lats and lons for polar stereographic grids.
% 
%     [x,y,err] = measures_data('error','xy'); 
%     h=imagesc(x,y,err); 
%     axis xy equal tight
%     cb = colorbar;
%     ylabel(cb,'Error [m/yr]') 
%     colormap(jet(10))
%     caxis([1 17])
%     set(h,'alphadata',err>0)
% 
%% Example 3: Grounding line migration
% Let's take a look at Pine Island Glacier.  Start by initializing a 100 km wide map 
% then load all the grounding line data within the extents of the map: 
% 
%     mapzoomps('pine island glacier','size',100)
%     [gllat,gllon,year] = measures_data('gl',xlim,ylim); 
%     scatterps(gllat,gllon,6,year,'filled')
%     colorbar
% 
%% Author Info
% This toolbox was written by Chad A. Greene of the University of Texas
% Institute for Geophysics (UTIG), July 2014, rewritten in September 2016. 
% Updated May 2017 for the velocity dataset v2. 
% http://www.chadagreene.com.  Feel free to contact me if you have any 
% questions, comments, bug reports, or feature requests.  
% 
% See also: measures_inter and measuresps. 

%% Initial error checks: 

narginchk(1,7) 
nargoutchk(2,4) 
assert(isnumeric(dataset)==0,'Input error: requested dataset must be a string (e.g., ''speed'', ''error'', ''gl'', or ''velocity'').') 

%% Set defaults: 

subset = false;      % Is user requesting all data or a subset? 
xyout = false;       % Give output coordinates in ps71? 
extrakm = [0 0];     % extra buffer around subset data 
stride = [1 1];      % This does not get changed. 
v1 = false;          % Use version of gridded data 2 by default 

%% Parse inputs: 

if strcmpi(dataset,'gl'); 
   gridded_data = false; 
else
   gridded_data = true; 
end

if nargin>1 
   
   % Determine input coordinates: 
   if isnumeric(varargin{1}) % A clause in case varargin{1} is the 'xy'  option.
      subset = true; 
      lati_or_xi = varargin{1}; 
      loni_or_yi = varargin{2}; 

      % Are inputs georeferenced coordinates or polar stereographic?
      if ~islatlon(lati_or_xi,loni_or_yi)  
         xi = lati_or_xi;
         yi = loni_or_yi;    
      else
         [xi,yi] = ll2ps(lati_or_xi,loni_or_yi); % The ll2ps function is in the Antarctic Mapping Tools package. 
         
      end

      if nargin>3
         if isnumeric(varargin{3})
            extrakm = varargin{3}; % frame of extra data to include around input coordinates, in kilometers.   
            
            % Make extrakm into a two-element array in the form [extra_x extra_y]: 
            if isscalar(extrakm)
               extrakm = [extrakm extrakm]; 
            end
         end
      end
   end
    
   % Should output coodinates be in geo or ps71? 
   if any(strcmpi(varargin,'xy'))
      xyout = true; 
   end
   
   if any(strcmpi(varargin,'v1'))
      v1 = true; 
   end
   
end

%% Define data file names according to which version the user wants: 

% Check for which data version to use
if v1 
   filename = 'antarctica_ice_velocity_450m.nc';
   varnames.vx = 'vx'; 
   varnames.vy = 'vy'; 
else
   filename = 'antarctica_ice_velocity_450m_v2.nc'; 
   varnames.vx = 'VX'; 
   varnames.vy = 'VY'; 

   if exist(filename,'file')==0
      warning('Cannot find Version 2 of the velocity dataset. You can download it here: https://nsidc.org/data/NSIDC-0484, but for now I will check for Version 1.') 
      filename = 'antarctica_ice_velocity_450m.nc';
      assert(exist(filename,'file')==2,'Couldn''t find version 1 either. Download the data, make sure Matlab can find it, and try again.') 
   end
end
   
%% Determine indices for loading subset of gridded data: 

if gridded_data
   if subset
      [start,count,x,y] = subset_range(xi,yi,extrakm); % The subset_range subfunction appears at the bottom of this script. 
   else
      start = [1 1]; 
      count = [Inf Inf]; 
      x = -2800000:450:2800000; 
      y = (-2800000:450:2800000)'; 
   end
end

%% Load data: 

switch lower(dataset(1:2))
   case 'gl' 
            
      % It's slightly faster to load only the minimum required variables, so treat it differently if user doesn't want the years: 
      if nargout==3
         G = load('measuresgl.mat'); 
         out3 = G.year; 
      else
         G = load('measuresgl.mat','gllat','gllon'); 
      end
      
      % Package up the function outputs: 
      if xyout
         [lat_or_x,lon_or_y] = ll2ps(G.gllat,G.gllon); 
      else
         lat_or_x = G.gllat; 
         lon_or_y = G.gllon; 
      end
      
   case {'sp','ve'}
      vx = ncread(filename,varnames.vx,start,count,stride);
      vy = ncread(filename,varnames.vy,start,count,stride);
      switch nargout
         case 3
            out3 = double(rot90(hypot(vx,vy))); 
         case 4
            out3 = double(rot90(vx)); 
            out4 = double(rot90(vy)); 
         otherwise
            error('Incorrect number of outputs for velocity or speed datasets.') 
      end
                 
   case {'er','un'}
      if v1
         assert(nargout==3,'Error: For v1 data, you can only request a scalar value of error.') 
         out3 = double(rot90(ncread(filename,'err',start,count,stride)));
      else
         errx = ncread(filename,'ERRX',start,count,stride);
         erry = ncread(filename,'ERRY',start,count,stride);
      switch nargout
         case 3
            out3 = double(rot90(hypot(errx,erry))); 
         case 4
            out3 = double(rot90(errx)); 
            out4 = double(rot90(erry)); 
         otherwise
            error('Incorrect number of outputs for uncertainty dataset.') 
      end
         
      end
      
   case 'co'
      out3 = double(rot90(ncread(filename,'CNT',start,count,stride)));
      
   otherwise 
      error('Input error: Unrecognized dataset request. The first input must be ''gl'', ''speed'', ''velocity'', ''count'', or ''error''.') 
end


%% Finalize outputs: 

if gridded_data
   if xyout
      lat_or_x = x; 
      lon_or_y = y; 
   else 
      [X,Y] = meshgrid(x,y); 
      [lat_or_x,lon_or_y] = ps2ll(X,Y); 
   end
   
else 
   % Does the grounding line need to be subset? 
   if subset
      
      % Indices within the polar stereographic quadrangle: 
      ind = inpsquad(lat_or_x,lon_or_y,...
         [min(xi(:))-1000*extrakm(1) max(xi(:))+1000*extrakm(1)],...
         [min(yi(:))-1000*extrakm(2) max(yi(:))+1000*extrakm(2)],'inclusive'); 
      
      % Also maintain NaN separators: 
      ind = ind | isnan(lat_or_x); 
      
      % Trim the grounding line dataset: 
      lat_or_x = lat_or_x(ind); 
      lon_or_y = lon_or_y(ind); 
      if nargout==3
         out3 = out3(ind); 
      end
      
      % Now for small regions there might be long series of NaNs which previously separated small bits
      % elsewhere in the continent, but no longer serve any purpose. So we trim again: 
      trim = isnan(lat_or_x) & [0;diff(isnan(lat_or_x))]==0; 
      lat_or_x = lat_or_x(~trim); 
      lon_or_y = lon_or_y(~trim); 
      if nargout==3
         out3 = out3(~trim); 
      end
      
   end
end


end
%% Subfunctions: 

function [start,count,x,y] = subset_range(xi,yi,extrakm) 
% This subset_range function returns stride and count arrays which are used 
% for inputs to ncread.  It also returns x and y spatial reference arrays. 
% Chad Greene, October 2016. 

   % x,y locations of full dataset: 
   x = -2800000:450:2800000; 
   y = (2800000:-450:-2800000)'; 

   % Find index of point close to desired center in full dataset: 
   rowstart = interp1(x,1:length(x),min(xi(:))-1000*extrakm(1),'nearest');
   rowend = interp1(x,1:length(x),max(xi(:))+1000*extrakm(1),'nearest');
   colend = interp1(y,1:length(y),min(yi(:))-1000*extrakm(2),'nearest');
   colstart = interp1(y,1:length(y),max(yi(:))+1000*extrakm(2),'nearest');
   
   % Make sure starting and ending points do not extend beyond data: 
   rowstart = max([1 rowstart]); 
   colstart = max([1 colstart]); 
   rowend = min([12445 rowend]); 
   colend = min([12445 colend]); 
  
   % Convert starting and ending indices to start and count vectors for ncread: 
   start = [rowstart colstart]; 
   count = [rowend-rowstart+1 colend-colstart+1]; 
   
   % Clip the spatial reference vectors: 
   x = x(rowstart:rowend); 
   y = flipud(y(colstart:colend)); 

end

