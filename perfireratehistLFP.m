function hbar = perfireratehistLFP(ModelDirectory,RunName,mynum,spiketrain,thetaper,stepsize,tstop)
global sl
% hbar = perfireratehist(spiketrain,period,stepsize,tstop,numcells)
%
% spiketrain: vector of spike times
% period: length of oscillatory period in same units as spike times
% stepsize: width of histogram bins in same units
% tstop: length of simulation in same units
% numcells: number of cells contributing to spike train (for computing per cell rate)


filename = [ModelDirectory sl 'networkclamp_results' sl RunName sl mynum sl 'lfp.dat'];
lfp = importdata(filename);


filteredlfp=mikkofilter(lfp,1000/lfp(2,1));
tmppeaks=findpeaks(max(filteredlfp(:,2))-filteredlfp(:,2));
if isstruct(tmppeaks)
    peaks = filteredlfp(tmppeaks.loc,1);
else
[~, tmppeaks]=findpeaks(max(filteredlfp(:,2))-filteredlfp(:,2));
    peaks = filteredlfp(tmppeaks,1);
end

[angle, magnitude, modactivitytimes]=getspikephase(spiketrain, thetaper, [peaks(1)-thetaper; peaks; [peaks(end)+thetaper:thetaper:(tstop+thetaper)]']);
mydata.modactivitytimes = modactivitytimes;
mydata.phase = angle*180/pi; % phase computed relative to local reference phase
mydata.mod = magnitude;
[pval zval] = circ_rtest(mydata.modactivitytimes*pi/(thetaper/2));
mydata.pval = pval;
mydata.zval = zval;

N = histc(mydata.modactivitytimes,[0:stepsize:thetaper]);
N(end-1)=sum(N(end-1:end));
N(end)=[];
mydata(r).hist.y=[N(:); N(:)];
if length([0:stepsize:thetaper*2-stepsize])==length(mydata(r).hist.y)
    mydata(r).hist.x=[0:stepsize:thetaper*2-stepsize];
else
    mydata(r).hist.x=[0:stepsize:thetaper*2-stepsize*2];
end
hbar=bar(mydata.hist.x,mydata.hist.y,'histc'); %if ~isempty(hbar) && hbar~=0,set(hbar,'EdgeColor','none');set(hbar,'FaceColor',mydata.color);end;set(gca, 'xLim', [0 thetaper*2])