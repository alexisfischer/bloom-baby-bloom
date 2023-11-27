function [u,v] = UVfromDM(Dir,Mag)
% UVFROMDM [u,v] = UVfromDM(Dir,Mag)
%
% UVfromDM(Dir,Mag) calculates the east-west or
% cross-shore ('U') and the north-south or alongshore ('V')
% components of a velocity given a time series of speed
% ('Mag') and direction ('Dir').
%

u = (sin(Dir*pi/180).*Mag); % E-W or cross-shore velocity
v = (cos(Dir*pi/180).*Mag); % N-S or alongshore velocity
u=-u; v=-v; % delete this if you want your stick-vectors to point in the direction the wind is coming from 