function h = plot_websitemore(handles,varargin)
global mypath RunArray sl
% try
h=[]; %figure;
return;
idx = handles.curses.ind;
ind = handles.curses.ind;
figformat='png';
if length(varargin)>0
    figpath=varargin{1};
else
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
    q=find([myrepos.current]==1);
    wtmp=strfind(myrepos(q).dir,sl);
    pathway=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
    if exist(pathway,'dir')==0
        mkdir(pathway)
    end
    figpath=[figpath sl 'results' sl];
end
mkdir([figpath RunArray(ind).RunName]);

fidrunsum=fopen([figpath 'allruns.txt'],'a');

ycolvec={[0 .4 .4],[.5 0 .3]};

nrninput = gettheta;

if isfield(handles.curses,'spikerast')==0
    spikeraster(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'spikerast')==1 && size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end

%%%%%%%%%%%%%
%  RASTERS  %
%%%%%%%%%%%%%
        NiceAbbrev = {'Pyr.','O-LM','Bis.','Axo.','PV+ B.','CCK+ B.','S.C.-A.','Ivy','NGF.'};
        dd=figure('Color','w');
        colorvec = [0 147 221; 0 146 63; 0 0 0]/255;

        ones2plot=0;
        myrs=[];
        for r=1:RunArray(ind).NumCellTypes % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            myidx=strmatch(handles.curses.cells(r).name,{'pyramidalcell','olmcell','bistratifiedcell','axoaxoniccell','pvbasketcell','cckcell','scacell','ivycell','ngfcell'},'exact');
            if ~isempty(myidx)
                myrs(myidx)=r;
            end
            ones2plot=ones2plot+1;
        end
        normrange = ([handles.curses.cells(myrs).numcells]).^(1/11)-handles.formatP.marg; % 1/11 1/3
        
        normrange(1) = normrange(1)*4; % 1/11 1/3
        normsize = normrange/sum(normrange)*(1-((ones2plot-1)*handles.formatP.marg+handles.formatP.bottom*2+.01));
        normy = [handles.formatP.bottom*2 normsize(1:end-1)+ handles.formatP.marg];

        for z=1:length(myrs) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            r=myrs(z);
            haxis=subplot('Position', [handles.formatP.left*2 sum(normy(1:z)) .9-handles.formatP.left normsize(z)]);
            outind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
            if (strcmp(handles.curses.cells(r).techname(1:2),'pp')==1 & handles.curses.cells(r).numcells>5000)
                plot(handles.curses.spikerast(outind,1),handles.curses.spikerast(outind,2),'Color','k','LineStyle','none','Marker','.')
            else
                plot(handles.curses.spikerast(outind,1),handles.curses.spikerast(outind,2),'Color','k','LineStyle','none','Marker','.')
            end

            g=strmatch(handles.curses.cells(r).name,{nrninput(:).tech});

                bd=ylabel(NiceAbbrev{z},'Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',14);
                set(bd, 'Units', 'Normalized', 'Position', [-0.03, 0.3, 0]);

