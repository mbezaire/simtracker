function h=plot_position(handles,varargin) 
global mypath RunArray

ind = handles.curses.ind;

if ~isempty(deblank(handles.optarg))
    rastertype = str2num(deblank(handles.optarg));
else
    rastertype=1; %'separate';
end

h=figure('Color','w');
pos=get(gcf,'Position');

[R G B]=meshgrid([.1:.4:1],[.1:.4:1],[.1:.4:1]);
colorvec = [R(:) G(:) B(:)];
colorvec = colorvec([3:2:end 2:2:end],1:3);

myrs=[];
if rastertype==0
    for r=1:RunArray(ind).NumCellTypes % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
        if strcmp(handles.curses.cells(r).techname(1:2),'pp')~=1
            myrs = [myrs r];
        end
    end
else
    myrs=1:RunArray(ind).NumCellTypes;
end

legstr={};
LayerLength = 50;

for r=1:length(handles.curses.cells)
    BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerLength);
    ZHeight(r) = 50;
end


titlestr=['Positions: ' RunArray(ind).RunName];
if isempty(varargin)==0
    mygid = varargin{3};
    
    postype=find([handles.curses.cells(:).range_st]<=mygid,1,'last'); 
    pos = getpos(mygid, handles.curses.cells(postype).range_st, BinInfo(postype), ZHeight(postype));

    plot3(pos.x,pos.y,pos.z,'MarkerEdgeColor','k','MarkerFaceColor','y','LineStyle','none','Marker','o','MarkerSize',13)
    hold on
    legstr{1}='Postsynaptic cell';
    positions2plot=handles.curses.position(varargin{1},:);
    titlestr=varargin{2};
    precells = varargin{1};
else
    precells = [0:handles.curses.cells(end).range_en];
end

for r=1:length(myrs)
    myidx=find(precells>=handles.curses.cells(myrs(r)).range_st & precells<=handles.curses.cells(myrs(r)).range_en);
    pos2plot=[];
    for p=1:length(myidx)
        pos = getpos(precells(myidx(p)), handles.curses.cells(myrs(r)).range_st, BinInfo(myrs(r)), ZHeight(myrs(r)));
        pos2plot(p,:) = [pos.x pos.y pos.z];
    end
    if isempty(pos2plot)
        continue
    end
    plot3(pos2plot(:,1),pos2plot(:,2),pos2plot(:,3),'Color',colorvec(r,:),'LineStyle','none','Marker','.','MarkerSize',5)
    hold on
    legstr{length(legstr)+1}=[handles.curses.cells(myrs(r)).name ' (' num2str(handles.curses.cells(myrs(r)).numcells) ' cells)'];
end

legend(legstr)
axis equal
xlim([0 RunArray(ind).LongitudinalLength])
ylim([0 RunArray(ind).TransverseLength])
height = str2num(['[' RunArray(ind).LayerHeights ']']);
zlim([0 sum(height(2:end))])
xlabel('Longitudinal length (um)')
ylabel('Transverse length (um)')
zlabel('Layer height (um)')
title(titlestr,'Interpreter','none')


