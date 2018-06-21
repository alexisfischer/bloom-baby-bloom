function [ ind_out, class_label ] = get_dino_ind_CA( class2use, class_label )
%function [ ind_out, class_label ] = get_dino_ind( class2use, class_label )
% California class list specific to return of indices that correspond to dinoflagellate taxa
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

class2get = {'Akashiwo' 'Alexandrium_singlet' 'Amy_Gony_Protoc' 'Ceratium'...
    'Cochlodinium' 'DinoMix' 'Dinophysis' 'Gymnodinium' 'Gyrodinium' 'Karenia'...
    'Lingulodinium' 'Noctiluca' 'Polykrikos' 'Prorocentrum' 'Protoperidinium'...
    'Pyrocystis' 'Scrip_Het' 'Boreadinium' 'Azadinium' 'Torodinium' 'Oxyp_Oxyt'};

[~,ind_out] = intersect(class2use, class2get);
ind_out = sort(ind_out);

end