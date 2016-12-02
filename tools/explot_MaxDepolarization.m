
function hp = explot_MaxDepolarization(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['Maximum Depolarization(' DetailedData.AxoClampData.VoltageUnits ')'];
    m = isnan([DetailedData.OtherData.Potentials(:).MaxDepol]);
    hp.x = DetailedData.AxoClampData.Currents(~m);
    hp.y = [DetailedData.OtherData.Potentials(~m).MaxDepol];
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

hp = plot(ax,DetailedData.AxoClampData.Currents,[DetailedData.OtherData.Potentials(:).MaxDepol],'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Maximum Depolarization(' DetailedData.AxoClampData.VoltageUnits ')'])
end
