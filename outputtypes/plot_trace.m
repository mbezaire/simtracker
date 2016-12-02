function h=plot_trace(handles)
%PLOT_TRACE  Plot membrane potential (MP) of cells.
%   H = PLOT_TRACE(HANDLES) where HANDLES contains a field called CURSES
%   and CURSES contains a field called TRACE will plot the membrane
%   potential (column 2 of TRACE) as a function of time (column 1 of TRACE)
%   
%       h = plot_trace(handles);
%   
%   returns the handle of the newly generated figure, h, for the plot.
%
%   H = PLOT_TRACE(HANDLES) where HANDLES contains a field OPTARG where
%   handles.optarg = TYPE
%   plots the LFP information differently according to the TYPE 
%   specified. TYPE is a string argument that can be any of the following:
%       average     - the average MP recorded into MP.dat file, default
%                       if TYPE is blank
%       avg         - same as average
%       pyr         - average MP of all recorded pyramidal cells (or
%                       whichever 3-character cell type was picked)
%       type        - average MP of all recorded cells, by cell type
%       all        - average MP of all recorded cells
%       gid        - LFP of one or more recorded cells, identified by gid

%   See also PLOT_LFP, PLOT_FFT, PLOT_SPECTROS.

%   Marianne J. Bezaire, 2015
%   marianne.bezaire@gmail.com, www.mariannebezaire.com

global mypath RunArray sl

h=[];
ind = handles.curses.ind;
%myflag=0;
if isfield(handles,'optarg')
    tmp=deblank(handles.optarg);
else
    tmp='';
end

% if (~isempty(strfind(tmp,'avg')) || ~isempty(strfind(tmp,'average'))) || isempty(tmp)
%     h(length(h)+1)=figure('Color','w','Name','MP');
%     plot(handles.curses.lfp(:,1),handles.curses.lfp(:,2))
%     title('Average MP (from mp.dat file)')
%     xlabel('Time (ms)')
%     ylabel('Membrane Potential (mV)')
% end


d = dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'trace_*cell*.dat']);

mygids=zeros(1,length(d));

for m=1:length(d)
    mygids(m)=str2num(char(regexp(d(m).name,'[0-9]+','match')));
end

if ~isempty(strfind(tmp,'all')) || isempty(tmp)
    h(length(h)+1)=figure('Color','w','Name','MP - all recorded cells');
    midx=1:length(mygids);

    for m=1:length(midx)
            mydata(midx(m)) = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(midx(m)).name]);
            plot(mydata(midx(m)).data(:,1),mydata(midx(m)).data(:,2))
            hold on
    end

    title('MP from all recorded cells')
    xlabel('Time (ms)')
    ylabel('MP (mV)')
end

if isempty(tmp)
    return
end
if ~isempty(strmatch(tmp,'avg')) || ~isempty(strmatch(tmp,'average'))
    h(length(h)+1)=figure('Color','w','Name','MP - avg of all recorded cells');
    midx=1:length(mygids);

    avgdata=[];
    for m=1:length(midx)
        if exist('mydata','var')==0 || isempty(mydata) || length(mydata)<m || isfield(mydata(midx(m)), 'data')==0 || isempty(mydata(midx(m)).data)
            mydata(midx(m)) = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(midx(m)).name]);
            avgdata=[avgdata mydata(midx(m)).data(:,2)];
        end
    end
    plot(mydata(midx(1)).data(:,1),mean(avgdata'))

    title('Average MP from all recorded cells')
    xlabel('Time (ms)')
    ylabel('MP (mV)')
end

for r=1:length(handles.curses.cells)
    if ~isempty(strfind(tmp,handles.curses.cells(r).name(1:3)))
        h(length(h)+1)=figure('Color','w','Name',['MP - recorded ' handles.curses.cells(r).name ' cells']);
        midx=find(mygids>=handles.curses.cells(r).range_st & mygids<=handles.curses.cells(r).range_en);
        
        avgdata=[];
        for m=1:length(midx)
            if exist('mydata','var')==0 || isempty(mydata) || length(mydata)<midx(m) || isfield(mydata(midx(m)), 'data')==0 || isempty(mydata(midx(m)).data)
                mydata(midx(m)) = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(midx(m)).name]);
            end
            avgdata=[avgdata mydata(midx(m)).data(:,2)];
        end
        ni = size(avgdata,2);

        for rr=1:length(avgdata)
            avgdata(rr,ni+1)=mean(avgdata(rr,2:ni)); % mean
            avgdata(rr,ni+2)=min(avgdata(rr,2:ni));  % min
            avgdata(rr,ni+3)=max(avgdata(rr,2:ni));  % max
            avgdata(rr,ni+4)=std(avgdata(rr,2:ni));  % stdev
        end
        
        plot(mydata(midx(1)).data(:,1),mean(avgdata'),'b')
        hold on
        plot(mydata(midx(1)).data(:,1),avgdata(:,ni+1)-avgdata(:,ni+4),'g')
        plot(mydata(midx(1)).data(:,1),avgdata(:,ni+1)+avgdata(:,ni+4),'g')
        plot(mydata(midx(1)).data(:,1),avgdata(:,ni+2),'r')
        plot(mydata(midx(1)).data(:,1),avgdata(:,ni+3),'r')
        legend('mean','+std','-std','max','min')

        title(['Average MP from recorded ' handles.curses.cells(r).name ' cells'])
        xlabel('Time (ms)')
        ylabel('MP (mV)')
    end
end

if ~isempty(strfind(tmp,'type'))
    h(length(h)+1)=figure('Color','w','Name','MP - recorded cells by type');
    legstr={};
    tt=[];
    for r=1:length(handles.curses.cells)    
        midx=find(mygids>=handles.curses.cells(r).range_st & mygids<=handles.curses.cells(r).range_en);
        
        avgdata=[];
        for m=1:length(midx)
            if exist('mydata','var')==0 || isempty(mydata) || length(mydata)<m || isfield(mydata(midx(m)), 'data')==0 || isempty(mydata(midx(m)).data)
                mydata(midx(m)) = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(midx(m)).name]);
            end
            avgdata=[avgdata mydata(midx(m)).data(:,2)];
        end
        if exist('avgdata','var') && ~isempty(avgdata)
            legstr{length(legstr)+1}=handles.curses.cells(r).name;
            tt(length(tt)+1)=plot(mydata(midx(1)).data(:,1),mean(avgdata'));
            hold on
        end
    end
    legend(tt,legstr)
    title('Average MP from recorded cells by type')
    xlabel('Time (ms)')
    ylabel('MP (mV)')
end

gids=regexp(tmp,'[0-9]+','match');
if length(gids)>0
    h(length(h)+1)=figure('Color','w','Name','MP - cells by gid');
    for g=1:length(gids)
        m=find(mygids==str2num(gids{g}));
        if ~isempty(m)
        if exist('mydata','var')==0 || isempty(mydata) || length(mydata)<m || isfield(mydata(midx(m)), 'data')==0 || isempty(mydata(midx(m)).data)
                mydata(g) = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(m).name]);
            end
            plot(mydata(g).data(:,1),mydata(g).data(:,2));
            hold on
        end
    end
    legend(gids)
    title('MP from cells by gid')
    xlabel('Time (ms)')
    ylabel('MP (mV)')
end
