function NewRepos(hObject, eventdata, handles,varargin) 
% This function starts a new SimTracker repository in an already created folder
global mypath RunArray sl logloc

if ~isempty(RunArray)
    saveRuns(handles) % Save the current runs (in the now "old" repository)
end

% Load the list of repositories, add a new one, and resave the updated list
q=getcurrepos(handles,1);

if exist([mypath sl 'data' sl 'myrepos.mat'],'file')
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
end

if exist('myrepos','var') && ~isempty(q)
    prevdir=myrepos(q).dir; %#ok<NODEF>
else
    prevdir = GetSimStorageFolder();%GetExecutableFolder();
end

% Choose a new repository (dialog box starts from existing repository)
if isempty(varargin) || strcmp(varargin{1},'Don''t Download')==1
folder_name = uigetdir(prevdir,'Choose directory where model repository code is stored');
else 
folder_name = [prevdir sl varargin{1}];
end


if isempty(folder_name) || strcmp(folder_name,'0')==1 || (ischar(folder_name)==0 && folder_name==0)
    msgbox('Incorrect folder choice')
    return
end

g=strfind(folder_name,sl);

if exist('myrepos','var') && sum(strcmp(folder_name(g(end)+1:end),{myrepos(:).name}))>0
    r=find(strcmp(folder_name(g(end)+1:end),{myrepos(:).name})==1);
    if myrepos(r).current==1
        return % If the current repository was already selected, stop here
    end
    if strcmp(myrepos(r).dir,folder_name)==1
        btn=questdlg({'Repository already known.','Update to that repository?'},'Prompt','Yes','No','Yes');
        switch btn
            case 'Yes' % Switch to already known repository
                for g=1:length(myrepos)
                    myrepos(g).current=0; %#ok<AGROW>
                end
                myrepos(r).current=1;
            case 'No' % Don't switch to already known repository
                return
        end
    else
        msgbox('Repository name already in use; rename the folder before adding.')
        return
    end
else
    % check the repository to make sure it has the necessary structure, if
    % not then create the folders and msgbox to add files, except if there
    % are no cells. Then ask to have some cells made first.
    instructions={};
    pullfilesflag=[];
    if exist(folder_name,'dir')==0
        mkdir(folder_name);
    end
    if numel(dir(folder_name))<3 % empty directory
        if isempty(varargin)
            myans=questdlg('Your directory is empty. Would you like to download a sample model repository?','Download sample repository?','ringdemo','ca1','Don''t Download','ringdemo');
        else
            myans=varargin{1};
        end
        if strcmp(myans,'Don''t Download')==1
            pullfilesflag=1;
        else
            [r, details]=system(['cd ' folder_name ' ' handles.dl ' hg init']);
            fid=fopen([logloc 'SimTrackerOutput.log'],'a');
            fprintf(fid,'%s\n\n',details);
            if r==0
                pullINrepo=['cd ' folder_name ' ' handles.dl  ' hg pull https://bitbucket.org/mbezaire/' myans ' ' handles.dl 'hg update tip'];
                [~, s]=system(pullINrepo);
                try
                    mkdir([folder_name sl 'datasets'])
                    pullINrepo=['cd ' folder_name sl 'datasets ' handles.dl ' hg init' handles.dl  ' hg pull https://bitbucket.org/mbezaire/' myans 'datasets ' handles.dl 'hg update tip'];
                    [~, s2]=system(pullINrepo);
                end
            else
                % add  --ignore-existing  flag to rsync to prevent overwriting
                % of existing files. But then there is a danger of the skeleton
                % files not all working together due to different versions.
                %if ismac
                    websave([folder_name sl 'tip.gz'],['http://bitbucket.org/mbezaire/' myans '/get/tip.gz']);
                    [r, s]=system(['cd ' folder_name ' ' handles.dl ' tar -xzf tip.gz ' handles.dl ' rsync -a mbezaire-' myans '-*/* ./ ' handles.dl ' rm -r mbezaire-' myans '-*/ ' handles.dl ' rm tip.gz']);
                     try
                        mkdir([folder_name sl 'datasets'])
                         websave([folder_name sl 'tip.gz'],['http://bitbucket.org/mbezaire/' myans 'datasets/get/tip.gz']);
                        [r, s2]=system(['cd ' folder_name sl 'datasets ' handles.dl ' tar -xzf tip.gz ' handles.dl ' rsync -a mbezaire-' myans '-*/* ./ ' handles.dl ' rm -r mbezaire-' myans '-*/ ' handles.dl ' rm tip.gz']);
                     end
                   %fprintf(fid,'%s\n\n',['cd ' folder_name ' ' handles.dl ' curl -LO http://bitbucket.org/mbezaire/' myans '/get/tip.gz ' handles.dl ' tar -xzf tip.gz ' handles.dl ' rsync -a mbezaire-' myans '-*/* ./ ' handles.dl ' rm -r mbezaire-' myans '-*/ ' handles.dl ' rm tip.gz']);
