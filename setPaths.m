function setPaths(handles,varargin)
global sl mypath nagreminder cygpath

% check/generate home directory
homepath=getenv('HOME');
if isempty(homepath)
    if ispc
        homepath=[handles.general.cygpath sl 'home' sl getenv('username')];
    else
        [ss,rr]=system('echo $HOME');
        if ss==0 && ~isempty(strtrim(rr))
            homepath=strtrim(rr);
        end
    end
end
if isempty(homepath)
    if ismac
        usr=strtrim(getenv('username'));
        if isempty(usr)
            [~,rr]=system('whoami');
            usr=strtrim(rr);
        end
        homepath=['/Users/' usr];
    else
        homepath=['/home/' getenv('username')];
    end
end
setenv('HOME',strtrim(homepath))

if ~isempty(varargin) && strcmp(varargin{1},'reset')
    % delete the two files so as to regenerate them and everything.
    system([cygpath 'rm ' mypath sl 'data' sl 'runme.sh'])
    system([cygpath 'rm ' homepath sl '.bashrc_nrnst'])
end

% First, check for runme.sh and .bashrc_nrnst. Do not edit them if they
% exist
% 
% if they donot exist, we will run some test to figure out what to put in them
what2put=GetVarVals(handles,1);
%     and then we will draft them and have user review them
if exist([mypath sl 'data' sl 'runme.sh'],'file')==0
    fid=fopen([mypath sl 'data' sl 'runme.sh'],'w');
    %     runme.sh should contain things to be set each time NEURON is run (everything not concatenated?)

    what2putstr='';
    for r=1:length(what2put)
        if what2put(r).alwayset==1 || handles.general.setenv==1
            what2putstr = [what2putstr '\nexport ' what2put(r).name '=' strrep(what2put(r).value,'\','\\')];
        end
    end
    
    if ispc
        part2 = ['rm *.c\nrm *.o\nrm *.dll\n' what2putstr '\nmknrndll'];
    else % isunix, ismac
        part2 = [what2putstr '\nnrnivmodl\n'];
    end
    fprintf(fid,part2);
    fclose(fid);
end

what2put=GetVarVals(handles,2);
if exist([homepath sl '.bashrc_nrnst'],'file')==0
%     .bashrc_nrnst should be run when SimTracker is first started (or it is changed)
    fid=fopen([homepath sl '.bashrc_nrnst'],'w');

    what2putstr='';
    for r=1:length(what2put)
        if what2put(r).alwayset==1 || handles.general.setenv==1
            what2putstr = [what2putstr '\nexport ' what2put(r).name '=' strrep(what2put(r).value,'\','/')];
        end
    end
    fprintf(fid,what2putstr);
    fclose(fid);
end

% now have the user review them IF the lastcheck.dat file is missing or its
% date is earlier than either of their last revisions...
checkme=1;
if exist([mypath sl 'data' sl 'lastcheck.mat'],'file')
    load([mypath sl 'data' sl 'lastcheck.mat'],'mydate')
    mm=dir([mypath sl 'data' sl 'runme.sh']);
    mm2=dir([homepath sl '.bashrc_nrnst']);
    if mm.datenum<=mydate && mm2.datenum<=mydate
        checkme=0;
    end
end

if checkme && isunix && ~ismac
    DoTheCheck([mypath sl 'data' sl 'runme.sh'],[homepath sl '.bashrc_nrnst']);
    mydate=now;
    save([mypath sl 'data' sl 'lastcheck.mat'],'mydate','-v7.3')
end


% now we will open them and use them to set env within MATLAB
setPathsFromFile([mypath sl 'data'],'runme.sh')
setPathsFromFile(homepath,'.bashrc_nrnst')

% now we will ensure they get called at the appropriate times

% runme.sh -- added to compile cmd
if ispc
    handles.general.compilenrn = [cygpath 'sh ' deblank(mypath) sl 'data' sl 'runme.sh'];
else
    handles.general.compilenrn = ['sh ' deblank(mypath) sl 'data' sl 'runme.sh'];
end

% .bashrc_nt 
%  -- called from .bashrc if possible (ask people, don't edit
% unless box is checked) 
tmp=[];
if exist([getenv('HOME')  sl '.bashrc'],'file')
    [~,rr]=system(['cat ' getenv('HOME')  sl '.bashrc']);
    tmp=strfind(rr,'.bashrc_nrnst');
end
if handles.general.setenv==1 && isempty(tmp)
    % append it to the bashrc file
    fid=fopen([getenv('HOME')  sl '.bashrc'],'a');
    fprintf(fid,'sh .bashrc_nrnst\n');
    fclose(fid);  
elseif isempty(tmp) && ((exist('nagreminder','var')==0 || isempty(nagreminder) || nagreminder==0)) && (isdeployed==0 || isunix==0)
    if ispc
        msgbox({['Call this file from your ' getenv('HOME')  sl '.bashrc file:'], [handles.general.cygpath sl 'home' sl getenv('username')  sl '.bashrc_nrnst']})
    else
        msgbox({['Call this file from your ' getenv('HOME')  sl '.bashrc file:'], [strtrim(getenv('HOME')) sl '.bashrc_nrnst']})
    end
    nagreminder=1;
end

%  -- and also called right now
if handles.general.setenv==1
    system([cygpath 'sh ' getenv('HOME') sl '.bashrc_nrnst']);
end

% save changes
if isfield(handles,'btn_generate')
    guidata(handles.btn_generate,handles)
elseif isfield(handles,'btn_browse')
    guidata(handles.btn_browse,handles)
end

function DoTheCheck(varargin)

for v=1:length(varargin)
    if ispc
        dos(['notepad ' varargin{v}])
    else
        system(['open ' varargin{v}])
    end
end

function setPathsFromFile(reposPath,FileName)
global sl 
%disp(['Read in ' FileName ' variables to MATLAB setenv cmds...'])
fid=fopen([reposPath sl FileName],'r');
tline = fgetl(fid);
while ischar(tline)
    %disp(['Read from file: ' tline])
    [name,value]=extractValues(tline);
    if ~isempty(name)
        setenv(name,strrep(value,'"',''));
    end
    tline = fgetl(fid);
end
fclose(fid);

function what2put=GetVarVals(handles,filetype)
global cygpath sl

what2put=[];
neuronhome = getNEURONhome(handles);
pythonpaths = getPYTHONhome(neuronhome);

% NEURONHOME
w=length(what2put)+1;
what2put(w).name = 'NEURONHOME';
what2put(w).value=['"' neuronhome '"'];
what2put(w).alwayset=1;

% N
w=length(what2put)+1;
what2put(w).name = 'N';
what2put(w).value=['"' neuronhome '"'];
what2put(w).alwayset=1;

if filetype==2
    pythonpaths = getPYTHONhome(neuronhome);
    
    for p=1:length(pythonpaths)
        w=length(what2put)+1;
        what2put(w).name = pythonpaths(p).name;
        what2put(w).value= pythonpaths(p).value;
        what2put(w).alwayset=0;
    end
    
    if ~isempty(handles.general.python) && isstruct(pythonpaths) && isfield(pythonpaths,'name')
        if isempty(strmatch('PYTHONPATH',{pythonpaths.name},'exact'))
            % PYTHONPATH
            w=length(what2put)+1;
            what2put(w).name = 'PYTHONPATH';
            what2put(w).value=[handles.general.python sl 'lib'];
            what2put(w).alwayset=0;
        end

        if isempty(strmatch('PYTHONHOME',{pythonpaths.name},'exact'))
            % PYTHONHOME
            w=length(what2put)+1;
            what2put(w).name = 'PYTHONHOME';
            what2put(w).value=handles.general.python;
            what2put(w).alwayset=0;
        end
    end

    if isstruct(pythonpaths) && isfield(pythonpaths,'name') && isempty(strmatch('LD_LIBRARY_PATH',{pythonpaths.name},'exact'))
        % LD_LIBRARY_PATH
        w=length(what2put)+1;
        what2put(w).name = 'LD_LIBRARY_PATH';
        what2put(w).value='$LD_LIBRARY_PATH';
        what2put(w).alwayset=1;
    end
    
    % PATH
    w=length(what2put)+1;
    what2put(w).name = 'PATH';
    if ispc
        what2put(w).value= ['"' cygpath(1:end-1) ';' neuronhome ';$PATH"'];
    elseif ismac
        what2put(w).value= [handles.general.python ':/usr/local/bin:' neuronhome ':$PATH'];
    else
        what2put(w).value= [neuronhome ':$PATH'];
    end
    what2put(w).alwayset=1;
end

function pythonpaths = getPYTHONhome(neuronhome)
global cygpath sl

pythonpaths=[];

tmphome=getenv('PYTHONHOME');
setenv('PYTHONHOME','');
[~,rr]=system([cygpath 'sh ' neuronhome sl 'bin' sl 'nrnpyenv.sh']);
setenv('PYTHONHOME',tmphome);

tlines=regexp(rr,'\n','split');
for t=1:length(tlines)
    [name,value]=extractValues(tlines{t});
    if ~isempty(name)
        p=length(pythonpaths)+1;
        pythonpaths(p).name = name;
        pythonpaths(p).value = value;
    end
end

function neuronhome = getNEURONhome(handles)
global cygpath realpath sl rr

if isempty(handles.general.neuron) && exist([realpath sl 'defaults' sl 'simsettings.mat'],'file')
    load([realpath sl 'defaults' sl 'simsettings.mat']);
    if exist('neuronhome','var')
        return;
    end
end

tmppath='nrniv';
if isempty(rr)
    [~,rr]=system([cygpath 'whereis nrniv']);
    if isempty(rr) && ismac
        [~,rr]=system('find /Applications -name nrniv -print | head -n 2'); %[cygpath 'which nrniv']);
    end
end
allpaths=regexp(rr,'\s','split');
for a=length(allpaths):-1:1
    if isempty(allpaths{a})
        continue
    end
    if ispc && ~isempty(strfind(allpaths{a},'exe'))
        tmppath=allpaths{a};
        break;
    elseif isunix && strcmp(allpaths{a}(end-4:end),'nrniv')
        tmppath=allpaths{a};
        break;
    end
end
[~,tmp]=system([tmppath ' -c "print neuronhome()" -c "quit()"']);
wowee=strfind(tmp,'Additional mechanisms');
if ~isempty(wowee)
    tmp=tmp(1:wowee-1);
end
tmp2=regexp(tmp,'\n','split');
for t=length(tmp2):-1:1
    if ~isempty(tmp2{t})
        neuronhome=strtrim(tmp2{t});
        break;
    end
end
if isempty(neuronhome) || (exist(neuronhome,'dir')==0 && exist(cygwin(neuronhome),'dir')==0 && exist(decygwin(neuronhome),'dir')==0)
    w=strfind(handles.general.neuron,'bin');
    neuronhome=handles.general.neuron(1:w-2);
end

try
    save([realpath sl 'defaults' sl 'simsettings.mat'],'neuronhome','-append');
end


function [name,value]=extractValues(tline)
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
        name=val{1}{1};
        value=newtmp;
    else
        name='';
        value='';
    end
