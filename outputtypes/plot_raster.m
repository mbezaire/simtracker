function h=plot_raster(handles,varargin) 
%PLOT_RASTER  Plot spike raster of simulation results.
%   H = PLOT_RASTER(HANDLES) where HANDLES contains a field called CURSES
%   and CURSES contains a field called SPIKERAST will plot the spike times
%   found in column one of SPIKERAST, by cell gid in column two of 
%   SPIKERAST, grouped by cell type in column three of SPIKERAST. 
%   
%       h = plot_raster(handles);
%   
%   returns the handle of the newly generated figure, h, for the plot.
%
%   H = PLOT_RASTER(HANDLES,AX) plots the plot into axis AX.
%
%   H = PLOT_RASTER(HANDLES,AX,COLORSTRUCT) colors the cells in the plot
%   according to the color/celltype coordination in the struct COLORSTRUCT
%   with an organization such as:
%   colorstruct.(celltype).pos = 1;
%   colorstruct.(celltype).color = [.5 .5 .5];
%
%   H = PLOT_RASTER(HANDLES) where HANDLES contains a field OPTARG where
%   handles.optarg = TYPE
%   plots the spike information differently according to the TYPE 
%   specified. TYPE is a string argument that can be any of the following:
%       separate     - the spikes of each cell type grouped separately
%       pyremph      - a separate raster with a larger plot section for
%                       pyramidal cells
%       interspersed - all cells plotted in an overlapping fashion, color
%                       coded by cell type
%       spikedist    - histogram by cell type of how many cells spiked a
%                       given number of times
%       phasepre     - phase of each spike given an oscillation period,
%                       separated by cell type
%       individual   - 
%       rasthist     - histogram of spikes as a function of time, separated
%                       by cell type
%       pyrpos       - spikes of the pyramidal cell type only, as a
%                       function of time and position

%
%   H = PLOT_RASTER(HANDLES,TYPE,AXES) plots the spikeraster into the
%   existing axis corresponding to the AXES handle.

%   See also PLOT_CELLTYPE.

%   Marianne J. Bezaire, 2015
%   marianne.bezaire@gmail.com, www.mariannebezaire.com

global mypath RunArray sl savepath

if ~isempty(savepath), fid=fopen([savepath sl 'SpikeRasterLocal.dat'],'w'); end;

rng default

stimflag=0;
histflag=0;
emphflag=0;
if isfield(handles,'optarg') && ~isempty(deblank(handles.optarg))
    optstring = deblank(handles.optarg);
else
    optstring = '';
end

msz=10;
downsampleflag=0;
if strfind(optstring,'down')
    downsampleflag=1;
    msz=1;
end

posflag=0;
if strfind(optstring,'posfil') & isfield(handles.curses.cells(1),'mygids')
    posflag=1;
end

plotposflag=0;
if strfind(optstring,'possort') | strfind(optstring,'posort')
    plotposflag=1;
end

optstring=strrep(strrep(strrep(strrep(strrep(optstring,'posfil',''),'possort',''),'posort',''),'down',''),',','');
    
if ~isempty(optstring)
    rastertype = optstring;%deblank(handles.optarg);
else
    rastertype='separate'; %'separate';
end

mksty='.';
sanghunproject=0;
csabaproject=0;

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
if strcmp('ca1',myrepos(q).name)
    mycellstr={'pyramidalcell','olmcell','bistratifiedcell','axoaxoniccell','pvbasketcell','cckcell','scacell','ivycell','ngfcell'};
    NiceAbbrev = {'Pyr.','O-LM','Bis.','Axo.','PV+ B.','CCK+ B.','S.C.-A.','Ivy','NGF.'};
else
    mycellstr={handles.curses.cells.name};
    NiceAbbrev=mycellstr;
end

ycolvec={[0 .4 .4],[.5 0 .3]};
idx = 3; % idx contains the column in the spikeraster that gives the cell type index

ind = handles.curses.ind;
if plotposflag==1
    layers=regexp(RunArray(ind).LayerHeights,';','split');
    LayerVec=str2double(layers(2:end-1));
    dd=importdata([RunArray(ind).ModelDirectory sl 'datasets' sl 'cellnumbers_' num2str(RunArray(ind).NumData) '.dat'],' ',1);
    layind=dd.data(:,2)+1;

    ZHeight=zeros(1,length(handles.curses.cells));
    for r=1:length(handles.curses.cells)
        BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerVec(layind(r)));
        ZHeight(r) = sum(LayerVec(1:layind(r)-1));
    end
end


if isempty(ind)
    SimDuration = round(max(handles.curses.spikerast(:,1)));
else
    SimDuration = RunArray(ind).SimDuration;
end


if strcmp(rastertype,'csaba')
    rastertype='separate';
    sanghunproject=0;
    csabaproject=1;
elseif strcmp(rastertype,'sanghun')
    rastertype='separate';
    sanghunproject=1;
    csabaproject=0;
    ycolvec={[0 0 0],[0 0 0]};
elseif strcmp(rastertype,'stim')
    rastertype='separate';
    stimflag=1;
elseif strcmp(rastertype,'pyremph')
    rastertype='separate';
    emphflag=1;
