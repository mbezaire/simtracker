function h=plot_lfp(handles)
%PLOT_LFP  Plot LFP of simulation results.
%   H = PLOT_LFP(HANDLES) where HANDLES contains a field called CURSES
%   and CURSES contains a field called LFP will plot the local field
%   potential (column 2 of LFP) as a function of time (column 1 of LFP)
%   
%       h = plot_lfp(handles);
%   
%   returns the handle of the newly generated figure, h, for the plot.
%
%   H = PLOT_LFP(HANDLES) where HANDLES contains a field OPTARG where
%   handles.optarg = TYPE
%   plots the LFP information differently according to the TYPE 
%   specified. TYPE is a string argument that can be any of the following:
%       average     - the average LFP recorded into LFP.dat file, default
%                       if TYPE is blank
%       avg         - same as average
%       filtered    - same as average, but filtered within the theta range
%       {type}      - (ex: pyr) average LFP of all recorded pyramidal cells (or
%                       whichever 3-character cell type was picked)
%       type        - average LFP of all recorded cells, by cell type
%       all         - average LFP of all recorded cells
%       position    - LFP as a function of position within the network
%       {gid}         - LFP of one or more recorded cells, identified by gid

%   See also PLOT_TRACE, PLOT_FFT, PLOT_SPECTROS.

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

if (~isempty(strfind(tmp,'avg')) || ~isempty(strfind(tmp,'average'))) || isempty(tmp)
    h(length(h)+1)=figure('Color','w','Name','LFP');
    plot(handles.curses.lfp(:,1),handles.curses.lfp(:,2))
    title('Average LFP (from lfp.dat file)')
    xlabel('Time (ms)')
    ylabel('LFP (mV)')
elseif ~isempty(strmatch(tmp,'filter'))
    h(length(h)+1)=figure('Color','w','Name','LFP');
    filteredlfp=mikkofilter(handles.curses.lfp,1000/RunArray(ind).lfp_dt);
    plot(filteredlfp(:,1),filteredlfp(:,2))
    title('Filtered Average LFP (from lfp.dat file)')
    xlabel('Time (ms)')
    ylabel('LFP (mV)')
end

return

if ~isempty(strmatch(tmp,'avg')) || ~isempty(strmatch(tmp,'average')) || ~isempty(strmatch(tmp,'filter')) || isempty(tmp)
    return
end

d = dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'lfptrace_*.dat']);

mygids=zeros(1,length(d));

for m=1:length(d)
    mygids(m)=str2num(d(m).name(10:end-4));
end

mydata=[];

if ~isempty(strfind(tmp,'all'))
    h(length(h)+1)=figure('Color','w','Name','LFP - all recorded cells');
    midx=1:length(mygids);

   avgdata=[];
    for m=1:length(midx)
        if isempty(mydata) || m>length(mydata) ||  isfield(mydata(midx(m)), 'data')==0 || isempty(mydata(midx(m)).data)
            mydata(midx(m)).data = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(midx(m)).name]);
        end
        if m==1
            avgdata=reshape(mydata(midx(m)).data(:,2),1,length(mydata(midx(m)).data(:,2)));
        else
            avgdata=[avgdata; reshape(mydata(midx(m)).data(:,2),1,length(mydata(midx(m)).data(:,2)))];
        end
    end
    plot(mydata(midx(1)).data(:,1),mean(avgdata))

    title('Average LFP from all recorded cells')
    xlabel('Time (ms)')
    ylabel('LFP (mV)')
end

if ~isempty(strfind(tmp,'pos'))
    mytmph=lfpposition(handles);
    if ~isempty(mytmph)
        h(length(h)+1)=mytmph;
    end
end

