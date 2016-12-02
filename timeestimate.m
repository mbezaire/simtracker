function varargout=timeestimate(handles,varargin)

global mypath RunArray sl logloc
try

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos') % backupfolder remotebackup


mylist=[];
if isempty(varargin) || isempty(varargin{1})
    z=handles.curses.ind;
else
    z=varargin{1};
    if length(varargin)>1
        mylistA=searchRuns('ModelVerComment',[varargin{2} ':'],0,'*'); 
        mylistB=searchRuns('Machine',RunArray(z).Machine,0,'=');
        mylistC=searchRuns('ExecutionDate','',0,'~');
        mylistD=intersect(mylistA,mylistB);
        mylist=intersect(mylistD,mylistC);
    end
end

if isempty(mylist)
    %mylistA=searchRuns('ModelVerComment','144:',0,'*'); 
    mylistB=searchRuns('Machine',RunArray(z).Machine,0,'=');
    mylistC=searchRuns('ExecutionDate','',0,'~');
    mylistD=searchRuns('RunTime',1,1,'>');
    mylistE=searchRuns('Errors','',0,'=');
    mylistH=searchRuns('RunName',RunArray(z).RunName,0,'~'); %RunArray(z).RunName
    mylistF=intersect(mylistD,mylistE);
    mylistG=intersect(mylistB,mylistC); % intersect(mylistD,mylistC);
    mylistI=intersect(mylistF,mylistG); % intersect(mylistD,mylistC);
    mylist=intersect(mylistH,mylistI); 
end


if isempty(mylist)
    msgbox('Not enough runs to estimate the time');
    return
end

mystr='';
for r=1:length(mylist)
    mystr = [mystr RunArray(mylist(r)).RunName ', ']; %#ok<AGROW>
end
mystr=mystr(1:end-2);

if isdeployed
    fid = fopen([logloc 'SimTrackerOutput.log'],'a');
    fprintf(fid,'%s\n',['Runs included: ' mystr]);
    fclose(fid);
else
    disp(['Runs included: ' mystr])
end

        
getruntimes(handles.btn_generate,handles,mylist)

handles=guidata(handles.btn_generate);

% For selected runs, come up with linear fits:
% - setup time: num processors total
x = [RunArray(mylist(:)).NumProcessors];
y=zeros(length(handles.curses.times),1);
for r=1:length(handles.curses.times)
    y(r)=handles.curses.times(r).setup.tot;
end


MYx = RunArray(z).NumProcessors;
[x si]=sort(x);
y=y(si);
yy=diff(y);
xx=diff(x);

if sum(xx)>0
    try
    addme = min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y));
    MYsetup = (MYx-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y)+max([addme 0]);
    catch
    addme = min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y));
    MYsetup = (MYx-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y)+max([addme 0]);
    end
else
    addme=0;
    MYsetup = mean(y);
end

% - creation time: num cells
x = [RunArray(mylist(:)).NumCells];
y=zeros(length(handles.curses.times),1);
for r=1:length(handles.curses.times)
    y(r)=handles.curses.times(r).create.tot;
end

MYx = RunArray(z).NumCells;
[x si]=sort(x);
y=y(si);
yy=diff(y);
xx=diff(x);
if sum(xx)>0
    try
addme = min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y));
MYcreate = (MYx-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y)+max([addme 0]);
    catch
addme = min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y));
MYcreate = (MYx-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y)+max([addme 0]);
    end
else
    addme=0;
MYcreate = mean(y);
end

% - connection time: conndata/scale (projected conns)
totcons=zeros(length(mylist),1);
for r=1:length(mylist)    
    fid = fopen([myrepos(q).dir sl 'datasets' sl 'conndata_' num2str(RunArray(mylist(r)).ConnData) '.dat'],'r');                
    numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
    filedata = textscan(fid,'%s %s %f %f %f\n') ;
    fclose(fid);
    mdx=filedata{3}~=0 & filedata{5}~=0;

    totcons(r)=sum(filedata{4}(mdx))/RunArray(mylist(r)).Scale;
end
x = totcons;
y=zeros(length(handles.curses.times),1);
for r=1:length(handles.curses.times)
    y(r)=handles.curses.times(r).connect.tot;
end


fid = fopen([myrepos(q).dir sl 'datasets' sl 'conndata_' num2str(RunArray(z).ConnData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);
mdx= filedata{3}~=0 & filedata{5}~=0;

MYtotcons = sum(filedata{4}(mdx))/RunArray(z).Scale;
[x si]=sort(x);
y=y(si);
yy=diff(y);
xx=diff(x);
if sum(xx)>0
    try
addme = min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y));
MYconnect = (MYtotcons-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y)+max([addme 0]);
    catch
addme = min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y));
MYconnect = (MYtotcons-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y)+max([addme 0]);
    end
else
    addme=0;
MYconnect = mean(y);
end