elseif strcmp(rastertype,'histemph')
    rastertype='separate';
    emphflag=1;
    histflag=1;
end

colorstruct=[];
if isempty(varargin)==0 
    if ~isempty(varargin{1})
        axes(varargin{1});
        h=get(varargin{1},'Parent');
    else
        h=figure('Visible','on','Color','w');
        pos=get(gcf,'Units');
        set(gcf,'Units','normalized','Position',[0 0 1 1]);
        set(gcf,'Units',pos);
    end
    if length(varargin)>1
        colorstruct=varargin{2};
    end
else
    % addfig('Raster','On'); % some function that keeps track of all the
    % open figures and opens a new figure with an axes, makes it current
    % since we have commented it out, we will make our own figure:
    h=figure('Visible','on','Color','w');
    pos=get(gcf,'Units');
    set(gcf,'Units','normalized','Position',[0 0 1 1]);
    set(gcf,'Units',pos);
end

%handles.formatP.colorvec
switch rastertype
    case 'spikedist'
        for r=1:length(handles.curses.cells) %2:7%
            plotind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind & handles.curses.spikerast(:,1)>handles.general.crop);
            figure(h(1));
            subplot(4,3,r)
            b=hist(handles.curses.spikerast(plotind,2),handles.curses.cells(r).range_st:handles.curses.cells(r).range_en);
            hist(b,0:max(b))
            title(handles.curses.cells(r).name)
            xlabel('# spikes per cell')
            ylabel('# cells')
%             if strcmp('pyramidalcell',handles.curses.cells(r).name)==1
%                 gidx = find(b>=2);
%                 pyrcells = gidx + handles.curses.cells(r).range_st - 1;
%                 newidx = find(ismember(handles.curses.spikerast(:,2),pyrcells)==1 & handles.curses.spikerast(:,1)>handles.general.crop);
%                 h(2)=figure('Color','w','Name','Pyramidal cell Multi-Spikers');
%                 plot(handles.curses.spikerast(newidx,1),handles.curses.spikerast(newidx,2),'Color','k','LineStyle','none','Marker',mksty,'MarkerSize',10);
%                 title('Pyramidal cells that spiked 2+ times after 50 ms')
%                 xlabel('Time (ms)')
%                 ylabel('Pyramidal Cell Gid')
%                 xlim([0 SimDuration])
%                 tmp = handles.curses.spikerast(newidx,:);
%                 for zz=handles.curses.cells(r).range_st:handles.curses.cells(r).range_en
%                     pyrtmp(zz-handles.curses.cells(r).range_st + 1) = mean(diff(tmp(tmp(:,2)==zz,1)));
%                     try
%                     pyrtmpmax(zz-handles.curses.cells(r).range_st + 1) = max(diff(tmp(tmp(:,2)==zz,1)));
%                     pyrtmpmin(zz-handles.curses.cells(r).range_st + 1) = min(diff(tmp(tmp(:,2)==zz,1)));
%                     catch
%                         pyrtmpmax(zz-handles.curses.cells(r).range_st + 1) = NaN;
%                         pyrtmpmin(zz-handles.curses.cells(r).range_st + 1) = NaN;
%                     end
%                 end
%                 h(3)=figure('Color','w','Name','Pyramidal cell Multi-Spiker Average ISIs');
%                 hist(pyrtmp,[0:10:500]);
%                 title('Average ISIs for Pyramidal Multi-Spikers')
%                 xlabel('Mean ISI (ms)')
%                 ylabel('# Pyramidal Cells')
%             end
        end
    case 'phasepre'
        for r=1:length(handles.curses.cells) %2:7%
            if strcmp('pyramidalcell',handles.curses.cells(r).name)==1
                plotind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind & handles.curses.spikerast(:,1)>handles.general.crop);
                figure(h(1));
                b=hist(handles.curses.spikerast(plotind,2),handles.curses.cells(r).range_st:handles.curses.cells(r).range_en);
