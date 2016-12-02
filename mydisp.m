
function mydisp(mystr,handles)
global logloc

if isdeployed
    if length(mystr)<200
        msgbox(mystr)
    else
        fid = fopen([logloc 'SimTrackerOutput.log'],'a');
        fprintf(fid,'%s\n',mystr);
        fclose(fid);
        system([handles.general.textviewer ' ' logloc 'SimTrackerOutput.log']);
    end
else
    disp(mystr)
end