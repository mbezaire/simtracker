function getdetailedconns(hObject,handles,preidx,postidx,varargin)
global mypath RunArray sl

ind = handles.curses.ind;
%sl = handles.curses.sl;

filestr='connections.dat';
if ~isempty(varargin)
    filestr=varargin{1};
end

filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl filestr];
readsegsize=10000;

handles.curses.connections=[];

if exist(filename,'file')==0
    sprintf('Warning: connection.dat file is missing\nPath: %s', filename);
    return
end

fid=fopen(filename);
textscan(fid, '%s\t%s\t%s\n', 1); % read the header
i=0;
while ~feof(fid)
    [mymat valcount] = fscanf(fid, '%u\t%u\t%u\n',[readsegsize, 3]);
    if valcount==readsegsize*3
        try
            handles.curses.connections(1+i*readsegsize:(i+1)*readsegsize,1:3) = reshape(uint32(mymat),3,[])';
        catch ME
            disp(['could not fill conns ' num2str(1+i*readsegsize) ':' num2str((i+1)*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    else
        try
            handles.curses.connections(1+i*readsegsize:valcount/3+i*readsegsize,1:3) = reshape(uint32(mymat(1:valcount)),3,[])';
            handles.curses.connections(valcount/3+i*readsegsize+1:end,:) = [];
        catch ME
            disp(['could not fill last conns ' num2str(1+i*readsegsize) ':' num2str(valcount/3+i*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    end
    i=i+1;
end 
fclose(fid);
clear mymat fid valcount i ME

if isempty(handles.curses.connections)
    guidata(hObject,handles);
    return
end
uniq_pre=unique(handles.curses.connections(:,1));
uniq_post=unique(handles.curses.connections(:,2));

for r=1:RunArray(ind).NumCellTypes
    % Set cell type ind for pre-cell column for this cell type
    handles.curses.connections(handles.curses.connections(:,1)<=handles.curses.cells(r).range_en & handles.curses.connections(:,1)>=handles.curses.cells(r).range_st,preidx)=r; % yikes, using r doesn't correspond to the 0-based index from the code
    % Set cell type ind for post-cell column for this cell type
    handles.curses.connections(handles.curses.connections(:,2)<=handles.curses.cells(r).range_en & handles.curses.connections(:,2)>=handles.curses.cells(r).range_st,postidx)=r;
    
    % Find the cells that do not connect to any others or do not receive
    % any connections from others (do we want to limit it to real cells? not necessary to limit, i think)
    vec=handles.curses.cells(r).range_st:handles.curses.cells(r).range_en;
    handles.curses.cells(r).not_pre=vec(ismember(vec, uniq_pre)==0);
    handles.curses.cells(r).not_post=vec(ismember(vec, uniq_post)==0);
end
clear uniq_pre uniq_post vec
guidata(hObject,handles);