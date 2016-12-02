
function q=getcurrepos(handles, varargin)
global mypath sl

if exist([mypath sl 'data' sl 'myrepos.mat'])
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos') % backupfolder remotebackup
    for r=length(myrepos):-1:1
        if exist(myrepos(r).dir,'dir')==0
            myrepos(r)=[];
        elseif ispc
            myrepos(r).dir=strrep(myrepos(r).dir,'/','\'); % in case it somehow gets saved with slashes wrongly, as it did on one of mine
        end
    end
    if isempty(myrepos)
        if ~isempty(varargin)
            q=[];
            return
        else
            [ST,I] = dbstack;
            NewRepos(handles.menuitem_new, [], handles) 
            load([mypath sl 'data' sl 'myrepos.mat'],'myrepos') % backupfolder remotebackup
        end
    end
else
    if ~isempty(varargin)
        q=[];
        return
    else
        NewRepos(handles.menuitem_new, [], handles) 
        load([mypath sl 'data' sl 'myrepos.mat'],'myrepos') % backupfolder remotebackup
    end
end

q=find([myrepos(:).current]==1);

if isempty(q)
    if ~isempty(varargin)
        q=length(myrepos);
        return
    end
    [~, loadname, val] = archive_gui(0);
elseif length(q)>1
    for r=1:length(q)-1
        myrepos(q(r)).current=0;
    end
    q=q(end);
end

save([mypath sl 'data' sl 'myrepos.mat'],'myrepos','-append') % backupfolder remotebackup
    


