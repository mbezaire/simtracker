
% Returns the folder where the compiled executable actually resides.
function [executableFolder, varargout] = GetExecutableFolder() 
global sl alreadychosen logloc
    % see if a repos dir is already registered somewhere
    % if it is, use that.
    % if it is not, prompt the user to create one somewhere (and/or tell
    % SimTracker where it is)
    realpwd=pwd;

    if isdeployed && ismac
        NameOfDeployedApp = 'SimTracker'; % do not include the '.app' extension
        [~, result] = system(['top -n100 -l1 | grep ' NameOfDeployedApp ' | awk ''{print $1}''']);
        result=strtrim(result);
        [status, result] = system(['ps xuwww -p ' result ' | tail -n1 | awk ''{print $NF}''']);
        if status==0
            diridx=strfind(result,[NameOfDeployedApp '.app']);
            realpwd=result(1:diridx-2);
        else
            msgbox({'realpwd not set:',result})
        end
    elseif isdeployed && ispc
        % User is running an executable in standalone mode.
        [status, result] = system('set PATH');
        realpwd = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));
        if isempty(realpwd)
            realpwd = char(regexpi(result, 'Path=(.*?):', 'tokens', 'once'));
        end
    elseif isdeployed && isunix %check4mac
        [status, result] = system('echo $PATH');
        realpwd = char(regexpi(result, '(.*?):', 'tokens', 'once'));        
    end
    if isempty(realpwd)
        realpwd=prefdir(1);
    end

    simsettings=[];
    if exist([realpwd sl 'defaults' sl 'simsettings.mat'],'file')
        load([realpwd sl 'defaults' sl 'simsettings.mat']);
    end
    if isempty(simsettings) && exist([pwd sl 'simsettings.mat'],'file')
        load([pwd sl 'simsettings.mat']);
    end
    
    executableFolder=getenv('SIMSETTINGS');
    
    if ~isempty(executableFolder)
        if exist(executableFolder,'dir')==0
            mkdir(executableFolder)
        end
        alreadychosen=executableFolder;
        simsettings.dir=executableFolder;
         try
            save([realpwd sl 'defaults' sl 'simsettings.mat'],'simsettings','-v7.3')
        catch ME
            try
                save([pwd sl 'simsettings.mat'],'simsettings','-v7.3')
            end
            %handleME(ME)
        end
   elseif ~isempty(alreadychosen) || isequal(alreadychosen,0)
        executableFolder=alreadychosen;
    elseif ~isempty(simsettings)
        executableFolder=simsettings.dir;
        alreadychosen=executableFolder;
    else
        tmpdir=realpwd;
        if exist([realpwd sl 'data'],'dir')
            if exist([realpwd sl 'data' sl 'myrepos.mat'],'file')
                load([realpwd sl 'data' sl 'myrepos.mat']);
                slidx=strfind(myrepos(1).dir,sl);
                tmpdir=myrepos(1).dir(1:slidx(end)-1);
            end
        end
        executableFolder = uigetdir(tmpdir, 'Select or create a ''repos'' directory for use by SimTracker');
        alreadychosen=executableFolder;
        simsettings.dir=executableFolder;
        if exist([executableFolder sl 'data'],'dir')==0
            mkdir([executableFolder sl 'data'])
        end
        try
            if exist([realpwd sl 'data'],'dir')
                [SUCCESS,MESSAGE,MESSAGEID] = copyfile([realpwd sl 'data'],[executableFolder sl 'data'],'f');
            end
        catch ME
            handleME(ME)
        end
        try
            save([pwd sl 'simsettings.mat'],'simsettings','-v7.3')
            save([realpwd sl 'defaults' sl 'simsettings.mat'],'simsettings','-v7.3')
        catch ME
            %handleME(ME)
        end
    end
    if nargout>1
        varargout{1}=realpwd;
    end
    setenv('SIMSETTINGS',executableFolder);

% 	try
% 		if isdeployed 
% 			% User is running an executable in standalone mode. 
% 			[status, result] = system('set PATH');
% 			executableFolder = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));
%             if isempty(executableFolder)
%                 executableFolder = char(regexpi(result, 'Path=(.*?):', 'tokens', 'once'));
%             end
% % 			fprintf(1, '\nIn function GetExecutableFolder(), currentWorkingDirectory = %s\n', executableFolder);
% 		else
% 			% User is running an m-file from the MATLAB integrated development environment (regular MATLAB).
% 			executableFolder = pwd; 
% 		end 
% 	catch ME
% 		errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
% 			ME.stack(1).name, ME.stack(1).line, ME.message);
% 		uiwait(warndlg(errorMessage));
% 	end
	return;