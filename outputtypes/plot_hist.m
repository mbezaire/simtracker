function h=plot_hist(handles,varargin) % idx contains the column in the spikeraster that gives the cell type index
global RunArray


if isfield(handles.curses,'spikerast')==0
    spikeraster(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end

myHz = 8;
bins = 12;%12;

ind = handles.curses.ind;

if ~isempty(deblank(handles.optarg)) & ~isempty(str2num(handles.optarg))
    myHz = str2num(handles.optarg);
end

thetaper=1000/myHz;
stepsize = thetaper/bins;

spikerast = handles.curses.spikerast;

tstop = RunArray(ind).SimDuration; %700;%

numcelltypes = length(handles.curses.cells);


titlestr = [RunArray(ind).RunName ': ' sprintf('%.2f', 1000/thetaper) ' Hz, ' sprintf('%.1f', thetaper) ' ms period ('  num2str(bins) ' bins), ' num2str(RunArray(ind).Stimulation) ' ' num2str(RunArray(ind).DegreeStim) ' Hz stimulation for ' num2str(tstop) ' ms'];
if ((strfind(RunArray(ind).Stimulation,'thetaspont')>0) | (strfind(RunArray(ind).Stimulation,'spontburst')>0))
    titlestr = [RunArray(ind).RunName ': ' sprintf('%.2f', 1000/thetaper) ' Hz, ' sprintf('%.1f', thetaper) ' ms period ('  num2str(bins) ' bins), ' num2str(RunArray(ind).Stimulation) ' ' num2str(RunArray(ind).DegreeStim) ' Hz stimulation ' num2str(RunArray(ind).Onint) ' ms/' num2str(RunArray(ind).Offint) ' ms  for ' num2str(tstop) ' ms'];
end
if handles.general.crop>0
    titlestr = [titlestr ' (first ' num2str(handles.general.crop) ' ms removed from analysis)'];
end

if ~isempty(varargin)
    h = histfig(handles,thetaper,stepsize,tstop,spikerast,titlestr,varargin);
else
    h = histfig(handles,thetaper,stepsize,tstop,spikerast,titlestr);
end

