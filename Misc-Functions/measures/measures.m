function [h] = measures(mapvar,varargin) 
% measures plots Antarctic surface velocity or grounding line data in a coordinate 
% system that requires Matlab's Mapping Toolbox.  If you don't have Matlab's Mapping Toolbox, 
% or even if you do, I recommend using measuresps instead--it's a better-written 
% function, it's faster, and does not require a license for Matlab's Mapping Toolbox.  
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
%
%% Description 
%
% measures 'gltype' plots grounding lines specified by 'gl', which
% plots all grounding line data from the Measures project, or any of the
% following strings to specify a grounding line from a specific year:
% 'gl1992', 'gl1994', 'gl1995', 'gl1996', 'gl1999', or
% 'gl2007'.
%
% measures('gltype','markerProperty',markerValue) formats the grounding
% line markerstyle properties with name-value pairs. 
%
% measures 'speed' plots a full continentsworth of ice speed data,
% downsampled to 4.5 km resolution. 
%
% measures('speed',lat,lon) plots a 500-kilometer-wide map of ice speed at 450 meter 
% resolution, centered at the location given by lat,lon.
%
% measures('speed','locationString') plots a 500-kilometer-wide map of ice speed at 450 meter 
% resolution, centered at the location given by 'locationString'. With this
% syntax, measures uses the scarloc function to search the SCAR
% database for 'locationString'. 
%
% measures('speed',...,'mapwidth',mapwidth_km) specifies the map width in
% kilometers. 
% 
% measures('speed',...'alpha',alphaValue) sets transparency of speed plot
% to an alpha value of 0 to 1.  0 is fully transparent; 1 is fully opaque. 
% 
% measures('speed',...'colormap',cmap) specifies a colormap (e.g.,
% autumn(256))
% 
% measures('speed',...'colorbar',ColorbarOption) turns off colorbar if
% 'colorbar', 'off' is declared. Alternatively, colorbar placement may be
% specified with any of the following ColorbarOption arguments: 
% 
%   * 'EastOutside', 'vertical', or 'on' Outside right
%   * 'SouthOutside' or 'horizontal'  Outside bottom
%   * 'North Inside' plot box near top
%   * 'South Inside' bottom
%   * 'East Inside' right
%   * 'West Inside' left
%   * 'NorthOutside' Outside plot box near top
%   * 'SouthOutside' Outside bottom
%   * 'WestOutside' Outside left
%
% measures('vel',lat,lon) plots velocity vectors using the quivermc function. 
%
% measures('vel','locationString') specifies map center location by its
% SCAR name. 
%
% measures('vel',...,'mapwidth',mapwidth_km) specifies width of a
% velocity map. 
%
% measures('vel',...,'quivermcProperty',quivermcValue) formats velocity
% vectors with quivermc name-value pairs. 
%
% measures(...,'inset','insetLocation') places an inset in a corner of
% the map given by cardinal location string (e.g. 'northwest' places an
% inset in the upper left hand corner of the map.) 
%
% h = measures(...) returns handles(s) h of plotted object(s). 
%
%% Examples 
% 
% Plot surface speed: 
% measures('speed')
% 
% Add a grounding line: 
% measures('gl') 
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
% This function was written by Chad A. Greene of the Institute for
% Geophysics at the University of Texas in Austin, July 2014. 
% 
% See also measuresps, measures_data, and measures_interp. 

%% Initial Error checks:  

assert(license('test','map_toolbox')==1,'You must have Matlab''s Mapping Toolbox to use the measures function. But you''re in luck--the measuresps function is better and does not require any paid toolboxes.')
assert(isnumeric(mapvar)==0,'Input mapvar must be a string.') 
assert(exist('ll2ps.m','file')==2,'Cannot find Antarctic Mapping Tools. Did you put them in some other folder where Matlab can''t find them? If you do not have AMT, search the Mathworks File Exchange site for Antarctic Mapping Tools.')

%% Set defaults 

PlotWholeContinent = true; 
mapwidth = 500; 
inset = false; 

%% Parse inputs: 

