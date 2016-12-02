function getlfp(hObject,handles)
global RunArray sl

ind = handles.curses.ind;
%sl = handles.curses.sl;

filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'lfp.dat'];

if exist(filename,'file')==0
    sprintf('Warning: lfp.dat file is missing\nPath: %s', filename);
    return
end
tmpdata = importdata(filename);

handles.curses.lfp = tmpdata;

guidata(hObject,handles);