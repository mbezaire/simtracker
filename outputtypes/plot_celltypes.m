function h = plot_celltypes(handles)
global RunArray logloc

try
h=[]; %figure;
idx = handles.curses.ind;


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
tmprast=handles.curses.spikerast(cropidx,:);
% 
% mydata = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/spikeraster.dat']);
% 
% mycells = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/celltype.dat']);

%handles.curses.cells.data=[];
if ~isempty(tmprast) && size(tmprast,2)>1
    for r=1:length(handles.curses.cells)
        y=histc(tmprast(:,2),handles.curses.cells(r).range_st:handles.curses.cells(r).range_en);
        handles.curses.cells(r).data(1) = length(find(y==0));
        handles.curses.cells(r).data(2) = min(y);
        handles.curses.cells(r).data(3) = max(y);
        handles.curses.cells(r).data(4) = mean(y/((RunArray(idx).SimDuration-croptime)/1000));
        handles.curses.cells(r).data(5) = std(y);
        handles.curses.cells(r).data(6) = mean(y(y~=0)/((RunArray(idx).SimDuration-croptime)/1000));
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
end
guidata(handles.btn_generate, handles)

if isdeployed
    fidout=fopen([logloc 'SimTrackerOutput.log'],'a');
    fprintf(fidout,'Calculations only include spikes from t = %d ms to end of simulation', croptime);
    fprintf(fidout,'\n%-26sGid%11s%10s%10s     ------ Spikes / Cell ------    Sub.\n', RunArray(idx).RunName(1:min(25,length(RunArray(idx).RunName))), 'Gid','Total','Cells');
    

   fprintf(fidout,'Cell Type  %9s%10s%10s%10s%10s%8s%8s%8s%8s%8s\n','#','Start','End','Cells','Silent','Min','Max','Mean','Std','Mean');
   

    for r=1:length(handles.curses.cells)
        tmp=handles.curses.cells(r).name;
        fprintf(fidout,'%-16s%4d%10d%10d%10d%10d%8d%8d%8.2f%8.2f%8.2f\n', tmp(1:min(16,length(tmp))), handles.curses.cells(r).ind ...
            , handles.curses.cells(r).range_st, handles.curses.cells(r).range_en, handles.curses.cells(r).numcells, handles.curses.cells(r).data(1), handles.curses.cells(r).data(2), handles.curses.cells(r).data(3) ...
            , handles.curses.cells(r).data(4), handles.curses.cells(r).data(5), handles.curses.cells(r).data(6));
        
    end   
    fclose(fidout);
else
    disp(['Calculations only include spikes from t= ' num2str(croptime) ' ms to end of simulation']);
    mystr = sprintf('\n%-26sGid%11s%10s%10s     ------ Spikes / Cell ------    Sub.', RunArray(idx).RunName(1:min(25,length(RunArray(idx).RunName))), 'Gid','Total','Cells');
    disp(mystr);

    mystr = sprintf('Cell Type  %9s%10s%10s%10s%10s%8s%8s%8s%8s%8s','#','Start','End','Cells','Silent','Min','Max','Mean','Std','Mean');
    disp(mystr);

    for r=1:length(handles.curses.cells)
        tmp=handles.curses.cells(r).name;
        mystr = sprintf('%-16s%4d%10d%10d%10d%10d%8d%8d%8.2f%8.2f%8.2f', tmp(1:min(16,length(tmp))), handles.curses.cells(r).ind ...
            , handles.curses.cells(r).range_st, handles.curses.cells(r).range_en, handles.curses.cells(r).numcells, handles.curses.cells(r).data(1), handles.curses.cells(r).data(2), handles.curses.cells(r).data(3) ...
            , handles.curses.cells(r).data(4), handles.curses.cells(r).data(5), handles.curses.cells(r).data(6));
        disp(mystr);
    end
end
catch ME
    if isdeployed
        msgbox({ME.identifier,ME.message,ME.stack,ME.cause})
    else
        throw(ME)
    end
end