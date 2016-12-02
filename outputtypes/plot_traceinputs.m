function h=plot_traceinputs(handles) % idx contains the column in the spikeraster that gives the cell type index
global mypath RunArray tableh sl

h=[]; %figure;
idx = handles.curses.ind;
ind = handles.curses.ind;
%sl = handles.curses.sl;
d=1;

if isempty(deblank(handles.optarg))
    gidstr=inputdlg('Enter the gid of the cell of interest');
    gid=str2num(gidstr{:});
else
    gid=str2num(handles.optarg);
    gidstr={num2str(gid)};
end

a=dir([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'trace_*cell' gidstr{:} '.dat']);

if isempty(a)
    msgbox('There is no trace available for that gid.')
    return
end

mycell = a.name(7:end-4);
x = length(gidstr{:});
celltype = mycell(1:end-x);

h(1) = figure('Color', 'w', 'Name', ['Trace for ' mycell]);
pos=get(h(1),'Position');
set(h(1),'Position',[pos(1) pos(2) pos(3)*2 pos(4)])
b=importdata([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl a.name]);
subplot('Position',[0.05 .55 .34 .4])
plot(b.data(:,1),b.data(:,2),'Color','k');
title(strrep(strrep(a.name(7:end),'cell',' cell, gid: '),'.dat',''))
xlabel('Time (ms)')
ylabel('Potential (mV)')
ylim([-90 0])
xlim([0 RunArray(idx).SimDuration])

%%%%%%%%%%%%%%

%spikeraster = importdata([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'spikeraster.dat']);

if exist([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'cell_syns.dat'], 'file')
    %cell_syns = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/cell_syns.dat']);
    [A B C]=textread([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'cell_syns.dat'],'%d\t%d\t%d\n','headerlines',1);
    cell_syns=[A B C];
else
    %cell_syns = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/connections.dat']);
    [A B C]=textread([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'connections.dat'],'%d\t%d\t%d\n','headerlines',1);
    cell_syns=[A B C];
end
clear A B C
%cell_syns=cell_syns.data;

inputs = cell_syns(cell_syns(:,2)==gid,:);

if isempty(inputs)
    return
end
%inputs = unique(inputs, 'rows');



if isempty(handles.curses.spikerast)
    spiketrain=[];
else
    spike_idx = ismember(handles.curses.spikerast(:,2),inputs(:,1));
    spiketrain = handles.curses.spikerast(spike_idx,:);
end


spiketrain=spiketrain(ismember(spiketrain(:,2),inputs(:,1)),:);
spiking_inputs=inputs(ismember(inputs(:,1),spiketrain(:,2)),:);
avgsyns=size(spiking_inputs,1)/length(unique(spiking_inputs(:,1)));
myi=size(spiketrain,1);
myistart=myi;
spiketrain(:,3)=-1;
if ~isnan(avgsyns)
spiketrain(end+1:round(myi*(avgsyns+.5)),:)=-1;
end

for r=1:myistart
    id = find(spiking_inputs(:,1)==spiketrain(r,2));
    spiketrain(r,3)=spiking_inputs(id(1),3); % add the synapse id
    for k=2:length(id)
        myi=myi+1;
        spiketrain(myi,:)=[spiketrain(r,1:2) spiking_inputs(id(k),3)]; % add the synapse id
    end    
end

if myi<size(spiketrain,1)
    spiketrain=spiketrain(1:myi,:);
end

%%%%%%%%%%%%%%

handles.prop = {'postcell','precell','weight','conns','syns'}; %, 'strength', 'numcons'};
if exist([RunArray(idx).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(idx).ConnData) '.dat'],'file')
    fid = fopen([RunArray(idx).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(idx).ConnData) '.dat']);
elseif RunArray(idx).ConnData==501
    fid = fopen([RunArray(idx).ModelDirectory sl 'datasets' sl 'conndata_430.dat']);
else
    disp('could not find the conndata file. quitting figure creation...')
    return
end
numlines = textscan(fid,'%d\n',1);
propstr=' %f %f %f';
c = textscan(fid,['%s %s' propstr '\n'],'Delimiter',' ', 'MultipleDelimsAsOne',0);
st = fclose(fid);