%                 else
%                     [r, s]=system(['cd ' folder_name ' ' handles.dl ' wget www.bitbucket.org/mbezaire/' myans '/get/tip.gz ' handles.dl ' tar -xzf tip.gz ' handles.dl ' rsync -a mbezaire-' myans '-*/* ./ ' handles.dl ' rm -r mbezaire-' myans '-*/ ' handles.dl ' rm tip.gz']);
%                 end
            end
            fprintf(fid,'%s\n%s\n\n',s,s2);
            fclose(fid);
            pullfilesflag=0;
        end
    else
    end
    folders2add={'cells','cellclamp_results','jobscripts','results','datasets','setupfiles','connectivity'};
    for zz=1:length(folders2add)
        if exist([folder_name sl folders2add{zz}],'dir')==0
            mkdir([folder_name sl folders2add{zz}])
        end
    end
    
    if isempty(pullfilesflag)
        myans=questdlg('Download setup files for repository or do you already have them?','Download necessary files?','Download','Already have','Download');
        if strcmp(myans,'Download')==1
            pullfilesflag=1;
        else
            pullfilesflag=0;
        end
    end
    
    if pullfilesflag
        [r, ~]=system(['cd ' folder_name ' ' handles.dl ' hg init']);
        if r==0
            pullINrepo=['hg init ' handles.dl ' hg pull https://bitbucket.org/mbezaire/reposkel ' handles.dl 'hg update tip'];
            system(pullINrepo);
        else
            % add  --ignore-existing  flag to rsync to prevent overwriting
            % of existing files. But then there is a danger of the skeleton
            % files not all working together due to different versions.
            websave([folder_name sl 'tip.gz'],['http://bitbucket.org/mbezaire/reposkel/get/tip.gz']);
            system(['cd ' folder_name ' ' handles.dl ' tar -xzf tip.gz ' handles.dl ' rsync -a mbezaire-reposkel-*/* ./ ' handles.dl ' rm -r mbezaire-reposkel-*/ ' handles.dl ' rm tip.gz'])
        end
    else
        ishoc=1;
        if ~isempty(dir([folder_name sl '*.py']))
            ishoc=0;
        end
        if exist([folder_name sl 'setupfiles' sl 'clamp'],'dir')==0
            mkdir([folder_name sl 'setupfiles' sl 'clamp'])
        end
        if isempty(dir([folder_name sl 'setupfiles' sl 'clamp' sl '*.*']))
            instructions{length(instructions)+1}='Please download the files to be included in the ''clamp'' folder''.';
        end
        if ishoc
            if isempty(dir([folder_name sl 'setupfiles' sl 'parameters.hoc']))
                instructions{length(instructions)+1}='In the SimTracker, choose the Settings>Parameters menu option to create a parameters file';
            end
            if isempty(dir([folder_name sl 'setupfiles' sl 'defaultvar.hoc']))
                websave([folder_name sl 'setupfiles' sl 'defaultvar.hoc'],['http://bitbucket.org/mbezaire/reposkel/src/tip/setupfiles/defaultvar.hoc']);
            end
            if isempty(dir([folder_name sl 'setupfiles' sl 'defaultvar.hoc']))
                instructions{length(instructions)+1}='Please download the ''defaultvar.hoc'' file and include it in the ''setupfiles'' folder';
            end
        end
        %filestocheck={'ranstream.hoc','CellCategoryInfo.hoc','set_other_parameters.hoc','load_cell_category_info.hoc'};
        if exist([folder_name sl 'stimulation'],'dir')==0
            mkdir([folder_name sl 'stimulation'])
        end
        if isempty(dir([folder_name sl 'stimulation' sl '*_stimulation.hoc']))
            websave([folder_name sl 'stimulation' sl 'spontaneous_stimulation.hoc'],['http://bitbucket.org/mbezaire/reposkel/src/tip/stimulation/spontaneous_stimulation.hoc']);
        end
        if isempty(dir([folder_name sl 'stimulation' sl '*_stimulation.hoc']))
            instructions{length(instructions)+1}='Create at least one file named ''[name]_stimulation.hoc'' with NEURON code to apply stimulation to your model';
        end
        [st,~]=system(['hg --cwd ' folder_name ' root']);
        if st~=0
            system(['cd ' folder_name ' ' handles.dl ' hg init'])
        end
        if exist([folder_name sl '.hgignore'],'file')==0
            fid = fopen([folder_name sl '.hgignore'],'w');
            fprintf(fid,'syntax:glob\nresults/*\ncellclamp_results/*\nnetworkclamp_results/*\n*.c\n*.o\n*.dll\nx86_64/*');
            fclose(fid);
            system(['cd ' folder_name ' ' handles.dl ' hg add .hgignore'])
        end
    end
    if ishoc
        if isempty(dir([folder_name sl 'cells' sl 'class_*.hoc']))
            websave([folder_name sl 'cells' sl 'class_ppstim.hoc'],['https://bitbucket.org/mbezaire/reposkel/src/tip/cells/class_ppspont.hoc']);
        end
        if isempty(dir([folder_name sl 'cells' sl 'class_*.hoc']))
            instructions{length(instructions)+1}='Please add at least one cell template to the ''cells'' directory, named ''class_[celltype].hoc''.';
        end
    end
    if isempty(dir([folder_name sl 'datasets' sl '*.dat']))
        instructions{length(instructions)+1}='In the SimTracker, use the options in the Tools menu to create sets of cells, connections, and synapse properties';
    end
    if exist([folder_name sl 'cells' sl 'axondists'],'dir')==0
        mkdir([folder_name sl 'cells' sl 'axondists'])
    end 

    if exist('myrepos','var')
        r=length(myrepos)+1;
    else
        r=1;
    end
    myrepos(r).name = folder_name(g(end)+1:end);
    myrepos(r).dir = folder_name;
    myrepos(r).current=1;

    set(handles.txt_datalabel,'String',['Current Directory: ' myrepos(r).dir])
    myex=get(handles.txt_datalabel,'Extent');
    mypos=get(handles.txt_datalabel,'Position');
    fl=0;
    while myex(3)>mypos(3)
        tmp=get(handles.txt_datalabel,'String');
        set(handles.txt_datalabel,'String',['Current Directory: ...' tmp(25:end)])
        myex=get(handles.txt_datalabel,'Extent');
        fl=fl+1;
    end
    if ~isempty(instructions)
        fid = fopen([folder_name sl 'instructions.txt'],'w');
        fprintf(fid,'INSTRUCTIONS FOR PREPARING YOUR NEW REPOSITORY:\n');
        for inst=1:length(instructions)
            fprintf(fid,'%d. %s\n', inst, instructions{inst});
        end
        fprintf(fid,'%d. %s\n', length(instructions)+1, 'In the terminal, use ''hg add'' to start tracking any newly created files in your Mercurial repository, and then when done adding files, use ''hg commit'' to save your model code version');
        fclose(fid);
        system([handles.general.textviewer ' ' folder_name sl 'instructions.txt']);
    end
    for q=1:r-1
        myrepos(q).current=0; %#ok<AGROW>
    end    
