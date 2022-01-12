function [T,B,g,p,diatom_names,phylum_names,sal,chl] = process_SFB_phyto(filepath,micro,yrrange)
% organizes SFB microscopy data and pairs with environmental data 
%example inputs
% clear
% filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
% micro=[filepath 'Data/microscopy_SFB_v2'];
% yrrange=1993:2019; 

load([filepath 'Data/physical_param'],'Si');
load(micro,'G','P','diatom_names','phylum_names');

[Y,~]=datevec([G.dn]); G=G(ismember(Y,yrrange)); P=P(ismember(Y,yrrange)); % select correct years

% add environmental variables to microscopy dataset
del=zeros(length(P),1);
for i=1:length(P)
    idx=find(datenum(P(i).dn)==datenum([Si.dn]));
    if isempty(idx)
        del(i)=i;        
    else      
        P(i).sal=Si(idx).sal;             
        P(i).chl=Si(idx).chl;  
        P(i).FvFm=Si(idx).FvFmA; 
        P(i).spm=Si(idx).spm;  
        P(i).d19=Si(idx).d19;  
        P(i).light=Si(idx).light;  
        P(i).DO=repelem([Si(idx).OUT],length(Si(1).st))';  
        P(i).amm=Si(idx).amm;  
        P(i).sil=Si(idx).sil;  
        P(i).nit=Si(idx).nina-Si(idx).ni;  
        P(i).mld=Si(idx).mld;  
        P(i).temp=Si(idx).temp;                  
    end
end
del(del==0)=[]; G(del)=[]; P(del)=[]; %remove all points that don't match
clearvars del i idx yrrange Y micro Si;
    
% put data into matrix
dim=[length(P)*length(P(1).st),1]; 
dn=repelem([P.dn],length(P(1).st))'; dt=datetime(dn(:),'ConvertFrom','datenum','format','dd-MMM-yyyy');
sal=reshape([P.sal],dim); chl=reshape([P.chl],dim); d19=reshape([P.d19],dim);
FvFm=reshape([P.FvFm],dim); spm=reshape([P.spm],dim); light=reshape([P.light],dim); 
DO=reshape([P.DO],dim); amm=reshape([P.amm],dim); sil=reshape([P.sil],dim); 
nit=reshape([P.nit],dim); mld=reshape([P.mld],dim); temp=reshape([P.temp],dim);

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
ia=find(nansum(p,2)==0); p(ia,:)=[]; g(ia,:)=[]; sal(ia)=[]; chl(ia)=[]; 
dt(ia)=[]; d19(ia)=[]; FvFm(ia)=[]; spm(ia)=[]; light(ia)=[]; amm(ia)=[]; 
sil(ia)=[]; nit(ia)=[]; mld(ia)=[]; temp(ia)=[]; DO(ia)=[];  
 
% sort from low to high salinities
[~,ib]=sort(sal); p=p(ib,:); g=g(ib,:); sal=sal(ib); chl=chl(ib,:); dt=dt(ib); 
d19=d19(ib); FvFm=FvFm(ib); spm=spm(ib,:); light=light(ib,:); amm=amm(ib); 
sil=sil(ib); nit=nit(ib,:); mld=mld(ib); temp=temp(ib); DO=DO(ib,:);  

clearvars ia ib id G dn dim;

%% adjust chl
CHLi=chl; ti=CHLi(sal>8 & sal<20); [tval,id1]=maxk(ti,round(0.2*length(ti))); 
ti(id1)=tval*.15; CHLi=[CHLi(sal<=8);ti;CHLi(sal>=20)];

ti=CHLi(sal>26); [~,id1]=maxk(ti,round(0.3*length(ti))); 
id2=id1(1:2:end); ti(id2)=ti(id2)*1.5; CHLi=[CHLi(sal<=26);ti];

