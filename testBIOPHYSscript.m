function testBIOPHYSscript
global flagM flagnew

load mytestdata.mat % t, current, voltage

figure;
subplot(2,1,1)
plot(t,current)
xlabel('Time (s)')
ylabel('Current (nA)')
title('Injected Current')

subplot(2,1,2)
plot(t,voltage)
xlabel('Time (s)')
ylabel('Potential (mV)')
title('Voltage Response')

fs = 1/(t(2) - t(1));
flagM=0;flagnew=0;
[resFreq, peakZ, Q]=addlstuff(current,voltage,fs);
fprintf('%10s:  res = %.2f, peakZ = %.2f, Q = %.2f\n','old way w/ n', resFreq, peakZ, Q)
% [res, Z, f] = res_freq(current', voltage', 20, fs);
% 
% oldway.res = res;
% oldway.Z = Z;
% oldway.f = f;
% fprintf('%10s:  res = %.2f, imp = %.2f\n','old way', res.freq, res.imp)

flagM=1;flagnew=0;
[resFreq, peakZ, Q]=addlstuff(current,voltage,fs);
fprintf('%10s:  res = %.2f, peakZ = %.2f, Q = %.2f\n','old way w/ m', resFreq, peakZ, Q)
% [res, Z, f] = res_freq(current', voltage', 20, fs);
% 
% oldwayM.res = res;
% oldwayM.Z = Z;
% oldwayM.f = f;
% fprintf('%10s:  res = %.2f, imp = %.2f\n','old way w/ m', res.freq, res.imp)


flagM=1;flagnew=1;
[resFreq, peakZ, Q]=addlstuff(current,voltage,fs);
fprintf('%10s:  res = %.2f, peakZ = %.2f, Q = %.2f\n','new way w/ m', resFreq, peakZ, Q)
% [res, Z, f] = res_freq(current', voltage', 20, fs);
% 
% newway.res = res;
% newway.Z = Z;
% newway.f = f;
% fprintf('%10s:  res = %.2f, imp = %.2f\n','new way (m)', res.freq, res.imp)


flagM=0;flagnew=1;
[resFreq, peakZ, Q]=addlstuff(current,voltage,fs);
%[res, Z, f] = res_freq(current', voltage', 20, fs);

% newwayN.res = res;
% newwayN.Z = Z;
% newwayN.f = f;
fprintf('%10s:  res = %.2f, peakZ = %.2f, Q = %.2f\n','new way w/ n', resFreq, peakZ, Q)


function [resFreq, peakZ, Q]=addlstuff(current,voltage,fs)

[res, Z, f] = res_freq(current', voltage', 20, fs);
[Q] = zap_Q(Z,f,[.5 15]);

inds = find((f>1) & (f<20));
f2 =f(inds);Z2 = Z(inds);
[peakZ, resFreqIdx] = max(Z2);
resFreq = f2(resFreqIdx);



