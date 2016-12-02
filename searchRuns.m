function idx=searchRuns(searchfield,searchval,numtype,varargin)
% This function searches through all the runs in RunArray using the
% user-provided search critera: which field to search, which value to
% search for, and what type of relation between the search value and the
% results (should equal, not equal, etc)
% idx=searchRuns(searchfield,searchval,numtype[,searchstyle])

global mypath RunArray
try
searchstyle='=';
searchidx=1:length(RunArray);
if ~isempty(varargin)
    searchstyle=varargin{1};
    if length(varargin)>1
        searchidx=varargin{2};
    end
end
if numtype==0 % string
    % search text fields
    if strcmp(searchstyle,'*')==1
        myt = regexp({RunArray(searchidx).(searchfield)},['[A-Za-z0-9_]*' strrep(searchval,'*','[A-Za-z0-9_]*') '[A-Za-z0-9_]*']);
        tmpidx=[];
        for r=1:length(myt)
            if ~isempty(myt{r})
                tmpidx=[tmpidx searchidx(r)]; %#ok<AGROW>
            end
        end
    else
        try
        eval(['tmpidx=find(strcmp(searchval,{RunArray(searchidx).(searchfield)})' searchstyle '=1);'])
        catch
            tmpidx=[];
        end
    end
elseif numtype==1
    % search numeric fields
    try
    eval(['tmpidx=find([RunArray(searchidx).(searchfield)]' searchstyle '=searchval);'])
    catch
        tmpidx=[];
    end

else
    tmpidx=[];
end
idx=searchidx(tmpidx);
catch ME
    handleME(ME)
end
