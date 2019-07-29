function h = measuresps(variable,varargin) 
% measuresps plots Antarctic ice surface speed as an imagesc plot in polar stereographic 
% coordinates (meters, true lat 71 S) or velocity vectors as a quiver plot.  
% 
%% Before you use this function: 
% 
% This function requires the MEaSUREs InSAR-Based Antarctica Ice Velocity Map, Version 2
% netcdf dataset which can be downloaded here: https://nsidc.org/data/NSIDC-0484. 
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
% measuresps('gl') plots the InSAR-derived point of surface flexure, which is one way to 
% interpret the grounding line. 
% 
% measuresps('gl',PropertyName,PropertyValue) formats the grounding line with any properties
% recognized by the plot function (e.g., linewidth, markerstyle, color, etc.) 
% 
% measuresps('speed') plots gridded surface speed as an imagesc plot. 
% 
% measuresps('speed','log') plots surface speed as an imagesc plot using log base 10. 
% 
% measuresps('speed','alpha',AlphaValue) plots surface speed as a semitransparent imagesc plot,
% which can be useful when overlaying. 
% 
% measuresps('velocity') plots quiver arrows of velocity.  
% 
% measuresps('velocity',QuiverProperty,QuiverValue) specifies quiver properties such as color, 
% linewidth, etc. 
% 
% measuresps(...,'autoscale',false) turns off automatic downsampling of large datasets.  The 
% full MEaSUREs grid is over 12,000 x 12,000 grid cells, which is probably more pixels than 
% your screen can depict, so by default the measuresps function scales the dataset to be closer
% to about 3000x3000 pixels.  You're welcome to turn off the autoscaling, but plotting may be
% real slow. 
% 
% measuresps(...,'km') plots in polar stereographic kilometers rather than meters. 
% 
% h = measuresps(...) returns a handle h of plotted objects. 
% 
%% Examples 
% Plot ice surface speed as semi-transparent log-scaled color, then overlay a black grounding line 
% and red vectors to show ice motion.  Start by centering the map on a location, like George VI Ice Shelf:
% 
% mapzoomps('george vi ice shelf')
% measuresps('speed','log','alpha',.5)
% measuresps('gl','k')
% measuresps('velocity','color','r')
% scalebarps('location','se')
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
% This function was written by Chad A. Greene of the University of Texas
% Institute for Geophysics (UTIG). October 2016. 
% http://www.chadagreene.com 
%
% See also measures_data and measures_interp. 

%% Error checks: 

assert(exist('ll2ps.m','file')==2,'Error: Cannot find Antarctic Mapping Tools for Matlab. Make sure AMT is in a folder where Matlab can find it.') 
assert(isnumeric(variable)==0,'Input error: variable must be either ''gl'', ''speed'', or ''velocity''.') 
assert(exist('antarctica_ice_velocity_450m_v2.nc','file')==2,'Error: cannot find antarctica_ice_velocity_450m_v2.nc. Get it here https://nsidc.org/data/NSIDC-0484 and make sure Matlab can find it.')
nargoutchk(0,1)
narginchk(1,Inf)

%% Input parsing: 

% Plot in kilometers? 
tmp = strcmpi(varargin,'km'); 
if any(tmp)
   km = true;
   varargin = varargin(~tmp); 
else
   km = false; 
end

% Has the user declared a facealpha value? 
tmp = strncmpi(varargin,'alpha',3); 
if any(tmp)
   alph = varargin{find(tmp)+1}; 
   assert(isscalar(alph)==1,'Input error: alpha value must be a scalar between zero and 1.')
   assert(alph>=0,'Input error: alpha value must be between zero and one.') 
   assert(alph<=1,'Input error: alpha value must be between zero and one.') 
   tmp(find(tmp)+1)=1; 
   varargin = varargin(~tmp); 
else 
   alph = 1; 
end

tmp = strncmpi(varargin,'autoscale',4); 
if any(tmp)
   autoscale = varargin{find(tmp)+1}; 
   assert(islogical(autoscale)==1,'Input error: autoscale argument must be true or false.') 
   tmp(find(tmp)+1)=1; 
   varargin = varargin(~tmp); 
else 
   autoscale = true; 
end 

% Plot in kilometers? 
tmp = strcmpi(varargin,'log'); 
if any(tmp)
   logplot = true;
   varargin = varargin(~tmp); 
else
   logplot = false; 
end

%% Get the lay of the land: 

% Get the hold state: 
hld = ishold; 
hold on

