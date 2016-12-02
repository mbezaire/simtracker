function formdata(handles,varargin)
global mypath RunArray sl

try

if ~isempty(varargin)
    ind = varargin{1};
    if isempty(ind)
        ind = handles.curses.ind;
        if isempty(ind)
                return
        end
    end    
    executioninfo=[{''} {''} {''} {''} {''} {''} {''}]';
    set(handles.table_executioninfo,'Data',executioninfo)
    if length(varargin)>1 && ~isempty(varargin{2})
        parameters=varargin{2};
    else
        q=getcurrepos(handles);
        load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
        parameters=switchSimRun({},myrepos(q).dir);
    end
else
    ind = handles.curses.ind;
    if isempty(ind)
        return
    end
    executioninfo=[{RunArray(ind).ExecutionDate} {RunArray(ind).ExecutedBy} {num2str(RunArray(ind).RunTime,'%10.2f')} {RunArray(ind).NumCells} {RunArray(ind).NumConnections} {RunArray(ind).NumSpikes} {RunArray(ind).NumCellsRecorded}]';
    set(handles.table_executioninfo,'Data',executioninfo)
    q=getcurrepos(handles);
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
    parameters=switchSimRun({myrepos.dir},myrepos(q).dir);
end

idx = find([parameters(:).form]==1); %#ok<NODEF>
myorder = ([parameters(idx).list] - floor([parameters(idx).list]))*100+floor([parameters(idx).list]);
myorder(myorder==0)=max(myorder)+1;
[~, sorti]=sort(myorder);
idx=idx(sorti);
myrows={parameters(idx).nickname};
set(handles.table_siminfo,'RowName',myrows);
siminfo=[];
for r=1:length(idx)
    siminfo=[siminfo {RunArray(ind).(parameters(idx(r)).name)}]; %#ok<AGROW>
end
set(handles.table_siminfo,'Data',siminfo')
catch ME
    handleME(ME)
end
