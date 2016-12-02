function [vars2changeOut, mymatOut, runnamesOut]=paramsearchtool(listOparams,varargin)
global mypath %h hc hr hu rows columns

% Any variables declared here will be accessible to the callbacks
% Initialize output
vars2changeOut = {};
mymatOut = [];
runnamesOut = {};

% Initialize newVariable
vars2change = {};
mymat = [];
runnames = {};
dt = [];
dd = [];
testy=[];

if ~isempty(varargin)
    dd=figure();
    dt=uitable('Parent',dd,'RowName',listOparams,'ColumnName',{'Ch?'},'Data',repmat({false},length(listOparams),1),'ColumnFormat',{'logical'},'ColumnEditable',true);
    pos=get(dt,'Position');
    uicontrol('Parent',dd,'style','pushbutton','String','Ok','Callback',{@updateparamlist},'Position',[pos(1) pos(2)+pos(4)*1.05 pos(3)*.25 pos(3)*.1]);
    uiwait(dd);
end

    function updateparamlist(~,~,~)
            listOparams=listOparams(cell2mat(get(dt,'data')));
            delete(dd)
    end


columns=listOparams(1:end-1);

rows=fliplr(listOparams(2:end));
hu=[];
ht=[];
hc=[];
hr=[];
testy=[];

tw = min(.7/(length(rows)+1),.2);
th = min(.8/(length(columns)+1),.2);

h(1)=figure('Name','Param Search Tool');

for r=1:length(rows)
    hr(r)=uicontrol(h(1),'style','text','String',rows{r},'Units','normalized','Position',[.2+r*(tw*1.1)  .9-th  tw  th]);
end

handles=guidata(h(1));
handles.listOparams=listOparams;
guidata(h(1),handles);

for c=1:length(columns)
    hc(c)=uicontrol(h(1),'style','text','String',columns{c},'Units','normalized','Position',[.2-(tw*1.1)  .8-(c)*(th*1.1)  tw  th]);
    for r=1:length(rows)
        if (c+r)<=length(listOparams)
            hu(r,c)=uicontrol(h(1),'style','toggle','Callback',{@setparallel},'String','Parallel','Units','normalized','Position',[.2+r*(tw)  .8-(c)*(th)  tw  th]);
        else
            hu(r,c)=NaN;
        end
    end
end

