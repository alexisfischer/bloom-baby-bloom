function mapaspect(meanlat)

%sets the plot box aspect ratio to account for the disparity in scale of
%degree lat to degree lon -> 1 degree lat = 1 degree lon / cos(mean lat)

daspect([1 cos(meanlat*pi/180) 1])