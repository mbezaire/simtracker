function fielddata(handles,varargin)
% This function updates the data in the form view, within the uicontrols
% except tables, to the data for the selected run

global mypath RunArray sl

try
ind = handles.curses.ind;
if isempty(ind)
    return
end


set(handles.txt_RunName,'string',{RunArray(ind).RunName})
set(handles.txt_ModelVerComment,'string',{RunArray(ind).ModelVerComment})

set(handles.txt_RunComments,'string',RunArray(ind).RunComments)

try
    idx=find(strncmp(RunArray(ind).Errors,cellstr(get(handles.txt_error,'String')),length(RunArray(ind).Errors))==1);
    set(handles.txt_error,'Value',idx(1))
catch ME %#ok<NASGU>
    contents = get(handles.txt_error,'String');
    contents{length(contents)+1}=RunArray(ind).Errors;
    set(handles.txt_error,'String',contents)
    set(handles.txt_error,'Value',length(contents))
    load([mypath sl 'data' sl 'MyOrganizer.mat'],'myerrors','-append')
    r=length(myerrors)+1;
    myerrors(r).category='Unknown';
    myerrors(r).errorphrase=RunArray(ind).Errors;
    myerrors(r).description='Unknown';
    save([mypath sl 'data' sl 'MyOrganizer.mat'],'myerrors','-append')
    msgbox('Error value disappeared so added back in here')
end

setmachinemenu(handles,0,ind)

q=getcurrepos(handles,varargin);

if ~isempty(q)
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos') 

    updatemenu(myrepos(q).dir,sl,handles,0,'stim','stimulation','stimulation',ind,'Stimulation')
    updatemenu(myrepos(q).dir,sl,handles,0,'conn','connectivity','connections',ind,'Connectivity')

    setvaldatasets(handles,ind,sl,myrepos(q).dir,'datasets','cells','NumData','numdata')
    setvaldatasets(handles,ind,sl,myrepos(q).dir,'datasets','conns','ConnData','conndata')
    setvaldatasets(handles,ind,sl,myrepos(q).dir,'datasets','syns','SynData','syndata')
else
    set(handles.menu_stim,'Style','text','String', RunArray(ind).Stimulation)
    set(handles.menu_conn,'Style','text','String', RunArray(ind).Connectivity)
    set(handles.menu_numdata,'Style','text','String', num2str(RunArray(ind).NumData))
    set(handles.menu_conndata,'Style','text','String', num2str(RunArray(ind).ConnData))
    set(handles.menu_syndata,'Style','text','String', num2str(RunArray(ind).SynData))
end

set(handles.edit_numprocs,'String',num2str(RunArray(ind).NumProcessors));
catch ME
    handleME(ME)
end