function [out1,out2] = measures_interp(variable,lati_or_xi,loni_or_yi,varargin) 
% measures_interp interpolates MEaSUREs ice surface velocity data at
% any location(s), along a path, or onto a new grid.  
% 
%% Before you use this function: 
% 
% This function requires the MEaSUREs InSAR-Based Antarctica Ice Velocity Map, Version 2
% netcdf dataset which can be downloaded here: https://nsidc.org/data/NSIDC-0484. 
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
% speedi = measures_interp('speed',lati_or_xi,loni_or_yi) returns local
% surface velocity at the location(s) given by lati,loni or xi,yi. Input
% coordinates are determined as geographic or polar stereographic
% automatically by the islatlon function. 
% 
% [vxi,vyi] = measures_interp('velocity',lati_or_xi,loni_or_yi) returns the
% polar stereographic (true latitude 71S) x and y components of velocity. 
% 
% err = measures_interp('error',lati_or_xi,loni_or_yi) returns a scalar value
% of uncertainty estimates presented with the dataset. 
% 
% count = measures_interp('count',lati_or_xi,loni_or_yi) returns the count
% of scenes used per pixel. 
% 
% [u,v] = measures_interp('uv',lati_or_xi,loni_or_yi) returns the geographic 
% zonal (positive eastward) and meridional (positive northward) components
% of velocity. 
% 
% [along,across] = measures_interp('track',lati_or_xi,loni_or_yi) returns 
% velocity components along or across a specified track. This can be used to 
% estimate flow through (the across component) a flux gate or grounding line.  
% For the across-track component, positive values are to the right. 
% 
% [...] = measures_interp(...,'method',interpMethod) specifies any interpolation 
% supported by interp2. Default interpMethod is 'linear'. 
% 
%% Example
% 
% [x,y] = psgrid('siple coast',500,0.3,'xy'); 
% speed = measures_interp('speed',x,y); 
% [vx,vy] = measures_interp('velocity',x,y); 
% 
% pcolor(x,y,log10(speed))
% shading interp
% axis equal tight
% hold on
% quiver(imresize(x,0.02),imresize(y,0.02),imresize(vx,0.02),imresize(vy,0.02),'k'); 
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
% ANTARCTIC MAPPING TOOLS: 
% Greene, C.A., Gwyther, D.E. and Blankenship, D.D., 2016. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences.  http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% File history: 
% July 2014: First version written. 
% 
% August 2014: Updated as a plugin for Antarctic Mapping Tools. 
% 
% October 2016: Fully rewritten--Now reads data from the new measures_data 
% function, which reads the .nc file directly. From the user'sperspective, 
% this version is more sensical because it allows returning two velocity
% components at once, whereas previous versions required calling the 
% measures_interp function twice.
% 
% May 2017: Updated for the Version 2 dataset. 
% 
%% Author Info 
% This function was written by Chad A. Greene of the University of Texas
% Institute for Geophysics (UTIG). 
% http://www.chadagreene.com 
%
% See also measures_data and measuresps. 

%% Input checking: 

narginchk(3,5) 
nargoutchk(0,2) 
assert(isequal(size(lati_or_xi),size(loni_or_yi))==1,'Dimensions of input coordinates must agree.') 
assert(exist('ll2ps.m','file')==2,'Cannot find some essential tools from the Antarctic Mapping Tools package. Are you in the right folder?')

% Input coordinates: 
if islatlon(lati_or_xi,loni_or_yi)
   [xi,yi] = ll2ps(lati_or_xi,loni_or_yi); 
else
   xi = lati_or_xi; 
   yi = loni_or_yi; 
end

% Interpolation method: 
interpMethod = 'linear'; 
if nargin>3
   tmp = strncmpi(varargin,'method',4); 
   if any(tmp)
      interpMethod = varargin{find(tmp)+1}; 
      assert(isnumeric(interpMethod)==0,'Input error: It seems like you''ve entered a number as an interpolation method.')
   else
      % A message to tell users about updates: 
      if any(ismember(varargin,{'linear','lin','cub','cubic','nearest','spline'}))
         warning('There''s been a minor update to the measures_interp function. Now if you specify an interpolation method, it must be preceded by the word ''method''. I am continuing with linear interpolation.') 
      end
   end
end


% Make sure outputs match the requested variable: 
switch lower(variable)
   case {'vel','velocity'} 
      assert(nargout==2,'Input error: the ''velocity'' option returns two output variables. Did you intend to request ''speed''?') 
        
   case 'uv' 
      assert(nargout==2,'Input error: the ''uv'' option returns two output variables. Did you intend to request ''speed'' or something else?') 
        
   case 'track' 
      assert(nargout==2,'Input error: the ''track'' option returns two output variables. Did you intend to request ''speed'' or something else?') 
      assert(isvector(xi)==1,'Input error: If you request components of velocity relative to a track, the input path must be a vector.')
        
   case 'speed'
      assert(nargout<2,'Input error: the ''speed'' option only returns one output variable.  Did you intend to request ''velocity'' or something else?') 
      
   case {'unc','uncert','uncertainty','err','error'} 
      assert(nargout<2,'Input error: the ''uncertainty'' option only returns one output variable.  Did you intend to request ''velocity'' or something else?') 

   case {'count','co','cou'} 
      assert(nargout<2,'Input error: the ''count'' option only returns one output variable.  Did you intend to request ''velocity'' or something else?') 
 
   case 'u'
      assert(nargout<2,'Input error: the ''u'' option only returns one output variable.  Did you intend to request ''uv'' or something else?') 
        
   case 'v'
      assert(nargout<2,'Input error: the ''v'' option only returns one output variable.  Did you intend to request ''velocity'' or something else?') 
        
   case 'vx'
      assert(nargout<2,'Input error: the ''vx'' option only returns one output variable.  Did you intend to request ''velocity'' or something else?') 
        
   case 'vy'
      assert(nargout<2,'Input error: the ''vy'' option only returns one output variable.  Did you intend to request ''velocity'' or something else?') 
        
   case 'along' 
      assert(nargout<2,'Input error: the ''speed'' option only returns one output variable.  Did you intend to request ''velocity'' or something else?') 
      assert(isvector(xi)==1,'Input error: If you request components of velocity relative to a track, the input path must be a vector.')
        
   case {'across','cross'} 
      assert(nargout<2,'Input error: the ''speed'' option only returns one output variable.  Did you intend to request ''velocity'' or something else?') 
      assert(isvector(xi)==1,'Input error: If you request components of velocity relative to a track, the input path must be a vector.')

   otherwise 
      error('Input error: Unrecognized variable.')
       
