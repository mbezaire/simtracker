
function hp = explot_VoltageOffset(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    hidx = find(DetailedData.AxoClampData.Currents<0);
    didx = find(DetailedData.AxoClampData.Currents>0);
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'Potential Change (mV)';
    hp.x = [DetailedData.AxoClampData.Currents(hidx) DetailedData.AxoClampData.Currents(didx)];
    hp.y = [[DetailedData.OtherData.Potentials(hidx).MaxHyper]-[DetailedData.OtherData.Potentials(hidx).RMP] [DetailedData.OtherData.Potentials(didx).MaxDepol]-[DetailedData.OtherData.Potentials(didx).RMP]];
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
hidx = find(DetailedData.AxoClampData.Currents<0);
didx = find(DetailedData.AxoClampData.Currents>0);

hp = plot(ax,DetailedData.AxoClampData.Currents(hidx),([DetailedData.OtherData.Potentials(hidx).MaxHyper]-[DetailedData.OtherData.Potentials(hidx).RMP]),'Color',col,'Marker','.');
axes(ax)
hold on
plot(ax,DetailedData.AxoClampData.Currents(didx),([DetailedData.OtherData.Potentials(didx).MaxDepol]-[DetailedData.OtherData.Potentials(didx).RMP]),'Color',col,'Marker','.');

ylabel(ax,'Potential Change (mV)') % ' DetailedData.AxoClampData.VoltageUnits '/'  DetailedData.AxoClampData.CurrentUnits '
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
end
