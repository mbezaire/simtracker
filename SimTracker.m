function varargout = SimTracker(varargin)
% SIMTRACKER M-file for SimTracker.fig
%      SIMTRACKER, by itself, creates a new SIMTRACKER or raises the existing
%      singleton*.
%
%      H = SIMTRACKER returns the handle to a new SIMTRACKER or the handle to
%      the existing singleton*.
%
%      SIMTRACKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMTRACKER.M with the given input arguments.
%
%      SIMTRACKER('Property','Value',...) creates a new SIMTRACKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SimTracker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SimTracker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SimTracker

% Last Modified by GUIDE v2.5 23-May-2016 15:34:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SimTracker_OpeningFcn, ...
                   'gui_OutputFcn',  @SimTracker_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SimTracker is made visible.
function SimTracker_OpeningFcn(hObject, eventdata, handles, varargin)
global cygpath cygpathcd realpath mypath logloc sl donotsave javaaddpathstaticflag

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SimTracker (see VARARGIN)

cygpathcd='';

donotsave=0;
try
    if isdeployed
        set(handles.txt_deployed,'String','Compiled')
        set(handles.menuitem_jobscripts,'Enable','Off')
    end
        
    % figure format settings
    handles.formatP.textwidth=15;
    handles.formatP.plottextwidth=.1;
    handles.formatP.marg=.03/2;
    handles.formatP.st=2;
    handles.formatP.left = .065;
    handles.formatP.bottom=.065;
    handles.formatP.hmar=-.03;
    handles.formatP.colorvec={'m','k','b','r','g','y','c'};
    handles.formatP.sizevec={5,5,5,5,5,5,5,5,5,5,5,5,5};
    handles.formatP.figs=[];
    
    if ispc
        handles.curses.sl='\';
        sl='\';
    else
        handles.curses.sl='/';
        sl='/';
    end
    
%%%%
[mypath, realpath]=GetSimStorageFolder();%GetExecutableFolder();
if iscell(realpath)
    realpath=realpath{1};
end

if exist([realpath sl 'defaults' sl 'defaultparameters.mat'],'file')==0
    if exist('defaultparameters.mat','file')
        load('defaultparameters.mat')
        save([realpath sl 'defaults' sl 'defaultparameters.mat'],'defchparams','defixparams','-v7.3');
    elseif exist([realpath sl 'defaults' sl 'defaultparameters.mat'],'file')
        load([realpath sl 'defaults' sl 'defaultparameters.mat'])
        save([realpath sl 'defaults' sl 'defaultparameters.mat'],'defchparams','defixparams','-v7.3');
    end
end
if exist([realpath sl 'defaults' sl 'defaultputs.mat'],'file')==0
    if exist('defaultputs.mat','file')
        load('defaultputs.mat')
        save([realpath sl 'defaults' sl 'defaultputs.mat'],'defaultputs','-v7.3');
    elseif exist([realpath sl 'defaults' sl 'defaultputs.mat'],'file')
        load([realpath sl 'defaults' sl 'defaultputs.mat'])
        save([realpath sl 'defaults' sl 'defaultputs.mat'],'defaultputs','-v7.3');
    end
end

if ispc || ismac
    javaaddpathstaticflag=1;
else
    javaaddpathstaticflag=0;
end

if exist([mypath sl 'ganymed-ssh2-build250' sl 'ganymed-ssh2-build250.jar'],'file') && javaaddpathstaticflag
    javaaddpathstatic([mypath sl 'ganymed-ssh2-build250' sl 'ganymed-ssh2-build250.jar']);