% Does a map already exist, or are we creating something from scratch? 
ax = axis; 
if isequal(ax,[0 1 0 1])
   ax = [-1 1 -1 1]*2800000;
   if km
      axis(ax/1000)
   else
      axis(ax)
   end
   newmap = true;
else
   newmap = false; 
   if km
      ax = ax*1000; 
   end
end

% Data aspect ratio: 
da = daspect; 
da = [1 1 da(3)]; 

%% Load data: 

if strcmpi(variable,'gl'); 
   [glx,gly] = measures_data('gl',ax(1:2),ax(3:4),'xy'); 
   
   if km
      glx = glx/1000; 
      gly = gly/1000; 
   end
   
else

   % We'll end up using uncertainty==0 as a mask for invalid data: 
   if newmap
      skip = 5; 
      x = -2800000:450*skip:2800000; 
      y = (-2800000:450*skip:2800000)'; 

      % Strangely, loading the whole file then downsampling is faster than loading with any stride value less than 8:
      tmpx = ncread('antarctica_ice_velocity_450m_v2.nc','ERRX');
      tmpy = ncread('antarctica_ice_velocity_450m_v2.nc','ERRY');
      unc = hypot(tmpx,tmpy); 
      unc = rot90(unc(1:skip:end,1:skip:end));

      vx = ncread('antarctica_ice_velocity_450m_v2.nc','VX');
      vx = rot90(vx(1:skip:end,1:skip:end)); 
      vy = ncread('antarctica_ice_velocity_450m_v2.nc','VY');
      vy = rot90(vy(1:skip:end,1:skip:end)); 

   else
      [x,y,unc] = measures_data('err',ax(1:2),ax(3:4),'xy'); 
      [~,~,vx,vy] = measures_data('velocity',ax(1:2),ax(3:4),'xy'); 
   end

   % Convert if plotting in kilometers: 
   if km
      x = x/1000; 
      y = y/1000; 
   end

   % Downsample if the dataset is real large: 
   if autoscale
      maxpx = 10e6; 
      px = numel(unc); 
      if px>maxpx
         skip = round(px/maxpx); 
         if strncmpi(variable,'speed',3); 
            warning(['That''s a large velocity dataset which would slow your computer down if I plot the whole thing. I''m downsampling to ',num2str(450*skip),' m resolution.  If you prefer to plot the full resolution data, specify ''autoscale'',false.'])
         end
         x = x(1:skip:end); 
         y = y(1:skip:end); 
         unc = unc(1:skip:end,1:skip:end); 
         vx = vx(1:skip:end,1:skip:end); 
         vy = vy(1:skip:end,1:skip:end); 
      end
   end

end
   
%% Plot data: 

switch lower(variable(1:2)) 
   case 'gl'
      h = plot(glx,gly,varargin{:}); 
      
   case 'sp' 
      alph = alph*double(isfinite(vx)); 
      if logplot
         h = imagesc(x,y,log10(hypot(vx,vy))); 
         caxis(log10([1 max(hypot(vx(:),vy(:)))]))
      else
         h = imagesc(x,y,hypot(vx,vy)); 
      end
      axis xy 
      
      set(h,'AlphaData',alph); 
      
   case 've'
      
      % Downsample quiver dataset to about 30x30. The Image Processing Toolbox function imresize anti-aliases, but if user doesn't have a license, just resample by every Nth datapoint.   
      if license('test','image_toolbox')==1
         sc = 30/length(x); 
         x = imresize(x,sc); 
         y = imresize(y,sc); 
         vx = imresize(vx,sc); 
         vy = imresize(vy,sc); 
         unc = imresize(unc,sc); 
      else
      
         skip = round(size(unc,1)/30); 
         unc = unc(1:skip:end,1:skip:end); 
         x = x(1:skip:end); 
         y = y(1:skip:end); 
         vx = vx(1:skip:end,1:skip:end); 
         vy = vy(1:skip:end,1:skip:end); 
      end
      
      % Zero values are not necessarily zero ice motion, but in most cases are actually bad data or ocean: 
      vx(unc==0) = NaN; 
      vy(unc==0) = NaN; 
      
      h = quiver(x,y,vx,vy,varargin{:}); 
      
   otherwise
      error('Input error: Unrecognized variable. The only options are ''gl'', ''speed'', or ''velocity''.') 
end

daspect(da); 

%% Clean up 

% Return hold state: 
if ~hld
   hold off
end

if nargout==0
   clear h
end

end