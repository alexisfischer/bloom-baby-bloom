function h = addFigureLetter(ha,txt,flagLoc,varargin);

% h = addFigureLetter(ha,txt,flagAbove);
% 
% add a letter (or other text) to upper rh corner of plot 
%   ha = current axes (== gca)
%   txt = text to write
%   flagLoc = where to plot it
%      [2]: upper left corner in plot
%       3 : lower left corner in plot
%       4 : lower right in plot
%       1 : upper right in plot
%      -2 : upper left above plot, etc

if nargin == 2
    flagLoc = 2;
end
if ischar(ha); flagLoc=txt; txt=ha;  ha=gcf; end
xaxcf = double(get(ha,'XLim')); yaxcf = double(get(ha,'YLim'));

if strcmp(get(gca,'xdir'),'reverse');
    x0 = xaxcf(2); x1 = xaxcf(1);
else
    x0 = xaxcf(1); x1 = xaxcf(2);
end
if strcmp(get(gca,'ydir'),'reverse');
    y0 = yaxcf(2); y1 = yaxcf(1);
else
    y0 = yaxcf(1); y1 = yaxcf(2);
end
% if size(txt,1) == 1
%     txt=[' ',txt];
% end
if abs(flagLoc)==2
    h = text(x0,y1,txt,'VerticalAlignment','Top');
elseif abs(flagLoc)==3
    h = text(x0,y0,txt,'VerticalAlignment','Bottom');    
elseif abs(flagLoc)==4
    h = text(x1,y0,txt,'VerticalAlignment','Bottom','horizontalalignment','right');    
elseif abs(flagLoc)==1
    h = text(x1,y1,txt,'VerticalAlignment','Top','horizontalalignment','right');    
end

if sign(flagLoc)==-1 & abs(flagLoc)<=2
    set(h,'VerticalAlignment','Bottom');
elseif sign(flagLoc)==-1 & abs(flagLoc)>2
    set(h,'VerticalAlignment','Top');
end

if not(isempty(varargin))    
    set(h,varargin{:});
end
