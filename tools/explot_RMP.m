
function hp = explot_RMP(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['Resting Membrane Potential (' DetailedData.AxoClampData.VoltageUnits ')'];
    hp.x = DetailedData.AxoClampData.Currents;
    hp.y = [DetailedData.OtherData.Potentials(:).RMP];
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

hp = plot(ax,DetailedData.AxoClampData.Currents,[DetailedData.OtherData.Potentials(:).RMP],'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Resting Membrane Potential (' DetailedData.AxoClampData.VoltageUnits ')'])
end
