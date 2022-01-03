function nextfig(n)

if nargin==0
    n=1;
end

% open the figure number after the current
% before matlab 2015b, this was figure(gcf+1), but then graphics handles
% became objects not doubles
% http://www.mathworks.com/help/matlab/graphics_transition/graphics-handles-are-now-objects-not-doubles.html

if verLessThan('matlab', '8.6.0.267246') % R2015b
    % Put code to run under MATLAB older than MATLAB R2015b here
    figure(gcf+n);
else
    % Put code to run under MATLAB R2014a and newer here
    jnk=gcf;
    figure(jnk.Number+n);
end