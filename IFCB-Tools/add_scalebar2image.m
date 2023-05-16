clear; 
close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/CharacteristicPNGs/PN_large/';

pixPerUm = 3.8;
scalebarLength = 10;  % scalebar will be 10 micrometer long
unit = sprintf('%sm', '\mu'); % micrometer

P=dir([filepath '*.png']);

for i=1:length(P)
    imagename=P(i).name;
    f = figure(); hAx = axes(f);
    imshow([filepath imagename], 'Parent', hAx);
    hScalebar = scalebar(hAx,'x',scalebarLength, unit,'Location','southeast',...
        'ConversionFactor',pixPerUm,'FontSize',.1,'LineWidth',6); hold on
    
    f = getframe(gca); im = frame2im(f);
    imwrite(im,[filepath 'scalebar/' imagename]) 
    hold off
end