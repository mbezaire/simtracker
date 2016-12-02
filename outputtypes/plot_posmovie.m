function h=plot_posmovie(handles,varargin) 
global RunArray

%position: cell	x	y	z	host
if size(handles.curses.position,2)<6
    handles.curses.position = addtype2raster(handles.curses.cells,handles.curses.position,6,1);
    guidata(handles.btn_generate, handles)
end

ind = handles.curses.ind;

% if ~isempty(deblank(handles.optarg))
%     rastertype = str2num(deblank(handles.optarg));
% else
%     rastertype=1; %'separate';
% end

h=figure('Color','w','Visible','On');

for r=1:RunArray(ind).NumCellTypes % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
    if strcmp(handles.curses.cells(r).name,'pyramidalcell')==1
        spikerast=handles.curses.spikerast(handles.curses.spikerast(:,3)==r-1,:);
        myrs = r;
    end
end

LayerLength = 50;

for r=1:length(handles.curses.cells)
    BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerLength);
    ZHeight(r) = 50;
end

mycells = [handles.curses.cells(myrs).range_st:handles.curses.cells(myrs).range_en];
for m=1:length(mycells)
    pos = getpos(mycells(m), handles.curses.cells(myrs).range_st, BinInfo(myrs), ZHeight(myrs));
    positions2plot(m,:) = [mycells(m) pos.x pos.y pos.z 0 myrs-1];
end

zvals=unique(positions2plot(:,4))

mycellidx=find(positions2plot(:,4)==zvals(1));

mypositions=positions2plot(mycellidx,:);
mycells=positions2plot(mycellidx,1);

titlestr=['Pyramidal movie: ' RunArray(ind).RunName];

xlim([0 RunArray(ind).LongitudinalLength])
ylim([0 RunArray(ind).TransverseLength])
axis equal
xlabel('Longitudinal length (um)')
ylabel('Transverse length (um)')
view(0,90);
title(titlestr,'Interpreter','none')

stepsize=5; %ms
bins=[0:stepsize:RunArray(ind).SimDuration];
N=[];
for c=1:length(mycells)
    cellrast = spikerast(spikerast(:,2)==mycells(c));
    N(c,:) = histc(cellrast,bins);
end
myx=unique(mypositions(:,2));
myy=unique(mypositions(:,3));

mymax=max(N(:));
figure(h)
% aviobj = avifile([RunArray(ind).ModelDirectory '\results\' RunArray(ind).RunName '\mymovie2.avi']);
% aviobj.quality = 100;
% aviobj.fps = 2;
% aviobj.colormap = gray;


% myVideo = VideoWriter([RunArray(ind).ModelDirectory '\results\' RunArray(ind).RunName '\mymovie3.avi'], 'Uncompressed AVI');
% myVideo.FrameRate = 10;  % Default 30
% %myVideo.quality = 100;    % Default 75
% open(myVideo);


    
for j=1:length(bins)-1
    for c=1:length(mycells)
        xidx = find(myx==mypositions(c,2));
        yidx = find(myy==mypositions(c,3));
        firemat(xidx,yidx)=N(c,j);
    end
    figure(h)
    surf(myx,myy,firemat')
    caxis([0 mymax])
  shading flat % shading interp
  view(0,90);
  colormap gray
  colorbar
  axis equal
  axis tight
  drawnow
  set(h,'Renderer','zbuffer') 
    pause(0.02)
    mymovie(j) = getframe(h);
  %M(j) = getframe(h);
  %aviobj = addframe(aviobj,M(j));
  %writeVideo(myVideo, frame2im(M(j)));
end
% for r=1:length(mymovie)
%     mymovie(r).colormap=gray*255;
% end
hmov=figure('Color','w'); movie(hmov,mymovie,1, 4)
% movie2avi(mymovie, 'spikes.avi', 'compression', 'None','fps',4);


%close(fig)
%aviobj = close(aviobj);
%close(myVideo);

%movie2avi(M,,'FPS',2)
%xyloObj = VideoReader([RunArray(ind).ModelDirectory '\results\' RunArray(ind).RunName '\mymovie2.avi']);

