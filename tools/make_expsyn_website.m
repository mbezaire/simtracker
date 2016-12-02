function make_expsyn_website(myrepos,varargin)

if ispc
sl = '\';
else
    sl='/';
end
if ~isempty(varargin)
    cellclamppath = varargin{1};
    results2use = varargin{2}; % eval(['[' varargin{2} ']']);
%     cellclamppath = [varargin{1} sl 'cellclamp_results'];
%     if length(varargin)>1
%         results2use = varargin{2};
%     else
%         zz = dir(cellclamppath);
%         zz = zz([zz(:).isdir==1]);
%         if strcmp(zz(end).name,'website')==1
%             zz = zz(1:end-1);
%         end
%         results2use = {zz(:).name};
%     end
else
    cellclamppath = [myrepos sl 'cellclamp_results'];
    results2use = {'444','445','446','447'};
end

pathway = [cellclamppath sl 'website'];

if exist([pathway sl 'exptraces.mat'],'file')
    load([pathway sl 'exptraces.mat'],'allexptraces')
end

for x=1:length(results2use)
    myresultsfolder = results2use{x};
    load([cellclamppath sl myresultsfolder sl 'rundata.mat'],'iclamp')


    d = dir([cellclamppath sl myresultsfolder sl '*.*.*.trace.dat']);
    st = round(iclamp.pairstart/2);

    for i=1:length(d)
        h=regexp(d(i).name,'\.','split');
        d(i).precell = h{1};
        d(i).postcell = h{2};
        d(i).synapse = h{3};
        d(i).prebypost = [h{1} h{2}];
    end

    try
        prebypost = unique({d(:).prebypost});
    catch ME
        continue
    end

    for i=1:length(prebypost)
        [numsyns idx]= searchfield(d,'prebypost',prebypost{i});

        for n=1:numsyns
            tr(n) = importdata([cellclamppath sl myresultsfolder sl d(idx(n)).name]);
            tr(1).data(:,2+n) = tr(n).data(:,3);
        end
        tr(2:end)=[];
        m = size(tr(1).data,2);
        if m<4
            avgdata = tr(1).data(:,3:m);
        else
            avgdata = mean(tr(1).data(:,3:m)')';
        end
        recidx = find(tr.data(:,1)>st/2,1,'first');
        stidx = find(tr.data(:,1)<st,1,'last');
        allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Time = tr.data(recidx:end,1);
        allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Trace = avgdata(recidx:end)-mean(avgdata(recidx:stidx));
        allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Holding = iclamp.holding;
        if (iclamp.currpair==1) 
            allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Clamp = 'Current';
        elseif (iclamp.voltpair==1)
            allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Clamp = 'Voltage';
        else
            allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Clamp = 'Unknown';
        end
        
        kinetics = getkinetics(allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Time,allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Trace,iclamp.pairstart-5);

        if (iclamp.voltpair==1)
            allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Amplitude = kinetics.amplitude*10^3; %%% pA
        else
            allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Amplitude = kinetics.amplitude; %%% pA
        end
        allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).RiseTime = kinetics.rt_10_90; %%% ms
        allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).DecayTau = kinetics.taudecay; %%% ms
        allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).HalfWidth = kinetics.halfwidth;
        allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Peak = kinetics.peak;
        
        if iclamp.revflag==0
            allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Reversal = 'auto';
        else
            allexptraces.(d(idx(n)).precell).(d(idx(n)).postcell).Reversal = iclamp.revpot;
        end
    end
end
save([pathway sl 'exptraces.mat'],'allexptraces','-v7.3')

function [y idx]=searchfield(d,field,val)

idx=[];

for r=1:length(d)
    if strcmp(d(r).(field),val)==1
        idx(length(idx)+1)=r;
    end
end
y=length(idx);
