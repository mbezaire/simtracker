function getpositions(hObject,handles,varargin)
global mypath RunArray sl

ind = handles.curses.ind;
%sl = handles.curses.sl;

filestr='position.dat';
if ~isempty(varargin)
    filestr=varargin{1};
end

filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl filestr];
readsegsize=10000;

handles.curses.position=[];

if exist(filename,'file')==0
    sprintf('Warning: position.dat file is missing\nPath: %s', filename);
    return
end

fid=fopen(filename);
textscan(fid, '%s\t%s\t%s\t%s\t%s\n', 1); % read the header
i=0;
while ~feof(fid)
    [mymat valcount] = fscanf(fid, '%f\t%f\t%f\t%f\t%f\n',[readsegsize, 5]);
    if valcount==readsegsize*5
        try
            handles.curses.position(1+i*readsegsize:(i+1)*readsegsize,1:5) = reshape(double(mymat),5,[])';
        catch ME
            disp(['could not fill conns ' num2str(1+i*readsegsize) ':' num2str((i+1)*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    else
        try
            handles.curses.position(1+i*readsegsize:valcount/5+i*readsegsize,1:5) = reshape(uint32(mymat(1:valcount)),5,[])';
            handles.curses.position(valcount/5+i*readsegsize+1:end,:) = [];
        catch ME
            disp(['could not fill last positions ' num2str(1+i*readsegsize) ':' num2str(valcount/5+i*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    end
    i=i+1;
end 
fclose(fid);
clear mymat fid valcount i ME

guidata(hObject,handles);