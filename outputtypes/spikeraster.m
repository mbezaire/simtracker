function spikeraster(hObject,handles);
global mypath RunArray sl

ind = handles.curses.ind;
%sl = handles.curses.sl;
filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'spikeraster.dat'];
readsegsize=10000;

handles.curses.spikerast=[];

if exist(filename,'file')==0
    sprintf('Warning: spikeraster.dat file is missing\nPath: %s', filename);
    return
end

fid=fopen(filename);
i=0;


while ~feof(fid) % & i<1000
    [mymat valcount] = fscanf(fid, '%f\t%g\n',[readsegsize, 2]);
    if valcount==readsegsize*2
        try
            handles.curses.spikerast(1+i*readsegsize:(i+1)*readsegsize,1:2) = reshape(mymat,2,[])';
        catch ME         
            disp(['could not fill spikes ' num2str(1+i*readsegsize) ':' num2str((i+1)*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    else
        try
            handles.curses.spikerast(1+i*readsegsize:valcount/2+i*readsegsize,1:2) = reshape(mymat(1:valcount),2,[])';
            handles.curses.spikerast(valcount/2+i*readsegsize+1:end,:) = [];
        catch ME
            disp(['could not fill last spikes ' num2str(1+i*readsegsize) ':' num2str(valcount/2+i*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    end
    i=i+1;
end
fclose(fid);
clear mymat fid filename valcount i ME
guidata(hObject,handles);