
function hp = explot_FiringRate(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'Firing Rate (Hz)';
    hp.x = DetailedData.AxoClampData.Currents;
    hp.y = [DetailedData.SpikeData(:).NumSpikes]./[DetailedData.AxoClampData.Injection(:).Duration];
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

hp = plot(ax,DetailedData.AxoClampData.Currents,[DetailedData.SpikeData(:).NumSpikes]./[DetailedData.AxoClampData.Injection(:).Duration],'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Firing Rate (Hz)'])

end