%                 if ~isempty(g)
%                 y=ylabel(nrninput(g(1)).name,'FontName','Verdana','FontSize',8,'FontWeight','Bold','rot',0,'Position',[0 sum(normy(1:z))+normsize(z)/2 0]);
%             else
%                 y=ylabel(handles.curses.cells(r).name,'FontName','Verdana','FontSize',8,'FontWeight','Bold','rot',0,'Position',[0 sum(normy(1:z))+normsize(z)/2 0]);
%             end
% 
%             set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
            
            grid off %on
            box on %off
            xlim([0 RunArray(ind).SimDuration])
         
            if handles.curses.cells(r).range_en==handles.curses.cells(r).range_st
                ylim([handles.curses.cells(r).range_st-.5 handles.curses.cells(r).range_st+.5])
            else
                ylim([handles.curses.cells(r).range_st-.5 handles.curses.cells(r).range_en+.5])
            end
            step=ceil((handles.curses.cells(r).range_en-handles.curses.cells(r).range_st)/5);
            if step==0, step=1; end
                if mod(handles.curses.cells(r).range_en-handles.curses.cells(r).range_st,step)>.75*step
                    set(haxis, 'ytick',[handles.curses.cells(r).range_st:step:handles.curses.cells(r).range_en handles.curses.cells(r).range_en], 'ycolor', [.5 .5 .5], 'xcolor',  [.5 .5 .5])
                else
                    set(haxis, 'ytick',[handles.curses.cells(r).range_st:step:handles.curses.cells(r).range_en], 'ycolor', [.5 .5 .5], 'xcolor', [.5 .5 .5])
                end
            if z>1
                set(haxis, 'xtickLabel',[])
            else
                    xlabel('Time (ms)','FontName','ArialMT','FontWeight','bold','FontSize',14)
                    set(haxis,'FontName','ArialMT','FontWeight','bold','FontSize',14)
            end
                set(haxis, 'ytickLabel',[])
                set(haxis,'FontName','Verdana','FontSize',8,'FontWeight','Bold')
        end

        set(dd, 'Color', 'w','Position',[1 41 1366 651])
        p = get(dd,'Position');
        set(dd,'PaperUnits','inches','PaperSize',[p(3) p(4)]./get(0,'ScreenPixelsPerInch'))
        set(dd,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait');
        print(dd,['-d' figformat],'-r200', [figpath  RunArray(ind).RunName '\spikeraster.' figformat])
        %close(dd)
h=dd;
%%%%%%%%%%%%
        dd=figure('Color','w');
       colorvec = [0 147 221; 0 146 63; 0 0 0]/255;

        ones2plot=0;
        myrs=[];
        for r=1:RunArray(ind).NumCellTypes % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            if (strcmp(handles.curses.cells(r).techname(1:2),'pp')==1) %&& strcmp(handles.curses.cells(r).techname(1:3),'poo')~=1
                myrs = [myrs r];
                ones2plot=ones2plot+1;
            end
        end
        normrange = ([handles.curses.cells(myrs).numcells]).^(1/11)-handles.formatP.marg; % 1/11 1/3
        
        normsize = normrange/sum(normrange)*(1-((ones2plot-1)*handles.formatP.marg+handles.formatP.bottom+.01));
        normy = [handles.formatP.bottom normsize(1:end-1)+ handles.formatP.marg];

        for z=1:length(myrs) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            r=myrs(z);
            haxis=subplot('Position', [handles.formatP.left*2 sum(normy(1:z)) .9-handles.formatP.left normsize(z)]);
            outind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
            if (strcmp(handles.curses.cells(r).techname(1:2),'pp')==1 & handles.curses.cells(r).numcells>5000)
                plot(handles.curses.spikerast(outind,1),handles.curses.spikerast(outind,2),'Color','k','LineStyle','none','Marker','.')
            else
                plot(handles.curses.spikerast(outind,1),handles.curses.spikerast(outind,2),'Color','k','LineStyle','none','Marker','.')
            end

            g=strmatch(handles.curses.cells(r).name,{nrninput(:).tech});

            if ~isempty(g)
                y=ylabel(nrninput(g(1)).name,'FontName','Verdana','FontSize',8,'FontWeight','Bold','rot',0,'Position',[0 sum(normy(1:z))+normsize(z)/2 0]);
            else
                y=ylabel(handles.curses.cells(r).name,'FontName','Verdana','FontSize',8,'FontWeight','Bold','rot',0,'Position',[0 sum(normy(1:z))+normsize(z)/2 0]);
            end

            set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
            
            grid off %on
            box on %off
            xlim([0 RunArray(ind).SimDuration])
         
            if handles.curses.cells(r).range_en==handles.curses.cells(r).range_st
                ylim([handles.curses.cells(r).range_st-.5 handles.curses.cells(r).range_st+.5])
            else
                ylim([handles.curses.cells(r).range_st-.5 handles.curses.cells(r).range_en+.5])
            end
            step=ceil((handles.curses.cells(r).range_en-handles.curses.cells(r).range_st)/5);
            if step==0, step=1; end
            if mod(handles.curses.cells(r).range_en-handles.curses.cells(r).range_st,step)>.75*step
                set(haxis, 'ytick',[handles.curses.cells(r).range_st:step:handles.curses.cells(r).range_en handles.curses.cells(r).range_en], 'ycolor', ycolvec{mod(r+1,length(ycolvec))+1}, 'xcolor', ycolvec{mod(r+1,length(ycolvec))+1})
            else
                set(haxis, 'ytick',[handles.curses.cells(r).range_st:step:handles.curses.cells(r).range_en], 'ycolor', ycolvec{mod(r+1,length(ycolvec))+1}, 'xcolor', ycolvec{mod(r+1,length(ycolvec))+1} )
            end
            if z>1
                set(haxis, 'xtickLabel',[])
            else
                xlabel('Time (ms)','FontName','Verdana','FontSize',8,'FontWeight','Bold')
            end
                set(haxis, 'ytickLabel',[])
                set(haxis,'FontName','Verdana','FontSize',8,'FontWeight','Bold')
        end

        set(dd, 'Color', 'w','Position',[1 41 1366 651])
        p = get(dd,'Position');
        set(dd,'PaperUnits','inches','PaperSize',[p(3) p(4)]./get(0,'ScreenPixelsPerInch'))
        set(dd,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait');
        print(dd,['-d' figformat],'-r200', [figpath  RunArray(ind).RunName '\stimraster.' figformat])
        close(dd)

%%%%%%%%%%%%

        dg=figure('Color','w');
        ones2plot=0;
        myrs=[];
        for r=1:RunArray(ind).NumCellTypes % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            if (strcmp(handles.curses.cells(r).techname(1:2),'pp')~=1) %&& strcmp(handles.curses.cells(r).techname(1:3),'poo')~=1
                myrs = [myrs r];
                ones2plot=ones2plot+1;
            end
        end
        
        normrange = ([handles.curses.cells(myrs).numcells]).^(1/11)-handles.formatP.marg; % 1/11 1/3
        normsize = normrange/sum(normrange)*(1-((ones2plot-1)*handles.formatP.marg+handles.formatP.bottom+.01));
        normy = [handles.formatP.bottom normsize(1:end-1)+ handles.formatP.marg];

        for z=1:length(myrs) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            r=myrs(z);
            haxis=subplot('Position', [handles.formatP.left*2 sum(normy(1:z)) .9-handles.formatP.left normsize(z)]);
            
            croprast=handles.curses.spikerast(handles.curses.spikerast(:,1)>30,:);
            outind=find(croprast(:,3)==handles.curses.cells(r).ind);
            binsize=1; %5
            N=histc(croprast(outind,1),[0:binsize:RunArray(ind).SimDuration]);
            hbar=bar([0:binsize:RunArray(ind).SimDuration],N);
            set(hbar,'EdgeColor','none')
            set(hbar,'FaceColor','k')

            g=strmatch(handles.curses.cells(r).name,{nrninput(:).tech});

            if ~isempty(g)
                y=ylabel(nrninput(g(1)).name,'FontName','Verdana','FontSize',8,'FontWeight','Bold','rot',0)
            else
                y=ylabel(handles.curses.cells(r).name,'FontName','Verdana','FontSize',8,'FontWeight','Bold','rot',0)
            end   
            
            set(y, 'Units', 'Normalized', 'Position', [-.1, 0.5, 0]);
            
            grid off %on
            box on %off
            xlim([0 RunArray(ind).SimDuration])
            if z>1
                set(haxis, 'xtickLabel',[])
            else
                xlabel('Time (ms)','FontName','Verdana','FontSize',8,'FontWeight','Bold')
            end
                set(haxis,'FontName','Verdana','FontSize',8,'FontWeight','Bold')
        end

        set(dg, 'Color', 'w','Position',[1 41 1366 651])
        p = get(dg,'Position');
        set(dg,'PaperUnits','inches','PaperSize',[p(3) p(4)]./get(0,'ScreenPixelsPerInch'))
        set(dg,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait');
        set(dg, 'CurrentAxes', haxis, 'Color', 'w','Position',[1 41 1366 651])
        set(gca,'FontName','Verdana','FontSize',8,'FontWeight','Bold')
        print(dg,['-d' figformat],'-r200', [figpath  RunArray(ind).RunName '\spikehist.' figformat])
        close(dg)

%%%%%%%%%%%%

        dg=figure('Color','w');
        ones2plot=0;
        myrs=[];
        for r=1:RunArray(ind).NumCellTypes % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            if (strcmp(handles.curses.cells(r).techname(1:2),'pp')==1) %&& strcmp(handles.curses.cells(r).techname(1:3),'poo')~=1
                myrs = [myrs r];
                ones2plot=ones2plot+1;
            end
        end
        
        normrange = ([handles.curses.cells(myrs).numcells]).^(1/11)-handles.formatP.marg; % 1/11 1/3
        normsize = normrange/sum(normrange)*(1-((ones2plot-1)*handles.formatP.marg+handles.formatP.bottom+.01));
        normy = [handles.formatP.bottom normsize(1:end-1)+ handles.formatP.marg];

        for z=1:length(myrs) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
            r=myrs(z);
            haxis=subplot('Position', [handles.formatP.left*2 sum(normy(1:z)) .9-handles.formatP.left normsize(z)]);
            
            croprast=handles.curses.spikerast(handles.curses.spikerast(:,1)>30,:);
            outind=find(croprast(:,3)==handles.curses.cells(r).ind);
            binsize=1; %5
            N=histc(croprast(outind,1),[0:binsize:RunArray(ind).SimDuration]);
            hbar=bar([0:binsize:RunArray(ind).SimDuration],N);
            set(hbar,'EdgeColor','none')
            set(hbar,'FaceColor','k')

            g=strmatch(handles.curses.cells(r).name,{nrninput(:).tech});

            if ~isempty(g)
                y=ylabel(nrninput(g(1)).name,'FontName','Verdana','FontSize',8,'FontWeight','Bold','rot',0)
            else
                y=ylabel(handles.curses.cells(r).name,'FontName','Verdana','FontSize',8,'FontWeight','Bold','rot',0)
            end   
            
            set(y, 'Units', 'Normalized', 'Position', [-.1, 0.5, 0]);
            
            grid off %on
            box on %off
            xlim([0 RunArray(ind).SimDuration])
            if z>1
                set(haxis, 'xtickLabel',[])
            else
                xlabel('Time (ms)','FontName','Verdana','FontSize',8,'FontWeight','Bold')
            end
                set(haxis,'FontName','Verdana','FontSize',8,'FontWeight','Bold')
        end

        set(dg, 'Color', 'w','Position',[1 41 1366 651])
        p = get(dg,'Position');
        set(dg,'PaperUnits','inches','PaperSize',[p(3) p(4)]./get(0,'ScreenPixelsPerInch'))
        set(dg,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait');
        set(dg, 'CurrentAxes', haxis, 'Color', 'w','Position',[1 41 1366 651])
        set(gca,'FontName','Verdana','FontSize',8,'FontWeight','Bold')
        print(dg,['-d' figformat],'-r200', [figpath  RunArray(ind).RunName '\stimhist.' figformat])
        close(dg)

%%%%%%%%%%
%  FIRE  %
%%%%%%%%%%

croptime=0; %2000;
cropidx=find(handles.curses.spikerast(:,1)>croptime);
handles.curses.croprast=handles.curses.spikerast(cropidx,:);

if isfield(handles.curses,'croprast') && ~isempty(handles.curses.croprast) && size(handles.curses.croprast,2)>1
    for r=1:length(handles.curses.cells)
        y=histc(handles.curses.croprast(:,2),handles.curses.cells(r).range_st:handles.curses.cells(r).range_en);
        handles.curses.cells(r).data(1) = length(find(y==0));
        handles.curses.cells(r).data(2) = min(y);
        handles.curses.cells(r).data(3) = max(y);
        handles.curses.cells(r).data(4) = mean(y/((RunArray(idx).SimDuration-croptime)/1000));
        handles.curses.cells(r).data(5) = std(y);
        handles.curses.cells(r).data(6) = mean(y(y~=0)/((RunArray(idx).SimDuration-croptime)/1000));
        handles.curses.cells(r).data(7) = length(find(handles.curses.croprast(:,2)>=handles.curses.cells(r).range_st & handles.curses.croprast(:,2)<=handles.curses.cells(r).range_en));
    end
else
    for r=1:length(handles.curses.cells)
        handles.curses.cells(r).data(1) = handles.curses.cells(r).numcells;
        for z=2:6
            handles.curses.cells(r).data(z) = 0;
        end
    end
end

realidx=[];
popfire=[];
subfire=[];
for r=1:length(handles.curses.cells)
    if strcmp(handles.curses.cells(r).techname,'ppspont')==0
        realidx=[realidx r];
    end
    awake(r)=NaN;
    anesth(r)=NaN;
    popfire(r)=handles.curses.cells(r).data(4);
    subfire(r)=handles.curses.cells(r).data(6);
    %popfire(r)=NaN;
    %subfire(r)=NaN;
    awakeref{r}='';
    awakeurl{r}='';
    anesthurl{r}='';
    anesthref{r}='';
end
if exist('firingrates.mat','file')
    load firingrates.mat firingrates
    for r=realidx 
        awake(r)=NaN;
        anesth(r)=NaN;
        awakeref{r}='';
        awakeurl{r}='';
        anesthurl{r}='';
        anesthref{r}='';
        mynames{r}=handles.curses.cells(realidx(r)).name;
        myi=find(strcmp(handles.curses.cells(r).name,{firingrates(:).celltype})==1);
        if ~isempty(myi)
            awake(r)=firingrates(myi).awake;
            anesth(r)=firingrates(myi).anesth;
            if strmatch(firingrates(myi).notes,'est.')
                mynames{r}=[handles.curses.cells(realidx(r)).name(1:end-4) '*'];
            end
        end
        g = strmatch(handles.curses.cells(realidx(r)).name,{nrninput(:).tech});
        for k=1:length(g)
            switch nrninput(g(k)).state
                case 'an'
                    try
                        anesth(r)=nrninput(g(k)).firingrate;
                    end
                    anesthref{r} = nrninput(g(k)).cite;
                    anesthurl{r} = nrninput(g(k)).url;
                case 'wr'
                    awake(r)=nrninput(g(k)).firingrate;
                    awakeref{r} = nrninput(g(k)).cite;
                    awakeurl{r} = nrninput(g(k)).url;
                case 'wf'
                    awake(r)=nrninput(g(k)).firingrate;
                    awakeref{r} = nrninput(g(k)).cite;
                    awakeurl{r} = nrninput(g(k)).url;
            end
        end
    end
end
guidata(handles.btn_generate, handles)

fidout=fopen([figpath RunArray(ind).RunName '\fire.txt'],'w');
fidout2=fopen([figpath RunArray(ind).RunName '\stimtable.txt'],'w');


for r=1:length(handles.curses.cells)
    tmp=handles.curses.cells(r).name;
    fprintf(fidout,'%s,%.1f,%s,%s,%.1f,%s,%s,%.1f,%.1f,%.1f,%.1f\n', tmp, awake(r), awakeurl{r}, awakeref{r}, anesth(r), anesthurl{r}, anesthref{r}, handles.curses.cells(r).data(6), handles.curses.cells(r).data(4),  ...
        handles.curses.cells(r).data(3), handles.curses.cells(r).data(1)/handles.curses.cells(r).numcells*100);
    if strcmp(handles.curses.cells(r).techname(1:2),'pp')==1
        fprintf(fidout2,'%s,%.0f,%.0f,%.0f,%.1f,%.1f,%.1f\n', tmp, handles.curses.cells(r).numcells, handles.curses.cells(r).data(7), handles.curses.cells(r).data(1)/handles.curses.cells(r).numcells*100, ...
        handles.curses.cells(r).data(3), handles.curses.cells(r).data(6), handles.curses.cells(r).data(4));
    end
    
    if strcmp(handles.curses.cells(r).name,'pyramidalcell')==1
        summary.firerate = handles.curses.cells(r).data(6);
        summary.poprate = handles.curses.cells(r).data(4);
    end
end
fclose(fidout);
fclose(fidout2);

hh=[];
    hh(1)=figure('color','w','Name','Population Firing Rates','units','normalized','outerposition',[0 0 1 1]);
    bar([popfire' anesth' awake'])
    set(gca,'xticklabel',mynames)
    ylabel('Firing frequency (Hz)')
    title([RunArray(idx).RunName ': Average firing rate of population'],'Interpreter','none')
    legend({'Model','Exp. Anesth.','Exp. Awake'})

    hh(2)=figure('color','w','Name','Subset Firing Rates','units','normalized','outerposition',[0 0 1 1]);
    bar([subfire' anesth' awake'])
    set(gca,'xticklabel',mynames)
    ylabel('Firing frequency (Hz)')
    title([RunArray(idx).RunName ': Average firing rate of firing cells (* means awake data was estimated)'],'Interpreter','none')
    legend({'Model','Exp. Anesth.','Exp. Awake'})

    print(hh(1),['-d' figformat],'-r200', [figpath  RunArray(ind).RunName '\popfire.' figformat])
    print(hh(2),['-d' figformat],'-r200', [figpath  RunArray(ind).RunName '\subfire.' figformat])
close(hh)

%%%%%%%%%
%  FFT  %
%%%%%%%%%


fidout=fopen([figpath RunArray(ind).RunName '\fft.txt'],'w');
fidout2=fopen([figpath RunArray(ind).RunName '\fftind.txt'],'w');
fidout3=fopen([figpath RunArray(ind).RunName '\fftnorm.txt'],'w');

h=[];
ind = handles.curses.ind;
celldata.xx=[];
celldata.yy=[];
celldata.zz=[];
legstr={};
reOrder=[];
for r=1:length(handles.curses.cells)
    if strcmp(handles.curses.cells(r).name,'pyramidalcell')==1 || strcmp(handles.curses.cells(r).name,'ca3cell')==1 || strcmp(handles.curses.cells(r).name,'eccell')==1
        reOrder = [r reOrder];
    else
        reOrder(r) = r;
    end
end

for rtmp=1:length(reOrder)
    r = reOrder(rtmp);
    idx = find(handles.curses.spikerast(:,2)>=handles.curses.cells(r).range_st & handles.curses.spikerast(:,2)<=handles.curses.cells(r).range_en);
    idt = find(handles.curses.spikerast(idx,1)>200);
 
    rez=1; % .1 is simulation resolution

    Fs = 1000/rez; % sampling frequency (per s)

    bins=[0:rez:RunArray(ind).SimDuration];
    y=histc(handles.curses.spikerast(idx(idt),1),bins);
    y = y-sum(y)/length(y);

    NFFT = 2^(nextpow2(length(y))+2); % Next power of 2 from length of y
    Y = fft(y,NFFT)/length(y);
    f = Fs/2*linspace(0,1,NFFT/2+1);
    fft_results = 2*abs(Y(1:NFFT/2+1));
    
    theta_range=find(f(:)>=4 & f(:)<=12);
    [thetapower, peak_idx] = max(fft_results(theta_range));
    gamma_range=find(f(:)>=25 & f(:)<=80);
    [gammapower, gamma_idx] = max(fft_results(gamma_range));
    rel_range=find(f(:)>2 & f(:)<=100);
    [peakpower, over_idx] = max(fft_results(rel_range));
    bandpower = sum(fft_results(theta_range))/length(theta_range);

    fprintf(fidout,'%s,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f\n',handles.curses.cells(r).name, f(rel_range(over_idx)), peakpower, f(theta_range(peak_idx)), thetapower, f(gamma_range(gamma_idx)), gammapower)    
    
    if strcmp(handles.curses.cells(r).name,'pyramidalcell')==1
        mytheta = f(theta_range(peak_idx));
        mygamma = f(gamma_range(gamma_idx));
        summary.freq = f(theta_range(peak_idx));
        summary.power = fft_results(theta_range(peak_idx))
    end
    
    % Plot single-sided amplitude spectrum.
    handles.curses.cells(r).f=f;
    handles.curses.cells(r).fft_results=fft_results;
    celldata.xx=f;
    %if strcmp(handles.curses.cells(r).name,'pyramidalcell')==myflag || strcmp(handles.curses.cells(r).name,'ca3cell')==myflag || strcmp(handles.curses.cells(r).name,'eccell')==myflag
        celldata.yy=[celldata.yy ; ones(size(f))*r];
try
        celldata.zz=[celldata.zz ;  fft_results'./max(fft_results)];
catch
        celldata.zz=[celldata.zz ;  fft_results./max(fft_results)];
end
        g=strmatch(handles.curses.cells(r).name,{nrninput(:).tech});
        
        if ~isempty(g)
            legstr{length(legstr)+1}=nrninput(g(1)).name;
        else
            legstr{length(legstr)+1}=handles.curses.cells(r).name;
        end
    %end
end

for r=1:length(handles.curses.cells)    
    skipme=1;
    endidx = find(handles.curses.cells(r).f<=100,1,'last');
    xstring = sprintf('%f,',handles.curses.cells(r).f(1:skipme:endidx)); % concatenate times together, separated by commas
    ystring = sprintf('%f,',handles.curses.cells(r).fft_results(1:skipme:endidx)); % concatenate PSP values together, separated by commas
    fprintf(fidout2,'%s,%s\n',handles.curses.cells(r).name,xstring(1:end-1));
    fprintf(fidout2,'%s,%s\n',handles.curses.cells(r).name,ystring(1:end-1));

    xstring = sprintf('%f,',handles.curses.cells(r).f(1:skipme:endidx)); % concatenate times together, separated by commas
    ystring = sprintf('%f,',handles.curses.cells(r).fft_results(1:skipme:endidx)./max(handles.curses.cells(r).fft_results(1:endidx))); % concatenate PSP values together, separated by commas
    fprintf(fidout3,'%s,%s\n',handles.curses.cells(r).name,xstring(1:end-1));
    fprintf(fidout3,'%s,%s\n',handles.curses.cells(r).name,ystring(1:end-1));
end

fclose(fidout2);
fclose(fidout3);

bb = figure('Color','w');

z=imagesc(celldata.xx,[1:3],flipud(celldata.zz));
xlim([0 100])
colormap(jet)
colorbar
set(gca,'yticklabel',fliplr(legstr))
xlim([0 100])
xlabel('Frequency (Hz)','FontName','Verdana','FontSize',8,'FontWeight','Bold')
legstr'
guidata(handles.btn_generate, handles)
p=get(bb,'Position');
set(bb,'Position',[p(1) p(2) p(3)*3 p(4)]);
set(bb,'PaperUnits','inches','PaperSize',[p(3)*3 p(4)]./get(0,'ScreenPixelsPerInch'))
set(bb,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait');
set(gca,'FontName','Verdana','FontSize',8,'FontWeight','Bold')
print(bb,['-d' figformat],'-r200', [figpath  RunArray(ind).RunName '\fftmap.' figformat])
close(bb)

%%%%%%%%%
% PHASE %
%%%%%%%%%

%%% Theta
myHz = mytheta;

timehalf=12; % Remove first 1/timehalf of simulation from analysis (under the assumption that the network needed that time to stabilize)

ind = handles.curses.ind;

if ~isempty(deblank(handles.optarg)) && ~isempty(str2num(handles.optarg))
    myHz = str2num(handles.optarg);
end

thetaper=1000/myHz;

if thetaper<50
    refphase = 0;
else
    refphase = 20;
end

spikerast = handles.curses.spikerast;

mycells = importdata([RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName '/celltype.dat']);
numcelltypes = size(mycells.data,1);%-1;

for r=1:numcelltypes
    celltypevec{r} = mycells.textdata{r+1,1};%2,1};
    numcellsvec(r) = mycells.data(r,3) - mycells.data(r,2) + 1; %+1
end


tstop = RunArray(ind).SimDuration; %700;%

if timehalf>1
   time_idx=find(spikerast(:,1)>=(tstop/timehalf));
else
    time_idx=[1:size(spikerast,1)];
end

spikerast=spikerast(time_idx,:);

[x,y] = pol2cart(0,1);
bh=figure('Color','w');
h_fake=compass(x,y);
hold on

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
      
legstr={};
legh=[];
for r=1:length(celltypevec)
    celltype = celltypevec{r};
    z = strmatch(celltype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','supercell','deepcell'});
    zidx = find(spikerast(:,3)==r-1);
    numcells = numcellsvec(r);
    
    g=strmatch(celltype,{nrninput(:).tech});

    if ~isempty(g)
        legstr{length(legstr)+1}=nrninput(g(1)).name;
    else
        legstr{length(legstr)+1}=celltype;
    end    
    
    % legstr{length(legstr)+1}=[celltype ' (' num2str(numcells) ' cells)'];
    
    spiketimes = spikerast(zidx,1);

    n=length(spiketimes);
    modspiketimes = mod(spiketimes, thetaper);

    xbar = 1/n*sum(sin(modspiketimes*pi/(thetaper/2)));
    ybar = 1/n*sum(cos(modspiketimes*pi/(thetaper/2)));

    magnitude(r)=sqrt(xbar^2+ybar^2);
    if xbar>0
        angle = acos(ybar/magnitude(r));
    else
        angle = 2*pi - acos(ybar/magnitude(r));
    end

    rdir(r) = angle; % * pi/180;
    if ~isempty(z) && z==1
        pyrangle=angle;
    end
% http://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics/content/circ_rtest.m
    if ~isempty(modspiketimes)
        [pval zval] = circ_rtest(modspiketimes*pi/(thetaper/2));
        %disp([celltype ': pval of ' num2str(pval) '. z statistic of ' num2str(zval) ', my r: ' num2str(magnitude(r))])
    else
        %disp([celltype ' had no spikes to analyze'])
    end
end

if isdeployed
    usepyrspikes=0;
else
    myvers=ver;
    g=strcmp({myvers(:).Name},'Signal Processing Toolbox');
    if sum(g)>0
        usepyrspikes=0;
    else
        usepyrspikes=1;
    end
end

usepyrspikes=1;

if usepyrspikes
    refangle=refphase/180*pi;
    pyrangle_shift=pyrangle-refangle;
    % disp('Set the pyramidal cell angle to the reference angle of 20^o')
else % use pyramidal intracellular peaks
    refangle=0;
    pyrangle=getpyramidalphase(handles,[myHz myHz],0);
    pyrangle_shift=pyrangle-refangle;
end

zz=1;
for r=1:length(celltypevec)
    rdir(r) = rdir(r)-pyrangle_shift;
    [x,y] = pol2cart(rdir(r),magnitude(r));
    k=compass(x,y);
    legh(length(legh)+1)=k;
    celltype = celltypevec{r};
    z = strmatch(celltype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','supercell','deepcell'});
    if isempty(z)
        set(k,'Color','k','LineWidth',4);
    else
        final_angle(z) = rdir(r)*180/pi;
        if rdir(r)<0
            final_angle(z) = (rdir(r)+2*pi)*180/pi;
        end
        set(k,'Color',colorvec(z,:),'LineWidth',4);
        % disp([celltype ': ' num2str(final_angle(z))])
        cellsdata(zz).name = celltype;
        cellsdata(zz).phase = mod(rdir(r),2*pi)*180/pi;
        cellsdata(zz).offset = [0 0];
        cellsdata(zz).color = colorvec(z,:);
        zz=zz+1;
    end
end

for r=1:length(celltypevec)
    phaseresults(r).name = celltypevec{r};
    phaseresults(r).theta = mod((rdir(r)-pyrangle_shift)*180/pi,360);
    phaseresults(r).thetamag = magnitude(r);
end

set(h_fake,'Visible','off');

legend(legh,legstr,'Location','BestOutside')

% if timehalf>1
%     title({[RunArray(ind).RunName ' theta preferred firing phase distribution'],['and strength of modulation at ' num2str(1000/thetaper) ' Hz'],[' (first 1/' num2str(timehalf) ' of time removed from analysis)']},'Interpreter','none')
% else
%     title({[RunArray(ind).RunName ' theta preferred firing phase distribution'],['and strength of modulation at ' num2str(1000/thetaper) ' Hz']},'Interpreter','none')
% end

set(gca,'FontName','Verdana','FontSize',12,'FontWeight','Bold')
print(bh,['-d' figformat],'-r200', [figpath  RunArray(ind).RunName '\thetacompass.' figformat])
close(bh)

summary.phasediffs=Website_Phases_Figure(cellsdata,myHz,'theta',RunArray(ind).RunName);
%set(hz,'Position',[p(1) p(2) p(3)*3 p(4)]);
% set(hz2,'PaperUnits','inches','PaperSize',[p(3) p(4)]./get(0,'ScreenPixelsPerInch'))
% set(hz2,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait');
% print(hz,['-d' figformat], [figpath 'lfpthetamodel.' figformat]) % ,'-r200'
% close(hz)


%%% Gamma

myHz = mygamma;

timehalf=12; % Remove first 1/timehalf of simulation from analysis (under the assumption that the network needed that time to stabilize)

ind = handles.curses.ind;

if ~isempty(deblank(handles.optarg)) && ~isempty(str2num(handles.optarg))
    myHz = str2num(handles.optarg);
end

thetaper=1000/myHz;

if thetaper<50
    refphase = 0;
else
    refphase = 20;
end

bg=figure('Color','w');
[x,y] = pol2cart(0,1);
h_fake=compass(x,y);
hold on
      
legstr={};
legh=[];
for r=1:length(celltypevec)
    celltype = celltypevec{r};
    z = strmatch(celltype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','supercell','deepcell'});
    zidx = find(spikerast(:,3)==r-1);
    numcells = numcellsvec(r);
    
    g=strmatch(celltype,{nrninput(:).tech});

    if ~isempty(g)
        legstr{length(legstr)+1}=nrninput(g(1)).name;
    else
        legstr{length(legstr)+1}=celltype;
    end    
    
    % legstr{length(legstr)+1}=[celltype ' (' num2str(numcells) ' cells)'];
    
    spiketimes = spikerast(zidx,1);

    n=length(spiketimes);
    modspiketimes = mod(spiketimes, thetaper);

    xbar = 1/n*sum(sin(modspiketimes*pi/(thetaper/2)));
    ybar = 1/n*sum(cos(modspiketimes*pi/(thetaper/2)));

    magnitude(r)=sqrt(xbar^2+ybar^2);
    if xbar>0
        angle = acos(ybar/magnitude(r));
    else
        angle = 2*pi - acos(ybar/magnitude(r));
    end

    rdir(r) = angle; % * pi/180;
    if ~isempty(z) && z==1
        pyrangle=angle;
    end
% http://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics/content/circ_rtest.m
    if ~isempty(modspiketimes)
        [pval zval] = circ_rtest(modspiketimes*pi/(thetaper/2));
        % disp([celltype ': pval of ' num2str(pval) '. z statistic of ' num2str(zval) ', my r: ' num2str(magnitude(r))])
    else
        % disp([celltype ' had no spikes to analyze'])
    end
end

nrninput = gettheta;
if isdeployed
    usepyrspikes=0;
else
    myvers=ver;
    g=strcmp({myvers(:).Name},'Signal Processing Toolbox');
    if sum(g)>0
        usepyrspikes=0;
    else
        usepyrspikes=1;
    end
end

usepyrspikes=1;

zz=1;

if usepyrspikes
    refangle=refphase/180*pi;
    pyrangle_shift=pyrangle-refangle;
    % disp('Set the pyramidal cell angle to the reference angle of 20^o')
else % use pyramidal intracellular peaks
    refangle=0;
    pyrangle=getpyramidalphase(handles,[myHz myHz],0);
    pyrangle_shift=pyrangle-refangle;
end
for r=1:length(celltypevec)
    rdir(r) = rdir(r)-pyrangle_shift;
    [x,y] = pol2cart(rdir(r),magnitude(r));
    k=compass(x,y);
    legh(length(legh)+1)=k;
    celltype = celltypevec{r};
    z = strmatch(celltype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','supercell','deepcell'});
    if isempty(z)
        set(k,'Color','k','LineWidth',4);
    else
        final_angle(z) = rdir(r)*180/pi;
        if rdir(r)<0
            final_angle(z) = (rdir(r)+2*pi)*180/pi;
        end
        set(k,'Color',colorvec(z,:),'LineWidth',4);
        %disp([celltype ': ' num2str(final_angle(z))])
        cellsdata(zz).name = celltype;
        cellsdata(zz).phase = mod(rdir(r),2*pi)*180/pi;
        cellsdata(zz).offset = [0 0];
        cellsdata(zz).color = colorvec(z,:);
        zz=zz+1;
    end
end


set(h_fake,'Visible','off');

legend(legh,legstr,'Location','BestOutside')

set(gca,'FontName','Verdana','FontSize',12,'FontWeight','Bold')
print(bg,['-d' figformat],'-r200', [figpath  RunArray(ind).RunName '\gammacompass.' figformat])
close(bg)

hm = Website_Phases_Figure(cellsdata,myHz,'gamma',RunArray(ind).RunName);

for r=1:length(celltypevec)
    phaseresults(r).name = celltypevec{r};
    phaseresults(r).gamma = mod((rdir(r)-pyrangle_shift)*180/pi,360);
    phaseresults(r).gammamag = magnitude(r);  
    
    myi = strmatch(phaseresults(r).name,{nrninput(:).tech});
    
    if isempty(myi)
        expresults(r).name = NaN;
        expresults(r).theta = NaN;
        expresults(r).thetamag = NaN;
        expresults(r).ref = NaN;
        expresults(r).gamma = NaN;
        expresults(r).gammamag = NaN;
        expresults(r).gref = NaN;
    else
        expresults(r).name = nrninput(myi(1)).tech;
        expresults(r).theta = nrninput(myi(1)).phase;
        expresults(r).thetamag = nrninput(myi(1)).mod;
        expresults(r).ref = nrninput(myi(1)).ref;
        expresults(r).gamma = nrninput(myi(1)).gamma;
        expresults(r).gammamag = nrninput(myi(1)).gmod;
        expresults(r).gref = nrninput(myi(1)).gref;
        expresults(r).url = nrninput(myi(1)).url;
        expresults(r).cite = nrninput(myi(1)).cite;
        expresults(r).gurl = nrninput(myi(1)).gurl;
        expresults(r).gcite = nrninput(myi(1)).gcite;
    end
end


fid1=fopen([figpath RunArray(ind).RunName '\phase_model.txt'],'w');
fid2=fopen([figpath RunArray(ind).RunName '\phase_exp.txt'],'w');
fid3=fopen([figpath RunArray(ind).RunName '\phase_diff.txt'],'w');
fid4=fopen([figpath RunArray(ind).RunName '\phasediff_chart.txt'],'w');

for r=1:length(phaseresults)
    thetadiff = (mod(phaseresults(r).theta-expresults(r).theta+180,360)-180)/360*100;
    gammadiff = (mod(phaseresults(r).gamma-expresults(r).gamma+180,360)-180)/360*100;
    
    fprintf(fid1,'%s,%.0f,%.3f,%.0f,%.3f\n',phaseresults(r).name,phaseresults(r).theta,phaseresults(r).thetamag,phaseresults(r).gamma,phaseresults(r).gammamag);
    if ~isnan(expresults(r).name)
        fprintf(fid2,'%s,%.0f,%.3f,%s,%s,%.0f,%.3f,%s,%s\n',expresults(r).name,expresults(r).theta,expresults(r).thetamag,expresults(r).url,expresults(r).cite,expresults(r).gamma,expresults(r).gammamag,expresults(r).gurl,expresults(r).gcite);
        fprintf(fid3,'%s,%+.1f%%,%+.1f%%,%+.1f%%,%+.1f%%\n',phaseresults(r).name,thetadiff,(phaseresults(r).thetamag-expresults(r).thetamag)*100,gammadiff,(phaseresults(r).gammamag-expresults(r).gammamag)*100);
        fprintf(fid4,'%s,%+.1f,%+.1f\n',phaseresults(r).name,thetadiff*360/100,gammadiff*360/100);
    end
end
fclose(fid1);
fclose(fid2);
fclose(fid3);
fclose(fid4);


fprintf(fidrunsum,'%s,Description,%.2f,%.1f,%.1f,%.1f,%.3f,%.3f\n', RunArray(ind).RunName, RunArray(ind).DegreeStim, summary.firerate, summary.poprate, summary.freq, summary.power, summary.phasediffs);
fclose(fidrunsum)


% catch ME
%     if isdeployed
%         msgbox({ME.identifier,ME.message,ME.stack,ME.cause})
%     else
%         throw(ME)
%     end
% end