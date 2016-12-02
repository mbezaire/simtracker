
function hp = explot_Sweep(ind,ax,varargin)
global AllCells DetailedData

hyperidx = find(DetailedData.AxoClampData.Currents<=0);
if ax==-1
    hp.xheader = ['Time (' DetailedData.AxoClampData.Time(end).Units ')'];
    hp.yheader = ['Potential (' DetailedData.AxoClampData.VoltageUnits ')'];
        hp.x = DetailedData.AxoClampData.Time(end).Data(:);
        hp.y = DetailedData.AxoClampData.Data(hyperidx(1)).RecordedVoltage(:);
    for h=2:length(hyperidx)
        hp.x = [hp.x DetailedData.AxoClampData.Time(end).Data(:)];
        hp.y = [hp.y DetailedData.AxoClampData.Data(hyperidx(h)).RecordedVoltage(:)];
    end
    if ~isempty(varargin) && varargin{1}>0
        [~, totry]=min(abs([DetailedData.AxoClampData.Currents]-varargin{1}));
        hp.x = [hp.x DetailedData.AxoClampData.Time(end).Data(:)];
        hp.y = [hp.y DetailedData.AxoClampData.Data(totry).RecordedVoltage(:)];
    else
        hp.x = [hp.x DetailedData.AxoClampData.Time(end).Data(:)];
        hp.y = [hp.y DetailedData.AxoClampData.Data(end).RecordedVoltage(:)];
    end
else

if isempty(varargin)
    col='b';
    cla(ax);
    cla(ax,'reset');
else
    col=varargin{1};
    if length(varargin)>1
        cla(ax);
        cla(ax,'reset');
    end
end

hp = plot(ax,DetailedData.AxoClampData.Time(end).Data,DetailedData.AxoClampData.Data(end).RecordedVoltage,'Color',col);
axes(ax);
hold on
for h=1:length(hyperidx)
    plot(ax,DetailedData.AxoClampData.Time(min(hyperidx(h),length(DetailedData.AxoClampData.Time))).Data,DetailedData.AxoClampData.Data(hyperidx(h)).RecordedVoltage,'Color',col);
    hold on
end
set(ax,'xLimMode','auto','yLimMode','auto');
xlabel(ax,['Time (' DetailedData.AxoClampData.Time(1).Units ')'])
ylabel(ax,['Potential (' DetailedData.AxoClampData.VoltageUnits ')'])
    axes(ax);
    hold off
end
