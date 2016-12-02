function handleME(ME)
    if isdeployed
        docerr(ME)
    else
        for r=1:length(ME.stack)
            disp(ME.stack(r).file);disp(ME.stack(r).name);disp(num2str(ME.stack(r).line))
        end
        throw(ME)
    end