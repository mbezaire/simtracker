function h=plot_traces(handles) % idx contains the column in the spikeraster that gives the cell type index
global RunArray sl

h=[]; %figure;
idx = handles.curses.ind;
%sl = handles.curses.sl;
plotall=0;
d=1;
if plotall==1
    a=dir([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/trace_*.dat']);

    for r=1:length(a)
        h(r) = figure('Color', 'w');
        b=importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/' a(r).name]);
        plot(b.data(:,1),b.data(:,2));
        title(strrep(strrep(a(r).name(7:end),'cell',' cell, gid: '),'.dat',''))
        xlabel('Time (ms)')
        ylabel('Potential (mV)')
        ylim([-90 0])
    end

    clear a b
else
    plotmax=1;
    filename = [RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'celltype.dat'];

    if exist(filename,'file')==0
        sprintf('Warning: celltype.dat file is missing\nPath: %s', filename);
        return
    end
    tmpdata = importdata(filename);

    for z=1:size(tmpdata.textdata,1)-1
        a=dir([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/trace_' tmpdata.textdata{z+1,1} '*.dat']);

        for r=1:min(length(a),plotmax)
            h(d) = figure('Color','w','Name',['Trace for ' tmpdata.textdata{z+1,1}]);
            b=importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/' a(r).name]);
            plot(b.data(:,1),b.data(:,2));
            title(strrep(strrep(a(r).name(7:end),'cell',' cell, gid: '),'.dat',''))
            xlabel('Time (ms)')
            ylabel('Potential (mV)')
            ylim([-90 30])
            d=d+1;
        end

        clear a b
    end
end