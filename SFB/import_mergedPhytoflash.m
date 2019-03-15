%% import merged Phytoflash excel files (2012-June 2015)
%Raphe merged these awhile ago

indir = '~/Documents/UCSC_research/SanFranciscoBay/Data/Phytoflash_merged/';
outdir = '~/Documents/MATLAB/bloom-baby-bloom/SFB/Data/';

filedir = dir([indir 'USGS_PF_*']);

for i=1:length(filedir)
    disp(filedir(i).name);    
    filename = [indir filedir(i).name];
    
    opts = detectImportOptions(filename);   
    opts.SelectedVariableNames={'Date','Latitude','Longitude',...
            'Chl','Tur','Temp','Sal','Fo','Fm','Fv','FvFm'};

    Traw=readtable(filename,opts);
    T=rmmissing(Traw); %remove rows w n

    T=standardizeMissing(T,-999);
    
    dn=datenum(T.Date);
    lat = T.Latitude;
    lon = T.Longitude-360;
    chl = T.Chl;
    tur = T.Tur;
    temp = T.Temp;
    sal = T.Sal;
    Fo = T.Fo;
    Fm = T.Fm;
    Fv = T.Fv;
    FvFm = T.FvFm;   

    p(i).dn=dn(1);
    p(i).lat=lat;
    p(i).lon=lon;
    p(i).chl=chl;
    p(i).tur=tur;
    p(i).sal=sal;
    p(i).temp=temp;
    p(i).Fo=Fo;
    p(i).Fm=Fm;
    p(i).Fv=Fv;
    p(i).FvFm=FvFm;
    
    clearvars dn lat lon chl tur temp sal Fo Fm Fv FvFm Traw T opts filename
    
end
  
p(1:3) = []; %remove 2012 data

save([outdir 'Phytoflash_2012-2015'],'p');
