
function hp = explot_Threshold(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    z=find([DetailedData.SpikeData(:).NumSpikes]>0);
    ThreshMean=[];
    threshSTD=[];
    for b=1:length(z)
        try
        ThreshMean(b) = mean([DetailedData.SpikeData(z(b)).Spikes(:).Threshold]);
        catch ME
            ME
        end
        threshSTD(b) = std([DetailedData.SpikeData(z(b)).Spikes(:).Threshold]);
    end
    
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['Threshold (' DetailedData.AxoClampData.VoltageUnits ')'];
    hp.x = DetailedData.AxoClampData.Currents(z);
    hp.y = ThreshMean;
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

z=find([DetailedData.SpikeData(:).NumSpikes]>0);
ThreshMean=[];
threshSTD=[];
for b=1:length(z)
    if isfield(DetailedData.SpikeData(z(b)).Spikes,'Threshold')
        try
        ThreshMean(b) = mean([DetailedData.SpikeData(z(b)).Spikes(:).Threshold]);
        catch ME
            ME
        end
        threshSTD(b) = std([DetailedData.SpikeData(z(b)).Spikes(:).Threshold]);
    else
        ThreshMean(b) = NaN;
        threshSTD(b) = NaN;
    end
end
hp = errorbar(ax,DetailedData.AxoClampData.Currents(z),ThreshMean,threshSTD,'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Threshold (' DetailedData.AxoClampData.VoltageUnits ')'])
end
