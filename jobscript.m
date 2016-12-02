function outstat=jobscript(hObject,handles,varargin)
% jobscript(hObject,handles)
% function used by the SimTracker GUI
% to create the jobscript files and put them on the server
% along with any other files needed to run the simulation
% (and to update the cells with the synapse set info as well)

% scp -r case@ranger.tacc.utexas.edu:/work/01475/case/repos/ca1/jobscripts/FewES3Rang.2582817.o /home/casem/delsoon
global mypath RunArray pswd pswdmach sl usesamehours realpath logloc divertflag
outstat=0;
try
    %for myind=1:length(handles.curses.ind)
ind = handles.curses.ind; %(myind);

if ~isempty(RunArray(ind).ExecutedBy)
    disp('This run has already been executed.')
    return
end

if isdeployed==0
    commandwindow;
end

partofbatch=0;
partOfBatchSquared=0;
if ~isempty(varargin)
    partofbatch=varargin{1};
    if length(varargin)>1
        partOfBatchSquared=varargin{2};
    end
end

% Machine and job parameters
RunArray(ind).JobScript = ['jobscripts/' RunArray(ind).RunName '.sh'];

idx = strfind(RunArray(ind).ModelDirectory,'/');
if isempty(idx)
    idx = strfind(RunArray(ind).ModelDirectory,'\');
end
jobtype.program = RunArray(ind).ModelDirectory(idx(end)+1:end);

if strcmp(RunArray(ind).Machine,'trestles')==1
    RunArray(ind).CatFlag=0;
else
    %RunArray(ind).CatFlag=1;
end

m = find(strcmp(RunArray(ind).Machine,{handles.machines(:).Nickname})==1);

RunArray(ind).TopProc = handles.machines(m).TopCmd;

jobtype.allocation = handles.machines(m).Allocation;

load([realpath sl 'defaults' sl 'defaultparameters.mat'],'defixparams')

modeldir=RunArray(ind).ModelDirectory;
if exist([modeldir sl 'setupfiles' sl 'parameters.mat'],'file')
    load([modeldir sl 'setupfiles' sl 'parameters.mat'],'chparams')
else
    load([realpath sl 'defaults' sl 'defaultparameters.mat'],'defchparams')
    chparams=defchparams;
    save([modeldir sl 'setupfiles' sl 'parameters.mat'],'chparams','-v7.3')
    checkAndcommitParams(handles,modeldir)
end
parameters=[defixparams chparams];

    
jobtype.options = {};
g=1;
for r=1:length(parameters)
    if parameters(r).file==1 && strcmp(parameters(r).name,'JobNumber')==0
        if strcmp(parameters(r).type,'string')==1
            jobtype.options{g}=['strdef ' parameters(r).name];
            g=g+1;
            jobtype.options{g}=[parameters(r).name '="' RunArray(ind).(parameters(r).name) '"'];
            g=g+1;
        else
            jobtype.options{g}=[parameters(r).name '=' num2str(RunArray(ind).(parameters(r).name))];
            g=g+1;
        end
    end
end

jobtype.email = handles.general.email;
divertflag=0;
% Decide which machine to run this on.
if isdeployed && strcmp(handles.machines(m).Address,'stampede.tacc.utexas.edu') && (isempty(handles.machines(m).gsi) || handles.general.gsi.flag==0)
    msgbox({'In compiled mode without GSI, SimTracker cannot access Stampede.','In your terminal, enter the following:',['cd ' RunArray(ind).ModelDirectory],['sh .' sl 'jobscripts' sl 'RunInTerminal_' RunArray(ind).RunName '.sh']});
    divertflag=1;
    fidivert=fopen([RunArray(ind).ModelDirectory sl 'jobscripts' sl 'RunInTerminal_' RunArray(ind).RunName '.sh'],'w');
elseif strcmp(handles.machines(m).Conn,'script')
    msgbox({'In your terminal, enter the following:',cygwin(['cd ' RunArray(ind).ModelDirectory]),cygwin(['sh .' sl 'jobscripts' sl 'RunInTerminal_' RunArray(ind).RunName '.sh'])});
    divertflag=1;
    fidivert=fopen([RunArray(ind).ModelDirectory sl 'jobscripts' sl 'RunInTerminal_' RunArray(ind).RunName '.sh'],'w');
end


if divertflag==0 && strcmp(handles.machines(m).Conn,'ssh2') && (isempty(handles.machines(m).gsi) || handles.general.gsi.flag==0)
    if isempty(pswd) || strcmp(handles.machines(m).Nickname,pswdmach)==0
        pswd=inputdlg(['Password for ' handles.machines(m).Username '@' handles.machines(m).Address]);
        pswdmach=handles.machines(m).Nickname;
    end
    if isempty(pswd)
        return
    end
end

jobtype.repos = [handles.machines(m).Repos jobtype.program];

if ~isnumeric(RunArray(ind).NumProcessors)
    RunArray(ind).NumProcessors=str2num(RunArray(ind).NumProcessors);
end
jobtype.nodes = ceil(RunArray(ind).NumProcessors/handles.machines(m).CoresPerNode); %  Warning = need to switch the properties to proper formats and not str2num here

if handles.general.roundcoresup
    jobtype.cores = jobtype.nodes*handles.machines(m).CoresPerNode;
    RunArray(ind).NumProcessors = jobtype.cores;
else
    jobtype.cores = RunArray(ind).NumProcessors;
end

if (partofbatch==0 && partOfBatchSquared==0) || usesamehours==0
    jobtype.runhours = RunArray(ind).JobHours; %2; %1.5; % estimator(cores, RunArray(ind).Scale, RunArray(ind).NumCells, RunArray(ind).Connectivity, RunArray(ind).Stimulation)
    if RunArray(ind).Scale<100
        jobtype.runhours=jobtype.runhours*2;
        if RunArray(ind).Scale==1
            jobtype.runhours=jobtype.runhours+2;
        end
        if RunArray(ind).SimDuration>400
            jobtype.runhours=jobtype.runhours*(RunArray(ind).SimDuration-200)/200;
        end
        if RunArray(ind).TemporalResolution<.1
            jobtype.runhours=jobtype.runhours*1.5;
        end
    end
    if RunArray(ind).SimDuration<2
        jobtype.runhours=.15;
    elseif strcmp(handles.machines(m).Nickname,'trestles')==1
        jobtype.runhours=jobtype.runhours*2;  % trestles takes almost twice as long. connections = 2x, simulation = 3x. surprising the overall time is not EVEN longer.
    end
    if handles.general.timelimit
        runhourschar=inputdlg('Enter the max number of hours the job can run','Max time',1,{num2str(RunArray(ind).JobHours)});
        if ~isempty(findstr(runhourschar{:},'*'))
            jobtype.runhours=str2num(runhourschar{1}(1:end-1));
            usesamehours=jobtype.runhours;
        else
            jobtype.runhours=str2num(runhourschar{:});
        end
        RunArray(ind).JobHours = jobtype.runhours;
    else 
        jobtype.runhours = RunArray(ind).JobHours;
    end
else
    jobtype.runhours=usesamehours;
end
runminsleft = mod(jobtype.runhours,1)*60;
jobtype.runtime = [num2str(fix(jobtype.runhours),'%02.0f') ':' num2str(fix(runminsleft),'%02.0f') ':' num2str(fix(mod(runminsleft,1)*60),'%02.0f')];

jobtype.queue='';
for r=1:length(handles.machines(m).Queues)
    if jobtype.runhours<=handles.machines(m).Queues(r).RunHours && jobtype.cores<=handles.machines(m).Queues(r).Cores
        jobtype.queue = handles.machines(m).Queues(r).Name;
        break;
    end
end

if isempty(jobtype.queue)
     h = msgbox({'You must submit this job', 'to the special request queue.'},'Run Parameter(s) Too Large','help');
    uiwait(h);
    return
end

% To use Mercurial on the server:
% Mercurial on RANGER (or whichever cluster you are in)
% module load beta -- mercurial is only available through the beta module,
% so execute that one first, then
% module load mercurial
% at the command line or in:
% .login_user and/or .profile_user shell startup files.

if ispc
    homedir=['C:\Users\' getenv('username') '\mercurial.ini'];
    %homedir=['cygdrive\c\Users\' getenv('username') '\mercurial.ini'];
else % if isunix
    homedir='$HOME/.hgrc';
end

if ismac
    if strcmp(handles.machines(m).Nickname,'trestles')==0
        jobscripts.push = ['!awk ''{if($0 ~ /remotecmd/) {print "#remotecmd = /opt/rocks/bin/hg"} else {print $0}}'' ' homedir ' > x' handles.dl 'mv x ' homedir ];
    else
        jobscripts.push = ['!awk ''{if($0 ~ /remotecmd/) {print "remotecmd = /opt/rocks/bin/hg"} else {print $0}}'' ' homedir ' > x' handles.dl 'mv x ' homedir ];
    end

else
    if strcmp(handles.machines(m).Nickname,'trestles')==0
        jobscripts.push = ['!sed "/remotecmd/c  #remotecmd = /opt/rocks/bin/hg" ' homedir ' > x' handles.dl 'mv x ' homedir ];
    else
        jobscripts.push = ['!sed "/remotecmd/c  remotecmd = /opt/rocks/bin/hg" ' homedir ' > x' handles.dl 'mv x ' homedir ];
    end
end
eval(jobscripts.push);

outstr=[];
if isdeployed
    fidlog=fopen([logloc 'SimTrackerOutput.log'],'a');
end

if exist([RunArray(ind).ModelDirectory sl 'results' sl 'machrepos.mat'],'file')
    load([RunArray(ind).ModelDirectory sl 'results' sl 'machrepos.mat'],'machrepos');
    mz=find(strcmp({machrepos(:).Nickname},handles.machines(m).Nickname)==1);
else
    mz=1;
    machrepos(1).Nickname=handles.machines(m).Nickname;
    machrepos(1).LatestVersion=[];
end

if isempty(mz)
    mz=length(machrepos)+1;
    machrepos(mz).Nickname=handles.machines(m).Nickname;
    machrepos(mz).LatestVersion=[];
end
%msgbox(['machine: ' handles.machines(m).Nickname ' conn: ' handles.machines(m).Conn ' m: ' num2str(m) ' strcmp: ' num2str(strcmp(handles.machines(m).Conn,'ssh2'))])

% Write job script and save it to the remote folder, then submit it
fid = fopen([RunArray(ind).ModelDirectory '/' RunArray(ind).JobScript],'w');
fid2 = fopen([RunArray(ind).ModelDirectory '/jobscripts/' RunArray(ind).RunName '_run.hoc'],'w');

%run(['jobscripts/' handles.machines(m).Nickname 'script.m']) % include the m-file that prints the jobscript

eval(['write_' handles.machines(m).Nickname 'script(fid,fid2,jobtype,handles,m)'])

fclose(fid);
fclose(fid2);

try
% Upload code to server if necessary
if partofbatch==0 && partOfBatchSquared==0
    if isempty(machrepos(mz).LatestVersion)
        %make repository
        if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
            jobscripts.update = ['!' handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' "cd ' handles.machines(m).Repos '; mkdir ' jobtype.program  '; cd ' jobtype.program '; hg init; mkdir datasets; cd datasets; hg init;"']; % This returns whether any changes were made,
            [~, outstr(length(outstr)+1).results]=system(jobscripts.update);
        elseif divertflag
            jobscripts.update = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' "cd ' handles.machines(m).Repos '; mkdir ' jobtype.program '; cd ' jobtype.program '; hg init; mkdir datasets; cd datasets; hg init;"']; % This returns whether any changes were made,
            fprintf(fidivert,'%s\n',jobscripts.update);
        elseif strcmp(handles.machines(m).Conn,'ssh2')
            saveglobals; %retrieveglobal mypaths
            getresults = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos '; mkdir ' jobtype.program '; cd ' jobtype.program '; hg init']);
            retrieveglobals
            getresults2 = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos jobtype.program '; mkdir datasets; cd datasets; hg init']);
            retrieveglobals
            outstr(length(outstr)+1).results = getresults{:};
            outstr(length(outstr)+1).results = getresults2{:};
        else
            jobscripts.update = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' "cd ' handles.machines(m).Repos '; mkdir ' jobtype.program '; cd ' jobtype.program '; hg init; mkdir datasets; cd datasets; hg init;"']; % This returns whether any changes were made,
            %[~, outstr(length(outstr)+1).results]=
            if isdeployed==0, commandwindow; end
            eval(['!' jobscripts.update]) %system(jobscripts.update);
        end
        
        jobscripts.push = ['cd ' cygwin(RunArray(ind).ModelDirectory) handles.dl ' hg push -f ssh://' handles.machines(m).Username '@' handles.machines(m).Address '/' jobtype.repos handles.dl ' cd datasets' handles.dl ' hg push -f ssh://' handles.machines(m).Username '@' handles.machines(m).Address '/' jobtype.repos '/datasets'];
        if isdeployed
            fprintf(fidlog,'\nAbout to use Mercurial to update the repository:\n%s\n', jobscripts.push);
        end
        %[~, outstr(length(outstr)+1).results]=
        if divertflag
            fprintf(fidivert,'%s\n',jobscripts.push);
        elseif isdeployed && strcmp(handles.machines(m).Conn,'ssh2')
            saveglobals; %retrieveglobal mypaths
            mytmp=dir(RunArray(ind).ModelDirectory);
            myjobfiles={mytmp([mytmp.isdir]==0).name}; %={'.hgignore'};
            getresults = scp_simple_put(handles.machines(m).Address,handles.machines(m).Username,pswd{:},myjobfiles,[jobtype.repos  '/'], [strrep(RunArray(ind).ModelDirectory,'\','/') '/']);
                %outstr(length(outstr)+1).results=getresults{:};
            retrieveglobals
            mydirs={mytmp([mytmp.isdir]).name};
            for dd=3:length(mydirs)
                mytmp=dir([RunArray(ind).ModelDirectory sl mydirs{dd}]);
                myjobfiles={mytmp([mytmp.isdir]==0).name}; %={'.hgignore'};
                if ~isempty(myjobfiles)
                    getresults2 = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' handles.machines(m).Repos jobtype.program '; mkdir ' mydirs{dd}]);
                    getresults = scp_simple_put(handles.machines(m).Address,handles.machines(m).Username,pswd{:},myjobfiles,[jobtype.repos  '/' mydirs{dd}], [strrep(RunArray(ind).ModelDirectory,'\','/') '/' mydirs{dd} '/']);
                end
                retrieveglobals
                %outstr(length(outstr)+1).results=getresults{:};
            end
        else
            commandwindow;
            eval(['!' jobscripts.push]) %system(jobscripts.push);
            if ~isempty(outstr) && isfield(outstr,'results')
                if ~isdeployed
                    disp(outstr(end).results)
                else
                    fprintf(fidlog,outstr(end).results);
                end
            end
        end
        outstr(length(outstr)+1).results='';

        [~, result] = system(['cd ' RunArray(ind).ModelDirectory handles.dl 'hg log']);
        [~, names] = regexp(result, 'changeset\:\ +(?<num>[\d]+)[\d\s\:]?', 'tokens', 'names');

        % if no jobscripts or results folders, make them here! copy over .hgignore
        
        if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
            jobtype.putscript = [handles.machines(m).gsi 'scp ' upper(handles.machines(m).GSIOpt) ' -r ' RunArray(ind).ModelDirectory '/.hgignore' ' ' handles.machines(m).Username '@' handles.machines(m).Address ':' jobtype.repos ];
            [~, outstr(length(outstr)+1).results]=system(jobtype.putscript);
        elseif divertflag
            jobtype.putscript = ['scp -r ' cygwin([RunArray(ind).ModelDirectory sl '.hgignore']) ' ' handles.machines(m).Username '@' handles.machines(m).Address ':' jobtype.repos ];
            fprintf(fidivert,'%s\n',jobtype.putscript);
        elseif strcmp(handles.machines(m).Conn,'ssh2')
            %gohere
            myjobfiles={'.hgignore'};
            jobtype.putscript='';
            saveglobals; %retrieveglobal mypaths
            getresults = scp_simple_put(handles.machines(m).Address,handles.machines(m).Username,pswd{:},myjobfiles,[jobtype.repos  '/'], [strrep(RunArray(ind).ModelDirectory,'\','/') '/']);
            retrieveglobals
            outstr(length(outstr)+1).results=getresults;
            
        else
            jobtype.putscript = ['scp -r ' cygwin([RunArray(ind).ModelDirectory sl '.hgignore']) ' ' handles.machines(m).Username '@' handles.machines(m).Address ':' jobtype.repos ];
            %[~, outstr(length(outstr)+1).results]=
            if isdeployed==0, commandwindow; end
            eval(['!' jobtype.putscript]) %system(jobtype.putscript);
        end

        machrepos(mz).LatestVersion = str2num(names(1).num); %max(str2num([names(:).num]'));

        if isdeployed
            fprintf(fidlog,'\nGoing to copy over the hgignore file:\n%s\n', jobtype.putscript);
        end
        
        if ~isdeployed
            disp(outstr(end).results)
        else
            %fprintf(fidlog,outstr(end).results) % this seems to cause
            %problems ... maybe it is a cell instead of char?
        end

        if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
            jobscripts.update = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' "cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; mkdir jobscripts ; mkdir results ; mkdir cells; mkdir datasets"']; % This returns whether any changes were made,
            [~, outstr(length(outstr)+1).results]=system(jobscripts.update);
        elseif divertflag
            jobscripts.update = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' "cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; mkdir jobscripts ; mkdir results ; mkdir cells ; mkdir datasets"']; % This returns whether any changes were made,
            fprintf(fidivert,'%s\n',jobscripts.update);
        elseif strcmp(handles.machines(m).Conn,'ssh2')
            jobscripts.update='';
            saveglobals; %retrieveglobal mypaths
            getresults = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; mkdir jobscripts ; mkdir results ; mkdir cells ; mkdir datasets']);
            retrieveglobals
            outstr(length(outstr)+1).results=getresults{:};
        else
            jobscripts.update = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' "cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; mkdir jobscripts ; mkdir results ; mkdir cells ; mkdir datasets"']; % This returns whether any changes were made,
            %[~, outstr(length(outstr)+1).results]=system(jobscripts.update);
            if isdeployed==0, commandwindow; end
            eval(['!' jobscripts.update])
        end
        
        if isdeployed
            fprintf(fidlog,'\nGoing to update the remote repository:\n%s\n', jobscripts.update);
        end
        
        if ~isdeployed
            disp(outstr(end).results)
        else
            fprintf(fidlog,outstr(end).results);
        end

    elseif str2num(strtok(RunArray(ind).ModelVerComment,':')) > machrepos(mz).LatestVersion % if local code version not yet uploaded to repository
        jobscripts.push = ['cd ' cygwin(RunArray(ind).ModelDirectory) handles.dl 'hg push -f ssh://' handles.machines(m).Username '@' handles.machines(m).Address '/' jobtype.repos handles.dl ' cd datasets' handles.dl 'hg push -f ssh://' handles.machines(m).Username '@' handles.machines(m).Address '/' jobtype.repos '/datasets'];
        if isdeployed
            fprintf(fidlog,'\nLet''s send repository over to remote computer:\n%s\n', jobscripts.push);
        end
        
        if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
            [~, outstr(length(outstr)+1).results]=system(jobscripts.push);
        elseif divertflag
            fprintf(fidivert,'%s\n',jobscripts.push);
        elseif strcmp(handles.machines(m).Conn,'ssh2')
            saveglobals; %retrieveglobal mypaths
            mytmp=dir(RunArray(ind).ModelDirectory);
            myjobfiles={mytmp([mytmp.isdir]==0).name}; %={'.hgignore'};
            getresults = scp_simple_put(handles.machines(m).Address,handles.machines(m).Username,pswd{:},myjobfiles,[jobtype.repos  '/'], [strrep(RunArray(ind).ModelDirectory,'\','/') '/']);
            retrieveglobals
            mydirs={mytmp([mytmp.isdir]).name};
            for dd=3:length(mydirs)
                mytmp=dir([RunArray(ind).ModelDirectory sl mydirs(dd).name]);
                myjobfiles={mytmp([mytmp.isdir]==0).name}; %={'.hgignore'};
                getresults = scp_simple_put(handles.machines(m).Address,handles.machines(m).Username,pswd{:},myjobfiles,[jobtype.repos  '/' mydirs(dd).name], [strrep(RunArray(ind).ModelDirectory,'\','/') '/' mydirs(dd).name '/']);
                retrieveglobals
                outstr(length(outstr)+1).results=getresults{:};
            end
        else
            if isdeployed==0, commandwindow; end
            eval(['!' jobscripts.push])
        end

        
        [~, result] = system(['cd ' RunArray(ind).ModelDirectory handles.dl ' hg log']);
        [~, names] = regexp(result, 'changeset\:\ +(?<num>[\d]+)[\d\s\:]?', 'tokens', 'names');

        % it also overwrites any local changes made to the working directory,
        % so I am basically assuming I will never make changes there. If I do,
        % I will need to review the workflow with that change in mind. Finally,
        % it also (re)compiles the mechanisms, in case they were changed.

        machrepos(mz).LatestVersion = str2num(names(1).num); %max(str2num([names(:).num]'));
    end
end
catch me
    msgbox('Jobscripts have been created in the jobscript folder but SimTracker could not connect to the supercomputer')
    return
end
save([RunArray(ind).ModelDirectory sl 'results' sl 'machrepos.mat'],'machrepos','-v7.3');


% check if any waiting jobs have different model version or synapses:
if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
    jobscripts.checkruns = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' ./testq '];
    if isdeployed
        fprintf(fidlog,'\nCheck existing runs:\n%s\n', jobscripts.checkruns);
    end
    [sta, myrunstr] = system(jobscripts.checkruns);
elseif divertflag
   jobscripts.checkruns = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' ./testq '];
   fprintf(fidivert,'# %s # run this command separately if you want to check which runs are currently active\n',jobscripts.checkruns);
   myrunstr='';
elseif strcmp(handles.machines(m).Conn,'ssh2')
            saveglobals; %retrieveglobal mypaths
    getresults = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},' ./testq ');
    retrieveglobals;
    myrunstr=getresults{:};
else
    jobscripts.checkruns = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' ./testq '];
    if isdeployed
        fprintf(fidlog,'\nCheck existing runs:\n%s\n', jobscripts.checkruns);
    end
    %[~, myrunstr] = system(jobscripts.checkruns);
    myrunstr='';
    if isdeployed==0, commandwindow; end
    eval(['!' jobscripts.checkruns])
end


myruns = regexp(myrunstr,'\n','split'); % note that you may have to run chmod u+x testq   on the testq script
lr = 1;
%addpath .

runstr={['Your run "' RunArray(ind).RunName '" version ' strtok(RunArray(ind).ModelVerComment,':')  ' conflicts with these queued runs: ']};
for r=1:length(myruns)-2
    idx = searchRuns(RunArray,'RunName',strtrim(myruns{r}),0);
    if ~isempty(idx)
        if ((str2num(strtok(RunArray(ind).ModelVerComment,':')) ~= str2num(strtok(RunArray(idx).ModelVerComment,':'))))
            lr = lr + 1;
            runstr{lr} = [RunArray(idx).RunName ': version ' strtok(RunArray(idx).ModelVerComment,':')];
        end
    end
end

if lr>1
    myquest = questdlg(runstr, 'Run Cross Check', 'Cancel Submission', ' Continue', 'Cancel Submission');
    switch myquest
        case 'Stop Sub'
            return
    end
end

if ispc
    mymodpath=cygwin(RunArray(ind).ModelDirectory);
else
    mymodpath=RunArray(ind).ModelDirectory;
end

if divertflag
     jobtype.putscript = ['scp ' cygwin([RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName '*.* ']) handles.machines(m).Username '@' handles.machines(m).Address ':' jobtype.repos '/jobscripts/'];
    fprintf(fidivert,'%s\n',jobtype.putscript);
elseif strcmp(handles.machines(m).Conn,'ssh2') && (isempty(handles.machines(m).gsi) || handles.general.gsi.flag==0)
    % scp_simple_put(HOSTNAME,USERNAME,PASSWORD,LOCALFILENAME,[REMOTEPATH][LOCALPATH],REMOTEFILENAME)
    myjobfiles={[RunArray(ind).RunName '.sh'],[RunArray(ind).RunName '_run.hoc']};
            saveglobals; %retrieveglobal mypaths
    getresults = scp_simple_put(handles.machines(m).Address,handles.machines(m).Username,pswd{:},myjobfiles,[jobtype.repos  '/jobscripts/'], [strrep(RunArray(ind).ModelDirectory,'\','/') '/jobscripts/']);
    retrieveglobals
    if partofbatch==0 && partOfBatchSquared==0
        retrieveglobals
    end
else
    %jobtype.putscript = sprintf (['printf "lcd %s\n cd %s\n put jobscripts/%s*.* jobscripts/ \n bye" | sftp %s@%s'],...
        %strrep(strrep(RunArray(ind).ModelDirectory,'C:','\cygdrive\c'),'\','/'), jobtype.repos, RunArray(ind).RunName, handles.machines(m).Username,  handles.machines(m).Address);
     jobtype.putscript = ['scp ' cygwin([RunArray(ind).ModelDirectory sl 'jobscripts' sl RunArray(ind).RunName '*.* ']) handles.machines(m).Username '@' handles.machines(m).Address ':' jobtype.repos '/jobscripts/'];
       if isdeployed
            fprintf(fidlog,'\nCopy over files:\n%s\n', jobtype.putscript);
        end
    %[out1 out2]=system(jobtype.putscript);
    if isdeployed==0, commandwindow; end
    eval(['!' jobtype.putscript])
end

% switch the remote repository to the same version as what is specified
% for the run

if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
    jobscripts.push2 = ['cd ' RunArray(ind).ModelDirectory sl 'datasets' handles.dl ' hg push -f ssh://' handles.machines(m).Username '@' handles.machines(m).Address '/' jobtype.repos '/datasets '];
    [~, outstr(length(outstr)+1).results]=system(jobscripts.push2);
    jobscripts.update2 = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' "cd ' jobtype.repos '/datasets; hg update ' handles.general.clean ' -r tip"']; % This returns whether any changes were made,
    [~, outstr(length(outstr)+1).results]=system(jobscripts.update2);
elseif divertflag
    jobscripts.push2 = ['cd ' cygwin([RunArray(ind).ModelDirectory sl 'datasets']) handles.dl ' hg push -f ssh://' handles.machines(m).Username '@' handles.machines(m).Address '/' jobtype.repos '/datasets ; hg update ' handles.general.clean ' -r tip'];
    fprintf(fidivert,'%s\n',jobscripts.push2);
elseif strcmp(handles.machines(m).Conn,'ssh2')
    getresults2 = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' jobtype.repos '/datasets; hg init']);
    retrieveglobals;
    jobscripts.push = ['cd ' RunArray(ind).ModelDirectory sl 'datasets' handles.dl 'hg push -f ssh://' handles.machines(m).Username '@' handles.machines(m).Address '/' jobtype.repos '/datasets'];
    retrieveglobals; %retrieveglobal mypaths
    %eval(['!' jobscripts.push])
    getresults2 = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},['cd ' jobtype.repos '/datasets; hg update ' handles.general.clean ' -r tip']);
    retrieveglobals;
    outstr(length(outstr)+1).results=getresults2{:};
else
    jobscripts.push2 = ['cd ' RunArray(ind).ModelDirectory sl 'datasets' handles.dl ' hg push -f ssh://' handles.machines(m).Username '@' handles.machines(m).Address '/' jobtype.repos '/datasets ; hg update ' handles.general.clean ' -r tip'];
    %[~, outstr(length(outstr)+1).results]=system(jobscripts.push2);
            if isdeployed==0, commandwindow; end
    eval(['!' jobscripts.push2])
    jobscripts.update = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ' "cd ' jobtype.repos '/datasets; hg update ' handles.general.clean ' -r tip"']; % This returns whether any changes were made,
    %[~, outstr(length(outstr)+1).results]=system(jobscripts.update);
            if isdeployed==0, commandwindow; end
    eval(['!' jobscripts.update])
end

% may need to run 'sh checkvercomp.sh' instead of nrnivmodl, to get hg info
if (~isempty(handles.machines(m).gsi) && handles.general.gsi.flag==1)
    if strcmp(handles.machines(m).Nickname,'stampede')==1
        if partofbatch==0 && partOfBatchSquared==0
        jobscripts.submission = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' "cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; sh checkvercomp.sh ; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' "cd ' jobtype.repos '; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    elseif strcmp(handles.machines(m).Nickname,'hpc')==1
        if partofbatch==0 && partOfBatchSquared==0
        jobscripts.submission = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' ". .bash_profile; cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; nrnivmodl ; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' ". .bash_profile; cd ' jobtype.repos '; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    elseif strcmp(handles.machines(m).Nickname,'trestles')==1
        if partofbatch==0 && partOfBatchSquared==0
        jobscripts.submission = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' ". .bashrc ; cd ' jobtype.repos ';  hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':')  '; sh checkvercomp.sh ; ' ... % replaced nrnivmodl with sh checkvercomp.sh
                            handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % /opt/torque/bin/' handles.machines... % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' ". .bashrc ; cd ' jobtype.repos '; ' ...
                            handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % /opt/torque/bin/' handles.machines... % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    else
        if partofbatch==0 && partOfBatchSquared==0    
        jobscripts.submission = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' " cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; nrnivmodl ; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = [handles.machines(m).gsi 'ssh ' handles.machines(m).GSIOpt ' -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' " cd ' jobtype.repos '; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    end
    if isdeployed
        fprintf(fidlog,'\nSubmit job:\n%s\n', jobscripts.submission);
    end
    [~, outstr(length(outstr)+1).results]=system(jobscripts.submission);

    if ~isdeployed
        disp(outstr(end).results)
    else
        fprintf(fidlog,outstr(end).results);
        fclose(fidlog);
    end
elseif strcmp(handles.machines(m).Conn,'ssh2')
    if strcmp(handles.machines(m).Nickname,'stampede')==1
        if partofbatch==0 && partOfBatchSquared==0
        jobscripts.submission = ['cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; sh checkvercomp.sh ; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript]; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = ['cd ' jobtype.repos '; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript]; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    elseif strcmp(handles.machines(m).Nickname,'hpc')==1
        if partofbatch==0 && partOfBatchSquared==0
        jobscripts.submission = ['. .bash_profile; cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; nrnivmodl ; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript]; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = ['. .bash_profile; cd ' jobtype.repos '; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript]; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    elseif strcmp(handles.machines(m).Nickname,'trestles')==1
        if partofbatch==0 && partOfBatchSquared==0
        jobscripts.submission = [' . .bashrc ; cd ' jobtype.repos ';  hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':')  '; nrnivmodl ; ' ... % replaced nrnivmodl with sh checkvercomp.sh % removed export PATH=\$PATH:/opt/rocks/bin ;
                            handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript ]; % /opt/torque/bin/' handles.machines... % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = ['. .bashrc ; cd ' jobtype.repos '; ' ...
                            handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript]; % /opt/torque/bin/' handles.machines... % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    else
        if partofbatch==0  && partOfBatchSquared==0   
        jobscripts.submission = [' cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; nrnivmodl ; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript]; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = [' cd ' jobtype.repos '; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript]; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    end
    if isdeployed
        fprintf(fidlog,'\nSubmit job:\n%s\n', jobscripts.submission);
    end
    if divertflag
        fprintf(fidivert,'%s\n',jobscripts.submission);
    else
        saveglobals; %retrieveglobal mypaths
        outstr(length(outstr)+1).results = ssh2_simple_command(handles.machines(m).Address,handles.machines(m).Username,pswd{:},jobscripts.submission);
        retrieveglobals
        if ~isdeployed
            disp(outstr(end).results{end})
        else
            fprintf(fidlog,'%s\n',outstr(end).results{end});
            fclose(fidlog);
        end
    end

else
    if strcmp(handles.machines(m).Nickname,'stampede')==1
        if partofbatch==0 && partOfBatchSquared==0
        jobscripts.submission = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' "cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; sh checkvercomp.sh ; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' "cd ' jobtype.repos '; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    elseif strcmp(handles.machines(m).Nickname,'hpc')==1
        if partofbatch==0 && partOfBatchSquared==0
        jobscripts.submission = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' ". .bash_profile; cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; nrnivmodl ; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' ". .bash_profile; cd ' jobtype.repos '; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    elseif strcmp(handles.machines(m).Nickname,'trestles')==1
        if partofbatch==0 && partOfBatchSquared==0
        jobscripts.submission = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' ". .bashrc ; cd ' jobtype.repos ';  hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':')  '; sh checkvercomp.sh ; ' ... % replaced nrnivmodl with sh checkvercomp.sh
                            handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % /opt/torque/bin/' handles.machines... % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' ". .bashrc ; cd ' jobtype.repos '; ' ...
                            handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % /opt/torque/bin/' handles.machines... % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    else
        if partofbatch==0     && partOfBatchSquared==0
        jobscripts.submission = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' " cd ' jobtype.repos '; hg update ' handles.general.clean ' -r ' strtok(RunArray(ind).ModelVerComment,':') '; nrnivmodl ; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        else
        jobscripts.submission = ['ssh  -X -Y -t -t ' handles.machines(m).Username '@' handles.machines(m).Address ...
                            ' " cd ' jobtype.repos '; ' ...
                             handles.machines(m).SubCmd ' ./' RunArray(ind).JobScript '"']; % chmod u+x ./jobscripts/' RunArray(ind).RunName '_run.sh;
        end
    end
    if isdeployed
        fprintf(fidlog,'\nSubmit job:\n%s\n', jobscripts.submission);
    end
    %[~, outstr(length(outstr)+1).results]=system(jobscripts.submission);
    if divertflag
        fprintf(fidivert,'%s\n',jobscripts.submission);
    else
    if isdeployed==0, commandwindow; end
    eval(['!' jobscripts.submission])
    end

if ~isempty(outstr) && isfield(outstr,'results')
    if ~isdeployed
        if iscell(outstr(end).results)
            disp(outstr(end).results{:})
        else
            disp(outstr(end).results)
        end
    else
        if iscell(outstr(end).results)
            fprintf(fidlog,outstr(end).results{:});
        else
            fprintf(fidlog,outstr(end).results);
        end
        fclose(fidlog);
    end
end
end
outstat=1;
if ~isempty(outstr) && isfield(outstr,'results')
if iscell(outstr(end).results)
    try
        if ischar(outstr(end).results{:})
            eval(['outstat=' strrep(handles.machines(m).Submitchkr,'string','outstr(end).results{:}') ';'])
        else
            eval(['outstat=' strrep(handles.machines(m).Submitchkr,'string','outstr(end).results{end}') ';'])
        end
    catch
        eval(['outstat=' strrep(handles.machines(m).Submitchkr,'string','outstr(end).results{end}') ';'])
    end
else
    eval(['outstat=' strrep(handles.machines(m).Submitchkr,'string','outstr(end).results') ';'])
end
end

if ismac
jobscripts.push = ['!awk ''{if($0 ~ /remotecmd/) {print "#remotecmd = /opt/rocks/bin/hg"} else {print $0}}'' ' homedir ' > x' handles.dl 'mv x ' homedir ];
else
jobscripts.push = ['!sed "/remotecmd/c  #remotecmd = /opt/rocks/bin/hg" ' homedir ' > x' handles.dl 'mv x ' homedir ];
end

eval(jobscripts.push);

    if divertflag
        fclose(fidivert);
    end


guidata(hObject,handles);
catch ME
    if isdeployed
        docerr(ME)
    else
        for r=1:length(ME.stack)
            disp(ME.stack(r).file);disp(ME.stack(r).name);disp(num2str(ME.stack(r).line))
        end
        throw(ME)
    end
end


function mydisp(mystr)
global logloc
if isdeployed
    if length(mystr)<200
        msgbox(mystr)
    else
        fid = fopen([logloc 'SimTrackerOutput.log'],'a');
        fprintf(fid,'%s\n',mystr);
        fclose(fid);
        system([handles.general.textviewer ' ' logloc 'SimTrackerOutput.log']);
    end
else
    disp(mystr)
end
