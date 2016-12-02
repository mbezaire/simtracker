
function hp = explot_SagTau(ind,ax,varargin)
global AllCells DetailedData

if ax==-1
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['Sag Time Constant (' DetailedData.AxoClampData.Time(1).Units ')'];
    m = isnan([DetailedData.OtherData.Sag(:).Tau]);
    hp.x = DetailedData.AxoClampData.Currents(~m);
    hp.y = [DetailedData.OtherData.Sag(~m).Tau];
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

hp = plot(ax,DetailedData.AxoClampData.Currents,[DetailedData.OtherData.Sag(:).Tau],'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Sag Time Constant (' DetailedData.AxoClampData.Time(1).Units ')'])
end
