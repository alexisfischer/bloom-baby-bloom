function [up,across] = rotate_current(u,v,angleV)
%
%   [up,across] = rotate_current(u,v,angleV)
%
%Function to rotate a coordinate system to lie along some new rotated angle
%angleV, relative to north.

%This m-file written by Soupy Alexander (11/2003) for U.S. Geological 
%Survey Data Series 74, Version 2.0. Updated by Soupy Dalyander (8/2008) 
%for U.S. Geological Survey Data Series 74, Version 3.0 (citation below).
%Soupy Dalyander previously Soupy Alexander.  

%This Matlab m-file was used to create portions of U.S. Geological Survey 
%Data Series 74, Version 3.0. Although this program has been used by the 
%USGS, no warranty, expressed or implied, is made by the USGS or the 
%United States Government as to the accuracy and functioning of the 
%program and related program material nor shall the fact of distribution 
%constitute any such warranty, and no responsibility is assumed by the 
%USGS in connection therewith.

%Citation:  Butman, Bradford, Dalyander, P.S., Bothner, M.H., Borden,
%Jonathan, Casso, M.A., Gutierrez, B.T., Hastings, M.E., Lightsom, F.L., 
%Martini, M.A., Montgomery, E.T, Rendigs, R.R., and Strahle, W.S., 2008, 
%Long-Term Oceanographic Observations in Massachusetts Bay, 1989—2006: 
%U.S. Geological Survey Data Series 74, Version 3.0, DVD-ROM. 
%Also online at http://pubs.usgs.gov/ds/74/.


%Convert u and v to angle and magnitude

[theta, mag] = cart2pol(u,v);
theta = theta*180/pi;

%Magnitude remains constant.  Convert to new theta

theta2 = theta - angleV;

%Compensate if new angle has passed 0 degrees

over_ang = find(theta2 > 360);
if isempty(over_ang) == 0;
    theta2(over_ang) = theta2(over_ang)-360;
end


%Reconfigure to new coordinate system
up = mag.*sin(theta2*(pi/180));
across = mag.*cos(theta2*(pi/180));
