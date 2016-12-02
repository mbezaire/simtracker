function h=plot_reltime(handles)
global mypath RunArray sl

ind = handles.curses.ind;
sl = '\'; %handles.curses.sl;

% Get timepoints
if exist([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'timeranges.mat'],'file')==2
    load([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'timeranges.mat']);
    numpulses=length(timeranges)/2;
else
    numpulses = inputdlg('Enter the number of pulses');
    numpulses=str2num(numpulses{:});
    msgbox('This may not work right anymore: findobj figure')
    myfigs = findobj('Type','figure');
    for r=length(myfigs):-1:1
        str = '';
        str=get(myfigs(r),'Name');
        if length(str)>11 && strmatch(str(end-11:end),'Spike Raster')
            [timeranges cellrange]=ginput(numpulses*2);
            break;
        end
    end
    save([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'timeranges.mat'],'timeranges','-v7.3');
end

% timeranges = 1.0e+03 * [0.0099 0.0496 0.6171 0.6369 1.2401 1.2798 1.7996 1.8472 2.3829 2.4226 2.8988 2.9385 3.4782 3.5218]';

cells={};
pulses=[];
ct=[];

disp(RunArray(ind).RunName);
for r=1:length(handles.curses.cells)
    tmp=[];
    ct(r)=0;
    for p=1:numpulses
        timerange = [timeranges((p-1)*2+1) timeranges((p-1)*2+2)];
        pulsedur(p)=diff(timerange);
        idx = find(handles.curses.spikerast(:,1)>timerange(1) & handles.curses.spikerast(:,1)<timerange(2) & handles.curses.spikerast(:,2)>=handles.curses.cells(r).range_st & handles.curses.spikerast(:,2)<=handles.curses.cells(r).range_en);
        subset=handles.curses.spikerast(idx,:);
        [~, minidx] = min(subset(:,1));
        [~, maxidx] = max(subset(:,1));
        % mean left_line right_line #_spikes #_cells
        type(r).pulse(p).min=subset(minidx,1);
        type(r).pulse(p).max=subset(maxidx,1);
        type(r).pulse(p).spikes=length(subset);
        type(r).pulse(p).cells=length(unique(subset(:,2)));
        type(r).pulse(p).idx = idx;
        if isempty(type(r).pulse(p).min) || isempty(type(1).pulse(p).min)
            ct(r)=ct(r)+1;
        else
            tmp(length(tmp)+1)=p;
        end
    end
    
    tmppulse=[];
    for p=1:numpulses
        for q=1:numpulses
            if p==q
                continue
            end
            same_cells = intersect(handles.curses.spikerast(type(r).pulse(p).idx,2), handles.curses.spikerast(type(r).pulse(q).idx,2));
            %if ~isempty(same_cells)
            %    disp(['For ' cells{r} ', comparing ' num2str(p) ' and ' num2str(q) ': ' num2str(length(same_cells))]);
            %end
            tmppulse(p,q)=length(same_cells);
        end
    end
    try
        pulses(r, 1) = mean([type(r).pulse(tmp).min]-[type(1).pulse(tmp).min]);
    catch
        'test'
    end
    pulses(r, 2) = pulses(r, 1)-std([type(r).pulse(tmp).min]-[type(1).pulse(tmp).min])/2;
    pulses(r, 3) = pulses(r, 1)+std([type(r).pulse(tmp).min]-[type(1).pulse(tmp).min])/2;
    pulses(r, 4) = mean([type(r).pulse(tmp).spikes]);
    pulses(r, 5) = std([type(r).pulse(tmp).spikes]);
    pulses(r, 6) = std([type(r).pulse(tmp).min]-[type(1).pulse(tmp).min]);
    pulsedata{r,1}=handles.curses.cells(r).name;
    pulsedata{r,2}=sprintf('%.1f',mean([type(r).pulse(:).spikes]));
    pulsedata{r,3}=sprintf('%.1f',std([type(r).pulse(:).spikes]));
    pulsedata{r,4}=sprintf('%.1f',mean(tmppulse(:)));
    pulsedata{r,5}=sprintf('%.1f',std(tmppulse(:)));
    pulsedata{r,6}=sprintf('%.1f',mean([type(r).pulse(:).cells]));
    pulsedata{r,7}=sprintf('%.1f',std([type(r).pulse(:).cells]));
    pulsedata{r,8}=handles.curses.cells(r).numcells;
       
    % disp([handles.curses.cells(r).name ' # of overlapping cells each pulse: ' num2str(mean(tmppulse(:))) ' +/- ' num2str(std(tmppulse(:))) ' out of ' num2str(handles.curses.cells(r).numcells) ' cells']);
end

colvec={'Cell','Avg Spikes','Std Spikes','Avg Shared Cells','Std Shared Cells','Avg Used Cells','Std Used Cells','Total Cells'};

h=figure('Color','w');
colform ={'char','numeric','numeric','numeric','numeric','numeric'}; %,'numeric','numeric'};
tableh = uitable(h, 'Data', pulsedata, 'ColumnName', colvec);%,'ColumnFormat',colform);
textent=get(tableh,'Extent');
set(tableh,'Position',[0 0 textent(3) textent(4)]);
set(h,'Position',[100 100 textent(3) textent(4)+textent(4)/4]);
axh=axes('Units',get(h,'Units'),'Position',[0 textent(4) textent(3) textent(4)/4],'xlim',[0 1],'ylim',[0 1]);
axis off
text(.5,.5,[num2str(numpulses) ' pulses of duration ' sprintf('%.0f',mean(pulsedur)) ' ms (+/- ' sprintf('%.0f',std(pulsedur)) ' ms)'],'Parent',axh,'FontSize',12,'HorizontalAlignment','center')

save([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl  'timeranges.mat'],'timeranges','pulsedata','-v7.3');

[~, idx]=sort(pulses(:,1));
pulses=pulses(idx,:);
cells={handles.curses.cells(idx).name};

h(2)=figure('Color','w');
for r=1:size(pulses,1)
    plot(pulses(r,1),r,'LineStyle','None','Marker','.','MarkerSize',10)
    hold on
    plot([pulses(r,2) pulses(r,3)], [r r],'-')
    text(pulses(r,1),r-.5,[cells{r} ' ' sprintf('%.1f',pulses(r, 1)) ' +/- ' sprintf('%.1f',pulses(r, 6)) ' ms'])
    if ct(r)>0
        text(pulses(r,1),r-.75,['Skipped ' num2str(ct(r)) ' pulses'])
    end
    % text(pulses(r,1),r-.5,[cells{r} ' ' sprintf('%.0f',pulses(r, 4)) ' +/- ' sprintf('%.0f',pulses(r, 5)) ' spikes']) 
end

yl = get(gca,'ylim');
ylim([0 yl(2)+1]);

xl = get(gca,'xlim');
xlim([xl(1)-1 xl(2)]);

xlabel('Lag time relative to first pyramidal cell spike of pulse (ms)')
ylabel('Cell type')