if nargin>1
    if isnumeric(varargin{1})
        assert(isnumeric(varargin{2})==1,'Location must be given by lat, lon or location string.') 
        lati = varargin{1}; 
        loni = varargin{2}; 
        varargin(1:2)=[]; 
    end
end

tmp = strncmpi(varargin,'mapwidth',8)|strncmpi(varargin,'wid',3); 
if any(tmp) 
    mapwidth = varargin{find(tmp)+1}; 
    assert(isscalar(mapwidth)==1,'Map width must be a scalar value.')
    tmp(find(tmp)+1)=1; 
    varargin = varargin(~tmp);
    PlotWholeContinent = false; 
end

% Warn user if the map is too big: 
if mapwidth>1200
    proceedWithBigPlot = questdlg('That is a large map width and it may take a long time to render. Proceed?',...
	'Map Size Warning','Yes, try to plot it.','No, give up now.','No, give up now.');
    if strcmpi(proceedWithBigPlot,'No, give up now.')
        return
    end
end
    

tmp = strcmpi(varargin,'inset'); 
if any(tmp)
    insetLocation = varargin{find(tmp)+1}; 
    assert(isnumeric(insetLocation)~=1,'Inset Location must be a string.') 
    tmp(find(tmp)+1)=1; 
    varargin = varargin(~tmp);
    inset = true; 
end

            
%% Initialize map: 

try % Is a map already initialized? If not, initialize one: 
    mapinitialized = strcmpi(getm(gca,'MapProjection'),'stereo');
catch 
    antmap; 
    set(gca,'visible','off');
end
hold on; 

