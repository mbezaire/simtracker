function parameters=switchSimRun(oldmodeldir,modeldir)
global mypath sl realpath cygpath

escchar='';
if ispc
    handles.dl='& ';
    escchar='\';
else
    handles.dl='; ';
end

if isdeployed==0
    % update the MATLAB class definition
    if ~isempty(oldmodeldir)
        if iscell(oldmodeldir)
            for r=1:length(oldmodeldir)
                if strmatch([oldmodeldir{r} sl 'setupfiles'],path)
                    rmpath([oldmodeldir{r} sl 'setupfiles'])
                end
                if strmatch([oldmodeldir{r} sl 'customout'],path)
                    rmpath([oldmodeldir{r} sl 'customout'])
                end
            end
        else
            if strmatch([oldmodeldir sl 'setupfiles'],path)
                rmpath([oldmodeldir sl 'setupfiles'])
            end
            if strmatch([oldmodeldir sl 'customout'],path)
                rmpath([oldmodeldir sl 'customout'])
            end
        end
    end
    evalin('base','clear SimRun')
    %evalin('caller','clear SimRun')

    if isempty(modeldir)
        % add this fcnality later to enable the view option for file>open
        % but then also need to start saving parameters with the archivearray
        % and simrun definition file with the zip results.
        % should do that anyway in prep for update and any other unknown
        % fcnality.
    %     if exist([oldmodeldir sl '..' 'backup' sl '\@SimRun'],'dir')==0
    %         mkdir([oldmodeldir sl '..' 'backup' sl '\@SimRun'])
    %     end
    %     addpath([oldmodeldir sl '..' 'backup' sl '\@SimRun'])
    %     system(['extract ' oldmodeldir sl '..' 'backup' sl mybackupname '.zip' sl 'SimRun.m ' oldmodeldir sl '..' 'backup' sl '\@SimRun' sl 'SimRun.m'])
    %     
    %     load([oldmodeldir sl '..' 'backup' sl mybackupname '.mat'],'parameters')

    else
        if ~strcmp(realpath,modeldir) && exist([realpath sl  escchar '@SimRun'],'dir')
            system([cygpath 'cp -r ' realpath sl  escchar '@SimRun ' mypath sl 'defaultSimRun.m'])
            if exist([realpath sl  'defSimRun'],'dir')==0
                system([cygpath 'mv ' realpath sl  escchar '@SimRun ' realpath sl  'defSimRun'])
            else
                system([cygpath 'rm -r ' realpath sl  escchar '@SimRun '])
            end 
        end
        addpath([modeldir sl 'setupfiles'])
        if exist([modeldir sl 'customout'],'dir')==0
            mkdir([modeldir sl 'customout']);
        end
        addpath([modeldir sl 'customout'])

        if exist([modeldir sl 'setupfiles' sl escchar '@SimRun' sl 'SimRun.m'],'file')==0
            if exist([modeldir sl 'setupfiles' sl escchar '@SimRun'],'dir')==0
                mkdir([modeldir sl 'setupfiles' sl escchar '@SimRun'])
            end           
            if exist([mypath sl 'defaultSimRun.m '],'file')
                system(['cp ' mypath sl 'defaultSimRun.m ' modeldir sl 'setupfiles' sl escchar '@SimRun' sl 'SimRun.m'])
            elseif exist([realpath sl  escchar '@SimRun' sl 'SimRun.m'],'file')
                system(['cp ' realpath sl  escchar  '@SimRun' sl 'SimRun.m ' modeldir sl 'setupfiles' sl escchar '@SimRun' sl 'SimRun.m'])
            elseif exist([realpath sl  escchar 'defSimRun' sl 'SimRun.m'],'file')
                system(['cp ' realpath sl  escchar  '@SimRun' sl 'SimRun.m ' modeldir sl 'setupfiles' sl escchar '@SimRun' sl 'SimRun.m'])
            end
        end

        % update the list of parameters
        load([realpath sl 'defaults' sl 'defaultparameters.mat'],'defixparams')

        if exist([modeldir sl 'setupfiles' sl 'parameters.mat'],'file')
            load([modeldir sl 'setupfiles' sl 'parameters.mat'],'chparams')
        else
            load([realpath sl 'defaults' sl 'defaultparameters.mat'],'defchparams')
            chparams=defchparams;
            save([modeldir sl 'setupfiles' sl 'parameters.mat'],'chparams','-v7.3')
            checkAndcommitParams(handles,modeldir)
        end
        parameters=[defixparams chparams];
    end
else
    load([realpath sl 'defaults' sl 'defaultparameters.mat'],'defixparams','defchparams')
    chparams=defchparams;
    save([modeldir sl 'setupfiles' sl 'parameters.mat'],'chparams','-v7.3')
    checkAndcommitParams(handles,modeldir)
    parameters=[defixparams chparams];
end