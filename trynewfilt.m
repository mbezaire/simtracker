function Hd = trynewfilt(varargin)
%TRYNEWFILT Returns a discrete-time filter object.

        load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
        q=find([myrepos.current]==1);
        runname='ca1_olmVar_gH_30_03';
        gidname='21310';

if isempty(varargin)
    tmpdata=importdata([myrepos(q).dir sl 'results' sl runname sl 'lfptrace_' gidname '.dat']);
    mytime=tmpdata(:,1);
    mydata=tmpdata(:,2);
elseif isnumeric(varargin{1})
    tmpdata=importdata([myrepos(q).dir sl 'results' sl runname sl 'lfptrace_' num2str(varargin{1}) '.dat']);
    mytime=tmpdata(:,1);
    mydata=tmpdata(:,2);
elseif size(varargin{1},2)>1
    mytime=varargin{1}(:,2);
    mydata=varargin{1}(:,2);
else
    mytime=0:(length(varargin{1})-1);
    mydata=varargin{1}; % handles.curses.lfp(:,2)
end

% MATLAB Code
% Generated by MATLAB(R) 8.5 and the Signal Processing Toolbox 7.0.
% Generated on: 13-Nov-2015 21:32:43

% Butterworth Lowpass filter designed using FDESIGN.LOWPASS.
tryfreqs=[30 50 100 200];
% All frequency values are in Hz.
Fs = 1000/diff(mytime(1:2)); %handles.runinfo.lfp_dt; %10000;  % Sampling Frequency

figure;plot(mytime,mydata)
hold on
kaiserflag=1;

for r=1:length(tryfreqs)
    
    if kaiserflag==1
        Fpass = tryfreqs(r);             % Passband Frequency
        Fstop = tryfreqs(r)*1.11;             % Stopband Frequency
        Dpass = 0.057501127785;  % Passband Ripple
        Dstop = 10^(-30/2/20); %0.0001;          % Stopband Attenuation
        flag  = 'scale';         % Sampling Flag

        % Calculate the order from the parameters using KAISERORD.
        [N,Wn,BETA,TYPE] = kaiserord([Fpass Fstop]/(Fs/2), [1 0], [Dstop Dpass]);

        % Calculate the coefficients using the FIR1 function.
        b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
        Hd(r) = dfilt.dffir(b);
        DownSc=1;
        downlfp = decimate(mydata,DownSc); % DownSc
        disp(['r = ' num2str(r)])
        fdatatmp = filtfilt(Hd(r).Numerator,1,downlfp);
        fdata = resample(fdatatmp,DownSc,1);
    else
        Fpass = tryfreqs(r);% 300;         % Passband Frequency
        Fstop = tryfreqs(r)*1.11;% 333;         % Stopband Frequency
        Apass = 1;           % Passband Ripple (dB)
        Astop = 80;          % Stopband Attenuation (dB)
        match = 'stopband';  % Band to match exactly

        % Construct an FDESIGN object and call its BUTTER method.
        h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
        Hd(r) = design(h, 'butter', 'MatchExactly', match);

        % [EOF]
        %fdata=filter(Hd(r),handles.curses.lfp(:,2));
        %fdata=filtfilt(Hd(r),handles.curses.lfp(:,2));
        fdata = filtfilt(dfilt.dffir(Hd(r)).Numerator,1,mydata);
    end
    plot(mytime,fdata)
end
legend([{'Raw'} cellstr(num2str(tryfreqs'))'])
xlim([1600 2400])

% ways to avoid phase shift:
% 1. use filtfilt
% 2. use this code:
% y = conv(hd,x);
% z = seqreverse(y); % reverse the data
% I = conv(hd,z); % filter the second data
% m = seqreverse(I); % reverse one more time