function myresults=getfullconndist(handles)
global mypath RunArray sl

ind = handles.curses.ind;

filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'connections.dat'];
readsegsize=10000;

handles.curses.connections=[];

if exist(filename,'file')==0
    sprintf('Warning: connection.dat file is missing\nPath: %s', filename);
    return
end

fid=fopen(filename);
textscan(fid, '%s\t%s\t%s\n', 1); % read the header
i=0;
[mymat, valcount] = fscanf(fid, '%u\t%u\t%u\n',[readsegsize, 3]);
if valcount==readsegsize*3
    try
        [myresults,BinInfo,ZHeight]=conndist(reshape(mymat,3,[])',handles);
    catch ME
        disp(['could not fill conns ' num2str(1+i*readsegsize) ':' num2str((i+1)*readsegsize)])
        disp(['specific error: ' ME.message]);
        disp(['in ' ME.stack.file ' line ' ME.stack.line]);
        return
    end
end
i=1;

while ~feof(fid)
    [mymat, valcount] = fscanf(fid, '%u\t%u\t%u\n',[readsegsize, 3]);
    if valcount==readsegsize*3
        try
            [myresults,BinInfo,ZHeight]=conndist(reshape(mymat,3,[])',handles,myresults,BinInfo,ZHeight);
        catch ME
            disp(['could not fill conns ' num2str(1+i*readsegsize) ':' num2str((i+1)*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    else
        try
            [myresults,BinInfo,ZHeight]=conndist(reshape(mymat(1:valcount),3,[])',handles,myresults,BinInfo,ZHeight);
        catch ME
            disp(['could not fill last conns ' num2str(1+i*readsegsize) ':' num2str(valcount/3+i*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    end
    i=i+1;
    if mod(i,10)==0
        disp(['now at i=' num2str(i) ' or about synapse #' num2str(i*readsegsize)  '...: ' num2str(i*readsegsize/5e9)])
    end
end 
fclose(fid);
clear mymat fid valcount i ME