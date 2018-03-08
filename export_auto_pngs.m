resultpath= 'F:\IFCB104\manual\'; %where manual files are
urlbase = 'http:\\128.114.25.154:8888/IFCB104\'; %where your dashboard is
outputpath = 'F:\IFCB104\manual\auto_png\';% where you want images to go

load 'F:\IFCB104\manual\D20160804T093210_IFCB104.mat';
imclass = strmatch('Dinophysis', class2use_manual); %class to export

filelist = dir([resultpath 'D*.mat']);
class_name=char(class2use_manual(imclass));
mkdir([outputpath class_name]);

for filecount = 1:length(filelist), %this is where you could potentially put filecount=1:10:length(filelist) if you had tons of files.

    filename = filelist(filecount).name;
    disp(filename)
    load([resultpath filename])
    
    roi_ind=find(classlist(:,3)==imclass);
       
    for i=1:length(roi_ind) %this is where you could potentially put i=1:10:length(roi_ind) if your categories were huge.
        pngnumber=num2str(classlist(roi_ind(i),1));
    pngname = [filename(1:24) '_' pngnumber];
        image = get_image([urlbase pngname]);
        if length(image) > 0,
            imwrite(image, [outputpath class_name '/' pngname '.png'], 'png');
        end;
    end;
  end
    