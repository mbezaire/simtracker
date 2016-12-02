function h=load_results(hObject,handles)
global RunArray

if isfield(handles.curses,'spikerast')==0 || isempty(handles.curses.spikerast)
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
if isfield(handles.curses,'lfp')==0 && (RunArray(handles.curses.ind).ComputeLFP + RunArray(handles.curses.ind).ComputeDipoleLFP + RunArray(handles.curses.ind).ComputeNpoleLFP )>0
    getlfp(handles.btn_generate,guidata(handles.btn_generate));
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'spikerast')==1 && size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end
if isfield(handles.curses,'spikerast') && ~isempty(handles.curses.spikerast) && size(handles.curses.spikerast,2)>1 && RunArray(handles.curses.ind).SimDuration>50
    for r=1:length(handles.curses.cells)
        idx = find(handles.curses.spikerast(:,2)>=handles.curses.cells(r).range_st & handles.curses.spikerast(:,2)<=handles.curses.cells(r).range_en);
        idt = find(handles.curses.spikerast(idx,1)>handles.general.crop);

        binned= histc(handles.curses.spikerast(idx(idt),1),[handles.general.crop:1:RunArray(handles.curses.ind).SimDuration]); % binned by 1 ms
        window=3; % ms
        kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
        sdf = conv(binned,kernel,'same');

        [f, fft_results]=mycontfft([handles.general.crop:1:RunArray(handles.curses.ind).SimDuration],sdf);
        
        % [f, fft_results]=myfft(handles.curses.spikerast(idx(idt),1),RunArray(handles.curses.ind).SimDuration,1);
        try
            handles.curses.cells(r).sdf = [[handles.general.crop:1:RunArray(handles.curses.ind).SimDuration]' sdf];
        catch
            sdf=sdf';
            handles.curses.cells(r).sdf = [[handles.general.crop:1:RunArray(handles.curses.ind).SimDuration]' sdf];
        end
        handles.curses.cells(r).f = f;
        handles.curses.cells(r).fft_results = fft_results;
        
        y=histc(handles.curses.spikerast(:,2),handles.curses.cells(r).range_st:handles.curses.cells(r).range_en);
        handles.curses.cells(r).data(1) = length(find(y==0));
        handles.curses.cells(r).data(2) = min(y);
        handles.curses.cells(r).data(3) = max(y);
        handles.curses.cells(r).data(4) = mean(y/(RunArray(handles.curses.ind).SimDuration/1000));
        handles.curses.cells(r).data(5) = std(y);
        handles.curses.cells(r).data(6) = mean(y(y~=0)/(RunArray(handles.curses.ind).SimDuration/1000));
    end
else
    for r=1:length(handles.curses.cells)
        handles.curses.cells(r).data(1) = handles.curses.cells(r).numcells;
        for z=2:6
            handles.curses.cells(r).data(z) = 0;
        end
    end
end

myfields=fieldnames(handles.curses);


for r=1:length(myfields)
    structresults.curses.(myfields{r}) = handles.curses.(myfields{r});
end

structresults.runinfo = RunArray(handles.curses.ind);

myfields=fieldnames(handles.formatP);

for m=1:length(myfields)
    structresults.formatP.(myfields{m})= handles.formatP.(myfields{m});
end

assignin('base',RunArray(handles.curses.ind).RunName,structresults);
beep
h=[];
