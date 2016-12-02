function hbar = perfireratehist(handles,spiketrain,period,stepsize,tstop,shiftme,varargin)
global refphase
% hbar = perfireratehist(spiketrain,period,stepsize,tstop,numcells)
%
% spiketrain: vector of spike times
% period: length of oscillatory period in same units as spike times
% stepsize: width of histogram bins in same units
% tstop: length of simulation in same units
% numcells: number of cells contributing to spike train (for computing per cell rate)
ftmp=[];
numcells=1;
if ~isempty(varargin)
    numcells = varargin{1};
    ftmp = varargin{2};
end

spikeper = mod(spiketrain, period);
N = histc(spikeper,[0:stepsize:period]);
N(end-1)=sum(N(end-1:end));
N(end)=[];
numperiods = floor(tstop/period);
extraidx = find([0:stepsize:period]<(tstop-numperiods*period),1,'last');
if ~isempty(extraidx)
    N(1:extraidx) = N(1:extraidx)./(numcells*numperiods+1);
    N(extraidx+1:end) = N(extraidx+1:end)./(numcells*numperiods);
else
    N = N./(numcells*numperiods);
end


% the peak is at the 5th bar but should be at the 2nd one
% -- shiftme = 3 ... everything should be 3 earlier
% so plot bars 1, 2, 3 at the end
% and plot bars 4 and 5 and so on at the beginning

% the peak is at the 2nd bar but should be at the 5th one
% -- shiftme = -3 ... everything should be moved back by three
% so plot bar end-2, end-1, end first
% and then plot bars 1:end-3 after that

if shiftme>0
    N = [N((shiftme+1):end); N(1:shiftme)];
elseif shiftme<0
    N = [N((end+shiftme+1):end); N(1:(end+shiftme))];
elseif isempty(varargin) % calculating shiftme for the first time
    if isdeployed
        usepyrspikes=0;
    else
        myvers=ver;
        g=strcmp({myvers(:).Name},'Signal Processing Toolbox');
        if sum(g)>0
            usepyrspikes=0;
        else
            usepyrspikes=1;
        end
    end
    usepyrspikes=1;
    if usepyrspikes
        ttarget=floor((refphase/360*period)/stepsize)+1;
        [~, tpeak]=max(N);
            if ~isempty(ftmp)
                figure(ftmp);
            end
    else
        ttarget=1;
        myref=getpyramidalphase(handles,[1000/period 1000/period],0)/(2*pi)*period;
        %if numcells>3000
            grrtt=getpyramidalphase(handles,[1000/period 1000/period],1);
            if ~isempty(ftmp)
                figure(ftmp);
            end
        %end
        %tpeak=floor(myref/stepsize)+1;

        N = histc(myref,[0:stepsize:period]);
        [~, tpeak]=max(N);
    end

    hbar=tpeak - ttarget; % return the computed shiftme distance for the pyramidal cell
    return
end

try
    hbar=bar([0:stepsize:period*2-stepsize],[N(:); N(:)],'histc');
    %disp('Did [0:stepsize:period*2-stepsize]')
catch ME
    hbar=bar([0:stepsize:period*2-stepsize*2],[N(:); N(:)],'histc');
    %disp('Did [0:stepsize:period*2-stepsize*2]')
end