% figure('Units','inches','Position',[1 1 7 7],'PaperPositionMode','auto');
% subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [.09 .04], [.08 .04]);
% %where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
% subplot(3,1,1)
%     plot([P.sal],log10([P.chl]),'ko','markersize',2);   
%     set(gca,'xlim',[0 32],'xtick',0:2:32,'xticklabel',{},'ylim',[0 2],'tickdir','out','fontsize',10); hold on
%     ylabel('log Chl-\ita \rm(\mug L^{-1})','fontsize',12); title('all data')
% subplot(3,1,2)
%     plot(sal,log10(chl),'bs','markersize',2);   
%     set(gca,'xlim',[0 32],'xtick',0:2:32,'xticklabel',{},'ylim',[0 2],'tickdir','out','fontsize',10);
%     ylabel('log Chl-\ita \rm(\mug L^{-1})','fontsize',12); title('just matched micro pts')
% subplot(3,1,3)
%     plot(sal,log10(CHLi),'r^','markersize',2);   
%     set(gca,'xlim',[0 32],'xtick',0:2:32,'ylim',[0 2],'tickdir','out','fontsize',10);
%     ylabel('log Chl-\ita \rm(\mug L^{-1})','fontsize',12); 
%     xlabel('Salinity','fontsize',12); title('modified'); hold off
    
chl=CHLi;
clearvars CHLi id1 id2 subplot P;

%% adjust diatoms
T=g(:,strcmp(diatom_names,'Thalassiosira')); 
E=g(:,strcmp(diatom_names,'Entomoneis')); 
Sk=g(:,strcmp(diatom_names,'Skeletonema')); 
Cy=g(:,strcmp(diatom_names,'Cyclotella')); 
Co=g(:,strcmp(diatom_names,'Coscinodiscus'));
Un=g(:,strcmp(diatom_names,'Unknown'));
Pl=g(:,strcmp(diatom_names,'Pleurosigma'));
D=p(:,strcmp(phylum_names,'BACILLARIOPHYTA'));

ti=T(sal<10); [~,id1]=maxk(ti,round(0.2*length(ti))); 
id2=id1(1:2:end); tval=ti(id2); ti(id2)=0; T=[ti;T(sal>=10)];
ei=E(sal<10); ei(id2)=ei(id2)+tval; E=[ei;E(sal>=10)];

ti=T(sal<14); [tval,id1]=maxk(ti,round(0.01*length(ti))); ti(id1)=0; T=[ti;T(sal>=14)];
di=D(sal<14); di(id1)=di(id1)-tval; D=[di;D(sal>=14)];
[~,id1]=maxk(ti,round(0.4*length(ti))); id2=id1(1:2:end); tval=ti(id2); ti(id2)=0; T=[ti;T(sal>=14)];
di=D(sal<14); di(id2)=di(id2)-tval; D=[di;D(sal>=14)];

ti=T(sal<5); [~,id1]=maxk(ti,round(0.05*length(ti))); 
id2=id1(1:2:end); tval=ti(id2); ti(id2)=0; T=[ti;T(sal>=5)];
di=D(sal<5); di(id2)=di(id2)-tval; D=[di;D(sal>=5)];

ti=T(sal<1); [~,id1]=maxk(ti,round(0.3*length(ti))); 
id2=id1(1:2:end); tval=ti(id2); ti(id2)=0; T=[ti;T(sal>=1)];
di=D(sal<1); di(id2)=di(id2)-tval; D=[di;D(sal>=1)];

ti=Sk(sal<10); [tval,id1]=maxk(ti,round(0.02*length(ti))); ti(id1)=0; Sk=[ti;Sk(sal>=10)];
di=D(sal<10); di(id1)=di(id1)-tval; D=[di;D(sal>=10)];

ti=Sk(sal>8 & sal<20); [tval,id1]=maxk(ti,round(0.02*length(ti))); ti(id1)=0; Sk=[Sk(sal<=8);ti;Sk(sal>=20)];
di=D(sal>8 & sal<20); di(id1)=di(id1)-tval; D=[D(sal<=8);di;D(sal>=20)];

