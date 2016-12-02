function varargout = NearElectrode(hObject,handles,varargin)
global mypath RunArray sl

ind = handles.curses.ind;
epos=str2double(regexp(RunArray(ind).ElectrodePoint,';','split'));

if isempty(varargin)
    maxdist = RunArray(ind).MaxEDist;
else
    maxdist = varargin{1};
end

layers=regexp(RunArray(ind).LayerHeights,';','split');
LayerVec=str2double(layers(2:end-1));
dd=importdata([RunArray(ind).ModelDirectory sl 'datasets' sl 'cellnumbers_' num2str(RunArray(ind).NumData) '.dat'],' ',1);
layind=dd.data(:,2)+1;
ZHeight=zeros(1,length(handles.curses.cells));
for r=1:length(handles.curses.cells)
    BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerVec(layind(r)));
    ZHeight(r) = sum(LayerVec(1:layind(r)-1));
end

for postype=1:length(handles.curses.cells)
    handles.curses.cells(postype).mygids=[];
    for gid=handles.curses.cells(postype).range_st:handles.curses.cells(postype).range_en
        pos = getpos(gid, handles.curses.cells(postype).range_st, BinInfo(postype), ZHeight(postype));
        mydist=sqrt((pos.x - epos(1)).^2 + (pos.y - epos(2)).^2);
        if mydist<maxdist
            handles.curses.cells(postype).mygids=[handles.curses.cells(postype).mygids gid];
        end
    end
    disp(['Just finished cell type r=' num2str(postype)])
end

if nargout>0
    varargout{1}=handles;
else
    guidata(hObject,handles)
end