numcon = [];
handles.conndata=[];

if size(c{1,1},1)>0
    for r=1:numlines{1,1}
        postcell = c{1,2}{r};
        precell = c{1,1}{r};
        if ~isfield(handles.conndata,postcell)
            handles.conndata.(postcell)=[];
        end
        if ~isfield(handles.conndata.(postcell), precell)
            handles.conndata.(postcell).(precell)=[];
        end
        try
        for z = 3:length(handles.prop)
            handles.conndata.(postcell).(precell).(handles.prop{z}) = c{1,z}(r);
        end
        catch
            z
        end
    end
end

%%%%%%%%%%%%%%

handles.prop = {'precell','synapsemech','seclist','range_st','range_en','tau1','tau2','e','tau1a','tau2a','ea','tau1b','tau2b','eb'}; %, 'strength', 'numcons'};
mysl=findstr(RunArray(idx).ModelDirectory,'/');
if isempty(mysl)
    mysl='\';
else
    mysl='/';
end

fid = fopen([RunArray(idx).ModelDirectory mysl 'datasets' mysl 'syndata_' num2str(RunArray(idx).SynData) '.dat']);
numlines = textscan(fid,'%d\n',1);
propstr=' %f %f %f %f %f %f %f %f %f %f';
c = textscan(fid,['%s %s %s %s %s %s' propstr '\n'],'Delimiter',' ', 'MultipleDelimsAsOne',0);
st = fclose(fid);

numcon = [];
handles.data=[];
if size(c{1,1},1)>0
    for r=1:numlines{1,1}
        postcell = c{1,1}{r};
        precell = c{1,2}{r};
        if ~isfield(handles.data,postcell)
            handles.data.(postcell)=[];
        end
        if ~isfield(handles.data.(postcell), precell)
            handles.data.(postcell).(precell)=[];
            handles.data.(postcell).(precell).syns=[];
            n = 1;
        else
            n = length(handles.data.(postcell).(precell).syns)+1;
        end
        try
        for z = 2:length(handles.prop)
            handles.data.(postcell).(precell).syns(n).(handles.prop{z}) = c{1,z+1}(r);
        end
        catch
            z
        end
    end
end

mysyns=[];
%allsyns = importdata([RunArray(idx).ModelDirectory sl 'cells' sl 'allsyns.dat']);

if exist([RunArray(idx).ModelDirectory sl 'results' sl  RunArray(idx).RunName sl 'allsyns.dat'],'file')==0
	if ispc
		handles.dl='& ';
	else
		handles.dl='; ';
	end
    [grr1, grr2]=system(['cd ' RunArray(idx).ModelDirectory handles.dl ' ' handles.general.neuron ' -c "NumData=' num2str(RunArray(idx).NumData) '" -c "ConnData=' num2str(RunArray(idx).ConnData) '" -c "SynData=' num2str(RunArray(idx).SynData) '" launch_synapse_printer.hoc  -c "quit()"']);
    system(['cd ' RunArray(idx).ModelDirectory handles.dl ' mv .' sl 'cells' sl 'allsyns.dat .' sl 'results' sl RunArray(idx).RunName sl])
    system(['cd ' RunArray(idx).ModelDirectory handles.dl ' mv .' sl 'cells' sl 'synlist.dat .' sl 'results' sl RunArray(idx).RunName sl])
end

allsyns = importdata([RunArray(idx).ModelDirectory sl 'results' sl  RunArray(idx).RunName sl 'allsyns.dat']);

for r=1:length(allsyns.data)
    if ~isfield(mysyns,allsyns.textdata{r,1})
        mysyns.(allsyns.textdata{r,1})=[];
    end
    if ~isfield(mysyns.(allsyns.textdata{r,1}),allsyns.textdata{r,2})
        mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2})=[];
    end
    mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2}).synstart = allsyns.data(r,1);
    mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2}).synend = allsyns.data(r,2);
    mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2}).numsyns = allsyns.data(r,2)-allsyns.data(r,1)+1;
end

