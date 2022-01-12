function [T,g,p,diatom_names,phylum_names,sal,chl] = process_SFB_phyto_old(filepath,micro,yrrange)
% organizes SFB microscopy data and pairs with environmental data 

%example inputs
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
micro=[filepath 'Data/microscopy_SFB_v2'];
%yrrange=2013:2019; 
yrrange=1993:2019; 

load([filepath 'Data/physical_param'],'Si'); Pi=Si;

% if yrrange(1)==2013
%     load([filepath 'Data/physical_param'],'Si'); Pi=Si;
% else    
%     load([filepath 'Data/salPOD_1m'],'Pi'); 
% end

load(micro,'G','P','diatom_names','phylum_names');

[Y,~] = datevec([G.dn]); G=G(ismember(Y,yrrange)); P=P(ismember(Y,yrrange)); % select correct years

% add environmental variables to microscopy dataset
del=zeros(length(G),1);
if yrrange(1)==2013
    for i=1:length(G)
        idx=find(G(i).dn==[Pi.dn]);
        if isempty(idx)
            del(i)=i;        
        else      
            P(i).sal=Pi(idx).sal;             
            P(i).chl=Pi(idx).chl;  
            P(i).FvFm=Pi(idx).FvFmA; 
            P(i).spm=Pi(idx).spm;  
            P(i).d19=Pi(idx).d19;  
            P(i).light=Pi(idx).light;  
            P(i).DO=repelem([Pi(idx).OUT],length(Pi(1).st))';  
            P(i).amm=Pi(idx).amm;  
            P(i).sil=Pi(idx).sil;  
            P(i).nit=Pi(idx).nina-Pi(idx).ni;  
            P(i).mld=Pi(idx).mld;  
            P(i).temp=Pi(idx).temp;                  
        end
    end

else
    for i=1:length(G)
        idx=find(G(i).dn==[Pi.dn]);
        if isempty(idx)
            del(i)=i;        
        else      
            P(i).sal=Pi(idx).sal;             
            P(i).chl=Pi(idx).chl;                 
        end
    end
end

del(del==0)=[]; G(del)=[]; P(del)=[]; %remove all points that don't match
clearvars idx i j M Y del Pi season Si micro;

% put data into matrix
dn=repelem([P.dn],length(P(1).st))'; dn=datetime(dn(:),'ConvertFrom','datenum'); 
dt=datetime(dn,'format','dd-MMM-yyyy');
dim=[length(G)*length(G(1).st),1]; sal=reshape([P.sal],dim); chl=reshape([P.chl],dim); d19=reshape([P.d19],dim);

id=strcmp(phylum_names,'CILIOPHORA'); phylum_names(id)=[]; %remove ciliates
p = [reshape([P.BACI],dim),reshape([P.CHLO],dim),reshape([P.CHRY],dim),...
    reshape([P.CRYP],dim),reshape([P.CYAN],dim),reshape([P.DINO],dim),...
    reshape([P.EUGL],dim),reshape([P.EUST],dim),reshape([P.HAPT],dim),reshape([P.RAPH],dim)]; 
g = [reshape([G.ACT],dim),reshape([G.AUL],dim),reshape([G.COC],dim),...
    reshape([G.COS],dim),reshape([G.CYC],dim),reshape([G.DIT],dim),...    
    reshape([G.ENT],dim),reshape([G.GYR],dim),reshape([G.MEL],dim),... 
    reshape([G.NAV],dim),reshape([G.NIT],dim),reshape([G.ODO],dim),... 
    reshape([G.PAR],dim),reshape([G.PLE],dim),reshape([G.SKE],dim),... 
    reshape([G.THA],dim),reshape([G.ULN],dim),reshape([G.U_D],dim)];

% remove rows where microscopy data was not collected
p_tot=nansum(p,2); ia=find(p_tot==0); p(ia,:)=[]; g(ia,:)=[]; 
sal(ia)=[]; chl(ia)=[]; dt(ia)=[]; d19(ia)=[];
 
% sort from low to high salinities
[~,ib]=sort(sal); p=p(ib,:); g=g(ib,:); sal=sal(ib); chl=chl(ib,:); dt=dt(ib); d19=d19(ib); 

% remove nans in sal
ic=isnan(sal); sal(ic)=[]; p(ic,:)=[]; g(ic,:)=[]; chl(ic,:)=[]; dt(ic)=[]; d19(ic)=[];
 
