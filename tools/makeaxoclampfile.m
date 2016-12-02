function makeaxoclampfile(varargin) % cellclamppath, results2use, cellfilespath, websitepath
global mypath sl 
if isempty(sl)
if ispc
    sl = '\';
else
    sl = '/';
end
end
if ~isempty(varargin)
    cellclamppath = varargin{1}; %[varargin{1} sl 'cellclamp_results'];
    if length(varargin)>1
        results2use = varargin{2};
    else
        zz = dir(cellclamppath);
        zz = zz([zz(:).isdir==1]);
        if strcmp(zz(end).name,'website')==1
            zz = zz(1:end-1);
        end
        results2use = {zz(:).name};
    end
    if length(varargin)>2
        cellfilespath = varargin{3};
    else
        cellfilespath=[mypath sl 'cellfiles'];
    end
    if length(varargin)>2
        websitepath = varargin{4};
    else
        load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
        q=find([myrepos.current]==1);
        wtmp=strfind(myrepos(q).dir,sl);
        websitepath=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
        if exist(websitepath,'dir')==0
            mkdir(websitepath)
        end
    end
else
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
    q=find([myrepos.current]==1);
    cellfilespath=[mypath sl 'cellfiles'];
    cellclamppath = [myrepos(q).dir sl 'cellclamp_results'];
        load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
        q=find([myrepos.current]==1);
        wtmp=strfind(myrepos(q).dir,sl);
        websitepath=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
        if exist(websitepath,'dir')==0
            mkdir(websitepath)
        end
        
        if ispc
        results2use = {'667','668','669','670','785','786'}; % {'822'};
    else
        cellclamppath = cellfilespath;
    end
end

if exist(cellfilespath,'dir')==0
    mkdir(cellfilespath);
end

pathway = [cellclamppath sl 'website'];

for x=1:length(results2use)
    potentials = [];
    myresultsfolder = results2use{x};
    zz = dir([cellclamppath sl myresultsfolder sl 'trace_*.soma(0.5).*']);
    for bb=1:length(zz)
        h=regexp(zz(bb).name,'[\_\.]','split');
        celltypes{bb} = h{2};
    end
    
    celltypes = unique(celltypes);
    
    for y=1:length(celltypes)
        celltype = celltypes{y};

        % read in a set of files for a particular cell
        d = dir([cellclamppath sl myresultsfolder sl 'trace_' celltype '.soma(0.5).*']);
        numcurrents = length(d);
        currents=[];
        load([cellclamppath sl myresultsfolder sl 'rundata.mat'],'iclamp')
        if mean(diff(iclamp.current))<0
            for n=1:numcurrents
                %tmp = importdata([cellclamppath sl myresultsfolder sl d(numcurrents-n+1).name]);
                tmp = importdata([cellclamppath sl myresultsfolder sl 'trace_' celltype '.soma(0.5).' num2str(numcurrents-n) '.dat']);
                rez = tmp.data(2,1)-tmp.data(1,1);
                timevec = tmp.data(:,1)/1000; % convert to s
                potentials(:,n) = tmp.data(:,2);
                currents(:,n) = [zeros(iclamp.c_start/rez,1); ones(iclamp.c_dur/rez,1)*iclamp.current(numcurrents-n+1)*1000; zeros(iclamp.c_after/rez,1)]; % convert to pA
            end
        else
            for n=1:numcurrents
                %tmp = importdata([cellclamppath sl myresultsfolder sl d(n).name]);
                tmp = importdata([cellclamppath sl myresultsfolder sl 'trace_' celltype '.soma(0.5).' num2str(n-1) '.dat']);
                rez = tmp.data(2,1)-tmp.data(1,1);
                timevec = tmp.data(:,1)/1000; % convert to s
                potentials(:,n) = tmp.data(:,2);
                try
                currents(:,n) = [zeros(iclamp.c_start/rez,1); ones(iclamp.c_dur/rez,1)*iclamp.current(n)*1000; zeros(iclamp.c_after/rez,1)]; % convert to pA
                catch
                    n
                end
            end
        end

        % write out an axoclamp file
        fcells = fopen([cellfilespath sl celltype '_' myresultsfolder '.atf'],'w');

        fprintf(fcells,'ATF	1.0\n8\t85\n"AcquisitionMode=Episodic Stimulation"\n"Comment="\n"YTop=200,4000"\n"YBottom=-200,-4000"\n"SyncTimeUnits=12.5"\n"SweepStartTimesMS=0.000"\n"SignalsExported=IN 1,IN 11"\n"Signals="\t"IN 1"\t"IN 11"\n');

        headstring = '"Time (s)"';
        cmdstr = 'timevec(:)';
        matresults = timevec(:);
        formatstr = '%f';

        for n=1:numcurrents
            headstring = [headstring '\t"Trace #' num2str(n) ' (mV)"\t"Trace #' num2str(n) ' (pA)"'];
            matresults = [matresults potentials(:,n) currents(:,n)];
            cmdstr = [cmdstr ', potentials(:,' num2str(n) '), currents(:,' num2str(n) ')'];
            formatstr = [formatstr '\t%f\t%f'];
        end

        fprintf(fcells,[headstring '\n']);

        %eval(['fprintf(fcells,''' formatstr '\n'',' cmdstr '.'');']);
        fprintf(fcells,[formatstr '\n'], matresults');

        fclose(fcells);

        % write out website file:
        lowrez = 100;
        highrez = 10;
        if exist([websitepath sl 'cells' sl celltype],'dir')==0
            mkdir([websitepath sl 'cells' sl celltype])
        end
        fcells = fopen([websitepath sl 'cells' sl celltype sl 'Current_sweep.dat'],'w');



        for c=1:size(potentials,2)
            if iclamp.current(c)<=0
                mytimes=sprintf('%0.4f,', timevec(1:lowrez:end));
                mypotentials=sprintf('%0.4f,', potentials(1:lowrez:end,c));
                fprintf(fcells,'%.0f pA,%s\nPotential (mV),%s\n', iclamp.current(c)*1000, mytimes(1:end-1), mypotentials(1:end-1));
            elseif iclamp.current(c)==max(iclamp.current)
                mytimes=sprintf('%0.4f,', timevec(1:highrez:end));
                mypotentials=sprintf('%0.4f,', potentials(1:highrez:end,c));
                fprintf(fcells,'%.0f pA,%s\nPotential (mV),%s\n', iclamp.current(c)*1000, mytimes(1:end-1), mypotentials(1:end-1));
            end
        end

        fclose(fcells);
    end
end



% load handel
% sound(y,Fs)