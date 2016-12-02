function RefreshList(hObject, eventdata, handles) % --- Executes on selection change in list_view.
% This function refreshes the view of the runs in the table tbl_runs
global mypath RunArray searchterms sl % searchterms is a global mypath variable accessed by some subGUIs called if certain views are picked


if isempty(RunArray) % If no runs, then there is nothing to display
    %msgbox('Empty RunArray')
    set(handles.tbl_runs,'Data',[]);
    set(handles.txt_numruns,'String','0 runs')
    return
end

% 1. Pick the indices of the RunArray that contain the runs to be displayed
contents = cellstr(get(hObject,'String'));
switch contents{get(hObject,'Value')} % find the runs that should appear for each view condition
    case 'All' % Show all runs in this directory
        idx=1:length(RunArray);

    case 'Errored Out' % Show all runs that have an error value in their Errors property
        idx=searchRuns('Errors','',0,'~');

    case 'Find Error' % Show all runs that are likely to have errored, but do not have an error value entered yet
        idx1=searchRuns('ExecutionDate','',0,'~');
        idx2=searchRuns('RunTime',0,1);
        idx3=intersect(idx1,idx2);
        idx4=searchRuns('Errors','',0);
        idx=intersect(idx3,idx4);

    case 'Not Ran' % Show all runs that have not yet been executed/do not have results uploaded yet
        idx1=searchRuns('ExecutionDate','',0);
        idx2=searchRuns('Errors','',0,'=');
        idx=intersect(idx1,idx2);

    case 'Ran' % Show all runs that have been executed and their results uploaded
        idx=searchRuns('ExecutionDate','',0,'~');

    case 'Ran Without Error' % Show all runs that have been executed and appear to have been successful
        idx1=searchRuns('ExecutionDate','',0,'~');
        idx2=searchRuns('RunTime',0,1,'~');
        idx=intersect(idx1,idx2);

    case 'Similar to Selection Name' % Show all runs that have the same root name as the selected one
        ind = handles.curses.ind;
        mystr=RunArray(ind).RunName;
        idxt=strfind(mystr,'_');
        NameStr=mystr(1:idxt(1)-1);

        idx=searchRuns('RunName',NameStr,0,'*');

    case 'Group A, B, C' % Show all runs that belong to the groups selected by the user
        h = searchgui({handles.groups(:).name});
        uiwait(h)
        mygroup = searchterms;
        idxstruct=[];
        is=0;
        mystr='';
        for r=1:length(mygroup)
            if ~isempty(mygroup{r})
                is = is + 1;
                if strcmp(mygroup{r},'~')
                    idxstruct(is).idx=searchRuns('Groups',handles.groups(r).name,0,'*'); %#ok<AGROW>
                    idxstruct(is).idx=setdiff(1:length(RunArray),idxstruct(is).idx); %#ok<AGROW>
                else
                    idxstruct(is).idx=searchRuns('Groups',handles.groups(r).name,0,'*'); %#ok<AGROW>
                end
                mystr = [mystr handles.groups(r).name ',']; %#ok<AGROW>
                idxstruct(is).type=mygroup{r}; %#ok<AGROW>
            end
        end

        if isempty(idxstruct)
            idx=[];
            set(handles.txt_numruns,'String',[num2str(length(idx)) ' of ' num2str(length(RunArray)) ' runs'])
            set(handles.tbl_runs,'Data',[]);
            return
        else
            idx = idxstruct(1).idx;
        end
        while is>1
            idx = intersect(idx,idxstruct(is).idx);
            is = is - 1;
        end

    case 'Error A, B, C' % Show all runs that contain the error(s) selected by the user
        h = searchgui({handles.myerrors(2:end).errorphrase});
        uiwait(h)
        mygroup = searchterms;
        idxstruct=[];
        is=0;
        mystr='';
        for r=1:length(mygroup)
            if ~isempty(mygroup{r})
                is = is + 1;
                if strcmp(mygroup{r},'~')
                    idxstruct(is).idx=searchRuns('Errors',handles.myerrors(r+1).errorphrase,0,'*'); %#ok<AGROW>
                    idxstruct(is).idx=setdiff(1:length(RunArray),idxstruct(is).idx); %#ok<AGROW>
                else
                    idxstruct(is).idx=searchRuns('Errors',handles.myerrors(r+1).errorphrase,0,'*'); %#ok<AGROW>
                end
                mystr = [mystr handles.myerrors(r+1).errorphrase ',']; %#ok<AGROW>
                idxstruct(is).type=mygroup{r}; %#ok<AGROW>
            end
        end

        if isempty(idxstruct)
            idx=[];
            set(handles.txt_numruns,'String',[num2str(length(idx)) ' of ' num2str(length(RunArray)) ' runs'])
            set(handles.tbl_runs,'Data',[]);
            return
        else
            idx = idxstruct(1).idx;
        end
        while is>1
            idx = intersect(idx,idxstruct(is).idx);
            is = is - 1;
        end

    case 'Comments'  % Search for runs with specific words in their comments
        NameStr=inputdlg('Enter the word(s) to search for');
        sp=strfind(NameStr{1},' ');
        id=1;
        idx=[];
        for r=1:length(sp)
            word{r}=NameStr{1}(id:sp(r)-1); %#ok<AGROW>
            id=sp(r)+1;
            if ~isempty(word{r})
                idx=[idx searchRuns('RunComments',word{r},0,'*')]; %#ok<AGROW>
            end
        end
        if ~isempty(sp)
            word{length(sp)+1}=NameStr{1}(id:end);
            if ~isempty(word{length(sp)+1})
                idx=[idx searchRuns('RunComments',word{length(sp)+1},0,'*')];
            end
            idx=unique(idx);
        else
            idx=searchRuns('RunComments',NameStr{1},0,'*');
        end

    case 'UID' % Search for the run with the specific UID
        NameStr=inputdlg('Enter the UID to search for');
        if isempty(NameStr) || isempty(NameStr{1})
            return
        end
        idx=searchRuns('UID',NameStr{1},0,'=');

    case 'Custom Filter' % Allow user to create their own search filter
        searchparams = inputdlg({'Property to search:','Value to search for:','Property type (String: 0, Number: 1):','(Optional) Type (=,~,>,<,*):'},'Enter Search Properties');
        if ~isempty(searchparams)
            searchfield = searchparams{1};
            searchval = searchparams{2};
            numtype = str2double(searchparams{3});
            searchstyle = searchparams{4};
            if numtype==1
                searchval = str2num(searchval); %#ok<ST2NM>
            end
            if isempty(searchstyle)
                idx=searchRuns(searchfield,searchval,numtype);
            else
                idx=searchRuns(searchfield,searchval,numtype,searchstyle);
            end
        else
            idx=1:length(RunArray);
        end
    otherwise
        idx=1:length(RunArray);
