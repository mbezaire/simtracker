
function saveRuns(handles)
% This function saves the current RunArray to a file

global mypath RunArray sl donotsave %#ok<NUSED>
if donotsave
    return
end
try

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos') 

if isempty(q)
    msgbox('Error: the current repository was not specified. Canceling operation now')
    return
end
set(handles.txt_datalabel,'String',['Current Directory: ' myrepos(q).dir])

for r=1:length(RunArray)
    RunArray(r).ModelDirectory=myrepos(q).dir;
end

if ~isa(RunArray,'SimRun') && ~isempty(RunArray)
    msgbox('Corrupted RunArray... NOT SAVING.')    
elseif ~isempty(RunArray)
        if exist([myrepos(q).dir sl 'results'],'dir')==0
            mkdir([myrepos(q).dir sl 'results']);
        end
        save([myrepos(q).dir sl 'results' sl 'RunArrayData.mat'], 'RunArray','-v7.3');
        tmp=load([myrepos(q).dir sl 'results' sl 'RunArrayData.mat']);

    if ~isa(tmp.RunArray,'SimRun')
        msgbox({'THE FILE WAS NOT SAVED PROPERLY',' ','    RunArrayData.mat',})
    end
elseif exist([myrepos(q).dir sl 'results' sl 'RunArrayData.mat'],'file')
    btn=questdlg('Save an empty repository?','Confirm save','Yes','No','Yes');
    switch btn
        case 'Yes'
            delete([myrepos(q).dir sl 'results' sl 'RunArrayData.mat'])
    end
end

catch ME
    handleME(ME)
end