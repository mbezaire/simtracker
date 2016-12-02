
function hp = explot_1stSpikeHalfWidth(ind,ax,varargin)
global AllCells DetailedData
if ax==-1 
    idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
    for b=1:length(idx)
        HW(b) = DetailedData.SpikeData(idx(b)).Spikes(1).HalfWidth*1000;
    end
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = '1st Spike Half Width (ms)';
    hp.x = DetailedData.AxoClampData.Currents(idx);
    hp.y = HW;
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
% DetailedData.SpikeData(z).Spikes(s).HalfWidth
idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
for b=1:length(idx)
    HW(b) = DetailedData.SpikeData(idx(b)).Spikes(1).HalfWidth*1000;
end
hp = plot(ax,DetailedData.AxoClampData.Currents(idx),HW,'Color',col,'Marker','.');
yl = get(ax,'yLim');
if yl(2)-yl(1)<10e-5
    tmp = round(yl(1)*100)/100;
    set(ax,'yLim',[tmp*.9 tmp*1.1])
end
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['1st Spike Half Width (ms)'])
end
