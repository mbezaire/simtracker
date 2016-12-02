
function hp = explot_FFT(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'Frequency (Hz, FFT Max)';
    hp.x = DetailedData.AxoClampData.Currents;
    hp.y = [DetailedData.OtherData.FFT(:).MaxFreq];
else

if isempty(varargin)
    col='b';
    cla(ax)
    cla(ax,'reset')
else
    col=varargin{1};
    if length(varargin)>1
        cla(ax)
        cla(ax,'reset')
    end
end

hp = plot(ax,DetailedData.AxoClampData.Currents,[DetailedData.OtherData.FFT(:).MaxFreq],'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Frequency (Hz, FFT Max)'])

end
