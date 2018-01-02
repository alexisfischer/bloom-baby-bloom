Pseudonitzschiafilelist = dir('C:\Users\Kudela IFCB\Desktop\png\Pseudo-nitzschia\');
Pseudonitzschiafilelist = char(Pseudonitzschiafilelist.name);
Pseudonitzschiafilelist = cellstr(Pseudonitzschiafilelist(:,1:end-4));

fileID=fopen('C:\Users\Kudela IFCB\Desktop\SpeciesList\Pseudo-nitzschiaList.txt','w');
fprintf(fileID,'%s\n',Pseudonitzschiafilelist{:});
fclose(fileID);

