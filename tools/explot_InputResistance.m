
function hp = explot_InputResistance(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    hidx = find(DetailedData.AxoClampData.Currents<0);
    for h=1:length(hidx)
        meanInjection(h) = mean(DetailedData.AxoClampData.Data(hidx(h)).CurrentInjection(DetailedData.AxoClampData.Injection(min(hidx(h),length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(hidx(h),length(DetailedData.AxoClampData.Injection))).OffIdx-1));
    end
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'Input Resistance (MegaOhms)';
    hp.x = DetailedData.AxoClampData.Currents(hidx);
    hp.y = ([DetailedData.OtherData.Potentials(hidx).MaxHyper]-[DetailedData.OtherData.Potentials(hidx).RMP]).*10^3./meanInjection;
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
for h=1:length(hidx)
    meanInjection(h) = mean(DetailedData.AxoClampData.Data(hidx(h)).CurrentInjection(DetailedData.AxoClampData.Injection(min(hidx(h),length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(hidx(h),length(DetailedData.AxoClampData.Injection))).OffIdx-1));
end

hp = plot(ax,DetailedData.AxoClampData.Currents(hidx),([DetailedData.OtherData.Potentials(hidx).MaxHyper]-[DetailedData.OtherData.Potentials(hidx).RMP]).*10^3./meanInjection,'Color',col,'Marker','.');
ylabel(ax,'Input Resistance (MegaOhms)') % ' DetailedData.AxoClampData.VoltageUnits '/'  DetailedData.AxoClampData.CurrentUnits '

xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
end
