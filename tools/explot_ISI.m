
function hp = explot_ISI(ind,ax,varargin)
global AllCells DetailedData
if ax==-1
    idx = find([DetailedData.SpikeData(:).NumISIs]>0);
    for b=1:length(idx)
        z=idx(b);
        m = isnan([DetailedData.SpikeData(z).ISIs(:).ISI]);
        ISIMean(b) = mean([DetailedData.SpikeData(z).ISIs(~m).ISI]);
        ISISTD(b) = std([DetailedData.SpikeData(z).ISIs(~m).ISI]);
    end
    
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'Average ISI (ms)';
    hp.x = DetailedData.AxoClampData.Currents(idx);
    hp.y = ISIMean;
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

idx = find([DetailedData.SpikeData(:).NumISIs]>0);
for b=1:length(idx)
    z=idx(b);
    m = isnan([DetailedData.SpikeData(z).ISIs(:).ISI]);
    ISIMean(b) = mean([DetailedData.SpikeData(z).ISIs(~m).ISI]);
    ISISTD(b) = std([DetailedData.SpikeData(z).ISIs(~m).ISI]);
end
hp = errorbar(ax,DetailedData.AxoClampData.Currents(idx),ISIMean,ISISTD,'Color',col,'Marker','.');

xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,'Average ISI (ms)')
end