% Get corners of current map (we don't need all corners, just enough to use with inpsquad)  
[axlat,axlon] = minvtran(get(gca,'xlim'),get(gca,'ylim')); 

%% 
switch lower(mapvar) 
    case {'gl','grounding line','groundingline','grounding','g'}
        load measuresgl 
        
        % Get indices of lat,lon inside extents of current map: 
        glind = inpsquad(gllat,gllon,axlat,axlon); 
        h = plotm(gllat(glind),gllon(glind),'k.',varargin{:}); 
        
    case {'gl1992','gl 1992','1992 gl','1992gl'} 
        load measuresgl 
        
        % Get indices of lat,lon inside extents of current map: 
        glind = inpsquad(gllat,gllon,axlat,axlon); 
        gllat = gllat(glind); 
        gllon = gllon(glind); 
        
        h = plotm(gllat(year==1992),gllon(year==1992),'k.'); 
        set(h,varargin{:});
 
    case {'gl1994','gl 1994','1994 gl','1994gl'} 
        load measuresgl 
        
        % Get indices of lat,lon inside extents of current map: 
        glind = inpsquad(gllat,gllon,axlat,axlon); 
        gllat = gllat(glind); 
        gllon = gllon(glind); 
        
        
        h = plotm(gllat(year==1994),gllon(year==1994),'k.'); 
        set(h,varargin{:});
 
    case {'gl1995','gl 1995','1995 gl','1995gl'} 
        load measuresgl 
        
        % Get indices of lat,lon inside extents of current map: 
        glind = inpsquad(gllat,gllon,axlat,axlon); 
        gllat = gllat(glind); 
        gllon = gllon(glind); 
        
        
        h = plotm(gllat(year==1995),gllon(year==1995),'k.'); 
        set(h,varargin{:});
 
    case {'gl1996','gl 1996','1996 gl','1996gl'} 
        load measuresgl 
        h = plotm(gllat(year==1996),gllon(year==1996),'k.'); 
        set(h,varargin{:});

    case {'gl1999','gl 1999','1999 gl','1999gl'} 
        load measuresgl 
        
        % Get indices of lat,lon inside extents of current map: 
        glind = inpsquad(gllat,gllon,axlat,axlon); 
        gllat = gllat(glind); 
        gllon = gllon(glind); 
        
        
        h = plotm(gllat(year==1999),gllon(year==1999),'k.'); 
        set(h,varargin{:});
 
    case {'gl2007','gl 2007','2007 gl','2007gl'} 
        load measuresgl 
        
        % Get indices of lat,lon inside extents of current map: 
        glind = inpsquad(gllat,gllon,axlat,axlon); 
        gllat = gllat(glind); 
        gllon = gllon(glind); 
        
        
        h = plotm(gllat(year==2007),gllon(year==2007),'k.'); 
        set(h,varargin{:});
        
    case {'speed','pcolor','pcolorm','magnitude'}
        cmap = jet(256); 
        tmp = strcmpi(varargin,'colormap'); 
        if any(tmp) 
            cmap = varargin{find(tmp)+1}; 
            tmp(find(tmp)+1)=1; 
            varargin = varargin(~tmp);
        end

        colorbarOn = true; 
        cbLocation = 'EastOutside'; 
        tmp = strcmpi(varargin,'colorbar'); 
        if any(tmp) 
            cbLocation = varargin{find(tmp)+1}; 
            cbLocation = strrep(cbLocation,'vertical','WestOutside'); 
            cbLocation = strrep(cbLocation,'on','EastOutside'); 
            cbLocation = strrep(cbLocation,'horizontal','SouthOutside'); 
            if strcmpi(cbLocation,'off')
                colorbarOn = false; 
            end
            tmp(find(tmp)+1)=1; 
            varargin = varargin(~tmp);
        end

        faceAlpha = 1; 
        tmp = strncmpi(varargin,'facea',5)|strcmpi(varargin,'alpha'); 
        if any(tmp)
            faceAlpha=varargin{find(tmp)+1};
            assert(faceAlpha>=0&faceAlpha<=1,'Transparency alpha value must be between 0 and 1.') 
            tmp(find(tmp)+1) = 1; 
            varargin = varargin(~tmp); 
        end
        
        
            % Jan 2015: This block was just moved here from down below. 
            if ~exist('lati','var') & nargin>1
                [lati,loni] = scarloc(varargin{1}); 
                varargin(1)=[];
                if isempty(lati)
                    error('Measures cannot find the location you requested.') 
                end
                PlotWholeContinent = false; 
            end
            
        
        % Simple map of whole continent: 
        if PlotWholeContinent
               skip = 10; 
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
               speed = double(hypot(vx,vy)); 
               speed(unc==0)=NaN; 
               [xr,yr] = meshgrid(x,y); 
               [lat,lon] = ps2ll(xr,yr); 
        end
        
        % Map of a small area: 
        if ~PlotWholeContinent
            [lat,lon,speed] = measures_data('speed',lati,loni,mapwidth/2); 
            speed(speed==0)=NaN; 

        end
        h = pcolorm(lat,lon,log10(speed),'facealpha',faceAlpha);

        colormap(cmap);
        caxis(log10([1 3000]))
        if colorbarOn
            cb = colorbar('location',cbLocation);
            switch lower(cbLocation)
                case {'east','west','eastoutside','westoutside'}
                    set(cb,'ytick',[0 1 2 3]','yticklabel',{num2str([1 10 100 1000]')})
                    ylabel(cb,'speed (m/a)')

                case {'north','south','northoutside','southoutside'}
                    set(cb,'xtick',[0 1 2 3]','xticklabel',{num2str([1 10 100 1000]')})
                    xlabel(cb,'speed (m/a)')

                otherwise
                    error('Invalid colorbar location.')
            end
        end
                
        
    case {'vel','velocity','vector'} 
        if nargin==1
            error('Not enough input arguments for velocity vector map--a vector map should depict an area less than 2000 km wide.')
        end
        if nargin>1
            if ~exist('lati','var')
                [lati,loni] = scarloc(varargin{1}); 
                varargin(1)=[];
                if isempty(lati)
                    error('modismoa cannot find the location you requested.') 
                end
            end

            [lat,lon,vx,vy] = measures_data('velocity',lati,loni,mapwidth/2); 
            [U,V] = vxvy2uv(lat,lon,vx,vy); 
            h = quivermc(lat,lon,U,V,varargin{:}); 
        end
        
    otherwise
        error('Unrecognized input for mapvar.') 
        
end

%% Zoom to region

if exist('lati','var') 
    if inset==false
        mapzoom(lati,loni,mapwidth)
    end
    if inset==true
        mapzoom(lati,loni,mapwidth,'inset',insetLocation);
    end
end


%% Clean up: 

if nargout == 0
    clear h
end

end
