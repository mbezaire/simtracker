function ensureGUIfits(hObject)
posunits=get(hObject,'Units');
set(hObject,'Units','normalized');
set(get(hObject,'children'),'Units','normalized');
pos=get(hObject,'Position');
if pos(1)+pos(3)>1
    set(hObject,'Position',[0.05 pos(2) .9 pos(4)])
end
pos=get(hObject,'Position');
if pos(2)+pos(4)>1
    set(hObject,'Position',[pos(1) 0.05 pos(3) .9])
end
set(hObject,'Units',posunits);