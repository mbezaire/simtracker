
function hp = explot_MaxHyperpolarization(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['Maximum Hyperpolarization(' DetailedData.AxoClampData.VoltageUnits ')'];
    m = isnan([DetailedData.OtherData.Potentials(:).MaxHyper]);
    hp.x = DetailedData.AxoClampData.Currents(~m);
    hp.y = [DetailedData.OtherData.Potentials(:).MaxHyper];
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

hp = plot(ax,DetailedData.AxoClampData.Currents,[DetailedData.OtherData.Potentials(:).MaxHyper],'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Maximum Hyperpolarization(' DetailedData.AxoClampData.VoltageUnits ')'])
end