end

if exist([mypath sl 'data' sl 'myrepos.mat'],'file')
    save([mypath sl 'data' sl 'myrepos.mat'],'myrepos','-append')
else
    save([mypath sl 'data' sl 'myrepos.mat'],'myrepos','-v7.3')
end

% Check to ensure there is a Mercurial repository
[~, myresult]=system(['cd ' myrepos(r).dir handles.dl ' hg parent']);

if  ~isempty(strfind(myresult,'abort')) && ~isempty(strfind(myresult,'found'))
    msgbox('Please create a Mercurial repository in this directory.')
    system([handles.general.explorer ' ' myrepos(r).dir])
end

d=dir([myrepos(r).dir sl 'results']);

if isempty(d) || sum([d(:).isdir])==0
    system(['mkdir ' myrepos(r).dir sl 'results'])
end

RunArray=[]; % Clear the RunArray to start fresh
handles.curses=[];handles.curses.ind=0; guidata(handles.list_view,handles)
set(handles.tbl_runs,'Data',[])

handles.parameters=switchSimRun({myrepos.dir},myrepos(r).dir);
guidata(hObject, handles); % resave the handles


% If data already exists in this repository, load it
if exist([myrepos(r).dir sl 'results' sl 'RunArrayData.mat'],'file')
    load([myrepos(r).dir sl 'results' sl 'RunArrayData.mat'])
end
x = mystrfind(get(handles.list_view,'String'),'All');
set(handles.list_view,'Value',x)
RefreshList(handles.list_view, [], handles)
set(handles.txt_datalabel,'String',['Current Directory: ' myrepos(r).dir])
msgbox('Your repository has been created and registered with SimTracker.')
