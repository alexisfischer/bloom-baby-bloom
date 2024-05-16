function [P19,P21] = estimate_patch_KDE(dt,lat,lon)
%function [P] = find_PN_patch_coordinates(dt,lat,lon)
%   Find PN patch coordinates for 2019 and 2021 Shimada survey

col=brewermap(5,'Set2');

%2019
idx=find(dt<datetime('01-Jan-2020'));
lattemp = lat(idx); lontemp = lon(idx); 
%P19(1).idx=(lattemp>=46.5 & lontemp<-123); 
P19(1).idx=(lattemp>=47.8 & lontemp<-123); 
P19(2).idx=(lattemp>=45.7 & lattemp<46.5); 
P19(3).idx=(lattemp>=43.3 & lattemp<45.7); 
P19(4).idx=(lattemp<43.3); 
P19(1).label={'Juan de Fuca'}; 
P19(2).label={'Columbia R'}; 
P19(3).label={'Heceta Bank'}; 
P19(4).label={'Trinidad Head'};
P19(1).col=col(1,:); 
P19(2).col=col(2,:); 
P19(3).col=col(3,:); 
P19(4).col=col(4,:);

%2021
idx=find(dt>datetime('01-Jan-2020'));
lattemp = lat(idx); lontemp = lon(idx); 
P21(1).idx=(lattemp>=47);
%P21(1).idx=(lattemp>=47 & lattemp<48);
P21(2).idx=(lattemp>=45.5 & lattemp<46);
P21(3).idx=(lattemp>=43.8 & lattemp<45.5);
%P21(2).idx=(lattemp>43.8 & lattemp<46);
P21(4).idx=(lattemp>=40.2 & lattemp<43.2);
P21(5).idx=(lattemp<39); 
P21(1).label={'Juan de Fuca'}; 
P21(2).label={'Columbia R'}; 
P21(3).label={'Heceta Bank'}; 
P21(4).label={'Trinidad Head'};
P21(5).label={'Southern CA'}; 
P21(1).col=col(1,:);
P21(2).col=col(2,:); 
P21(3).col=col(3,:); 
P21(4).col=col(4,:); 
P21(5).col=col(5,:);    

end