exc=[];
inh=[];
post = celltype;
prefields = fieldnames(handles.data.(post));
for r=1:length(prefields)
    pre = prefields{r};
    if isfield(mysyns.(post),pre) && ~isempty(handles.data.(post).(pre).syns(1).e) && ~isnan(handles.data.(post).(pre).syns(1).e)
        if handles.data.(post).(pre).syns(1).e<-40
            inh = [inh mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend];
        else
            exc = [exc mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend];
        end
    elseif  isfield(mysyns.(post),pre) % assume GABAergic (a and b)
        inh = [inh mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend];
    end
end

%exc = [handles.data.(celltype).syns(excidx).sid];
%inh = [handles.data.(celltype).syns(inhidx).sid];

%%%%%%%%%%%%%%
axcondelay=3;

figure(h(1))
ax_ex = subplot('Position',[0.05 .3 .34 .2]);
spike_idx = ismember(spiketrain(:,3),exc);
%plot(spiketrain(spike_idx,1), spiketrain(spike_idx,3),'LineStyle','none','Marker','.','MarkerSize',10,'Color','m')
N=histc(spiketrain(spike_idx,1)+axcondelay,[0:RunArray(idx).SimDuration]);
hbar=bar([0:RunArray(idx).SimDuration],N);
set(hbar,'EdgeColor','m')
set(hbar,'FaceColor','m')
xlabel('Time (ms)')
ylabel('Excitatory Events')
xlim([0 RunArray(idx).SimDuration])

ax_ex2 = axes('Position',get(ax_ex,'Position'),'YAxisLocation','right','Color','none','YTickLabel',{},'xlim',[0 RunArray(idx).SimDuration]);
hl1 = line(b.data(:,1),b.data(:,2),'Color','k','Parent',ax_ex2);


axcondelay=RunArray(idx).myConDelay;

ax_in = subplot('Position',[0.05 0.05 .34 .2]);
spike_idx = ismember(spiketrain(:,3),inh);
%plot(spiketrain(spike_idx,1), spiketrain(spike_idx,3),'LineStyle','none','Marker','.','MarkerSize',10,'Color','c')
N=histc(spiketrain(spike_idx,1)+axcondelay,[0:RunArray(idx).SimDuration]);
hbar=bar([0:RunArray(idx).SimDuration],N);
set(hbar,'EdgeColor','c')
set(hbar,'FaceColor','c')
xlabel('Time (ms)')
ylabel('Inhibitory Events')
xlim([0 RunArray(idx).SimDuration])

ax_in2 = axes('Position',get(ax_in,'Position'),'YAxisLocation','right','Color','none','YTickLabel',{},'xlim',[0 RunArray(idx).SimDuration]);
hl2 = line(b.data(:,1),b.data(:,2),'Color','k','Parent',ax_in2);

%%%%%%%%%%%%%%

if isfield(handles.curses,'position')
pos_idx=unique(inputs(:,1)); % ismember(handles.curses.position(:,1),unique(inputs(:,1)));
handles.optarg=num2str(0);
h(2)=plot_position(handles,pos_idx,[RunArray(idx).RunName ': ' strrep(strrep(a.name(7:end),'cell',' cell, gid: '),'.dat','') ' Input Cell Positions'],gid);

h(3)=figure('color','w');

LayerLength = 50;

for r=1:length(handles.curses.cells)
    BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerLength);
    ZHeight(r) = 50;
end

postype=find([handles.curses.cells(:).range_st]<=gid,1,'last'); 
mypos = getpos(gid, handles.curses.cells(postype).range_st, BinInfo(postype), ZHeight(postype));
% myidx=find(handles.curses.position(:,1)==gid);

maxlength=sqrt(RunArray(idx).LongitudinalLength^2 + RunArray(idx).TransverseLength^2);
%positions2plot=handles.curses.position(pos_idx,:);

for x=1:size(inputs,1)
    gid = inputs(x,1);
    postype=find([handles.curses.cells(:).range_st]<=gid,1,'last'); 
    pos = getpos(gid, handles.curses.cells(postype).range_st, BinInfo(postype), ZHeight(postype));  
    positions2plot(x,:)=[gid pos.x pos.y pos.z];
end
% [~, tdy]=ismember(inputs(:,1),handles.curses.position(:,1));
% positions2plot=inputs(:,1);
% positions2plot(:,2:4)=handles.curses.position(tdy,2:4);

