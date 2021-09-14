function [ SCW2PNWclass ] = convert_class_SCW2PNW( SCWclass2use )
%function [ SCWclass ] = convert_class_PNW2SCW( PNWclass )
% Convert SCW class of interest to the PNW class
% to merge training set
% SCWclass2use: any SCW classlist
% SCW2PNWclass: conversion to PNW classlist
%  Alexis D. Fischer, NOAA, August 2021

%% convert SCW classes to PNW classes
SCW2PNWclass=SCWclass2use;

SCW2PNWclass(strcmp('Alexandrium_doublet', SCW2PNWclass)) = {'Alexandrium'};
SCW2PNWclass(strcmp('Alexandrium_quad', SCW2PNWclass)) = {'Alexandrium'};
SCW2PNWclass(strcmp('Alexandrium_singlet', SCW2PNWclass)) = {'Alexandrium'};
SCW2PNWclass(strcmp('Alexandrium_triplet', SCW2PNWclass)) = {'Alexandrium'};
SCW2PNWclass(strcmp('Alexandrium_doublet', SCW2PNWclass)) = {'Alexandrium'};
SCW2PNWclass(strcmp('Amy_Gony_Protoc', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Ash_dark', SCW2PNWclass)) = {'Detritus'};
SCW2PNWclass(strcmp('Ash_glassy', SCW2PNWclass)) = {'Detritus'};
SCW2PNWclass(strcmp('Beads', SCW2PNWclass)) = {'Bead'};
SCW2PNWclass(strcmp('bubbles', SCW2PNWclass)) = {'Bubble'};
SCW2PNWclass(strcmp('Centric', SCW2PNWclass)) = {'Centric_diatom'};
SCW2PNWclass(strcmp('Centric<10', SCW2PNWclass)) = {'Nanoplankton_<10'};
SCW2PNWclass(strcmp('Chaetoceros socialis', SCW2PNWclass)) = {'Chaetoceros'};
SCW2PNWclass(strcmp('Ciliates', SCW2PNWclass)) = {'Ciliate'};
SCW2PNWclass(strcmp('Cryptophyte,NanoP_less10,small_misc', SCW2PNWclass)) = {'Nanoplankton_<10'};
SCW2PNWclass(strcmp('Cyano_filament', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Cyl_Nitz', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('cyst', SCW2PNWclass)) = {'Cyst'};
SCW2PNWclass(strcmp('Desmid', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Det_Cer_Lau', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('DinoMix', SCW2PNWclass)) = {'Dinoflagellate_mix'};
SCW2PNWclass(strcmp('Dolichospermum', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('FlagMix', SCW2PNWclass)) = {'Flagellate_mix'};
SCW2PNWclass(strcmp('Fragilariopsis', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Guin_Dact', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Gymnodinium,Peridinium', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Karenia', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Lio_Thal', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Microcystis', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Myrionecta', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('NanoP_less10', SCW2PNWclass)) = {'Nanoplankton_<10'};
SCW2PNWclass(strcmp('Navicula', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Oxyp_Oxyt', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Pediastrum', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Pennate', SCW2PNWclass)) = {'Pennate_diatom'};
SCW2PNWclass(strcmp('Peridinium', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Pyrocystis', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Rhiz_Prob', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Scrip_Het', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('small_misc', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Steph_Melo', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Umbilicosphaera', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('Vicicitus', SCW2PNWclass)) = {'unclassified'};
SCW2PNWclass(strcmp('zooplankton_misc', SCW2PNWclass)) = {'Zooplankton'};

end