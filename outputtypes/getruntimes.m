function getruntimes(hObject,handles,varargin)
global RunArray

sl = '/'; % handles.curses.sl;
handles.curses.times=[];
if isempty(varargin)
    ind = handles.curses.ind;

    filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'runtimes.dat'];

    if exist(filename,'file')==0
        sprintf('Warning: runtimes.dat file is missing\nPath: %s', filename);
        return
    end
    tmpdata = importdata(filename);

    handles.curses.times.setup.avg=mean(tmpdata.data(:,2));
    handles.curses.times.setup.tot=sum(tmpdata.data(:,2));
    handles.curses.times.setup.std=std(tmpdata.data(:,2));

    handles.curses.times.create.avg=mean(tmpdata.data(:,3));
    handles.curses.times.create.tot=sum(tmpdata.data(:,3));
    handles.curses.times.create.std=std(tmpdata.data(:,3));

    handles.curses.times.connect.avg=mean(tmpdata.data(:,4));
    handles.curses.times.connect.tot=sum(tmpdata.data(:,4));
    handles.curses.times.connect.std=std(tmpdata.data(:,4));

    handles.curses.times.run.avg=mean(tmpdata.data(:,5));
    handles.curses.times.run.tot=sum(tmpdata.data(:,5));
    handles.curses.times.run.std=std(tmpdata.data(:,5));

    handles.curses.times.write.avg=RunArray(ind).RunTime - sum(tmpdata.data(1,:));
    handles.curses.times.write.tot=handles.curses.times.write.avg*RunArray(ind).NumProcessors;
    handles.curses.times.write.std=0;

    clear tmpdata filename r
    
else


    for r=1:length(varargin{1})
        filename = [RunArray(varargin{1}(r)).ModelDirectory sl 'results' sl RunArray(varargin{1}(r)).RunName sl 'runtimes.dat'];

        if exist(filename,'file')==0
            sprintf('Warning: runtimes.dat file is missing\nPath: %s', filename);
            return
        end
        tmpdata = importdata(filename);

        handles.curses.times(r).setup.avg=mean(tmpdata.data(:,2));
        handles.curses.times(r).setup.tot=sum(tmpdata.data(:,2));
        handles.curses.times(r).setup.std=std(tmpdata.data(:,2));

        handles.curses.times(r).create.avg=mean(tmpdata.data(:,3));
        handles.curses.times(r).create.tot=sum(tmpdata.data(:,3));
        handles.curses.times(r).create.std=std(tmpdata.data(:,3));

        handles.curses.times(r).connect.avg=mean(tmpdata.data(:,4));
        handles.curses.times(r).connect.tot=sum(tmpdata.data(:,4));
        handles.curses.times(r).connect.std=std(tmpdata.data(:,4));

        handles.curses.times(r).run.avg=mean(tmpdata.data(:,5));
        handles.curses.times(r).run.tot=sum(tmpdata.data(:,5));
        handles.curses.times(r).run.std=std(tmpdata.data(:,5));

        handles.curses.times(r).write.avg=RunArray(varargin{1}(r)).RunTime - sum(tmpdata.data(1,:));
        handles.curses.times(r).write.tot=handles.curses.times(r).write.avg*RunArray(varargin{1}(r)).NumProcessors;
        handles.curses.times(r).write.std=0;

        clear tmpdata filename
    end

end

guidata(hObject,handles);