for r=1:length(handles.curses.cells)
    subplot(3,ceil((length(handles.curses.cells))/3),r)
    mysubidx=find(inputs(:,1)>=handles.curses.cells(r).range_st & inputs(:,1)<=handles.curses.cells(r).range_en);
    if ~isempty(mysubidx)
        myh=hist(inputs(mysubidx,1),handles.curses.cells(r).range_st:handles.curses.cells(r).range_en);
        mz=bar(myh);
    end
    title(handles.curses.cells(r).name)
end

h(4)=figure('color','w');

mylegstr={};
stackflag=0;
for r=1:length(handles.curses.cells)
    stepsize=200;
    typeidx=find(positions2plot(:,1)>=handles.curses.cells(r).range_st & positions2plot(:,1)<=handles.curses.cells(r).range_en);
    mydists=sqrt((positions2plot(typeidx,2) - mypos.x).^2 + (positions2plot(typeidx,3) - mypos.y).^2);
    if stackflag==1
        cpos(:,r) = histc(mydists,[0:stepsize:maxlength]);
        mylegstr{r}=handles.curses.cells(r).name;
    else
        subplot(3,ceil((length(handles.curses.cells))/3),r)
        try
            predist=importdata([RunArray(idx).ModelDirectory sl 'cells' sl 'axondists' sl 'dist_' handles.curses.cells(r).name '.hoc']);
        catch
            predist = [1 0 1000];
        end
        %stepsize=200; %predist(3)*4/5;
        stepsize=predist(3)*4/5;
        if isfield(handles.conndata, celltype) && isfield(handles.conndata.(celltype), handles.curses.cells(r).name)
            mz=bar([0:stepsize:maxlength],histc(mydists,[0:stepsize:maxlength])/handles.conndata.(celltype).(handles.curses.cells(r).name).syns); 
            xlim([0-stepsize*get(mz,'BarWidth') maxlength+stepsize*get(mz,'BarWidth')])
        end
        testy=get(gca,'XTick');
        %set(gca,'XTick',testy(1:4:end));
        my = axes('Position',get(gca,'Position'),'YAxisLocation','right','Color','none','XTickLabel',{},'YTickLabel',{});
        px=[0:(stepsize/20):maxlength];
        py=exp(-predist(1)*((px-predist(2))/predist(3)).^2);
        hl1 = line(px,py,'Color','k','LineWidth',2,'Parent',my);
        set(my,'xlim',[0-stepsize*get(mz,'BarWidth') maxlength+stepsize*get(mz,'BarWidth')]);
        title(handles.curses.cells(r).name)
    end
end
msgbox('Make sure to be updated to the same version of repository as used')

%mydists=sqrt((handles.curses.position(pos_idx,2) - handles.curses.position(myidx,2)).^2 + (handles.curses.position(pos_idx,3) - handles.curses.position(myidx,3)).^2);
if stackflag==1
    bar([0:stepsize:maxlength],cpos,'stack');
    legend(mylegstr)
end
end


%%%%%%%%%%%%%%
z=figure('Color','w','Name',[RunArray(idx).RunName ': ' post ' Inputs by Type']);
numpre = length(prefields);
easz = .9/numpre;

axcondelay=3;
cutoff=15;
corrdeadline=20000;
corrtrain = spiketrain(spiketrain(:,1)<corrdeadline,:);
postcellspks = handles.curses.spikerast(handles.curses.spikerast(handles.curses.spikerast(:,1)<corrdeadline,2)==gid,1);

if length(postcellspks)>1
    postcellspks = [postcellspks(1); postcellspks((postcellspks(2:end)-postcellspks(1:end-1))>5.5)]; % only take the first PVBC spike in each burst
end

for r=1:numpre
    pre = prefields{r};
    if isfield(mysyns.(post),pre)==0
        grr(r).useme=0;
        continue
    end
    col='m';
    axcondelay=RunArray(idx).myConDelay;
    if ~isempty(handles.data.(post).(pre).syns(1).e) && ~isnan(handles.data.(post).(pre).syns(1).e) && handles.data.(post).(pre).syns(1).e>=-40
        col='c';
        axcondelay=3;
    end
    
    h1(r) = subplot('Position',[0.2 .05+easz*(r-1) .75 easz-.02]);
    spike_idx = ismember(spiketrain(:,3),mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend);
    corr_idx = ismember(corrtrain(:,3),mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend);
    %plot(spiketrain(spike_idx,1), spiketrain(spike_idx,3),'LineStyle','none','Marker','.','MarkerSize',10,'Color','m')
    N=histc(spiketrain(spike_idx,1)+axcondelay,[0:.5:RunArray(idx).SimDuration]);
