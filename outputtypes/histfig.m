function h = histfig(handles,thetaper,stepsize,tstop,spikerast,titlestr,varargin);
global mypath RunArray sl refphase


if thetaper<50
    refphase = 0;
else
    refphase = 20;
end

plotexp=0;

numcelltypes = length(handles.curses.cells);

if isempty(varargin)==0
    axes(varargin{1})
else
    % addfig('Raster','On'); % some function that keeps track of all the
    % open figures and opens a new figure with an axes, makes it current
    % since we have commented it out, we will make our own figure:
    h=figure('Color','w','Name','Histogram'); % 'Visible','off',
    pos=get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) pos(3)*2 pos(4)*2]);
end

marg = .5/10;

colorvec=[.0 .0 .6;
          .0 .75 .65;
          1 .75 .0;
          1 .5 .3;
          1 .0 .0;
          .6 .4 .1;
          .5 .0 .6;
          .6 .6 .6;
          1 .1 1;
          1 0 0;
          0 0 1;];
      
      
subplot('Position',[.18 0.04 .09 .89])
fftpic = imread([mypath sl 'outputtypes' sl 'ThetaPreferredNoTop.png'], 'png');
image(fftpic)
axis image
axis off

ftmp = gcf;

g=subplot('Position',[.28 0.05 .25 .4]);
angles = plot_compass(handles,g,plotexp);
figure(ftmp);

g2=subplot('Position',[.28 0.5 .7 .4]);
g3=subplot('Position',[.54 0.05 .45 .4]);
new_theta_graphic(g2,g3,angles,plotexp);
figure(ftmp);

if handles.general.crop>0
   time_idx=find(spikerast(:,1)>=handles.general.crop);
else
    time_idx=[1:size(spikerast,1)];
end

subplot('Position',[.1 1-marg .08 marg/2])
text(0.5,0,'Model Histogram','HorizontalAlignment','center');
axis off

subplot('Position',[.18 1-marg .09 marg/2])
text(0.5,0,'Anesthetized Histogram','HorizontalAlignment','center');
axis off

subplot('Position',[.0 1-marg/2 1 marg/2])
text(0.5,0,titlestr,'HorizontalAlignment','center','FontWeight','bold','Interpreter','none');
axis off
z = strmatch('pyramidalcell',{handles.curses.cells(:).name});
zidx = find(spikerast(time_idx,3)==handles.curses.cells(z).ind);
shiftme = perfireratehist(handles,spikerast(time_idx(zidx),1),thetaper,stepsize,tstop,0);
figure(ftmp);

for r=1:numcelltypes
    zidx = find(spikerast(time_idx,3)==handles.curses.cells(r).ind);
    celltype = handles.curses.cells(r).name; %celltypevec{r};
    numcells = handles.curses.cells(r).numcells; %numcellsvec(r);
    disp([celltype ' ' num2str(length(zidx)) ' spikes'])
    z = strmatch(celltype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
    if isempty(z)
        continue;
    end
    if ~isempty(zidx)
        rez=10; % .1 is simulation resolution
        Fs = 1000/rez; % sampling frequency (per s)
        bins=[0:rez:tstop];
        y=histc(spikerast(time_idx(zidx),1),bins);
        y = y - sum(y)/length(y);

        NFFT = 2^(nextpow2(length(y))+2); % Next power of 2 from length of y
        Y = fft(y,NFFT)/length(y);
        f = Fs/2*linspace(0,1,NFFT/2+1);
        fft_results = 2*abs(Y(1:NFFT/2+1));

        theta_range=find(f(:)>=4 & f(:)<=12);
        [peak_power, peak_idx] = max(fft_results(theta_range));

        theta_idx=find(f(:)<=1000/thetaper+0.01, 1, 'last');

        subplot('Position',[.01 1-marg-z/10 .04 1/10-.05])
        %axes
        b(r) = text(.5,.5,{celltype, [num2str(round(angles(z))) '^o']});
        axis off
        set(b(r),'Color',colorvec(z,:),'FontWeight','Bold')
        subplot('Position',[.1 1-marg-z/10 .08 1/10-.05])
        %plotind=find(spikerast(time_idx,3)==r); % this seemed wrong
        %anyway, should have been r-1 
        hbar = perfireratehist(handles,spikerast(time_idx(zidx),1),thetaper,stepsize,tstop,shiftme,numcells,ftmp);  %shiftme is the i'th bar, move it to the first position
        if ~isempty(hbar) && hbar~=0
            set(hbar,'EdgeColor','none')
            set(hbar,'FaceColor',colorvec(z,:))
        end
        set(gca, 'xLim', [0 thetaper*2])
        hold on
        xL=get(gca,'xLim');
        yL=get(gca,'yLim');
        fst = (xL(2) - xL(1))/4;
        snd= (xL(2) - xL(1))*3/4;
        plot([fst fst], yL, 'Color',[.5 .5 .5],'LineStyle','--')
        plot([snd snd], yL, 'Color',[.5 .5 .5],'LineStyle','--')
        plot(xL, [yL(1) yL(1)],'Color',[.75 .75 .75])
        axis off
    end
end

hfig=gcf;
set(hfig,'Units','normalized','OuterPosition',[0 0 1 1])

us = get(hfig,'Units');
set(hfig,'Units','inches');
setpos=get(hfig,'Position');
setposO=get(hfig,'OuterPosition');
set(hfig,'Units',us);

%set(hfig,'PaperUnits', 'inches','PaperSize',[max(setpos(3),setposO(3)) max(setpos(4),setposO(4))])
set(hfig,'PaperUnits','normalized','PaperSize',[1 1.01])


