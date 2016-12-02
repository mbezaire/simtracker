function h=plot_lfpfft(hObject,handles)
global RunArray


% spikeraster(hObject,handles);
% handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
% handles=guidata(hObject);
% 
% if isfield(handles.curses,'spikerast')==0
%     spikeraster(handles.btn_generate,guidata(handles.btn_generate))
%     handles=guidata(handles.btn_generate);
% end
% if isfield(handles.curses,'cells')==0
%     getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
%     handles=guidata(handles.btn_generate);
% end
% if size(handles.curses.spikerast,2)<3
%     handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
%     guidata(handles.btn_generate, handles)
% end

h=[];
ind = handles.curses.ind;
%myflag=0;

h(1)=figure('Color','w','Name','LFP')
plot(handles.curses.lfp(:,1),handles.curses.lfp(:,2))
title('LFP')
xlabel('Time')
ylabel('LFP mV')

tmp=deblank(handles.optarg);

rez=.5; % ms - this needs to match lfp_dt

[f, fft_results]=mycontfft([0 rez],handles.curses.lfp(:,2));

theta_range=find(f(:)>=4 & f(:)<=12);
[~, peak_idx] = max(fft_results(theta_range));
rel_range=find(f(:)>2 & f(:)<=100);
[~, over_idx] = max(fft_results(rel_range));
bandpower = sum(fft_results(theta_range))/length(theta_range);
% Plot single-sided amplitude spectrum.
h(length(h)+1)=figure('Color','w','Name','LFP FFT');
plot(f, fft_results)
xlim([0 100])
title({['Single-Sided Amplitude Spectrum of LFP'],['(res=' num2str(rez) ') theta Freq: ' sprintf('%.2f', f(theta_range(peak_idx))) ' Freq: ' sprintf('%.2f', f(rel_range(over_idx)))],['bandpower: ' sprintf('%.2f',bandpower)]})
xlabel('Frequency (Hz)')
ylabel('FFT Power |Y(f)|')

ht=newmikkoscript(handles.curses.lfp);

hw=plot_spectrogram(handles.curses.lfp(:,2),1000/rez);
title('Pyramidal LFP Spectrogram')

h=[h ht hw];