%     if strcmp(col,'m')
%         disp('IPSCs arrive at:')
%         spiketrain(spike_idx,1)+axcondelay
%     end
    if 1==0 % plot spike times
    plot(spiketrain(spike_idx,1)+axcondelay,spiketrain(spike_idx,2),'LineStyle','none','Marker','.','MarkerSize',10,'Color',col)
    xlim([0 RunArray(idx).SimDuration])
    else % plot hist
    hbar=bar([0:.5:RunArray(idx).SimDuration],N);
    set(hbar,'EdgeColor',col)
    set(hbar,'FaceColor',col)
    end
    if r==1
        xlabel('Time (ms)')
    else
        set(h1(r),'XTickLabel',{})
    end
    ylabel(pre,'rot',0,'HorizontalAlignment','right')
    xlim([0 RunArray(idx).SimDuration])

    h2(r) = axes('Position',get(h1(r),'Position'),'YAxisLocation','right','Color','none','YTickLabel',{},'XTickLabel',{},'xlim',[0 RunArray(idx).SimDuration]);
    hl1 = line(b.data(:,1),b.data(:,2),'Color','k','Parent',h2(r));
    if r==numpre
        title(strrep(strrep(a.name(7:end),'cell',' cell, gid: '),'.dat',''))
    end
    
    spkpre = corrtrain(corr_idx,1)+3;
    %spkpre = corrtrain(spike_idx,1)+3; % add 3 for axonal conduction delay
    
    if ~isempty(spkpre) && length(spkpre)>0 && ~isempty(postcellspks) && length(postcellspks)>0
        Apre=repmat(spkpre,1,length(postcellspks));
        Bpost=repmat(postcellspks',length(spkpre),1);
        supPV=Bpost-Apre;
        sidx = find(supPV(:)>-cutoff & supPV(:)<cutoff);
        grr(r).supVec=supPV(sidx);
        grr(r).useme=1;
    else
        grr(r).useme=0;
    end
end

qq=figure('color','w','Name',[RunArray(idx).RunName ': Cross Correlogram Subplots']);
useme=[];
for r=1:numpre
    if grr(r).useme==1
        useme=[useme r];
    end
end

g=0;
maxy=0;
addbar=[];
legstr={};
normfac=1;
normflag=1; % 0=display number of spikes, 1=display probability of spikes
titlestr='s';
ystr='# Spikes';
for r=useme
    g=g+1;
    if normflag==1
        normfac=length(grr(r).supVec);
        titlestr=' Probability';
        ystr='Spike Prob.';
    end
    figure(qq)
    tt=subplot(length(useme),1,g);
    b=hist(grr(r).supVec,-cutoff:cutoff);
    addbar=[addbar [b/normfac]'];
    legstr{g}=prefields{r};
    bar(-cutoff:cutoff,b/normfac)
    %xlabel(['Spike timing relative to ' prefields{r} ' inputs (ms)'])
    %ylabel(ystr)
    ylabel(prefields{r})
    if g==1
        title([strrep(strrep(a.name(7:end),'cell',' cell, gid: '),'.dat','') ' - Spike' titlestr ' Cross Corr. with Synaptic Input Events'])
    end
    if g==length(useme)
        xlabel(['Spike timing relative to inputs (ms)'])
    else
        set(gca, 'xtickLabel',[])
    end
    yr=get(tt,'yLim');
    maxy=max(maxy,yr(2));
end
for r=1:g
    subplot(length(useme),1,r)
    ylim([0 maxy])
end

h(5)=z;
h(6)=qq;
if ~isempty(addbar)
    kk=figure('color','w','Name',[RunArray(idx).RunName ': Cross Correlogram Comparison']);
    ww=bar(-cutoff:cutoff,addbar);
    colorvec={'b','g','r','y','k','m','c','b','g','r','y','k','m','c'};
    for r=1:length(ww)
        set(ww(r),'FaceColor',colorvec{r},'EdgeColor',colorvec{r})
    end
    legend(legstr)
    title([strrep(strrep(a.name(7:end),'cell',' cell, gid: '),'.dat','') ' - Spike' titlestr ' Cross Corr. with Synaptic Input Events'])
    xlabel('Spike timing relative to synaptic inputs (ms)')
    ylabel(ystr)
    h(7)=kk;
end

%%%%%%%%%%%%%%

clear a b

mycells = importdata([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'celltype.dat']);

for n=1:size(mycells.data,1)
    cellidx = find(inputs(:,1)>=mycells.data(n,2) & inputs(:,1)<=mycells.data(n,3)); % source target synapse
    %cellidx = find(spiking_inputs(:,1)>=mycells.data(n,2) & spiking_inputs(:,1)<=mycells.data(n,3)); % source target synapse
    spkidx = find(spiketrain(:,2)>=mycells.data(n,2) & spiketrain(:,2)<=mycells.data(n,3)); % source target synapse
    precell = mycells.textdata{1+n, 1};
    cellmat{n,1} = precell; % # precells of this type
    cellmat{n,2} = length(cellidx); % # precells of this type
    cellmat{n,3} = length(spkidx);
    if isfield(handles.conndata, post) && isfield(handles.conndata.(post), precell)
    cellmat{n,4} = handles.conndata.(post).(precell).weight;
    cellmat{n,5} = length(inputs(cellidx,1))/handles.conndata.(post).(precell).syns;
    cellmat{n,6} = length(unique(inputs(cellidx,1)));
    %cellmat{n,5} = length(unique(spiking_inputs(cellidx,1)));
    cellmat{n,7} = handles.conndata.(post).(precell).syns;
    else
        for g=4:7
            cellmat{n,g} = 0;
        end
    end
    %cellmat{n,4} = length(cellidx)*?; % # presyns of this type
    %cellmat{n,5} = mysyns.(celltype).(mycells.textdata{1+n, 1}).synstart;
    %cellmat{n,6} = mysyns.(celltype).(mycells.textdata{1+n, 1}).synend;
    if n==1
        %back when there was only one pp synapsing onto a given cell, this
        %made sense to display:
        %disp([mycells.textdata{1+n, 1} ' gid: ' num2str(inputs(cellidx,1))])
    end
end

k=1;
for r=1:length(prefields)
    precell = prefields{r};
    for n = 1:length(handles.data.(celltype).(precell).syns)
        numcon{k,1} = precell; %handles.data.(celltype).(precell).syns(n);
        for w = 2:length(handles.prop)
            try
                numcon(k,w) = handles.data.(celltype).(precell).syns(n).(handles.prop{w});
            catch
                numcon(k,w) = {handles.data.(celltype).(precell).syns(n).(handles.prop{w})};
            end
        end
        k=k+1;
    end
end

myzfunc=@context_copymytable_Callback;
mycontextmenuz=uicontextmenu('Tag','menu_copy1','Parent',h(1));
uimenu(mycontextmenuz,'Label','Copy Table','Tag','context_copytable1','Callback',myzfunc);

mycontextmenub=uicontextmenu('Tag','menu_copy2','Parent',h(1));
uimenu(mycontextmenub,'Label','Copy Table','Tag','context_copytable2','Callback',myzfunc);


tableh(1) = uitable(h(1), 'Data', numcon, 'ColumnName', handles.prop, 'Units','normalized','Position',[.45 0 .55 .45],'UIContextMenu',mycontextmenuz);
tableh(2) = uitable(h(1), 'Data', cellmat, 'ColumnName', {'     Cell Type     ','# syns','# spikes x syns','  Weight (uS)  ','# conns','unique cells','#syns/conn'},'ColumnFormat',{'char','numeric','numeric','short e','numeric','numeric'}, 'Units','normalized','Position',[.45 .45 .55 .55],'UIContextMenu',mycontextmenub); % ,'# syns','sid start','sid end'

for hi=length(h):-1:1
    if h(hi)==0
        h(hi)=[];
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

