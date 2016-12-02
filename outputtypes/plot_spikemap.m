function h=plot_spikemap(handles) 
global mypath RunArray sl

ind = handles.curses.ind;

%if isfield(handles.curses,'path')==0
    mm=importdata([RunArray(ind).ModelDirectory sl 'paths' sl RunArray(ind).MovementPath '.dat'],' ',1);
    handles.curses.path = mm.data;
    [p, r]=cart2pol(diff(handles.curses.path(:,1)),diff(handles.curses.path(:,2)));
    p(end+1)=p(end);
    r(end+1)=r(end);

    handles.curses.path(:,4)=p;
    handles.curses.path(:,5)=r;

    %handles.curses.path(:,3)=handles.curses.path(:,3)/10;
    idx=find(handles.curses.path(:,3)>RunArray(ind).SimDuration,1,'first');
    handles.curses.path(idx:end,:)=[];
    for s=1:size(handles.curses.spikerast,1)
        rr=find(handles.curses.spikerast(s,1)>=handles.curses.path(:,3),1,'last');
        handles.curses.spikepath(s,1:7) = [handles.curses.path(rr,1) handles.curses.path(rr,2) handles.curses.spikerast(s,2:3) handles.curses.path(rr,4:5) handles.curses.spikerast(s,1)];
    end
    
    borderdata=importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'bordercells.dat']);
    for d=1:1 %length(borderdata.textdata)
        borderstruct(d).name=borderdata.textdata{d};
        borderstruct(d).gid=borderdata.data(d,1);
        borderstruct(d).xbord=borderdata.data(d,2);
        borderstruct(d).xref=borderdata.data(d,3);
        borderstruct(d).yref=borderdata.data(d,4);
    end
    
    dirdata=importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'directioncells.dat']);
    for d=1:length(dirdata.textdata)
        dirstruct(d).name=dirdata.textdata{d};
        dirstruct(d).gid=dirdata.data(d,1);
        dirstruct(d).angle=dirdata.data(d,2);
    end
    
    for u=1:length(handles.curses.cells)
        if strcmp(handles.curses.cells(u).name,'movedircell')
            handles.curses.cells(u).directions = dirstruct;
        elseif strcmp(handles.curses.cells(u).name,'bordercell') || strcmp(handles.curses.cells(u).name,'borderthetacell')
            handles.curses.cells(u).directions = borderstruct;
        end
    end
    
    guidata(handles.btn_generate, handles)
%end

stepsize=30;
thetaper=125;
simpleflag=0;
origflag=0;

h(1)=figure('Color','w','Name','Spike Map - Border Cells');
h(2)=figure('Color','w','Name','Spike Map - Stellate & Pyramidal Cells');
h(3)=figure('Color','w','Name','Spike Map - Interneurons');
h(4)=figure('Color','w','Name','Movement Direction Cells');
h(5)=figure('Color','w','Name','All Moving Directions');
h(6)=figure('Color','w','Name','MS Cells');

figure(h(6))
for u=1:length(handles.curses.cells)
    subplot(length(handles.curses.cells),1,u)
    thetarast=mod(handles.curses.spikerast(handles.curses.spikerast(:,3)==handles.curses.cells(u).ind,1),thetaper)/thetaper*360;
    N = histc(thetarast,[0:stepsize:360]);
    N(end-1)=sum(N(end-1:end));
    N(end)=[];
    y=[N(:); N(:)];
    if length([0:stepsize:720-stepsize])==length(y)
        x=[0:stepsize:720-stepsize];
    else
        x=[0:stepsize:720-60];
    end
    hbar=bar(x,y,'histc');
    if ~isempty(hbar) && hbar~=0,set(hbar,'EdgeColor','none');
        set(hbar,'FaceColor','k');
    end;
    set(gca, 'xLim', [0 720]);
    title(handles.curses.cells(u).name)
end

figure(h(5))
myl=polar(p,handles.curses.path(:,3));
set(myl,'Color','b','Marker','.','LineStyle','none')

usecells=0;
if usecells==1
    addi=0;
else % usegroups
    addi=1;
end
%mleg(1)=plot(mm.data(:,1),mm.data(:,2),'Color',[.5 .5 .5]);
for ht=1:3
    figure(h(ht));
    figleg(ht).mleg(1)=plot(handles.curses.path(:,1),handles.curses.path(:,2),'Color',[.5 .5 .5]);
    figleg(ht).legstr={};
    hold on
end

figleg(4).mleg=[];
figleg(4).legstr={};

if simpleflag
    ht=1;
    figure(h(ht));
    figleg(ht).mleg(2)=plot(handles.curses.spikepath(:,1),handles.curses.spikepath(:,2),'Color','r','LineStyle','none','Marker','.','MarkerSize',10);
    figleg(ht).legstr{1}='all cells';
