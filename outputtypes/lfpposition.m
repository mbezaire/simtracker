function [h, varargout]=lfpposition(handles)
global mypath RunArray sl

h=[];
ind = handles.curses.ind;

try
lfplist = dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'lfptrace_*.dat']);


LayerLength = 50;
LayerVec=[100 50 200 100];
layind=[2 2 2 2 4 1 2 2 3 3 4];
for r=1:length(handles.curses.cells)
    BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerVec(layind(r)));
    ZHeight(r) = sum(LayerVec(1:layind(r)-1));
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

handles.curses.epos.myd=[];
handles.curses.epos.mygids=[];
handles.curses.epos.myx=1770; %2900; %3000;
handles.curses.epos.myy=160; %600; %500;
handles.curses.epos.mylim=150;
handles.curses.epos.mylfplim=1000; %400;

for d=1:length(lfpdir)
    mydist=sqrt((xvec(d) - handles.curses.epos.myx).^2 + (yvec(d) - handles.curses.epos.myy).^2);
    if mydist<handles.curses.epos.mylfplim
        handles.curses.epos.myd=[handles.curses.epos.myd d];
        handles.curses.epos.mygids=[handles.curses.epos.mygids lfpdir(d).gid];
    end
end

Fs=1000/diff(timevec(1:2));
tmplfp=lfpdir(handles.curses.epos.myd(1)).lfp';
tmpfilt=lowfilt(Fs,lfpdir(handles.curses.epos.myd(1)).lfp)';
for d=1:length(handles.curses.epos.myd)
    tmplfp(d,:)=lfpdir(handles.curses.epos.myd(d)).lfp';
    tmpfilt(d,:)=lowfilt(Fs,lfpdir(handles.curses.epos.myd(d)).lfp)';
end
handles.curses.epos.lfp=mean(tmplfp);
handles.curses.epos.filtlfp=mean(tmpfilt);
handles.curses.epos.array=tmplfp;
handles.curses.epos.filtarray=tmpfilt;
disp('Finished selecting LFP traces')

for postype=1:length(handles.curses.cells)
    handles.curses.cells(postype).mygids=[];
    for gid=handles.curses.cells(postype).range_st:handles.curses.cells(postype).range_en
        if gid==20408
            20408
        end
        pos = getpos(gid, handles.curses.cells(postype).range_st, BinInfo(postype), ZHeight(postype));
        mydist=sqrt((pos.x - handles.curses.epos.myx).^2 + (pos.y - handles.curses.epos.myy).^2);
        if mydist<handles.curses.epos.mylim
            handles.curses.cells(postype).mygids=[handles.curses.cells(postype).mygids gid];
        end
    end
    disp(['Just finished cell type r=' num2str(postype)])
end

if nargout>1
    varargout{1}=handles.curses.epos.mygids;
end
if nargout>2
    varargout{2}=handles.curses.epos.myd;
end

if nargout>3
    varargout{3}=handles;
end

return

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

function fdata=lowfilt(Fs,mydata)
tryfreq=50;

Fpass = tryfreq;             % Passband Frequency
Fstop = tryfreq*1.11;             % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 10^(-30/2/20); %0.0001;          % Stopband Attenuation
flag  = 'scale';         % Sampling Flag

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([Fpass Fstop]/(Fs/2), [1 0], [Dstop Dpass]);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);
fdata = filtfilt(Hd.Numerator,1,mydata);

% DownSc=1;
% downlfp = decimate(mydata,DownSc); % DownSc
% fdatatmp = filtfilt(Hd(r).Numerator,1,downlfp);
% fdata = resample(fdatatmp,DownSc,1);
