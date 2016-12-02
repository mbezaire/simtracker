function h=clk_spikeraster(handles)

ind = handles.curses.ind;
sl = '\'; %handles.curses.sl;
fl=0;
h=[];
    msgbox('This may not work right anymore: findobj figure')
myfigs = findobj('Type','figure');
for r=length(myfigs):-1:1
    str = '';
    str=get(myfigs(r),'Name');
    if ~isempty(str) & length(str)>11 & strmatch(str(end-11:end),'Spike Raster')
        figure(myfigs(r));
        [timerange cellrange]=ginput(2);
        
        for t=1:length(handles.curses.cells)
            idx = find(handles.curses.spikerast(:,1)>timerange(1) & handles.curses.spikerast(:,1)<timerange(2) & handles.curses.spikerast(:,2)>=handles.curses.cells(t).range_st & handles.curses.spikerast(:,2)<=handles.curses.cells(t).range_en);

            subset=handles.curses.spikerast(idx,:);

            [~, minidx] = min(subset(:,1));
            [~, maxidx] = max(subset(:,1));
            
            mydata{t,1} = handles.curses.cells(t).name; % cell type
            mydata{t,2} = Sep1000Str(size(subset,1)); % # spikes
            mydata{t,3} = Sep1000Str(length(unique(subset(:,2)))); % # cells to spike 
            mydata{t,4} = sprintf('%.1f',subset(minidx,1)); % first spike
            mydata{t,5} = sprintf('%.1f',size(subset,1)/(subset(maxidx,1)-subset(minidx,1))*1000/handles.curses.cells(t).numcells); % firing rate
            mydata{t,6} = sprintf('%.1f',size(subset,1)/(subset(maxidx,1)-subset(minidx,1))*1000/length(unique(subset(:,2)))); % firing rate
            % mydata{t,7} = subset(minidx,2); % first cell to spike
            % mydata{t,8} = subset(maxidx,2); % last cell to spike

        end
        h=figure('Color','w');
        colvec={'Cell','# Spks','# Cells','1st spike','Pop Hz','Sub Hz'}; %,'1st cell','Last cell'};
        colform ={'char','numeric','numeric','numeric','numeric','numeric'}; %,'numeric','numeric'};
        tableh = uitable(h, 'Data', mydata, 'ColumnName', colvec,'ColumnFormat',colform);
        textent=get(tableh,'Extent');
        set(tableh,'Position',[0 0 textent(3) textent(4)]);
        set(h,'Position',[100 100 textent(3) textent(4)+textent(4)/4]);
        axh=axes('Units',get(h,'Units'),'Position',[0 textent(4) textent(3) textent(4)/4],'xlim',[0 1],'ylim',[0 1]);
        axis off
        text(.5,.5,['Between ' num2str(round(subset(minidx,1))) ' ms and ' num2str(round(subset(maxidx,1))) ' ms (' num2str(round(subset(maxidx,1)-subset(minidx,1))) ' ms)'],'Parent',axh,'FontSize',18,'HorizontalAlignment','center')

        fl=1;
        break;
    end
end
if fl==0
    msgbox('Open a spikeraster first.')
end

function [gidrange, celltype]=getrange(cellrange,handles)
global RunArray

gidrange=[];
celltype='';
ind = handles.curses.ind;
sl = '\'; %sl = handles.curses.sl;

mycells = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'celltype.dat']);
for r=1:size(mycells.data,1)
    if cellrange(1)>mycells.data(r,2) && cellrange(2)<mycells.data(r,3)
        gidrange = [mycells.data(r,2) mycells.data(r,3)];
        celltype=char(mycells.textdata(1+r));
    end
end




function S = Sep1000Str(N)
% Jan Simon: http://www.mathworks.com/matlabcentral/answers/32171-function-to-format-number-as-currency
S = sprintf('%d', N);
if length(S)<4
    return;
end
S(2, length(S)-3:-3:0) = ','
S = transpose(S(S ~= char(0)))