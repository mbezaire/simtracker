function h=plot_spectrogram(data,srate,varargin)
% Written by Jesse Jackson, jc.jackson27@gmail.com
%you must have Chronux installed on your computer to get this to work http://chronux.org/
%also, play with the time-bandwidth product(4) and tapers (7) also try ([3 5]).  
% input: data is the time series of the LFP and srate is the sample rate
% note: for theta, it is best to downsample data to 1kHz to speed up
% processing, but not necessary
% data=data*1000;% from microV to mV
if isempty(varargin)
    winsize=4;
else
    winsize=min(4,varargin{1}*.8/1000);
end
params=struct('tapers',[3 5],'pad',1,'Fs',srate,'fpass',[1 200],'err',[1 0.01],'trialave',0);%%% 
[S,t,f]=mtspecgramc(data,[winsize .001],params);% here I use a winsize s analysis and sweep through in 1 ms chunks, but change this accordingly for faster processing
h=figure('Color','w');
imagesc(t,f,S');axis xy;ylim([1 25]);
xlabel('Time (s)')
ylabel('Frequency (Hz)')


