function h=plot_tallysyns(hObject,handles)
global RunArray sl

getcelltypes(hObject,guidata(hObject));
handles=guidata(hObject);
numcons(hObject,handles);
handles=guidata(hObject);

h=[];
tally.remote.excitatory.local.excitatory.data = 0;
tally.local.excitatory.local.excitatory.data = 0;
tally.local.inhibitory.local.excitatory.data = 0;

tally.remote.excitatory.local.inhibitory.data = 0;
tally.local.excitatory.local.inhibitory.data = 0;
tally.local.inhibitory.local.inhibitory.data = 0;

tally.remote.excitatory.local.excitatory.color = '#009933';
tally.local.excitatory.local.excitatory.color = '#00FF00';
tally.local.inhibitory.local.excitatory.color = '#33CCFF';

tally.remote.excitatory.local.inhibitory.color = '#CC33FF';
tally.local.excitatory.local.inhibitory.color = '#CC99FF';
tally.local.inhibitory.local.inhibitory.color = '#FF9999';

% Load in weights
fid = fopen([RunArray(handles.curses.ind).ModelDirectory '/datasets/conndata_' num2str(RunArray(handles.curses.ind).ConnData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid)

syns=filedata{5};

for precell=1:length(handles.curses.cells)
    switch handles.curses.cells(precell).name
        case 'eccell'
            preorigin='remote';
            precat = 'excitatory';
        case 'ca3cell'
            preorigin='remote';
            precat = 'excitatory';
        case 'pyramidalcell'
            preorigin='local';
            precat = 'excitatory';
        otherwise
            preorigin='local';
            precat = 'inhibitory';
    end
    for postcell=1:length(handles.curses.cells)
        switch handles.curses.cells(postcell).name
            case 'pyramidalcell'
                postorigin='local';
                postcat = 'excitatory';
            otherwise
                postorigin='local';
                postcat = 'inhibitory';
        end
        idx = find(handles.curses.numcons(:,2)==handles.curses.cells(precell).ind & handles.curses.numcons(:,3)==handles.curses.cells(postcell).ind);
        
        thissyntype=find(strcmp(filedata{1},handles.curses.cells(precell).name)==1 & strcmp(filedata{2},handles.curses.cells(postcell).name)==1);
        SynPerConn = syns(thissyntype);
        if ~isempty(SynPerConn) & SynPerConn>0
            tally.(preorigin).(precat).(postorigin).(postcat).data = tally.(preorigin).(precat).(postorigin).(postcat).data + sum(handles.curses.numcons(idx,4))*SynPerConn;
        end       
    end
end

% for c=1:length(celltype)
%     origin = celltype(c).origin;
%     cat = celltype(c).cat;
%     for p=1:length(celltype)
%         porig = celltype(p).origin;
%         pcat = celltype(p).cat;
%         ptype = celltype(p).type;
%         if isfield(celltype(c).output,ptype)
%             tally.(origin).(cat).(porig).(pcat).data = tally.(origin).(cat).(porig).(pcat).data + celltype(c).output.(ptype);
%         end
%     end
% end
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
pathway=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
if exist(pathway,'dir')==0
    mkdir(pathway)
end

fid = fopen([pathway sl 'allsyns.txt'],'w');
ofields = fieldnames(tally);
for o=1:length(ofields)
    cfields = fieldnames(tally.(ofields{o}));
    for c=1:length(cfields)
        opfields = fieldnames(tally.(ofields{o}).(cfields{c}));
        for op=1:length(opfields)
            cpfields = fieldnames(tally.(ofields{o}).(cfields{c}).(opfields{op}));
            for cp=1:length(cpfields)
                fprintf(fid,'%s %s -> %s %s,%d,%s\n',ofields{o},cfields{c},opfields{op},cpfields{cp},tally.(ofields{o}).(cfields{c}).(opfields{op}).(cpfields{cp}).data,tally.(ofields{o}).(cfields{c}).(opfields{op}).(cpfields{cp}).color);
            end
        end
    end
end

fclose(fid);