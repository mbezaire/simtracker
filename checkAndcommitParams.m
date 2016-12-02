function checkAndcommitParams(handles,path2params,varargin)
global sl

if ispc
    handles.dl=' & ';
else
    handles.dl=' ; ';
end

[~,rr]=system(['cd ' path2params handles.dl ' hg status -q']);
[~,rr2]=system(['cd ' path2params handles.dl ' hg log -r tip']);

if nargin>2 || (~isempty(findstr(['M setupfiles' sl 'parameters.mat'],strtrim(rr))) && isempty(strfind(rr2,'updated parameters in matlab file')))
    fid=fopen([path2params sl '.hg' sl 'hgrc'],'a');
    fprintf(fid,'\n\n[ui]\nuser = Your Name <your@email.com>\n');
    fclose(fid);
    [~,rr]=system(['cd ' path2params handles.dl ' hg commit -m "updated parameters in matlab file"']);
end