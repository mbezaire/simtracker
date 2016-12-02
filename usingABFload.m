function usingABFload()

fn='/path/to/abf/file';
[d,si,h]=abfload(fn);
h
si
d(1:10,:,1)
h.sweepStartInPts(1:5)
h.fADCSampleInterval
h.lActualAcqLength
tmp=1e-6*h.lActualAcqLength*h.fADCSampleInterval
disp(['total length of recording: ' num2str(tmp,'%5.1f') ' s ~ ' num2str(tmp/60,'%3.0f') ' min']);
disp(['sampling interval: ' num2str(h.si,'%5.0f') ' µs']);
h.si
time=(0:(size(d,1)-1))*h.si*1e-6;
time(1:10)
time(1:10)'
sprintf('%.7f\n', time(1))
sprintf('%.7f\n', time(2))
1/0.0000500
find(time==1)
h
h.si*h.dataPtsPerChan*1e-6