elseif origflag
    ht=1;
    figure(h(ht));
    ucells=unique(handles.curses.spikepath(:,3+addi));
    for u=1:length(ucells)
        if usecells
            figleg(ht).legstr{u}=['cell #' num2str(u) ' = ' num2str(sum(handles.curses.spikepath(:,3+addi)==ucells(u))) ' spikes'];
        else
            figleg(ht).legstr{u}=[handles.curses.cells(ucells(u)+1).name ' = ' num2str(sum(handles.curses.spikepath(:,3+addi)==ucells(u))) ' spikes'];
        end
        figleg(ht).mleg(u+1)=plot(handles.curses.spikepath(handles.curses.spikepath(:,3+addi)==ucells(u),1),handles.curses.spikepath(handles.curses.spikepath(:,3+addi)==ucells(u),2),'LineStyle','none','Marker','.','MarkerSize',10);
    end   
else
    for u=1:length(handles.curses.cells)
        if strcmp(handles.curses.cells(u).name,'movedircell')
            ht=4;
            figure(h(ht));
            for c=1:handles.curses.cells(u).numcells
                mind=find(handles.curses.spikepath(:,3)==(handles.curses.cells(u).range_st+c-1));
                subplot(4,5,c)
                if isempty(mind)
                    polar(0,0)
                    title(['cell #' num2str(handles.curses.cells(u).range_st+c-1) ' = ' num2str(length(mind)) ' spikes']);
                else
                    figleg(ht).mleg(end+1)=polar(handles.curses.spikepath(mind,5),handles.curses.spikepath(mind,7));
                    set(figleg(ht).mleg(end),'LineStyle','none','Marker','.','Color','b')
                end
                hold on
                bd=find([dirstruct.gid]==(handles.curses.cells(u).range_st+c-1));
                if ~isempty(bd)
                    myang=dirstruct(bd).angle-30:dirstruct(bd).angle+30;
                    [myx, myy]=pol2cart(myang/180*pi,max(max(xlim,ylim))*ones(size(myang)));
                    myy=[0 myy 0];
                    myx=[0 myx 0];
                    pp=patch(myx,myy,'c');
                    set(pp,'EdgeColor','c','FaceColor','none')
                else
                    disp(['couldnt find direction info for gid ' num2str((handles.curses.cells(u).range_st+c-1))])
                end
                title(['cell #' num2str(handles.curses.cells(u).range_st+c-1) ' = ' num2str(length(mind)) ' spikes']);
            end                
        elseif strcmp(handles.curses.cells(u).name,'bordercell') || strcmp(handles.curses.cells(u).name,'borderthetacell')
            ht=1;
            figure(h(ht));
            figleg(ht).legstr{end+1}=[handles.curses.cells(u).name ' = ' num2str(sum(handles.curses.spikepath(:,4)==(handles.curses.cells(u).ind))) ' spikes'];
            figleg(ht).mleg(end+1)=plot(handles.curses.spikepath(handles.curses.spikepath(:,4)==(handles.curses.cells(u).ind),1),handles.curses.spikepath(handles.curses.spikepath(:,4)==(handles.curses.cells(u).ind),2),'LineStyle','none','Marker','.','MarkerSize',10);
        elseif strcmp(handles.curses.cells(u).name,'stellatecell') || strcmp(handles.curses.cells(u).name,'pyramidalcell')
            ht=2;
            figure(h(ht));
            figleg(ht).legstr{end+1}=[handles.curses.cells(u).name ' = ' num2str(sum(handles.curses.spikepath(:,4)==(handles.curses.cells(u).ind))) ' spikes'];
            figleg(ht).mleg(end+1)=plot(handles.curses.spikepath(handles.curses.spikepath(:,4)==(handles.curses.cells(u).ind),1),handles.curses.spikepath(handles.curses.spikepath(:,4)==(handles.curses.cells(u).ind),2),'LineStyle','none','Marker','.','MarkerSize',10);
        elseif strcmp(handles.curses.cells(u).name,'pvbasketcell') || strcmp(handles.curses.cells(u).name,'cckcell')
            ht=3;
            figure(h(ht));
            figleg(ht).legstr{end+1}=[handles.curses.cells(u).name ' = ' num2str(sum(handles.curses.spikepath(:,4)==(handles.curses.cells(u).ind))) ' spikes'];
            figleg(ht).mleg(end+1)=plot(handles.curses.spikepath(handles.curses.spikepath(:,4)==(handles.curses.cells(u).ind),1),handles.curses.spikepath(handles.curses.spikepath(:,4)==(handles.curses.cells(u).ind),2),'LineStyle','none','Marker','.','MarkerSize',10);
        end
    end
end

for ht=1:3
    figure(h(ht));
    xlim([0 100])
    ylim([0 100])
    legend(figleg(ht).mleg,['path' figleg(ht).legstr])
end

