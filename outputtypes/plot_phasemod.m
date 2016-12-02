function [h varargout]=plot_phasemod(hObject,handles,varargin)
%PLOT_PHASEMOD  Plot oscillation phase and modulation of network activity.
%   H = PLOT_PHASEMOD(HANDLES) where HANDLES contains a field called CURSES
%   and CURSES contains a field called spikerast will plot the oscillation 
%   phase and modulation of the network's activity (spike times, LFP peak, 
%   or MP peak) by cell type
%   
%       h = plot_phasemod(hObject,handles);
%   
%   returns the handle of the newly generated figure, h, for the plot.
%
%   H = PLOT_PHASEMOD(HANDLES) where HANDLES contains a field OPTARG where
%   handles.optarg = TYPE
%   can be used to specify what analysis to perform:
%       hist     - spike times of all relevant cells (default)
%       compass  - LFP of relevant recorded cells (local field potential)
%       wave     - MP of relevant recorded cells (membrane potential)
%       table    - MP of relevant recorded cells (membrane potential)
%       mod      - MP of relevant recorded cells (membrane potential)
%   which property of the network activity to analyze:
%       spikes   - phase of spikes of all cells, by cell type
%       sdf      - phase of SDF of all cells, by cell type
%       lfp      - FFT of all [recorded] cells
%       mp       - FFT of one or more [recorded] cells, identified by gid
%   which frequency to use:
%       8.00     - ex: enter the oscillation frequency in Hz (default 8 Hz)
%   and whether to specify a reference phase:
%       ref      - flag to open an additional dialogue allowing
%                   specification of the reference phase of the
%                   oscillation. By default, it is set as 0 degrees at the 
%                   trough of the LFP signal, if lfp.dat results file exists.
%                   If lfp.dat does not exist, the phase of the highest
%                   probability of pyramidal cell firing is set to 20 degrees.

%   See also PLOT_SPECTRO, PLOT_FFT, PLOT_LFP, PLOT_TRACE.

%   Marianne J. Bezaire, 2015
%   marianne.bezaire@gmail.com, www.mariannebezaire.com

global mypath RunArray sl tableh bins myFontSize myFontWeight myFontName

if isempty(myFontSize)
    myFontSize=10;
end
if isempty(myFontWeight)
    myFontWeight='normal';
end
if isempty(myFontName)
    myFontName='ArialMT';
end

h=[];
ind = handles.curses.ind;
%myflag=0;

bins=30; %12;

tmp=deblank(handles.optarg);

posflag=0;
if isfield(handles.curses.cells(1),'mygids')
    posflag=1;
end

showmod=0;

refstr='??';

if isfield(handles,'optarg')
    tmp=lower(deblank(handles.optarg));
else
    tmp='';
end

NiceAbbrev = {'Pyr.','O-LM','Bis.','Axo.','PV+ B.','CCK+ B.','S.C.-A.','Ivy','NGF.','CA3','ECIII'};
nicekey={'pyramidalcell','olmcell','bistratifiedcell','axoaxoniccell','pvbasketcell','cckcell','scacell','ivycell','ngfcell','ca3cell','eccell'};

datatype='spikes';
if ~isempty(strfind(tmp,'lfp'))
    datatype='lfp';
elseif ~isempty(strfind(tmp,'mp'))
    ss=strfind(tmp,'mp');
    if ss>1 & strcmp(tmp(ss-1),'o')==1
        datatype='spikes';
    else
        datatype='mp';
    end
end

dispformat='hist';
histflag=0;
compassflag=0;
waveflag=0;
tableflag=0;
modflag=0;
if ~isempty(strfind(tmp,'compass'))
    compassflag=1;
    dispformat='compass';
end
if ~isempty(strfind(tmp,'table'))
    tableflag=1;
    dispformat='table';
end

if ~isempty(strfind(tmp,'wave'))
    waveflag=1;
    dispformat='wave';
