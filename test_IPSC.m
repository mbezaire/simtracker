A=105;
k1 = 1/3;
k2 = 1/36;
y = A*(exp(-k1.*t) - exp(-k2.*t));


before_idx = 1;
after_idx = length(y);

[~, peak_idx] = max(abs(y-y(1)));

change_idx = 1;

% 10 - 90 rise time
compdata = y - y(1);
per10_val = .1*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
per10_idx = find(abs(compdata(change_idx:peak_idx))>=abs(per10_val),1,'first')+change_idx-1;
per90_val = .9*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
per90_idx = find(abs(compdata(change_idx:peak_idx))>=abs(per90_val),1,'first')+change_idx-1;
rt_10_90 = t(per90_idx) - t(per10_idx);

% rise time constant
erise_val = (1-1/exp(1))*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
taurise_idx = find(abs(compdata(before_idx:after_idx))>=abs(erise_val),1,'first')+before_idx-1;
%plot(tr.data(taurise_idx,1),tr.data(taurise_idx,3),'y','LineStyle','none','Marker','.')
taurise = t(taurise_idx) - t(change_idx);

% decay time constant
edecay_val = (1/exp(1))*(compdata(peak_idx) - compdata(after_idx))+compdata(after_idx);
taudecay_idx = find(abs(compdata(before_idx:after_idx))>=abs(edecay_val),1,'last')+before_idx-1;
%plot(tr.data(taudecay_idx,1),tr.data(taudecay_idx,3),'y','LineStyle','none','Marker','.')
taudecay = t(taudecay_idx) - t(peak_idx);

figure;plot(t,y)
hold on
plot(t(peak_idx),y(peak_idx),'r','Marker','.')

titlestr{1}=['Amplitude: ' sprintf('%.2f',abs(y(peak_idx)-y(change_idx))) ' pA'];
titlestr{2}=['10 - 90% rise time: ' sprintf('%.2f',rt_10_90) ' ms  (tau = ' sprintf('%.2f',taurise) ' ms)'];
titlestr{3}=['Decay tau: ' sprintf('%.2f',taudecay) ' ms'];
titlestr'