% - sim time: proj steps * proj conns
x = [RunArray(mylist(:)).SimDuration]./[RunArray(mylist(:)).TemporalResolution].*totcons';
y=zeros(length(handles.curses.times),1);
for r=1:length(handles.curses.times)
    y(r)=handles.curses.times(r).run.tot;
end

MYx = RunArray(z).SimDuration/RunArray(z).TemporalResolution*MYtotcons;
[x si]=sort(x);
y=y(si);
yy=diff(y);
xx=diff(x);

if sum(xx)>0
    try
addme = 0; % min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y));
MYsim = (MYx-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y)+max([addme 0]);
    catch
addme = min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y));
MYsim = (MYx-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y)+max([addme 0]);
    end
else
    addme=0;
    MYsim = mean(y);
end


% - write time: RunTime - avg of all other steps, a function of proj conns
% and also of num procs
x = [RunArray(mylist(:)).SimDuration]./[RunArray(mylist(:)).TemporalResolution].*totcons';
y=zeros(length(handles.curses.times),1);
for r=1:length(handles.curses.times)
    y(r) = RunArray(mylist(r)).RunTime*RunArray(mylist(r)).NumProcessors-(handles.curses.times(r).run.tot+handles.curses.times(r).connect.tot+handles.curses.times(r).create.tot+handles.curses.times(r).setup.tot);
end

MYx = RunArray(z).SimDuration/RunArray(z).TemporalResolution*MYtotcons;
[x si]=sort(x);
y=y(si);
yy=diff(y);
xx=diff(x);

if sum(xx)>0
    try
addme = min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y));
MYwrite = (MYx-mean(x))*mean(yy(xx~=0)./xx(xx~=0)')+mean(y)+max([addme 0]);
    catch
addme = min(y) -  ((min(x)-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y));
MYwrite = (MYx-mean(x))*mean(yy(xx~=0)./xx(xx~=0))+mean(y)+max([addme 0]);
    end
else
    addme=0;
MYwrite = mean(y);
end

total=max(0,MYsim)+max(0,MYconnect)+max(0,MYcreate)+max(0,MYsetup)+max(0,MYwrite);

if nargout>0
    extramargin=1.3;
    varargout{1}=max((total/RunArray(z).NumProcessors)*extramargin/3600,.25); % in terms of hours
else
    % Add all these times together, divide by number of processors
    mystr={['Estimated time for ' RunArray(z).RunName ' with ' num2str(RunArray(z).NumProcessors) ' processors:'], ...
    ['Setup: ' num2str(MYsetup/RunArray(z).NumProcessors) ' s'], ...
    ['Create: ' num2str(MYcreate/RunArray(z).NumProcessors) ' s'], ...
    ['Connect: ' num2str(MYconnect/RunArray(z).NumProcessors) ' s'], ...
    ['Simulate: ' num2str(MYsim/RunArray(z).NumProcessors) ' s'], ...
    ['Write: ' num2str(MYwrite/RunArray(z).NumProcessors) ' s'], ...
    ['Total: ' num2str(total/RunArray(z).NumProcessors) ' s  (' num2str(total/RunArray(z).NumProcessors/3600) ' hours)']};
    if ~isempty(RunArray(z).RunTime) && RunArray(z).RunTime>0
        mydiff=round(((total/RunArray(z).NumProcessors-RunArray(z).RunTime)/RunArray(z).RunTime)*100);
        compstr='more';
        if mydiff<0
            compstr='less';
        end
        mystr{length(mystr)+1}=['Actual time: ' num2str(RunArray(z).RunTime) ' s (Estimate was ' num2str(mydiff) '% ' compstr ' than actual)'];
    end
    
    if isdeployed
        fid = fopen([logloc 'SimTrackerOutput.log'],'a');
        fprintf(fid,'%s\n',mystr);
        fclose(fid);
        system([handles.general.textviewer ' SimTrackerOutput.log']);
    else
        disp(mystr')
    end
end
catch ME
    handleME(ME)
end


function handleME(ME)
    if isdeployed
        docerr(ME)
    else
        for r=1:length(ME.stack)
            disp(ME.stack(r).file);disp(ME.stack(r).name);disp(num2str(ME.stack(r).line))
        end
        throw(ME)
    end
    
function docerr(ME)
global logloc
fid = fopen([logloc 'SimTrackerOutput.log'],'a');
fprintf(fid,'%s\n',ME.identifier);
fprintf(fid,'%s\n\n',ME.message);
for r=1:length(ME.stack)
    fprintf(fid,'%s\n\t%s\n\t%g\n\n', ME.stack(r).file, ME.stack(r).name, ME.stack(r).line);
end
fclose(fid);

%msgbox(ME.identifier)
errordlg(ME.message)
%for r=1:length(ME.stack)
%    msgbox({ME.stack(r).file,ME.stack(r).name,num2str(ME.stack(r).line)})
%end