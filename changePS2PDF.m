function changePS2PDF(varargin)
global sl mypath

if isempty(sl)
if ispc
    sl='\';
else
    sl='/';
end
end
if ~isempty(varargin)
    pathstr = varargin{1};
else
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
    q=find([myrepos.current]==1);
    wtmp=strfind(myrepos(q).dir,sl);
    disspath=[myrepos(q).dir(1:wtmp(end)) 'figures' myrepos(q).dir(wtmp(end):end)];
    if exist(disspath,'dir')==0
        mkdir(disspath)
    end
    pathstr = [disspath sl 'cells'];
end

c=dir([pathstr sl '*']);
c = c([c(:).isdir]);
for cf=1:length(c)
    b=dir([pathstr sl c(cf).name sl '*.ps']);

    for r=1:length(b)
        [~,fname,ext] = fileparts(b(r).name);
%         disp(fname)
         try
            ps2pdf('psfile',[pathstr sl c(cf).name sl fname ext],'pdffile',[pathstr sl c(cf).name sl lower(fname) '.png'])
             if strcmp(fname,'all')==0
                delete([pathstr sl c(cf).name sl fname ext])
             end
         end
    end
end

% have to add C:\Program
% Files\MATLAB\R2014a\sys\extern\win64\ghostscript\ps_files to path
