
function hp = explot_SagAmplitude(ind,ax,varargin)
global AllCells DetailedData


if ax==-1
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['Sag Amplitude (' DetailedData.AxoClampData.VoltageUnits ')'];
    m = isnan([DetailedData.OtherData.Sag(:).Amp]);
    hp.x = DetailedData.AxoClampData.Currents(~m);
    hp.y = [DetailedData.OtherData.Sag(~m).Amp];
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

hp = plot(ax,DetailedData.AxoClampData.Currents,[DetailedData.OtherData.Sag(:).Amp],'Color',col,'Marker','.');
xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Sag Amplitude (' DetailedData.AxoClampData.VoltageUnits ')'])
end
