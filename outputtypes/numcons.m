function numcons(hObject,handles)
global RunArray sl

ind = handles.curses.ind;
%sl = handles.curses.sl;

filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'numcons.dat'];

handles.curses.numcons=[];

if exist(filename,'file')==0
    sprintf('Warning: numcons.dat file is missing\nPath: %s', filename);
    return
end

numcons = importdata(filename); % host pretype posttype #conns
handles.curses.numcons=numcons.data(:,1:4);
clear numcons
guidata(hObject,handles);