
function hp = explot_VoltageCircle(ind,ax,varargin)
global AllCells DetailedData
if ax==-1 
    idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
    z=idx(end);
    
    hp.xheader = ['Potential (' DetailedData.AxoClampData.VoltageUnits ')'];
    hp.yheader = ['dV/dt (' DetailedData.AxoClampData.VoltageUnits '/m' DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Units ')'];
    hp.x = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OffIdx-1);
    hp.y = diff(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OffIdx))./(diff(DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OffIdx)).*1000);
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

idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
for b=1:length(idx)
    z=idx(b);
    hp = plot(ax,DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OffIdx-1),diff(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OffIdx))./(diff(DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OffIdx))'.*1000),'Color',col,'Marker','.');
end
xlabel(ax,['Potential (' DetailedData.AxoClampData.VoltageUnits ')'])
ylabel(ax,['dV/dt (' DetailedData.AxoClampData.VoltageUnits '/m' DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Units ')'])
end
