function update_avail_outputs(handles)
% This function will update the table of available outputs based on the
% results printed from the selected run

global RunArray sl %#ok<NUSED> because it will be used in the eval statement below
try
if isempty(handles.curses.ind)
    return
end

ind = handles.curses.ind; %#ok<NASGU> because it is used in the eval statement
avail={};

for r=1:length(handles.myoutputs)
    flag=1;
    for k=1:length(handles.myoutputs(r).needs)
        mytest=0;
        try
            mytest=eval(handles.myoutputs(r).needs(k).eval);
        catch ME
            handleME(ME)
        end
        if ~mytest
            flag=0;
        end
    end
    if flag==1
        id=size(avail,1)+1;
        avail{id,1}=handles.myoutputs(r).output; %#ok<AGROW>
        avail{id,3}=' '; %#ok<AGROW> %{handles.myoutputs(r).formats};
        avail{id,4}=handles.myoutputs(r).description; %#ok<AGROW>
    end
end

set(handles.tbl_outputtypes,'Data',avail);
catch ME
    handleME(ME)
end