%                 zz=hist(b,0:max(b));
%                 plot(0:max(b),zz,'Marker',mksty,'MarkerSize',15,'MarkerFaceColor','r')
%                 set(gca,'YScale','log')
%                 title(handles.curses.cells(r).name)
%                 xlabel('# spikes per cell')
%                 ylabel('# cells')
                if max(b)<2
                    break;
                end
                for q=2:max(b)
                    mymat=[];
                    gidx = find(b==q);
                    pyrcells = gidx + handles.curses.cells(r).range_st - 1;
                    newidx = find(ismember(handles.curses.spikerast(:,2),pyrcells)==1 & handles.curses.spikerast(:,1)>handles.general.crop);
                    for w=1:length(pyrcells)
                        mymat(w,:) = handles.curses.spikerast((handles.curses.spikerast(:,2)==pyrcells(w) & handles.curses.spikerast(:,1)>handles.general.crop),1);
                    end
                    mymatphase = mod(mymat,146)*360/146;
                    phasediffs = diff(mymatphase')';
                    gdx=find(phasediffs>180);
                    phasediffs(gdx) = phasediffs(gdx)-360;
                    gdx=find(phasediffs<-180);
                    phasediffs(gdx) = phasediffs(gdx)+360;
                    h(q)=figure('Color','w','Name',['Phase Differences of ' handles.curses.cells(r).name 's that spiked ' num2str(q) ' times after 50 ms']);
                    h(q+max(b))=figure('Color','w','Name',['Phases of ' handles.curses.cells(r).name 's that spiked ' num2str(q) ' times after 50 ms']);
                    h(q+max(b)+1)=figure('Color','w','Name',['Histogram of Phase Differences for ' handles.curses.cells(r).name 's that spiked ' num2str(q) ' times after 50 ms']);
                    for y=1:size(phasediffs,2)
                        figure(h(q))
                        subplot(1,size(phasediffs,2),y)
                        plot(phasediffs(:,y),[1:size(phasediffs,1)],'LineStyle','none','Marker',mksty,'MarkerSize',msz,'Color','r')
                        xlabel('Phase diff. (degrees)')
                        ylabel([handles.curses.cells(r).name ' Cell Arb #'])
                        xlim([-180 180])
                        figure(h(q+max(b)+1))
                        subplot(1,size(phasediffs,2),y)
                        hist(phasediffs(:,y),[-180:10:180]);
                        xlabel('Phase diff. (degrees)')
                        ylabel(['# ' handles.curses.cells(r).name ' Cells'])
                        disp([num2str(length(find(phasediffs(:,y)<0))) ' cells of ' num2str(size(phasediffs,1)) ' cells that fired ' num2str(q) ' spikes after 50 ms fired their #' num2str(y+1) ' spike earlier'])
                    end   
                    for y=1:size(mymatphase,2)
                        figure(h(q+max(b)))
                        subplot(1,size(mymatphase,2),y)
                        plot(mymatphase(:,y),[1:size(mymatphase,1)],'LineStyle','none','Marker',mksty,'MarkerSize',msz,'Color','r')
                        xlabel('Phase (degrees)')
                        ylabel([handles.curses.cells(r).name ' Cell Arb #'])
                        xlim([0 360])
                    end
                end
            end
        end
        
    case 'interspersed'
        pos=[];
        %[R G B]=meshgrid([.1:.4:1],[.1:.4:1],[.1:.4:1]);
        [R G B]=meshgrid([.1:.4:1],[.1:.4:1],[.1:.4:1]);
        colorvec = [R(:) G(:) B(:)];
        colorvec = colorvec([2:4:end 4:4:end 3:4:end],1:3);
        colorvec = [1 0 0; 0 1 0; 0 0 1; 0 0 0; .5 0 .5; 0 .5 .5; .5 .5 0; 0 1 1; 1 1 0; .8 .7 .1; .3 0 1;];

        maxcells=max([handles.curses.cells(1:end).numcells]);
        
        for r=1:length(handles.curses.cells)
            addpos=(0:handles.curses.cells(r).numcells-1)*(maxcells-1)/(handles.curses.cells(r).numcells-1);
            pos=[pos addpos];
        end
        mycellplots=[];
        myvec={'b','r','g','y','k','c','m'};
        for r=1:length(handles.curses.cells) %2:7%
            if posflag==1
                plotind = find(ismember(handles.curses.spikerast(:,2),handles.curses.cells(r).mygids)==1);
            else
                plotind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
            end
            %try
                % fix(1) ... 1 used to be: handles.curses.spikerast(plotind,2)-handles.curses.cells(3).range_st+1
            if strcmp(handles.curses.cells(r).techname(1:2),'pp')~=1
                %%plot(handles.curses.spikerast(plotind,1),pos(fix(handles.curses.spikerast(plotind,2))+1),'Color',handles.formatP.colorvec{r},'LineStyle','none','Marker',mksty,'MarkerSize',handles.formatP.sizevec{r})
                plot(handles.curses.spikerast(plotind,1),pos(fix(handles.curses.spikerast(plotind,2))+1),'Color',colorvec(r,:),'LineStyle','none','Marker',mksty,'MarkerSize',msz)%handles.formatP.sizevec{1})
                %plot(handles.curses.spikerast(plotind,1),pos(fix(handles.curses.spikerast(plotind,2))+1),'Color',myvec{r-1},'LineStyle','none','Marker',mksty,'MarkerSize',10)%handles.formatP.sizevec{1})
                mycellplots=[mycellplots r];
            end
                %catch ME
           %     r
            %end
            hold on
        end
        
        set(gca,'FontName','ArialMT','FontWeight','bold','FontSize',14)
        %set(gca,'FontUnits','points','FontSize',12)
        xlabel('Time (ms)') %,'FontName','Verdana'
        ylabel('Arbitrary Units')
        title('Spike Raster','FontSize',16)
        set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
        customizeraster
        hleg=legend(handles.curses.cells(mycellplots).name,'Location','NorthEastOutside');
        grid off
        hfig=gcf;
        set(hfig,'Units','normalized','OuterPosition',[0 .05 .95 .95])

    case 'separate'      
       %colorvec = [.3 .3 1; .3 1 .3; 0 0 0];
       colorvec = [0 147 221; 0 146 63; 0 0 0]/255;

        ones2plot=0;
        myrs=[];
        for r=1:length(handles.curses.cells) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            if emphflag==1
                if isempty(colorstruct) || isfield(colorstruct,handles.curses.cells(r).name(1:end-4))==0
                    myidx=strmatch(handles.curses.cells(r).name,mycellstr,'exact');
                    if ~isempty(myidx)
                        myrs(myidx)=r;
                    end
                else
                    myrs(colorstruct.(handles.curses.cells(r).name(1:end-4)).pos)=r;
                end
                ones2plot=ones2plot+1;
            elseif (strcmp(handles.curses.cells(r).techname(1:2),'pp')~=1 || csabaproject==1 || stimflag==1) %&& strcmp(handles.curses.cells(r).techname(1:3),'poo')~=1
            %if strcmp(handles.curses.cells(r).techname(1:3),'poo')==1
                myrs = [myrs r];
                ones2plot=ones2plot+1;
            end
        end
        myrs=myrs(myrs~=0);
        if emphflag==0 || ~isempty(colorstruct)
            myrs=myrs(end:-1:1);
        end
        if sanghunproject
            normrange = ([handles.curses.cells(myrs).numcells]).^(1/1.5)-handles.formatP.marg; %sanghunproject 
        else
            normrange = ([handles.curses.cells(myrs).numcells]).^(1/11)-handles.formatP.marg; % 1/11 1/3
        end
        %normsize = normrange/(sum(normrange)+(length(handles.curses.cells(:))-1)*handles.formatP.marg+handles.formatP.bottom + 2);
        if emphflag==1
            if isempty(colorstruct) || isfield(colorstruct,'pyramidal')==0
                normrange(1) = normrange(1)*4; % 1/11 1/3
            else
                normrange(length(myrs)+1-colorstruct.pyramidal.pos) = normrange(length(myrs)+1-colorstruct.pyramidal.pos)*4; % 1/11 1/3
            end
            normsize = normrange/sum(normrange)*(1-((ones2plot-1)*handles.formatP.marg+handles.formatP.bottom*2+.01));
            normy = [handles.formatP.bottom*2 normsize(1:end-1)+ handles.formatP.marg];
        else
            normsize = normrange/sum(normrange)*(1-((ones2plot-1)*handles.formatP.marg+handles.formatP.bottom+.01));
            normy = [handles.formatP.bottom normsize(1:end-1)+ handles.formatP.marg];
        end

        %for r=1:length(handles.curses.cells) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
        for z=1:length(myrs) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            r=myrs(z);
            %haxis=subplot('Position', [handles.formatP.left sum(normy(1:r)) .9 normsize(z)]);
            if emphflag==1
                haxis=subplot('Position', [handles.formatP.left*2 sum(normy(1:z)) .9-handles.formatP.left normsize(z)]);
            else
                haxis=subplot('Position', [handles.formatP.left sum(normy(1:z)) .9-handles.formatP.left normsize(z)]);
            end
            if posflag==1
                outind = find(ismember(handles.curses.spikerast(:,2),handles.curses.cells(r).mygids)==1);
            else
                outind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
            end
            
            if isempty(outind)
                myz=strmatch(handles.curses.cells(r).name,mycellstr,'exact');
                bd=ylabel({NiceAbbrev{myz},'none'},'Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',14);
                set(bd, 'Units', 'Normalized', 'Position', [-0.03, 0.3, 0]);

                %bd=ylabel([strrep(NiceAbbrev{myz},'.','') ': ' num2str(mynumcells)],'Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',14);
                % bd=ylabel(sprintf('%-6s %4s', [strrep(NiceAbbrev{myz},'.','') ':'],num2str(mynumcells)),'Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',14);
                %set(bd, 'Units', 'Normalized', 'Position', [-.01, 0.3, 0]);
                set(bd,'Units','character')
                if z>1 % && emphflag==0) || (z==9 && emphflag==1)
                    set(haxis, 'xtickLabel',[])
                end
                xlim([0 SimDuration])
                continue
            end
            
            if plotposflag==1
                pos = getpos(handles.curses.spikerast(outind,2), handles.curses.cells(r).range_st, BinInfo(r), ZHeight(r));
                plotsort=[];
                plotsort(:,1)=[pos.x];
                plotsort(:,2)=[pos.y];
                plotsort(:,3)=[pos.z];
                [~,~,plotyvals] = unique(plotsort,'rows');
                plotyvals = plotyvals + (handles.curses.cells(r).range_st - min(plotyvals));
                chedges = min(plotyvals):(max(plotyvals)-min(plotyvals)+1)/500*downsampleflag:max(plotyvals);
            else
                plotyvals=handles.curses.spikerast(outind,2);
                chedges=handles.curses.cells(r).range_st:(handles.curses.cells(r).numcells/500*downsampleflag):handles.curses.cells(r).range_en;
            end
            
            if downsampleflag>0
                origpts=length(plotyvals);
                [~, gidbins] = histc(plotyvals, chedges);
                [~, timebins] = histc(handles.curses.spikerast(outind,1), 0:downsampleflag:RunArray(ind).SimDuration);
                [~,IA,~] = unique([timebins gidbins],'rows');
                plotyvals = plotyvals(IA);
                outind = outind(IA);
                P = randperm(length(outind),round(length(outind)*(4-downsampleflag)/4));
                outind=outind(P);
                plotyvals = plotyvals(P);
                disp(['Downsampled ' num2str(origpts) ' points to ' num2str(length(plotyvals)) ' points (' num2str(length(plotyvals)/origpts) '%)'])
            end
            
            if isempty(colorstruct) || isfield(colorstruct,handles.curses.cells(r).name(1:end-4))==0
                mycol='k';
            else
                mycol=colorstruct.(handles.curses.cells(r).name(1:end-4)).color;
            end
           if ~isempty(savepath), fprintf(fid,'%f\t%d\n',[handles.curses.spikerast(outind,1) plotyvals(:)]'); end;
           if (strcmp(handles.curses.cells(r).techname(1:2),'pp')==1 & handles.curses.cells(r).numcells>5000)
                %text(SimDuration/2,.5,'Too many to plot')
                %plot(handles.curses.spikerast(outind,1),plotyvals,'Color',colorvec(r,:),'LineStyle','none','Marker',mksty)
                plot(handles.curses.spikerast(outind,1),plotyvals,'Color',mycol,'LineStyle','none','Marker',mksty,'MarkerSize',msz)
            else
                if sanghunproject
                    plot(handles.curses.spikerast(outind,1),plotyvals,'Color',colorvec(r,:),'LineStyle','none','Marker',mksty,'MarkerSize',msz) %sanghunproject 
                    set(haxis,'ytick',[])
                else
                    if histflag==1
                        croprast=find(handles.curses.spikerast(outind,1)>handles.general.crop);
                        binsize=5; %5
                        N=histc(handles.curses.spikerast(outind,1),[0:binsize:SimDuration]);
                        hbar=bar([0:binsize:SimDuration],N);
                        % set(gca,'Clipping','on')
                        ylim([0 max(max(N(binsize*6:end))*1.1,1)])
                        set(hbar,'EdgeColor','none')
                        set(hbar,'FaceColor',mycol)
                    elseif strcmp(handles.curses.cells(r).name,'pyramidalcell')==1
                        plot(handles.curses.spikerast(outind,1),plotyvals,'Color',mycol,'LineStyle','none','Marker',mksty,'MarkerSize',msz/10)
                    else
                        plot(handles.curses.spikerast(outind,1),plotyvals,'Color',mycol,'LineStyle','none','Marker',mksty,'MarkerSize',msz)
                    end
                end
            end
%             if z==3
%             ylabel([handles.curses.cells(r).name(1:3) ' ' RunArray(ind).RunComments(4:end) ])
%             else
            if emphflag==1
                myz=strmatch(handles.curses.cells(r).name,mycellstr,'exact');
                if posflag==1
                    mynumcells=length(handles.curses.cells(r).mygids);
                else
                    mynumcells=handles.curses.cells(r).numcells;
                end
                bd=ylabel(NiceAbbrev{myz},'Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',14);
                set(bd, 'Units', 'Normalized', 'Position', [-0.03, 0.3, 0]);

                %bd=ylabel([strrep(NiceAbbrev{myz},'.','') ': ' num2str(mynumcells)],'Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',14);
                % bd=ylabel(sprintf('%-6s %4s', [strrep(NiceAbbrev{myz},'.','') ':'],num2str(mynumcells)),'Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',14);
                %set(bd, 'Units', 'Normalized', 'Position', [-.01, 0.3, 0]);
                set(bd,'Units','character')
                set(haxis,'ytick',[],'ycolor','k')
           else
                ylabel({handles.curses.cells(r).name(1:3),[num2str(handles.curses.cells(r).numcells) ' cells']})
            end
%            end
            grid off %on
            box on %off
            if sanghunproject
                xlim([500 1000]) %sanghunproject 
            elseif csabaproject
                xlim([100 150]) %csabaproject 
            else
                xlim([0 SimDuration])
            end
         
            if histflag==0
                if handles.curses.cells(r).range_en==handles.curses.cells(r).range_st
                    ylim([handles.curses.cells(r).range_st-.5 handles.curses.cells(r).range_st+.5])
                elseif plotposflag==1
                    ylim([min(plotyvals)-.5 max(plotyvals)+.5])
                elseif posflag==1
                    ylim([min(handles.curses.cells(r).mygids)-.5 max(handles.curses.cells(r).mygids)+.5])
                else
                    ylim([handles.curses.cells(r).range_st-.5 handles.curses.cells(r).range_en+.5])
                end
            end
            step=ceil((handles.curses.cells(r).range_en-handles.curses.cells(r).range_st)/5);
            if step==0, step=1; end
            if emphflag==1
                if isempty(colorstruct) || isfield(colorstruct,handles.curses.cells(r).name(1:end-4))==0
                    mycol=[.5 .5 .5];
                else
                    mycol=colorstruct.(handles.curses.cells(r).name(1:end-4)).color;
                end
                if mod(handles.curses.cells(r).range_en-handles.curses.cells(r).range_st,step)>.75*step
                    set(haxis, 'ytick',[handles.curses.cells(r).range_st:step:handles.curses.cells(r).range_en handles.curses.cells(r).range_en], 'ycolor', mycol, 'xcolor',  'k')
                else
                    set(haxis, 'ytick',[handles.curses.cells(r).range_st:step:handles.curses.cells(r).range_en], 'ycolor', mycol, 'xcolor', 'k')
                end
                set(haxis,'ytick',[])
            elseif sanghunproject==0
                if mod(handles.curses.cells(r).range_en-handles.curses.cells(r).range_st,step)>.75*step
                    set(haxis, 'ytick',[handles.curses.cells(r).range_st:step:handles.curses.cells(r).range_en handles.curses.cells(r).range_en], 'ycolor', ycolvec{mod(r+1,length(ycolvec))+1}, 'xcolor', ycolvec{mod(r+1,length(ycolvec))+1})
                else
                    set(haxis, 'ytick',[handles.curses.cells(r).range_st:step:handles.curses.cells(r).range_en], 'ycolor', ycolvec{mod(r+1,length(ycolvec))+1}, 'xcolor', ycolvec{mod(r+1,length(ycolvec))+1} )
                end
            end
            if z>1 % && emphflag==0) || (z==9 && emphflag==1)
                set(haxis, 'xtickLabel',[])
            else
                if emphflag==0
                    xlabel(['time (ms) for ' RunArray(ind).RunName ', Stim: ' num2str(RunArray(ind).DegreeStim) ' Hz, ConnData: ' num2str(RunArray(ind).ConnData)],'Interpreter','None')
                else
                    xlabel('Time (ms)','FontName','ArialMT','FontWeight','bold','FontSize',14)
                    set(haxis,'FontName','ArialMT','FontWeight','bold','FontSize',14,'xcolor','k')
                end
            end
            set(haxis, 'ytickLabel',[])
            hold on