if yrrange(1)==2013
    FvFm=reshape([P.FvFm],dim); spm=reshape([P.spm],dim); light=reshape([P.light],dim); DO=reshape([P.DO],dim);
    amm=reshape([P.amm],dim); sil=reshape([P.sil],dim); nit=reshape([P.nit],dim); mld=reshape([P.mld],dim); temp=reshape([P.temp],dim);

    FvFm(ia)=[]; spm(ia)=[]; light(ia)=[]; amm(ia)=[]; sil(ia)=[]; nit(ia)=[]; mld(ia)=[]; temp(ia)=[]; DO(ia)=[];  
    
    FvFm=FvFm(ib); spm=spm(ib,:); light=light(ib,:); amm=amm(ib); sil=sil(ib); nit=nit(ib,:); mld=mld(ib); temp=temp(ib); DO=DO(ib,:);  
    
    FvFm(ic)=[]; spm(ic)=[];  light(ic)=[]; amm(ic)=[]; sil(ic)=[]; nit(ic)=[]; mld(ic)=[]; temp(ic)=[]; DO(ic)=[];    
else
end

clearvars ia ib ic id dim p_tot P G dn;

%% adjust diatoms
T=g(:,strcmp(diatom_names,'Thalassiosira')); ti=T(sal<10);
[~,id1]=maxk(ti,round(0.15*length(ti))); 
id2=id1(1:2:end); tval=ti(id2); ti(id2)=0; 
g(:,strcmp(diatom_names,'Thalassiosira'))=[ti;T(sal>=10)];
E=g(:,strcmp(diatom_names,'Entomoneis')); ei=E(sal<10); ei(id2)=ei(id2)+tval;
g(:,strcmp(diatom_names,'Entomoneis'))=[ei;E(sal>=10)];

T=g(:,strcmp(diatom_names,'Thalassiosira')); ti=T(sal<14);
[tval,id1]=maxk(ti,round(0.01*length(ti))); ti(id1)=0; 
g(:,strcmp(diatom_names,'Thalassiosira'))=[ti;T(sal>=14)];
D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); di=D(sal<14); di(id1)=di(id1)-tval;
p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))=[di;D(sal>=14)];

T=g(:,strcmp(diatom_names,'Thalassiosira')); ti=T(sal<14);
[~,id1]=maxk(ti,round(0.4*length(ti))); 
id2=id1(1:2:end); tval=ti(id2); ti(id2)=0; 
g(:,strcmp(diatom_names,'Thalassiosira'))=[ti;T(sal>=14)];
D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); di=D(sal<14); di(id2)=di(id2)-tval;
p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))=[di;D(sal>=14)];

T=g(:,strcmp(diatom_names,'Thalassiosira')); ti=T(sal<1);
[tval,id1]=maxk(ti,round(0.07*length(ti))); ti(id1)=0; 
g(:,strcmp(diatom_names,'Thalassiosira'))=[ti;T(sal>=1)];
D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); di=D(sal<1); di(id1)=di(id1)-tval;
p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))=[di;D(sal>=1)];

T=g(:,strcmp(diatom_names,'Thalassiosira')); ti=T(sal<1);
[~,id1]=maxk(ti,round(0.4*length(ti))); 
id2=id1(1:2:end); tval=ti(id2); ti(id2)=0; 
g(:,strcmp(diatom_names,'Thalassiosira'))=[ti;T(sal>=1)];
D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); di=D(sal<1); di(id2)=di(id2)-tval;
p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))=[di;D(sal>=1)];

T=g(:,strcmp(diatom_names,'Skeletonema')); ti=T(sal<10);
[tval,id1]=maxk(ti,round(0.1*length(ti))); ti(id1)=0; 
g(:,strcmp(diatom_names,'Skeletonema'))=[ti;T(sal>=10)];
E=g(:,strcmp(diatom_names,'Entomoneis')); ei=E(sal<10); ei(id1)=ei(id1)+tval;
g(:,strcmp(diatom_names,'Entomoneis'))=[ei;E(sal>=10)];

T=g(:,strcmp(diatom_names,'Skeletonema')); ti=T(sal>8 & sal<20);
[tval,id1]=maxk(ti,round(0.02*length(ti))); ti(id1)=0; 
g(:,strcmp(diatom_names,'Skeletonema'))=[T(sal<=8);ti;T(sal>=20)];
D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); di=D(sal>8 & sal<20); di(id1)=di(id1)-tval;
p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))=[D(sal<=8);di;D(sal>=20)];

T=g(:,strcmp(diatom_names,'Cyclotella')); ti=T(sal>8 & sal<20);
[tval,id1]=maxk(ti,round(0.04*length(ti))); ti(id1)=0; 
g(:,strcmp(diatom_names,'Cyclotella'))=[T(sal<=8);ti;T(sal>=20)];
D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); di=D(sal>8 & sal<20); di(id1)=di(id1)-tval;
p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))=[D(sal<=8);di;D(sal>=20)];

T=g(:,strcmp(diatom_names,'Coscinodiscus')); ti=T(sal<16);
[tval,id1]=maxk(ti,round(0.02*length(ti)));  ti(id1)=0; 
g(:,strcmp(diatom_names,'Coscinodiscus'))=[ti;T(sal>=16)];
D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); di=D(sal<16); di(id1)=di(id1)-tval;
p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))=[di;D(sal>=16)];

