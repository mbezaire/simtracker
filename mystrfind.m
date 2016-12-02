function g=mystrfind(stringarray,mystr)
% This function returns the findstr data in a more useful way for me
g=[];
if iscell(stringarray)==1
    g = find(strcmp(stringarray,mystr)==1);
end

if isempty(g)
    m = strfind(stringarray,mystr);
    g=0;
    if iscell(m)
        for r=1:length(m)
            if ~isempty(m{r})
                g=r;
            end
        end
    else
        g=m;
    end
end