h(3)=uicontrol(h(1),'style','pushbutton','Callback',{@confirmarrang},'String','Go','Units','normalized','Position',[.1  .9  .05  .05]);


    function confirmstuff()
        if ispc
            sl='\';
        else
            sl='/';
        end
        
        load([mypath sl 'data' sl 'parameters.mat'],'parameters')

        
        runnames = {};
        
        for t=1:length(ht)
            ps(t).pars=get(ht(t),'RowName');
            ps(t).data=get(ht(t),'Data');
            ps(t).numvals=size(ps(t).data,2)-1;
            ps(t).numvars=length(ps(t).pars);
        end
        vecnumvals=[ps.numvals];
        
        numruns=prod(vecnumvals);
        numvars=sum([ps.numvars]);
        mymat=zeros(numruns,numvars)*NaN;
        myindmat=zeros(numruns,numvars)*NaN;
        
        vars2change={};
        curcol=0;
        for t=1:length(ps)
            for p=1:length(ps(t).pars)
                vars2change{end+1}=ps(t).pars{p};
                if isnumeric(ps(t).data{p,2})
                    myvals=[ps(t).data{p,2:end}];
                else
                    myvals=str2num(char(ps(t).data{p,2:end}));
                end
                curcol=curcol+1;
                
                tmp=repmat(myvals(:)',prod(vecnumvals(t+1:end)),prod(vecnumvals(1:t-1)));
                mymat(:,curcol)=tmp(:);
                tmpind=repmat(1:length(myvals)',prod(vecnumvals(t+1:end)),prod(vecnumvals(1:t-1)));
                myindmat(:,curcol)=tmpind(:);
            end
        end
        
        if size(mymat,2)==size(unique(mymat,'rows'),2)
            disp('ok!')
        else
            disp('not ok!')
        end
        
        
        tmpstr=regexp(get(h(7),'String'),'([^(^)]+)','match'); % 'mytesty(#RipStim)ci($DegreeStim)Hz_($hblock*100)_(#Ind)'
        
       fmstr='';
       myargs='';
       if iscell(tmpstr)
            for t=1:length(tmpstr)
                if strcmpi(tmpstr{t},'#ind')==1
                    fmstr= [fmstr  '%03d'];
                    myargs=[myargs 'm,'];
                    continue
                end
                switch tmpstr{t}(1)
                    case '$'
                        perind=strfind(tmpstr{t},'%');
                        if ~isempty(perind)
                            perstuff=tmpstr{t}(perind:end);
                            tmpstr{t}=tmpstr{t}(2:perind-1);
                        else
                            perstuff='';
                            tmpstr{t}=tmpstr{t}(2:end);
                        end
                        mathstuff='';
                        myi=regexp(tmpstr{t},'[\^/*+-]+');
                        if ~isempty(myi)
                            mathstuff=tmpstr{t}(myi(1):end);
                            tmpstr{t}=tmpstr{t}(1:myi(1)-1);
                        end
                        if isempty(perstuff)
                            bb=strmatch(tmpstr{t},{parameters.name});
                            if isempty(bb)
                                perstuff='%d';
                            else
                                perstuff=parameters(bb).format;
                            end
                        end
                        fmstr= [fmstr  perstuff];
                        myi=strmatch(tmpstr{t},vars2change,'exact');
                        myargs=[myargs 'mymat(m,' num2str(myi) ')' mathstuff ','];
                    case '#'
                        fmstr= [fmstr  '%03d'];
                        myi=strmatch(tmpstr{t}(2:end),vars2change,'exact');
                        myargs=[myargs 'myindmat(m,' num2str(myi) '),'];
                    otherwise
                        fmstr= [fmstr  tmpstr{t}];
                end
            end
        else
            fmstr=tmpstr;
        end
                
        for m=1:size(mymat,1)
            enterargs=eval(['{' myargs(1:end-1) '}']);
            runnames{m}=sprintf(fmstr,enterargs{:});
        end
        if length(runnames)~=length(unique(runnames))
            disp('run names not unique, adding ind at end')
            for m=1:length(runnames)
                runnames{m}=[runnames{m} '_' sprint('%03d',m)];
            end
        end
    end

    function setparallel(hObject,~,handles)
        %global hu listOparams rows columns testy
        
        tmplist=listOparams;
        
        testy=struct([]);
        
        
        nextgroupnum=0;
        while ~isempty(tmplist)
            if ~isfield(testy,tmplist{end}) || isempty(testy(1).(tmplist{end}))
                flag=0;
                r=strmatch(tmplist{end},rows,'exact');
                if ~isempty(r)
                    for c=1:length(columns)
                        if ~isnan(hu(r,c)) && get(hu(r,c),'Value')
                            if ~isfield(testy,columns{c}) || isempty(testy(1).(columns{c}))
                                nextgroupnum=nextgroupnum+1;
                                testy(1).(rows{r})=nextgroupnum;
                                testy(1).(columns{c})=nextgroupnum;
                                flag=1;
                            else
                                testy(1).(rows{r})=testy(1).(columns{c});
                                flag=1;
                            end
                        end
                    end
                end
                c=strmatch(tmplist{end},columns,'exact');
                if ~isempty(c)
                    for r=1:length(rows)
                        if ~isnan(hu(r,c)) && get(hu(r,c),'Value')
                            if ~isfield(testy,rows{r}) || isempty(testy(1).(rows{r}))
                                nextgroupnum=nextgroupnum+1;
                                testy(1).(rows{r})=nextgroupnum;
                                testy(1).(columns{c})=nextgroupnum;
                                flag=1;
                            else
                                testy(1).(columns{c})=testy(1).(rows{r});
                                flag=1;
                            end
                        end
                    end
                end
                if flag==0
                    nextgroupnum=nextgroupnum+1;
                    testy(1).(tmplist{end})=nextgroupnum;
                end
            end
            tmplist(end)=[];
        end
    end

    function confirmarrang(hObject,~,handles)
        fl=0;
        while isempty(testy) && fl<3
            setparallel()
            fl=fl+1;
        end
        dr=fieldnames(testy);
        
        for d=1:length(dr)
            groups(d)=testy.(dr{d});
        end
        numpargroups=max(groups);
        
        h(4)=figure('Name','Confirm Dimensions','Units','normalized','CloseRequestFcn',@closefunction);
        lastposhgt=.1;
        marg = .04;
        for t=1:numpargroups
            ht(t)=uitable(h(4),'RowName',dr(groups==t),'Data',repmat({''},length(dr(groups==t)),1),'ColumnFormat',{'char'},'ColumnEditable',true,'ColumnName',{'Value Vec 2 Expand'},'Units','Normalized','Position',[.1 lastposhgt  .8  .2]);
            gex=get(ht(t),'Extent');
            set(ht(t),'Position',[.1 lastposhgt  .8  gex(4)*1.3]);
            uicontrol('style','text','Parent',h(4),'String',['Group ' num2str(t)],'Units','normalized','Position',[.1 lastposhgt+gex(4)*1.3+.01 .1 .03])
            lastposhgt = lastposhgt + gex(4)*1.3 + marg;
            if t<numpargroups
                uicontrol(h(4),'style','text','String',' X ','Units','Normalized','Position',[.1 lastposhgt  .8  .04])
                lastposhgt = lastposhgt + .04 + marg;
            end
        end
        h(5)=uicontrol('style','pushbutton','String','Expand','Units','Normalized','Position',[.1 lastposhgt .2 .05],'Callback',{@expandstuff});
        h(6)=uicontrol('style','pushbutton','String','Confirm','Units','Normalized','Position',[.35 lastposhgt .2 .05],'Callback',{@done});
        h(7)=uicontrol('style','edit','String','template($ParameterName)','Units','Normalized','Position',[.6 lastposhgt .35 .05]);
        uicontrol('style','text','String',{'RunName pattern:','Enter ($ParameterName) for values and (#ParameterName) or (#Ind) for indices.'},'HorizontalAlignment','left','Units','Normalized','Position',[.6 lastposhgt+.1 .35 .1]);
        
        set(h(7),'Units','inches');
        pos=get(h(7),'Position');
        set(h(7),'Units','normalized');
        set(h(4),'Units','inches')
        posf=get(h(4),'Position');
        % for t=1:numpargroups
        %     set(ht(t),'Units','inches');
        % end
        set(h(4),'Position',[4 2  posf(3) pos(2)+pos(4)+.1]);
        set(h(4),'Units','normalized');
        
        set(h(1),'Visible','off')
    end


    function expandstuff(hObject,~,handles)
        
        for t=1:length(ht)
            pars=get(ht(t),'RowName');
            data=get(ht(t),'Data');
            colstr={};
            for p=1:length(pars)
                if ~isempty(data{p,1})
                    valarray = eval(data{p,1});
                    for v=1:length(valarray)
                        data{p,v+1}=valarray(v);
                    end
                end
            end
            colstr{1}='Orig';
            for d=2:size(data,2)
                colstr{d}=['#' num2str(d-1)];
            end
            set(ht(t),'Data',data,'ColumnName',colstr);
        end
    end

    function closefunction(~,~,~)
        % This callback is executed if the user closes the gui
        confirmstuff()
        % Assign Output
        vars2changeOut = vars2change;
        mymatOut = mymat;
        runnamesOut = runnames;
        % Close figure
        delete(h(4)); % close GUI
        delete(h(1)); % close GUI
    end

    function done(~,~,~)
        try
        confirmstuff()
        % Assign Output
        vars2changeOut = vars2change;
        mymatOut = mymat;
        runnamesOut = runnames;
        % Close figure
        delete(h(4)); % close GUI
        delete(h(1)); % close GUI
        catch ME
            handleME(ME)
        end
    end

% Pause until figure is closed ---------------------------------------%
waitfor(h(1));
end

