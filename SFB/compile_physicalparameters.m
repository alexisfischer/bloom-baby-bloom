function [phys,s] = compile_physicalparameters(filepath,phys)

% sort data by survey dates
s(1).a=find([phys.dn]==datenum('31-Jul-2017'));
s(2).a=find([phys.dn]==datenum('22-Aug-2017'));
s(3).a=find([phys.dn]==datenum('30-Aug-2017'));
s(4).a=find([phys.dn]==datenum('19-Sep-2017'));
s(5).a=find([phys.dn]==datenum('28-Sep-2017'));
s(6).a=find([phys.dn]==datenum('18-Oct-2017'));
s(7).a=find([phys.dn]==datenum('27-Oct-2017'));
s(8).a=find([phys.dn]==datenum('06-Dec-2017'));
s(9).a=find([phys.dn]>=datenum('07-Feb-2018') & [phys.dn]<= datenum('08-Feb-2018'));
s(10).a=find([phys.dn]==datenum('23-Feb-2018'));
s(11).a=find([phys.dn]==datenum('09-Mar-2018'));
s(12).a=find([phys.dn]==datenum('15-Mar-2018'));
s(13).a=find([phys.dn]==datenum('26-Mar-2018'));
s(14).a=find([phys.dn]==datenum('09-Apr-2018'));
% s(15).a=find([phys.dn]==datenum('07-May-2018'));

% organize station data into structures based on survey date
for i=1:length(s)
    s(i).dn=datestr(phys(s(i).a(1,1)).dn);
    s(i).st=[phys(s(i).a).st]'; 
    s(i).lat=[phys(s(i).a).lat]'; 
    s(i).lon=[phys(s(i).a).lon]';     
    s(i).chl=[phys(s(i).a).chl]';
    s(i).d36=[phys(s(i).a).d36]';    
    s(i).temp=[phys(s(i).a).temp]';
    s(i).sal=[phys(s(i).a).sal]';  
    s(i).obs=[phys(s(i).a).obs]';
    s(i).spm=[phys(s(i).a).spm]';
    s(i).ni=[phys(s(i).a).ni]';
    s(i).nina=[phys(s(i).a).nina]';
    s(i).amm=[phys(s(i).a).amm]';
    s(i).phos=[phys(s(i).a).phos]';
    s(i).sil=[phys(s(i).a).sil]';    
end
s=rmfield(s,'a');

save([filepath 'Data/physical_param'],'phys','s');

end


