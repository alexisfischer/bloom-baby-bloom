function [SA_gridded,CT_gridded,isopycs_gridded] = get_isopycnals(SA,CT,p_ref)
%Get isopycnals: Script adapted from GSW toolbox script gsw_SA_CT_plot
% Alexis D. Fischer, NOAA NWFSC, January 2024
%
% INPUT:
%  SA  =  Absolute Salinity                                        [ g/kg ]
%  CT  =  Conservative Temperature (ITS-90)                       [ deg C ]
%
% Optional:
%  p_ref        = reference sea pressure for the isopycnals        [ dbar ]
%                 (i.e. absolute reference pressure - 10.1325 dbar) 
%

min_SA_data = min(min(SA(:)));
max_SA_data = max(max(SA(:)));
min_CT_data = min(min(CT(:)));
max_CT_data = max(max(CT(:)));

SA_min = min_SA_data - 0.1*(max_SA_data - min_SA_data);
SA_min(SA_min < 0) = 0;
SA_max = max_SA_data + 0.1*(max_SA_data - min_SA_data);
SA_axis = [SA_min:(SA_max-SA_min)/200:SA_max];

CT_freezing = gsw_CT_freezing(SA_axis,p_ref,0); 
CT_min = min_CT_data - 0.1*(max_CT_data - min_CT_data);
CT_max = max_CT_data + 0.1*(max_CT_data - min_CT_data);
if CT_min > min(CT_freezing) 
    CT_min = min_CT_data - 0.1*(max_CT_data - min(CT_freezing));
end
CT_axis = [CT_min:(CT_max-CT_min)/200:CT_max];

SA_gridded = meshgrid(SA_axis,1:length(CT_axis));
CT_gridded = meshgrid(CT_axis,1:length(SA_axis))';
isopycs_gridded = gsw_rho(SA_gridded,CT_gridded,0)-1000;

end