end

if ~isempty(strfind(tmp,'mod'))
    modflag=1;
    dispformat='mod';
end

if (compassflag+waveflag+tableflag+modflag)==0 || ~isempty(strfind(tmp,'hist')) || strcmp(dispformat,'hist')==1
    histflag=1;
end

tt=regexp(tmp,'[0-9.]+','match');
if isempty(tt) || strcmp(tt{1},'.')
    myHz=8; % Hz
else
    myHz=str2num(tt{1}); % Hz
end

tstop = RunArray(ind).SimDuration; %700;%
thetaper=1000/myHz;

% calculate shift
if isempty(strfind(tmp,'ref')) & isempty(strfind(tmp,'abs'))
    if exist([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'lfp.dat'],'file')
        uselfpref=1;
    else
        usespikeref=1;
    end
elseif ~isempty(strfind(tmp,'abs'))
        uselfpref=0;
        usespikeref=0;
else
        uselfpref=0;
        usespikeref=1;
end



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

mydata=[];
vertflag=0;
if ~isempty(varargin)
    vertflag=varargin{1};
    if length(varargin)>1
        mydata=varargin{2};
    end
end
      
if isempty(mydata)      
    % get mydata
    if strcmp(datatype,'spikes')
        activitytimes=handles.curses.spikerast(handles.curses.spikerast(:,1)>handles.general.crop,:);
        for r=1:length(handles.curses.cells)
            if posflag
                zidx = find(ismember(activitytimes(:,2),handles.curses.cells(r).mygids)==1);
            else
                zidx = find(activitytimes(:,2)>=handles.curses.cells(r).range_st & activitytimes(:,2)<=handles.curses.cells(r).range_en);
            end
            mydata(r).activitytimes=activitytimes(zidx,1);
        end
    elseif strcmp(datatype,'lfp')
        msgbox('Not ready yet')
        return
    else % mp
        msgbox('Not ready yet')
        return
    end
    for r=1:length(handles.curses.cells)
        k=strmatch(handles.curses.cells(r).name,nicekey,'exact');
        if isempty(k)
            mydata(r).name=handles.curses.cells(r).name;
        else
            mydata(r).name=NiceAbbrev{k};
        end
        mydata(r).tech=handles.curses.cells(r).name;

        z = strmatch(mydata(r).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});

        if isempty(z)
            mydata(r).color=[0 0 0];
        else
            mydata(r).color=colorvec(z,:);%handles.curses.cells(r).color;
        end
        mydata(r).numcells=handles.curses.cells(r).numcells;
        mydata(r).numactivities=length(mydata(r).activitytimes);

    %     mydata(r).expdata(1).type='awake';
    %     mydata(r).expdata(1).phase=1;
    %     mydata(r).expdata(1).mod=1;
    %     mydata(r).expdata(1).ref=1;

        [angle, magnitude]=getspikephase(mydata(r).activitytimes, thetaper);

        mydata(r).absphase = angle*180/pi;
        mydata(r).absmod = magnitude;
    end

    filteredlfp=[];
    peaks=[];

    if exist('uselfpref','var') && uselfpref && RunArray(ind).SimDuration>3500
        if posflag && isfield(handles.curses,'epos')
            filteredlfp=mikkofilter([handles.curses.lfp(:,1) handles.curses.epos.lfp'],1000/RunArray(ind).lfp_dt);
        else
            filteredlfp=mikkofilter(handles.curses.lfp,1000/RunArray(ind).lfp_dt);
         end
        tmppeaks=findpeaks(max(filteredlfp(:,2))-filteredlfp(:,2));
        if isstruct(tmppeaks)
            peaks = filteredlfp(tmppeaks.loc,1);
        else
        [~, tmppeaks]=findpeaks(max(filteredlfp(:,2))-filteredlfp(:,2));
            peaks = filteredlfp(tmppeaks,1);
        end
        [angle, magnitude]=getspikephase(peaks, thetaper);
        shift = angle*180/pi;
        refstr='lfp trough=0^o';
    elseif exist('uselfpref','var') && uselfpref
        if posflag
            tmppeaks=findpeaks(max(handles.curses.lfp(:,2))-handles.curses.lfp(:,2));
            if isstruct(tmppeaks)
                peaks = handles.curses.lfp(tmppeaks.loc,1);
            else
            [~, tmppeaks]=findpeaks(max(handles.curses.lfp(:,2))-handles.curses.lfp(:,2));
                peaks = handles.curses.lfp(tmppeaks,1);
            end
        else
            tmppeaks=findpeaks(max(handles.curses.lfp(:,2))-handles.curses.lfp(:,2));
            if isstruct(tmppeaks)
                peaks = handles.curses.lfp(tmppeaks.loc,1);
            else
            [~, tmppeaks]=findpeaks(max(handles.curses.lfp(:,2))-handles.curses.lfp(:,2),'MinPeakDistance',50/RunArray(ind).lfp_dt,'MinPeakHeight',600);
                peaks = handles.curses.lfp(tmppeaks,1);
            end
        end
        [angle, magnitude]=getspikephase(peaks, thetaper);
        shift = angle*180/pi;
        refstr='lfp trough=0^o';
    elseif usespikeref
        r=strmatch('pyramidalcell',{mydata(:).tech});
        if ~isempty(r) & ~isempty(mydata(r).absphase) & ~isnan(mydata(r).absphase) & ~isempty(mydata(r).absphase)
            shift = mydata(r).absphase-20; % shift pyramidal cell spike phase to 20
            peaks = round(shift/360*thetaper):thetaper:RunArray(ind).SimDuration;
            peaks=peaks';
            refstr='pyramidal spikes=20^o';
        else
            peaks = 0:thetaper:RunArray(ind).SimDuration;
            peaks=peaks';
            shift = 0;
            refstr='Absolute phase t=0=0^o';
        end
    else
        peaks = 0:thetaper:RunArray(ind).SimDuration;
        peaks=peaks';
        shift = 0;
        refstr='Absolute phase t=0=0^o';
    end

    stepsize = thetaper/bins;
    for r=1:length(handles.curses.cells)
        mydata(r).newphase = mydata(r).absphase - shift; % relative to averaged pyr lfp trough
        [angle, magnitude, modactivitytimes]=getspikephase(mydata(r).activitytimes, thetaper, [peaks(1)-thetaper; peaks; [peaks(end)+thetaper:thetaper:(RunArray(ind).SimDuration+thetaper)]']);
        mydata(r).modactivitytimes=modactivitytimes;
        mydata(r).phase = angle*180/pi; % phase computed relative to local reference phase
        mydata(r).mod = magnitude;
        [pval zval] = circ_rtest(mydata(r).modactivitytimes*pi/(thetaper/2));
        mydata(r).pval = pval;
        mydata(r).zval = zval;

        N = histc(mydata(r).modactivitytimes,[0:stepsize:thetaper]);
        N(end-1)=sum(N(end-1:end));
        N(end)=[];
        mydata(r).hist.y=[N(:); N(:)];
        if length([0:stepsize:thetaper*2-stepsize])==length(mydata(r).hist.y)
            mydata(r).hist.x=[0:stepsize:thetaper*2-stepsize];
        else
            mydata(r).hist.x=[0:stepsize:thetaper*2-stepsize*2];
        end
        mydata(r).hist.plot='hbar=bar(mydata(r).hist.x,mydata(r).hist.y,''histc'');if ~isempty(hbar) && hbar~=0,set(hbar,''EdgeColor'',''none'');set(hbar,''FaceColor'',mydata(r).color);end;set(gca, ''xLim'', [0 thetaper*2])';
    end
end
if nargout>0
    varargout{1}=mydata;
    varargout{2}=peaks;
end


if histflag==1 %strcmp(dispformat,'hist')
    if vertflag
        h = figure('Color','w','Name','Theta Histogram','Units','inches','Position',[.1 .1 1.75 6],'PaperUnits','inches','PaperPosition',[0 0 1.75 6],'PaperSize',[1.75 6]);
    else
        h=figure('Color','w','Name',['Histogram (Phase of ' datatype ' relative to ' refstr ')']);
        pos=get(h,'Position');
        set(h,'Position',[pos(1) pos(2) pos(3)/3 pos(4)]);
    end
    marg = .5/10;
    stepsize = thetaper/bins;
    
    period=1000/myHz;
    trace.data=0:.025:(period*2);
    trace.data=trace.data';
    Hzval = myHz;

    excell = -sin((Hzval*(2*pi))*trace.data(:,1)/1000 + pi/2);  % -13.8/125);  %  - handles.phasepref +   -  (0.25)*Hzval*2*pi
    %subplot('Position',[.05 1-marg .9 1/10-.06])
    if vertflag
        subplot('Position',[.05 1-1/10+.01 .9 1/10-.04]);
    else
        subplot('Position',[.38 1-1/10+.01 .6 1/10-.04]);
    end
    plot(trace.data,excell,'k','LineWidth',1.5)
    ylim([-1.1 1.1])
    xlim([0 max(trace.data)])
    set(gca,'XTickLabel',{})
    set(gca,'YTickLabel',{})
    set(gca,'XColor','w')
    set(gca,'YColor','w')
    title('Model','FontWeight','Bold','FontName','ArialMT','FontSize',myFontSize)
    hold on
    
    for r=1:length(mydata)
        z = strmatch(mydata(r).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
        if (isempty(z) && ~isempty(strmatch('pyramidalcell',{mydata.tech})))  || (isfield(mydata(r),'pval') && mydata(r).pval>.001) % || mydata(r).mod<.2
            continue
        elseif isempty(z)
            z=r;
        end
        try
        idx(1)=find(trace.data>=mydata(r).phase/360*period,1,'first');
        idx(2)=find(trace.data>=mydata(r).phase/360*period+period,1,'first');
        plot(trace.data(idx),excell(idx),'MarkerFaceColor',mydata(r).color,'MarkerEdgeColor',mydata(r).color,'Marker','o','MarkerSize',4,'LineWidth',1.25,'LineStyle','none')
        catch
            idx(1)=NaN;
            idx(2)=NaN;
        end
    end
    axis off

    for r=1:length(mydata)
        z = strmatch(mydata(r).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
        if (isempty(z) && ~isempty(strmatch('pyramidalcell',{mydata.tech})))
            continue;
                    elseif isempty(z)
z=r;
        end
        if vertflag            
            if posflag==0
                subplot('Position',[.05 1-(z+1)/10+.05+.01+.02 .72 .03]);
                axis off
                b = text(0,.45,mydata(r).name);
                set(b,'Color','w','FontWeight','Bold','FontName','ArialMT','FontSize',myFontSize) % mydata(r).color
            end

            gra=subplot('Position',[.95 1-(z+1)/10+.05+.01+.02 .04 .03]);
            if posflag==1
                if showmod==1 & mydata(r).pval<.001
                    b = text(0,.5,['mod. strength=' sprintf('%0.2f',mydata(r).mod)]);
                    gfe=subplot('Position',[.05 1-(z+1)/10+.05+.01+.02 .04 .03]);
                else
                    subplot('Position',[.05 1-(z+1)/10+.05+.01+.02 .72 .03]);

                    axis off
                    b(r) = text(0,.45,mydata(r).name); %celltypeNice{z});
                    set(b(r),'Color',colorvec(z,:),'FontWeight',myFontWeight,'FontName',myFontName,'FontSize',myFontSize)
                    gfe=subplot('Position',[.95 1-(z+1)/10+.05+.01+.02 .04 .03]);

                end
                bcd = text(0,.5,[num2str(round(mydata(r).phase)) '^o'],'HorizontalAlignment','right','Color',mydata(r).color,'FontWeight','Bold','FontName','ArialMT','FontSize',myFontSize);
                axis(gfe,'off')
                %b = text(0,.5,['(n=' num2str(length(handles.curses.cells(r).mygids)) ',m=' sprintf('%0.2f',mydata(r).mod) ') ' num2str(round(mydata(r).phase)) '^o']);
            elseif showmod==1
                b = text(0,.5,[num2str(round(mydata(r).phase)) '^o']);
                set(b,'HorizontalAlignment','right','Color',mydata(r).color,'FontWeight','Bold','FontName','ArialMT','FontSize',myFontSize) % mydata(r).color
            else
                subplot('Position',[.05 1-(z+1)/10+.05+.01+.02 .72 .03]);
                axis off
                b(r) = text(0,.45,mydata(r).name); %celltypeNice{z});
                set(b(r),'Color',colorvec(z,:),'FontWeight',myFontWeight,'FontName',myFontName,'FontSize',myFontSize)
                gfe=subplot('Position',[.95 1-(z+1)/10+.05+.01+.02 .04 .03]);
                bcd = text(0,.5,[num2str(round(mydata(r).phase)) '^o'],'HorizontalAlignment','right','Color',mydata(r).color,'FontWeight','Bold','FontName','ArialMT','FontSize',myFontSize);
                axis(gfe,'off')
            end
            axis(gra,'off')
        else
            subplot('Position',[.03 1-marg-z/10+.02 .3 1/10-.05])
            if posflag==1
                b = text(.5,.5,{['(n=' num2str(length(handles.curses.cells(r).mygids)) ',m=' sprintf('%0.2f',mydata(r).mod) ')'], [num2str(round(mydata(r).phase)) '^o']});
            else
                b = text(.5,.5,{mydata(r).name, [num2str(round(mydata(r).phase)) '^o']},'HorizontalAlignment','right');
            end
            axis off
            set(b,'Color',mydata(r).color,'FontWeight','Bold','FontName','ArialMT','FontSize',myFontSize)
        end
        
        if vertflag
            subplot('Position',[.05 1-(z+1)/10+.01 .9 .05+.015])
        else
            subplot('Position',[.38 1-marg-z/10-.00 .6 1/10-.05+.015])
        end

        N = histc(mydata(r).modactivitytimes,[0:stepsize:thetaper]);
        N(end-1)=sum(N(end-1:end));
        N(end)=[];
        try
            hbar=bar([0:stepsize:thetaper*2-stepsize],[N(:); N(:)],'histc');
            %disp('Did [0:stepsize:period*2-stepsize]')
        catch ME
            hbar=bar([0:stepsize:thetaper*2-stepsize*2],[N(:); N(:)],'histc');
            %disp('Did [0:stepsize:period*2-stepsize*2]')
        end
        if ~isempty(hbar) && hbar~=0
            set(hbar,'EdgeColor','none')
            set(hbar,'FaceColor',mydata(r).color)
        end
        if max(N)==0
        set(gca, 'xLim', [0 thetaper*2],'yLim',[0 1])
        else
        set(gca, 'xLim', [0 thetaper*2],'yLim',[0 max(N)])
        end
        hold on
        xL=get(gca,'xLim');
        yL=get(gca,'yLim');
        fst = (xL(2) - xL(1))/4;
        snd= (xL(2) - xL(1))*3/4;
        plot([fst fst], yL, 'Color',[.5 .5 .5],'LineStyle','--')
        plot([snd snd], yL, 'Color',[.5 .5 .5],'LineStyle','--')
        plot(xL, [yL(1) yL(1)],'Color',[.75 .75 .75])
        axis off
        % title(mydata(r).name)
    end
end
if compassflag==1 %strcmp(dispformat,'compass')
    h=figure('Color','w','Name',['Compass (Phase of ' datatype ' relative to ' refstr ')']);
    [x,y] = pol2cart(0,1);
    h_fake=compass(x,y);
    hold on

    legh=zeros(length(mydata),1);
    legstr=repmat({''},length(mydata),1);
    for r=1:length(mydata)
        [x,y] = pol2cart(mydata(r).phase/180*pi,mydata(r).mod);
        k=compass(x,y);
        legh(r)=k;
        legstr{r}=mydata(r).name;
        set(k,'Color',mydata(r).color,'LineWidth',4);
    end
    set(h_fake,'Visible','off');
    legend(legh,legstr,'Location','BestOutside')
end
if tableflag==1 %strcmp(dispformat,'table')
    tbldata={};
    for r=1:length(mydata)
        tbldata{r,1}=mydata(r).name;
        tbldata{r,2}=round(mydata(r).phase*10)/10;
        tbldata{r,3}=mydata(r).mod;
        tbldata{r,4}=mydata(r).numcells;
        tbldata{r,5}=mydata(r).numactivities;
        tbldata{r,6}=mydata(r).pval;
        tbldata{r,7}=mydata(r).zval;
    end
    h=figure('Color','w','Name',['Oscillation Table (Phase of ' datatype ' relative to ' refstr ')']);
    myzfunc=@context_copymytable_Callback;
    mycontextmenuz=uicontextmenu('Tag','menu_copy1','Parent',h);
    uimenu(mycontextmenuz,'Label','Copy Table','Tag','context_copytable1','Callback',myzfunc);
    % ,'ColumnFormat',{'char','bank','bank','bank','bank'}
    tableh = uitable(h, 'Data', tbldata,'ColumnFormat',{'char','bank','bank','short','short','numeric','bank'},'ColumnName',{'Name','Phase','Modulation','# Cells','# Activities','P-val','Z-val'},'Units','inches', 'UIContextMenu',mycontextmenuz);
    ex=get(tableh,'Extent');
    set(h,'Units','inches');
    pos=get(h,'Position');
    set(h,'Position',[pos(1) pos(2) ex(3)+.05 ex(4)+.05])
    set(tableh,'Units','normalized','Position',[0 0 1 1])
end
if waveflag==1 %strcmp(dispformat,'wave')
    h=figure('Color','w','Name',['LFP Wave (Phase of ' datatype ' relative to ' refstr ')']);
    pos=get(h,'Position');
    set(h,'Position',[pos(1) pos(2) pos(3)*2 pos(4)])
    period=1000/myHz;
    trace.data=0:.025:(period*2);
    trace.data=trace.data';
    Hzval = myHz;

    excell = -sin((Hzval*(2*pi))*trace.data(:,1)/1000 + pi/2);  % -13.8/125);  %  - handles.phasepref +   -  (0.25)*Hzval*2*pi
    plot(trace.data,excell,'k')
    hold on
    
    for r=1:length(mydata)
        z = strmatch(mydata(r).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
        if (isempty(z) && ~isempty(strmatch('pyramidalcell',{mydata.tech}))) || mydata(r).mod<.2 || (isfield(mydata(r),'pval') && mydata(r).pval>.001)
            continue
                    elseif isempty(z)
z=r;
        end
        idx(1)=find(trace.data>=mydata(r).phase/360*period,1,'first');
        idx(2)=find(trace.data>=mydata(r).phase/360*period+period,1,'first');
        plot(trace.data(idx),excell(idx),'MarkerFaceColor',mydata(r).color,'MarkerEdgeColor',mydata(r).color,'Marker','o','MarkerSize',10,'LineWidth',2,'LineStyle','none')
        text(trace.data(idx(1))+6,excell(idx(1)),[num2str(round(mydata(r).phase)) '^o ' mydata(r).name],'Color',mydata(r).color)
    end
    set(gca,'Position',[0.05 0.1 .9 .8])
    axis off
    
    if isstruct(tmppeaks)
        filteredlfpmat = cutperiods(filteredlfp,tmppeaks.loc);
%         if posflag
%             lfpmat = cutperiods([handles.curses.lfp(:,1) handles.curses.epos.lfp'],tmppeaks.loc);
%         else
            lfpmat = cutperiods(handles.curses.lfp,tmppeaks.loc);
%         end
    else
        filteredlfpmat = cutperiods(filteredlfp,tmppeaks);
%         if posflag
%             lfpmat = cutperiods([handles.curses.lfp(:,1) handles.curses.epos.lfp'],tmppeaks);
%         else
            lfpmat = cutperiods(handles.curses.lfp,tmppeaks);
%         end
    end
    
    figure('Color','w');
    subplot(4,1,1)
    plot(0:360,mean(filteredlfpmat),'k')
    hold on
    plot(360:720,mean(filteredlfpmat),'k')
    axis off
    title('Filtered Avg')
    
    subplot(4,1,2)
    for r=1:size(filteredlfpmat,1)
        plot(0:360,filteredlfpmat(r,:),'k')
        hold on
        plot(360:720,filteredlfpmat(r,:),'k')
    end
    axis off
    title('Filtered Overlay')
    
    
    subplot(4,1,3)
    plot(0:360,mean(lfpmat),'k')
    hold on
    plot(360:720,mean(lfpmat),'k')
    axis off
    title('Raw Avg')
    
    subplot(4,1,4)
    for r=1:size(lfpmat,1)
        plot(0:360,lfpmat(r,:),'k')
        hold on
        plot(360:720,lfpmat(r,:),'k')
    end
    axis off
    title('Raw Overlay')
    
end
if modflag==1 %strcmp(dispformat,'mod')
    msgbox('Not ready yet')
    %h=plot_firemod(RunArray(ind).RunName,myHz,mydata);
end
% if nargout>1
%     close(h)
% end
    
function filteredlfpmat = cutperiods(filteredlfp,tmppeaks)
    filteredlfpmat=[];
    for t=1:length(tmppeaks)-1
        mytime=(filteredlfp(tmppeaks(t):tmppeaks(t+1),1)-filteredlfp(tmppeaks(t),1))/(filteredlfp(tmppeaks(t+1),1)-filteredlfp(tmppeaks(t),1))*360;
        mytrace=filteredlfp(tmppeaks(t):tmppeaks(t+1),2);
        newtrace = interp1(mytime,mytrace,0:360,'pchip');
        if t==1
            filteredlfpmat=reshape(newtrace,1,length(newtrace));
        else
            filteredlfpmat=[filteredlfpmat; reshape(newtrace,1,length(newtrace))];
        end
    end





function context_copymytable_Callback(hObject,eventdata)
% hObject    handle to context_copytable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath  tableh

mystr=get(hObject,'Tag');
tablestr=mystr(end);

eval(['mydata=get(tableh(' tablestr '),''Data'');'])
eval(['mycol=get(tableh(' tablestr '),''ColumnName'');'])


%load parameters
% create a header
% copy each row
str = '';
for j=1:size(mydata,2)
    str = sprintf ( '%s%s\t', str, mycol{j} );
end
str = sprintf ( '%s\n', str(1:end-1));
for i=1:size(mydata,1)
    for j=1:size(mydata,2)
        if isstr(mydata{i,j})
            str = sprintf ( '%s%s\t', str, mydata{i,j} );
        elseif isinteger(mydata(i,j))
            str = sprintf ( '%s%d\t', str, mydata{i,j} );
        else
            str = sprintf ( '%s%f\t', str, mydata{i,j} );
        end
    end
    str = sprintf ( '%s\n', str(1:end-1));
end
clipboard ('copy', str);
