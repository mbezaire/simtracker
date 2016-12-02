function h=plot_crosscorr(handles,varargin)
global RunArray

ind = handles.curses.ind;

popflag=1; % 0 = compute cross corr for single cells only, 1 = compute it for population, too

if ~isempty(varargin)
    mycomps=varargin{1};
else
    mycomps={'pyramidalcell','pvbasketcell';'cckcell','pvbasketcell'};
    %mycomps={'supercell','pvbasketcell';'deepcell','pvbasketcell'};
end

cutoff=10;
if ~isempty(deblank(handles.optarg)) & ~isempty(str2num(handles.optarg))
    cutoff = str2num(handles.optarg);
end

numpairs=size(mycomps,1);

if isfield(handles.curses,'spikerast')==0
    spikeraster(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'numcons')==0
    numcons(handles.btn_generate,handles);
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'spikerast')==1 && size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end

% get cross corr between two cells in population
addbar=[];
legstr={};
h(1)=figure('color','w');
maxy=0;
for r=1:numpairs
    if popflag
        cellA_idx=handles.curses.cells(find(strcmp({handles.curses.cells.name},mycomps{r,1})==1)).ind;
        cellB_idx=handles.curses.cells(find(strcmp({handles.curses.cells.name},mycomps{r,2})==1)).ind;

        cellAspikes = handles.curses.spikerast((handles.curses.spikerast(:,3)==cellA_idx),1);
        cellBspikes = handles.curses.spikerast((handles.curses.spikerast(:,3)==cellB_idx),1);
    else
        cellA_idx=handles.curses.cells(find(strcmp({handles.curses.cells.name},mycomps{r,1})==1)).range_st;
        cellB_idx=handles.curses.cells(find(strcmp({handles.curses.cells.name},mycomps{r,2})==1)).range_st;

        cellAspikes = handles.curses.spikerast((handles.curses.spikerast(:,2)==cellA_idx),1);
        cellBspikes = handles.curses.spikerast((handles.curses.spikerast(:,2)==cellB_idx),1);
    end
    
    cellAdata=histc(cellAspikes,[0:RunArray(ind).SimDuration]);
    cellBdata=histc(cellBspikes,[0:RunArray(ind).SimDuration]);
    
    [acor,lag] = xcorr(cellAdata,cellBdata);
    
    plotidx=find(lag>=-cutoff & lag<=cutoff);
    subplot(numpairs,1,r)
    bar(lag(plotidx),acor(plotidx))
    
    if popflag
        title([RunArray(ind).RunName ': ' mycomps{r,1} ' to ' mycomps{r,2} ', population'],'Interpreter','none')
    else
        title([RunArray(ind).RunName ': ' mycomps{r,1} ' to ' mycomps{r,2} ', two cells'],'Interpreter','none')
    end
end
