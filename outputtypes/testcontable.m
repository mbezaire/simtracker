function h=testcontable(hObject,handles)
addformatP(handles,hObject);
getcelltypes(hObject,guidata(hObject));
handles=guidata(hObject);
numcons(hObject,handles);
handles=guidata(hObject);
h=plot_numcons(handles);