end

%% Load data: 

extrakm = [3 3]; % Load an extra 3 kilometers of data on all sides to allow even the fanciest interpolation methods without screwing up the edges of the domain. 

% All options except 'vx', 'vy', and 'uncert' require loading vx AND vy: 
switch lower(variable)
   case 'vx'
      [x,y,Vx,~] = measures_data('velocity',lati_or_xi,loni_or_yi,extrakm,'xy'); 
      
   case 'vy'
      [x,y,~,Vy] = measures_data('velocity',lati_or_xi,loni_or_yi,extrakm,'xy'); 
      
   case {'unc','uncert','uncertainty','err','error'} 
      [x,y,Unc] = measures_data('error',lati_or_xi,loni_or_yi,extrakm,'xy');
      
   case 'count'
      [x,y,Unc] = measures_data('count',lati_or_xi,loni_or_yi,extrakm,'xy'); 
   
   otherwise 
      [x,y,Vx,Vy] = measures_data('velocity',lati_or_xi,loni_or_yi,extrakm,'xy'); 
      
end

%% Interpolate and transform if necessary: 

switch lower(variable)
   case {'vel','velocity'} 
      out1 = interp2(x,y,Vx,xi,yi,interpMethod); 
      out2 = interp2(x,y,Vy,xi,yi,interpMethod); 
        
   case 'uv' 
      [X,Y] = meshgrid(x,y); 
      [out1,out2] = vxvy2uv(X,Y,interp2(x,y,Vx,xi,yi,interpMethod),interp2(x,y,Vy,xi,yi,interpMethod)); 
        
   case 'track' 
      % Calculate along-track angles
      alongtrackdist = pathdistps(xi,yi);
      fx = gradient(xi,alongtrackdist); 
      fy = gradient(yi,alongtrackdist);
      theta = atan2(fy,fx);          

      % Interpolate x and y components of velocity: 
      vxi = interp2(x,y,Vx,xi,yi,interpMethod);
      vyi = interp2(x,y,Vy,xi,yi,interpMethod);

      % Convert x and y components to cross-track component: 
      out1 = vxi.*cos(theta) + vyi.*sin(theta);       
      out2 = vxi.*sin(theta) - vyi.*cos(theta); 
        
   case 'speed'
      out1 = interp2(x,y,hypot(Vx,Vy),xi,yi,interpMethod); 
      
   case {'unc','uncert','uncertainty','err','error','count'} 
      out1 = interp2(x,y,Unc,xi,yi,interpMethod); 

   case 'u'
      [X,Y] = meshgrid(x,y); 
      [out1,~] = vxvy2uv(X,Y,interp2(x,y,Vx,xi,yi,interpMethod),interp2(x,y,Vy,xi,yi,interpMethod)); 
        
   case 'v'
      [X,Y] = meshgrid(x,y); 
      [~,out1] = vxvy2uv(X,Y,interp2(x,y,Vx,xi,yi,interpMethod),interp2(x,y,Vy,xi,yi,interpMethod)); 
        
   case 'vx'
      out1 = interp2(x,y,Vx,xi,yi,interpMethod); 
        
   case 'vy'
      out1 = interp2(x,y,Vy,xi,yi,interpMethod); 
        
   case 'along' 
      % Calculate along-track angles
      alongtrackdist = pathdistps(xi,yi);
      fx = gradient(xi,alongtrackdist); 
      fy = gradient(yi,alongtrackdist);
      theta = atan2(fy,fx);          

      % Interpolate x and y components of velocity: 
      vxi = interp2(x,y,Vx,xi,yi,interpMethod);
      vyi = interp2(x,y,Vy,xi,yi,interpMethod);

      % Convert x and y components to along-track component: 
      out1 = vxi.*cos(theta) + vyi.*sin(theta); 
        
   case {'across','cross'} 
      % Calculate along-track angles
      alongtrackdist = pathdistps(xi,yi);
      fx = gradient(xi,alongtrackdist); 
      fy = gradient(yi,alongtrackdist);
      theta = atan2(fy,fx);          

      % Interpolate x and y components of velocity: 
      vxi = interp2(x,y,Vx,xi,yi,interpMethod);
      vyi = interp2(x,y,Vy,xi,yi,interpMethod);

      % Convert x and y components to cross-track component: 
      out1 = vxi.*sin(theta) - vyi.*cos(theta); 
        
   otherwise 
      error('I really don''t know how this error came about.  Really, it''s quite odd.')
       
end




end

