function getcelltypes(hObject,handles)
global RunArray sl

ind = handles.curses.ind;
%sl = handles.curses.sl;

filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'celltype.dat'];

if exist(filename,'file')==0
    sprintf('Warning: celltype.dat file is missing\nPath: %s', filename);
    return
end
tmpdata = importdata(filename);

for r=1:size(tmpdata.textdata,1)-1
    handles.curses.cells(r).name=tmpdata.textdata{r+1,1};
    handles.curses.cells(r).techname=tmpdata.textdata{r+1,2};
    handles.curses.cells(r).ind=tmpdata.data(r,1);
    handles.curses.cells(r).range_st=tmpdata.data(r,2);
    handles.curses.cells(r).range_en=tmpdata.data(r,3);
    handles.curses.cells(r).numcells=handles.curses.cells(r).range_en - handles.curses.cells(r).range_st + 1;
end

clear tmpdata filename r
guidata(hObject,handles);