function [out1,out2,out3] = measuresann_interp(variable,lati_or_xi,loni_or_yi,varargin)
% measuresann_interp provides annual surface velocities from Mouginot et al's MEaSUREs dataset. 
% 
%% Installation 
% This function requires all 11 of the .nc data files that make up Mouginot's MEaSUREs Annual Antarctic 
% Ice Velocity Maps 2005-2016, Version 1. Download them here (http://nsidc.org/data/NSIDC-0720) and put 
% them somewhere that Matlab can find them. Then you should be good to go. 
% 
%% Citing this data
% If this function is useful for you, please cite the dataset, the peer reviewed article, and Antarctic 
% Mapping Tools for Matlab. It can feel like overkill, but different individuals and entities get credit
% for the different roles they've played in making the data freely available. 
% 
% Dataset Citation: 
% Mouginot, J., B. Scheuchl, and E. Rignot. 2017. MEaSUREs Annual Antarctic Ice Velocity Maps 2005-2016, Version 1.
% Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed Active Archive Center.
% http://dx.doi.org/10.5067/9T4EPQXTJYW9.
% 
% Literature Citation:
% Mouginot, J., E. Rignot, B. Scheuchl, and R. Millan. 2017. Comprehensive Annual Ice Sheet Velocity Mapping Using 
% Landsat-8, Sentinel-1, and RADARSAT-2 Data, Remote Sensing. 9. Art. #364. http://dx.doi.org/10.3390/rs9040364
% 
% Antarctic Mapping Tools for Matlab: 
% Greene, C.A., Gwyther, D.E. and Blankenship, D.D. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences.  http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% Syntax 
% 
%  [vx,vy,t] = measuresann_interp('velocity',lati,loni)
%  [v,t] = measuresann_interp('speed',lati,loni)
%  [errx,erry,t] = measuresann_interp('error',lati,loni)
%  [count,t] = measuresann_interp('count',lati,loni)
%  [...] = measuresann_interp(variable,xi,yi) 
%  [...] = measuresann_interp(...,'method',InterpolationMethod) 
%  [...] = measuresann_interp(...,'inpaintnans') 
% 
%% Description 
% 
% [vx,vy,t] = measuresann_interp('velocity',lati,loni) gives the polar stereographic x and y components of ice 
% surface velocity at the geographic location(s) given by lati,loni. The output t vector is just 2006:2016. Each
% year corresponds to roughly January 1 of that year. In other words, the first value of t is 2006, indicating the 
% velocity measurements were acquired from mid 2005 to mid 2006. 
%
% [v,t] = measuresann_interp('speed',lati,loni) gives the scalar value of ice speed at the geographic location(s)
% given by lati,loni. Speed is calculated as v = hypot(vx,vy). 
%
% [errx,erry,t] = measuresann_interp('error',lati,loni) gives the x and y components of error estimates. 
% 
% [count,t] = measuresann_interp('count',lati,loni) gives the number of scenes used per pixel. 
% 
% [...] = measuresann_interp(variable,xi,yi) performs any of the above, but uses polar stereographic coordinates
% xi,yi in meters instead of lati,loni. Coordinates are automatically parsed by the islatlon function. 
%
% [...] = measuresann_interp(...,'method',InterpolationMethod) specifies an interpolation method. Default is 
% 'linear'. Differences between interpolation methods will probably never amount to a hill of beans compared
% to measurement uncertainties. 
% 
% [...] = measuresann_interp(...,'inpaintnans') attempts to fill in missing data using John D'Errico's inpaint_nans
% function. (The inpaint_nans function is already included in the measuresann_interp function.) I cannot guarantee
% the accuracy of this approach, but if you just have a few missing pixels it can reasonably fill in a little bit
% of missing data. For large domains, the inpaintnans option might be slow. 
% 
%% Usage note 
% This function will likely be slow for large geographic domains. If you're working on a specific glacier it will 
% probably be pretty quick, but the whole continent will be slower. 
% 
%% Example 
% Here's a time series of Pine Island Glacier surface velocity: 
% 
%   [lat,lon] = scarloc('pine island glacier'); 
%   [sp,t] = measuresann_interp('speed',lat,lon);
%   plot(t,sp,'ro-')
%   axis tight
%   box off
% 
%% More examples
% For more examples with pictures, type this into your command window: 
%
%   showdemo measuresann_interp_documentation
% 
%% Author Info
% This function was written by Chad A. Greene of the University of Texas Institute for 
% Geophysics (UTIG), May 2017. 
% 
% See also: measures_interp. 

%% Example 2: 
% [lati,loni] = psgrid('pine island glacier',200,0.5); 
% [sp,t] = measuresann_interp('speed',lati,loni);
% pcolorps(lati,loni,trend(sp,t,3));
% colorbar
% axis tight
% cmocean('bal','pivot')

% [vx,vy,t] = measuresann_interp('vel',lati,loni);

%% Filenames: 

f = {'Antarctica_ice_velocity_2005_2006_1km_v1.nc';
     'Antarctica_ice_velocity_2006_2007_1km_v1.nc';
     'Antarctica_ice_velocity_2007_2008_1km_v1.nc';
     'Antarctica_ice_velocity_2008_2009_1km_v1.nc';
     'Antarctica_ice_velocity_2009_2010_1km_v1.nc';
     'Antarctica_ice_velocity_2010_2011_1km_v1.nc';
     'Antarctica_ice_velocity_2011_2012_1km_v1.nc';
     'Antarctica_ice_velocity_2012_2013_1km_v1.nc';
     'Antarctica_ice_velocity_2013_2014_1km_v1.nc';
     'Antarctica_ice_velocity_2014_2015_1km_v1.nc';
     'Antarctica_ice_velocity_2015_2016_1km_v1.nc'}; 
  
%% Error checks 

narginchk(3,inf) 
nargoutchk(2,3)
assert(isequal(size(lati_or_xi),size(loni_or_yi))==1,'Input error: dimensions of coordinates must match.')
assert(isnumeric(variable)==0,'Input error: variable must be a string.') 
for k = 1:length(f)
   assert(exist(f{k},'file')==2,'Error: cannot find all of the velocity datasets. They should be named Antarctica_ice_velocity_2005_2006_1km_v1.nc or similar. Make sure Matlab can find the data, or download the .nc files here if necessary: http://nsidc.org/data/nsidc-0720.')
end

%% Set defaults: 

inpaint = false; 
InterpMethod = 'linear'; 

%% Parse inputs: 

if islatlon(lati_or_xi,loni_or_yi)
   [xi,yi] = ll2ps(lati_or_xi,loni_or_yi); 
else
   xi = lati_or_xi; 
   yi = loni_or_yi; 
end

switch lower(variable(1:3)) 
   case 'spe'
      assert(nargout<3,'Error: You are asking for too many outputs. Did you mean you want velocity instead of speed?') 
      varx = 'VX'; 
      vary = 'VY'; 
      
   case 'vel'
      assert(nargout==3,'Error: For velocity there must be three outouts: vx, vy, and t. Did you mean you want speed instead of velocity?')
      varx = 'VX'; 
      vary = 'VY'; 
      
   case 'err'
      assert(nargout==3,'Error: For error estimates there must be three outputs: errx, erry, and t. If you want the total magnitude of error, use hypot(errx,erry).') 
      varx = 'ERRX'; 
      vary = 'ERRY'; 
      
   case 'cou'
      assert(nargout<3,'Error: Too many outputs for counts.') 
      varx = 'CNT'; 
      vary = 'CNT'; % It's crude, but it uses way less lines of code to take the hypotenuse of the counts. Same answer, computationally slower, but probably not used very often. 
      
   otherwise
      error(['Unrecognized variable ',variable,'. Must be ''speed'', ''velocity'', ''error'', or ''count''.'])
end


if nargin>3
   if any(strncmpi(varargin,'inpaintnans',3))
      inpaint = true; 
      assert(exist('antarctica_ice_velocity_450m_v2.nc','file')==2,'Error: the inpaintnans option requires that you must also have the antarctica_ice_velocity_450m_v2.nc dataset.')
      warning('I will attempt to fill in missing data with inpaint_nans. This might be slow and the numbers it gives you could be totally bogus. Nonetheless, if you''re inpainting a few pixels of missing data that are surrounded by high-quality data, maybe it''s okay. Maybe.')
   end
   
   tmp = strncmpi(varargin,'method',4); 
   if any(tmp)
      InterpMethod = varargin{find(tmp)+1}; 
   end
   
   
end


%% Load data and interpolate: 

% Preallocate output: 
Vx = nan(size(xi,1),size(xi,2),length(f)); 
Vy = nan(size(xi,1),size(xi,2),length(f)); 

extrakm = [1 1]; 
stride = [1 1];  % This does not get changed. 
[start,count,x,y] = subset_range(xi,yi,extrakm); 

if inpaint
   [X,Y] = meshgrid(x,y); 
   % If you think about stretching a surface to fill in missing data, errors in that surface will be smaller if the surface
   % does not have much dynamic relief to begin with. So for our case, inpainting errors will be smaller if we inpaint the 
   % *difference* between individual measurements and some mean  reference value. For the reference, let's use the 
   % 'antarctica_ice_velocity_450m_v2.nc' dataset. 
   [refx,refy] = measures_interp('vel',X,Y); 
end

for k = 1:length(f) 
   tmpx = rot90(ncread(f{k},varx,start,count,stride));
   tmpy = rot90(ncread(f{k},vary,start,count,stride));
   
   if inpaint
      % We could inpaint tmpx and tmpy directly, but that would be prone to greater magnitude of errors: 
      tmpx = refx + inpaint_nans(tmpx-refx,4); 
      tmpy = refy + inpaint_nans(tmpy-refy,4); 
   end
   
   % Interpolate the raw data to xi,yi points: 
   Vx(:,:,k) = interp2(x,y,tmpx,xi,yi,InterpMethod); 
   Vy(:,:,k) = interp2(x,y,tmpy,xi,yi,InterpMethod); 
   
end

if numel(xi)==1
   Vx = squeeze(Vx); 
   Vy = squeeze(Vy); 
end

%% Package up the outputs: 

t = 2006:2016; 

if nargout<3
   out1 = hypot(Vx,Vy); 
   out2 = t; 
else
   out1 = Vx; 
   out2 = Vy; 
   out3 = t; 
end  

end
%% Subfunctions: 

function [start,count,x,y] = subset_range(xi,yi,extrakm) 
% This subset_range function returns stride and count arrays which are used 
% for inputs to ncread.  It also returns x and y spatial reference arrays. 
% Chad Greene, October 2016. 

   % x,y locations of full dataset: 
   x = -2800000:1000:2800000; 
   y = (2800000:-1000:-2800000)'; 

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







function B=inpaint_nans(A,method)
% INPAINT_NANS: in-paints over nans in an array
% usage: B=INPAINT_NANS(A)          % default method
% usage: B=INPAINT_NANS(A,method)   % specify method used
%
% Solves approximation to one of several pdes to
% interpolate and extrapolate holes in an array
%
% arguments (input):
%   A - nxm array with some NaNs to be filled in
%
%   method - (OPTIONAL) scalar numeric flag - specifies
%       which approach (or physical metaphor to use
%       for the interpolation.) All methods are capable
%       of extrapolation, some are better than others.
%       There are also speed differences, as well as
%       accuracy differences for smooth surfaces.
%
%       methods {0,1,2} use a simple plate metaphor.
%       method  3 uses a better plate equation,
%                 but may be much slower and uses
%                 more memory.
%       method  4 uses a spring metaphor.
%       method  5 is an 8 neighbor average, with no
%                 rationale behind it compared to the
%                 other methods. I do not recommend
%                 its use.
%
%       method == 0 --> (DEFAULT) see method 1, but
%         this method does not build as large of a
%         linear system in the case of only a few
%         NaNs in a large array.
%         Extrapolation behavior is linear.
%         
%       method == 1 --> simple approach, applies del^2
%         over the entire array, then drops those parts
%         of the array which do not have any contact with
%         NaNs. Uses a least squares approach, but it
%         does not modify known values.
%         In the case of small arrays, this method is
%         quite fast as it does very little extra work.
%         Extrapolation behavior is linear.
%         
%       method == 2 --> uses del^2, but solving a direct
%         linear system of equations for nan elements.
%         This method will be the fastest possible for
%         large systems since it uses the sparsest
%         possible system of equations. Not a least
%         squares approach, so it may be least robust
%         to noise on the boundaries of any holes.
%         This method will also be least able to
%         interpolate accurately for smooth surfaces.
%         Extrapolation behavior is linear.
%
%         Note: method 2 has problems in 1-d, so this
%         method is disabled for vector inputs.
%         
%       method == 3 --+ See method 0, but uses del^4 for
%         the interpolating operator. This may result
%         in more accurate interpolations, at some cost
%         in speed.
%         
%       method == 4 --+ Uses a spring metaphor. Assumes
%         springs (with a nominal length of zero)
%         connect each node with every neighbor
%         (horizontally, vertically and diagonally)
%         Since each node tries to be like its neighbors,
%         extrapolation is as a constant function where
%         this is consistent with the neighboring nodes.
%
%       method == 5 --+ See method 2, but use an average
%         of the 8 nearest neighbors to any element.
%         This method is NOT recommended for use.
%
%
% arguments (output):
%   B - nxm array with NaNs replaced
%
%
% Example:
%  [x,y] = meshgrid(0:.01:1);
%  z0 = exp(x+y);
%  znan = z0;
%  znan(20:50,40:70) = NaN;
%  znan(30:90,5:10) = NaN;
%  znan(70:75,40:90) = NaN;
%
%  z = inpaint_nans(znan);
%
%
% See also: griddata, interp1
%
% Author: John D'Errico
% e-mail address: woodchips@rochester.rr.com
% Release: 2
% Release date: 4/15/06


% I always need to know which elements are NaN,
% and what size the array is for any method
[n,m]=size(A);
A=A(:);
nm=n*m;
k=isnan(A(:));

% list the nodes which are known, and which will
% be interpolated
nan_list=find(k);
known_list=find(~k);

% how many nans overall
nan_count=length(nan_list);

% convert NaN indices to (r,c) form
% nan_list==find(k) are the unrolled (linear) indices
% (row,column) form
[nr,nc]=ind2sub([n,m],nan_list);

% both forms of index in one array:
% column 1 == unrolled index
% column 2 == row index
% column 3 == column index
nan_list=[nan_list,nr,nc];

% supply default method
if (nargin<2) || isempty(method)
  method = 0;
elseif ~ismember(method,0:5)
  error 'If supplied, method must be one of: {0,1,2,3,4,5}.'
end

% for different methods
switch method
 case 0
  % The same as method == 1, except only work on those
  % elements which are NaN, or at least touch a NaN.
  
  % is it 1-d or 2-d?
  if (m == 1) || (n == 1)
    % really a 1-d case
    work_list = nan_list(:,1);
    work_list = unique([work_list;work_list - 1;work_list + 1]);
    work_list(work_list <= 1) = [];
    work_list(work_list >= nm) = [];
    nw = numel(work_list);
    
    u = (1:nw)';
    fda = sparse(repmat(u,1,3),bsxfun(@plus,work_list,-1:1), ...
      repmat([1 -2 1],nw,1),nw,nm);
  else
    % a 2-d case
    
    % horizontal and vertical neighbors only
    talks_to = [-1 0;0 -1;1 0;0 1];
    neighbors_list=identify_neighbors(n,m,nan_list,talks_to);
    
    % list of all nodes we have identified
    all_list=[nan_list;neighbors_list];
    
    % generate sparse array with second partials on row
    % variable for each element in either list, but only
    % for those nodes which have a row index > 1 or < n
    L = find((all_list(:,2) > 1) & (all_list(:,2) < n));
    nl=length(L);
    if nl>0
      fda=sparse(repmat(all_list(L,1),1,3), ...
        repmat(all_list(L,1),1,3)+repmat([-1 0 1],nl,1), ...
        repmat([1 -2 1],nl,1),nm,nm);
    else
      fda=spalloc(n*m,n*m,size(all_list,1)*5);
    end
    
    % 2nd partials on column index
    L = find((all_list(:,3) > 1) & (all_list(:,3) < m));
    nl=length(L);
    if nl>0
      fda=fda+sparse(repmat(all_list(L,1),1,3), ...
        repmat(all_list(L,1),1,3)+repmat([-n 0 n],nl,1), ...
        repmat([1 -2 1],nl,1),nm,nm);
    end
  end
  
  % eliminate knowns
  rhs=-fda(:,known_list)*A(known_list);
  k=find(any(fda(:,nan_list(:,1)),2));
  
  % and solve...
  B=A;
  B(nan_list(:,1))=fda(k,nan_list(:,1))\rhs(k);
  
 case 1
  % least squares approach with del^2. Build system
  % for every array element as an unknown, and then
  % eliminate those which are knowns.

  % Build sparse matrix approximating del^2 for
  % every element in A.
  
  % is it 1-d or 2-d?
  if (m == 1) || (n == 1)
    % a 1-d case
    u = (1:(nm-2))';
    fda = sparse(repmat(u,1,3),bsxfun(@plus,u,0:2), ...
      repmat([1 -2 1],nm-2,1),nm-2,nm);
  else
    % a 2-d case
    
    % Compute finite difference for second partials
    % on row variable first
    [i,j]=ndgrid(2:(n-1),1:m);
    ind=i(:)+(j(:)-1)*n;
    np=(n-2)*m;
    fda=sparse(repmat(ind,1,3),[ind-1,ind,ind+1], ...
      repmat([1 -2 1],np,1),n*m,n*m);
    
    % now second partials on column variable
    [i,j]=ndgrid(1:n,2:(m-1));
    ind=i(:)+(j(:)-1)*n;
    np=n*(m-2);
    fda=fda+sparse(repmat(ind,1,3),[ind-n,ind,ind+n], ...
      repmat([1 -2 1],np,1),nm,nm);
  end
  
  % eliminate knowns
  rhs=-fda(:,known_list)*A(known_list);
  k=find(any(fda(:,nan_list),2));
  
  % and solve...
  B=A;
  B(nan_list(:,1))=fda(k,nan_list(:,1))\rhs(k);
  
 case 2
  % Direct solve for del^2 BVP across holes

  % generate sparse array with second partials on row
  % variable for each nan element, only for those nodes
  % which have a row index > 1 or < n
  
  % is it 1-d or 2-d?
  if (m == 1) || (n == 1)
    % really just a 1-d case
    error('Method 2 has problems for vector input. Please use another method.')
    
  else
    % a 2-d case
    L = find((nan_list(:,2) > 1) & (nan_list(:,2) < n));
    nl=length(L);
    if nl>0
      fda=sparse(repmat(nan_list(L,1),1,3), ...
        repmat(nan_list(L,1),1,3)+repmat([-1 0 1],nl,1), ...
        repmat([1 -2 1],nl,1),n*m,n*m);
    else
      fda=spalloc(n*m,n*m,size(nan_list,1)*5);
    end
    
    % 2nd partials on column index
    L = find((nan_list(:,3) > 1) & (nan_list(:,3) < m));
    nl=length(L);
    if nl>0
      fda=fda+sparse(repmat(nan_list(L,1),1,3), ...
        repmat(nan_list(L,1),1,3)+repmat([-n 0 n],nl,1), ...
        repmat([1 -2 1],nl,1),n*m,n*m);
    end
    
    % fix boundary conditions at extreme corners
    % of the array in case there were nans there
    if ismember(1,nan_list(:,1))
      fda(1,[1 2 n+1])=[-2 1 1];
    end
    if ismember(n,nan_list(:,1))
      fda(n,[n, n-1,n+n])=[-2 1 1];
    end
    if ismember(nm-n+1,nan_list(:,1))
      fda(nm-n+1,[nm-n+1,nm-n+2,nm-n])=[-2 1 1];
    end
    if ismember(nm,nan_list(:,1))
      fda(nm,[nm,nm-1,nm-n])=[-2 1 1];
    end
    
    % eliminate knowns
    rhs=-fda(:,known_list)*A(known_list);
    
    % and solve...
    B=A;
    k=nan_list(:,1);
    B(k)=fda(k,k)\rhs(k);
    
  end
  
 case 3
  % The same as method == 0, except uses del^4 as the
  % interpolating operator.
  
  % del^4 template of neighbors
  talks_to = [-2 0;-1 -1;-1 0;-1 1;0 -2;0 -1; ...
      0 1;0 2;1 -1;1 0;1 1;2 0];
  neighbors_list=identify_neighbors(n,m,nan_list,talks_to);
  
  % list of all nodes we have identified
  all_list=[nan_list;neighbors_list];
  
  % generate sparse array with del^4, but only
  % for those nodes which have a row & column index
  % >= 3 or <= n-2
  L = find( (all_list(:,2) >= 3) & ...
            (all_list(:,2) <= (n-2)) & ...
            (all_list(:,3) >= 3) & ...
            (all_list(:,3) <= (m-2)));
  nl=length(L);
  if nl>0
    % do the entire template at once
    fda=sparse(repmat(all_list(L,1),1,13), ...
        repmat(all_list(L,1),1,13) + ...
        repmat([-2*n,-n-1,-n,-n+1,-2,-1,0,1,2,n-1,n,n+1,2*n],nl,1), ...
        repmat([1 2 -8 2 1 -8 20 -8 1 2 -8 2 1],nl,1),nm,nm);
  else
    fda=spalloc(n*m,n*m,size(all_list,1)*5);
  end
  
  % on the boundaries, reduce the order around the edges
  L = find((((all_list(:,2) == 2) | ...
             (all_list(:,2) == (n-1))) & ...
            (all_list(:,3) >= 2) & ...
            (all_list(:,3) <= (m-1))) | ...
           (((all_list(:,3) == 2) | ...
             (all_list(:,3) == (m-1))) & ...
            (all_list(:,2) >= 2) & ...
            (all_list(:,2) <= (n-1))));
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(all_list(L,1),1,5), ...
      repmat(all_list(L,1),1,5) + ...
        repmat([-n,-1,0,+1,n],nl,1), ...
      repmat([1 1 -4 1 1],nl,1),nm,nm);
  end
  
  L = find( ((all_list(:,2) == 1) | ...
             (all_list(:,2) == n)) & ...
            (all_list(:,3) >= 2) & ...
            (all_list(:,3) <= (m-1)));
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(all_list(L,1),1,3), ...
      repmat(all_list(L,1),1,3) + ...
        repmat([-n,0,n],nl,1), ...
      repmat([1 -2 1],nl,1),nm,nm);
  end
  
  L = find( ((all_list(:,3) == 1) | ...
             (all_list(:,3) == m)) & ...
            (all_list(:,2) >= 2) & ...
            (all_list(:,2) <= (n-1)));
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(all_list(L,1),1,3), ...
      repmat(all_list(L,1),1,3) + ...
        repmat([-1,0,1],nl,1), ...
      repmat([1 -2 1],nl,1),nm,nm);
  end
  
  % eliminate knowns
  rhs=-fda(:,known_list)*A(known_list);
  k=find(any(fda(:,nan_list(:,1)),2));
  
  % and solve...
  B=A;
  B(nan_list(:,1))=fda(k,nan_list(:,1))\rhs(k);
  
 case 4
  % Spring analogy
  % interpolating operator.
  
  % list of all springs between a node and a horizontal
  % or vertical neighbor
  hv_list=[-1 -1 0;1 1 0;-n 0 -1;n 0 1];
  hv_springs=[];
  for i=1:4
    hvs=nan_list+repmat(hv_list(i,:),nan_count,1);
    k=(hvs(:,2)>=1) & (hvs(:,2)<=n) & (hvs(:,3)>=1) & (hvs(:,3)<=m);
    hv_springs=[hv_springs;[nan_list(k,1),hvs(k,1)]];
  end

  % delete replicate springs
  hv_springs=unique(sort(hv_springs,2),'rows');
  
  % build sparse matrix of connections, springs
  % connecting diagonal neighbors are weaker than
  % the horizontal and vertical springs
  nhv=size(hv_springs,1);
  springs=sparse(repmat((1:nhv)',1,2),hv_springs, ...
     repmat([1 -1],nhv,1),nhv,nm);
  
  % eliminate knowns
  rhs=-springs(:,known_list)*A(known_list);
  
  % and solve...
  B=A;
  B(nan_list(:,1))=springs(:,nan_list(:,1))\rhs;
  
 case 5
  % Average of 8 nearest neighbors
  
  % generate sparse array to average 8 nearest neighbors
  % for each nan element, be careful around edges
  fda=spalloc(n*m,n*m,size(nan_list,1)*9);
  
  % -1,-1
  L = find((nan_list(:,2) > 1) & (nan_list(:,3) > 1)); 
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
      repmat(nan_list(L,1),1,2)+repmat([-n-1, 0],nl,1), ...
      repmat([1 -1],nl,1),n*m,n*m);
  end
  
  % 0,-1
  L = find(nan_list(:,3) > 1);
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
      repmat(nan_list(L,1),1,2)+repmat([-n, 0],nl,1), ...
      repmat([1 -1],nl,1),n*m,n*m);
  end

  % +1,-1
  L = find((nan_list(:,2) < n) & (nan_list(:,3) > 1));
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
      repmat(nan_list(L,1),1,2)+repmat([-n+1, 0],nl,1), ...
      repmat([1 -1],nl,1),n*m,n*m);
  end

  % -1,0
  L = find(nan_list(:,2) > 1);
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
      repmat(nan_list(L,1),1,2)+repmat([-1, 0],nl,1), ...
      repmat([1 -1],nl,1),n*m,n*m);
  end

  % +1,0
  L = find(nan_list(:,2) < n);
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
      repmat(nan_list(L,1),1,2)+repmat([1, 0],nl,1), ...
      repmat([1 -1],nl,1),n*m,n*m);
  end

  % -1,+1
  L = find((nan_list(:,2) > 1) & (nan_list(:,3) < m)); 
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
      repmat(nan_list(L,1),1,2)+repmat([n-1, 0],nl,1), ...
      repmat([1 -1],nl,1),n*m,n*m);
  end
  
  % 0,+1
  L = find(nan_list(:,3) < m);
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
      repmat(nan_list(L,1),1,2)+repmat([n, 0],nl,1), ...
      repmat([1 -1],nl,1),n*m,n*m);
  end

  % +1,+1
  L = find((nan_list(:,2) < n) & (nan_list(:,3) < m));
  nl=length(L);
  if nl>0
    fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
      repmat(nan_list(L,1),1,2)+repmat([n+1, 0],nl,1), ...
      repmat([1 -1],nl,1),n*m,n*m);
  end
  
  % eliminate knowns
  rhs=-fda(:,known_list)*A(known_list);
  
  % and solve...
  B=A;
  k=nan_list(:,1);
  B(k)=fda(k,k)\rhs(k);
  
