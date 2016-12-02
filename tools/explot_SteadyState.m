
function hp = explot_SteadyState(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['Steady State Potential (' DetailedData.AxoClampData.VoltageUnits ')'];
    m = isnan([DetailedData.OtherData.Potentials(:).SS]);
    hp.x = DetailedData.AxoClampData.Currents(~m);
    hp.y = [DetailedData.OtherData.Potentials(:).SS];
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

hp = plot(ax,DetailedData.AxoClampData.Currents,[DetailedData.OtherData.Potentials(:).SS],'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Steady State Potential (' DetailedData.AxoClampData.VoltageUnits ')'])
end
