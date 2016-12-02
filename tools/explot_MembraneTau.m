
function hp = explot_MembraneTau(ind,ax,varargin)
global AllCells DetailedData
if ax==-1
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['Membrane Time Constant (' DetailedData.AxoClampData.Time(1).Units ')'];
    hp.x = DetailedData.AxoClampData.Currents;
    hp.y = [DetailedData.OtherData.Membrane(:).Tau];
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

hp = plot(ax,DetailedData.AxoClampData.Currents,[DetailedData.OtherData.Membrane(:).Tau],'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Membrane Time Constant (' DetailedData.AxoClampData.Time(1).Units ')'])
end
