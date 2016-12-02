function h=lfpposition(handles)
global mypath mypath RunArray sl

h=[];
ind = handles.curses.ind;

if exist([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'LFPmovie.mat'],'file')==0
try
lfplist = dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'lfptrace_*.dat']);


LayerLength = 50;
for r=1:length(handles.curses.cells)
    BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerLength);
    ZHeight(r) = 50;
end


postype=strmatch('pyramidalcell',{handles.curses.cells(:).name}); 

% read in all lfp files
% match up the gids with their positions
timevec=[];
xvec=zeros(length(lfplist),1);
yvec=zeros(length(lfplist),1);


filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl lfplist(1).name];
tmpdata = importdata(filename);
lfpdir(1:length(lfplist))=struct('gid',str2num(lfplist(1).name(10:end-4)),'lfp',tmpdata(:,2),'name',{lfplist.name});
timevec=tmpdata(:,1);
pos = getpos(lfpdir(1).gid, handles.curses.cells(postype).range_st, BinInfo(postype), ZHeight(postype));
xvec(1) = pos.x;
yvec(1) = pos.y;


for d=2:length(lfpdir)
    filename = [RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl lfpdir(d).name];
    tmpdata = importdata(filename);
    lfpdir(d).gid=str2num(lfpdir(d).name(10:end-4));
    lfpdir(d).lfp=tmpdata(:,2);
    if isempty(timevec)
        timevec=tmpdata(:,1);
    end
    pos = getpos(lfpdir(d).gid, handles.curses.cells(postype).range_st, BinInfo(postype), ZHeight(postype));
    xvec(d) = pos.x;
    yvec(d) = pos.y;
    if mod(d,100)==0
        disp(['we are on d=' num2str(d)])
    end
end

% make a matrix of unique x and y positions
uniqx=unique(xvec);
uniqy=unique(yvec);

% make 3d matrix! x by y by time
mymat=ones(length(uniqx),length(uniqy),length(lfpdir(1).lfp));
myimax=0;
for x=1:length(uniqx)
    for y=1:length(uniqy)
        myi=find(xvec==uniqx(x) & yvec==uniqy(y));
        if isempty(myi)
            mymat(x,y,:)=NaN;
            continue
        end
        if length(myi)>myimax
            myimax=length(myi);
        end
        if length(myi)>1
            avglfp=zeros(1,length(timevec));
            for t=1:length(timevec);
                avglfp(t)=mean(arrayfun(@(x) x.lfp(t), lfpdir));
            end
        else
            avglfp=lfpdir(myi).lfp;
        end
        mymat(x,y,:)=avglfp;
    end
end

mynan=isnan(mymat(:));
mymat(mynan)=min(mymat(~mynan))-(max(mymat(~mynan))-min(mymat(~mynan)))/50;

disp(['myimax is ' num2str(myimax)])

lfpxpos = matfile([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'LFPmovie.mat'],'Writable',true);
lfpxpos.matrix=mymat;
lfpxpos.uniqx=uniqx;
lfpxpos.uniqy=uniqy;
lfpxpos.timevec=timevec(:);
lfpxpos.minval = min(mymat(:));
lfpxpos.maxval = max(mymat(:));
clear mymat uniqx uniqy timevec

h=figure('Color','w','Name',RunArray(ind).RunName);
ddd=[0 0 0; jet(100)];

b1=subplot('Position',[.1 .2 .8 .7]);
bb=imagesc(lfpxpos.uniqx,lfpxpos.uniqy,lfpxpos.matrix(:,:,1));
axis equal;
axis tight;
xlabel('Longitudinal Length')
ylabel('Transverse Length')
title(['LFP Movie of ' RunArray(ind).RunName],'Interpreter','none')
colormap(ddd)
caxis([lfpxpos.minval lfpxpos.maxval])
colorbar

b2=subplot('Position',[.1 .075 .8 .075]);
plot([0 0],[0 1],'k')
hold on
plot([lfpxpos.timevec(end,1) lfpxpos.timevec(end,1)],[0 1],'k')
plot([0 lfpxpos.timevec(end,1)],[.5 .5],'k')
mm=plot(0,.5,'k','Marker','.','MarkerSize',20);
xlim([0 max(lfpxpos.timevec(:,1))])
ylim([0 1])
xlabel([num2str(RunArray(ind).SimDuration) ' ms long'])
axis off

% preallocate F
tmpstruct = getframe(h);
F(1:length(lfpxpos.timevec)) = struct('cdata',tmpstruct.cdata,'colormap',tmpstruct.colormap);

for t=2:length(lfpxpos.timevec)
    set(get(b1,'Children'),'CData',lfpxpos.matrix(:,:,t));
    caxis([lfpxpos.minval lfpxpos.maxval])
    set(mm,'XData',lfpxpos.timevec(t,1));
    drawnow
    F(t) = getframe(h);
    if mod(t,100)==0
        disp(['we are on t=' num2str(t)])
    end
end

close(h);
lfpxpos.F=F;
clear F
uiwait(msgbox('Your movie is ready to play'))
catch ME
    system(['rm ' RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'LFPmovie.mat'])
    ME.message
    ME.stack(1)
    return
end
else
    lfpxpos=load([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'LFPmovie.mat']); % lfpxpos
end
h=figure('Color','w','Name','Movie');
pos=get(h,'Position');
set(h,'Position',[pos(1) pos(2) pos(3)*1.5 pos(4)])
gg=axes('Position',[.1 .1 .8 .8]);
axis off
FpS=120;
movie(lfpxpos.F,1,FpS)

writerObj = VideoWriter([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'LFPmovie.avi'],'Motion JPEG AVI');
writerObj.FrameRate = FpS;  % Default 30
%myVideo.Quality = 50;    % Default 75
open(writerObj);
writeVideo(writerObj, lfpxpos.F);
close(writerObj);
clear lfpxpos

% make a heat map of x by y, whose colors depend on LFP voltage, that is
% animated thru time

% make some line graphs of particular regions: time by voltage (subtly
% changing colors as a function of position)