%             filteredlfp=[];
%             try
%             filteredlfp=mikkofilter(handles.curses.lfp,1000/RunArray(ind).lfp_dt);
%             catch ME
%                 ME
%             end
%             yy=ylim;
%             if isfield(handles.curses,'lfp') && ~isempty(handles.curses.lfp)
%                 plot(handles.curses.lfp(:,1),(handles.curses.lfp(:,2)-min(handles.curses.lfp(:,2)))/(max(handles.curses.lfp(:,2))-min(handles.curses.lfp(:,2)))*diff(yy)+yy(1),'g','LineWidth',2)
%             end
%             if ~isempty(filteredlfp)
%                 plot(filteredlfp(:,1),(filteredlfp(:,2)-min(filteredlfp(:,2)))/(max(filteredlfp(:,2))-min(filteredlfp(:,2)))*diff(yy)+yy(1),'m','LineWidth',2)
%             end
%             ylim(yy);

            %             ax2(z) = axes('Position', get(haxis, 'Position'),'Color','none');
%             set(ax2(z),'XTick',[],'YTick',[],'XColor','k','YColor','k','box','on','layer','top')
        end

        %set(gcf, 'CurrentAxes', haxis, 'Color', 'w')
        set(gcf, 'Color', 'w')
        if sanghunproject || csabaproject
            pp = get(gcf,'Position'); %sanghunproject 
            set(gcf,'Position',[pp(1) pp(2) pp(3)/4 pp(4)]) %sanghunproject 
        end
        if emphflag==0
            title(['Spike Raster: ', num2str(length(handles.curses.cells)-1),' cell types, ',num2str(SimDuration),' ms'])
        end
        
    case 'individual'  
        for r=1:length(handles.curses.cells) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            if r>1
                h(2)=figure('Color','w');
            else
                set(gcf, 'Color', 'w')
            end
            if posflag==1
                outind = find(ismember(handles.curses.spikerast(:,2),handles.curses.cells(r).mygids)==1);
            else
                outind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
            end
            plot(handles.curses.spikerast(outind,1),handles.curses.spikerast(outind,2),'Color','k','LineStyle','none','Marker',mksty,'MarkerSize',msz)
            xlabel('Time (ms)')
            ylabel(handles.curses.cells(r).name)
            title(RunArray(ind).RunName)
        end

    case 'rasthist'      
        ones2plot=0;
        emphflag=1;
        myrs=[];
        for r=1:length(handles.curses.cells) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            if (strcmp(handles.curses.cells(r).techname(1:2),'pp')~=1 || csabaproject==1) %&& strcmp(handles.curses.cells(r).techname(1:3),'poo')~=1
            %if strcmp(handles.curses.cells(r).techname(1:3),'poo')==1
                myrs = [myrs r];
                ones2plot=ones2plot+1;
            end
        end
        myrs=[];
        for r=1:length(handles.curses.cells) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            if emphflag==1
                if isempty(colorstruct) || isfield(colorstruct,handles.curses.cells(r).name(1:end-4))==0
                    myidx=strmatch(handles.curses.cells(r).name,mycellstr,'exact');
                    if ~isempty(myidx)
                        myrs(myidx)=r;
                    end
                else
                    myrs(colorstruct.(handles.curses.cells(r).name(1:end-4)).pos)=r;
                end
                ones2plot=ones2plot+1;
            elseif (strcmp(handles.curses.cells(r).techname(1:2),'pp')~=1 || csabaproject==1 || stimflag==1) %&& strcmp(handles.curses.cells(r).techname(1:3),'poo')~=1
            %if strcmp(handles.curses.cells(r).techname(1:3),'poo')==1
                myrs = [myrs r];
                ones2plot=ones2plot+1;
            end
        end
        myrs=myrs(myrs~=0);
        if emphflag==0 || ~isempty(colorstruct)
            myrs=myrs(end:-1:1);
        end
        
        normrange = ([handles.curses.cells(myrs).numcells]).^(1/11)-handles.formatP.marg; % 1/11 1/3
        normsize = normrange/sum(normrange)*(1-((ones2plot-1)*handles.formatP.marg+handles.formatP.bottom+.01));
        normy = [handles.formatP.bottom normsize(1:end-1)+ handles.formatP.marg];

        if emphflag==1
            if isempty(colorstruct) || isfield(colorstruct,'pyramidal')==0
                normrange(1) = normrange(1)*4; % 1/11 1/3
            else
                normrange(length(myrs)+1-colorstruct.pyramidal.pos) = normrange(length(myrs)+1-colorstruct.pyramidal.pos)*4; % 1/11 1/3
            end
            normsize = normrange/sum(normrange)*(1-((ones2plot-1)*handles.formatP.marg+handles.formatP.bottom*2+.01));
            normy = [handles.formatP.bottom*2 normsize(1:end-1)+ handles.formatP.marg];
        else
            normsize = normrange/sum(normrange)*(1-((ones2plot-1)*handles.formatP.marg+handles.formatP.bottom+.01));
            normy = [handles.formatP.bottom normsize(1:end-1)+ handles.formatP.marg];
        end

        for z=1:length(myrs) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            r=myrs(z);
            haxis=subplot('Position', [handles.formatP.left+.02 sum(normy(1:z)) .88 normsize(z)]);
            