end

% all done, make sure that B is the same shape as
% A was when we came in.
B=reshape(B,n,m);

end
% ====================================================
%      end of main function
% ====================================================
% ====================================================
%      begin subfunctions
% ====================================================
function neighbors_list=identify_neighbors(n,m,nan_list,talks_to)
% identify_neighbors: identifies all the neighbors of
%   those nodes in nan_list, not including the nans
%   themselves
%
% arguments (input):
%  n,m - scalar - [n,m]=size(A), where A is the
%      array to be interpolated
%  nan_list - array - list of every nan element in A
%      nan_list(i,1) == linear index of i'th nan element
%      nan_list(i,2) == row index of i'th nan element
%      nan_list(i,3) == column index of i'th nan element
%  talks_to - px2 array - defines which nodes communicate
%      with each other, i.e., which nodes are neighbors.
%
%      talks_to(i,1) - defines the offset in the row
%                      dimension of a neighbor
%      talks_to(i,2) - defines the offset in the column
%                      dimension of a neighbor
%      
%      For example, talks_to = [-1 0;0 -1;1 0;0 1]
%      means that each node talks only to its immediate
%      neighbors horizontally and vertically.
% 
% arguments(output):
%  neighbors_list - array - list of all neighbors of
%      all the nodes in nan_list

if ~isempty(nan_list)
  % use the definition of a neighbor in talks_to
  nan_count=size(nan_list,1);
  talk_count=size(talks_to,1);
  
  nn=zeros(nan_count*talk_count,2);
  j=[1,nan_count];
  for i=1:talk_count
    nn(j(1):j(2),:)=nan_list(:,2:3) + ...
        repmat(talks_to(i,:),nan_count,1);
    j=j+nan_count;
  end
  
  % drop those nodes which fall outside the bounds of the
  % original array
  L = (nn(:,1)<1)|(nn(:,1)>n)|(nn(:,2)<1)|(nn(:,2)>m); 
  nn(L,:)=[];
  
  % form the same format 3 column array as nan_list
  neighbors_list=[sub2ind([n,m],nn(:,1),nn(:,2)),nn];
  
  % delete replicates in the neighbors list
  neighbors_list=unique(neighbors_list,'rows');
  
  % and delete those which are also in the list of NaNs.
  neighbors_list=setdiff(neighbors_list,nan_list,'rows');
  
else
  neighbors_list=[];
end

end

