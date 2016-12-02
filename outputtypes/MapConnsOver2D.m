function [incomingmat, outgoingmat, nummat, storegids] = MapConnsOver2D(handles,conmat,varargin)
global mypath RunArray sl


xvals=[0:50:4000];
yvals=[0:50:1000];

if isempty(varargin)
    ind = handles.curses.ind;
    maxdist = 500;
    
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
    save('storegids.mat','storegids','-v7.3');
else
    storegids=varargin{1};
end

if length(varargin)<4
    try
        incomingmat=zeros(length(xvals),length(yvals));
        outgoingmat=zeros(length(xvals),length(yvals));
        nummat=zeros(length(xvals),length(yvals));

        for xp=1:length(xvals)
            for yp=1:length(yvals)
                %for postype=1:length(handles.curses.cells)
                    %handles.curses.cells(postype).mygids = storegids(postype).posval(xp,yp).mygids;
               % end
                postype=7;
                datacol=7;
                incomingmat(xp,yp) = mean(conmat(storegids(postype).posval(xp,yp).mygids+1,datacol));
                outgoingmat(xp,yp) = mean(conmat(storegids(postype).posval(xp,yp).mygids+1,datacol+11));
                nummat(xp,yp) = length(storegids(postype).posval(xp,yp).mygids);
            end
        end 
    catch
        incomingmat=[];
        outgoingmat=[];
        nummat=[];
    end
else
    incomingmat=varargin{2};
    outgoingmat=varargin{3};
    nummat=varargin{4};
end


figure;surf(yvals,xvals,incomingmat);hold on; %surf(yvals,xvals,allresults(1).thetapowermat)
xlim([0 1000])
ylim([0 4000])
set(gca, 'DataAspectRatio', [repmat(min(diff(get(gca, 'XLim')), diff(get(gca, 'YLim'))), [1 2]) diff(get(gca, 'ZLim'))])
mz=zlim;
h(1)=plot3([160 160],[1770 1770],mz,'r','LineWidth',2);
h(2)=plot3([100 100],[200 200],mz,'g','LineWidth',2);
legend({'Connectivity','Old Point','New Point'})
title('Incoming Excitatory Connections to Pyramidal Cells')
%legend(h,{'Old Point','New Point'})
xlabel('Transverse Axis (\mum)')
ylabel('Longitudinal Axis (\mum)')
zlabel('Avg Incoming Synapses to each Pyr. Cell')
bb=text(160,1770,max(mz)*.8,'Old Point');
set(bb,'Color','r')
cc=text(100,200,max(mz)*.8,'New Point');
set(cc,'Color','g')



figure;surf(yvals,xvals,outgoingmat);hold on; %surf(yvals,xvals,allresults(1).thetapowermat)
xlim([0 1000])
ylim([0 4000])
set(gca, 'DataAspectRatio', [repmat(min(diff(get(gca, 'XLim')), diff(get(gca, 'YLim'))), [1 2]) diff(get(gca, 'ZLim'))])
mz=zlim;
h(1)=plot3([160 160],[1770 1770],mz,'r','LineWidth',2);
h(2)=plot3([100 100],[200 200],mz,'g','LineWidth',2);
legend({'Connectivity','Old Point','New Point'})
title('Outgoing Excitatory Connections to Pyramidal Cells')
%legend(h,{'Old Point','New Point'})
xlabel('Transverse Axis (\mum)')
ylabel('Longitudinal Axis (\mum)')
zlabel('Avg Outgoing Synapses to each Pyr. Cell')
bb=text(160,1770,max(mz)*.8,'Old Point');
set(bb,'Color','r')
cc=text(100,200,max(mz)*.8,'New Point');
set(cc,'Color','g')



figure;surf(yvals,xvals,nummat);hold on; %surf(yvals,xvals,allresults(1).thetapowermat)
xlim([0 1000])
ylim([0 4000])
set(gca, 'DataAspectRatio', [repmat(min(diff(get(gca, 'XLim')), diff(get(gca, 'YLim'))), [1 2]) diff(get(gca, 'ZLim'))])
mz=zlim;
h(1)=plot3([160 160],[1770 1770],mz,'r','LineWidth',2);
h(2)=plot3([100 100],[200 200],mz,'g','LineWidth',2);
legend({'Connectivity','Old Point','New Point'})
title('# Pyramidal Cells in area')
%legend(h,{'Old Point','New Point'})
xlabel('Transverse Axis (\mum)')
ylabel('Longitudinal Axis (\mum)')
zlabel('Num Pyr. Cell included in avg at point')
bb=text(160,1770,max(mz)*.8,'Old Point');
set(bb,'Color','r')
cc=text(100,200,max(mz)*.8,'New Point');
set(cc,'Color','g')





figure;surf(yvals,xvals,outgoingmat);hold on %surf(yvals,xvals,allresults(1).thetapowermat)
xlim([0 1000])
ylim([0 4000])
set(gca, 'DataAspectRatio', [repmat(min(diff(get(gca, 'XLim')), diff(get(gca, 'YLim'))), [1 2]) diff(get(gca, 'ZLim'))])
mz=zlim;
h(1)=plot3([160 160],[1770 1770],mz,'r','LineWidth',2);
h(2)=plot3([100 100],[200 200],mz,'g','LineWidth',2);
legend({'Outgoing Connectivity','Old Point','New Point'})
title('Excitatory Connections between Pyramidal Cells')
%legend(h,{'Old Point','New Point'})
xlabel('Transverse Axis (\mum)')
ylabel('Longitudinal Axis (\mum)')
zlabel('Avg Synapses to/from each Pyr. Cell')
bb=text(160,1770,max(mz)*.8,'Old Point');
set(bb,'Color','r')
cc=text(100,200,max(mz)*.8,'New Point');
set(cc,'Color','g')
shading interp


