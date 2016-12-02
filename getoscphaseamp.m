function handles=getoscphaseamp(handles,varargin)


% specify which signal to find the oscillation in (and filter it first?)

if isempty(varargin)
    signal2use='lfp';
    filterflag=1;
else
    signal2use=varargin{1};
    filterflag=varargin{2};
end

switch signal2use
    case 'lfp'
        signal = handles.curses.lfp;
        myrez = 1000/handles.runinfo.lfp_dt;
    case 'sdf'
        % idx = find(handles.curses.spikerast(:,3)==6);

        binned= histc(handles.curses.spikerast(:,1),[0:1:handles.runinfo.SimDuration]); % binned by 1 ms
        window=3; % ms
        kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
        sdf = conv(binned,kernel,'same');
        sdf=sdf-sum(sdf)/length(sdf);
        signal = sdf;
        timevec = [0:1:handles.runinfo.SimDuration];
        myrez = 1;
end

if filterflag
    signal=mikkofilter(signal,myrez);
    timevec = signal(:,1);
    signal=signal(:,2);
end

% specify which frequencies to look for

% per frequency, report back:
% - time index (dt resolution:   time | phase | amplitude | envelope)
% - spike raster (extra columns with phase, amplitude, and envelope)

phase = angle(hilbert(signal))*180/pi+180;    %Phase of low frequency signal.
amplitude=signal;
envelope = abs(hilbert(signal));

handles.curses.oscphase = [timevec(:) signal(:) phase(:) envelope(:)];

handles.curses.oscspikerast = handles.curses.spikerast(handles.curses.spikerast(:,1)<=timevec(end),:);
[~, timeidx]=histc(handles.curses.oscspikerast(:,1),timevec);

newcol = size(handles.curses.oscspikerast,2)+1;
handles.curses.oscspikerast(:,newcol) = phase(timeidx); % phase
handles.curses.oscspikerast(:,newcol+1) = amplitude(timeidx); % amplitude
handles.curses.oscspikerast(:,newcol+2) = envelope(timeidx); % envelope