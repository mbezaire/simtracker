function print_repos_id(repoinfo,netsyns,varargin)
global realpath websitepath

if ispc
    sl='\';
else
    sl='/';
end

if exist([repoinfo.repospath sl 'results' sl 'repotype.mat'],'file')
    load([repoinfo.repospath sl 'results' sl 'repotype.mat'])
elseif exist([realpath sl 'repotype.mat'],'file')
    load([realpath sl 'repotype.mat'])
end

if exist('repotype','var')==0 || isempty(repotype)
    repotype=repoinfo;
end
if ~isempty(varargin)
    for nc=length(repotype.cells):-1:1
        if isempty(strmatch(repotype.cells(nc).techname,varargin{1}))
            repotype.cells(nc)=[];
        end
    end
    for v=1:length(varargin{1})
        if isempty(strmatch(varargin{1}{v},{repotype.cells.techname}))
            repotype.cells(end+1).techname=varargin{1}{v};
        end
    end
    if length(varargin)>1
        for nc=length(repotype.channels):-1:1
            if isempty(strmatch(repotype.channels(nc).techname,varargin{2}))
                repotype.channels(nc)=[];
            end
        end
    end
    for v=1:length(varargin{2})
        if isempty(strmatch(varargin{2}{v},{repotype.channels.techname}))
            repotype.channels(end+1).techname=varargin{2}{v};
        end
    end
end
[~,uicell]=unique({repotype.cells.techname});
repotype.cells=repotype.cells(uicell);
[~,uichan]=unique({repotype.channels.techname});
repotype.channels=repotype.channels(uichan);
cellrepo=nicecellcolor(repotype);
chanrepo = nicechannelformat(repotype);

repotype.cells=cellrepo.cells;
repotype.channels=chanrepo.channels;
save([repoinfo.repospath sl 'results' sl 'repotype.mat'],'repotype','-v7.3')


fid = fopen([websitepath sl 'repos_id.js'],'w');

fprintf(fid,'var repository = "%s"\n', repoinfo.repo);
fprintf(fid,'var publication = "%s"\n', repoinfo.publication);
fprintf(fid,'var publink = "%s"\n', repoinfo.publink);
fprintf(fid,'var netsyns = %e\n', netsyns);
fprintf(fid,'var funding = "%s"\n', repoinfo.funding);
fprintf(fid,'var author = "%s"\n', repoinfo.author);
fprintf(fid,'var authorlink = "%s"\n', repoinfo.authorlink);
fprintf(fid,'var lab = "%s"\n', repoinfo.lab);
fprintf(fid,'var lablink = "%s"\n', repoinfo.lablink);

fprintf(fid,'		var getNiceCellName = {\n');
for rc=1:length(cellrepo.cells)
    fprintf(fid,'			"%s": "%s",\n', cellrepo.cells(rc).techname, cellrepo.cells(rc).nicename);
end
fprintf(fid,'		};\n');
fprintf(fid,'\n');

fprintf(fid,'		var getNiceChanName = {\n');
for rc=1:length(chanrepo.channels)
    fprintf(fid,'			"%s": "%s (%s)<br/>%s",\n', chanrepo.channels(rc).techname, chanrepo.channels(rc).formatname, chanrepo.channels(rc).techname, chanrepo.channels(rc).nicename);
end

fprintf(fid,'		};\n');
fprintf(fid,'		\n');
fprintf(fid,'		var getColor = {\n');
for rc=1:length(cellrepo.cells)
    fprintf(fid,'			"%s": "%s", // %s\n', cellrepo.cells(rc).nicename, cellrepo.cells(rc).colorcode, cellrepo.cells(rc).color);
end
fprintf(fid,'		};\n');
fclose(fid);