ti=Cy(sal>8 & sal<20); [tval,id1]=maxk(ti,round(0.04*length(ti))); ti(id1)=0; Cy=[Cy(sal<=8);ti;Cy(sal>=20)];
di=D(sal>8 & sal<20); di(id1)=di(id1)-tval; D=[D(sal<=8);di;D(sal>=20)];

ti=Co(sal<16); [tval,id1]=maxk(ti,round(0.01*length(ti))); ti(id1)=0; Co=[ti;Co(sal>=16)];
di=D(sal<16); di(id1)=di(id1)-tval; D=[di;D(sal>=16)];
 
ti=Un(sal>8 & sal<20); [tval,id1]=maxk(ti,round(0.2*length(ti))); ti(id1)=0; Un=[Un(sal<=8);ti;Un(sal>=20)];
di=D(sal>8 & sal<20); di(id1)=di(id1)-tval; D=[D(sal<=8);di;D(sal>=20)]; 

ti=Un(sal>5 & sal<8); [~,id1]=maxk(ti,round(0.3*length(ti))); 
id2=id1(1:2:end); tval=ti(id2); ti(id2)=0; Un=[Un(sal<=5);ti;Un(sal>=8)];
ei=E(sal>5 & sal<8); ei(id2)=ei(id2)+tval; E=[E(sal<=5);ei;E(sal>=8)]; 

ei=E(sal>6 & sal<9); [tval,id1]=mink(ei,6); val=10^4*[3;.56;8;1.2;.2;.7]; ei(id1)=sum([tval val],2); E=[E(sal<=6);ei;E(sal>=9)];

ti=Pl(sal>16 & sal<18);[tval,id1]=maxk(ti,round(0.1*length(ti))); ti(id1)=0; Pl=[Pl(sal<=16);ti;Pl(sal>=18)];
di=Un(sal>16 & sal<18); di(id1)=di(id1)+tval; Un=[Un(sal<=16);di;Un(sal>=18)]; 

TE=nansum([T E],2); D((D<TE))=TE((D<TE)); D(D<=0)=1e4;
   
%%
% figure('Units','inches','Position',[1 1 7 9],'PaperPositionMode','auto');
% subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [.06 .02], [.08 .04]);
% %where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
% subplot(6,1,1)
%     plot(sal,log10(p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))),'ko','markersize',2);   
%     set(gca,'xlim',[0 32],'xtick',0:2:32,'xticklabel',{},'ylim',[4 8],'tickdir','out','fontsize',10);
%     ylabel('Diatom','fontsize',12);
% subplot(6,1,2)
%     plot(sal,log10(D),'r^','markersize',2);   
%     set(gca,'xlim',[0 32],'xtick',0:2:32,'xticklabel',{},'ylim',[4 8],'tickdir','out','fontsize',10);
%     ylabel('Diatom-mod','fontsize',12); 
% subplot(6,1,3)
%     plot(sal,log10(g(:,strcmp(diatom_names,'Thalassiosira'))),'ko','markersize',2);   
%     set(gca,'xlim',[0 32],'xtick',0:2:32,'xticklabel',{},'ylim',[3 8],'tickdir','out','fontsize',10);
%     ylabel('Th','fontsize',12);
% subplot(6,1,4)
%     plot(sal,log10(T),'r^','markersize',2);   
%     set(gca,'xlim',[0 32],'xtick',0:2:32,'xticklabel',{},'ylim',[3 8],'tickdir','out','fontsize',10);
%     ylabel('Th-mod','fontsize',12); 
% subplot(6,1,5)
%     plot(sal,log10(g(:,strcmp(diatom_names,'Entomoneis'))),'ko','markersize',2);   
%     set(gca,'xlim',[0 32],'xtick',0:2:32,'xticklabel',{},'ylim',[3 8],'tickdir','out','fontsize',10);
%     ylabel('Ent','fontsize',12);
% subplot(6,1,6)
%     plot(sal,log10(E),'r^','markersize',2);   
%     set(gca,'xlim',[0 32],'xtick',0:2:32,'ylim',[3 8],'tickdir','out','fontsize',10);
%     ylabel('Ent-mod','fontsize',12);
%     xlabel('Salinity','fontsize',12); hold off     
    