for r=1:length(handles.curses.cells)
    if ~isempty(strfind(tmp,handles.curses.cells(r).name(1:3)))
        h(length(h)+1)=figure('Color','w','Name',['LFP - recorded ' handles.curses.cells(r).name ' cells']);
        midx=find(mygids>=handles.curses.cells(r).range_st & mygids<=handles.curses.cells(r).range_en);
        
        avgdata=[];
        for m=1:length(midx)
            if isempty(mydata) || m>length(mydata) ||  isfield(mydata(midx(m)), 'data')==0 || isempty(mydata(midx(m)).data)
                mydata(midx(m)).data = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(midx(m)).name]);
            end
            if m==1
                avgdata=reshape(mydata(midx(m)).data(:,2),1,length(mydata(midx(m)).data(:,2)));
            else
                avgdata=[avgdata; reshape(mydata(midx(m)).data(:,2),1,length(mydata(midx(m)).data(:,2)))];
            end
        end
        ni = size(avgdata,1);

        for rr=1:size(avgdata,2)
            avgdata(ni+1,rr)=mean(avgdata(1:ni,rr)); % mean
            avgdata(ni+2,rr)=min(avgdata(1:ni,rr));  % min
            avgdata(ni+3,rr)=max(avgdata(1:ni,rr));  % max
            avgdata(ni+4,rr)=std(avgdata(1:ni,rr));  % stdev
        end
        plot(mydata(midx(1)).data(:,1),avgdata(ni+1,:),'b')
        hold on
        plot(mydata(midx(1)).data(:,1),avgdata(ni+1,:)+avgdata(ni+4,:),'g')
        plot(mydata(midx(1)).data(:,1),avgdata(ni+1,:)-avgdata(ni+4,:),'g')
        plot(mydata(midx(1)).data(:,1),avgdata(ni+3,:),'r')
        plot(mydata(midx(1)).data(:,1),avgdata(ni+2,:),'r')
        legend('mean','+std','-std','max','min')

        title(['Average LFP from recorded ' handles.curses.cells(r).name ' cells'])
        xlabel('Time (ms)')
        ylabel('LFP (mV)')
    end
end

if ~isempty(strfind(tmp,'type'))
    h(length(h)+1)=figure('Color','w','Name','LFP - recorded cells by type');
    legstr={};
    for r=1:length(handles.curses.cells)    
        midx=find(mygids>=handles.curses.cells(r).range_st & mygids<=handles.curses.cells(r).range_en);
        
        avgdata=[];
        for m=1:length(midx)
            if isempty(mydata) || m>length(mydata) ||  isfield(mydata(midx(m)), 'data')==0 || isempty(mydata(midx(m)).data)
                mydata(midx(m)).data = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(midx(m)).name]);
            end
            if m==1
                avgdata=reshape(mydata(midx(m)).data(:,2),1,length(mydata(midx(m)).data(:,2)));
            else
                avgdata=[avgdata; reshape(mydata(midx(m)).data(:,2),1,length(mydata(midx(m)).data(:,2)))];
            end
        end
        if exist('avgdata','var') && ~isempty(avgdata)
            tt(length(tt)+1)=plot(mydata(midx(1)).data(:,1),mean(avgdata));
            legstr{length(legstr)+1}=handles.curses.cells(r).name;
            hold on
        end
    end
    legend(tt,legstr)
    title('Average LFP from recorded cells by type')
    xlabel('Time (ms)')
    ylabel('LFP (mV)')
end

gids=regexp(tmp,'[0-9]+','match');
if length(gids)>0
    h(length(h)+1)=figure('Color','w','Name','LFP - cells by gid');
    for g=1:length(gids)
        m=find(mygids==str2num(gids{g}));
        midx=1:length(mygids);
        if ~isempty(m)
            if isempty(mydata) || length(mydata)<midx(m) || isfield(mydata(midx(m)), 'data')==0 || isempty(mydata(midx(m)).data)
                mydata(midx(m)).data = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(midx(m)).name]);
            end
            plot(mydata(midx(m)).data(:,1),mydata(midx(m)).data(:,2));
            hold on
        end
    end
    legend(gids)
    title('LFP from cells by gid')
    xlabel('Time (ms)')
    ylabel('LFP (mV)')
end