%         normrange = ([handles.curses.cells(:).numcells]).^(1/11)-handles.formatP.marg;
%         normsize = normrange/sum(normrange)*(1-((length(handles.curses.cells(:))-1)*handles.formatP.marg+handles.formatP.bottom+.01));
%         normy = [handles.formatP.bottom normsize(1:end-1)+ handles.formatP.marg];

        %for r=1:length(handles.curses.cells) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            %haxis=subplot('Position', [handles.formatP.left sum(normy(1:r)) .9 normsize(r)]);
            if 1==0
                croprast=handles.curses.spikerast(handles.curses.spikerast(:,1)>handles.general.crop,:);
                outind=find(croprast(:,3)==handles.curses.cells(r).ind);
                binsize=1; %5
                N=histc(croprast(outind,1),[0:binsize:SimDuration]);
            else
                outind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
                binsize=1; %5
                N=histc(handles.curses.spikerast(outind,1),[0:binsize:SimDuration]);
            end
            hbar=bar([0:binsize:SimDuration],N);
            if exist('colorstruct','var')==0 || isempty(colorstruct) || isfield(colorstruct,handles.curses.cells(r).name(1:end-4))==0
                mycol='k';
            else
                mycol=colorstruct.(handles.curses.cells(r).name(1:end-4)).color;
            end
            set(hbar,'EdgeColor',mycol)
            set(hbar,'FaceColor',mycol)

            bd=ylabel(handles.curses.cells(r).name(1:3));
            set(bd,'Units','character')
            grid off %on
            box on %off
            xlim([0 140])%SimDuration])
            hold on
