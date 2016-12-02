function [h, varargout] = plot_firingrates(handles)
global mypath RunArray

try
h=[]; %figure;
idx = handles.curses.ind;

if ~isempty(deblank(handles.optarg))
    figtype = deblank(handles.optarg);
else
    figtype=''; %'subset'; 'all'
end


if isfield(handles.curses,'spikerast')==0
    spikeraster(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'spikerast')==1 && size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end

croptime = handles.general.crop;
cropidx=find(handles.curses.spikerast(:,1)>croptime);
handles.curses.croprast=handles.curses.spikerast(cropidx,:);
% 
% mydata = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/spikeraster.dat']);
% 
% mycells = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/celltype.dat']);

%handles.curses.cells.data=[];
if isfield(handles.curses,'croprast') && ~isempty(handles.curses.croprast) && size(handles.curses.croprast,2)>1
    for r=1:length(handles.curses.cells)
        y=histc(handles.curses.croprast(:,2),handles.curses.cells(r).range_st:handles.curses.cells(r).range_en);
        handles.curses.cells(r).data(1) = length(find(y==0));
        handles.curses.cells(r).data(2) = min(y);
        handles.curses.cells(r).data(3) = max(y);
        handles.curses.cells(r).data(4) = mean(y/((RunArray(idx).SimDuration-croptime)/1000));
        handles.curses.cells(r).data(5) = std(y);
        if isempty(y(y~=0))
            handles.curses.cells(r).data(6) = 0;
            handles.curses.cells(r).data(7) = 0;
            handles.curses.cells(r).data(8) = 0;
        else
            handles.curses.cells(r).data(6) = mean(y(y~=0)/((RunArray(idx).SimDuration-croptime)/1000));
            handles.curses.cells(r).data(7) = max(y(y~=0)/((RunArray(idx).SimDuration-croptime)/1000));
            handles.curses.cells(r).data(8) = min(y(y~=0)/((RunArray(idx).SimDuration-croptime)/1000));
        end
    end
else
    for r=1:length(handles.curses.cells)
        handles.curses.cells(r).data(1) = handles.curses.cells(r).numcells;
        for z=2:6
            handles.curses.cells(r).data(z) = 0;
        end
    end
end

realidx=[];
for r=1:length(handles.curses.cells)
    if strcmp(handles.curses.cells(r).techname,'ppspont')==0
        realidx=[realidx r];
    end
end

popfire=[];
subfire=[];
if exist('firingrates.mat','file')
    load firingrates.mat firingrates
    for r=realidx
        popfire(r)=handles.curses.cells(r).data(4);
        subfire(r)=handles.curses.cells(r).data(6);
        awake(r)=0;
        anesth(r)=0;
        mynames{r}=handles.curses.cells(realidx(r)).name;
        myi=find(strcmp(handles.curses.cells(r).name,{firingrates(:).celltype})==1);
        if ~isempty(myi)
            awake(r)=firingrates(myi).awake;
            anesth(r)=firingrates(myi).anesth;
            if strmatch(firingrates(myi).notes,'est.')
                mynames{r}=[handles.curses.cells(realidx(r)).name(1:end-4) '*'];
            end
        end
    end
    %mynames={handles.curses.cells(realidx).name};
    
    h=[];
    if strcmp(figtype,'subset')==0
        h(length(h)+1)=figure('color','w','Name','Population Firing Rates','units','normalized','outerposition',[0 0 1 1]);
        bar([popfire' anesth' awake'])
        set(gca,'xticklabel',mynames)
        ylabel('Firing frequency (Hz)')
        title([RunArray(idx).RunName ': Average firing rate of population'],'Interpreter','none')
        legend({'Model','Exp. Anesth.','Exp. Awake'})
    end
    if strcmp(figtype,'all')==0
        h(length(h)+1)=figure('color','w','Name','Subset Firing Rates','units','normalized','outerposition',[0 0 1 1]);
        bar([subfire' anesth' awake'])
        set(gca,'xticklabel',mynames)
        ylabel('Firing frequency (Hz)')
        title([RunArray(idx).RunName ': Average firing rate of firing cells (* means awake data was estimated)'],'Interpreter','none')
        legend({'Model','Exp. Anesth.','Exp. Awake'})
    end
end

try
    guidata(handles.btn_generate, handles)
end

if nargout>0
    varargout{1}=handles.curses.cells;
end

catch ME
    if isdeployed
        msgbox({ME.identifier,ME.message,ME.stack,ME.cause})
    else
        throw(ME)
    end
end