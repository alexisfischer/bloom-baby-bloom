%% |measuresann_interp| documentation 
% The |measuresann_interp| function provides annual surface velocities from Mouginot et al's MEaSUREs dataset. 
% 
%% Installation 
% This function requires all 11 of the .nc data files that make up Mouginot's MEaSUREs Annual Antarctic 
% Ice Velocity Maps 2005-2016, Version 1. Download them at <http://nsidc.org/data/NSIDC-0720> and put 
% them somewhere that Matlab can find them. Then you should be good to go. 
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
% |[vx,vy,t] = measuresann_interp('velocity',lati,loni)| gives the polar stereographic x and y components of ice 
% surface velocity at the geographic location(s) given by |lati,loni|. The output |t| vector is just |2006:2016|. Each
% year corresponds to roughly January 1 of that year. In other words, the first value of |t| is |2006|, indicating the 
% velocity measurements were acquired from mid 2005 to mid 2006. 
%
% |[v,t] = measuresann_interp('speed',lati,loni)| gives the scalar value of ice speed at the geographic location(s)
% given by |lati,loni|. Speed is calculated as |v = hypot(vx,vy)|. 
%
% |[errx,erry,t] = measuresann_interp('error',lati,loni)| gives the x and y components of error estimates. 
% 
% |[count,t] = measuresann_interp('count',lati,loni)| gives the number of scenes used per pixel. 
% 
% |[...] = measuresann_interp(variable,xi,yi)| performs any of the above, but uses polar stereographic coordinates
% |xi,yi| in meters instead of |lati,loni|. Coordinates are automatically parsed by the |islatlon| function. 
%
% |[...] = measuresann_interp(...,'method',InterpolationMethod)| specifies an interpolation method. Default is 
% |'linear'|. Differences between interpolation methods will probably never amount to a hill of beans compared
% to measurement uncertainties. 
% 
% |[...] = measuresann_interp(...,'inpaintnans')| attempts to fill in missing data using John D'Errico's |inpaint_nans|
% function. (The |inpaint_nans| function is already included in the |measuresann_interp| function.) I cannot guarantee
% the accuracy of this approach, but if you just have a few missing pixels it can reasonably fill in a little bit
% of missing data. For large domains, the |'inpaintnans'| option might be slow. 
% 
%% Usage note 
% This function will likely be slow for large geographic domains. If you're working on a specific glacier it will 
% probably be pretty quick, but the whole continent will be slower. 
% 
%% Example 1: Time series at a single location
% Here's a time series of Pine Island Glacier surface velocity. I'm using the AMT function |scaloc| to get the location
% of Pine Island Glacier. 

[lat,lon] = scarloc('pine island glacier'); 
[sp,t] = measuresann_interp('speed',lat,lon);
plot(t,sp,'ro-')
axis tight
box off

%% Example 2: Data grids
% If you enter more than one location, outputs will be 3D matrices, where the third dimension of the matrix corresponds
% to time. Output will be MxNx11 because there are 11 years of data in this dataset. 
% 
% Let's define a grid centered on PIG and make it 250x250, at 0.5 km resolution: 

[lati,loni] = psgrid('pine island glacier',250,0.5); 

%% Mean velocity
% Now we can get the speed and corresponding time vectors easily with |measuresann_interp|: 

[sp,t] = measuresann_interp('speed',lati,loni);

%% 
% Now we have |sp|, which is a 501x501x11 matrix. Plot the mean velocity from 2005 to 2016 like this: 

figure
pcolorps(lati,loni,mean(sp,3))
axis tight
measuresps('gl','color','k')
cb = colorbar; 
ylabel(cb,'mean surface velocity (m/a)') 

%% 
% There's quite a bit of missing data there. Actually, there's missing data wherever there are any less than 11 
% years of data. An easy workaround is to plot the |nanmean| of the velocity, but just be aware this approach
% is effectively making a mosaic of velocity measurements collected at different times. 

figure
pcolorps(lati,loni,nanmean(sp,3))
axis tight
measuresps('gl','color','k')
cb = colorbar; 
ylabel(cb,'mean surface velocity (m/a)') 

%% Velocity trends 
% To assess velocity trends I'm going to employ another one of my functions called <https://www.mathworks.com/matlabcentral/fileexchange/46363-trend
% |trend|>, which simply gives the linear least squares trend for 3D datasets. And we'll plot with a <https://www.mathworks.com/matlabcentral/fileexchange/57773 |cmocean|>
% (Thyng et al., 2016) balanced colormap: 

figure
pcolorps(lati,loni,trend(sp,t,3));
colorbar
axis tight
caxis([-100 100]) 
cmocean balance
cb = colorbar; 
ylabel(cb,'velocity trend m/a') 
measuresps('gl','color','k')

%% Inpainting missing data
% Unfortunately the |trend| function does not work anywhere there's a single missing data point. We could loop through
% each grid cell and calculate the trend of whatever datapoints are available, but then we'd be making a mosaic of trends
% obtained at different times. That's not an too much of an issue if you're making a mean velocity map, but trends can 
% be mighty sensitive to the time over which they're calculated. 
% 
% As a workaround the |measuresann_interp| function includes an option to fill missing data. I cannot guarantee this is
% a good idea everywhere, but it can provide some meaningful insights in some circumstances. Try recalculating with the
% |'inpaintnans'| option and then plot the trend just like we did above: 

[sp,t] = measuresann_interp('speed',lati,loni,'inpaintnans');

figure
pcolorps(lati,loni,trend(sp,t,3));
colorbar
axis tight
caxis([-100 100]) 
cmocean balance
cb = colorbar; 
ylabel(cb,'velocity trend m/a') 
measuresps('gl','color','k')

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
%% Author Info
% This function and supporting documentation were written by <http://www.chadagreene.com Chad A. Greene> of the University of Texas Institute for 
% Geophysics (UTIG), May 2017. 

