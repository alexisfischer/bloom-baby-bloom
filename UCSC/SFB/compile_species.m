%function [phyto,A] = compile_species(class2do_string,classData,cruisetime,parameters,filepath)
class2do_string = 'Dinophysis'; 
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SFB/';
classData = [filepath 'Data/IFCB_summary/class/' num2str(class2do_string) '_summary'];
cruisetime =[filepath 'Data/st_filename_raw.csv'];
parameters= [filepath 'Data/sfb_raw.csv'];


%% add station #s to Alexandrium data 
load(classData);
[st,filename] = import_IFCB_stations(cruisetime);

[~,~,c] = intersect(filename,class(1).filelist);
matdate=class(1).mdateTB(c);
y_mat=class(1).y_mat(c);

for i=1:length(filename)
    phyto(i).filename=filename(i);
    phyto(i).st=st(i);
    phyto(i).matdate=matdate(i);
    phyto(i).y_mat=y_mat(i);    
end

%% add sfb parameters to IFCB dataset
[phys]=loadSFBparameters(parameters);
[~,~,c] = intersect([phyto.filename],[phys.filename]);

for i=1:length(c)
    phyto(i).lat=phys(c(i)).lat;
    phyto(i).lon=phys(c(i)).lon;
    phyto(i).chl=phys(c(i)).chl;
    phyto(i).d36=phys(c(i)).d36;
    phyto(i).temp=phys(c(i)).temp;
    phyto(i).sal=phys(c(i)).sal;    
    phyto(i).obs=phys(c(i)).obs;
    phyto(i).spm=phys(c(i)).spm;
    phyto(i).ni=phys(c(i)).ni;
    phyto(i).nina=phys(c(i)).nina;
    phyto(i).amm=phys(c(i)).amm;
    phyto(i).phos=phys(c(i)).phos;
    phyto(i).sil=phys(c(i)).sil;        
end

%% sort data by survey dates
A(1).a=find([phyto.matdate]==datenum('31-Jul-2017'));
A(2).a=find([phyto.matdate]==datenum('22-Aug-2017'));
A(3).a=find([phyto.matdate]==datenum('30-Aug-2017'));
A(4).a=find([phyto.matdate]==datenum('19-Sep-2017'));
A(5).a=find([phyto.matdate]==datenum('28-Sep-2017'));
A(6).a=find([phyto.matdate]==datenum('18-Oct-2017'));
A(7).a=find([phyto.matdate]==datenum('27-Oct-2017'));
A(8).a=find([phyto.matdate]==datenum('06-Dec-2017'));
A(9).a=find([phyto.matdate]>=datenum('07-Feb-2018') & [phyto.matdate]<= datenum('08-Feb-2018'));
A(10).a=find([phyto.matdate]==datenum('23-Feb-2018'));
A(11).a=find([phyto.matdate]==datenum('09-Mar-2018'));
A(12).a=find([phyto.matdate]==datenum('15-Mar-2018'));
A(13).a=find([phyto.matdate]==datenum('26-Mar-2018'));
A(14).a=find([phyto.matdate]==datenum('09-Apr-2018'));
A(15).a=find([phyto.matdate]==datenum('18-Apr-2018'));
% A(16).a=find([phyto.matdate]==datenum('07-May-2018'));
% A(17).a=find([phyto.matdate]==datenum('17-May-2018'));
% A(18).a=find([phyto.matdate]==datenum('06-Jun-2018'));
% A(19).a=find([phyto.matdate]==datenum('11-Jun-2018'));
% A(20).a=find([phyto.matdate]==datenum('12-Jul-2018'));
% A(21).a=find([phyto.matdate]==datenum('03-Aug-2018'));
% A(22).a=find([phyto.matdate]==datenum('14-Aug-2018'));

% organize station data into structures
for i=1:length(A)
    A(i).filename=[phyto(A(i).a).filename]'; 
    A(i).matdate=[phyto(A(i).a).matdate]'; 
    A(i).dn=datestr(A(i).matdate(1));    
    A(i).st=[phyto(A(i).a).st]'; 
    A(i).lat=[phyto(A(i).a).lat]'; 
    A(i).lon=[phyto(A(i).a).lon]';       
    A(i).y_mat=[phyto(A(i).a).y_mat]'; 
    A(i).chl=[phyto(A(i).a).chl]';
    A(i).d36=[phyto(A(i).a).d36]';    
    A(i).temp=[phyto(A(i).a).temp]';
    A(i).sal=[phyto(A(i).a).sal]';  
    A(i).obs=[phyto(A(i).a).obs]';
    A(i).spm=[phyto(A(i).a).spm]';
    A(i).ni=[phyto(A(i).a).ni]';
    A(i).nina=[phyto(A(i).a).nina]';
    A(i).amm=[phyto(A(i).a).amm]';
    A(i).phos=[phyto(A(i).a).phos]';
    A(i).sil=[phyto(A(i).a).sil]';    
end
A=rmfield(A,'a');

save([filepath 'Data/IFCB_summary/class/' num2str(class2do_string) '_param'],'phyto','A');
