function h=run_netclamp(handles) % idx contains the column in the spikeraster that gives the cell type index
global mypath RunArray sl

h=[]; %figure;
idx = handles.curses.ind;
%sl = handles.curses.sl;

if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end

if isempty(deblank(handles.optarg))
    gidstr=inputdlg('Enter the type of cell of interest');
    mytype=gidstr{:};
else
    mytype=handles.optarg;
end

id = find(strcmp({handles.curses.cells(:).name},mytype)==1);
cellind = handles.curses.cells(id).ind;
alist=dir([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'trace_' mytype '*.dat']);

if isempty(alist)
    msgbox('There are no trace available for that type.')
    return
end

for atype=1:length(alist)
    a = alist(atype);
    gidsnip = a.name(length(['trace_' mytype])+1:end-4);
    gidstr = {gidsnip};
    gid = str2num(gidsnip);
    
    fid = fopen([RunArray(idx).ModelDirectory sl 'jobscripts' sl RunArray(idx).RunName '_netclamp.hoc'],'w');
    fprintf(fid,'SimDuration=%d\n', RunArray(idx).SimDuration);
    fprintf(fid,'TemporalResolution=%d\n', RunArray(idx).TemporalResolution);
    fprintf(fid,'NumData=%d\n', RunArray(idx).NumData);
    fprintf(fid,'ConnData=%d\n', RunArray(idx).ConnData);
    fprintf(fid,'SynData=%d\n', RunArray(idx).SynData);
    fprintf(fid,'strdef BasedOnRunName\nBasedOnRunName="%s"\n', RunArray(idx).RunName);
    fprintf(fid,'strdef CellOI\nCellOI="%s"\n', mytype);
    fprintf(fid,'CellOItype=%d\n', cellind)
    fprintf(fid,'gid=%d\n', gid)
    fprintf(fid,'{load_file("./netclamp.hoc")}\n')
    fclose(fid);
    mystr=system(['cd ' RunArray(idx).ModelDirectory ' ' handles.dl ' nrniv jobscripts' sl RunArray(idx).RunName '_netclamp.hoc']);
    disp(mystr)
end
msgbox('Done!')