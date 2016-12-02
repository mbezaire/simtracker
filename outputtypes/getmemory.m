function h=getmemory(handles,varargin)
global mypath RunArray sl

if isempty(varargin)
    ind = handles.curses.ind;
    filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'topoutput.dat'];
    fid = fopen(filename);
    c=textscan(fid,'%s','Delimiter','\t');
    fclose(fid);

    filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'memory.dat'];
    fid = fopen(filename);
    d=textscan(fid,'%s\t%f\t%d\t%d\n','Delimiter','\t');
    fclose(fid);

    [memstruct, mallstruct]=getmemstruct(c,d);
    
    tmp=upper(deblank(handles.optarg));
    
    if isempty(tmp) || isempty(strmatch(tmp,{'KB','MB','GB','TB'}))
        memsize=questdlg('What units should the result display in?','Memory Units','MB','GB','TB','GB');
    else
        memsize=tmp;
    end

    DivBy=1;
    if strcmp(memsize,'MB')
        DivBy=1024;
    elseif strcmp(memsize,'GB')
        DivBy=1024*1024;
    elseif strcmp(memsize,'TB')
        DivBy=1024*1024*1024;
    end

    h=figure('Color','w');
    legstr={};
    % having trouble with time values that come out of top, so no longer
    % want to use [memstruct(:).seconds] for the x-axis...
    if length([memstruct(:).VIRT])==length([mallstruct(:).swseconds])
        plot([mallstruct(:).swseconds],[memstruct(:).VIRT]./DivBy,'g')
        legstr{length(legstr)+1}='Virtual';
    end
    hold on
    if length([memstruct(:).RES])==length([mallstruct(:).swseconds])
        plot([mallstruct(:).swseconds],[memstruct(:).RES]./DivBy,'b')
        legstr{length(legstr)+1}='Reserved';
    end
    if length([memstruct(:).SHR])==length([mallstruct(:).swseconds])
        plot([mallstruct(:).swseconds],[memstruct(:).SHR]./DivBy,'r')
        legstr{length(legstr)+1}='Shared';
    end

    m = find(strcmp(RunArray(ind).Machine,{handles.machines(:).Nickname})==1);
    if isempty(m)
        mym=inputdlg('What machine did you run this simulation on?');
        m = find(strcmp(mym{:},{handles.machines(:).Nickname})==1);
        if ~isempty(m)
            RunArray(ind).Machine=mym{:};
        else
            msgbox(['Unable to find machine ' mym{:}])
            return;
        end
    end
    coresPERnode=handles.machines(m).CoresPerNode;
    if sum([mallstruct(:).mallinfo])>0
        plot([mallstruct(:).swseconds],[mallstruct(:).mallinfo]./DivBy,'c')
            legstr{length(legstr)+1}='Mallinfo';
        disp([RunArray(ind).RunName ' (' num2str(RunArray(ind).NumProcessors) ' procs)'])
        disp([' per core: ' sprintf('%8.1f',max([mallstruct(:).mallinfo])/DivBy) ' ' memsize])
        disp([' per node: ' sprintf('%8.1f',coresPERnode*max([mallstruct(:).mallinfo])/DivBy) ' ' memsize])
        disp(['  per job: ' sprintf('%8.1f',RunArray(ind).NumProcessors*max([mallstruct(:).mallinfo])/DivBy) ' ' memsize])
    end

    legend(legstr)
    xlabel('Seconds into run')
    ylabel(['Memory (' memsize ')'])
    title(['Rank 0 memory usage by ' RunArray(ind).RunName ' (' num2str(RunArray(ind).NumProcessors) ' procs)'],'Interpreter','none')
else
    for p=1:length(varargin{1})
        ind = varargin{1}(p);
        filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'topoutput.dat'];
        fid = fopen(filename);
        c=textscan(fid,'%s','Delimiter','\t');
        fclose(fid);

        filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'memory.dat'];
        fid = fopen(filename);
        d=textscan(fid,'%s\t%f\t%d\t%d\n','Delimiter','\t');
        fclose(fid);

        [memstruct, mallstruct]=getmemstruct(c,d);
        h(p).memstruct = memstruct;
        h(p).mallstruct = mallstruct;        
    end
end
%subplot(1,2,2)
%                | max VIRT | max RES | max SHR | max MALLINFO |
% per core
% per node
% per job

function [memstruct, mallstruct]=getmemstruct(c,d)
    memstruct=[];
    mallstruct=[];
    fieldlist={'PID','USER','PR','NI','VIRT','RES','SHR','S','perCPU','perMEM','TIMEplus','COMMAND'};
    for r=1:length(c{1})/2
        memstruct(r).step = c{1}{(r-1)*2+1};
        tmp = regexp(c{1}{r*2},' *','split');
        for g=1:length(fieldlist)
            if g>length(tmp)
                memstruct(r).(fieldlist{g}) =  '0';
            else
                memstruct(r).(fieldlist{g}) =  tmp{g};
            end
        end
        %switch length(findstr('00:12:51.06',':'))
        switch length(findstr(memstruct(r).TIMEplus,':'))
            case 2
                mytime = memstruct(r).TIMEplus;
            case 1
                mytime = ['00:' memstruct(r).TIMEplus];
            case 0
                mytime = ['00:00:' memstruct(r).TIMEplus];
            otherwise
                msgbox(['Can''t figure out time for ''' memstruct(r).TIMEplus ''''])
                mytime='00:00:00';
        end
        %mytime = '00:12:51.06';
        memstruct(r).seconds = 86400*mod(datenum(mytime),1);

        % 1 GB = 1048576 KB; 1 MB = 1024 KB
        memfieldlist={'VIRT','RES','SHR'};
        for g=1:length(memfieldlist)
            switch memstruct(r).(memfieldlist{g})(end)
                case 'm'
                    memstruct(r).(memfieldlist{g}) = str2num(memstruct(r).(memfieldlist{g})(1:end-1))*1024; % get into kb (from mb)
                case 'g'
                    memstruct(r).(memfieldlist{g}) = str2num(memstruct(r).(memfieldlist{g})(1:end-1))*1048576; % get into kb (from gb)
                otherwise
                    memstruct(r).(memfieldlist{g}) = str2num(memstruct(r).(memfieldlist{g}));  % assume kb
            end
        end

        numfieldlist={'perCPU','perMEM'};
        for g=1:length(numfieldlist)
            memstruct(r).(numfieldlist{g}) = str2num(memstruct(r).(numfieldlist{g}));
        end
    end

    for r=1:length(d{1})
        mallstruct(r).swseconds = double(d{2}(r));
        mallstruct(r).mallinfo = double(d{3}(r))/1024; % get into kb (from b)
    end

