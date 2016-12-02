function h=plot_runtimes(hObject,handles)
global RunArray sl

if isfield(handles.curses,'indices')==0
    handles.curses.indices=handles.curses.ind;
end
getruntimes(hObject,handles,handles.curses.indices)
handles=guidata(hObject); % update the handles structure so it contains the fresh times structure data

% single bar chart
h(1)=figure('Color','w');
bar([handles.curses.times.setup.avg,handles.curses.times.create.avg,handles.curses.times.connect.avg,handles.curses.times.run.avg,handles.curses.times.write.avg])
set(gca,'xticklabel',{'Set up','Create','Connect','Run','Write'})
ylabel('Time per processor (s)')
title([RunArray(handles.curses.indices).RunName ' Performance'],'Interpreter','none')

h(2)=figure('Color','w');
bar([handles.curses.times.setup.std,handles.curses.times.create.std,handles.curses.times.connect.std,handles.curses.times.run.std])
set(gca,'xticklabel',{'Set up','Create','Connect','Run'})
ylabel('Standard deviation of times')
title([RunArray(handles.curses.indices).RunName ' Balance'],'Interpreter','none')