%             filteredlfp=mikkofilter(handles.curses.lfp,1000/RunArray(ind).lfp_dt);
%             tmppeaks=findpeaks(max(filteredlfp(:,2))-filteredlfp(:,2));
%             if isstruct(tmppeaks)
%                 peaks = filteredlfp(tmppeaks.loc,1);
%                 tmppeaks=tmppeaks.loc;
%             else
%             [~, tmppeaks]=findpeaks(filteredlfp(:,2));
%                 peaks = filteredlfp(tmppeaks,1);
%             end
%             yy=ylim;
%             plot(handles.curses.lfp(:,1),(handles.curses.lfp(:,2)-min(handles.curses.lfp(:,2)))/(max(handles.curses.lfp(:,2))-min(handles.curses.lfp(:,2)))*yy(2),'g','LineWidth',2)
%             plot(filteredlfp(:,1),(filteredlfp(:,2)-min(filteredlfp(:,2)))/(max(filteredlfp(:,2))-min(filteredlfp(:,2)))*yy(2),'m','LineWidth',2)
%             ylim(yy);
            
            if z>1
                set(haxis, 'xtickLabel',[])
            else
                xlabel('Time (ms)')
            end
            mm=get(gca,'ytickLabel');
            for mym=1:length(mm)-1
                mm{mym}='';
            end
            gm=get(gca,'ytick');
            tstr=num2str(gm(end));
            if strcmp(tstr(end-2:end),'000')
                mm{end}=[tstr(1:(end-3)) 'K'];
            end
            set(gca,'ytickLabel',mm);
            myz=strmatch(handles.curses.cells(r).name,mycellstr,'exact');
            bd=ylabel(NiceAbbrev{myz},'Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',14);
            set(bd, 'Units', 'Normalized', 'Position', [-0.005, 0.08, 0]);
            set(bd,'Units','character')            
        end
        set(gcf, 'CurrentAxes', haxis, 'Color', 'w')
        title('Spike Histogram per Cell Type (Spikes/ms)')
        %title(['Spike Histogram: ', num2str(length(handles.curses.cells)-1),' cell types, ',num2str(SimDuration),' ms'])
        
    case 'pyrpos'     
