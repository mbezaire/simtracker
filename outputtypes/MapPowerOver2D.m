function [pwelchdata, thetapowermat, allpowermat, storegids] = MapPowerOver2D(handles,varargin)
global mypath RunArray sl

ind = handles.curses.ind;
maxdist = 500;

xvals=[0:50:4000];
yvals=[0:50:1000];

if isempty(varargin)
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
    %handles.curses.cells(postype).mygids=[];
    for xp=1:length(xvals)
        for yp=1:length(yvals)
            storegids(postype).posval(xp,yp).mygids = [];
        end
    end
    
    for gid=handles.curses.cells(postype).range_st:handles.curses.cells(postype).range_en
        pos = getpos(gid, handles.curses.cells(postype).range_st, BinInfo(postype), ZHeight(postype));
        for xp=1:length(xvals)
            for yp=1:length(yvals)
                mydist=sqrt((pos.x - xvals(xp)).^2 + (pos.y - yvals(yp)).^2);
                if mydist<maxdist
                    storegids(postype).posval(xp,yp).mygids = [storegids(postype).posval(xp,yp).mygids gid];
                    %handles.curses.cells(postype).mygids=[handles.curses.cells(postype).mygids gid];
                end
            end
        end
    end
    disp(['Just finished cell type r=' num2str(postype)])
end
else
    storegids=varargin{1};
end
try
handles.optarg='pyr,sdf,pwelch,table';
load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')
handles.general=general;
thetapowermat=zeros(length(xvals),length(yvals));
allpowermat=zeros(length(xvals),length(yvals));
for xp=1:length(xvals)
    for yp=1:length(yvals)
        for postype=1:length(handles.curses.cells)
            handles.curses.cells(postype).mygids = storegids(postype).posval(xp,yp).mygids;
        end
        [~, tbldata]=plot_spectral(handles);
        pwelchdata(xp,yp).power=tbldata;
        thetapowermat(xp,yp) = tbldata{1,3};
        allpowermat(xp,yp) = tbldata{1,7};
    end
end 
catch
    pwelchdata = [];
    thetapowermat=[];
    allpowermat=[];
end