end
% 
% addpath('.\ganymed-ssh2-build250\')
% addpath('.\ganymed-ssh2-build250\src\')
% addpath('.\ganymed-ssh2-build250\src\ch\')
% addpath('.\ganymed-ssh2-build250\src\ch\ethz\')
% addpath('.\ganymed-ssh2-build250\src\ch\ethz\ssh2\')
%%%%
    if exist([mypath sl 'data' sl 'MyOrganizer.mat'],'file')
        try
            load([mypath sl 'data' sl 'MyOrganizer.mat'],'myoutputs')
            id=strmatch('Fast Fourier Transform (FFT)',{myoutputs.output},'exact');
            if ~isempty(id)
                myoutputs(id).output='Spectral Analysis';
                myoutputs(id).function='plot_spectral(handles)';
                myoutputs(id).description='Spectral analysis of SDF, spike times, LFP, or MP by average, type, or heatmap, using Pwelch, periodogram, or FFT';
                myoutputs(id).tooltip=sprintf('analysis method: pwelch|gram|fft\nproperty to analyze: sdf|spikes|lfp|mp\norganization: type|all|{gid}|{type} ex: 3920 for {gid} or sca for {type}\noutput: 2d|heatmap|table\nnormalization desired: norm');
                save([mypath sl 'data' sl 'MyOrganizer.mat'],'myoutputs','-append')
            end
        end
    end
    if exist('myversion.mat','file')
        load myversion.mat myversion % Do not change the values in myversion; they are used by Marianne for troubleshooting
        handles.myversion=myversion;
    else
        handles.myversion = 'unknown';
    end
    %if ismac
        logloc=[mypath sl];
    %else
    %    logloc='';
    %end
        
    if isdeployed
        try
            wflag='w';
            if exist([logloc 'SimTrackerOutput.log'],'file')
                wflag='a';
            end
           fid = fopen([logloc 'SimTrackerOutput.log'],wflag);
            fprintf(fid,'The repos (data storage) directory for SimTracker is:\n%s\n\nAnd the SimTracker directory is located in:\n%s\n\n',mypath, realpath);
            fclose(fid);
        catch ME
            handleME(ME)
        end
    else
        disp('The repos (data storage) directory for SimTracker is:')
        disp(mypath)
        disp('And the SimTracker application is located in:')
        disp(realpath)
    end
    
    if exist([mypath sl 'data'],'dir')==0
        mkdir([mypath sl 'data'])
    end

    if ispc % Set the slash type for paths
        sl='\';
        handles.dl='& ';
    else
        sl='/';
        handles.dl='; ';
    end
    
    handles.output = hObject; % Choose default command line output for SimTracker
    handles.curses=[];handles.curses.ind=[]; % handles.curses.ind holds the index into RunArray of the currently selected run in the table tbl_runs

    if ispc && isempty(strfind(getenv('Path'),'cygwin')) % On PCs, Cygwin is needed for its Linux commands
        msgbox('Note that Cygwin or similar must be installed and added to your system Path')
    end

    % Add the subfolders associated with SimTracker to the MATLAB searchable path
    if isdeployed==0 % For deployed applications, these folders are added to the build
        if exist([mypath sl 'customout'],'dir')==0
            mkdir([mypath sl 'customout']);
        end
        addpath([mypath sl 'customout']) %#ok<MCAP>
        addpath([mypath sl 'data']) %#ok<MCAP>

        addpath([realpath sl 'outputtypes']) %#ok<MCAP>
        addpath([realpath sl 'tools']) %#ok<MCAP>
        addpath([realpath sl 'settings']) %#ok<MCAP>
        addpath([realpath sl 'jobscripts']) %#ok<MCAP>
        addpath([realpath sl 'ssh2_v2_m1_r4']) %#ok<MCAP>
        addpath([realpath sl '..']) %#ok<MCAP>
    end
    
    % Load the .mat file containing all the settings for SimTracker
    datastructs={'myoutputs','savedfigs','machines','general','myerrors','groups'};
    if exist([mypath sl 'data' sl 'MyOrganizer.mat'],'file')==2
        load([mypath sl 'data' sl 'MyOrganizer.mat']);
        % Load all the settings structures into the handles structure for easy access
        for r=1:length(datastructs)
            if exist(datastructs{r},'var')==1
                handles.(datastructs{r})=eval(datastructs{r}); % myoutputs previously loaded from MyOrganizer.mat
            else
                handles.(datastructs{r})=[];
            end
            eval(['clear ' datastructs{r}])
        end
        handles.savedfigs = [];
    end
    if isfield(handles,'general')==0 || isempty(handles.general)
        handles.general.clean = '-C';
        handles.general.savefigs= 1;
        handles.general.showfigs= 1;
        handles.general.res= 300;
        handles.general.crop= 50;
        handles.general.outputclick= 1;
        if ispc
            handles.general.explorer= 'cygstart';
            handles.general.picviewer= 'cygstart';
            handles.general.pdfviewer= 'cygstart';
            handles.general.textviewer= 'cygstart';
        elseif ismac
            handles.general.explorer= 'open';
            handles.general.picviewer= 'open';
            handles.general.pdfviewer= 'open';
            handles.general.textviewer= 'open';
        else %if isunix 
            handles.general.explorer= 'nautilus';
            handles.general.picviewer= 'xdg-open';
            handles.general.pdfviewer= 'xdg-open';
            handles.general.textviewer= 'xdg-open';
        end
        handles.general.gsi.flag=0;
        handles.general.gsi.user='';
        handles.general.gsi.command='GLOBUS_LOCATION=$HOME/globus;MYPROXY_SERVER=myproxy.teragrid.org;MYPROXY_SERVER_PORT=7514;export GLOBUS_LOCATION MYPROXY_SERVER MYPROXY_SERVER_PORT;. $GLOBUS_LOCATION/etc/globus-user-env.sh;myproxy-logon -T -t 12 -l';
        handles.general.email= '';
        if ispc
            dd=dir('C:\*ygwin*');
            handles.general.cygpath= ['C:\' dd(1).name];
        else
            handles.general.cygpath='';
        end
        otherdiff=1;
        if ispc && otherdiff
            cygpath=[handles.general.cygpath sl 'bin' sl];
        else
            cygpath='';
        end
        if ismac
            [r, t]=system([cygpath 'which nrngui']);
        else
            [r, t]=system([cygpath 'which nrniv']);
        end
        if r==0
            handles.general.neuron= strtrim(deblank(t));
            if ispc
                handles.general.neuron=[strrep(strrep(handles.general.neuron,'/cygdrive/c','C:'),'/','\') ' -nopython'];
            end
        else
            handles.general.neuron='';
            if ismac
                [r, t]=system('find /Applications/N* -name nrngui');
                if isempty(t)
                    [r, t]=system('find /Applications/n* -name nrngui');
                end
            elseif ispc
                [r, t]=system('find /cygdrive/c/n* -name nrniv.exe');
            else
                [r, t]=system('find /nrn* -name nrniv');
                if isempty(t)
                    [r, t]=system('find / -name nrniv');
                end
            end
            handles.general.neuron='';
            if ~isempty(t)
                newt=regexp(t,'\n','split');
                for nt=1:length(newt)
                    if ~isempty(strfind(newt{nt},'bin'))
                        handles.general.neuron=newt{nt};
                    end
                end
            end
            if ispc
                handles.general.neuron=[handles.general.neuron ' -nopython'];
            end
        end
        if size(handles.general.neuron,1)>1, handles.general.neuron=strtrim(handles.general.neuron(end,:)); end
        if isfield(handles.general,'python')==0 || isempty(handles.general.python)
            if ismac && exist('/System/Library/Frameworks/Python.framework/Versions/Current','dir')
                handles.general.python='/System/Library/Frameworks/Python.framework/Versions/Current';
            else
                [ss,rr]=system('which python');
                if ss==0
                    w=strfind(rr,'/');
                    handles.general.python=[rr(1:w(end)-1)];% sl 'lib' sl 'python'];
                else
                    w=strfind(handles.general.neuron,'bin');
                    handles.general.python=[handles.general.neuron(1:w-2)];% sl 'lib' sl 'python'];
                end
            end
        end
        if size(handles.general.python,1)>1, handles.general.python=strtrim(handles.general.python(end,:)); end
        handles.general.roundcoresup= 1;
        handles.general.mpi= 0;
        handles.general.rpath= '';
        handles.general.timelimit= 1;
        handles.general.setenv=0;
        general=handles.general;
        save([mypath sl 'data' sl 'MyOrganizer.mat'],'general','-v7.3')
        h=generalset;
        uiwait(h);

        if exist([mypath sl 'data' sl 'MyOrganizer.mat'],'file')==2
            load([mypath sl 'data' sl 'MyOrganizer.mat'],'general');
            if exist('general','var')==1
                handles.general=general; % general previously loaded from MyOrganizer.mat
            else
                msgbox('Can''t find general settings');
            end
        else
            msgbox('Can''t find MyOrganizer file');
        end
    end
        
    if isfield(handles,'groups')==0 || isempty(handles.groups)
        handles.groups(1).name = 'theta';
        handles.groups(1).date = '08-Aug-2012 15:55:49';
        handles.groups(2).name = 'oscillation';
        handles.groups(2).date = '08-Jul-2013 17:17:14';
    end
        
    if isfield(handles,'myerrors')==0 || isempty(handles.myerrors)
        handles.myerrors(1).category=[];
        handles.myerrors(1).errorphrase=[];
        handles.myerrors(1).description=[];
    end
        
    if isfield(handles,'machines')==0 || isempty(handles.machines)
        handles.machines(1).Nickname=strtrim(getenv('computername'));
        handles.machines(1).Address=strtrim(getenv('computername'));
        handles.machines(1).Username=strtrim(getenv('username'));
        if isempty(handles.machines(1).Nickname)
            [~, mm]=system('hostname');
            handles.machines(1).Nickname=strtrim(mm);
            handles.machines(1).Address=strtrim(mm);
        end
        if isempty(handles.machines(1).Username)
            [~, mm]=system('whoami');
            handles.machines(1).Username=strtrim(mm);
        end
        handles.machines(1).Repos='';
        handles.machines(1).Allocation='';
        handles.machines(1).CoresPerNode=[];
        handles.machines(1).Queues=[];
        handles.machines(1).Script=[];
        handles.machines(1).LatestVersion=[];
        handles.machines(1).SubCmd=[];
        handles.machines(1).GSIOpt= [];
        handles.machines(1).gsi=[];
        handles.machines(1).Submitchkr='1';
        handles.machines(1).Conn='ssh2';
        handles.machines(1).TopCmd='nrniv';
        
        handles.machines(2).Nickname='NSG';
        handles.machines(2).Address='';
        handles.machines(2).Username='';
        handles.machines(2).Repos='';
        handles.machines(2).Allocation='';
        handles.machines(2).CoresPerNode=32;
        handles.machines(2).Queues=[];
        handles.machines(2).Script=[];
        handles.machines(2).LatestVersion=[];
        handles.machines(2).SubCmd=[];
        handles.machines(2).GSIOpt= [];
        handles.machines(2).gsi=[];
        handles.machines(2).Submitchkr='1';
        handles.machines(2).Conn='ssh2';
        handles.machines(2).TopCmd='nrniv';
    end

     if isfield(handles,'myoutputs')==0 || isempty(handles.myoutputs)
       if exist([realpath sl 'defaults' sl 'defaultputs.mat'],'file')
            load([realpath sl 'defaults' sl 'defaultputs.mat'],'defaultputs');
            handles.myoutputs = defaultputs;
            if isfield(handles.myoutputs(1),'tooltip')==0
                for mm=1:length(handles.myoutputs)
                    handles.myoutputs(mm).tooltip='';
                end
            end 
        elseif exist(['defaultputs.mat'],'file')
            load(['defaultputs.mat'],'defaultputs');
            handles.myoutputs = defaultputs;
            if isfield(handles.myoutputs(1),'tooltip')==0
                for mm=1:length(handles.myoutputs)
                    handles.myoutputs(mm).tooltip='';
                end
            end 
        else
            handles.myoutputs(1).output='Spike Raster';
            handles.myoutputs(1).description='Which cells spiked and when';
            handles.myoutputs(1).function='h=plot_raster(handles)';
            handles.myoutputs(1).needs.eval='~isempty(RunArray(ind).ExecutedBy)';
            handles.myoutputs(1).tooltip='';
        end
        
        handles.savedfigs = [];
     end
        
    for r=1:length(datastructs)
        eval([datastructs{r} '=handles.(''' datastructs{r} ''');']); % myoutputs previously loaded from MyOrganizer.mat
    end
    save([mypath sl 'data' sl 'MyOrganizer.mat'],'-struct', 'handles', datastructs{:},'-v7.3');
    
    if exist('cygpath','var')==0 || isempty(cygpath)
        otherdiff=1;
        if ispc && otherdiff
            cygpath=[handles.general.cygpath sl 'bin' sl];
        else
            cygpath='';
        end
    end

    
    if isfield(handles.general,'clean')==0
        handles.general.clean='-C';
    end
    if isfield(handles.general,'setenv')==0
        handles.general.setenv=0;
    end
    if isfield(handles.general,'crop')==0
        handles.general.crop=50;
    end
    if isfield(handles.general,'mercurial')==0
        if ispc
           [~, r]=system([cygpath 'whereis hg']);
            turtle=strfind(r,'TortoiseHg');
            if isempty(turtle)
                handles.general.mercurial='';
            else
                mystarts=strfind(r,'/cygdrive');
                myends=strfind(r,'/hg');
                handles.general.mercurial=r(mystarts(find(mystarts<turtle,1,'last')):myends(find(myends>turtle,1,'first')));
                handles.general.mercurial=['"' strrep(strrep(handles.general.mercurial,'/cygdrive/c','C:'),'/','\') '"'];
            end
        else
            handles.general.mercurial='';
        end
    end
    if isfield(handles.general,'python')==0 || isempty(handles.general.python)
        if ismac && exist('/System/Library/Frameworks/Python.framework/Versions/Current','dir')
            handles.general.python='/System/Library/Frameworks/Python.framework/Versions/Current';
        else
            [ss,rr]=system('which python');
            if ss==0
                w=strfind(rr,'/');
                handles.general.python=[rr(1:w(end)-1)];% sl 'lib' sl 'python'];
            else
                w=strfind(handles.general.neuron,'bin');
                handles.general.python=[handles.general.neuron(1:w-2)];% sl 'lib' sl 'python'];
            end
        end
    end
    general = handles.general; %#ok<NASGU>
    save([mypath sl 'data' sl 'MyOrganizer.mat'],'general','-append');  

    if ~isfield(handles.machines,'Submitchkr')
        for r=1:length(handles.machines)
            switch handles.machines(r).Nickname
                case 'stampede'
                    handles.machines(r).Submitchkr = '~isempty(strfind(string{end},''Submitted batch job''))';
                case 'trestles'
                    handles.machines(r).Submitchkr = '~isempty(strfind(string{end},''.sdsc.edu''))';
                case 'hpc'
                    handles.machines(r).Submitchkr = '~isempty(strfind(string,''has been submitted''))';
                otherwise
                    handles.machines(r).Submitchkr = '1';
            end
        end
        machines = handles.machines; %#ok<NASGU>
        save([mypath sl 'data' sl 'MyOrganizer.mat'],'machines','-append');    
    end
    if ~isfield(handles.machines,'Allocation')
        for r=1:length(handles.machines)
            handles.machines(r).Allocation='';
        end
        machines = handles.machines; %#ok<NASGU>
        save([mypath sl 'data' sl 'MyOrganizer.mat'],'machines','-append');    
    end
    
    if ~isfield(handles.machines,'Conn')
        for r=1:length(handles.machines)
            switch handles.machines(r).Nickname
                case 'stampede'
                    handles.machines(r).Conn = 'ssh2';
                case 'trestles'
                    handles.machines(r).Conn = 'ssh2';
                case 'hpc'
                    handles.machines(r).Conn = 'ssh';
                otherwise
                    handles.machines(r).Conn = 'ssh2';
            end
        end
        machines = handles.machines; %#ok<NASGU>
        save([mypath sl 'data' sl 'MyOrganizer.mat'],'machines','-append');    
    end
    
    
    [~, myname]=system([cygpath 'hostname']); % Get the name of this machine
    myname=deblank(myname); % Remove the extra spaces
    fl=0; % Add the machine to the machines list if it isn't already there
    if isempty(handles.machines)
        handles.machines(1).Nickname = myname;
        fl=1;
    elseif sum(strcmp({handles.machines(:).Nickname},myname))==0 && sum(strcmp({handles.machines(:).Nickname},getenv('computername')))==0
        handles.machines(length(handles.machines)+1).Nickname = myname;
        fl=1;
    end
    if fl==1
        machines = handles.machines; %#ok<NASGU>
        save([mypath sl 'data' sl 'MyOrganizer.mat'],'machines','-append');    
        clear machines
    end
    
    handles=getready2runNRN(handles);
    
    if handles.general.gsi.flag==1 % Then run the GSI command to connect to XSEDE resources
        try
            [st,~]=system([handles.general.gsi.command ' ' handles.general.gsi.user]);
        catch %#ok<CTCH>
            msgbox({'Couldn''t start GSI. Turning it off', 'until the GSI command in general settings is corrected'})
            handles.general.gsi.flag=0;
        end
        if st~=0
            msgbox({'Couldn''t start GSI. Turning it off', 'until the GSI command in general settings is corrected'})
            handles.general.gsi.flag=0;
        end
    end

    % Update handles structure across all functions of the SimTracker
    guidata(hObject, handles);

    % Add context (right-click) menu to the list of runs
    myfunc=@context_copytable_Callback;
    myopenfunc=@context_open_Callback;
    mycopyfunc=@context_copyrun_Callback;
    mycontextmenuh=uicontextmenu('Tag','menu_copyh');
    uimenu(mycontextmenuh,'Label','Copy Table','Tag','context_copytableh','Callback',myfunc);
    uimenu(mycontextmenuh,'Label','Open Run Folder','Tag','context_copytableh1','Callback',myopenfunc);
    uimenu(mycontextmenuh,'Label','Copy Run Info','Tag','context_copytableh2','Callback',mycopyfunc);
    set(handles.tbl_runs,'UIContextMenu',mycontextmenuh);

    % Add context (right-click) menu to the list of outputs per run
    myopenfilefunc=@context_openfile_Callback;
    mycontextmenua=uicontextmenu('Tag','menu_copya');
    uimenu(mycontextmenua,'Label','Open File Location','Tag','context_copytablea1','Callback',myopenfunc);
    uimenu(mycontextmenua,'Label','Open File','Tag','context_copytablea2','Callback',myopenfilefunc);
    set(handles.tbl_savedfigs,'UIContextMenu',mycontextmenua);

    guidata(hObject, handles); % resave the handles


    % Update the uicontrols in the SimTracker to their initial state and populate the popupmenus
    if isempty(handles.myerrors)==0
        set(handles.txt_error,'String',{handles.myerrors(:).errorphrase},'Value',1)
    end
    if isempty(handles.groups)==0
        set(handles.list_groups,'String',{handles.groups(:).name})
    end

    set(handles.btn_saverun,'Visible','off') % don't show save run button

    setmachinemenu(handles,0) % update machine list, but not editable

    % Make sure repository can be loaded or add one if none yet

    if exist([mypath sl 'data' sl 'myrepos.mat'],'file')
        load([mypath sl 'data' sl 'myrepos.mat'], 'myrepos')
    end
    
    stoptry=0;
    while exist('myrepos','var')==0 || isempty(myrepos) && stoptry<3
        menuitem_new_Callback(handles.menuitem_new, [], handles,1)
        if exist([mypath sl 'data' sl 'myrepos.mat'], 'file')
            load([mypath sl 'data' sl 'myrepos.mat'], 'myrepos')
        end
        stoptry=stoptry+1;
    end
    
    if ~isfield(handles.general,'rpath')
        handles.general.rpath=''; % C:\R\R-3.0.1\bin\Rscript.exe
        guidata(hObject, handles); % resave the handles
    end

    set(handles.menuitem_custom,'Enable','Off')
    if isdeployed==0
        handles.custmenus=[];
        mm=dir([mypath sl 'customout' sl '*.m']);
        for m=1:length(mm)
            lblname=strrep(mm(m).name(1:end-2),'_',' ');
            eval(['handles.custmenus(end+1)=uimenu(handles.menuitem_custom,''Label'',''' lblname ''' ,''Callback'',{@' mm(m).name(1:end-2) ',handles});']);
            set(handles.menuitem_custom,'Enable','On')
        end
    end
    
    
        q=getcurrepos(handles); %#ok<NASGU>
        load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
        set(handles.txt_datalabel,'String',['Current Directory: ' myrepos(q).dir])
        pex=get(handles.txt_datalabel,'Extent');
        pos=get(handles.txt_datalabel,'Position');
        set(handles.txt_datalabel,'Position',[pos(1) pos(2) pex(3) pex(4)]);
        handles.parameters=switchSimRun('',myrepos(q).dir);
        guidata(hObject, handles); % resave the handles

        % Attempt to load saved runs into the SimTracker. If successful, refresh the view
        if loadRuns(handles,1) % This tries to load runs and returns 1 if successful
            x = mystrfind(get(handles.list_view,'String'),'All');
            set(handles.list_view,'Value',x)
            list_view_Callback(handles.list_view, [], handles)
        end
        
        if isdeployed==0
            mm=dir([myrepos(q).dir sl 'customout' sl '*.m']);
            for m=1:length(mm)
                lblname=strrep(mm(m).name(1:end-2),'_',' ');
                eval(['handles.custmenus(end+1)=uimenu(handles.menuitem_custom,''Label'',''' lblname ''' ,''Callback'',{@' mm(m).name(1:end-2) ',handles});']);
                set(handles.menuitem_custom,'Enable','On')
            end
        end
    
    guidata(hObject, handles);   
catch ME
    handleME(ME)
end


% --- Outputs from this function are returned to the command line.
function varargout = SimTracker_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;


function list_view_Callback(hObject, eventdata, handles) % --- Executes on selection change in list_view.
% This function refreshes the view of the runs in the table tbl_runs

try
    RefreshList(hObject, eventdata, handles)

catch ME
    handleME(ME)
end



% --- Executes during object creation, after setting all properties.
function list_view_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

% --------------------------------------------------------------------
function menuitem_new_Callback(hObject, eventdata, handles,varargin) 
% This function starts a new SimTracker repository in an already created folder

try
    if isempty(varargin)
        NewRepos(hObject, eventdata, handles) 
    else
        myans=questdlg('Your ''repos'' directory contains no repositories known to SimTracker. Would you like to download a sample model repository?','Download sample repository?','ringdemo','ca1','Don''t Download','ringdemo');
        NewRepos(hObject, eventdata, handles,myans) 
    end
catch ME
    handleME(ME)
end



% --------------------------------------------------------------------
function menuitem_export_Callback(hObject, eventdata, handles) 
% This function puts all the data currently selected in the table tbl_runs
% into a tab delimited file that can be opened by spreadsheet applications

global cygpath cygpathcd mypath RunArray sl

try
    % Find the RunArray indices for all selected runs
    tmpdata=get(handles.tbl_runs,'Data');
    handles.curses.indices = [];
    for r=1:size(handles.indices,1)
        myrow = handles.indices(r,1);
        RunName = tmpdata(myrow,1);
        handles.curses.indices(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1 );
    end
    
    % Decide where to store the exported files
    PathName = uigetdir(RunArray(end).ModelDirectory, 'Pick a Location to save the exported runs.');
    %[FileName,PathName] = uiputfile('*.txt','Export tab delimited file');

    if PathName==0
        return
    end
%     fid=fopen([PathName FileName],'w');
% 
%     headerstr='';
%     formatstr='';
%     cmdstr = '';
%     parameters=handles.parameters;%load([mypath sl 'data' sl 'parameters.mat'],'parameters')
% 
%     % Design the header of the file and the print command for printing data
%     for r=1:length(parameters)
%         headerstr=[headerstr  strrep(parameters(r).nickname,'%','%%') '\t' ]; %#ok<AGROW>
% 
%         formatstr=[formatstr parameters(r).format '\t']; %#ok<AGROW>
% 
%         cmdstr = [cmdstr 'RunArray(x).' parameters(r).name ', ']; %#ok<AGROW>
%     end
% 
%     headerstr=[headerstr(1:end-1) 'n'];
%     formatstr=[formatstr(1:end-1) 'n'];
%     cmdstr=cmdstr(1:end-2);
% 
%     % Print all data for each run using the print command
%     fprintf(fid,headerstr);
    for r=1:length(handles.curses.indices)
        x=handles.curses.indices(r); %#ok<NASGU>
%         evalstr=['fprintf(fid,''' formatstr ''', ' cmdstr ');'];
%         eval(evalstr);
        
        % export results (zip files)
        if ispc
            [bb, cc]=system(cygwin([' tar -zcvf ' PathName sl RunArray(handles.curses.indices(r)).RunName '.tgz -C ' RunArray(handles.curses.indices(r)).ModelDirectory sl 'results .' sl RunArray(handles.curses.indices(r)).RunName sl ' ']));
        else
            [bb, cc]=system(['cd ' RunArray(handles.curses.indices(r)).ModelDirectory handles.dl  ' tar -zcvf ' PathName sl  RunArray(handles.curses.indices(r)).RunName '.tgz results' sl RunArray(handles.curses.indices(r)).RunName]);
        end
        if bb~=0
            msgbox(cc)
            disp(cc)
        end
    end

%     fclose(fid);
catch ME
    handleME(ME)
end

% --------------------------------------------------------------------
function menuitem_import_Callback(hObject, eventdata, handles) 
% This function 

global cygpath cygpathcd mypath RunArray sl

try
    q=getcurrepos(handles); %#ok<NASGU>
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

    [FileName,PathName] = uigetfile({'*.gz;*.tgz;*.tar','Compressed Results Folder(s)';'*.zip','Zipped Results Folder(s)';'*.txt','Text file generated by SimTracker Export';'*.*','All file(s)'},'Select individual zipped files or choose a SimTracker-generated text file with the list of runs to import:','MultiSelect', 'on');
    if isnumeric(PathName) && PathName==0
        return
    end
    if iscell(FileName)==0 && strcmp(FileName(end-3:end),'txt')
        NewList=textread([PathName FileName],'%s%*[^\n]');    

        for r=2:length(NewList) % r=1 is the header, "run"
            if length(RunArray)>0 && ~isempty(strmatch(NewList{r},{RunArray.RunName},'exact'))
                myans=questdlg(['Run ' NewList{r} ' already exists in the SimTracker. Rename new run?'],'Duplicate Names','Rename','Skip','Rename');
                switch myans
                    case 'Rename'
                        if ispc
                            [bb, cc]=system(cygwin([' tar -xzf ' PathName  NewList{r} '.tgz -C ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']));
                        else
                            [bb, cc]=system([' tar -xzf ' PathName  NewList{r} '.tgz -C ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']);
                        end
                        NewList{r}=[NewList{r} '_RenamedImported'];
                    case 'Skip'
                        continue
                end
            else
                if ispc
                    [bb, cc]=system(cygwin([' tar -xzf ' PathName  NewList{r} '.tgz -C ' myrepos(q).dir sl 'results']));
                else
                    [bb, cc]=system([' tar -xzf ' PathName  NewList{r} '.tgz -C ' myrepos(q).dir sl 'results']);
                end
            end
            ind=length(RunArray)+1;
            RunArray(ind)=SimRun(NewList{r},myrepos(q).dir,'0');

            %LocalDirectory = RunArray(ind).ModelDirectory;

            if ~isempty(dir([myrepos(q).dir sl 'results' sl RunArray(ind).RunName sl 'spikeraster_*.dat']))
                ConcatSpikeRaster(handles,ind)
                SortSpikeRaster(handles,ind)
            end

            loadexecdata(RunArray(ind));
            %RunArray(ind).RemoteDirectory = RunArray(ind).ModelDirectory;
            %RunArray(ind).ModelDirectory = LocalDirectory;
            GetJobNumber(ind)
            if ~isempty(dir([myrepos(q).dir sl 'results' sl RunArray(ind).RunName sl 'subconns_*.dat']))
                ConcatSubconns(handles,ind)
            end
        end
    else
        NewList={};
        if iscell(FileName)==0
            FileName={FileName};
        end
%         if strcmp(FileName{1}(end-2:end),'txt')
%             NewList=textread([PathName FileName],'%s%*[^\n]');
%         end
        for r=1:length(FileName)
            gzflag=0;
            targzflag=0;
            filextl=4;
            switch FileName{r}(end-2:end)
                case 'zip'
                    zipflag=1;
%                 case 'txt'
%                     msgbox('Sorry, you can only select a single txt file for importing.')
%                     return
                case 'tgz'
                    zipflag=0;
                otherwise % treat like tgz
                    if strcmp(FileName{r}(end-6:end),'.tar.gz')
                        targzflag=1;
                        filextl=7;
                    elseif strcmp(FileName{r}(end-2:end),'.gz')
                        gzflag=1;
                        filextl=3;
                    end
                    zipflag=0;
            end
            NewList{r}=FileName{r}(1:end-filextl);
            if length(RunArray)>0 && ~isempty(strmatch(NewList{r},{RunArray.RunName},'exact'))
                myans=questdlg(['Run ' NewList{r} ' already exists in the SimTracker. Rename new run?'],'Duplicate Names','Rename','Skip','Rename');
                switch myans
                    case 'Rename'
                        if ispc
                            if zipflag
                                [bb, cc]=system(cygwin([' unzip ' PathName  NewList{r} '.zip -d ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']));
                            elseif targzflag
                                [bb, cc]=system(cygwin([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-5:end) ' -C ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']));
                            elseif gzflag
                                [bb, cc]=system(cygwin([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-1:end) ' -C ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']));
                            else
                                [bb, cc]=system(cygwin([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-2:end) ' -C ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']));
                            end
                        else
                            if zipflag
                                [bb, cc]=system([' unzip ' PathName  NewList{r} '.zip -d ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']);
                            elseif targzflag
                                [bb, cc]=system([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-5:end) ' -C ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']);
                            elseif gzflag
                                [bb, cc]=system([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-1:end) ' -C ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']);
                            else
                                [bb, cc]=system([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-2:end) ' -C ' PathName handles.dl ' mv ' PathName NewList{r} ' '  myrepos(q).dir sl 'results' sl NewList{r} '_RenamedImported']);
                            end
                        end
                        NewList{r}=[NewList{r} '_RenamedImported'];
                    case 'Skip'
                        continue
                end
            else
                if ispc
                    if zipflag
                        [bb, cc]=system(cygwin([' unzip ' PathName  NewList{r} '.zip -d ' myrepos(q).dir sl 'results']));
                    elseif targzflag
                        [bb, cc]=system(cygwin([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-5:end) ' -C ' myrepos(q).dir sl 'results']));
                    elseif gzflag
                        [bb, cc]=system(cygwin([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-1:end) ' -C ' myrepos(q).dir sl 'results']));
                   else
                        [bb, cc]=system(cygwin([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-2:end) ' -C ' myrepos(q).dir sl 'results']));
                    end
                else
                    if zipflag
                        [bb, cc]=system([' unzip ' PathName  NewList{r} '.zip -d ' myrepos(q).dir sl 'results']);
                    elseif targzflag
                        [bb, cc]=system([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-5:end) ' -C ' myrepos(q).dir sl 'results']);
                    elseif gzflag
                        [bb, cc]=system([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-1:end) ' -C ' myrepos(q).dir sl 'results']);
                    else
                        [bb, cc]=system([' tar -xzf ' PathName  NewList{r} '.' FileName{r}(end-2:end) ' -C ' myrepos(q).dir sl 'results']);
                    end
                end
            end
            ind=length(RunArray)+1;
            RunArray(ind)=SimRun(NewList{r},myrepos(q).dir,'0');

            %LocalDirectory = RunArray(ind).ModelDirectory;

            if ~isempty(dir([myrepos(q).dir sl 'results' sl RunArray(ind).RunName sl 'spikeraster_*.dat']))
                RunArray(ind).NumProcessors=length(dir([myrepos(q).dir sl 'results' sl RunArray(ind).RunName sl 'spikeraster_*.dat']));
                ConcatSpikeRaster(handles,ind)
                SortSpikeRaster(handles,ind)
            end

            loadexecdata(RunArray(ind));
            %RunArray(ind).RemoteDirectory = RunArray(ind).ModelDirectory;
            %RunArray(ind).ModelDirectory = LocalDirectory;
            GetJobNumber(ind)
            if ~isempty(dir([myrepos(q).dir sl 'results' sl RunArray(ind).RunName sl 'subconns_*.dat']))
                ConcatSubconns(handles,ind)
            end
        end
        NewList{length(NewList)+1}='header';
    end
    saveRuns(handles)
    set(handles.list_view,'Value',1)
    list_view_Callback(handles.list_view, [], handles);
    msgbox([num2str(length(NewList)-1) ' runs have been imported.'])
catch ME
    handleME(ME)
end


% --------------------------------------------------------------------
function menuitem_quit_Callback(hObject, eventdata, handles) %#ok<DEFNU>

figure1_CloseRequestFcn(handles.figure1, eventdata, handles)



% --------------------------------------------------------------------
function menuitem_parameterlist_Callback(hObject, eventdata, handles) %#ok<DEFNU>
global mypath sl
% This function allows you to edit the parameters used by the SimTracker
try
btn=questdlg('Before changing parameters, it is recommended that you backup your data','Backup Prompt','Backup','Don''t Backup','Backup');
if strcmp(btn,'Backup')==1
    menuitem_backup_Callback(handles.menuitem_backup, [], handles)
end

h=parameterset;
uiwait(h);
if isdeployed
    msgbox({'The parameters have been updated. If you clicked the Print button', ...
            'which updates the parameters file in your model repository,', ...
            'you must also commit the changes to a new version.'})
else
    msgbox({'The parameters have been updated. You must now quit SimTracker', ...
            ', enter ''clear all'' at the command line, and then restart SimTracker.', ...
            'If you clicked the Print button which updates the parameters file in', ...
            'your model repository, you must also commit the changes to a new version.'})
end
q=getcurrepos(handles); %#ok<NASGU>
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
handles.parameters=switchSimRun({myrepos.dir},myrepos(q).dir);
guidata(hObject, handles); % resave the handles
try
list_view_Callback(handles.list_view, [], handles);
CellSelected(hObject, [], handles)
catch
    disp('Unable to refresh view until SimTracker is closed, all variables cleared, and SimTracker restarted.')
end
catch ME
    handleME(ME)
end

% --------------------------------------------------------------------
function menuitem_general_Callback(hObject, eventdata, handles) %#ok<DEFNU>
global cygpath cygpathcd mypath sl
% This function allows you to edit general settings of the SimTracker
try

    
h=generalset;
uiwait(h);

if exist([mypath sl 'data' sl 'MyOrganizer.mat'],'file')==2
    load([mypath sl 'data' sl 'MyOrganizer.mat']);
else
    msgbox('Can''t find MyOrganizer file');
end

if exist('general','var')==1
    handles.general=general; % general previously loaded from MyOrganizer.mat
else
    msgbox('Can''t find general settings');
end

guidata(hObject, handles);

catch ME
    handleME(ME)
end

function menu_settings_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function menu_metadata_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

% --------------------------------------------------------------------
function menuitem_jobscripts_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
global cygpath cygpathcd mypath sl
% This function will open the jobscript m-files for editting
try

    
a = dir(['jobscripts' sl '*.m']);
for r=1:length(a)
    open(['jobscripts' sl a(r).name])
end
catch ME
    handleME(ME)
end

% --- Executes on button press in btn_generate.
function btn_generate_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function will generate the selected outputs for the selected run

global cygpath cygpathcd mypath RunArray savedfigs sl
%try
    
tmpdata=get(handles.tbl_runs,'Data');
usenameflag=0; %1;
for r=1:1 %size(handles.indices,1)
    myrow = handles.indices(r,1);
    RunName = tmpdata(myrow,1);
    allTypeind(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1);  % 1= 1st spike, 2= 2nd spike, 0= avg spike time, -1= 1st ISI

%     handles.curses=[];
%     handles.curses.ind = allTypeind(r);

%addformatP(handles,hObject);
%handles=guidata(hObject);
ind = handles.curses.ind;
    
if ~isempty(RunArray(handles.curses.ind).ExecutionDate)   
    if isfield(handles.curses,'spikerast')==0
        spikeraster(handles.btn_generate,guidata(handles.btn_generate))
        handles=guidata(handles.btn_generate);
    end
    if isfield(handles.curses,'cells')==0
        getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
        handles=guidata(handles.btn_generate);
    end
    if isfield(handles.curses,'numcons')==0
        numcons(handles.btn_generate,guidata(handles.btn_generate));
        handles=guidata(handles.btn_generate);
    end
    if isfield(handles.curses,'position')==0 && RunArray(handles.curses.ind).PrintCellPositions==1
        getpositions(handles.btn_generate,guidata(handles.btn_generate));
        handles=guidata(handles.btn_generate);
    end
    if isfield(handles.curses,'connections')==0 && RunArray(handles.curses.ind).PrintConnDetails==1 && RunArray(handles.curses.ind).NumConnections<1e7
        getdetailedconns(handles.btn_generate,guidata(handles.btn_generate),4,5);
        handles=guidata(handles.btn_generate);
    end
    if isfield(handles.curses,'lfp')==0 && exist([RunArray(handles.curses.ind).ModelDirectory sl 'results' sl RunArray(handles.curses.ind).RunName sl 'lfp.dat'],'file')
    %if isfield(handles.curses,'lfp')==0 && (RunArray(handles.curses.ind).ComputeLFP==1 || RunArray(handles.curses.ind).ComputeNpoleLFP==1 || RunArray(handles.curses.ind).ComputeDipoleLFP==1)
        getlfp(handles.btn_generate,guidata(handles.btn_generate));
        handles=guidata(handles.btn_generate);
    end
    if size(handles.curses.spikerast,2)<3
        handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
        guidata(handles.btn_generate, handles)
    end
    if isfield(handles.curses.cells(1),'mygids')==0
        NearElectrode(handles.btn_generate,handles)
        handles=guidata(handles.btn_generate);
    end
end




%sl = '/'; %handles.curses.sl;
savedfigs = handles.savedfigs;

if usenameflag==1
    figname = RunName;
else
    figname = get(handles.txt_figname,'String');
end
contents = cellstr(get(handles.list_format,'String'));
figformat = contents{get(handles.list_format,'Value')};
figdata = get(handles.tbl_outputtypes,'Data');

figpath='';

for rr=1:size(figdata,1) % for each possible output
    if figdata{rr,2}==1 % check if the checkbox is checked for that output, if so, produce that output
        figtype=figdata(rr,1);
        handles.optarg=figdata{rr,3}; % read in the optional argument
        guidata(hObject,handles);
        eval([handles.myoutputs(find(strcmp(figtype{1},{handles.myoutputs.output})==1,1)).function ';']); % this generates the output and returns a variable h, filled with the figure handle
        handles=guidata(hObject);
        if exist('h','var') && length(h)>1 %#ok<NODEF>  % Here, get the name of the figure or title of its plot
            for t=1:length(h(:))
                try
                    figtype{t}=get(get(get(h(t),'Children'),'Name'),'String');
                catch %#ok<CTCH>
                    try
                        figtype{t}=get(get(get(h(t),'Children'),'Title'),'String');
                    catch %#ok<CTCH>
                        figtype{t}=get(h(t),'Name');
                    end
                end
            end
        end
        % Determine the path where the figure will be saved, if it is to be saved
        if isempty(figpath)
            figpath=[RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl];
        else
            % figpath=sprintf([figpath sl], RunArray(ind).RunName);
        end
        if ispc
            figpath=strrep(figpath,'/','\');
        end
        % Show or save the figure in the desired format, as determined by
        % the general settings
        if strcmp(figformat,'fig')
            if handles.general.showfigs==1
                for t=1:length(h(:))
                    try
                        set(h(t),'Visible','on','Name',[RunArray(ind).RunName ' ' figtype{t}])
                    catch %#ok<CTCH>
                        set(h(t),'Visible','on','Name',[RunArray(ind).RunName ' ' figtype{t}{1}])
                    end
                end
            end
           if handles.general.savefigs==1
                for t=1:length(h(:))
                    if size(figtype{t},1)>1
                        mystr=figtype{t}(1);
                    elseif size(figtype,2)>1
                        mystr=figtype(t);
                    else
                        mystr=figtype;
                    end
                    % Remove undesirable characters from the figure file name
                    mystr{:}(strfind(mystr{:},' '))='_';
                    mystr{:}(strfind(mystr{:},','))='';
                    %mystr{:}(strfind(mystr{:},'.'))='';
                    mystr{:}(strfind(mystr{:},':'))='';
                    if iscell(figname)
                        fignametmp=figname{:};
                    else
                        fignametmp=figname;
                    end
                    saveas(h(t),[figpath fignametmp '_' mystr{:} '.' figformat]);
                    typestr=figtype{t};
                    if iscell(typestr)
                        typestr=typestr{1};
                    end
                    logsave(ind, figtype{t}, figformat, now, figpath, [fignametmp '_' typestr '.' figformat], RunArray(ind).RunName) % add a record of this figure to the log
                end
                if handles.general.showfigs==0
                    close(h)
                    system([cygpath handles.general.explorer ' ' figpath]);
                end
            end
        else
            try
                for t=1:length(h(:))
                    if size(figtype{t},1)>1
                        mystr=figtype{t}(1);
                    elseif size(figtype,2)>1
                        mystr=figtype(t);
                    else
                        mystr=figtype;
                    end
                    % Remove undesirable characters from the figure file name
                    mystr{:}(strfind(mystr{:},' '))='_';
                    mystr{:}(strfind(mystr{:},','))='';
                    %mystr{:}(strfind(mystr{:},'.'))='';
                    mystr{:}(strfind(mystr{:},':'))='';
                    set(h(t),'units','inches')
                    mypos = get(h(t),'Position');
                    if strcmp(figformat,'pdf')
                        set(h(t),'papersize',[11 8.5])
                        set(h(t),'paperposition',[0 0 11 8.5])
                    else
                        set(h(t),'papersize',mypos(3:4))
                        set(h(t),'paperposition',mypos)
                    end
                    %%print(h(t),['-d' figformat],['-r' num2str(handles.general.res)], [figpath strrep(strrep(strrep(RunArray(ind).RunComments(4:end),'%','percent'),' ','_'),'+','') '_' mystr{:}])
                    %print(h(t),['-d' figformat],['-r' num2str(handles.general.res)], [figpath figname{:} '_' mystr{:}])
                    print(h(t),['-d' figformat],'-r200', [figpath fignametmp '_' mystr{:}])
                    %%logsave(ind, mystr{:}, figformat, now, figpath, [strrep(strrep(strrep(RunArray(ind).RunComments(4:end),'%','percent'),' ','_'),'+','') '_' mystr{:}], RunArray(ind).RunName) % add a record of this figure to the log
                    logsave(ind, mystr{:}, figformat, now, figpath, [fignametmp '_' mystr{:}], RunArray(ind).RunName) % add a record of this figure to the log
                    close(h(t))
                    if strcmp(figformat,'jpeg')==1
                        myfigformat='jpg';
                    else
                        myfigformat=figformat;
                    end
                    if handles.general.showfigs==1
                        system([cygpath handles.general.picviewer ' ' figpath fignametmp '_' mystr{:} '.' myfigformat]);
                    end
                end
            catch ME
                msgbox('Ran into an error while saving and logging a figure')
                mydisp(ME,handles)
                docerr(ME)
            end

            system([cygpath handles.general.explorer ' ' figpath]);

        end
    end
end
handles.savedfigs = savedfigs;


save([mypath sl 'data' sl 'MyOrganizer.mat'],'savedfigs','-append');    
guidata(hObject,handles);
update_saved_figs(handles)
end
%catch ME
%    handleME(ME)
%end


function list_format_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>


function list_format_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_figname_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>



% --- Executes during object creation, after setting all properties.
function txt_figname_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes when selected cell(s) is changed in tbl_runs.
function tbl_runs_CellSelectionCallback(hObject, eventdata, handles)
% This function updates the handles structure with the currently selected
% run(s); the selected rows are available in the Indices field of eventdata

try
    CellSelected(hObject, eventdata, handles) 
    handles=guidata(hObject);
catch ME
    handleME(ME)
end


function result=loadRuns(handles,varargin)
% This function loads in the runs saved in the RunArray variable saved in
% the specified directory

global cygpath cygpathcd mypath RunArray sl

try
result=0;
    
q=getcurrepos(handles,1);

if isempty(q)
    if isempty(varargin)
        msgbox('Error: the current repository was not specified. Canceling operation now')
    end
    return
end

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

set(handles.txt_datalabel,'String',['Current Directory: ' myrepos(q).dir])
pex=get(handles.txt_datalabel,'Extent');
pos=get(handles.txt_datalabel,'Position');
set(handles.txt_datalabel,'Position',[pos(1) pos(2) pex(3) pex(4)]);

    if ~exist([myrepos(q).dir sl 'results' sl 'RunArrayData.mat'],'file')
        return
    end
    load([myrepos(q).dir sl 'results' sl 'RunArrayData.mat']);


if ~isa(RunArray,'SimRun')
    msgbox({'THE FILE WAS NOT LOADED PROPERLY', ' ',  '    RunArrayData.mat'})
else
    result=1;
end
catch ME
    handleME(ME)
end


function addRunsBatch(handles,localname,mymachs,fl)
% This function allows multiple runs to be uploaded at a time

global cygpath cygpathcd mypath RunArray sl pswd pswdmach

try

    
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=[myrepos(:).current]==1;
mymodpath=myrepos(q).dir;


mydir=dir([mymodpath sl 'results' ]);
idx=[mydir.isdir];
mydir=mydir(idx);


addidx=[];
modidxA=[];
if ~isempty(RunArray)
    for r=3:length(mydir)
        idx=searchRuns('RunName',mydir(r).name,0);
        try
        if isempty(idx) && fl.localunknownflag==1
            addidx(length(addidx)+1)=r;  %#ok<AGROW>
        elseif ~isempty(idx) && isempty(RunArray(idx).ExecutedBy) && fl.localknownflag==1
            modidxA(length(modidxA)+1)=idx;    %#ok<AGROW>
        end
        catch me
            msgbox(['May have duplicate run names! length idx=' num2str(idx) ' for RunName=' RunArray(idx(1)).RunName])
        end
    end
elseif fl.localunknownflag==1
    addidx=3:length(mydir);
end
mycounter=0;
mymodcounter=0;
for r=1:length(addidx)
    ind=length(RunArray)+1;
    %UID=getUID;
    RunArray(ind)=SimRun(mydir(addidx(r)).name,mymodpath,'0'); % unique id as third arg? system('cscript //NoLogo uuid.vbs') %http://superuser.com/questions/155740/how-can-i-generate-a-uuid-from-the-command-line-in-windows-xp
    ConcatSpikeRaster(handles,ind)
    SortSpikeRaster(handles,ind)
    loadexecdata(RunArray(ind));
        mycounter=mycounter+1;
end

for r=1:length(modidxA)
    ConcatSpikeRaster(handles,modidxA(r))
    SortSpikeRaster(handles,modidxA(r))
    loadexecdata(RunArray(modidxA(r)));
        mymodcounter=mymodcounter+1;
end


%%%%%%% done with local entry, so remove that from the mach list
removeme = find(strcmp(mymachs,localname)==1 || strcmp(mymachs,getenv('computername'))==1);
mymachs(removeme)=[];

if fl.remoteunknownflag==1
    for r=1:length(mymachs)
        tmp = cygwin(mymodpath);
        idx = strfind(tmp,'/');

        prog = tmp(idx(end)+1:end);
        addidx=[];
        m = find(strcmp(mymachs{r},{handles.machines(:).Nickname})==1);% if machine is not this one, then
        if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
            [one, getresults] = system([handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' "cd ' handles.machines(m).Repos prog '/results/'  '; dir"']); % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
            allresults = regexp(getresults,'\n','split');
            resstr='';
            for r=1:length(allresults)-2
                resstr=[resstr allresults{r} ' '];
            end
        elseif strcmp(handles.machines(m).Conn,'ssh2')
            if isempty(pswd) || strcmp(handles.machines(m).Nickname,pswdmach)==0
                pswd=inputdlg(['Password for ' handles.machines(m).Username '@' handles.machines(m).Address]);
                pswdmach=handles.machines(m).Nickname;
            end
            if isempty(pswd)
                return
            end
            getresults = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos prog '/results/'  '; dir']);
            for x=1:length(getresults)
                getresults{x} = [getresults{x} ' '];
            end
            resstr = [getresults{:} ' '];
        else
            [one, getresults] = system(['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' "cd ' handles.machines(m).Repos prog '/results/'  '; dir"']); % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
            allresults = regexp(getresults,'\n','split');
            resstr='';
            for r=1:length(allresults)-2
                resstr=[resstr allresults{r} ' '];
            end
        end
        
        allresults = regexp(resstr,'\s','split');
        allresults=unique(allresults);
        
        for g=1:length(allresults)
            if ~isempty(allresults{g}) && (isempty(RunArray) || length(RunArray)==0 || sum(strcmp(allresults{g},{RunArray(:).RunName}))==0)
                ind=length(RunArray)+1;
                addidx(length(addidx)+1)=ind;
                RunArray(ind)=SimRun(allresults{g},mymodpath,'0');
                RunArray(ind).Machine=handles.machines(m).Nickname;
            end
        end
        
        for g=1:length(addidx)
    grr=cygwin(RunArray(addidx(g)).ModelDirectory);
    idx = strfind(grr,'/');
    jobtype.program = grr(idx(end)+1:end);
    
            if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
                getresults = ['!' handles.machines(m).gsi 'scp ' upper(handles.machines(m).GSIOpt) ' -r ' handles.machines(m).Username '@' handles.machines(m).Address ':' handles.machines(m).Repos prog '/results/' RunArray(addidx(g)).RunName  ' ' RunArray(addidx(g)).ModelDirectory '/results/' RunArray(addidx(g)).RunName];
                eval(cygwin(getresults))

            elseif strcmp(handles.machines(m).Conn,'ssh2') % integrate this here
                if isempty(pswd) || strcmp(handles.machines(m).Nickname,pswdmach)==0
                    pswd=inputdlg(['Password for ' handles.machines(m).Username '@' handles.machines(m).Address]);
                    pswdmach=handles.machines(m).Nickname;
                end
                if isempty(pswd)
                    return
                end
                mkdir([RunArray(addidx(g)).ModelDirectory sl 'results' sl],RunArray(addidx(g)).RunName)
                %getlist = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos prog  '/results/' RunArray(addidx(g)).RunName '; ls']);
                %getresults = scp_simple_get(handles.machines(m).Address,handles.machines(m).Username,pswd{:},getlist, [RunArray(addidx(g)).ModelDirectory sl 'results' sl RunArray(addidx(g)).RunName],[handles.machines(m).Repos prog  '/results/' RunArray(addidx(g)).RunName]);

                saveglobals;
                getlist = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos prog  '; tar -zcvf results/' RunArray(addidx(g)).RunName '.tgz results/' RunArray(addidx(g)).RunName]);
                retrieveglobals;

                getresults = scp_simple_get(handles.machines(m).Address,handles.machines(m).Username,pswd{:},{[RunArray(addidx(g)).RunName '.tgz']}, [RunArray(addidx(g)).ModelDirectory],[handles.machines(m).Repos prog  '/results']);
                retrieveglobals;
                system([cygpathcd 'cd ' RunArray(addidx(g)).ModelDirectory ' ' handles.dl ' tar -zxvf ' RunArray(addidx(g)).RunName '.tgz']);
                system([cygpathcd 'cd ' RunArray(addidx(g)).ModelDirectory ' ' handles.dl ' rm ' RunArray(addidx(g)).RunName '.tgz']);
                getlist = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos prog  '/results/; rm ' RunArray(addidx(g)).RunName '.tgz ']);

            else
                % use scp to copy results from remote computer back to this one, to
                getresults = ['!scp  -r ' handles.machines(m).Username '@' handles.machines(m).Address ':' handles.machines(m).Repos prog '/results/' RunArray(addidx(g)).RunName  ' ' cygwin([RunArray(addidx(g)).ModelDirectory sl 'results' sl RunArray(addidx(g)).RunName])];
                eval(cygwin(getresults))

            end
            if exist([RunArray(addidx(g)).ModelDirectory sl 'results' sl RunArray(addidx(g)).RunName],'dir')==7 && ~isempty(dir([RunArray(addidx(g)).ModelDirectory sl 'results' sl RunArray(addidx(g)).RunName]))
                LocalDirectory = RunArray(addidx(g)).ModelDirectory;
                ConcatSpikeRaster(handles,addidx(g))
                SortSpikeRaster(handles,addidx(g))

                loadexecdata(RunArray(addidx(g)));
                RunArray(addidx(g)).RemoteDirectory = RunArray(addidx(g)).ModelDirectory;
                RunArray(addidx(g)).ModelDirectory = LocalDirectory;
                if strcmp(RunArray(ind).Machine,handles.machines(m).Nickname)~=1
                    msgbox(['changing machine from ' RunArray(ind).Machine ' to ' handles.machines(m).Nickname])
                end
                RunArray(ind).Machine=handles.machines(m).Nickname;
    
                GetJobNumber(addidx(g))
                ConcatSubconns(handles,addidx(g))
        
                mycounter=mycounter+1;
            end

        end
    end
end

if fl.remoteknownflag==1
    modidx=searchRuns('ExecutionDate','',0);

    for r=1:length(modidx)
        [~, myname]=system([cygpath 'hostname']);
        if  ~isempty(RunArray(modidx(r)).Machine) && ~strcmp(RunArray(modidx(r)).Machine, deblank(myname)) && ~strcmp(RunArray(modidx(r)).Machine, deblank(getenv('computername')))  && ~isempty(strmatch(RunArray(modidx(r)).Machine,mymachs,'exact'))  %~strcmp(RunArray(modidx(r)).Machine, deblank(myname)) && check_remote==1
            m = find(strcmp(RunArray(modidx(r)).Machine,{handles.machines(:).Nickname})==1);% if machine is not this one, then
    grr=cygwin(RunArray(modidx(r)).ModelDirectory);
    idx = strfind(grr,'/');
    prog = grr(idx(end)+1:end);
    
            if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
                getresults = ['!' handles.machines(m).gsi 'scp ' upper(handles.machines(m).GSIOpt) ' -r ' handles.machines(m).Username '@' handles.machines(m).Address ':' handles.machines(m).Repos prog '/results/' RunArray(modidx(r)).RunName  ' ' RunArray(modidx(r)).ModelDirectory '/results/' RunArray(modidx(r)).RunName];
                eval(cygwin(getresults))

            elseif strcmp(handles.machines(m).Conn,'ssh2')
                if isempty(pswd) || strcmp(handles.machines(m).Nickname,pswdmach)==0
                    pswd=inputdlg(['Password for ' handles.machines(m).Username '@' handles.machines(m).Address]);
                    pswdmach=handles.machines(m).Nickname;
                end
                if isempty(pswd)
                    return
                end
                saveglobals;
                getlist = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos prog  '/results/' RunArray(modidx(r)).RunName '; ls']);
                retrieveglobals;
                if isempty(strmatch('sumnumout.txt',getlist,'exact')) % make sure results folder exists with results
                    continue
                end

                saveglobals;
                getlist = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos prog  '; tar -zcvf results/' RunArray(modidx(r)).RunName '.tgz results/' RunArray(modidx(r)).RunName]);
                retrieveglobals;

                mkdir([RunArray(modidx(r)).ModelDirectory sl 'results' sl],RunArray(modidx(r)).RunName)
                getresults = scp_simple_get(handles.machines(m).Address,handles.machines(m).Username,pswd{:},{[RunArray(modidx(r)).RunName '.tgz']}, [RunArray(modidx(r)).ModelDirectory],[handles.machines(m).Repos prog  '/results']);
                retrieveglobals;
                system([cygpathcd 'cd ' RunArray(modidx(r)).ModelDirectory ' ' handles.dl ' tar -zxvf ' RunArray(modidx(r)).RunName '.tgz']);
                system([cygpathcd 'cd ' RunArray(modidx(r)).ModelDirectory ' ' handles.dl ' rm ' RunArray(modidx(r)).RunName '.tgz']);
                getlist = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos prog  '/results/; rm ' RunArray(modidx(r)).RunName '.tgz ']);
                retrieveglobals;
                
                
                
%                 try
%                 getresults = scp_simple_get(handles.machines(m).Address,handles.machines(m).Username,pswd{:},getlist, [RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName],[handles.machines(m).Repos prog  '/results/' RunArray(modidx(r)).RunName],1);
%                 catch me
%                     minchunk=100;
%                     finishedidx=0;
%                     tryidx=min(floor(length(getlist)/2),minchunk);
%                     while finishedidx<length(getlist)
%                         try
%                             getresults = scp_simple_get(handles.machines(m).Address,handles.machines(m).Username,pswd{:},getlist((finishedidx+1):tryidx), [RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName],[handles.machines(m).Repos prog  '/results/' RunArray(modidx(r)).RunName],1);
%                             disp(['Just did ' num2str(finishedidx) ':' num2str(tryidx) ' out of ' num2str(length(getlist))])
%                             finishedidx=tryidx;
%                             tryidx = min(max(minchunk,floor((length(getlist)-finishedidx)/2))+finishedidx,length(getlist));
%                         catch
%                             tryidx= floor((tryidx-finishedidx)/2) + finishedidx + 1;                            
%                         end
%                     end
%                 end
            else
                % use scp to copy results from remote computer back to this one, to
                getresults = ['!scp  -r ' handles.machines(m).Username '@' handles.machines(m).Address ':' handles.machines(m).Repos prog '/results/' RunArray(modidx(r)).RunName  ' ' cygwin([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName])];
                eval(cygwin(getresults))
            end
        end
        if exist([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName],'dir')==7 && ~isempty(dir([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName]))
            LocalDirectory = RunArray(modidx(r)).ModelDirectory;
            ConcatSpikeRaster(handles,modidx(r))
            SortSpikeRaster(handles,modidx(r))
            loadexecdata(RunArray(modidx(r)));
            RunArray(modidx(r)).RemoteDirectory = RunArray(modidx(r)).ModelDirectory;
            RunArray(modidx(r)).ModelDirectory = LocalDirectory;

            GetJobNumber(modidx(r))
            ConcatSubconns(handles,modidx(r))
            
            mymodcounter=mymodcounter+1;
        end
    end
end



msgbox({[num2str(mycounter) ' unknown runs have been added.'],[num2str(mymodcounter) ' known runs have been added.']});

x = mystrfind(get(handles.list_view,'String'),'Ran');
set(handles.list_view,'Value',x)
list_view_Callback(handles.list_view, [], handles)
catch ME
    handleME(ME)
end

function SortSpikeRaster(handles,ind)
global cygpath cygpathcd mypath RunArray sl

sortraster = [cygpath 'sort -k 1n,1 ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'spikeraster.dat > ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'sortedraster.dat ' handles.dl ' ' cygpath 'mv ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'sortedraster.dat ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'spikeraster.dat'];
[rrr,sss]=system(sortraster);

function GetJobNumber(ind)
global cygpath cygpathcd mypath RunArray sl

    d=dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl RunArray(ind).RunName '*.o']);
    if length(d)==1
        myruns=regexp(d.name,'\.','split');
        RunArray(ind).JobNumber=str2num(myruns{2});
    elseif length(d)>1
        msgbox('There are multiple job logfiles in the results folder.',RunArray(ind).RunName)
    end

function ConcatSubconns(handles,ind)
global cygpath cygpathcd mypath RunArray sl

    d=dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'subconns_*.dat']);
    if ~isempty(d)
        for g=0:RunArray(ind).NumProcessors-1
            system([cygpath 'cat ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'subconns_' num2str(g) '.dat >> ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'cell_syns.dat' handles.dl ...
                    cygpath 'rm ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'subconns_' num2str(g) '.dat']);
        end
    end
    d=dir([RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName sl 'suballconns_*.dat']);
    if ~isempty(d)
        for g=0:RunArray(ind).NumProcessors-1
            [rrr, sss]=system([cygpath 'cat ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'suballconns_' num2str(g) '.dat >> ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'connections.dat' handles.dl ...
                    cygpath 'rm ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'suballconns_' num2str(g) '.dat']);
            if rrr ~= 0
                disp(sss);
            end
        end
    end
    
function ConcatSpikeRaster(handles,ind)
global cygpath cygpathcd mypath RunArray sl
    pause(2);
    spikeraster_path=[RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'spikeraster_*.dat'];
    d=dir(spikeraster_path);
    if ~isempty(d) && length(d)== RunArray(ind).NumProcessors
        for g=0:RunArray(ind).NumProcessors-1
            [rrr, sss]=system([cygpath 'cat ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'spikeraster_' num2str(g) '.dat >> ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'spikeraster.dat' handles.dl ...
                    cygpath 'rm ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'spikeraster_' num2str(g) '.dat']);
                if rrr ~= 0
                    disp(sss);
                end
        end
    elseif RunArray(ind).CatFlag==0 && exist([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'spikeraster.dat'],'file')==0
        msgbox(['There should be ' num2str(RunArray(ind).NumProcessors) ' spikeraster files but there are actually ' num2str(length(d)) ' files. Attempting to proceed.'],RunArray(ind).RunName)
    end
    
function menu_runs_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>



function menuitem_batchupload_Callback(hObject, eventdata, handles) %#ok<DEFNU,*INUSL>
% This function calls the AddRunsBatch function, which allows multiple runs
% to be uploaded at once
global cygpath cygpathcd mypath sl
try

mymachs = inputdlg({'Look for known runs','Look for unknown runs',handles.machines.Nickname},'Put an equals sign in the fields of interest:');


macharray={};
for r=3:length(mymachs)
    if ~isempty(mymachs{r})
        macharray{length(macharray)+1}=handles.machines(r-2).Nickname;
    end
end

fl.localunknownflag=0;
fl.remoteunknownflag=0;
fl.localknownflag=0;
fl.remoteknownflag=0;

[~, myname]=system([cygpath 'hostname']);
myname=deblank(myname);

if ~isempty(mymachs{1})
    if sum(strcmp(myname,macharray))>0 || sum(strcmp(getenv('computername'),macharray))>0
        fl.localknownflag=1;
    end
    fl.remoteknownflag=1;
end
if ~isempty(mymachs{2})
    if sum(strcmp(myname,macharray))>0 || sum(strcmp(getenv('computername'),macharray))>0
        fl.localunknownflag=1;
    end
    fl.remoteunknownflag=1;
end

addRunsBatch(handles,myname,macharray,fl)
saveRuns(handles)
x = mystrfind(get(handles.list_view,'String'),'Ran');
set(handles.list_view,'Value',x)
list_view_Callback(handles.list_view, [], handles);

catch ME
    handleME(ME)
end


% --------------------------------------------------------------------
function menuitem_uploadrun_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function uploads selected single runs to the SimTracker

global cygpath cygpathcd mypath RunArray sl pswd pswdmach
try
tmpdata=get(handles.tbl_runs,'Data');
handles.curses.indices = [];
for r=1:size(handles.indices,1)
    myrow = handles.indices(r,1);
    RunName = tmpdata(myrow,1);
    handles.curses.indices(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1 ); % delete min for real data
end
modidx = handles.curses.indices;

[~, myname]=system([cygpath 'hostname']);
refreshlist=1;
uploadstr=[];
mysshstr='';
for r=1:length(modidx)
    m = find(strcmp(RunArray(modidx(r)).Machine,{handles.machines(:).Nickname})==1);
    if strcmp(RunArray(modidx(r)).Machine, deblank(myname)) || strcmp(RunArray(modidx(r)).Machine, deblank(getenv('computername'))) 
        ConcatSpikeRaster(handles,modidx(r))
        SortSpikeRaster(handles,modidx(r))
        loadexecdata(RunArray(modidx(r)));
    elseif strcmp(RunArray(modidx(r)).Machine, 'NSG')
        if exist([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName],'dir') && ~isempty(dir([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName sl]))
            if ~isempty(dir([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName sl '*.gz']))
                ExpandNSGResults(handles,modidx(r),'gz')
            elseif ~isempty(dir([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName sl 'Cipres_Data*.zip']))
                ExpandNSGResults(handles,modidx(r),'1zip')
                ExpandNSGResults(handles,modidx(r),'gz')
            elseif ~isempty(dir([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName sl '*.tar']))
                ExpandNSGResults(handles,modidx(r),'tar')
            elseif ~isempty(dir([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName sl '*.zip']))
                ExpandNSGResults(handles,modidx(r),'zip')
            end
            ConcatSpikeRaster(handles,modidx(r))
            SortSpikeRaster(handles,modidx(r))
            loadexecdata(RunArray(modidx(r)));
        else
            system([cygpath 'mkdir ' RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName]);
            system([cygpath handles.general.explorer ' ' RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName]);
            refreshlist=0;
            msgbox({'Either the zipped *.gz or *.zip file or the individual ','results files must be placed in the results folder'})
        end
    elseif ((isdeployed && strcmp(handles.machines(m).Address,'stampede.tacc.utexas.edu')) || strcmp(handles.machines(m).Conn,'script')) && (isempty(handles.machines(m).gsi) || handles.general.gsi.flag==0)
        if exist([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName],'dir') && ~isempty(dir([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName]))
            ConcatSpikeRaster(handles,modidx(r))
            SortSpikeRaster(handles,modidx(r))
            loadexecdata(RunArray(modidx(r)));
        else
            if strcmp(handles.machines(m).Conn,'script')
                msgbox({'Run this terminal script and then choose to upload the run again:',['cd ' cygwin(RunArray(modidx(r)).ModelDirectory)],['sh .' sl 'jobscripts' sl 'UploadInTerminal_' RunArray(modidx(r)).RunName '.sh']});
            else
                msgbox({'In compiled mode without GSI, SimTracker cannot access Stampede.','In your terminal, enter the following before trying this command again:',['cd ' RunArray(modidx(r)).ModelDirectory],['sh .' sl 'jobscripts' sl 'UploadInTerminal_' RunArray(modidx(r)).RunName '.sh']});
            end
            grr=cygwin(RunArray(modidx(r)).ModelDirectory);
            idx = strfind(grr,'/');
            prog = grr(idx(end)+1:end);

            mysshstr=[mysshstr ':' handles.machines(m).Repos sl prog sl 'results' sl RunArray(modidx(r)).RunName ' '];
            getresults = ['rsync -zrp  ' handles.machines(m).Username '@' handles.machines(m).Address mysshstr  ' ' cygwin([RunArray(modidx(r)).ModelDirectory sl 'results' sl]) ];
            %getresults = ['!scp -r ' handles.machines(m).Username '@' handles.machines(m).Address ':' handles.machines(m).Repos prog '/results/' RunArray(modidx(r)).RunName  ' ' RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName];
            fidivert=fopen([RunArray(modidx(r)).ModelDirectory sl 'jobscripts' sl 'UploadInTerminal_' RunArray(modidx(r)).RunName '.sh'],'w');
            fprintf(fidivert,'%s\n',cygwin(getresults));
            fclose(fidivert);
            refreshlist=0;
        end
    else
        uploadstr(length(uploadstr)+1)=modidx(r);
        
        m = find(strcmp(RunArray(modidx(r)).Machine,{handles.machines(:).Nickname})==1);
    grr=cygwin(RunArray(modidx(r)).ModelDirectory);
    idx = strfind(grr,'/');
    prog = grr(idx(end)+1:end);
    
        mysshstr=[mysshstr ':' handles.machines(m).Repos prog sl 'results' sl RunArray(modidx(r)).RunName ' '];
    end
end
if ~isempty(uploadstr)
    if strcmp(handles.machines(m).Conn,'ssh')
    tic
    % rsync is about twice as fast as scp
    %getresults = ['!rsync -zrp ' handles.machines(m).Username '@' handles.machines(m).Address ':' handles.machines(m).Repos prog '/results/' RunArray(modidx(r)).RunName  ' ' RunArray(modidx(r)).ModelDirectory sl 'results' sl ];
    getresults = ['!rsync -zrp  ' handles.machines(m).Username '@' handles.machines(m).Address mysshstr  ' ' cygwin([RunArray(uploadstr(1)).ModelDirectory sl 'results' sl]) ];
    %getresults = ['!scp -r ' handles.machines(m).Username '@' handles.machines(m).Address ':' handles.machines(m).Repos prog '/results/' RunArray(modidx(r)).RunName  ' ' RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName];

    eval(cygwin(getresults))

    toc
    end
    
    for r=1:length(uploadstr)
        if exist([RunArray(uploadstr(r)).ModelDirectory sl 'results' sl RunArray(uploadstr(r)).RunName],'dir')==7 && ~isempty(dir([RunArray(uploadstr(r)).ModelDirectory sl 'results' sl RunArray(uploadstr(r)).RunName]))
            LocalDirectory = RunArray(uploadstr(r)).ModelDirectory;
            ConcatSpikeRaster(handles,uploadstr(r))
            SortSpikeRaster(handles,uploadstr(r))
            loadexecdata(RunArray(uploadstr(r)));
            RunArray(uploadstr(r)).RemoteDirectory = RunArray(uploadstr(r)).ModelDirectory;
            RunArray(uploadstr(r)).ModelDirectory = LocalDirectory;
        else
            if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
                getresults = ['!' handles.machines(m).gsi 'scp ' upper(handles.machines(m).GSIOpt)  ' -r ' handles.machines(m).Username '@' handles.machines(m).Address ':' handles.machines(m).Repos prog  '/results/' RunArray(modidx(r)).RunName  ' ' cygwin([RunArray(modidx(r)).ModelDirectory sl 'results' sl RunArray(modidx(r)).RunName])];
                eval(cygwin(getresults))
            elseif strcmp(handles.machines(m).Conn,'ssh2')
                if exist('pswd','var')==0 || isempty(pswd) || strcmp(handles.machines(m).Nickname,pswdmach)==0 || iscell(pswd)==0
                    pswd=inputdlg(['Password for ' handles.machines(m).Username '@' handles.machines(m).Address]);
                    pswdmach=handles.machines(m).Nickname;
                end
                if isempty(pswd)
                    return
                end
                
                saveglobals;
                getlist = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos prog  '; tar -zcvf results/' RunArray(modidx(r)).RunName '.tgz results/' RunArray(modidx(r)).RunName]);
                retrieveglobals;
                getresults = scp_simple_get(handles.machines(m).Address,handles.machines(m).Username,pswd{:},{[RunArray(modidx(r)).RunName '.tgz']}, [RunArray(modidx(r)).ModelDirectory],[handles.machines(m).Repos prog  '/results']);
                retrieveglobals;
                system([cygpathcd 'cd ' RunArray(modidx(r)).ModelDirectory ' ' handles.dl ' tar -zxvf ' RunArray(modidx(r)).RunName '.tgz']);
                system([cygpathcd 'cd ' RunArray(modidx(r)).ModelDirectory ' ' handles.dl ' rm ' RunArray(modidx(r)).RunName '.tgz']);
                getlist = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos prog  '/results/; rm ' RunArray(modidx(r)).RunName '.tgz ']);
                retrieveglobals;

            else
                getresults = ['!scp -r ' handles.machines(m).Username '@' handles.machines(m).Address ':' handles.machines(m).Repos prog  '/results/' RunArray(modidx(r)).RunName  ' ' cygwin([RunArray(modidx(r)).ModelDirectory sl 'results' sl]) RunArray(modidx(r)).RunName];
                eval(cygwin(getresults))
            end

            if exist([RunArray(uploadstr(r)).ModelDirectory sl 'results' sl RunArray(uploadstr(r)).RunName],'dir')==7 && ~isempty(dir([RunArray(uploadstr(r)).ModelDirectory sl 'results' sl RunArray(uploadstr(r)).RunName]))
                        LocalDirectory = RunArray(uploadstr(r)).ModelDirectory;
                        ConcatSpikeRaster(handles,uploadstr(r))
                        SortSpikeRaster(handles,uploadstr(r))
                        loadexecdata(RunArray(uploadstr(r)));
                        RunArray(uploadstr(r)).RemoteDirectory = RunArray(uploadstr(r)).ModelDirectory;
                        RunArray(uploadstr(r)).ModelDirectory = LocalDirectory;
            end
        end        
    end
end

for r=1:length(modidx)
    GetJobNumber(modidx(r))
    ConcatSubconns(handles,modidx(r))
end


saveRuns(handles)
if refreshlist==1
    msgbox('Results have been uploaded.')
    x = mystrfind(get(handles.list_view,'String'),'Ran');
    set(handles.list_view,'Value',x)
    list_view_Callback(handles.list_view, [], handles);
end
catch ME
    handleME(ME)
end

function ExpandNSGResults(handles,ind,ext)
global cygpath cygpathcd mypath RunArray sl
Cipresflag=0;
switch ext
    case '1zip'
        ext='zip';
        cmdstr='unzip';
        Cipresflag=1;
    case 'zip'
        cmdstr='unzip';
    case 'gz'
        cmdstr='untar';
    case 'tar'
        cmdstr='untar';
end
myfile=dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl '*.' ext]);
file2unzip=[RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl myfile(1).name];
loc2place=[RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'tmp'];
eval([cmdstr '(file2unzip,loc2place);']);
mydir=dir([loc2place sl RunArray(ind).RunName sl 'results' sl]);
if sum([mydir(3:end).isdir])>1
    uiwait(msgbox('There is more than one results directory in the expansion. Consolidate manually before clicking OK.'))
end
if Cipresflag
    system([cygpathcd 'cd ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName handles.dl ...
            cygwin([' mv tmp' sl '*.*  .' sl handles.dl ...
            ' rm -f *.' ext ' ' handles.dl ' rm -r tmp'])]);
else
    system([cygpathcd 'cd ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName handles.dl ...
            cygwin([' mv tmp' sl RunArray(ind).RunName sl 'results' sl RunArray(ind).RunName sl '*.*  .' sl handles.dl ...
            ' rm -f *.' ext ' ' handles.dl ' rm -r tmp'])]);
end


% --------------------------------------------------------------------
function menuitem_designrun_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function makes the form of the SimTracker editable, plugs in
% default values, and adds a "save" button so you can create a new Run with
% this.

global cygpath cygpathcd mypath RunArray sl
try

if isempty(RunArray)
    handles.curses=[];handles.curses.ind=0; guidata(handles.list_view,handles)
    ind=0;
else
    ind=handles.curses.ind;
end

if isempty(ind)
    handles.curses=[];handles.curses.ind=0; guidata(handles.list_view,handles)
    ind=0;
end

guidata(hObject, handles);

% make the form view editable
mytable={'table_executioninfo', 'table_siminfo'};
for r=1:length(mytable)
    set(handles.(mytable{r}),'Data',repmat({''},size(get(handles.(mytable{r}),'Data')) ));
end
set(handles.table_siminfo,'ColumnEditable',true(size(get(handles.table_siminfo,'ColumnEditable'))));

% if exist([mypath sl 'data' sl 'parameters.mat'],'file')
%     load([mypath sl 'data' sl 'parameters.mat'],'parameters')
% else
%     load([mypath sl 'data' sl 'defaultparameters.mat'],'parameters')
% end
parameters=handles.parameters;%

idx = find([parameters(:).form]==1); %#ok<NODEF>
myrows={parameters(idx).nickname};
set(handles.table_siminfo,'RowName',myrows);
siminfo=[];
for r=1:length(idx)
    siminfo=[siminfo {parameters(idx(r)).default}]; %#ok<AGROW>
end
set(handles.table_siminfo,'Data',siminfo')

oneoff = {'RunName', 'RunComments'};
for r=1:length(oneoff)
    set(handles.(['txt_' oneoff{r}]), 'String', '');
    set(handles.(['txt_' oneoff{r}]),'Style','edit'); 
end
    set(handles.edit_numprocs,'Style','edit'); 

set(handles.txt_error, 'Value', 1);

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos') 

setversionmenu(myrepos(q).dir,handles)

inv = {'btn_saverun'}; 
for r=1:length(inv)
    set(handles.(inv{r}),'Visible','on','String','Save Run')
end

setmachinemenu(handles,1)

updatemenu(myrepos(q).dir,sl,handles,1,'stim','stimulation','stimulation')
updatemenu(myrepos(q).dir,sl,handles,1,'conn','connectivity','connections')

addcells2menu(myrepos(q).dir,sl,handles,'cellnumbers','cells','numdata')
addcells2menu(myrepos(q).dir,sl,handles,'conndata','conns','conndata')
addcells2menu(myrepos(q).dir,sl,handles,'syndata','syns','syndata')

catch ME
    handleME(ME)
end

function addcells2menu(myrep,sl,handles,filestr,varname,menuname)

mynumdata={};
a=dir([myrep sl 'datasets' sl filestr '_*.dat']);
if isempty(a)
    msgbox(['There are no ' filestr ' datasets in this repository.'])
    return
end
%load ../cellnumbers_gui/cells.mat %% new
cellflag=0;
if exist([myrep sl 'datasets' sl varname '.mat'])
    load([myrep sl 'datasets' sl varname '.mat']) %% new
    eval(['cellidx=length(' varname ')+1;'])
else
    cellflag=1;
    cellidx=1;
end
for r=1:length(a)
    tk = regexp(a(r).name,[filestr '_(\d*).dat'],'tokens');
    numtk = str2double(tk{1}{:});
    if numtk>90
        if cellflag==1 || eval(['isempty(find([' varname '(:).num]==numtk))'])
            eval([varname '(cellidx).num=numtk;'])
            eval([varname '(cellidx).comments='''';'])
            eval(['cellidx=length(' varname ')+1;'])
        end
        eval(['mynumdata{length(mynumdata)+1}=[tk{1}{:} '': '' ' varname '([' varname '(:).num]==numtk).comments];']) %#ok<NODEF,AGROW>
    end
end
if cellflag==1 && exist(varname,'var')
    save([myrep sl 'datasets' sl varname '.mat'],varname,'-v7.3') %% new
else
    save([myrep sl 'datasets' sl varname '.mat'],varname,'-append') %% new
end
if isempty(mynumdata)
    msgbox(['Doesn''t work for menu_' menuname])
else
    set(handles.(['menu_' menuname]),'Style','popupmenu','String',mynumdata,'Visible','on','Value',length(mynumdata))
end


function menuitem_editrun_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function allows the user to edit an already created run. If not yet
% executed, the design-related fields can be edited. If already executed,
% the execution-related fields can be edited 

global cygpath cygpathcd mypath RunArray sl

try

ind = handles.curses.ind;
if isempty(ind)
    return
end

if ~isempty(RunArray(ind).ExecutedBy)

    set(handles.table_executioninfo,'ColumnEditable',true(size(get(handles.table_executioninfo,'ColumnEditable'))));

else
    
    % make the form view editable
    set(handles.table_siminfo,'ColumnEditable',true(size(get(handles.table_siminfo,'ColumnEditable'))));

    oneoff = {'RunName', 'RunComments'}; %, 'ModelDirectory'
    for r=1:length(oneoff)
        set(handles.(['txt_' oneoff{r}]), 'String', '');
        set(handles.(['txt_' oneoff{r}]),'Style','edit'); 
    end
    set(handles.txt_RunName,'String', RunArray(ind).RunName); 
    set(handles.txt_RunComments,'String', RunArray(ind).RunComments)


q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos') 

setversionmenu(myrepos(q).dir,handles,ind)

setmachinemenu(handles,1,ind)

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

addcells2menu(myrepos(q).dir,sl,handles,'cellnumbers','cells','numdata')
addcells2menu(myrepos(q).dir,sl,handles,'conndata','conns','conndata')
addcells2menu(myrepos(q).dir,sl,handles,'syndata','syns','syndata')

updatemenu(myrepos(q).dir,sl,handles,1,'stim','stimulation','stimulation',ind,'Stimulation')
updatemenu(myrepos(q).dir,sl,handles,1,'conn','connectivity','connections',ind,'Connectivity')

    if strcmp(get(handles.menu_machine,'Style'),'popupmenu')
        machval=find(strncmp(RunArray(ind).Machine,get(handles.menu_machine,'String'),100)==1);
        set(handles.menu_machine,'Value',machval);
    else
        set(handles.menu_machine,'String',RunArray(ind).Machine);
    end

setvaldatasets(handles,ind,sl,myrepos(q).dir,'datasets','cells','NumData','numdata')
setvaldatasets(handles,ind,sl,myrepos(q).dir,'datasets','conns','ConnData','conndata')
setvaldatasets(handles,ind,sl,myrepos(q).dir,'datasets','syns','SynData','syndata')

    set(handles.edit_numprocs,'Style','edit')
end

inv = {'btn_saverun'};
for r=1:length(inv)
    set(handles.(inv{r}),'Visible','on','String','Update')
end
catch ME
    handleME(ME)
end


% --------------------------------------------------------------------
function menuitem_copyrun_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This allows for designing a new run, with the values from the currently
% selected run already populated in the form

global cygpath cygpathcd mypath RunArray sl

try
copyind = handles.curses.ind;

%guidata(hObject, handles);

% make the form view editable
mytable={'table_executioninfo', 'table_siminfo'};
for r=1:length(mytable)
    set(handles.(mytable{r}),'Data',repmat({''},size(get(handles.(mytable{r}),'Data')) ));
end
set(handles.table_siminfo,'ColumnEditable',true(size(get(handles.table_siminfo,'ColumnEditable'))));

oneoff = {'RunName', 'RunComments'}; %, 'ModelDirectory'
for r=1:length(oneoff)
    set(handles.(['txt_' oneoff{r}]), 'String', '');
    set(handles.(['txt_' oneoff{r}]),'Style','edit');
end

inv = {'btn_saverun'}; 
for r=1:length(inv)
    set(handles.(inv{r}),'Visible','on','String','Save Run')
end

set(handles.txt_error,'Value',1)

setmachinemenu(handles,1,copyind)

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

setversionmenu(myrepos(q).dir,handles,copyind)

updatemenu(myrepos(q).dir,sl,handles,1,'stim','stimulation','stimulation',copyind,'Stimulation')
updatemenu(myrepos(q).dir,sl,handles,1,'conn','connectivity','connections',copyind,'Connectivity')

addcells2menu(myrepos(q).dir,sl,handles,'cellnumbers','cells','numdata')
addcells2menu(myrepos(q).dir,sl,handles,'conndata','conns','conndata')
addcells2menu(myrepos(q).dir,sl,handles,'syndata','syns','syndata')

% set items to copied run
formdata(handles,copyind);
set(handles.txt_RunName,'String',[RunArray(copyind).RunName '_00'])


% 
% if strcmp(get(handles.menu_conn,'Style'),'popupmenu')
%     connval=find(strncmp(RunArray(copyind).Connectivity,get(handles.menu_conn,'String'),100)==1);
%     set(handles.menu_conn,'Value',connval);
% else
%     set(handles.menu_conn,'String',RunArray(copyind).Connectivity);
% end
setvaldatasets(handles,copyind,sl,myrepos(q).dir,'datasets','cells','NumData','numdata')
setvaldatasets(handles,copyind,sl,myrepos(q).dir,'datasets','conns','ConnData','conndata')
setvaldatasets(handles,copyind,sl,myrepos(q).dir,'datasets','syns','SynData','syndata')

set(handles.edit_numprocs,'String',num2str(RunArray(copyind).NumProcessors),'Style','edit');
catch ME
    handleME(ME)
end

function setversionmenu(myrep,handles,varargin)
global cygpath cygpathcd mypath RunArray

if isfield(handles.general,'mercurial') && ~isempty(handles.general.mercurial)
[~, result] = system([cygpath 'sh $HOME/.bashrc ' handles.dl ' cd ' myrep handles.dl handles.general.mercurial 'hg log']);
else
[~, result] = system([cygpath 'sh $HOME/.bashrc ' handles.dl  'cd ' myrep handles.dl cygpath 'hg log']); 
end
[vernum, ~] = regexp(result, 'changeset\:\ +(?<num>[\d]+)[\d\s\:]?', 'tokens', 'names');
[vercomm, ~] = regexp(result, 'summary\:\ +(?<vers>[^\n]+)[\d\w\s]?', 'tokens', 'names');

if isempty(vernum)
    msgbox('Please commit a version to the repository.')
    return
end

fl=1;
myvercomm={};
for r=1:length(vernum)
    myvercomm{r} = [char(vernum{r}) ': ' char(vercomm{r})]; %#ok<AGROW>
    if ~isempty(varargin)
        if strcmp(RunArray(varargin{1}).ModelVerComment,myvercomm{r})==1
            fl=r;
        end
    end
end
if isempty(myvercomm)
    myvercomm={''};
end
set(handles.txt_ModelVerComment ,'Style','popupmenu','String',myvercomm,'Value', fl);


% --------------------------------------------------------------------
function menuitem_deleterun_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function deletes a run from the SimTracker RunArray after confirm.

global cygpath cygpathcd mypath RunArray sl
try
ind = handles.curses.ind;
ButtonName = questdlg({'You are about to delete the run', ['''' RunArray(ind).RunName ''' from the Organizer. Continue?']}, 'Confirm Delete?', 'Yes', 'No', 'No');
q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

switch ButtonName
    case 'Yes'
        ButtonName2 = questdlg({'Do you want to delete the results folder for ', ['''' RunArray(ind).RunName ''' as well?']}, 'Confirm Delete?', 'Yes', 'No', 'No');
        switch ButtonName2
            case 'Yes'
                system(cygwin(['rm -r ' myrepos(q).dir sl 'results' sl RunArray(ind).RunName]));
        end
        RunArray(ind)=[];
        set(handles.list_view,'Value',1)
        list_view_Callback(handles.list_view, [], handles);
        saveRuns(handles);
end

%if ind>length(RunArray)
    handles.curses=[];handles.curses.ind=length(RunArray); guidata(handles.list_view,handles)
%end
catch ME
    handleME(ME)
end

% --------------------------------------------------------------------
function menuitem_executerun_Callback(hObject, eventdata, handles)
% This function executes a run or submits a jobscript to a queue on a
% supercomputer

global cygpath cygpathcd mypath RunArray sl

try
if size(handles.indices,1)>1
    origind=handles.curses.ind;

    tmpdata=get(handles.tbl_runs,'Data');
    handles.curses.indices = [];
    for r=1:size(handles.indices,1)
        myrow = handles.indices(r,1);
        RunName = tmpdata(myrow,1);
        handles.curses.indices(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1 ); % delete min for real data
    end
    
    for chkstr={'ModelVerComment'}
        try
            if length(unique({RunArray(handles.curses.ind).(chkstr{:})}))>1
                msgbox(['Multiple runs can only be submitted at the same time if they have the same ' chkstr{:} '.'],'Runs not Submitted','error');
                return
            end
        catch
            if length(unique([RunArray(handles.curses.ind).(chkstr{:})]))>1
                msgbox(['Multiple runs can only be submitted at the same time if they have the same ' chkstr{:} '.'],'Runs not Submitted','error');
                return
            end
        end
    end
    
    for z=1:length(handles.curses.indices)
        ind = handles.curses.indices(z);
        handles.curses.ind = ind;
        execrun(ind, hObject, eventdata, handles)
    end
    handles.curses.ind=origind;
else
    ind = handles.curses.ind;
    execrun(ind, hObject, eventdata, handles)
end
catch ME
    handleME(ME)
end

function execrun(ind,hObject, eventdata, handles)
global cygpath cygpathcd mypath RunArray sl divertflag

w=strfind(handles.general.neuron,'bin');

% perform checks before executing run
if ~isempty(RunArray(ind).ExecutedBy) && hObject~=handles.menuitem_debugrun
    msgbox('This run has already been executed.')
    return
end

g=importdata([RunArray(ind).ModelDirectory sl 'datasets' sl 'cellnumbers_' num2str(RunArray(ind).NumData) '.dat'],' ',1);
sp=findstr(RunArray(ind).LayerHeights,';');
numlayer=str2num(RunArray(ind).LayerHeights(1:sp-1));
if max(g.data(:,2))>(numlayer-1)
    msgbox(['Cell(s) defined in cellnumbers_' num2str(RunArray(ind).NumData) '.dat file are found in layer ' num2str(max(g.data(:,2))) ', but this exceeds maximum defined in LayerHeights: ' RunArray(ind).LayerHeights ' (zero-based).'])
    return
end


if ispc
    mystr='.exe';
else
    mystr='';
end

m=findstr(handles.general.neuron,' ');

if ~isempty(m)
    nrnpath=handles.general.neuron(1:m(1)-1);
else
    nrnpath=handles.general.neuron;
end

if exist([strrep(nrnpath,'.exe','') mystr],'file')==0
    msgbox({'Please update the location of NEURON''s','nrniv executable in the General Settings first.'})
    return
end
outstat=[];
[~, statresult]=system([cygpath 'sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory handles.dl ' hg status']);
updateflag=1;
[~, myname]=system([cygpath 'hostname']); % Warning: need to change this section so that user can easily add in a script how to run model on their compy
myname=deblank(myname);
if ~isempty(statresult) && strcmp(statresult(1:end-1),'sh: $HOME/.bashrc: No such file or directory')==0 && strcmp(statresult(1:end-1),'/usr/bin/sh: $HOME/.bashrc: No such file or directory')==0
    changes=regexp(statresult,'\n','split');
    myfiles={};
    for r=1:length(changes)
        if ~isempty(changes{r}) && strcmp(changes{r}(1),'?')==0 && isempty(strfind(changes{r},'No such file or directory'))% strcmp(changes{r}(1:min(44,end)),'sh: $HOME/.bashrc: No such file or directory')==0
            myfiles{length(myfiles)+1}=changes{r}; %#ok<AGROW>
        end
    end
    if ~isempty(myfiles)
        if strcmp(RunArray(ind).Machine, deblank(myname)) || strcmp(RunArray(ind).Machine, deblank(getenv('computername')))
            btn=questdlg({'There are uncommitted changes to the following files:',myfiles{:},'Update code version and lose changes or run with uncommitted changes or cancel run?'},'Overwrite Changes?','Overwrite','Run Uncommitted Code','Cancel Run','Run Uncommitted Code');
            if strcmp('Cancel Run',btn)
                return
            elseif strcmp('Run Uncommitted Code',btn)
                updateflag=0;
            end
        else
            btn=questdlg({'There are uncommitted changes to the following files:',myfiles{:},'If you submit this run, the changes will be lost. Continue?'},'Overwrite Changes?','Overwrite','Cancel Run','Cancel Run');
            if strcmp('Cancel Run',btn)
                return
            end
        end
    end
end

if updateflag==1
    if isfield(handles.general,'mercurial') && ~isempty(handles.general.mercurial)
    system([cygpath 'sh $HOME/.bashrc ' handles.dl ' '  'cd ' RunArray(ind).ModelDirectory handles.dl handles.general.mercurial 'hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') ]); % Update the local Mercurial version
    else
    system([cygpath 'sh $HOME/.bashrc ' handles.dl ' '  'cd ' RunArray(ind).ModelDirectory handles.dl cygpath 'hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') ]); % Update the local Mercurial version
    end
end
if ispc
    compilestr=[cygpath 'sh ' getenv('HOME') sl '.bashrc_nrnst ' handles.dl ' '  'cd ' RunArray(ind).ModelDirectory handles.dl ' ' handles.general.compilenrn];
else
    compilestr=[cygpath 'sh $HOME/.bashrc ' handles.dl ' '  'cd ' RunArray(ind).ModelDirectory handles.dl ' ' handles.general.compilenrn];
end
system(compilestr);

    [~, myname]=system([cygpath 'hostname']); % Warning: need to change this section so that user can easily add in a script how to run model on their compy

    if strcmp(RunArray(ind).Machine, deblank(myname)) || strcmp(RunArray(ind).Machine, deblank(getenv('computername')))
    z = find(strcmp(RunArray(ind).Machine,{handles.machines(:).Nickname})==1);
    RunArray(ind).TopProc = handles.machines(z).TopCmd;
    
    parameters=handles.parameters;%load([mypath sl 'data' sl 'parameters.mat'],'parameters')
    jobtype.options = {};
    m=1;
    for r=1:length(parameters)
        if parameters(r).file==1 && strcmp(parameters(r).name,'JobNumber')==0
            if strcmp(parameters(r).type,'string')==1
                jobtype.options{m}=['strdef ' parameters(r).name];
                m=m+1;
                jobtype.options{m}=[parameters(r).name '="' RunArray(ind).(parameters(r).name) '"'];
                m=m+1;
            else
                jobtype.options{m}=[parameters(r).name '=' num2str(RunArray(ind).(parameters(r).name))];
                m=m+1;
            end
        end
    end
    if exist([RunArray(ind).ModelDirectory sl 'jobscripts'],'dir')==0
        mkdir([RunArray(ind).ModelDirectory sl 'jobscripts']);
    end
    fid2 = fopen([RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName '_run.hoc'],'w');
    fprintf(fid2, '%s\n', jobtype.options{:});
    grr=cygwin(RunArray(ind).ModelDirectory);
    idx = strfind(grr,'/');
    jobtype.program = grr(idx(end)+1:end);

    fprintf(fid2, '{load_file("./main.hoc")}\n');
    %fprintf(fid2, '{load_file("./%s.hoc")}\n', jobtype.program);
    fclose(fid2);
    
    if hObject==handles.menuitem_debugrun
        if isdeployed
            msgbox({'..........','run the following commands in your terminal:',['cd ' cygwin(RunArray(ind).ModelDirectory)],['gdb ' cygwin(handles.general.neuron)],cygwin(['run   .' sl 'jobscripts' sl RunArray(ind).RunName '_run.hoc'])});
        else
        mydisp(['..........'],handles)
        mydisp(['run the following commands in your terminal:'],handles)
        mydisp(['cd ' cygwin(RunArray(ind).ModelDirectory)],handles)
        mydisp(['gdb ' cygwin(handles.general.neuron)],handles)
        mydisp(cygwin(['run   .' sl 'jobscripts' sl RunArray(ind).RunName '_run.hoc']),handles)
        end
    else
        %mydisp(cmdstr,handles)

        if handles.general.mpi==1
            cmdstr=[ 'cd ' RunArray(ind).ModelDirectory handles.dl ' mpiexec -n ' num2str(RunArray(ind).NumProcessors) ...
                ' ' handles.general.neuron ' -mpi   .' sl 'jobscripts' sl RunArray(ind).RunName '_run.hoc -c "quit()"'];
        else
            cmdstr=[ 'cd ' RunArray(ind).ModelDirectory handles.dl ' ' handles.general.neuron ' .' sl 'jobscripts' sl RunArray(ind).RunName '_run.hoc -c "quit()"'];
        end
        %mydisp(cmdstr,handles)
        [~, results] = system(cmdstr);
        mydisp(results,handles)
    end
    msgbox('The run has been executed.')
elseif strcmp(RunArray(ind).Machine, 'NSG')
    RunArray(ind).CatFlag=0;
    % in the jobscripts folder, make a runname folder
    %sl='/'; msgbox('backslash for mkdir and repos slash for fopen...')
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName]);

    % in that folder, place all the files in the root repos directory
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl]));
    % make a fresh results folder
    % copy in the setupfiles, cells, stimulation, x86_64 folders
    % make a new connections folder and upload the specific files necessary
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'results']);
    f2=fopen([RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'results' sl 'log.log'],'w');
    fclose(f2);
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'datasets']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(ind).ConnData) '.dat ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'datasets' sl]));
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'datasets' sl 'syndata_' num2str(RunArray(ind).SynData) '.dat ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'datasets' sl]));
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'datasets' sl 'cellnumbers_' num2str(RunArray(ind).NumData) '.dat ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'datasets' sl]));
   
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'setupfiles']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'setupfiles' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'setupfiles' sl]));
   
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'paths']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'paths' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'paths' sl]));
    
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'connectivity']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'connectivity' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'connectivity' sl]));
    
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'cells']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'cells' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'cells' sl]));

    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'cells' sl 'axondists']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'cells' sl 'axondists' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'cells' sl 'axondists' sl]));
    
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'stimulation']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'stimulation' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'stimulation' sl]));
    
    % make the run.hoc file and save it within the main folder
    parameters=handles.parameters;%load([mypath sl 'data' sl 'parameters.mat'],'parameters')
    jobtype.options = {};
    m=1;
    for r=1:length(parameters)
        if parameters(r).file==1 && strcmp(parameters(r).name,'JobNumber')==0
            if strcmp(parameters(r).type,'string')==1
                jobtype.options{m}=['strdef ' parameters(r).name];
                m=m+1;
                jobtype.options{m}=[parameters(r).name '="' RunArray(ind).(parameters(r).name) '"'];
                m=m+1;
            else
                jobtype.options{m}=[parameters(r).name '=' num2str(RunArray(ind).(parameters(r).name))];
                m=m+1;
            end
        end
    end

    fid2 = fopen([RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'init.hoc'],'w');
    fprintf(fid2, '%s\n', jobtype.options{:});
    grr=cygwin(RunArray(ind).ModelDirectory);
    idx = strfind(grr,'/');
    jobtype.program = grr(idx(end)+1:end);
    
    fprintf(fid2, '{load_file("./main.hoc")}\n');
    % fprintf(fid2, '{load_file("./%s.hoc")}\n', jobtype.program);
    fclose(fid2);   
    
    % check version stuff
    system(cygwin(['rm ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'hg_*.out']));
    system(cygwin(['rm ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl 'ver*.txt']));

    system([cygpath 'sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory handles.dl  'hg parent --template "{rev}: {desc}\n" > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'vercomment.txt']);
    system([cygpath 'sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory handles.dl  'hg parent --template "{node}\n" > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'version.txt']);

    [stat, res]=system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory ' ' handles.dl ' hg status']);
    if ~isempty(res)
        system([cygpath 'sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory ' ' handles.dl ' hg status > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'hg_status.out']);
        system([cygpath 'sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory ' ' handles.dl ' hg diff > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'hg_diff.out']);
    end

    %system(['cd ' RunArray(ind).ModelDirectory handles.dl  'MYTEST=$(hg status)' handles.dl ' if [ -n "$MYTEST" ]' handles.dl ' then hg status > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'hg_status.out' handles.dl ' fi' handles.dl ' if [ -n "$MYTEST" ]' handles.dl ' then hg diff > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'hg_diff.out' handles.dl ' fi']);
    
    % zip the runname folder
    tic
    zip([RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName '.zip'],[RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName]);
    toc
    system([cygpath 'rm -r ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName]);
    mymach=questdlg('Which NSG machine will you use?','NSG Machine','Comet','Stampede','Comet');
    switch mymach
        case 'Comet'
            CoresPerNode=24;
        case 'Stampede'
            CoresPerNode=16;
        otherwise
            CoresPerNode=16;
    end
    % display info to the user
    myzipdir = [RunArray(ind).ModelDirectory sl 'jobscripts'];
    system([cygpath handles.general.explorer ' ' myzipdir]);
    m = find(strcmp(RunArray(ind).Machine,{handles.machines(:).Nickname})==1);
    msgbox({[RunArray(ind).RunName ' instructions:'], 'Log onto nsgportal', ...
            ['Zip file to upload: "' RunArray(ind).RunName '.zip"'], ...
            ['Tool: NEURON7.3 on ' mymach], ...
            'Parameters:', ...
            ['Max hours to run: ' num2str(RunArray(ind).JobHours)], ...
             'Main input file to run: "init.hoc"', ...
            ['# nodes: ' num2str(ceil(RunArray(ind).NumProcessors/CoresPerNode))], ...
             ['Cores per node: ' num2str(CoresPerNode)], ...
            ''})
else
    outstat=jobscript(hObject,handles); % Warning = add time shift property to the machines structure. For ranger (2), it should be -2 hours
    handles=guidata(hObject); %#ok<NASGU>
    if ~isempty(outstat) && outstat==1
        m = find(strcmp(RunArray(ind).Machine,{handles.machines(:).Nickname})==1);
        if ~strcmp(handles.machines(m).Conn,'script') && divertflag==0
            msgbox('The run has been submitted.')
        end
    else
        msgbox('There was an error submitting the run.')
    end
end






function pkg4michael(handles)
global cygpath cygpathcd cygpathcd mypath RunArray sl
ind = handles.curses.ind;

% 
% if isempty(getenv('HOME'))
%     [~, wh]=system('whoami');
%     myhome=regexp(wh,'[^\w]*[/\\]([^\w]*)','split');
%     setenv('HOME',['/home/' myhome{2}])
% end

[~, statresult]=system([cygpath 'sh $HOME/.bashrc ' handles.dl ' ' cygpathcd 'cd ' RunArray(ind).ModelDirectory handles.dl ' hg status']);

if ~isempty(statresult) && strcmp(statresult(1:end-1),'sh: $HOME/.bashrc: No such file or directory')==0 && strcmp(statresult(1:end-1),'/usr/bin/sh: $HOME/.bashrc: No such file or directory')==0 && strcmp(statresult([1:57 59:end-1]),'''.'' is not recognized as an internal or external command,operable program or batch file.')==0
    changes=regexp(statresult,'\n','split');
    myfiles={};
    for r=1:length(changes)
        if ~isempty(changes{r}) && strcmp(changes{r}(1),'?')==0 &&  isempty(strfind(changes{r},'No such file or directory'))%
            myfiles{length(myfiles)+1}=changes{r}; %#ok<AGROW>
        end
    end
    if ~isempty(myfiles)
        btn=questdlg({'There are uncommitted changes to the following files:',myfiles{:},'If you prepare this troubleshooting package,', 'the changes will be lost. Continue?'},'Overwrite Changes?','Overwrite','Cancel Run','Cancel Run');
        if strcmp('Cancel Run',btn)
            return
        end
    end
end

    if isfield(handles.general,'mercurial') && ~isempty(handles.general.mercurial)
        system([cygpath 'sh $HOME/.bashrc ' handles.dl ' ' cygpathcd 'cd ' RunArray(ind).ModelDirectory handles.dl ' ' handles.general.mercurial 'hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') ]); % Update the local Mercurial version
    else
        system([cygpath 'sh $HOME/.bashrc ' handles.dl ' ' cygpathcd 'cd ' RunArray(ind).ModelDirectory handles.dl ' ' cygpath 'hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') ]); % Update the local Mercurial version
    end
compilestr=[cygpath 'sh $HOME/.bashrc ' handles.dl ' ' cygpathcd 'cd ' RunArray(ind).ModelDirectory handles.dl ' ' handles.general.compilenrn]; %handles.compilenrn];
[~, myname]=system([cygpath 'hostname']); % Warning: need to change this section so that user can easily add in a script how to run model on their compy
    system(compilestr);
    
    RunArray(ind).CatFlag=0;
    % in the jobscripts folder, make a runname folder
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName '_trblsht']);

    % in that folder, place all the files in the root repos directory
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl]));
    
    % make a fresh results folder
    % copy in the setupfiles, cells, stimulation, x86_64 folders
    % make a new connections folder and upload the specific files necessary
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'results']);
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'results' sl RunArray(ind).RunName]);
    f2=fopen([RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'results' sl RunArray(ind).RunName sl 'log.log'],'w');
    fclose(f2);
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName '_trblsht' sl 'datasets']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(ind).ConnData) '.dat ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'datasets' sl]));
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'datasets' sl 'syndata_' num2str(RunArray(ind).SynData) '.dat ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'datasets' sl]));
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'datasets' sl 'cellnumbers_' num2str(RunArray(ind).NumData) '.dat ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'datasets' sl]));
   
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'setupfiles']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'setupfiles' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'setupfiles' sl]));
   
    system(['mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'connectivity']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'connectivity' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'connectivity' sl]));
    
    % use runname, don't make a new folder in results
    mydir = [RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName   '_trblsht' sl 'main.hoc'];
    pushstr = [cygpath 'sed "/save_run_info/c  strdef cmd, dircmd, direx // don''t run save_run_info in the troubleshooting version" ' mydir ' > x' handles.dl 'mv x ' mydir ];
    system(pushstr);
    
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'cells']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'cells' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'cells' sl]));
    
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'stimulation']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'stimulation' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'stimulation' sl]));
    
    system([cygpath 'mkdir ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'x86_64']);
    system(cygwin(['cp ' RunArray(ind).ModelDirectory sl 'x86_64' sl '*.* ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'x86_64' sl]));

    % make the run.hoc file and save it within the main folder
    parameters=handles.parameters;%load([mypath sl 'data' sl 'parameters.mat'],'parameters');
    jobtype.options = {};
    m=1;
    for r=1:length(parameters)
        if parameters(r).file==1 && strcmp(parameters(r).name,'JobNumber')==0
            if strcmp(parameters(r).type,'string')==1
                jobtype.options{m}=['strdef ' parameters(r).name];
                m=m+1;
                jobtype.options{m}=[parameters(r).name '="' RunArray(ind).(parameters(r).name) '"'];
                m=m+1;
            else
                jobtype.options{m}=[parameters(r).name '=' num2str(RunArray(ind).(parameters(r).name))];
                m=m+1;
            end
        end
    end

    fid2 = fopen([RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'init.hoc'],'w');
    fprintf(fid2, '%s\n', jobtype.options{:});
    grr=cygwin(RunArray(ind).ModelDirectory);
    idx = strfind(grr,'/');
    jobtype.program = grr(idx(end)+1:end);
    
    fprintf(fid2, '{load_file("./main.hoc")}\n');
    % fprintf(fid2, '{load_file("./%s.hoc")}\n', jobtype.program);
    fclose(fid2);   
    
    % check version stuff
    system([cygpath 'rm ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'hg_*.out']);
    system(['rm ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl 'ver*.txt']);

    system([cygpath 'sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory handles.dl  'hg parent --template "{rev}: {desc}\n" > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl  'vercomment.txt']);
    system([cygpath 'sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory handles.dl  'hg parent --template "{node}\n" > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl  'version.txt']);

    system([cygpath 'sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory handles.dl  'MYTEST=$(hg status)' handles.dl ' if [ -n "$MYTEST" ]' handles.dl ' then hg status > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl  'hg_status.out' handles.dl ' fi' handles.dl ' if [ -n "$MYTEST" ]' handles.dl ' then hg diff > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht' sl  'hg_diff.out' handles.dl ' fi']);

    
    % zip the runname folder
    tic
    zip([RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht.zip'],[RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht']);
    toc
    system([cygpath 'rm -r ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName  '_trblsht']);

    % display info to the user
    runtimestr= ['Max. run time: ' num2str(2)];
    if ~isempty(RunArray(ind).RunTime) && RunArray(ind).RunTime>0
        runtimestr=['Approx. run time: ' num2str(RunArray(ind).RunTime/3600) ' hours']; % this will never happen, errored runs don't have runtimes.
    end
    myzipdir = [RunArray(ind).ModelDirectory sl 'jobscripts'];
    system([cygpath handles.general.explorer ' ' myzipdir]);
    msgbox({[RunArray(ind).RunName ' instructions:'], ...
            ['Send this zip file: "' RunArray(ind).RunName  '_trblsht.zip"'], ...
             'Share the following info:', ...
             'Main input file to run: "init.hoc"', ...
             runtimestr, ...
            ['  on ' num2str(RunArray(ind).NumProcessors) ' processors'], ...
            ''})



% --------------------------------------------------------------------
function menuitem_jobfile_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function will grab the job output file for that run

global cygpath cygpathcd cygpathcd mypath RunArray sl
try

ind = handles.curses.ind;
% 
% m = find(strcmp(RunArray(ind).Machine,{handles.machines(:).Nickname})==1);
% idx = strfind(RunArray(ind).ModelDirectory,sl);
% jobtype.program = RunArray(ind).ModelDirectory(idx(end)+1:end);
% jobtype.repos = [handles.machines(m).Repos jobtype.program];
% 
% getjobfile = ['!gsiscp  ' handles.machines(m).Username '@' handles.machines(m).Address ':' jobtype.repos '/jobscripts/' RunArray(ind).RunName '*.o ' RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName '/'];
% eval(getjobfile);
% 
% system([handles.general.explorer ' ' RunArray(ind).ModelDirectory sl
% 'results' sl RunArray(ind).RunName sl]);

if RunArray(ind).JobNumber==0
    system([cygpath handles.general.textviewer ' ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl RunArray(ind).RunName '*.o '])
else
dd=dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl '*' num2str(RunArray(ind).JobNumber) '*']);
system([cygpath handles.general.textviewer ' ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl dd.name]);
%system([handles.general.textviewer ' ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl RunArray(ind).RunName '*' num2str(RunArray(ind).JobNumber) '*'])
end
catch ME
    handleME(ME)
end



function menuitems_outputs_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function allows the user to update the outputs available with
% the SimTracker
global cygpath cygpathcd cygpathcd mypath sl

h=outputset;
uiwait(h);

if exist([mypath sl 'data' sl 'MyOrganizer.mat'],'file')==2
    load([mypath sl 'data' sl 'MyOrganizer.mat'],'myoutputs');
else
    msgbox('Can''t find MyOrganizer file');
end

if exist('myoutputs','var')==1
    handles.myoutputs=myoutputs; % machines previously loaded from MyOrganizer.mat
    msgbox('Output list updated');
else
    msgbox('Can''t find output struct');
end

guidata(hObject, handles);

update_avail_outputs(handles);

% --- Executes when selected cell(s) is changed in tbl_outputtypes.
function tbl_outputtypes_CellSelectionCallback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

mydata=get(handles.tbl_outputtypes,'Data');
try
    if isempty(eventdata) || isprop(eventdata,'Indices')==0 || isempty(eventdata.Indices)
        return;
    end
idx=strmatch(mydata{eventdata.Indices(1),1},{handles.myoutputs(:).output},'exact');

if isempty(idx) || isempty(handles.myoutputs(idx).output)
    set(handles.tbl_outputtypes,'TooltipString',[handles.myoutputs(idx).output ' has no specific options.']);
else
    set(handles.tbl_outputtypes,'TooltipString',sprintf([handles.myoutputs(idx).output ' arguments:\n' handles.myoutputs(idx).tooltip]));
end
catch ME
    handleME(ME)
end


% --- Executes when entered data in editable cell(s) in tbl_outputtypes.
function tbl_outputtypes_CellEditCallback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to tbl_outputtypes (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
try
data=get(hObject,'Data');
cols=get(hObject,'ColumnFormat');
if strcmp(cols(eventdata.Indices(2)),'logical')
    if eventdata.EditData
        data{eventdata.Indices(1),eventdata.Indices(2)}=true;
    else
        data{eventdata.Indices(1),eventdata.Indices(2)}=false;
    end
end

set(hObject,'Data',data);
catch ME
    handleME(ME)
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    delete(hObject); % calls figure1_DeleteFcn
catch ME
    handleME(ME)
end

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuitem_help_Callback(hObject, eventdata, handles) %#ok<DEFNU>
global realpath sl cygpath cygpathcd logloc
% This function displays the instruction manual for the SimTracker


try
    wflag='w';
    if exist([logloc 'SimTrackerOutput.log'],'file')
        wflag='a';
    end
    fid = fopen([logloc 'SimTrackerOutput.log'],wflag);
    mycmd=[cygpath handles.general.pdfviewer ' '  strrep(cygwin([realpath  sl 'SimTrackerManual.pdf']),' ','\ ')];
    fprintf(fid,'Opening manual located at:\n%s\n\n',mycmd);
    [rr,ss]=system(mycmd);
    if rr~=0
        fprintf(fid,'Msg:\n%s\n\n',ss);
        mycmd=[cygpath handles.general.pdfviewer ' "'  cygwin([realpath  sl 'SimTrackerManual.pdf"'])];
        fprintf(fid,'Opening manual located at:\n%s\n\n',mycmd);
        [rr,ss]=system(mycmd);
        if rr~=0
            fprintf(fid,'Msg:\n%s\n\n',ss);
        end
    end
    fclose(fid);
catch ME
    handleME(ME)
end


% --------------------------------------------------------------------
function menuitem_about_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% This function displays information about the SimTracker

msgbox({'SimTracker Version 1.0','Coded by Marianne Bezaire','marianne.bezaire@gmail.com'})

function UID=getUID
global realpath sl
% This function generates the unique ID for each run


if isunix || ismac
    [~, UID]=system('uuidgen');
elseif exist('C:\Windows\system32\cscript.exe','file') || exist('C:\WINDOWS\SysWOW64\cscript.exe','file')
    if exist('C:\WINDOWS\SysWOW64\cscript.exe','file')
        ccmd='C:\WINDOWS\SysWOW64\cscript';
    else
        ccmd='C:\Windows\system32\cscript';
    end
    
    tmppath = ['"' realpath sl 'uuid.vbs' '"'];

    [~, UID]=system([ccmd ' //NoLogo ' tmppath]);
    chkmsg=regexp(UID,'\n','split');
    if length(chkmsg)>1
        for c=length(chkmsg):-1:1
            if ~isempty(regexp(chkmsg{c},'[A-Z0-9]+\-[A-Z0-9]+\-[A-Z0-9]+','match'))
                UID=chkmsg{c};
            end
        end
    end
    i=0;
    while (~isempty(strfind(UID,'uuid')) && i<3)
        [~, UID]=system([ccmd ' //NoLogo ' tmppath]);
        i=i+1;
    end
    if ~isempty(strfind(UID,'uuid')) || isempty(UID)
        msgbox({'Incorrect UID set:',UID,'Setting UID to ''0'' for now'})
        UID='0 ';
    end
else
    UID='0 ';
end
UID=UID(1:end-1);
if strfind(UID,'sh: $HOME/.bashrc: No such file or directory')
    tgr=strfind(UID,'sh: $HOME/.bashrc: No such file or directory');
    UID(tgr:(tgr+length('sh: $HOME/.bashrc: No such file or directory')))=[];
elseif strfind(UID,'sh: $HOME/.bashrc: No such file or director')
    tgr=strfind(UID,'sh: $HOME/.bashrc: No such file or director');
    UID(tgr:(tgr+length('sh: $HOME/.bashrc: No such file or director')))=[];
end

% --- Executes on button press in btn_saverun.
function btn_saverun_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function adds the new run data to the already created new index into
% RunArray

global cygpath cygpathcd cygpathcd mypath RunArray sl

try

% check RunName...
if iscell(get(handles.txt_RunName, 'String'))
    checkname=get(handles.txt_RunName, 'String');
    checkstr=checkname{:};
    set(handles.txt_RunName, 'String',checkstr);
else
    checkstr=get(handles.txt_RunName, 'String');
end
if ~isempty(regexp(checkstr,'\W','match')) %  (not a-zA-Z_0-9)
    msgbox({'Cannot save run with this name','Must contain only letters, numbers, and underscores.'});
    return
end

ind = handles.curses.ind;

parameters=handles.parameters;%load([mypath sl 'data' sl 'parameters.mat'],'parameters')
q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

set(handles.txt_datalabel,'String',['Current Directory: ' myrepos(q).dir])
pex=get(handles.txt_datalabel,'Extent');
pos=get(handles.txt_datalabel,'Position');
set(handles.txt_datalabel,'Position',[pos(1) pos(2) pex(3) pex(4)]);


if strcmp(get(handles.btn_saverun,'String'),'Update')==0 % Save a new run
    ind = length(RunArray)+1;
    handles.curses=[];handles.curses.ind= ind; guidata(handles.list_view,handles)
    UID=getUID;

    RunArray(ind)=SimRun(get(handles.txt_RunName, 'String'), myrepos(q).dir,UID); % get(handles.txt_ModelDirectory, 'String'));  % unique id as third arg? system('cscript //NoLogo uuid.vbs')
    set(handles.txt_RunName,'Style','text'); % text is uneditable
    %set(handles.txt_ModelDirectory,'Style','text'); % text is uneditable
else
    RunArray(ind).RunName=get(handles.txt_RunName,'String');
end
    
if isempty(RunArray(ind).ExecutedBy)    
    RunArray(ind).RunComments=get(handles.txt_RunComments,'String');

    mytable={'table_siminfo'};
    % loop through each table
    for r=1:length(mytable)
        %   make each table uneditable
        set(handles.(mytable{r}),'ColumnEditable',false(size(get(handles.(mytable{r}),'ColumnEditable'))));
        myfields = get(handles.(mytable{r}),'RowName');
        mydata = get(handles.(mytable{r}),'Data');
        for k=1:length(myfields)

            idx=find(strcmp({parameters(:).nickname},myfields{k})==1);
            field=parameters(idx).name;

            % Warning = check column format and convert value mydata{k} as
            % necessary before setting RunArray(ind).field
            if ~isempty(mydata{k})
                try
                if strcmp(parameters(idx).type,'string')
                    RunArray(ind).(field) = mydata{k};
                else
                    try
                        RunArray(ind).(field) = str2num(mydata{k}); %#ok<ST2NM>
                    catch %#ok<CTCH>
                        RunArray(ind).(field) = mydata{k};
                    end
                end
                catch
                    'm'
                end
            end
        end
    end

    try %#ok<TRYNC>
        RunArray(ind).ConnData=str2double(RunArray(ind).ConnData);
    end
    try %#ok<TRYNC>
        RunArray(ind).SynData=str2double(RunArray(ind).SynData);
    end
    try %#ok<TRYNC>
        RunArray(ind).SynData=str2double(RunArray(ind).NumData);
    end

    versions = get(handles.txt_ModelVerComment, 'String');
    try
    RunArray(ind).ModelVerComment = versions{max(get(handles.txt_ModelVerComment, 'Value'),1)};
    catch
        ind
    end
    set(handles.txt_ModelVerComment,'Style','text','String',RunArray(ind).ModelVerComment);

    inv = {'btn_saverun'};
    for r=1:length(inv)
        set(handles.(inv{r}),'Visible','off')
    end

    if strcmp(get(handles.menu_machine,'Style'),'text')==1
        RunArray(ind).Machine = get(handles.menu_machine,'String');
    else
        tmpstr = get(handles.menu_machine,'String');
        RunArray(ind).Machine = tmpstr{get(handles.menu_machine,'Value')};
        set(handles.menu_machine,'Style','text','String',RunArray(ind).Machine)
    end

    if strcmp(get(handles.menu_stim,'Style'),'text')==1
        RunArray(ind).Stimulation = get(handles.menu_stim,'String');
    else
        tmpstr = get(handles.menu_stim,'String');
        RunArray(ind).Stimulation = tmpstr{get(handles.menu_stim,'Value')};
        set(handles.menu_stim,'Style','text','String',RunArray(ind).Stimulation)
    end
    
    if strcmp(get(handles.menu_conn,'Style'),'text')==1
        RunArray(ind).Connectivity = get(handles.menu_conn,'String');
    else
        tmpstr = get(handles.menu_conn,'String');
        RunArray(ind).Connectivity = tmpstr{get(handles.menu_conn,'Value')};
        set(handles.menu_conn,'Style','text','String',RunArray(ind).Connectivity)
    end

    try
        tmpstr = get(handles.menu_numdata,'String');
        mystr=tmpstr{get(handles.menu_numdata,'Value')};
        m=strfind(mystr,':');
        RunArray(ind).NumData = str2double(mystr(1:m-1));
    catch ME
        mystr='101:?';
        RunArray(ind).NumData = 101;
    end
    set(handles.menu_numdata,'Style','text','String',mystr)

    try
        tmpstr = get(handles.menu_conndata,'String');
        mystr=tmpstr{get(handles.menu_conndata,'Value')};
        m=strfind(mystr,':');
        RunArray(ind).ConnData = str2double(mystr(1:m-1));
    catch ME
        mystr='101:?';
        RunArray(ind).ConnData = 101;
    end
    set(handles.menu_conndata,'Style','text','String',mystr)

    try
        tmpstr = cellstr(get(handles.menu_syndata,'String'));
        mystr=tmpstr{get(handles.menu_syndata,'Value')};
        m=strfind(mystr,':');
        RunArray(ind).SynData = str2double(mystr(1:m-1));
    catch ME
        mystr='101:?';
        RunArray(ind).SynData = 101;
    end
    set(handles.menu_syndata,'Style','text','String',mystr)

    tmpstr = get(handles.edit_numprocs,'String');
    RunArray(ind).NumProcessors = str2double(tmpstr);
    set(handles.edit_numprocs,'Style','text')
    
else
    mytable={'table_executioninfo'};
    % loop through each table
    msgbox('Does this part work right?')
    if 1==0
    for r=1:length(mytable)
        %   make each table uneditable
        set(handles.(mytable{r}),'ColumnEditable',false(size(get(handles.(mytable{r}),'ColumnEditable'))));
        myfields = get(handles.(mytable{r}),'RowName');
        mydata = get(handles.(mytable{r}),'Data');
        for k=1:length(myfields)
            tl = findstr(myfields{k},' (');
            if ~isempty(tl)
                myfields{k} = myfields{k}(1:tl-1);
            end
            idx=find(strcmp({parameters(:).nickname},myfields{k})==1);
            field=parameters(idx).name;
            if isempty(mystrfind({'ExecutionDate','ExecutedBy'},field)) %isempty(mystrfind(field,{'ExecutionDate','ExecutedBy'}))
                % Warning = check column format and convert value mydata{k} as
                % necessary before setting RunArray(ind).field
                if ~isempty(mydata{k})
                    if strcmp(parameters(idx).type,'string')
                        RunArray(ind).(field) = mydata{k};
                    else
                        try
                            RunArray(ind).(field) = str2num(mydata{k}); %#ok<ST2NM>
                        catch %#ok<CTCH>
                            RunArray(ind).(field) = mydata{k};
                        end
                    end
                end
            end
        end
    end 
end
end

saveRuns(handles)
set(handles.btn_saverun,'Visible','off')
x = mystrfind(get(handles.list_view,'String'),'Not Ran');
set(handles.list_view,'Value',x)
list_view_Callback(handles.list_view, [], handles)
catch ME
    handleME(ME)
end

function menu_machine_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_machine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_machine contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_machine


% --- Executes during object creation, after setting all properties.
function menu_machine_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_machine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_stim.
function menu_stim_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_stim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_stim


% --- Executes during object creation, after setting all properties.
function menu_stim_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_conn.
function menu_conn_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_conn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_conn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_conn


% --- Executes during object creation, after setting all properties.
function menu_conn_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_conn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------

function menuitem_executeparamspace_Callback(hObject, eventdata, handles)
global cygpath cygpathcd cygpathcd mypath RunArray sl pswd pswdmach usesamehours

% msgbox({'Please update your SimTracker version to the','most current one to access this functionality.'})
% return
if isdeployed
        msgbox('This functionality not yet implemented for deployed applications.')
return
end

try 
    
problem=0;
partOfBatchSquared=0;
usesamehours=0;


if ispc
    mystr='.exe';
else
    mystr='';
end
m=findstr(handles.general.neuron,' ');
if ~isempty(m)
    nrnpath=handles.general.neuron(1:m(1)-1);
else
    nrnpath=handles.general.neuron;
end
if exist([strrep(nrnpath,'.exe','') mystr],'file')==0
    msgbox({'Please update the location of NEURON''s','nrniv executable in the General Settings first.'})
    return
end
[~, myname]=system('hostname');

runset=1;

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

[~, statresult]=system(['sh $HOME/.bashrc ' handles.dl ' cd ' myrepos(q).dir handles.dl ' hg status']); % RunArray(ind).ModelDirectory
ind=handles.curses.ind;
if isempty(ind)
	ind = length(RunArray);
end
updateflag=1;
if ~isempty(statresult) && strcmp(statresult(1:end-1),'sh: $HOME/.bashrc: No such file or directory')==0 && strcmp(statresult(1:end-1),'/usr/bin/sh: $HOME/.bashrc: No such file or directory')==0
    changes=regexp(statresult,'\n','split');
    myfiles={};
    for r=1:length(changes)
        if ~isempty(changes{r}) && strcmp(changes{r}(1),'?')==0 &&  isempty(strfind(changes{r},'No such file or directory')) % strcmp(changes{r}(1:min(44,end)),'sh: $HOME/.bashrc: No such file or directory')==0
            myfiles{length(myfiles)+1}=changes{r}; %#ok<AGROW>
        end
    end
    if ~isempty(myfiles) %gohere
        if strcmp(RunArray(ind).Machine, deblank(myname)) || strcmp(RunArray(ind).Machine, deblank(getenv('computername'))) 
            btn=questdlg({'There are uncommitted changes to the following files:',myfiles{:},'Update code version and lose changes or run with uncommitted changes or cancel run?'},'Overwrite Changes?','Overwrite','Run Uncommitted Code','Cancel Run','Cancel Run');
            if strcmp('Cancel Run',btn)
                return
            elseif strcmp('Run Uncommitted Code',btn)
                updateflag=0;
            end
        else
            btn=questdlg({'There are uncommitted changes to the following files:',myfiles{:},'If you submit this run, the changes will be lost. Continue?'},'Overwrite Changes?','Overwrite','Cancel Run','Cancel Run');
            if strcmp('Cancel Run',btn)
                return
            end
        end
    end
end

if updateflag==1 && runset==1
    system(['sh $HOME/.bashrc ' handles.dl  'cd ' RunArray(ind).ModelDirectory handles.dl ' hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') ]); % Update the local Mercurial version
    compilestr=['cd ' RunArray(ind).ModelDirectory handles.dl ' ' handles.general.compilenrn]; %handles.compilenrn];
    system(compilestr);
end

[~, myname]=system('hostname');


parameters=handles.parameters;%load([mypath sl 'data' sl 'parameters.mat'],'parameters')
outstat=[];

testy=strmatch('string',{parameters.type}');
listOparams={parameters.name};
listOparams(testy)=[];

alsoremove={'NumSpikes', 'NumConnections', 'NumCellTypes', 'RunTime', 'NumCellsRecorded', 'NumCells','ExecutionDate','ExecutedBy','RunTime'};

for a=1:length(alsoremove)
    testy=strmatch(alsoremove{a},listOparams);
    listOparams(testy)=[];
end

[vars2change, mymat, runnames]=paramsearchtool(listOparams,1);
moddir=RunArray(ind).ModelDirectory;

% for m=1:size(mymat,1)
%     % set new ind
%     % set name
%     RunArray(ind).RunName = runnames{m};
%     for p=1:length(vars2change)
%         RunArray(ind).(vars2change{p}) = mymat(m,p);
%     end
%     % execute sim
% end

    for r=1:length(runnames)
        newind = length(RunArray)+1;
        flds = fieldnames(RunArray);
        UID=getUID;
        RunArray(newind) = SimRun(runnames{r}, moddir,UID);  % unique id as third arg? system('cscript //NoLogo uuid.vbs')

        for g=1:length(flds)
            if strcmp(flds{g},'UID')==0 && strcmp(flds{g},'RunName')==0  && sum(strcmp(alsoremove,flds{g}))==0
                RunArray(newind).(flds{g}) = RunArray(ind).(flds{g});
            end
        end

        %RunArray(newind).RunName = [RunArray(ind).RunName '_' sprintf('%02.0f', r)];
        
        for p=1:length(vars2change)
            RunArray(newind).(vars2change{p}) = mymat(r,p);
        end

        if strcmp(RunArray(newind).Machine, deblank(myname)) || strcmp(RunArray(newind).Machine, deblank(getenv('computername'))) 
            g=1;
            for k=1:length(parameters)
                if parameters(k).file==1 && strcmp(parameters(k).name,'JobNumber')==0
                    if strcmp(parameters(k).type,'string')==1
                        jobtype.options{g}=['strdef ' parameters(k).name];
                        g=g+1;
                        jobtype.options{g}=[parameters(k).name '="' RunArray(newind).(parameters(k).name) '"'];
                        g=g+1;
                    else
                        jobtype.options{g}=[parameters(k).name '=' num2str(RunArray(newind).(parameters(k).name))];
                        g=g+1;
                    end
                end
            end

            fid2 = fopen([RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName '_run.hoc'],'w');
            fprintf(fid2, '%s\n', jobtype.options{:});
            grr=cygwin(RunArray(newind).ModelDirectory);
            idx = strfind(grr,'/');
            jobtype.program = grr(idx(end)+1:end);

            fprintf(fid2, '{load_file("./main.hoc")}\n');
            % fprintf(fid2, '{load_file("./%s.hoc")}\n', jobtype.program);
            fclose(fid2);

            if handles.general.mpi==1
                cmdstr=['cd ' RunArray(newind).ModelDirectory handles.dl ' mpiexec -n ' num2str(RunArray(newind).NumProcessors) ...
                    ' ' handles.general.neuron ' -mpi   .' sl 'jobscripts' sl RunArray(newind).RunName '_run.hoc'];
            else
                cmdstr=['cd ' RunArray(newind).ModelDirectory handles.dl ' ' handles.general.neuron ' .' sl 'jobscripts' sl RunArray(newind).RunName '_run.hoc'];
            end

            %mydisp(cmdstr,handles)
            [~, results] = system(cmdstr);
            mydisp(results,handles)
        elseif strcmp(RunArray(newind).Machine, 'NSG') %comehere        
            RunArray(newind).CatFlag=0;
            % in the jobscripts folder, make a runname folder
            %sl='/'; msgbox('backslash for mkdir and repos slash for fopen...')
            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName]);

            % in that folder, place all the files in the root repos directory
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl]));
            % make a fresh results folder
            % copy in the setupfiles, cells, stimulation, x86_64 folders
            % make a new connections folder and upload the specific files necessary
            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'results']);
            f2=fopen([RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'results' sl 'log.log'],'w');
            fclose(f2);
            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'datasets']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(newind).ConnData) '.dat ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'datasets' sl]));
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'datasets' sl 'syndata_' num2str(RunArray(newind).SynData) '.dat ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'datasets' sl]));
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'datasets' sl 'cellnumbers_' num2str(RunArray(newind).NumData) '.dat ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'datasets' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'setupfiles']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'setupfiles' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'setupfiles' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'connectivity']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'connectivity' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'connectivity' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'cells']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'cells' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'cells' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'cells' sl 'axondists']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'cells' sl 'axondists' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'cells' sl 'axondists' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'stimulation']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'stimulation' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'stimulation' sl]));

            % make the run.hoc file and save it within the main folder
            parameters=handles.parameters;%load([mypath sl 'data' sl 'parameters.mat'],'parameters');
            jobtype.options = {};
            m=1;
            for rrr=1:length(parameters)
                if parameters(rrr).file==1 && strcmp(parameters(rrr).name,'JobNumber')==0
                    if strcmp(parameters(rrr).type,'string')==1
                        jobtype.options{m}=['strdef ' parameters(rrr).name];
                        m=m+1;
                        jobtype.options{m}=[parameters(rrr).name '="' RunArray(newind).(parameters(rrr).name) '"'];
                        m=m+1;
                    else
                        jobtype.options{m}=[parameters(rrr).name '=' num2str(RunArray(newind).(parameters(rrr).name))];
                        m=m+1;
                    end
                end
            end

            fid2 = fopen([RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'init.hoc'],'w');
            fprintf(fid2, '%s\n', jobtype.options{:});
            grr=cygwin(RunArray(newind).ModelDirectory);
            idx = strfind(grr,'/');
            jobtype.program = grr(idx(end)+1:end);

            fprintf(fid2, '{load_file("./main.hoc")}\n');
            % fprintf(fid2, '{load_file("./%s.hoc")}\n', jobtype.program);
            fclose(fid2);   

            % check version stuff
            system(cygwin(['rm ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'hg_*.out']));
            system(cygwin(['rm ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'ver*.txt']));

            system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory handles.dl  'hg parent --template "{rev}: {desc}\n" > ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl  'vercomment.txt']);
            system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory handles.dl  'hg parent --template "{node}\n" > ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl  'version.txt']);

            [stat, res]=system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory ' ' handles.dl ' hg status']);
            if ~isempty(res)
                system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory ' ' handles.dl ' hg status > ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl  'hg_status.out']);
                system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory ' ' handles.dl ' hg diff > ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl  'hg_diff.out']);
            end

            %system(['cd ' RunArray(ind).ModelDirectory handles.dl  'MYTEST=$(hg status)' handles.dl ' if [ -n "$MYTEST" ]' handles.dl ' then hg status > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'hg_status.out' handles.dl ' fi' handles.dl ' if [ -n "$MYTEST" ]' handles.dl ' then hg diff > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'hg_diff.out' handles.dl ' fi']);

            % zip the runname folder
            tic
            zip([RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName '.zip'],[RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName]);
            toc
            system(['rm -r ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName]);

            mymach=questdlg('Which NSG machine will you use?','NSG Machine','Comet','Stampede','Comet');
            switch mymach
                case 'Comet'
                    CoresPerNode=24;
                case 'Stampede'
                    CoresPerNode=16;
                otherwise
                    CoresPerNode=16;
            end
            % display info to the user
            myzipdir = [RunArray(newind).ModelDirectory sl 'jobscripts'];
            system([handles.general.explorer ' ' myzipdir]);
            msgbox({[RunArray(newind).RunName ' instructions:'], 'Log onto nsgportal', ...
                    ['Zip file to upload: "' RunArray(newind).RunName '.zip"'], ...
                    ['Tool: NEURON7.3 on ' mymach], ...
                    'Parameters:', ...
                    ['Max hours to run: ' num2str(RunArray(newind).JobHours)], ...
                     'Main input file to run: "init.hoc"', ...
                    ['# nodes: ' num2str(ceil(RunArray(newind).NumProcessors/CoresPerNode))], ...
                     ['Cores per node: ' num2str(CoresPerNode)], ...
                    ''})


        else
            handles.curses=[];handles.curses.ind= newind; guidata(handles.list_view,handles)
            if r==1
                partofbatch=0;
            else
                partofbatch=1;
            end
            outstat(r)=jobscript(hObject,handles,partofbatch,partOfBatchSquared); % Warning = add time shift property to the machines structure. For ranger (2), it should be -2 hours
            handles=guidata(hObject);
        end
    end

    if ~strcmp(RunArray(newind).Machine, 'NSG') && ~strcmp(RunArray(newind).Machine, deblank(myname)) && ~strcmp(RunArray(newind).Machine, deblank(getenv('computername'))) && partOfBatchSquared==0        
        if ~isempty(outstat) && sum(outstat)==length(valarray)
            msgbox([RunName{runset} ': Your job batch has been submitted'],'Runs Submitted')
        else
            if isempty(outstat)
                outstat=0;
            end
            problem(runset)=length(valarray)-sum(outstat);
            msgbox([RunName{runset} ': There was a problem with ' num2str(problem) ' of the ' num2str(length(valarray)) ' job submissions. The remaining jobs were submitted.'],'Runs Not Submitted')
        end
    elseif partOfBatchSquared==1
            if isempty(outstat)
                outstat=0;
            end
            problem(runset)=length(valarray)-sum(outstat);
    end

    x = mystrfind(get(handles.list_view,'String'),'Not Ran');
    set(handles.list_view,'Value',x)
    list_view_Callback(handles.list_view, [], handles)

    saveRuns(handles)

usesamehours=0;

catch ME
    handleME(ME)
end



function menuitem_executerunrange_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function will allow the user to execute a batch of runs based on the
% currently selected run. One parameter can be specified to be altered,
% with the values to be ran specified as well. Then a batch of runs with
% the same root name will all be created and executed or submitted to a 
% queue.

global cygpath cygpathcd cygpathcd mypath RunArray sl pswd pswdmach usesamehours
try
    
% get the property to vary and the range/steps over which to vary it
varyline = inputdlg('Property = [min:step:max]', 'Parameter to vary');
if isempty(varyline)
    return;
end
idx = strfind(varyline{1},'=');
propstr = varyline{1}(1:idx-1);
valarray = eval(varyline{1}(idx+1:end));


if ispc
    mystr='.exe';
else
    mystr='';
end
m=findstr(handles.general.neuron,' ');
if ~isempty(m)
    nrnpath=handles.general.neuron(1:m(1)-1);
else
    nrnpath=handles.general.neuron;
end
if exist([strrep(nrnpath,'.exe','') mystr],'file')==0
    msgbox({'Please update the location of NEURON''s','nrniv executable in the General Settings first.'})
    return
end
[~, myname]=system('hostname');

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

[~, statresult]=system(['sh $HOME/.bashrc ' handles.dl ' cd ' myrepos(q).dir handles.dl ' hg status']); % RunArray(ind).ModelDirectory

tmpdata=get(handles.tbl_runs,'Data');
for runset=1:size(handles.indices,1)
    myrow = handles.indices(runset,1);
    RunName(runset) = tmpdata(myrow,1);
end

msgbox({'The following runs will be expanded:',RunName{:},'Using the range command of:',varyline{1}});

ind = find(strcmp(RunName{1},{RunArray.RunName})==1, 1 );
updateflag=1;
if ~isempty(statresult) && strcmp(statresult(1:end-1),'sh: $HOME/.bashrc: No such file or directory')==0 && strcmp(statresult(1:end-1),'/usr/bin/sh: $HOME/.bashrc: No such file or directory')==0
    changes=regexp(statresult,'\n','split');
    myfiles={};
    for r=1:length(changes)
        if ~isempty(changes{r}) && strcmp(changes{r}(1),'?')==0 &&  isempty(strfind(changes{r},'No such file or directory')) % strcmp(changes{r}(1:min(44,end)),'sh: $HOME/.bashrc: No such file or directory')==0
            myfiles{length(myfiles)+1}=changes{r}; %#ok<AGROW>
        end
    end
    if ~isempty(myfiles) %gohere
        if strcmp(RunArray(ind).Machine, deblank(myname)) || strcmp(RunArray(ind).Machine, deblank(getenv('computername')))
            btn=questdlg({'There are uncommitted changes to the following files:',myfiles{:},'Update code version and lose changes or run with uncommitted changes or cancel run?'},'Overwrite Changes?','Overwrite','Run Uncommitted Code','Cancel Run','Cancel Run');
            if strcmp('Cancel Run',btn)
                return
            elseif strcmp('Run Uncommitted Code',btn)
                updateflag=0;
            end
        else
            btn=questdlg({'There are uncommitted changes to the following files:',myfiles{:},'If you submit this run, the changes will be lost. Continue?'},'Overwrite Changes?','Overwrite','Cancel Run','Cancel Run');
            if strcmp('Cancel Run',btn)
                return
            end
        end

    end
end

problem=0;
partOfBatchSquared=0;
usesamehours=0;
for runset=1:length(RunName)
    if runset>1
        partOfBatchSquared=1;
    end
    handles.curses.ind = find(strcmp(RunName{runset},{RunArray.RunName})==1, 1 );  % 1= 1st spike, 2= 2nd spike, 0= avg spike time, -1= 1st ISI
    ind = handles.curses.ind;
    myprops=properties(RunArray(ind));

    if ~isempty(RunArray(ind).ExecutedBy)
        msgbox(['The run ' RunName{runset} ' has already been executed.'])
        continue
    elseif isempty(ind)
        msgbox(['The run ' RunName{runset} ' no longer exists.'])
        continue
    elseif sum(strcmp(propstr,myprops))==0
        msgbox(['''' propstr ''' is not a valid RunArray property for ' RunName{runset}])
        continue
    end

    if updateflag==1 && runset==1
        system(['sh $HOME/.bashrc ' handles.dl  'cd ' RunArray(ind).ModelDirectory handles.dl ' hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') ]); % Update the local Mercurial version
        compilestr=['cd ' RunArray(ind).ModelDirectory handles.dl ' ' handles.general.compilenrn]; %handles.compilenrn];
        system(compilestr);
    end


    [~, myname]=system('hostname');


    parameters=handles.parameters;%load([mypath sl 'data' sl 'parameters.mat'],'parameters')
    outstat=[];

    maxnum=0;
    similaridx=searchRuns('RunName',[RunArray(ind).RunName '_'],0,'*');
    for r=1:length(similaridx)
        idxt=strfind(RunArray(similaridx(r)).RunName,'_');
        if ~isempty(idxt & sum(isstrprop(RunArray(similaridx(r)).RunName(idxt(end)+1:end), 'digit'))==length(RunArray(similaridx(r)).RunName(idxt(end)+1:end)))
            maxnum=max(maxnum,str2num(RunArray(similaridx(r)).RunName(idxt(end)+1:end)));
        end
    end

    %maxnum=length(previdx);

    for r=1:length(valarray)
        newind = length(RunArray)+1;
        flds = fieldnames(RunArray);
        UID=getUID;
        RunArray(newind) = SimRun([RunArray(ind).RunName '_' sprintf('%02.0f', r+maxnum)], RunArray(ind).ModelDirectory,UID);  % unique id as third arg? system('cscript //NoLogo uuid.vbs')

        for g=1:length(flds)
            if strcmp(flds{g},'UID')==0 && strcmp(flds{g},'RunName')==0 
                RunArray(newind).(flds{g}) = RunArray(ind).(flds{g});
            end
        end

        %RunArray(newind).RunName = [RunArray(ind).RunName '_' sprintf('%02.0f', r)];
        RunArray(newind).(propstr) = valarray(r);

        if strcmp(RunArray(newind).Machine, deblank(myname)) || strcmp(RunArray(newind).Machine, deblank(getenv('computername')))
            g=1;
            for k=1:length(parameters)
                if parameters(k).file==1 && strcmp(parameters(r).name,'JobNumber')==0
                    if strcmp(parameters(k).type,'string')==1
                        jobtype.options{g}=['strdef ' parameters(k).name];
                        g=g+1;
                        jobtype.options{g}=[parameters(k).name '="' RunArray(newind).(parameters(k).name) '"'];
                        g=g+1;
                    else
                        jobtype.options{g}=[parameters(k).name '=' num2str(RunArray(newind).(parameters(k).name))];
                        g=g+1;
                    end
                end
            end

            fid2 = fopen([RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName '_run.hoc'],'w');
            fprintf(fid2, '%s\n', jobtype.options{:});
            grr=cygwin(RunArray(newind).ModelDirectory);
            idx = strfind(grr,'/');
            jobtype.program = grr(idx(end)+1:end);

            fprintf(fid2, '{load_file("./main.hoc")}\n');
            % fprintf(fid2, '{load_file("./%s.hoc")}\n', jobtype.program);
            fclose(fid2);

            if handles.general.mpi==1
                cmdstr=['cd ' RunArray(newind).ModelDirectory handles.dl ' mpiexec -n ' num2str(RunArray(newind).NumProcessors) ...
                    ' ' handles.general.neuron ' -mpi   .' sl 'jobscripts' sl RunArray(newind).RunName '_run.hoc'];
            else
                cmdstr=['cd ' RunArray(newind).ModelDirectory handles.dl ' ' handles.general.neuron ' .' sl 'jobscripts' sl RunArray(newind).RunName '_run.hoc'];
            end

            %mydisp(cmdstr,handles)
            [~, results] = system(cmdstr);
            mydisp(results,handles)
        elseif strcmp(RunArray(newind).Machine, 'NSG') %comehere        
            RunArray(newind).CatFlag=0;
            % in the jobscripts folder, make a runname folder
            %sl='/'; msgbox('backslash for mkdir and repos slash for fopen...')
            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName]);

            % in that folder, place all the files in the root repos directory
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl]));
            % make a fresh results folder
            % copy in the setupfiles, cells, stimulation, x86_64 folders
            % make a new connections folder and upload the specific files necessary
            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'results']);
            f2=fopen([RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'results' sl 'log.log'],'w');
            fclose(f2);
            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'datasets']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(newind).ConnData) '.dat ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'datasets' sl]));
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'datasets' sl 'syndata_' num2str(RunArray(newind).SynData) '.dat ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'datasets' sl]));
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'datasets' sl 'cellnumbers_' num2str(RunArray(newind).NumData) '.dat ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'datasets' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'setupfiles']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'setupfiles' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'setupfiles' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'connectivity']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'connectivity' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'connectivity' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'cells']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'cells' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'cells' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'cells' sl 'axondists']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'cells' sl 'axondists' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'cells' sl 'axondists' sl]));

            system(['mkdir ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'stimulation']);
            system(cygwin(['cp ' RunArray(newind).ModelDirectory sl 'stimulation' sl '*.* ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'stimulation' sl]));

            % make the run.hoc file and save it within the main folder
            parameters=handles.parameters;%load([mypath sl 'data' sl 'parameters.mat'],'parameters');
            jobtype.options = {};
            m=1;
            for rrr=1:length(parameters)
                if parameters(rrr).file==1 && strcmp(parameters(rrr).name,'JobNumber')==0
                    if strcmp(parameters(rrr).type,'string')==1
                        jobtype.options{m}=['strdef ' parameters(rrr).name];
                        m=m+1;
                        jobtype.options{m}=[parameters(rrr).name '="' RunArray(newind).(parameters(rrr).name) '"'];
                        m=m+1;
                    else
                        jobtype.options{m}=[parameters(rrr).name '=' num2str(RunArray(newind).(parameters(rrr).name))];
                        m=m+1;
                    end
                end
            end

            fid2 = fopen([RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'init.hoc'],'w');
            fprintf(fid2, '%s\n', jobtype.options{:});
            grr=cygwin(RunArray(newind).ModelDirectory);
            idx = strfind(grr,'/');
            jobtype.program = grr(idx(end)+1:end);

            fprintf(fid2, '{load_file("./main.hoc")}\n');
            % fprintf(fid2, '{load_file("./%s.hoc")}\n', jobtype.program);
            fclose(fid2);   

            % check version stuff
            system(cygwin(['rm ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'hg_*.out']));
            system(cygwin(['rm ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl 'ver*.txt']));

            system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory handles.dl  'hg parent --template "{rev}: {desc}\n" > ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl  'vercomment.txt']);
            system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory handles.dl  'hg parent --template "{node}\n" > ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl  'version.txt']);

            [stat, res]=system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory ' ' handles.dl ' hg status']);
            if ~isempty(res)
                system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory ' ' handles.dl ' hg status > ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl  'hg_status.out']);
                system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(newind).ModelDirectory ' ' handles.dl ' hg diff > ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName sl  'hg_diff.out']);
            end

            %system(['cd ' RunArray(ind).ModelDirectory handles.dl  'MYTEST=$(hg status)' handles.dl ' if [ -n "$MYTEST" ]' handles.dl ' then hg status > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'hg_status.out' handles.dl ' fi' handles.dl ' if [ -n "$MYTEST" ]' handles.dl ' then hg diff > ' RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName sl  'hg_diff.out' handles.dl ' fi']);

            % zip the runname folder
            tic
            zip([RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName '.zip'],[RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName]);
            toc
            system(['rm -r ' RunArray(newind).ModelDirectory sl 'jobscripts' sl RunArray(newind).RunName]);

            mymach=questdlg('Which NSG machine will you use?','NSG Machine','Comet','Stampede','Comet');
            switch mymach
                case 'Comet'
                    CoresPerNode=24;
                case 'Stampede'
                    CoresPerNode=16;
                otherwise
                    CoresPerNode=16;
            end
            % display info to the user
            myzipdir = [RunArray(newind).ModelDirectory sl 'jobscripts'];
            system([handles.general.explorer ' ' myzipdir]);
            msgbox({[RunArray(newind).RunName ' instructions:'], 'Log onto nsgportal', ...
                    ['Zip file to upload: "' RunArray(newind).RunName '.zip"'], ...
                    ['Tool: NEURON7.3 on ' mymach], ...
                    'Parameters:', ...
                    ['Max hours to run: ' num2str(RunArray(ind).JobHours)], ...
                     'Main input file to run: "init.hoc"', ...
                    ['# nodes: ' num2str(ceil(RunArray(newind).NumProcessors/CoresPerNode))], ...
                     ['Cores per node: ' num2str(CoresPerNode)], ...
                    ''})


        else
            handles.curses=[];handles.curses.ind= newind; guidata(handles.list_view,handles)
            if r==1
                partofbatch=0;
            else
                partofbatch=1;
            end
            outstat(r)=jobscript(hObject,handles,partofbatch,partOfBatchSquared); % Warning = add time shift property to the machines structure. For ranger (2), it should be -2 hours
            handles=guidata(hObject);
        end
    end

    if ~strcmp(RunArray(ind).Machine, 'NSG') && ~strcmp(RunArray(ind).Machine, deblank(myname)) && ~strcmp(RunArray(ind).Machine, deblank(getenv('computername'))) && partOfBatchSquared==0        
        if ~isempty(outstat) && sum(outstat)==length(valarray)
            msgbox([RunName{runset} ': Your job batch has been submitted'],'Runs Submitted')
        else
            if isempty(outstat)
                outstat=0;
            end
            problem(runset)=length(valarray)-sum(outstat);
            msgbox([RunName{runset} ': There was a problem with ' num2str(problem) ' of the ' num2str(length(valarray)) ' job submissions. The remaining jobs were submitted.'],'Runs Not Submitted')
        end
    elseif partOfBatchSquared==1
            if isempty(outstat)
                outstat=0;
            end
            problem(runset)=length(valarray)-sum(outstat);
    end

    RunArray(ind)=[];
    x = mystrfind(get(handles.list_view,'String'),'Not Ran');
    set(handles.list_view,'Value',x)
    list_view_Callback(handles.list_view, [], handles)

    saveRuns(handles)
end
usesamehours=0;
if strcmp(RunArray(ind).Machine, deblank(myname)) || strcmp(RunArray(ind).Machine, deblank(getenv('computername'))) 
    msgbox('Finished all the runs!')
elseif partOfBatchSquared==1
    if sum(problem)>0
        msgbox([RunName{runset} ': There was a problem with ' num2str(sum(problem)) ' of the ' num2str(length(valarray)) ' job submissions. The remaining jobs were submitted.'],'Runs Not Submitted')    
    else
        msgbox(['Your job batches have been submitted'],'Runs Submitted')
    end
end
catch ME
    handleME(ME)
end

function btn_PDF_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function will create a PDF report of the currently selected,
% executed run. It will give the parameters used, and incorporate any jpg
% outputs into the PDF

makepdf(handles)


% --------------------------------------------------------------------
function menuitem_compare_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function compares two selected runs, pointing out which parameters
% were different between the two, and showing each spikeraster, etc, in a
% PDF report

global cygpath cygpathcd mypath RunArray sl

if isdeployed
    msgbox('This functionality not yet implemented for deployed applications.')
else
    comp2Runs(handles)
end

return

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

try
tmpdata=get(handles.tbl_runs,'Data');
handles.curses.indices = [];
for r=1:size(handles.indices,1)
    myrow = handles.indices(r,1);
    RunName = tmpdata(myrow,1);
    handles.curses.indices(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1 ); % delete min for real data
end

fields = fieldnames(RunArray(handles.curses.indices(1)));
fieldlist = {'RunName','ModelVersion','ExecutionDate','NEURONVersion','RemoteDirectory','ModelDirectory','RandomSeeds','LongitudinalLength', ...
             'LayerHeights','SpatialResolution','TemporalResolution','NumCellsRecorded','Positioning','PercentCellDeath','PercentAxonSprouting', ...
             'PrintVoltage','PrintTerminal','PrintConnDetails','PrintCellPositions','PrintConnSummary','RunTime'};
for r=1:length(fieldlist)         
    fields(strcmp(fields,fieldlist{r})==1) = [];
end
fieldsame = [];
fielddiff = [];

for f = 1:length(fields)
    myvals=repmat({''},length(handles.curses.indices),1);
    %test=[];
    for r = 1:length(handles.curses.indices)
        myvals{r} = RunArray(handles.curses.indices(r)).(fields{f});
    end
    if ischar(myvals{1})
        test = length(myvals) == sum(strcmp(myvals,myvals{1}));
    else
        test = length(myvals) == sum(myvals{1} == [myvals{:}]);
    end
    if test
        fieldsame(length(fieldsame)+1)=f; %#ok<AGROW>
    else
        fielddiff(length(fielddiff)+1)=f; %#ok<AGROW>
    end
end

ConnData=zeros(length(handles.curses.indices),1);
SynData=zeros(length(handles.curses.indices),1);

for r = 1:length(handles.curses.indices)
    ConnData(r) = RunArray(handles.curses.indices(r)).ConnData;
    try
        SynData(r) = str2double(RunArray(handles.curses.indices(r)).SynData);
        RunArray(handles.curses.indices(r)).SynData = str2double(RunArray(handles.curses.indices(r)).SynData);
    catch %#ok<CTCH>
        SynData(r) = RunArray(handles.curses.indices(r)).SynData;
    end
end

ConnData = unique(ConnData);
SynData = unique(SynData);

load([myrepos(q).dir sl 'datasets' sl 'conns.mat']) %% new
load([myrepos(q).dir sl 'datasets' sl 'syns.mat']) %% new


cidx = zeros(length(ConnData),1);
sidx = zeros(length(SynData),1);

for x=1:length(ConnData)
    cidx(x) = find([conns(:).num]==ConnData(x));
end

for x=1:length(SynData)
    sidx(x) = find([syns(:).num]==SynData(x));
end

ConnString=repmat({''},length(cidx),1);
SynString=repmat({''},length(sidx),1);
for x=1:length(cidx)
    ConnString{x} = [num2str(conns(cidx(x)).num) ': ' conns(cidx(x)).comments];
end

for x=1:length(sidx)
    SynString{x} = [num2str(syns(sidx(x)).num) ': ' syns(sidx(x)).comments{:}];
end

ind = handles.curses.indices(1);
myrespath = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName];

rname = RunArray(ind).RunName;
filenames={};

%%%% PAGE 0
if length(sidx)>1
    idx=length(filenames)+1;

    h=figure;
    set(h,'Units','inches','Color','w','Visible','off')
    figpos=get(h,'Position');
    set(h,'Position',[figpos(1) figpos(2) 11 8.5])
    ha=axes('Position',[0.05 0.5 0.9 0.45]); %#ok<NASGU>

    synresults=zeros(length(sidx),1);
    for x=1:length(sidx)
        synresults(x) = loadsyns(syns(sidx(x)).num);
    end

    postcells = fieldnames(synresults);

    for y=length(postcells):-1:1
        evalstr= 'synresults(1).(postcells{y})';
        for x=2:length(sidx)
            evalstr = [evalstr ', synresults(' num2str(x) ').(postcells{y})']; %#ok<AGROW>
        end
        fl = 0;
        eval(['if isequal(' evalstr '), fl=1; end']);
        if fl==1
            synresults = rmfield(synresults, postcells{y});
            continue
        end

        gs = [];
        gstr=[];
        for x=1:length(sidx)
            gs(x).precells = sort(fieldnames(synresults(x).(postcells{y})));
            gstr = [gstr; gs(x).precells]; %#ok<AGROW>
        end
        gstr=sort(unique(gstr));

        missingcells=[];
        for x=1:length(sidx)
            missingcells = [missingcells; setdiff(gstr,gs(x).precells)]; %#ok<AGROW>
        end

        existingcells = setdiff(gstr, missingcells);

        for z=length(existingcells):-1:1
            evalstr= 'synresults(1).(postcells{y}).(existingcells{z})';
            for x=2:length(sidx)
                evalstr = [evalstr ',  synresults(' num2str(x) ').(postcells{y}).(existingcells{z})']; %#ok<AGROW>
            end
            fl = 0;
            eval(['if isequal(' evalstr '), fl=1; end']);
            if fl==1
                for x=1:length(sidx)
                    synresults(x).(postcells{y}) = rmfield(synresults(x).(postcells{y}), existingcells{z});
                end
                continue
            end
        end
    end

    postcells = fieldnames(synresults);

    headstr={};
    headstr{1}='                                                Synapse Differences                                                ';
    headstr{2}=sprintf('%3s | %16s | %16s | %16s | %6s | %5s | %5s | %3s | %3s |', 'Set', 'Precell', 'Postcell', 'Secname', 'Secpos','Tau1','Tau2','e');

    for y=1:length(postcells)
        for x=1:length(sidx)
            precells = fieldnames(synresults(x).(postcells{y}));
            for z=1:length(precells)
                for sy=1:length(synresults(x).(postcells{y}).(precells{z}).syns)
                    headstr{length(headstr)+1}=sprintf(' %2d | %16s | %16s | %16s |  %3.1f   | %5.2f | %5.2f | %3d |', syns(sidx(x)).num, precells{z}, postcells{y}, synresults(x).(postcells{y}).(precells{z}).syns(sy).secname, ...
                        synresults(x).(postcells{y}).(precells{z}).syns(sy).secpos,synresults(x).(postcells{y}).(precells{z}).syns(sy).tau1, ...
                        synresults(x).(postcells{y}).(precells{z}).syns(sy).tau2,synresults(x).(postcells{y}).(precells{z}).syns(sy).e); %#ok<AGROW>
                end
            end
        end
    end

    text(0, 1, headstr,'Interpreter','none','VerticalAlignment','top','FontName','FixedWidth')
    axis off
    set(h,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait')
    print(h,'-dpdf','-r600',[myrespath sl rname '_Comparison_' sprintf('%02g',idx)])
    close(h)
    filenames{idx}=[myrespath sl rname '_Comparison_' sprintf('%02g',idx)];
end

%%%% PAGE 1
idx=length(filenames)+1;

h=figure;
set(h,'Units','inches','Color','w','Visible','off')
figpos=get(h,'Position');
set(h,'Position',[figpos(1) figpos(2) 11 8.5])
ha=axes('Position',[0.05 0.5 0.9 0.45]); %#ok<NASGU>

strpropsame=repmat({''},length(fieldsame),1);
for r=1:length(fieldsame)
    if isnumeric(RunArray(ind).(fields{fieldsame(r)}))
        strpropsame{r}=[fields{fieldsame(r)} ' = ' num2str(RunArray(ind).(fields{fieldsame(r)}))];
    else
        strpropsame{r}=[fields{fieldsame(r)} ' = ' RunArray(ind).(fields{fieldsame(r)})];
    end
end

strpropdiff=repmat({''},length(fielddiff),1);
for r=1:length(fielddiff)
    strpropdiff{r}=[sprintf('%-20s',fields{fielddiff(r)}) ' = ' ];
    if isnumeric(RunArray(ind).(fields{fielddiff(r)}))
        for z = 1:length(handles.curses.indices)
            strpropdiff{r}=[strpropdiff{r} sprintf('%27s',num2str(RunArray(handles.curses.indices(z)).(fields{fielddiff(r)}))) ' |'];
        end
    else
        for z = 1:length(handles.curses.indices)
            mystr = RunArray(handles.curses.indices(z)).(fields{fielddiff(r)});
            strpropdiff{r}=[strpropdiff{r} sprintf('%27s',mystr(1:min(26,end))) ' |'];
        end
    end
end

namestr=sprintf('%23s',' ');
for z = 1:length(handles.curses.indices)
    namestr=[namestr sprintf('%20s', RunArray(handles.curses.indices(z)).RunName) '        |']; %#ok<AGROW>
end

strpropleft = [namestr strpropdiff ' ' 'Connection Sets in Use:' ConnString  ' ' 'Synapse Sets in Use:' SynString  ' ' strpropsame];

text(0, 1, [namestr strpropdiff],'Interpreter','none','VerticalAlignment','top','FontName','FixedWidth')
text(0, 1-(length(strpropdiff)+1)*.042, [' ' 'Connection Sets in Use:' ConnString  ' ' 'Synapse Sets in Use:' SynString],'Interpreter','none','VerticalAlignment','top','FontName','FixedWidth')
text(0.5, 1-(length(strpropdiff)+1)*.042, [' ' strpropsame],'Interpreter','none','VerticalAlignment','top','FontName','FixedWidth')

%axis image
axis off

hb = axes('Position',[0.05 0.4 0.9 0.1]);
titlestr='';
connstr='';
synstr='';
for z=1:length(handles.curses.indices)
    titlestr = [titlestr '|    ' sprintf('%27s',RunArray(handles.curses.indices(z)).RunName) '    |']; %#ok<AGROW>
    connstr = [connstr '|    ' sprintf('%27s',[num2str(conns(RunArray(handles.curses.indices(z)).ConnData).num) ': ' conns(RunArray(handles.curses.indices(z)).ConnData).comments]) '    |']; %#ok<AGROW>
    synstr = [synstr '|    ' sprintf('%27s',[num2str(syns(RunArray(handles.curses.indices(z)).SynData).num) ': ' syns(RunArray(handles.curses.indices(z)).SynData).comments{:}]) '    |']; %#ok<AGROW>
end

strs{1} = ['Name: ' titlestr '      '];
strs{2} = ['Conn: ' connstr '      '];
strs{3} = ['Syns: ' synstr '      '];

text(.5, 1, strs,'Interpreter','none','HorizontalAlignment','center','VerticalAlignment','top','FontName','FixedWidth')
axis off

hc = axes('Position',[0.05 0.05 0.9 0.35]); %#ok<NASGU>

catraster=[];
for z=1:length(handles.curses.indices)
    myrespath = [RunArray(handles.curses.indices(z)).ModelDirectory sl 'results' sl RunArray(handles.curses.indices(z)).RunName];
    if exist([myrespath sl RunArray(handles.curses.indices(z)).RunName '_Spike_Raster.jpg'],'file')>0
        raster = imread([myrespath sl RunArray(handles.curses.indices(z)).RunName '_Spike_Raster.jpg'], 'jpg');
        catraster = [catraster raster]; %#ok<AGROW>
    end
end

image(catraster)
% axis image
axis off

set(h,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','landscape')
print(h,'-dpdf','-r600',[myrespath sl rname '_Comparison_' sprintf('%02g',idx)])
close(h)
filenames{idx}=[myrespath sl rname '_Comparison_' sprintf('%02g',idx)];


[h2 chartstr] = plot_fftmult(hObject,handles,filenames); %#ok<NASGU,ASGLU>
catch ME
    handleME(ME)
end

function logsave(ind, figtype, figformat, datetimenow, figpath, fullfigname, runname)
% This function records the outputs that have been saved into the results
% folder for each run, so that the list of them can be displayed in the
% SimTracker

global cygpath cygpathcd mypath savedfigs
try
i=length(savedfigs)+1;

savedfigs(i).ind=ind;
savedfigs(i).figtype=figtype;
savedfigs(i).figformat=figformat;
savedfigs(i).datetimenow=datestr(datetimenow,'ddmmmyy HH:MM');
savedfigs(i).figpath=figpath;
savedfigs(i).fullfigname=fullfigname;
savedfigs(i).runname=runname;
catch ME
    handleME(ME)
end

function synresults = loadsyns(sx)

try
q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')


% This function ...
msgbox('What does this function do?')
prop = {'precell','secname', 'secpos','tau1','tau2','e'};
fid = fopen([myrepos(q).dir sl 'datasets' sl 'syndata_' num2str(sx) '.dat']);
numlines = textscan(fid,'%d\n',1);
propstr=' %f %f %f %f %f %f %f';
c = textscan(fid,['%s %s %s' propstr '\n']);
st = fclose(fid);

synresults=[];

if size(c{1,1},1)>0
    for r=1:numlines{1,1}
        postcell = c{1,1}{r};
        precell = c{1,2}{r};
        if ~isfield(synresults,postcell)
            synresults.(postcell)=[];
        end
        if ~isfield(synresults.(postcell), precell)
            synresults.(postcell).(precell)=[];
            synresults.(postcell).(precell).syns=[];
            n = 1;
        else
            n = length(synresults.(postcell).(precell).syns)+1;
        end
        synresults.(postcell).(precell).syns(n).secname = c{1,3}{r};
        for z = 3:length(prop)
            synresults.(postcell).(precell).syns(n).(prop{z}) = c{1,z+1}(r);
        end
    end
end
catch ME
    handleME(ME)
end


 


% --------------------------------------------------------------------
function menuitem_debugrun_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function prints to the command line the text necessary to run a
% debug session for a given run

menuitem_executerun_Callback(handles.menuitem_debugrun, eventdata, handles)


% --- Executes on selection change in txt_error.
function txt_error_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function saves the error data to the selected run when the error
% value is updated from the popupmenu
global cygpath cygpathcd mypath RunArray

try
% Hints: contents = cellstr(get(hObject,'String')) returns txt_error contents as cell array
%        contents{get(hObject,'Value')} returns selected item from txt_error
ind = handles.curses.ind;

contents = cellstr(get(hObject,'String'));

RunArray(ind).Errors = contents{get(hObject,'Value')};
saveRuns(handles)
catch ME
    handleME(ME)
end

% --- Executes during object creation, after setting all properties.
function txt_error_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to txt_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_RunComments_Callback(hObject, eventdata, handles) %#ok<DEFNU>
global cygpath cygpathcd mypath RunArray
% hObject    handle to txt_RunComments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_RunComments as text
%        str2double(get(hObject,'String')) returns contents of txt_RunComments as a double

if strcmp(get(handles.btn_saverun,'Visible'),'off') || strcmp(get(handles.btn_saverun,'Visible'),'Off')
    ind = handles.curses.ind;

    RunArray(ind).RunComments=get(hObject,'String');
    saveRuns(handles)
end


% --- Executes on selection change in list_groups.
function list_groups_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function adds or subtracts group labels from the selected run.

global cygpath cygpathcd mypath RunArray

try
ind = handles.curses.ind;

if isempty(ind)
    return
end


contents = cellstr(get(handles.list_groups,'String'));
groupcell = contents(get(handles.list_groups,'Value'));

groupstr = '';
for r = 1:length(groupcell)
    groupstr = [groupstr groupcell{r} ',']; %#ok<AGROW>
end

RunArray(ind).Groups = groupstr(1:end-1);
set(handles.txt_group,'String',groupstr(1:end-1));
saveRuns(handles)
catch ME
    handleME(ME)
end

% --- Executes during object creation, after setting all properties.
function list_groups_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to list_groups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_tools_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuitem_errorlist_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function allows the user to edit the list of possible errors.
global cygpath cygpathcd mypath sl
try
h=errorset;
uiwait(h);

if exist([mypath sl 'data' sl 'MyOrganizer.mat'],'file')==2
    load([mypath sl 'data' sl 'MyOrganizer.mat']);
else
    msgbox('Can''t find MyOrganizer file');
end

if exist('myerrors','var')==1
    handles.myerrors=myerrors; % myerrors previously loaded from MyOrganizer.mat
    msgbox('Error list updated');
else
    msgbox('Can''t find myerrors struct');
end

guidata(hObject, handles);

contents=get(handles.txt_error,'String');
val = contents(get(handles.txt_error,'Value'));

set(handles.txt_error,'String',{handles.myerrors(:).errorphrase})

try
    idx = strmatch(val, cellstr(get(handles.txt_error,'String')),'exact');
    set(handles.txt_error,'Value',idx(1))
catch ME %#ok<NASGU>
    contents = get(handles.txt_error,'String');
    contents{length(contents)+1}=val;
    set(handles.txt_error,'String',contents)
    set(handles.txt_error,'Value',length(contents))
    load([mypath sl 'data' sl 'MyOrganizer.mat'],'myerrors','-append')
    r=length(myerrors)+1;
    myerrors(r).category='Unknown';
    myerrors(r).errorphrase=val;
    myerrors(r).description='Unknown';
    save([mypath sl 'data' sl 'MyOrganizer.mat'],'myerrors','-append')


    msgbox('Error value disappeared so added back in here')
end
catch ME
    handleME(ME)
end



% --------------------------------------------------------------------
function menuitem_archive_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function allows the user to archive the selected runs from the
% SimTracker


%menuitem_export_Callback(handles.menuitem_export, eventdata, handles)

global cygpath cygpathcd mypath RunArray sl

try
tmpdata=get(handles.tbl_runs,'Data');
handles.curses.indices = [];
for r=1:size(handles.indices,1)
    myrow = handles.indices(r,1);
    RunName = tmpdata(myrow,1);
    handles.curses.indices(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1 ); % delete min for real data
end

ArchiveArray = RunArray(handles.curses.indices);

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos') 

backupfolder = getbackup(myrepos(q).dir);
set(handles.txt_datalabel,'String',['Current Directory: ' myrepos(q).dir])
pex=get(handles.txt_datalabel,'Extent');
pos=get(handles.txt_datalabel,'Position');
set(handles.txt_datalabel,'Position',[pos(1) pos(2) pex(3) pex(4)]);

backupname=inputdlg('Name the archive:','Name',1,{[myrepos(q).name '_' datestr(now,'yyyymmdd')]});
if isempty(backupname)
    return;
end
d=dir([backupfolder sl backupname{1} '_rundata.mat']);

while ~isempty(d)
    backupname=inputdlg('That name is already taken, please choose a new name:','Name',1,{[myrepos(q).name '_' datestr(now,'yyyymmdd')]});
    d=dir([backupfolder sl backupname{1} '*']);
end    

parameters=handles.parameters;
save([backupfolder sl backupname{1} '_rundata.mat'],'ArchiveArray','parameters','-v7.3');

myfiles={}; %repmat({''},length(ArchiveArray),1);
z=1;
idx2delete=[];
for r=1:length(ArchiveArray)
    if exist([ArchiveArray(r).ModelDirectory sl 'results' sl ArchiveArray(r).RunName],'dir')
        myfiles{z}=[ArchiveArray(r).ModelDirectory sl 'results' sl ArchiveArray(r).RunName];
        idx2delete(z)=handles.curses.indices(r);
        disp(myfiles{z})
        z=z+1;
    end
end

myfiles{z}=[ArchiveArray(r).ModelDirectory sl 'setupfiles' sl '\@SimRun' sl 'SimRun.m'];

%3.85 for 2
%2.45 for 5

ziptime = length(myfiles)*3.85;
zipstr='';
if ziptime>3599
    hs = floor(ziptime/3600);
    ziptime = rem(ziptime,3600);
    zipstr=[zipstr num2str(hs) ' h, '];
end
if ziptime>59
    mins = floor(ziptime/60);
    ziptime = rem(ziptime,60);
    zipstr=[zipstr num2str(mins) ' m, '];
end
zipstr=[zipstr num2str(ziptime) ' s'];


mydisp({'The program will take some time to zip the results into an archive: ',zipstr}',handles)

tic
zip([backupfolder sl backupname{1} '_results.zip'],myfiles);
timetaken = toc;
xx=0;
for r=1:length(myfiles)
   xx = xx+dirsize(myfiles{r});
end

mydisp({['Total size of archived folders: ' num2str(xx) ' bytes'],['Total time taken: ' num2str(timetaken) ' s']},handles)

mydisp(['zipped files: ' num2str(length(myfiles))],handles)

btn=questdlg(['Ready to delete ' num2str(length(idx2delete)) ' archived results?']);
switch btn
    case 'Yes'
        for r=1:length(myfiles)
            system(['rm -r ' myfiles{r}]);
        end
        RunArray(idx2delete)=[];
        handles.curses=[];handles.curses.ind=1; guidata(handles.list_view,handles)
        x = mystrfind(get(handles.list_view,'String'),'All');
        set(handles.list_view,'Value',x)
        list_view_Callback(handles.list_view, [], handles)
        saveRuns(handles)
end
catch ME
    handleME(ME)
end

function x = dirsize(path)
s = dir(path);
name = {s.name};
isdir = [s.isdir] & ~strcmp(name,'.') & ~strcmp(name,'..');
subfolder = strcat(path, filesep(), name(isdir));
x = sum([s(~isdir).bytes cellfun(@dirsize, subfolder)]);

% --------------------------------------------------------------------
function menuitem_backup_Callback(hObject, eventdata, handles, varargin)
% This function allows the user to save/backup all the data currently in
% the SimTracker

global cygpath cygpathcd mypath RunArray sl
try
% hObject    handle to menuitem_backup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% backup options:
% SimTracker Settings
% RunArray data
% results folders
if ~isempty(varargin)
    runsettings = varargin{1}(1);
    rundata = varargin{1}(2);
    results = varargin{1}(3);
    classbackup = varargin{1}{4};
else
    runsettings = 1;
    rundata = 1;
    results = 1;
    classbackup = 1;
end

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
set(handles.txt_datalabel,'String',['Current Directory: ' myrepos(q).dir])
pex=get(handles.txt_datalabel,'Extent');
pos=get(handles.txt_datalabel,'Position');
set(handles.txt_datalabel,'Position',[pos(1) pos(2) pex(3) pex(4)]);

% Backup folder:
backupfolder = getbackup(myrepos(q).dir);
backupname = inputdlg('Name the backup/archive:','Name',1,{[myrepos(q).name '_' datestr(now,'yyyymmdd')]});
remote=0;
% SimTracker settings
escchar='';
if ispc
    escchar='\';
end
if classbackup == 1
    %system(['cp @SimRun' sl 'SimRun.m ' backupfolder sl backupname{1} '_SimRun.m']);
    system(['cp ' myrepos(q).dir sl 'setupfiles' sl escchar '@SimRun' sl 'SimRun.m ' backupfolder sl backupname{1} '_SimRun.m']);
end

if runsettings == 1
    myoutputs=handles.myoutputs; %#ok<NASGU>
    savedfigs=handles.savedfigs; %#ok<NASGU>
    machines=handles.machines; %#ok<NASGU>
    myerrors=handles.myerrors; %#ok<NASGU>
    groups=handles.groups; %#ok<NASGU>
    save([backupfolder sl backupname{1} '_runsettings.mat'],'myoutputs','savedfigs','machines','myerrors','groups','-v7.3');
    if remote==1
        eval(['!scp -r ' backupfolder sl backupname{1} '_runsettings.mat' ' ' remotebackup.username '@' remotebackup.server ':'  remotebackup.dir]);
    end
end

if rundata == 1
    parameters=handles.parameters;
    ArchiveArray=RunArray; %#ok<NASGU>
    save([backupfolder sl backupname{1} '_rundata.mat'],'ArchiveArray','parameters','-v7.3');
    if remote==1
        eval(['!scp -r ' backupfolder sl backupname{1} '_rundata.mat' ' ' remotebackup.username '@' remotebackup.server ':'  remotebackup.dir]);
    end
end

if results == 1
    ziptime = length(dir([myrepos(q).dir sl 'results']))*3.85;
    zipstr='';
    if ziptime>3599
        hs = floor(ziptime/3600);
        ziptime = rem(ziptime,3600);
        zipstr=[zipstr num2str(hs) ' h, '];
    end
    if ziptime>59
        mins = floor(ziptime/60);
        ziptime = rem(ziptime,60);
        zipstr=[zipstr num2str(mins) ' m, '];
    end
    zipstr=[zipstr num2str(ziptime) ' s'];


    mydisp({['The program will take some time to zip the ' num2str(length(dir([myrepos(q).dir sl 'results']))-2) ' results into an archive: '],zipstr,datestr(now)}',handles)
    system(['cp ' myrepos(q).dir sl 'setupfiles' sl escchar '@SimRun' sl 'SimRun.m ' myrepos(q).dir sl 'results' sl 'SimRun.m']);

    tic
    zip([backupfolder sl backupname{1} '_results.zip'], [myrepos(q).dir sl 'results']); 
    timetaken = toc;
    system(['rm ' myrepos(q).dir sl 'results' sl 'SimRun.m']);
    xx = dirsize([myrepos(q).dir sl 'results']);
    mydisp({['Total size of results folder: ' num2str(xx) ' bytes'],['Total time taken: ' num2str(timetaken) ' s']},handles)
    if remote==1
        eval(['!scp -r ' backupfolder sl backupname{1} '_results.zip' ' ' remotebackup.username '@' remotebackup.server ':'  remotebackup.dir]);
    end
end
msgbox('Completed backup')
catch ME
    handleME(ME)
end

% --------------------------------------------------------------------
function menuitem_loaddata_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function allows the user to load in data from a source that they
% specify, either an archive or backup, and they can either append or
% replace the existing data in the SimTracker

global cygpath cygpathcd mypath RunArray sl donotsave

try
% save existing data
saveRuns(handles)
[~, loadname, val] = archive_gui(1);


% loadname=myresults{2};
% val=myresults{3};

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
set(handles.txt_datalabel,'String',['Current Directory: ' myrepos(q).dir])
pex=get(handles.txt_datalabel,'Extent');
pos=get(handles.txt_datalabel,'Position');
set(handles.txt_datalabel,'Position',[pos(1) pos(2) pex(3) pex(4)]);
handles.parameters=switchSimRun({myrepos.dir},myrepos(q).dir);
guidata(hObject, handles); % resave the handles

if isdeployed==0
    for c=length(handles.custmenus):-1:1
        delete(handles.custmenus(c))
        handles.custmenus(c)=[];
    end
    set(handles.menuitem_custom,'Enable','Off')
    mm=dir([mypath sl 'customout' sl '*.m']);
    for m=1:length(mm)
        lblname=strrep(mm(m).name(1:end-2),'_',' ');
        eval(['handles.custmenus(end+1)=uimenu(handles.menuitem_custom,''Label'',''' lblname ''' ,''Callback'',{@' mm(m).name(1:end-2) ',handles});']);
        set(handles.menuitem_custom,'Enable','On')
    end
    mm=dir([myrepos(q).dir sl 'customout' sl '*.m']);
    for m=1:length(mm)
        lblname=strrep(mm(m).name(1:end-2),'_',' ');
        eval(['handles.custmenus(end+1)=uimenu(handles.menuitem_custom,''Label'',''' lblname ''' ,''Callback'',{@' mm(m).name(1:end-2) ',handles});']);
        set(handles.menuitem_custom,'Enable','On')
    end
end
backupfolder = getbackup(myrepos(q).dir);
%gohere
% if ~exist('backupfolder','var')
%     backupfolder=uigetdir(myrepos(q).dir,'Choose Backup Folder');
%     save([mypath sl 'data' sl 'myrepos.mat'],'myrepos','backupfolder','-append')
% end



if val==1
    donotsave=0;
    archiveflag=0;
    archiveview(handles,archiveflag);
    RunArray=[];
    handles.curses=[]; handles.curses.ind=0; guidata(handles.list_view,handles)
    if loadRuns(handles)
        x = mystrfind(get(handles.list_view,'String'),'All');
        set(handles.list_view,'Value',x)
        list_view_Callback(handles.list_view, [], handles)
    else
        x = mystrfind(get(handles.list_view,'String'),'All');
        set(handles.list_view,'Value',x)
        list_view_Callback(handles.list_view, [], handles)
    end
    saveRuns(handles)
elseif val==2 % append
    archiveflag=0;
    archiveview(handles,archiveflag);
    S = load([backupfolder sl loadname '_rundata.mat']);

    % check for overlap
    if ~isempty(RunArray)
        [~, check]=intersect({S.ArchiveArray(:).RunName},{RunArray(:).RunName});
        if ~isempty(check)
            if length(check)==length(S.ArchiveArray)
                msgbox('All of the archived runs are already in SimTracker. They will not be reloaded.')
                return
            else
                msgbox('Some of the archived runs are already in the SimTracker. They will not be reloaded.');
                S.ArchiveArray(check)=[];
            end
        end
    end
    RunArray = [RunArray S.ArchiveArray];
    x = mystrfind(get(handles.list_view,'String'),'All');
    set(handles.list_view,'Value',x)
    list_view_Callback(handles.list_view, [], handles)
    % get results folders
    %unzip([backupfolder sl loadname '_results.zip'], [myrepos(q).dir sl 'results' sl])
    mkdir([myrepos(q).dir sl 'tmp' sl])
    unzip([backupfolder sl loadname '_results.zip'], [myrepos(q).dir sl 'tmp' sl])
    if isempty(dir([myrepos(q).dir sl 'tmp' sl 'results']))
        d = dir([myrepos(q).dir sl 'tmp']);
        for zz=3:length(d)
            if d(zz).isdir
                 copyfile([myrepos(q).dir sl 'tmp' sl d(zz).name],[myrepos(q).dir sl 'results' sl d(zz).name]);
                 rmdir([myrepos(q).dir sl 'tmp' sl d(zz).name], 's')
            else
                delete([myrepos(q).dir sl 'tmp' sl d(zz).name])
            end
        end
    else
        d = dir([myrepos(q).dir sl 'tmp' sl 'results']);
        for zz=3:length(d)
            if d(zz).isdir
                 copyfile([myrepos(q).dir sl 'tmp' sl 'results' sl d(zz).name],[myrepos(q).dir sl 'results' sl d(zz).name]);
                 rmdir([myrepos(q).dir sl 'tmp' sl 'results' sl d(zz).name], 's')
            else
                delete([myrepos(q).dir sl 'tmp' sl 'results' sl d(zz).name])
            end
        end
    end
    if exist([myrepos(q).dir sl 'tmp' sl 'results'],'dir')
        rmdir([myrepos(q).dir sl 'tmp' sl 'results'],'s')
    end
    rmdir([myrepos(q).dir sl 'tmp' sl],'s')
    saveRuns(handles)



    % we should unzip it to a temp folder, test to see if any runs already
    % exist in results folder, then copy over only those that don't exist
    % and delete the tmp folder
elseif val==3
    donotsave=1;
    RunArray=[]; %#ok<NASGU>
    for r=1:length(myrepos)
        myrepos(r).current=0;
    end
    save([mypath sl 'data' sl 'myrepos.mat'],'myrepos','-append')
    archiveflag=1;
    archiveview(handles,archiveflag);
    S = load([backupfolder sl loadname '_rundata.mat']);


    RunArray = S.ArchiveArray;
    x = mystrfind(get(handles.list_view,'String'),'All');
    set(handles.list_view,'Value',x)
    list_view_Callback(handles.list_view, 1, handles) %gobackhere
end


% if ~isempty(RunArray)
%     btn=questdlg('Append data to current data or switch (archive current data and load this data)?','Append','Switch','Switch');
%     switch btn
%         case 'Switch'
%             % archive data
%             menuitem_backup_Callback(handles.menuitem_backup, [], handles, [0 1 1])
%             % clear runarray and results
%             RunArray=[];
%             system('cd myrepos(q).dir/results/;rm%% -r ./*');
%     end
% end


catch ME
    handleME(ME)
end




function archiveview(handles,archiveflag)
% This function alters the look of the SimTracker for viewing archives,
% so that nothing can be changed in the data

try
menulist = {'batchupload','uploadrun','designrun','copyrun','editrun','deleterun','executerun','jobfile','executerunrange','debugrun','update','compare'}; % disable menu items
btnlist = {'generate','PDF'};

if archiveflag==1
    cmdstr='off';
else
    cmdstr='on';
end

for r=1:length(menulist)
    set(handles.(['menuitem_' menulist{r}]),'Enable',cmdstr)
end

for r=1:length(btnlist)
    set(handles.(['btn_' btnlist{r}]),'Enable',cmdstr)
end
catch ME
    handleME(ME)
end

% --------------------------------------------------------------------
function menuitem_machines_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function allows the user to update the list of supercomputers
global cygpath cygpathcd mypath sl
try
h=machineset;
uiwait(h);

if exist([mypath sl 'data' sl 'MyOrganizer.mat'],'file')==2
    load([mypath sl 'data' sl 'MyOrganizer.mat']);
else
    msgbox('Can''t find MyOrganizer file');
end

if exist('machines','var')==1
    handles.machines=machines; % machines previously loaded from MyOrganizer.mat
    msgbox('Machine list updated');
else
    msgbox('Can''t find machines struct');
end

guidata(hObject, handles);

if strcmp(get(handles.menu_machine,'Visible'),'on') && ~isempty(get(handles.menu_machine,'String')) && strcmp(get(handles.menu_machine,'Style'),'popupmenu')==1
    contents=get(handles.menu_machine,'String');
    val = contents(get(handles.menu_machine,'Value'));

    set(handles.menu_machine,'String',{handles.machines(:).Nickname})

    try
        idx = strmatch(val, cellstr(get(handles.menu_machine,'String')),'exact');
        set(handles.menu_machine,'Value',idx(1))
    catch ME %#ok<NASGU>
        contents = get(handles.menu_machine,'String');
        contents{length(contents)+1}=val;
        set(handles.menu_machine,'Value',length(contents))
        msgbox('Machine name disappeared so added back in here')
    end
end

catch ME
    handleME(ME)
end

% --------------------------------------------------------------------
function menuitem_update_Callback(hObject, eventdata, handles)
global cygpath cygpathcd mypath RunArray sl
% hObject    handle to menuitem_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try

ind = handles.curses.ind;

[~, statresult]=system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory handles.dl ' hg status']);

if ~isempty(statresult) && strcmp(statresult(1:end-1),'sh: $HOME/.bashrc: No such file or directory')==0 && strcmp(statresult(1:end-1),'/usr/bin/sh: $HOME/.bashrc: No such file or directory')==0
    changes=regexp(statresult,'\n','split');
    myfiles={};
    for r=1:length(changes)
        if ~isempty(changes{r}) && strcmp(changes{r}(1),'?')==0 &&  isempty(strfind(changes{r},'No such file or directory'))%strcmp(changes{r}(1:min(44,end)),'sh: $HOME/.bashrc: No such file or directory')==0
            myfiles{length(myfiles)+1}=changes{r}; %#ok<AGROW>
        end
    end
    if ~isempty(myfiles)
        btn=questdlg({'There are uncommitted changes to the following files:',myfiles{:},'If you update to a previous code version, the changes will be lost. Continue?'},'Overwrite Changes?','Overwrite','Cancel','Cancel');
        if strcmp('Cancel',btn)
            return
        end
    end
end



version = strtok(RunArray(ind).ModelVerComment,':');

system(['sh $HOME/.bashrc ' handles.dl ' cd ' RunArray(ind).ModelDirectory handles.dl ' hg update ' handles.general.clean ' -r ' version ]);

d=dir([RunArray(ind).ModelDirectory sl RunArray(ind).RunName sl 'hg_diff.out']);

if isempty(d)
    msgbox(['The code directory has been updated to version ' version])
else
    msgbox({['The code directory has been updated to version ' version], 'However, this run was executed with uncommitted changes. A list of those changes will now appear'})
    system([handles.general.textviewer ' ' RunArray(ind).ModelDirectory sl RunArray(ind).RunName sl 'hg_diff.out']);
end
catch ME
    handleME(ME)
end

% --------------------------------------------------------------------
function menuitem_groups_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function allows the user to edit the available groups that the runs
% can be labelled with
global cygpath cygpathcd mypath sl
try
h=groupset;
uiwait(h);

if exist([mypath sl 'data' sl 'MyOrganizer.mat'],'file')==2
    load([mypath sl 'data' sl 'MyOrganizer.mat']);
else
    msgbox('Can''t find MyOrganizer file');
end

if exist('groups','var')==1
    handles.groups=groups; % groups previously loaded from MyOrganizer.mat
    msgbox('Group list updated');
else
    msgbox('Can''t find groups struct');
end

guidata(hObject, handles);

contents=get(handles.list_groups,'String');
val = contents(get(handles.list_groups,'Value'));

set(handles.list_groups,'String',{handles.groups(:).name})
idx=zeros(length(val),1);
for r=1:length(val)
    try
        idx(r) = strmatch(val{r}, cellstr(get(handles.list_groups,'String')),'exact');
    catch ME %#ok<NASGU>
        contents = get(handles.list_groups,'String');
        contents{length(contents)+1}=val{r};
        set(handles.list_groups,'String',contents)
        idx(length(contents)) = 0;
        %idx(r) = length(contents);
        msgbox('Group value disappeared so added back in here')
    end
end
set(handles.list_groups,'Value',idx)
catch ME
    handleME(ME)
end


function edit_numprocs_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to edit_numprocs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numprocs as text
%        str2double(get(hObject,'String')) returns contents of edit_numprocs as a double


% --- Executes during object creation, after setting all properties.
function edit_numprocs_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to edit_numprocs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menuitem_cellclamp_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% This function allows the user to update the working code directory to the
% version of the currently selected run

if ispc
    mystr='.exe';
else
    mystr='';
end
m=findstr(handles.general.neuron,' ');
if ~isempty(m)
    nrnpath=handles.general.neuron(1:m(1)-1);
else
    nrnpath=handles.general.neuron;
end
if exist([strrep(nrnpath,'.exe','') mystr],'file')==0
    msgbox({'Please update the location of NEURON''s','nrniv executable in the General Settings first.'})
    return
end

% if ~isempty(handles.curses.ind)
%     btn = questdlg('Update code version to that of selected run?','Update version','Update','No','Update');
% 
%     switch btn
%         case 'Update'
%             menuitem_update_Callback(handles.menuitem_update, [], handles);
%     end
% end

evalin('base', 'cellclamp')


function menu_numdata_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>


function menu_conndata_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>


function menu_syndata_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>


% --- Executes on selection change in menu_numdata.
function menuitem_numdata_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% This function allows the user to update the cellnumbers GUI

evalin('base', ['cellnumbers_gui'])


% --- Executes during object creation, after setting all properties.
function menu_numdata_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_numdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function menu_conndata_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_conndata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function menu_syndata_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to menu_syndata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in menu_conndata.
function menuitem_conndata_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% This function allows the user to access the numcons GUI

evalin('base', ['numcons_gui'])

% --- Executes on selection change in menu_syndata.
function menuitem_syndata_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% This function allows the user to access the synapse GUI

evalin('base', ['synapse_gui'])


% --------------------------------------------------------------------
function varargout=menuitem_estimate_Callback(hObject, eventdata, handles,varargin) %#ok<DEFNU>
% This function estimates the amount of real time the selected run would
% take to run

%tmpout=timeestimate(handles,varargin{:});
%varargout={tmpout};
if isdeployed
    msgbox('This functionality not yet implemented for deployed applications.')    
else
    timeestimate(handles,varargin{:});
end

% --- Executes when selected cell(s) is changed in tbl_savedfigs.
function tbl_savedfigs_CellSelectionCallback(hObject, eventdata, handles) %#ok<DEFNU>
% This function opens the results folder or specific file associated with
% the results figure list row the user clicked on

try
    if (isprop(eventdata,'Indices') || isfield(eventdata,'Indices')) && numel(eventdata.Indices)>0
        handles.curses.myoutputfigrow=eventdata.Indices(1,1);
        guidata(hObject, handles);
    end

catch ME
    handleME(ME)
end



% --------------------------------------------------------------------
function menuitem_trblsht_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_trblsht (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pkg4michael(handles)


% --------------------------------------------------------------------
function menuitem_trblshtinfo_Callback(hObject, eventdata, handles)
global logloc mypath
% hObject    handle to menuitem_trblshtinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isdeployed
    fid = fopen([logloc 'SimTrackerOutput.log'],'a');
    fprintf(fid,'\n***********************************************\n');
    fprintf(fid,'TROUBLESHOOTING INFO:\n%s\n','Compiled version');
    fprintf(fid,'System: %s\n',handles.myversion.CompSys);
    fprintf(fid,'SimTracker Version: %s\n',handles.myversion.ROhg);
    fprintf(fid,'ispc=%g, ismac=%g, isunix=%g, computer=%s, OS=%s\n',ispc,ismac,isunix,computer,getenv('OS'));
    fprintf(fid,'***********************************************\n');
    fclose(fid);
    msgbox({'Please send an email to marianne.bezaire@gmail.com','or post at https://www.neuron.yale.edu/phpBB/viewforum.php?f=42','describing the problem with the SimTracker','and include the SimTrackerOutput.log file located at',[logloc 'SimTrackerOutput.log']})
else
    m=strfind(handles.myversion.ROhg,':');
    myver = handles.myversion.ROhg(1:m-1);

    [~, myoutp]=system(['sh $HOME/.bashrc ' handles.dl 'hg log -r ' myver ':tip']);
    [~, myouts]=system(['sh $HOME/.bashrc ' handles.dl ' hg status']);
    [~, myoutd]=system(['sh $HOME/.bashrc ' handles.dl ' hg diff -r ' myver ':tip']);
    fid = fopen('SimTrackerTRBLSHT.log','w');
    fprintf(fid,'\n***********************************************\n');
    fprintf(fid,'TROUBLESHOOTING INFO:\n%s\n','Uncompiled version');
    fprintf(fid,'System: %s\n',version);
    fprintf(fid,'SimTracker Version: %s\n',handles.myversion.ROhg);
    fprintf(fid,'ispc=%g, ismac=%g, isunix=%g, computer=%s, OS=%s\n\nToolboxes:\n',ispc,ismac,isunix,computer,getenv('OS'));
    b=ver;
    for r=1:length(b)
        fprintf(fid,'Tool: %s %s %s %s\n',b(r).Name, b(r).Version, b(r).Release, b(r).Date);
    end
    fprintf(fid,'\nMercurial Parent:\n%s\n\nMercurial Status:\n%s\n\nMercurial Diff:\n%s\n\n',myoutp,myouts,myoutd)
    fprintf(fid,'***********************************************\n');
    fclose(fid);
    msgbox({'Please send an email to marianne.bezaire@gmail.com','or post at https://www.neuron.yale.edu/phpBB/viewforum.php?f=42','describing the problem with the SimTracker','and include the SimTrackerTRBLSHT.log file',['in: ' mypath]})
end


% --------------------------------------------------------------------
function context_copyrun_Callback(hObject, eventdata, handles)
% hObject    handle to context_copyrun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cygpath cygpathcd mypath RunArray
handles = guidata(hObject);
ind = handles.curses.ind;
for r=1:length(ind)
    p = properties(RunArray(ind(r)));
    str = '';%sprintf ('%s', RunArray(ind(r)).RunName);
    for z=1:length(p)
        if isstr(RunArray(ind(r)).(p{z}))
            str = sprintf ( '%s%s\t%s\n', str, p{z}, RunArray(ind(r)).(p{z}));
        elseif isinteger(RunArray(ind(r)).(p{z}))
            str = sprintf ( '%s%s\t%d\n', str, p{z}, RunArray(ind(r)).(p{z}));
        else
            str = sprintf ( '%s%s\t%f\n', str, p{z}, RunArray(ind(r)).(p{z}));
        end
    end
    str = sprintf ( '%s\n', str);
end
clipboard ('copy', str);

% --------------------------------------------------------------------
function context_open_Callback(hObject, ~)
% hObject    handle to context_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cygpath cygpathcd mypath RunArray sl
handles = guidata(hObject);
ind = handles.curses.ind;

system([handles.general.explorer ' ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName]);

% --------------------------------------------------------------------
function context_openfile_Callback(hObject, ~)
% hObject    handle to context_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cygpath cygpathcd mypath RunArray sl
handles = guidata(hObject);
ind = handles.curses.ind;
myrow = handles.curses.myoutputfigrow;
if isempty(myrow)
    return
end


tmpdata=get(handles.tbl_savedfigs,'Data');
figname=tmpdata{myrow,4};
figformat=tmpdata{myrow,2};
figpath = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName];
figname(strfind(figname,' '))='_';
figname(strfind(figname,','))='';
figname(strfind(figname,':'))='';

if strcmp(figformat,'jpeg')==1
    figformat='jpg';
    system([handles.general.picviewer ' ' figpath sl figname '.' figformat]);
elseif strcmp(figformat,'pdf')==1
    system([handles.general.pdfviewer ' ' figpath sl figname '.' figformat]);
elseif strcmp(figformat,'fig')==1
    open([figpath sl figname]);
else
    system([handles.general.picviewer ' ' figpath sl figname '.' figformat]);
end

% --------------------------------------------------------------------
function MenuRunList_Callback(hObject, eventdata, handles)
% hObject    handle to MenuRunList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function context_copytable_Callback(hObject, ~)
% hObject    handle to context_copytable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject); 
mydata=get(handles.tbl_runs,'Data');
mycol=get(handles.tbl_runs,'ColumnName');

%load parameters
% create a header
% copy each row
str = sprintf ('\t');
for j=1:size(mydata,2)
    str = sprintf ( '%s%s\t', str, mycol{j} );
end
str = sprintf ( '%s\n', str(1:end-1));
for i=1:size(mydata,1)
    str = sprintf ( '%s%d\t', str, i );
    for j=1:size(mydata,2)
        if isstr(mydata{i,j})
            str = sprintf ( '%s%s\t', str, mydata{i,j} );
        elseif isinteger(mydata{i,j})
            str = sprintf ( '%s%d\t', str, mydata{i,j} );
        else
            str = sprintf ( '%s%f\t', str, mydata{i,j} );
        end
    end
    str = sprintf ( '%s\n', str(1:end-1));
end
clipboard ('copy', str);


% --------------------------------------------------------------------
function menuitem_multperf_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_multperf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cygpath cygpathcd mypath RunArray sl

if isdeployed
    msgbox('This functionality not yet implemented for deployed applications.')
    return
end
h=plotperf(hObject,handles);

try

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

tmpdata=get(handles.tbl_runs,'Data');
handles.curses.indices = [];
for r=1:size(handles.indices,1)
    myrow = handles.indices(r,1);
    RunName = tmpdata(myrow,1);
    handles.curses.indices(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1 ); % delete min for real data
end

% Fill out the handles.curses.times structure for all selected runs
getruntimes(hObject,handles,handles.curses.indices)
handles=guidata(hObject); % update the handles structure so it contains the fresh times structure data

    figure('Color','w'); % sum setup time as a function of numprocs (lines for each computer)
    for r=1:length(handles.curses.indices)
        % match machines nickname to get color
        RunArray(handles.curses.indices(r)).Machine;
        mycol='b';

        plot(RunArray(handles.curses.indices(r)).NumProcessors, handles.curses.times(r).setup.tot,'Color',mycol,'Marker','.','MarkerSize',10,'Linestyle','none')
        hold on
    end
    x = [RunArray(handles.curses.indices(:)).NumProcessors];
    y=zeros(length(handles.curses.times),1);
    for r=1:length(handles.curses.times)
        y(r)=handles.curses.times(r).setup.tot;
    end


    MYx = 0:max(x)/10:max(x);
    [x si]=sort(x);
    y=y(si);
    yy=diff(y);
    xx=diff(x);
    addme = min(y) -  ((min(x)-mean(x))*max(yy(xx~=0)./xx(xx~=0)')+mean(y));
    %zerome = 0 -  ((0-mean(x))*max(yy(xx~=0)./xx(xx~=0))+mean(y));
    MYsetup = (MYx-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y)+max([addme 0]); % zerome]);
    plot(MYx,MYsetup,'k','LineStyle','-')
    xlabel('Num Processors')
    ylabel('Total Setup Time of all Processors (s)')
    yL=get(gca,'yLim');
    ylim([0 yL(2)])
    xL=get(gca,'xLim');
    xlim([0 xL(2)])


    figure('Color','w'); % sum creation time as a function of cell numbers (colors for each computer, markers according to num procs)
    for r=1:length(handles.curses.indices)
        % match machines nickname to get color
        RunArray(handles.curses.indices(r)).Machine;
        mymark='.';
        RunArray(handles.curses.indices(r)).NumProcessors;
        mycol='b';

        plot(RunArray(handles.curses.indices(r)).NumCells, handles.curses.times(r).create.tot,'Color',mycol,'Marker',mymark,'MarkerSize',10,'Linestyle','none')
        hold on
    end
    x = [RunArray(handles.curses.indices(:)).NumCells];
    y=zeros(length(handles.curses.times),1);
    for r=1:length(handles.curses.times)
        y(r)=handles.curses.times(r).create.tot;
    end

    if length(x)>1
        MYx = 0:max(x)/10:max(x);
        [x, si]=sort(x);
        y=y(si);
        yy=diff(y);
        xx=diff(x);
        if sum(xx)==0
                myslope=0;
        else
            myslope=max(yy(xx~=0)./xx(xx~=0));
            if isempty(myslope)
                myslope=0;
            end
        end
        addme = min(y) -  ((min(x)-mean(x))*myslope+mean(y));
        MYcreate = (MYx-mean(x))*myslope+mean(y)+max(addme,0);

        plot(MYx,MYcreate,'k','LineStyle','-')
    end
    xlabel('Num Cells')
    ylabel('Total Cell Creation Time of all Processors (s)')
    get(gca,'yLim')
    yL=get(gca,'yLim');
    ylim([0 yL(2)])
    xL=get(gca,'xLim');
    xlim([0 xL(2)])

    figure('Color','w'); % sum connection time as a function of ConnData & Scale (colors for each computer, markers according to num procs)
    totcons=zeros(length(handles.curses.times),1);
    for r=1:length(handles.curses.indices)
        % match machines nickname to get color
        RunArray(handles.curses.indices(r)).Machine;
        RunArray(handles.curses.indices(r)).NumProcessors;
        mycol='b';

        fid = fopen([myrepos(q).dir sl 'datasets' sl 'conndata_' num2str(RunArray(handles.curses.indices(r)).ConnData) '.dat'],'r');                
        numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
        filedata = textscan(fid,'%s %s %f %f %f\n') ;
        fclose(fid);
        mdx= filedata{3}~=0 & filedata{5}~=0;

        totcons(r)=sum(filedata{4}(mdx))/RunArray(handles.curses.indices(r)).Scale;
        plot(totcons(r), handles.curses.times(r).connect.tot,'Color',mycol,'Marker',mymark,'MarkerSize',10,'Linestyle','none')
        hold on
    end
    x = totcons;
    y=zeros(length(handles.curses.times),1);
    for r=1:length(handles.curses.times)
        y(r)=handles.curses.times(r).connect.tot;
    end

    if length(x)>1
        MYtotcons = 0:max(x)/10:max(x);
        [x si]=sort(x);
        y=y(si);
        yy=diff(y);
        xx=diff(x);
        myslope=max(yy(xx~=0)./xx(xx~=0));
        if isempty(myslope)
            myslope=0;
        end
        addme = min(y) -  ((min(x)-mean(x))*myslope+mean(y));
        MYconnect = (MYtotcons-mean(x))*myslope+mean(y)+max([addme 0]);
        plot(MYtotcons,MYconnect,'k','LineStyle','-')
    end
    xlabel('Proposed Connections')
    ylabel('Total Cell Connection Time of all Processors (s)')
    get(gca,'yLim')
    yL=get(gca,'yLim');
    ylim([0 yL(2)])
    xL=get(gca,'xLim');
    xlim([0 xL(2)])


    figure('Color','w'); % sum connection time as a function of ConnData & Scale (colors for each computer, markers according to num procs)
    for r=1:length(handles.curses.indices)
        % match machines nickname to get color
        RunArray(handles.curses.indices(r)).Machine;
        mymark='.';
        RunArray(handles.curses.indices(r)).NumProcessors;
        mycol='b';

        fid = fopen([myrepos(q).dir sl 'datasets' sl 'conndata_' num2str(RunArray(handles.curses.indices(r)).ConnData) '.dat'],'r');                
        numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
        filedata = textscan(fid,'%s %s %f %f %f\n') ;
        fclose(fid);
        mdx=filedata{3}~=0 & filedata{5}~=0;

        totcons(r)=sum(filedata{4}(mdx))/RunArray(handles.curses.indices(r)).Scale;
        plot(totcons(r), RunArray(handles.curses.indices(r)).NumConnections,'Color',mycol,'Marker',mymark,'MarkerSize',10,'Linestyle','none')
        hold on
    end
    x = totcons;
    y=zeros(length(handles.curses.times),1);
    for r=1:length(handles.curses.indices)
        y(r)=RunArray(handles.curses.indices(r)).NumConnections;
    end

    if length(x)>1
        MYtotcons = 0:max(x)/10:max(x);
        [x si]=sort(x);
        y=y(si);
        yy=diff(y);
        xx=diff(x);
        myslope=max(yy(xx~=0)./xx(xx~=0));
        if isempty(myslope)
            myslope=0;
        end
        addme = min(y) -  ((min(x)-mean(x))*myslope+mean(y));
        MYconnect = (MYtotcons-mean(x))*myslope+mean(y)+max([addme 0]);
        plot(MYtotcons,MYconnect,'k','LineStyle','-')
    end
    xlabel('Proposed Connections')
    ylabel('Total Cell Connections')
    get(gca,'yLim')
    yL=get(gca,'yLim');
    ylim([0 yL(2)])
    xL=get(gca,'xLim');
    xlim([0 xL(2)])

    figure('Color','w'); % sum run time as a function of sim duration x temporal resolution  (colors for each computer, markers according to num procs)
    for r=1:length(handles.curses.indices)
        % match machines nickname to get color
        RunArray(handles.curses.indices(r)).Machine;
        mymark='.';
        RunArray(handles.curses.indices(r)).NumProcessors;
        mycol='b';

        projsteps = RunArray(handles.curses.indices(r)).SimDuration/RunArray(handles.curses.indices(r)).TemporalResolution*totcons(r);

        plot(projsteps, handles.curses.times(r).run.tot,'Color',mycol,'Marker',mymark,'MarkerSize',10,'Linestyle','none')
        hold on
    end
    x = [RunArray(handles.curses.indices(:)).SimDuration]./[RunArray(handles.curses.indices(:)).TemporalResolution].*totcons';
    y=zeros(length(handles.curses.times),1);
    for r=1:length(handles.curses.times)
        y(r)=handles.curses.times(r).run.tot;
    end

    if length(x)>1
        MYx = 0:max(x)/10:max(x);
        [x si]=sort(x);
        y=y(si);
        yy=diff(y);
        xx=diff(x);
        myslope=max(yy(xx~=0)./xx(xx~=0)');
        if isempty(myslope)
            myslope=0;
        end
        addme = min(y) -  ((min(x)-mean(x))*myslope+mean(y));
        MYsim = (MYx-mean(x))*myslope+mean(y)+max([addme 0]);
        plot(MYx,MYsim,'LineStyle','-','Color','k')
    end
    xlabel('Num Sim Steps x Num Projected Connections')
    ylabel('Total Simulation Time of all Processors (s)')
    get(gca,'yLim')
    yL=get(gca,'yLim');
    ylim([0 yL(2)])
    xL=get(gca,'xLim');
    xlim([0 xL(2)])

    % - write time: RunTime - avg of all other steps, a function of proj conns
    % and also of num procs
    figure('Color','w'); % sum run time as a function of sim duration x temporal resolution  (colors for each computer, markers according to num procs)
    for r=1:length(handles.curses.indices)
        % match machines nickname to get color
        RunArray(handles.curses.indices(r)).Machine;
        mymark='.';
        RunArray(handles.curses.indices(r)).NumProcessors;
        mycol='b';

        projsteps = RunArray(handles.curses.indices(r)).SimDuration/RunArray(handles.curses.indices(r)).TemporalResolution*totcons(r);
        writetime = RunArray(handles.curses.indices(r)).RunTime*RunArray(handles.curses.indices(r)).NumProcessors-(handles.curses.times(r).run.tot+handles.curses.times(r).connect.tot+handles.curses.times(r).create.tot+handles.curses.times(r).setup.tot);

        plot(projsteps, writetime,'Color',mycol,'Marker',mymark,'MarkerSize',10,'Linestyle','none')
        hold on
    end
    x = [RunArray(handles.curses.indices(:)).SimDuration]./[RunArray(handles.curses.indices(:)).TemporalResolution].*totcons';
    y=zeros(length(handles.curses.times),1);
    for r=1:length(handles.curses.times)
        y(r)=RunArray(handles.curses.indices(r)).RunTime*RunArray(handles.curses.indices(r)).NumProcessors-(handles.curses.times(r).run.tot+handles.curses.times(r).connect.tot+handles.curses.times(r).create.tot+handles.curses.times(r).setup.tot);
    end

    if length(x)>1
        MYx = 0:max(x)/10:max(x);
        [x si]=sort(x);
        y=y(si);
        yy=diff(y);
        xx=diff(x);
        myslope=max(yy(xx~=0)./xx(xx~=0)');
        if isempty(myslope)
            myslope=0;
        end
        addme = min(y) -  ((min(x)-mean(x))*myslope+mean(y));
        MYsim = (MYx-mean(x))*myslope+mean(y)+max([addme 0]);
        plot(MYx,MYsim,'LineStyle','-','Color','k')
    end
    xlabel('Num Sim Steps x Num Projected Connections')
    ylabel('Total Results Write Time of all Processors (s)')
    get(gca,'yLim')
    yL=get(gca,'yLim');
    ylim([0 yL(2)])
    xL=get(gca,'xLim');
    xlim([0 xL(2)])

    
catch ME
    handleME(ME)
end


% --------------------------------------------------------------------
function menuitem_netclamp_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_netclamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%gohere

if ispc
    mystr='.exe';
else
    mystr='';
end
m=findstr(handles.general.neuron,' ');
if ~isempty(m)
    nrnpath=handles.general.neuron(1:m(1)-1);
else
    nrnpath=handles.general.neuron;
end
% if exist([strrep(nrnpath,'.exe','') mystr],'file')==0
%     msgbox({'Please update the location of NEURON''s','nrniv executable in the General Settings first.'})
%     return
% end

% if ~isempty(handles.curses.ind)
%     btn = questdlg('Update code version to that of selected run?','Update version','Update','No','Update');
% 
%     switch btn
%         case 'Update'
%             menuitem_update_Callback(handles.menuitem_update, [], handles);
%     end
% end
try
evalin('base', 'NewNetClamp')
catch ME
    handleME(ME)
end


% --------------------------------------------------------------------
function menuitem_expdata_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_expdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isdeployed
    msgbox('This functionality not yet implemented for deployed applications.')
else
evalin('base', 'CellData')
end


% --------------------------------------------------------------------
function menuitem_websitemaker_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_websitemaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isdeployed
    msgbox('This functionality not yet implemented for deployed applications.')
else
evalin('base', 'WebsiteMaker')
end




% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu13.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu13


% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu14.
function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu14


% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15


% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu16.
function popupmenu16_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu16


% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu17.
function popupmenu17_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu17


% --- Executes during object creation, after setting all properties.
function popupmenu17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18


% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu19.
function popupmenu19_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu19


% --- Executes during object creation, after setting all properties.
function popupmenu19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu20.
function popupmenu20_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu20 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu20


% --- Executes during object creation, after setting all properties.
function popupmenu20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu21.
function popupmenu21_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu21


% --- Executes during object creation, after setting all properties.
function popupmenu21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu22.
function popupmenu22_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu22 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu22


% --- Executes during object creation, after setting all properties.
function popupmenu22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_variables.
function btn_variables_Callback(hObject, eventdata, handles)
% hObject    handle to btn_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=load_results(hObject,handles);

function comp2Runs(handles)
global cygpath cygpathcd mypath RunArray

tmpdata=get(handles.tbl_runs,'Data');
handles.curses.indices = [];
for r=1:size(handles.indices,1)
    myrow = handles.indices(r,1);
    RunName = tmpdata(myrow,1);
    handles.curses.indices(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1 ); % delete min for real data
end

g = properties(RunArray(handles.curses.ind));
myfl=zeros(1,length(g));
disp('*** Differences ***')
for gidx=1:length(g)
    if isnumeric(RunArray(handles.curses.ind).(g{gidx}))
        for h=1:length(handles.curses.indices)
            if isequal(RunArray(handles.curses.ind).(g{gidx}),RunArray(handles.curses.indices(h)).(g{gidx}))==0
                myfl(gidx)=1;
            end
        end
    else
        for h=1:length(handles.curses.indices)
            if strcmp(RunArray(handles.curses.ind).(g{gidx}),RunArray(handles.curses.indices(h)).(g{gidx}))==0
                myfl(gidx)=2;
            end
        end
    end
    if myfl(gidx)==1
        disp([g{gidx} ': '])
        for h=1:length(handles.curses.indices)
            disp([RunArray(handles.curses.indices(h)).RunName ' = ' num2str(RunArray(handles.curses.indices(h)).(g{gidx}))])
        end
        disp(' ')
    elseif myfl(gidx)==2
        disp([g{gidx} ': '])
        for h=1:length(handles.curses.indices)
            disp([RunArray(handles.curses.indices(h)).RunName ' = ' RunArray(handles.curses.indices(h)).(g{gidx})])
        end
        disp(' ')
    end
end


% --------------------------------------------------------------------
function menuitem_custom_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function varargout=system(mycmd)
global cygpath cygpathcd mypath sl
if exist([getenv('HOME') sl '.bashrc'],'file')
    if ispc
    [varargout{1:nargout}]=builtin('system',['sh $HOME/.bashrc & ' mycmd]);
    else
    [varargout{1:nargout}]=builtin('system',['. $HOME/.bashrc ; ' mycmd]);
    end
else
    [varargout{1:nargout}]=builtin('system',mycmd);
end