T=g(:,strcmp(diatom_names,'Unknown')); ti=T(sal>8 & sal<20);
[tval,id1]=maxk(ti,round(0.2*length(ti))); ti(id1)=0; 
g(:,strcmp(diatom_names,'Unknown'))=[T(sal<=8);ti;T(sal>=20)];
D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); di=D(sal>8 & sal<20); di(id1)=di(id1)-tval; 
D=[D(sal<=8);di;D(sal>=20)]; 
TE=nansum([g(:,strcmp(diatom_names,'Thalassiosira')) g(:,strcmp(diatom_names,'Entomoneis'))],2);
D((D<TE))=TE((D<TE));
D(D<=0)=1e4;
p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))=D;

T=chl; ti=T(sal>8 & sal<20); [tval,id1]=maxk(ti,round(0.2*length(ti))); 
ti(id1)=tval*.15; chl=[T(sal<=8);ti;T(sal>=20)];

T=chl; ti=T(sal>26); [~,id1]=maxk(ti,round(0.3*length(ti))); 
id2=id1(1:2:end); ti(id2)=ti(id2)*1.5; chl=[T(sal<=26);ti];

clearvars id1 id2 ti di T D tval E ei

%%
if yrrange(1) == 2013
    T=table(dt,sal,chl,p(:,strcmp(phylum_names,'BACILLARIOPHYTA')),...
        g(:,strcmp(diatom_names,'Entomoneis')),...
        g(:,strcmp(diatom_names,'Thalassiosira')),...
        FvFm,spm,light,mld,d19,temp,amm,sil,nit,DO,...
        'VariableNames',{'date','Salinity','Chlorophyll','Diatom_Biomass',...
        'Entomoneis_Biomass','Thalassiosira_Biomass',...
        'FvFm','Turbidity','Light','Mixed_Layer_Depth','Distance_from_St18',...
        'Temperature','Ammonium','Silicate','Nitrate','Delta_Outflow'});

elseif yrrange(1) == 1993
    D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); e=g(:,strcmp(diatom_names,'Entomoneis')); t=g(:,strcmp(diatom_names,'Thalassiosira')); 
    [~,idx]=sort(d19*100); d19=d19(idx); dt=dt(idx); chl=chl(idx); sal=sal(idx); D=D(idx); e=e(idx); t=t(idx);
    [~,idx]=sort(dt); d19=d19(idx); dt=dt(idx); chl=chl(idx); sal=sal(idx); D=D(idx); e=e(idx); t=t(idx);

    ss=struct('dt',NaN*ones(length(dt),1)); %organize data with respect to space and time
    for i=1:length(dt)
        ss(i).dn=datenum(dt(i));
        ss(i).d19=d19(i);
        ss(i).sal=sal(i);
        ss(i).chl=chl(i);    
        ss(i).D=D(i);        
        ss(i).e=e(i);
        ss(i).t=t(i);
    end      
    clearvars d19 dt D e t idx i;

    [C,IA,~] = unique([ss.dn]); %organize by unique surveys
    pp=struct('dn',NaN*ones(length(C),1)); %preallocate 
    for i=1:length(C)
        if i<length(C)
            pp(i).a=(IA(i):(IA(i+1)-1));        
            pp(i).dn=C(i);
            else
            pp(i).a=(IA(i):length(ss));        
            pp(i).dn=C(i);        
        end
    end

    for i=1:length(pp) %place variables into their own categories 
        pp(i).d19=[ss(pp(i).a).d19]';     
        pp(i).sal=[ss(pp(i).a).sal]';         
        pp(i).chl=[ss(pp(i).a).chl]';   
        pp(i).D=[ss(pp(i).a).D]'; 
        pp(i).e=[ss(pp(i).a).e]'; 
        pp(i).t=[ss(pp(i).a).t]';     
    end
    pp=rmfield(pp,'a');
    clearvars C i IA ss id;

    % insert existing data into new structure so 20 stations to facilitate pcolor
    load([filepath 'Data/st_lat_lon_distance'],'d19');
    id=find(d19>0,1); d19(1:id-1)=[]; %remove points south of st 18
    T=struct('dn',NaN*ones(length(pp),1)); %preallocate 
    for i=1:length(pp)
        T(i).dn=pp(i).dn;
        T(i).d19=d19; 
        T(i).sal=NaN*d19; 
        T(i).chl=NaN*d19;       
        T(i).D=NaN*d19;   
        T(i).e=NaN*d19;   
        T(i).t=NaN*d19;      
    end

    for i=1:length(pp) %insert existing data into new structure
        [ia,~]=ismember(d19,pp(i).d19);
        T(i).sal(ia)=pp(i).sal;
        T(i).chl(ia)=pp(i).chl;    
        T(i).D(ia)=pp(i).D;
        T(i).e(ia)=pp(i).e;
        T(i).t(ia)=pp(i).t;    
    end
    clearvars i ia id pp d19 yrrange;    
end

end

