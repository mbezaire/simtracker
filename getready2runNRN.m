function handles=getready2runNRN(handles)
global mypath sl nagreminder

setPaths(handles)
if isfield(handles,'btn_generate')
    handles=guidata(handles.btn_generate);
elseif isfield(handles,'btn_browse')
    guidata(handles.btn_browse,handles)
end
return;

if ispc
    handles.dl = ' & '; % System command delimiter for this computer (; for linux, & for pc)
    if isempty(strfind(mypath,'\'))
        mysl='/';
    else
        mysl='\';
    end
    % for PCs, to compile NEURON mod files, must set an environmental
    % variable $N first (to NEURON path)
    handles.compilenrn = [handles.general.cygpath sl 'bin' sl 'sh ' deblank(mypath) mysl 'data' mysl 'runme.sh'];
    w=strfind(handles.general.neuron,'bin');
    if exist([mypath sl 'data' sl 'runme.sh'],'file')==0
        if isfield(handles.general,'setenv') && handles.general.setenv==1
            part2 = ['rm *.c\nrm *.o\nrm *.dll\nexport PYTHONHOME=' cygwin(handles.general.python) '\nexport PYTHONPATH=' cygwin(handles.general.python) '/lib\nexport N=' cygwin(handles.general.neuron(1:w-2)) '\nexport NEURONHOME=' cygwin(handles.general.neuron(1:w-2)) '\nexport PATH="' cygwin(handles.general.neuron(1:w+2)) ':$PATH"\nmknrndll'];
        else
            part2 = ['rm *.c\nrm *.o\nrm *.dll\nmknrndll'];
        end
        fid=fopen([mypath sl 'data' sl 'runme.sh'],'w');
        fprintf(fid,part2);
        fclose(fid);
    else
        if isfield(handles.general,'setenv') && handles.general.setenv==1
            disp('Read in runme.sh variables to MATLAB setenv cmds...')
            fid=fopen('C:/Users/kim/Documents/repos/data/runme.sh','r');
            tline = fgetl(fid);
            while ischar(tline)
                disp(['Read from file: ' tline])
                val=regexp(tline,'export[\s]+([a-zA-Z]+)=([^\n]+)','tokens');
                if ~isempty(val)
                    tmp=val{1}{2};
                    [~, um, one]=regexp(tmp,'\$([a-zA-Z]+)([\:\;]*)','match','split','tokens');
                    newtmp=um{1};
                    for o=1:length(one)
                        newtmp=[newtmp getenv(one{o}{1}) one{o}{2} um{o+1}];
                    end
                    [~, um, one]=regexp(newtmp,'\$([a-zA-Z]+)([\:\;]*)','match','split','tokens');
                    while ~isempty(one)
                        newtmp=um{1};
                        for o=1:length(one)
                            newtmp=[newtmp getenv(one{o}{1}) one{o}{2} um{o+1}];
                        end
                        [~, um, one]=regexp(newtmp,'\$([a-zA-Z]+)([\:\;]*)','match','split','tokens');
                    end
                    disp(['about to set ' val{1}{1} ' to ' newtmp])
                    setenv(val{1}{1},newtmp);
                end
                tline = fgetl(fid);
            end
            fclose(fid);
        end
    end
elseif isunix && ~ismac
    fid=fopen([mypath sl 'data' sl 'runme.sh'],'w');
    fprintf(fid,'\nnrnivmodl\n');
    fclose(fid);
    handles.compilenrn = ['sh ' deblank(mypath) mysl 'data' mysl 'runme.sh'];
elseif ismac
    handles.dl = ';';
    handles.compilenrn = 'nrnivmodl';
end

if isfield(handles.general,'setenv') && handles.general.setenv==1
    if isunix && ~ismac
        fid=fopen([mypath sl 'data' sl 'runme.sh'],'w');
        fprintf(fid,part2);
        fclose(fid);
        handles.compilenrn = ['sh ' deblank(mypath) mysl 'data' mysl 'runme.sh'];
    else
        if isempty(getenv('HOME')) && ispc
            setenv('HOME',[handles.general.cygpath sl 'home' sl getenv('username')])
        elseif isempty(getenv('HOME'))
            [ss,rr]=system('echo $HOME');
            if ss==0 && ~isempty(strtrim(rr))
                setenv('HOME',strtrim(rr))
            end
        end
        if isempty(getenv('HOME'))
            if ismac
                usr=strtrim(getenv('username'));
                if isempty(usr)
                    [~,rr]=system('whoami');
                    usr=strtrim(rr);
                end
                setenv('HOME',['/Users/' usr])
            else
                setenv('HOME',['/home/' getenv('username')])
            end
        end
        w=strfind(handles.general.neuron,'bin');
        if exist([getenv('HOME')  sl '.bashrc'],'file')==0
            fid=fopen([getenv('HOME')  sl '.bashrc'],'a');
            fprintf(fid,'sh .bash_nrnst\n');
            fclose(fid);
        elseif ~exist([handles.general.cygpath sl 'home' sl getenv('username')  sl '.bash_nrnst'],'file') && (exist('nagreminder','var')==0 || isempty(nagreminder) || nagreminder==0)
            if ispc
                msgbox({'Review this file and either call it from your .bashrc file or incorporate contents as appropriate:', [handles.general.cygpath sl 'home' sl getenv('username')  sl '.bash_nrnst']})
            else
                msgbox({'Review this file and either call it from your .bashrc file or incorporate contents as appropriate:', [getenv('HOME') sl '.bash_nrnst']})
            end
            nagreminder=1;
        elseif exist('nagreminder','var')==0 || isempty(nagreminder) || nagreminder==0
            try
                [~,rr]=system(['cat ' getenv('HOME')  sl '.bashrc']);
                tmp=strfind(rr,'.bash_nrnst');
                if isempty(tmp)
                    msgbox({'Review this file and either call it from your .bashrc file or incorporate contents as appropriate:', [getenv('HOME') sl '.bash_nrnst']});
                    nagreminder=1;
                end
            end
        end
        
        if ispc
            fid=fopen([handles.general.cygpath sl 'home' sl getenv('username')  sl '.bash_nrnst'],'w');
            setenv('PATH',[handles.general.cygpath sl 'bin;' getenv('PATH')]);
            setenv('PYTHONHOME',cygwin(handles.general.python));
            setenv('PYTHONPATH',cygwin([handles.general.python sl 'lib']));
            setenv('N',cygwin(handles.general.neuron(1:w-2)));
            setenv('NEURONHOME',cygwin(handles.general.neuron(1:w-2)));
            
            fprintf(fid,'export PATH=%s:%s\n',strrep(cygwin([handles.general.cygpath sl 'bin']),' ','\ '),strrep(strrep(cygwin(getenv('PATH')),' ','\ '),';',':'));
            fprintf(fid,'export PYTHONPATH=%s\n',getenv('PYTHONPATH'));
            fprintf(fid,'export PYTHONHOME=%s\n',getenv('PYTHONHOME'));
            fprintf(fid,'export N=%s\n',getenv('N'));
            fprintf(fid,'export NEURONHOME=%s\n',getenv('NEURONHOME'));
        elseif ismac
            fid=fopen([getenv('HOME') sl '.bash_nrnst'],'w');
            w=strfind(handles.general.neuron,'bin');
            setenv('PYTHONPATH',[handles.general.python '/lib:' handles.general.neuron(1:w-2) sl 'lib' sl 'python']);
            setenv('PYTHONHOME',[handles.general.python '/']);
            setenv('PATH',[handles.general.python ':/usr/local/bin:' handles.general.neuron(1:w+2) ':' getenv('PATH')]);
            w=strfind(handles.general.neuron,'x86_64');
            setenv('N',[handles.general.neuron(1:w-2) sl 'share' sl 'nrn']);
            setenv('NEURONHOME',[handles.general.neuron(1:w-2) sl 'share' sl 'nrn']);
            
            fprintf(fid,'export PYTHONPATH=%s\n',getenv('PYTHONPATH'));
            fprintf(fid,'export PYTHONHOME=%s\n',getenv('PYTHONHOME'));
            fprintf(fid,'export N=%s\n',getenv('N'));
            fprintf(fid,'export NEURONHOME=%s\n',getenv('NEURONHOME'));
            fprintf(fid,'export PATH=%s\n',getenv('PATH'));
        else
            fid=fopen([getenv('HOME')  sl '.bash_nrnst'],'w');
            setenv('PYTHONHOME',handles.general.python);
            setenv('PYTHONPATH',[handles.general.python sl 'lib']);
            setenv('N',handles.general.neuron(1:w-2));
            setenv('NEURONHOME',handles.general.neuron(1:w-2));
            
            fprintf(fid,'export PYTHONPATH=%s\n',getenv('PYTHONPATH'));
            fprintf(fid,'export PYTHONHOME=%s\n',getenv('PYTHONHOME'));
            fprintf(fid,'export N=%s\n',getenv('N'));
            fprintf(fid,'export NEURONHOME=%s\n',getenv('NEURONHOME'));
        end
        fclose(fid);
    end
end
if ismac
    if isempty(getenv('PYTHONPATH'))
        setenv('PYTHONPATH',[handles.general.python '/lib'])
    end
    if isempty(getenv('PYTHONHOME'))
        setenv('PYTHONHOME',[handles.general.python])
    end
    if isempty(strfind('/usr/local/bin:',getenv('PATH')))
        setenv('PATH',['/usr/local/bin:' getenv('PATH')])
    end
end

if isfield(handles,'btn_generate')
    guidata(handles.btn_generate,handles)
elseif isfield(handles,'btn_browse')
    guidata(handles.btn_browse,handles)
end


%%%%%%%%%%%%%%%%%%%%
% system([handles.general.cygpath '\bin\sh nrnpyenv.sh'])
% # items in sys.path =  11
% # beginning with sys.prefix =  9
% # site-3 same as sys.prefix
% # in neither location  ['.', '/cygdrive/c/nrn/lib']
% # sys.prefix = /usr
% # site-3 = /usr
% export PYTHONHOME="/usr"
% export PYTHONPATH="/cygdrive/c/nrn/lib"
% export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"
% 
% ans =
% 
%      0
% 
% setenv('PYTHONHOME','C:\\cygwin64\\usr')
% setenv('PYTHONPATH','C:\\nrn\\lib')
% getenv('LD_LIBRARY_PATH')
% 
% ans =
% 
%      ''
% 
% 
% setenv('LD_LIBRARY_PATH','C:\\cygwin64\\usr\\lib')
% system([handles.general.cygpath '\bin\sh nrnpyenv.sh'])
% # PYTHONHOME exists. Do nothing