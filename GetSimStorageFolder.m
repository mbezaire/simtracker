function [folder, varagout]=GetSimStorageFolder()
if nargout>1
    [folder, tmpout]=GetExecutableFolder();
    varagout{1}=tmpout;
else
    folder=GetExecutableFolder();
end



% apparently matlab compiled gui doesnt have write permissions to the directory in which it was installed