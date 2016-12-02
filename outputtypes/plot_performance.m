function plot_performance(~,~,handles)
global mypath sl

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

tmpdata=get(handles.tbl_runs,'Data');
handles.curses.indices = [];
for r=1:size(handles.indices,1)
    myrow = handles.indices(r,1);
    RunName = tmpdata(myrow,1);
    handles.curses.indices(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1 ); % delete min for real data
end

% Fill out the handles.curses.times structure for all selected runs
getruntimes(hObject,handles,handles.curses.indices)
handles=guidata(hObject); % update the handles structure so it contains the fresh times structure data

if length(handles.curses.indices)==1 % if only one run is selected, print out specific graphs for that
    % single bar chart
    figure('Color','w');
    bar([handles.curses.times.setup.avg,handles.curses.times.create.avg,handles.curses.times.connect.avg,handles.curses.times.run.avg,handles.curses.times.write.avg])
    set(gca,'xticklabel',{'Set up','Create','Connect','Run','Write'})
    ylabel('Time per processor (s)')
    title([RunArray(handles.curses.indices).RunName ' Performance'],'Interpreter','none')
    
    figure('Color','w');
    bar([handles.curses.times.setup.std,handles.curses.times.create.std,handles.curses.times.connect.std,handles.curses.times.run.std])
    set(gca,'xticklabel',{'Set up','Create','Connect','Run'})
    ylabel('Standard deviation of times')
    title([RunArray(handles.curses.indices).RunName ' Balance'],'Interpreter','none')
elseif length(handles.curses.indices)<=3 % if only a few runs are selected, compare them in bar graphs
    plotme=zeros(length(handles.curses.times),1);
    % single bar chart
    figure('Color','w');
    subplot(2,3,1)
    for r=1:length(handles.curses.times)
        plotme(r)=handles.curses.times(r).setup.avg;
    end
    bar(plotme)
    set(gca,'xticklabel',{RunArray(handles.curses.indices(:)).RunName})
    ylabel('Time per processor (s)')
    title('Set up','Interpreter','none')
    
    subplot(2,3,2)
    for r=1:length(handles.curses.times)
        plotme(r)=handles.curses.times(r).create.avg;
    end
    bar(plotme)
    set(gca,'xticklabel',{RunArray(handles.curses.indices(:)).RunName})
    ylabel('Time per processor (s)')
    title('Cell Creation','Interpreter','none')    
    
    subplot(2,3,3)
    for r=1:length(handles.curses.times)
        plotme(r)=handles.curses.times(r).connect.avg;
    end
    bar(plotme)
    set(gca,'xticklabel',{RunArray(handles.curses.indices(:)).RunName})
    ylabel('Time per processor (s)')
    title('Cell Connection','Interpreter','none')   
    
    subplot(2,3,4)
    for r=1:length(handles.curses.times)
        plotme(r)=handles.curses.times(r).run.avg;
    end
    bar(plotme)
    set(gca,'xticklabel',{RunArray(handles.curses.indices(:)).RunName})
    ylabel('Time per processor (s)')
    title('Simulation','Interpreter','none')   
    
    subplot(2,3,5)
    for r=1:length(handles.curses.times)
        plotme(r)=handles.curses.times(r).write.avg;
    end
    bar(plotme)
    set(gca,'xticklabel',{RunArray(handles.curses.indices(:)).RunName})
    ylabel('Time per processor (s)')
    title('Write Results','Interpreter','none')   
    
    if RunArray(handles.curses.indices(1)).NumProcessors~=RunArray(handles.curses.indices(2)).NumProcessors
        figure('Color','w');
        subplot(2,2,1)
        for r=1:length(handles.curses.times)
            plotme(r)=handles.curses.times(r).setup.tot;
        end
        bar(plotme)
        set(gca,'xticklabel',{RunArray(handles.curses.indices(:)).RunName})
        ylabel('Total time across all processors (s)')
        title('Set up','Interpreter','none')

        subplot(2,2,2)
        for r=1:length(handles.curses.times)
            plotme(r)=handles.curses.times(r).create.tot;
        end
        bar(plotme)
        set(gca,'xticklabel',{RunArray(handles.curses.indices(:)).RunName})
        ylabel('Total time across all processors (s)')
        title('Cell Creation','Interpreter','none')    

        subplot(2,2,3)
        for r=1:length(handles.curses.times)
            plotme(r)=handles.curses.times(r).connect.tot;
        end
        bar(plotme)
        set(gca,'xticklabel',{RunArray(handles.curses.indices(:)).RunName})
        ylabel('Total time across all processors (s)')
        title('Cell Connection','Interpreter','none')   

        subplot(2,2,4)
        for r=1:length(handles.curses.times)
            plotme(r)=handles.curses.times(r).run.tot;
        end
        bar(plotme)
        set(gca,'xticklabel',{RunArray(handles.curses.indices(:)).RunName})
        ylabel('Total time across all processors (s)')
        title('Simulation','Interpreter','none')   
    end
end