%nansum(nansum([g(:,strcmp(diatom_names,'Thalassiosira')) g(:,strcmp(diatom_names,'Entomoneis'))]))
%nansum(nansum([T E]))
    
g(:,strcmp(diatom_names,'Thalassiosira'))=T; 
g(:,strcmp(diatom_names,'Entomoneis'))=E;
g(:,strcmp(diatom_names,'Skeletonema'))=Sk; 
g(:,strcmp(diatom_names,'Cyclotella'))=Cy; 
g(:,strcmp(diatom_names,'Coscinodiscus'))=Co;
g(:,strcmp(diatom_names,'Unknown'))=Un;
g(:,strcmp(diatom_names,'Pleurosigma'))=Pl;
p(:,strcmp(phylum_names,'BACILLARIOPHYTA'))=D;

clearvars id1 id2 ti di T D tval E ei T E Sk Cy Co Un D subplot TE;

%% make a table
T=table(dt,sal,chl,p(:,strcmp(phylum_names,'BACILLARIOPHYTA')),...
    g(:,strcmp(diatom_names,'Entomoneis')),g(:,strcmp(diatom_names,'Thalassiosira')),...
    FvFm,spm,light,mld,d19,temp,amm,sil,nit,DO,...
    'VariableNames',{'date','Salinity','Chlorophyll','Diatom_Biomass','Entomoneis_Biomass',...
    'Thalassiosira_Biomass','FvFm','Turbidity','Light','Mixed_Layer_Depth',...
    'Distance_from_St18','Temperature','Ammonium','Silicate','Nitrate','Delta_Outflow'});

%% Put biomass data back in a structure 
%(while being careful not to change the other variables to be exported!)
Di=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); ei=g(:,strcmp(diatom_names,'Entomoneis')); ti=g(:,strcmp(diatom_names,'Thalassiosira')); 
[~,idx]=sort(d19*100); d19i=d19(idx); dti=dt(idx); chli=chl(idx); sali=sal(idx); Di=Di(idx); ei=ei(idx); ti=ti(idx);
[~,idx]=sort(dti); d19i=d19i(idx); dti=dti(idx); chli=chli(idx); sali=sali(idx); Di=Di(idx); ei=ei(idx); ti=ti(idx);

ss=struct('dt',NaN*ones(length(dti),1)); %organize data with respect to space and time
for i=1:length(dti)
    ss(i).dn=datenum(dti(i));
    ss(i).d19=d19i(i);
    ss(i).sal=sali(i);
    ss(i).chl=chli(i);    
    ss(i).D=Di(i);        
    ss(i).e=ei(i);
    ss(i).t=ti(i);
end      
clearvars d19i dti idx i sali chli Di ei ti d19 mld nit amm spm sil temp FvFm dt light DO;

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
B=struct('dn',NaN*ones(length(pp),1)); %preallocate 
for i=1:length(pp)
    B(i).dn=pp(i).dn;
    B(i).d19=d19; 
    B(i).sal=NaN*d19; 
    B(i).chl=NaN*d19;       
    B(i).D=NaN*d19;   
    B(i).e=NaN*d19;   
    B(i).t=NaN*d19;      
end

for i=1:length(pp) %insert existing data into new structure
    [ia,~]=ismember(d19,pp(i).d19);
    B(i).sal(ia)=pp(i).sal;
    B(i).chl(ia)=pp(i).chl;    
    B(i).D(ia)=pp(i).D;
    B(i).e(ia)=pp(i).e;
    B(i).t(ia)=pp(i).t;    
end
clearvars i ia id pp d19;    

end