%         if isfield(handles.curses,'position')==0
%             getposition(handles.btn_generate,guidata(handles.btn_generate))
%             handles=guidata(handles.btn_generate);
%         end
        for r=1:length(handles.curses.cells) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            if strcmp(handles.curses.cells(r).name,'pyramidalcell')==1
            %if strcmp(handles.curses.cells(r).name,'bistratifiedcell')==1
                myrs = r;
            end
        end
        mypyridx = find(handles.curses.spikerast(:,3)==handles.curses.cells(myrs).ind);
        positions2plot=handles.curses.spikerast(mypyridx,1:2);

        tmpz = regexp(RunArray(end).LayerHeights,';','split');
        for z=2:str2num(tmpz{1})
            tmpLayer(z-1) = str2num(tmpz{z});
        end
        
        LayerLength = tmpLayer(2);
        ZHeight = tmpLayer(1);
        
        dimidx=[3 4 5];
        labels={'Longitudinal Length (um)','Transverse Length (um)','Height (um)'};
        posprops={'LongitudinalLength','TransverseLength','LayerHeights'};
        dims={'x','y','z'};
        dimvals=[RunArray(ind).LongitudinalLength RunArray(ind).TransverseLength LayerLength];
        dimvalLim= [0 RunArray(ind).LongitudinalLength;
                    0 RunArray(ind).TransverseLength;
                    ZHeight ZHeight+LayerLength];
        
        
        BinInfo = setBins(handles.curses.cells(myrs).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerLength);
        pos = getpos(positions2plot(:,2), handles.curses.cells(myrs).range_st, BinInfo, ZHeight); %positions2plot(z,2)
        positions2plot(:,dimidx(1)) = [pos.(dims{1})];
        positions2plot(:,dimidx(2)) = [pos.(dims{2})];
        positions2plot(:,dimidx(3)) = [pos.(dims{3})];
        
        for whichdim=dimidx
            otherdims=setxor(whichdim,dimidx);
            if whichdim==dimidx(1)
                otherdims = [otherdims(2:end) otherdims(1)];
            end
            myz=linspace(min(positions2plot(:,whichdim)),max(positions2plot(:,whichdim))+1, 6);
            for myzidx=1:length(myz)-1
                % firstzidx = find(positions2plot(:,whichdim)==myz(myzidx));
                firstzidx = find(positions2plot(:,whichdim)>=myz(myzidx) & positions2plot(:,whichdim)<myz(myzidx+1));

                plot3(positions2plot(firstzidx,otherdims(1)),positions2plot(firstzidx,otherdims(2)),positions2plot(firstzidx,1),'LineStyle','none','Marker',mksty,'Color','k','MarkerSize',msz)
                xlabel(labels{otherdims(1)-2})%'Longitudinal Length (um)')
                ylabel(labels{otherdims(2)-2})%'Transverse Length (um)')
                zlabel('Time (ms)')
                view([0 0])
                xlim([dimvalLim(otherdims(1)-2,1) dimvalLim(otherdims(1)-2,2)])
                zlim([0 SimDuration])
                zt = get(gca,'ZTick');
                hold on
                for z=zt
                    plot3([dimvalLim(otherdims(1)-2,1) dimvalLim(otherdims(1)-2,2)],[0 0],[z z],'r')
                    plot3([0 0],[dimvalLim(otherdims(2)-2,1) dimvalLim(otherdims(2)-2,2)],[z z],'r')
                end
                title([labels{whichdim-2}(1:end-5) ' ' num2str(myz(myzidx)) '-' num2str(myz(myzidx+1)) labels{whichdim-2}(end-4:end) ' (slice ' num2str(myzidx) '/' num2str(length(myz)-1) ')'])
                if myzidx<length(myz)-1 || whichdim>3
                    figure('Color','w')
                end
            end
        end
        
    otherwise
        for r=[handles.curses.cells(:).ind]
            plotind=find(handles.curses.spikerast(:,idx)==r);
            try
            plot(handles.curses.spikerast(plotind,1),handles.curses.spikerast(plotind,2),'Color',handles.formatP.colorvec{r+1},'LineStyle','none','Marker',mksty,'MarkerSize',handles.formatP.sizevec{r+1})
            catch ME
                ME
            end
            hold on
        end
        set(gca,'FontName','ArialMT','FontWeight','bold','FontSize',14)
        %set(gca,'FontUnits','points','FontSize',12)
        xlabel('Time (ms)') %,'FontName','Verdana'
        ylabel('Cell')
        title('Spike Raster','FontSize',16)
        set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
        customizeraster
        handles.formatP.hleg=legend(handles.curses.cells(:).name,'Location','NorthEastOutside');
        grid off
        handles.formatP.hfig=gcf;
        set(handles.formatP.hfig,'Units','normalized','OuterPosition',[0 .05 .95 .95])
        
end

ch=get(gcf,'Children');
if length(ch)>1
    linkaxes(ch,'x');
end

if ~isempty(savepath), fclose(fid); end;

