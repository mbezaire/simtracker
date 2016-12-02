
function hp = explot_SFA(ind,ax,varargin)
global AllCells DetailedData
if ax==-1
    idx = find([DetailedData.SpikeData(:).NumISIs]>0);
    for b=1:length(idx)
        z=idx(b);
        if length(DetailedData.SpikeData(z).ISIs)>6
            SFA(b)=mean([DetailedData.SpikeData(z).ISIs(end-2:end).ISI])/mean([DetailedData.SpikeData(z).ISIs(1:3).ISI]);
        elseif length(DetailedData.SpikeData(z).ISIs)>2
            SFA(b)=mean([DetailedData.SpikeData(z).ISIs(end).ISI])/mean([DetailedData.SpikeData(z).ISIs(1).ISI]);
        else
            SFA(b)=NaN;
        end
    end
    
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'SFA Ratio of ISIs (end/beginning)';
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
        if length(DetailedData.SpikeData(z).ISIs)>6
            SFA(b)=mean([DetailedData.SpikeData(z).ISIs(end-2:end).ISI])/mean([DetailedData.SpikeData(z).ISIs(1:3).ISI]);
        elseif length(DetailedData.SpikeData(z).ISIs)>2
            SFA(b)=mean([DetailedData.SpikeData(z).ISIs(end).ISI])/mean([DetailedData.SpikeData(z).ISIs(1).ISI]);
        else
            SFA(b)=NaN;
        end
    end

hp = plot(ax,DetailedData.AxoClampData.Currents(idx),SFA,'Color',col,'Marker','.');

xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,'SFA Ratio of ISIs (end/beginning)')
end