end

% 2. Extract the data to displayed in the table from each of the runs
newdata=[]; % data (runs of interest) to put in the table

if ~isempty(idx)
    % sort newdata by most recent execution date
    dateidx=zeros(length(idx),1);
    for r=1:length(idx)
        if isempty(RunArray(idx(r)).ExecutionDate)
            dateidx(r)=0;
        else
            if isstr(RunArray(idx(r)).ExecutionDate) && strcmp(RunArray(idx(r)).ExecutionDate,'unknown')
                mydate = inputdlg(['Enter the execution date for run ' RunArray(idx(r)).RunName],'Enter Date',1,{'28-Oct-2013 22:00:00'});
                RunArray(idx(r)).ExecutionDate = mydate{:};
            end
            dateidx(r)=datenum(RunArray(idx(r)).ExecutionDate);
        end
    end
    [~, I] = sort(dateidx,'descend');
    idx=idx(I);
    dateidx=dateidx(I);

    % For runs not executed, sort in opposite order so newly created ones
    % show first
    zidx=find(dateidx==0);
    idx(zidx)=fliplr(idx(zidx));

    % Display a formatted execution date
    datecol=repmat({''},length(idx),1);
    for r=1:length(idx)
        if ~isempty(RunArray(idx(r)).ExecutionDate)
            datecol(r,1) = cellstr(datestr({RunArray(idx(r)).ExecutionDate},'ddmmmyy HH:MM'));
        else
            datecol(r,1) = {''};
        end
    end

    % Build the table data one column at a time; find all the parameters to include in the list
    mycols={};
    t=1;
    for r=1:max([handles.parameters(:).list]) %#ok<NODEF> 
        bx = find(floor([handles.parameters(:).list])==r); % and display them in the order set by the user in the parameters GUI
        if ~isempty(bx)
            bg = strfind(handles.parameters(bx(1)).nickname,' ');
            if ~isempty(bg) % Create the header line for the table, use | for a newline
                mycols{t}=[handles.parameters(bx(1)).nickname(1:bg(end)-1) '|' handles.parameters(bx(1)).nickname(bg(end)+1:end)]; %#ok<AGROW>
            else
                mycols{t}=[' |' handles.parameters(bx(1)).nickname]; %#ok<AGROW>
            end
            if strcmp('ExecutionDate',handles.parameters(bx(1)).name)==1 % If the ExecutionDate is to be displayed, display the nicely formatted column instead
                newdata=[newdata datecol]; %#ok<AGROW>
            else
                newdata=[newdata {RunArray(idx).(handles.parameters(bx(1)).name)}']; %#ok<AGROW>
            end
            t=t+1;
        end
    end
end

% Update the table tbl_runs data and column headers

for z=1:size(newdata,1)
    for p=1:size(newdata,2)
        try
            mym = newdata{z,p};
        catch
            msgbox(['newdata{' num2str(z) ',' num2str(p) '}'])
            msgbox(newdata{z,p})
        end
        
    end
end

for n=1:size(newdata,1)
    if iscell(newdata{n,1})
        newdata{n,1}=newdata{n,1}{:};
    end
end

set(handles.tbl_runs,'Data',newdata);
if exist('mycols','var')
    set(handles.tbl_runs,'ColumnName',mycols);
end

% Display above the table the number of runs returned
if strcmp('Group A, B, C',contents{get(hObject,'Value')})==1
    set(handles.txt_numruns,'String',[num2str(length(idx)) ' of ' num2str(length(RunArray)) ' runs, groups: ' mystr(1:end-1)])
else
    set(handles.txt_numruns,'String',[num2str(length(idx)) ' of ' num2str(length(RunArray)) ' runs'])
end

% Update the formdata, etc, to show the first run now displayed in the tbl_runs
if ~isempty(newdata) && ~isempty(eventdata)
    CellSelected(handles.tbl_runs, eventdata, handles) 
end