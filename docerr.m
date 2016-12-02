function docerr(ME)
global logloc

fid = fopen([logloc 'SimTrackerOutput.log'],'a');

fprintf(fid,'%s\n',ME.identifier);
fprintf(fid,'%s\n\n',ME.message);
for r=1:length(ME.stack)
    fprintf(fid,'%s\n\t%s\n\t%g\n\n', ME.stack(r).file, ME.stack(r).name, ME.stack(r).line);
end
fclose(fid);

errordlg(ME.message)
