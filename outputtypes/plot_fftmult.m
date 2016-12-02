function [h chartstr]=plot_fftmult(hObject,handles,filenames)
global mypath RunArray


if isfield(handles.curses,'spikerast')==0
    myspikeraster(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end


load data/myrepos.mat backupfolder myrepos

q=find([myrepos(:).current]==1);


mypath = [RunArray(handles.curses.indices(1)).ModelDirectory '/results/' RunArray(handles.curses.indices(1)).RunName];
rname = RunArray(handles.curses.indices(1)).RunName;
colorvec={'r','g','b','k','m','c'};

if ispc
    handles.curses.sl='\';
else
    handles.curses.sl='/';
end

nl=0;
tmpstr=sprintf('%17s', '|');
for z=1:length(handles.curses.indices)  
    results(z) = getfft(hObject,handles,handles.curses.indices(z));
    names{z}=RunArray(handles.curses.indices(z)).RunName;
    nl=max(nl,length(names{z}));
    tmpstr = [tmpstr sprintf('%15s', RunArray(handles.curses.indices(z)).RunName) sprintf('%2s', '|')];
end

for z=1:length(results)
    allresults(z) = results(z).all;
end
results=rmfield(results,'all');

cells = fieldnames(results);
h=zeros(length(cells));

thetastr{1} = tmpstr;
allstr{1} = tmpstr;
mystr={};
mystr{1} = sprintf('%-16s%10s%10s%10s%10s%10s%10s%10s%10s', 'celltype','Cells','Spikes','Silent','Min Sp/C','Max Sp/C','Avg Sp/C','St Dev');

thetamat=[];
allmat=[];
meanmat=[];
stdmat=[];

pages = ceil(length(cells)/6);

for p=1:pages
    hp(p)=figure;
    set(hp(p),'Units','inches','Color','w'); %,'Visible','off')
    figpos=get(hp(p),'Position');
    set(hp(p),'Position',[figpos(1) figpos(2) 8.5 11])
end

rows = ceil(min(length(cells),6)/2);

for x=1:length(cells)
    p = floor((x-1)/6)+1;
    r = floor((x-(p-1)*6-1)/2)+1;
    c = x-(p-1)*6-(r-1)*2;
    figure(hp(p))
    hpa(x)=axes('Parent',hp(p),'Units','normalized','Position',[(c-1)*.5+.052 (r-1)/rows+.05 .4 1/rows-.1]);
end



for r=1:length(cells)
    figure(hp(p))
    axes(hpa(r))
    
    for z=1:length(results)
        thetamat(z,r) = results(z).(cells{r}).theta_freq;
        allmat(z,r) = results(z).(cells{r}).all_freq;

        meanmat(z,r) = results(z).(cells{r}).mean;
        stdmat(z,r) = results(z).(cells{r}).std;
        
        plot(results(z).(cells{r}).f, results(z).(cells{r}).fft_results,colorvec{z})
        hold on
        legstr{z} = [sprintf(['%-' num2str(nl) 's'], names{z}) ': (' num2str(results(z).(cells{r}).num) '), ' sprintf('%5s',sprintf('%5.2f', results(z).(cells{r}).theta_freq)) ', ' sprintf('%5s',sprintf('%5.2f', results(z).(cells{r}).all_freq)) ' Hz'];
    end
    
    legend(legstr, 'Interpreter','none','FontName','FixedWidth','Location','SouthOutside', 'Box', 'off')
    
    tmpstr='|    ';
    tmpstr2='|    ';
    tmpstr3={};
    tmpstr3{1}=' ';
    tmpstr3{2} = sprintf('%s', cells{r});
    
    for z=1:length(results)
        plot(results(z).(cells{r}).theta_freq, results(z).(cells{r}).theta_pow, colorvec{z}, 'LineStyle', 'none', 'Marker', 'sq', 'MarkerSize', 10)
        plot(results(z).(cells{r}).all_freq, results(z).(cells{r}).all_pow, colorvec{z}, 'LineStyle', 'none', 'Marker', '^', 'MarkerSize', 10)
        tmpstr = [tmpstr sprintf('%5s',sprintf('%5.2f', results(z).(cells{r}).theta_freq)) ' Hz    |    '];
        tmpstr2 = [tmpstr2 sprintf('%5s',sprintf('%5.2f', results(z).(cells{r}).all_freq)) ' Hz    |    '];
        tmpstr3{length(tmpstr3)+1} = sprintf('%16s%10d%10d%10d%10d%10d%10.2f%10.2f', RunArray(handles.curses.indices(z)).RunName, results(z).(cells{r}).num, ...
        results(z).(cells{r}).numspikes, results(z).(cells{r}).silent, results(z).(cells{r}).min, results(z).(cells{r}).max, ...
        results(z).(cells{r}).mean, results(z).(cells{r}).std);
    end
    
    thetastr{r+1} = [sprintf('%-16s', cells{r}) tmpstr];
    allstr{r+1} = [sprintf('%-16s', cells{r}) tmpstr2];
    mystr = [mystr tmpstr3];
    
    title({[cells{r} ' FFT']})
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    set(gcf,'Color','w')
end

for p=1:pages
    idx=length(filenames)+1;
    set(hp(p),'PaperUnits','normalized','PaperPosition',[0 0 1 1])
    print(hp(p),'-dpdf','-r600',[mypath '/' rname '_Comparison_' sprintf('%02g',idx)])
    filenames{idx}=[mypath '/' rname '_Comparison_' sprintf('%02g',idx)];
    close(hp(p))
end


allresultstr{1}=thetastr{1};
allresultstr{2}=[sprintf('%-15s','Theta freq.') ' |    '];
allresultstr{3}=[sprintf('%-15s','Theta power') ' |    '];
allresultstr{4}=' ';
allresultstr{5}=[sprintf('%-15s','All freq.') ' |    '];
allresultstr{6}=[sprintf('%-15s','All power') ' |    '];

for z=1:length(allresults)
    allresultstr{2} = [allresultstr{2} sprintf('%6s',sprintf('%6.2f', allresults(z).theta_freq)) ' Hz   |    '];
    allresultstr{3} = [allresultstr{3} sprintf('%6s',sprintf('%6.2f', allresults(z).theta_pow)) '      |    '];
    allresultstr{5} = [allresultstr{5} sprintf('%6s',sprintf('%6.2f', allresults(z).all_freq)) ' Hz   |    '];
    allresultstr{6} = [allresultstr{6} sprintf('%6s',sprintf('%6.2f', allresults(z).all_pow)) '      |    '];
end

chartstr = ['                        Theta (4 - 12 Hz) Peak:' thetastr ' '   ' '   '                        Overall (2 Hz+) Peak:' allstr '  '  '   ' allresultstr];
spikestr = ['                        Spike Activity per Cell Type:' mystr];

% Text chart of peak frequencies
idx=length(filenames)+1;

h3=figure('Color','w'); %,'Visible','off');
us = get(h3,'Units');
set(h3,'Units','inches');
pos = get(h3,'Position');
set(h3,'Position', [pos(1) pos(2) 8.5 11]);
set(h3,'Units','normalized');

hd(1) = axes('Position',[0.05 0.05 0.9 0.9]);
text(0, 1, chartstr,'Interpreter','none','HorizontalAlignment','left','VerticalAlignment','top','FontName','FixedWidth')
axis off

set(h3,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait')
print(h3,'-dpdf','-r600',[mypath '/' rname '_Comparison_' sprintf('%02g',idx)])
close(h3)
filenames{idx}=[mypath '/' rname '_Comparison_' sprintf('%02g',idx)];


% Text chart of spike stats
cellstr={};
for r=1:length(cells)
    cellstr{r}=cells{r}(1:3); %(1:end-4);
end
cellstr=cellstr';
idx=length(filenames)+1;

hw=figure('Color','w'); %,'Visible','off');
us = get(hw,'Units');
set(hw,'Units','inches');
pos = get(hw,'Position');
set(hw,'Position', [pos(1) pos(2) 8.5 11]);
set(hw,'Units','normalized');

hd(2) = axes('Position',[0.05 0.3 0.9 0.65]);
text(0, 1, spikestr,'Interpreter','none','HorizontalAlignment','left','VerticalAlignment','top','FontName','FixedWidth')
axis off

% graph of avg cell firing

hv(1) = subplot('Position',[.1 .05 .85 .15]);
fsize = get(hv(1),'FontSize');
set(hv(1),'FontSize',fsize,'FontName','Courier')

for z=1:length(results)
    plot([1:length(cells)]-.1+(z-floor(length(results)/2))/10, [meanmat(z,:)], 'LineStyle','none','Marker','.','MarkerSize',10, 'MarkerEdgeColor', colorvec{z})
    hold on
end

set(hv(1),'TickDir','out','XTickLabel',[' '; cellstr; ' '],'YScale','log', 'xlim', [0 length(cells)+1]) % ,'TickDir','out'
set(hv(1),'FontSize',fsize,'FontName','Courier')
ylabel('Spikes/Cell Type')
legend(names, 'Interpreter','none','FontSize',fsize,'FontName','Courier','Location','NorthOutside')
set(hv(1),'YGrid','on','box','off')

set(hw,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait')
print(hw,'-dpdf','-r600',[mypath '/' rname '_Comparison_' sprintf('%02g',idx)])
close(hw)
filenames{idx}=[mypath '/' rname '_Comparison_' sprintf('%02g',idx)];



% graph of peak frequencies per cell per run
idx=length(filenames)+1;

h4=figure('Color','w'); %,'Visible','off');
us = get(h4,'Units');
set(h4,'Units','inches');
pos = get(h4,'Position');
set(h4,'Position', [pos(1) pos(2) 11 8.5]);
set(h4,'Units','normalized');
he(1) = subplot('Position',[.1 .6 .85 .3]);
fsize = 12; % get(he(1),'FontSize');
set(he(1),'FontSize',fsize,'FontName','Courier')

for z=1:length(results)
    plot([1:length(cells)], [thetamat(z,:)], 'LineStyle','none','Marker','o','MarkerSize',7, 'MarkerFaceColor', colorvec{z}, 'MarkerEdgeColor', colorvec{z})
    hold on
end

    
set(he(1),'TickDir','out','YTick',[4 6 8 10 12],'XTickLabel',[' '; cellstr; ' '],'ylim',[0 20], 'xlim', [0 length(cells)+1]) % ,'TickDir','out'
bbox=dsxy2figxy(he(1),[0 4 length(cells)+1 8]);
annotation('rectangle', bbox,'FaceColor','none','EdgeColor','y')
set(he(1),'FontSize',fsize,'FontName','Courier')
ylabel('Peak Theta Range Freq.')
legend(names, 'Interpreter','none','FontSize',fsize,'FontName','Courier')
set(he(1),'YGrid','on','box','off')

he(2) = subplot('Position',[.1 .1 .85 .3]);
set(he(2),'FontSize',fsize,'FontName','Courier')

for z=1:length(results)
    plot([1:length(cells)], [allmat(z,:)], 'LineStyle','none','Marker','^','MarkerSize',7, 'MarkerFaceColor', colorvec{z}, 'MarkerEdgeColor', colorvec{z})
    hold on
end

set(he(2),'TickDir','out','XTickLabel',[' '; cellstr; ' '],'ylim',[0 50], 'xlim', [0 length(cells)+1]) % ,'TickDir','out'
bbox=dsxy2figxy(he(2),[0 4 length(cells)+1 8]);
annotation('rectangle', bbox,'FaceColor','none','EdgeColor','y')
set(he(2),'FontSize',fsize,'FontName','Courier')
ylabel('Peak Overall Freq.')
set(he(2),'YGrid','on','YMinorGrid','on','box','off')

set(h4,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','landscape')
print(h4,'-dpdf','-r200',[mypath '/' rname '_Comparison_' sprintf('%02g',idx)])
close(h4)
filenames{idx}=[mypath '/' rname '_Comparison_' sprintf('%02g',idx)];

%%%%%%%%%%%%%%%%%%



%%%%%% PAGE 2+

hgt = 1/length(handles.curses.indices);
filenamex={};
for r=1:length(cells)

    h=figure;
    set(h,'Units','inches','Color','w'); %,'Visible','off')
    figpos=get(h,'Position');
    set(h,'Position',[figpos(1) figpos(2) 11 8.5])
    
    celltype = cells{r};
    myflag=0;
    for z=1:length(handles.curses.indices)
        ridx = handles.curses.indices(z);
        dd = dir([RunArray(ridx).ModelDirectory '/results/' RunArray(ridx).RunName '/trace_' celltype '*']);
        if length(dd)>0        
            myflag=1;
            mycell = dd(1).name(7:end-4);
            gid = str2num(mycell(length(celltype)+1:end));


            b=importdata([RunArray(ridx).ModelDirectory '/results/' RunArray(ridx).RunName '/trace_' mycell '.dat']);

            %%%%%%%%%%%%%%

            myspikeraster = importdata([RunArray(ridx).ModelDirectory '/results/' RunArray(ridx).RunName '/spikeraster.dat']);

            if exist([RunArray(ridx).ModelDirectory '/results/' RunArray(ridx).RunName '/cell_syns.dat'], 'file')
                cell_syns = importdata([RunArray(ridx).ModelDirectory '/results/' RunArray(ridx).RunName '/cell_syns.dat']);
            else
                cell_syns = importdata([RunArray(ridx).ModelDirectory '/results/' RunArray(ridx).RunName '/connections.dat']);
            end
            cell_syns=cell_syns.data;
            inputs = cell_syns(cell_syns(:,2)==gid,:);
            inputs = unique(inputs, 'rows');

            spike_idx = ismember(myspikeraster(:,2),inputs(:,1));
            spiketrain = myspikeraster(spike_idx,:);

            for k=1:size(spiketrain,1)
                id = find(inputs(:,1)==spiketrain(k,2));
                spiketrain(k,3)=inputs(id(1),3); % add the synapse id
                for k=2:length(id)
                    spiketrain(length(spiketrain)+1,:)=[spiketrain(k,1:2) inputs(id(k),3)]; % add the synapse id
                end    
            end

            %%%%%%%%%%%%%%

            handles.prop = {'precell','tau1','tau2','e','tau1a','tau2a','ea','tau1b','tau2b','eb'};
            fid = fopen([RunArray(idx).ModelDirectory '/datasets/syndata_' num2str(RunArray(ridx).SynData) '.dat']);
            numlines = textscan(fid,'%d\n',1);
            propstr=' %f %f %f %f %f %f %f %f %f';
            c = textscan(fid,['%s %s' propstr '\n']);
            st = fclose(fid);

            numcon = [];
            handles.data=[];      

            if size(c{1,1},1)>0
                for k=1:numlines{1,1}
                    postcell = c{1,1}{k};
                    precell = c{1,2}{k};
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
                        for m = 2:length(handles.prop)
                            handles.data.(postcell).(precell).syns(n).(handles.prop{m}) = c{1,m+1}(k);
                        end
                    catch
                        m
                    end
                end
            end            
            
            mysyns=[];
            allsyns = importdata([ myrepos(q).dir '/cells/allsyns.dat']);
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
                if ~isempty(handles.data.(post).(pre).syns(1).e) && ~isnan(handles.data.(post).(pre).syns(1).e)
                    if handles.data.(post).(pre).syns(1).e<-40
                        inh = [inh mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend];
                    else
                        exc = [exc mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend];
                    end
                else % assume GABAergic (a and b)
                    inh = [inh mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend];
                end
            end
            
            %%%%%%%%%%%%%%

            subplot('Position',[0.1 1-(z-1)*hgt-hgt*.48 .85 hgt*.4])
            plot(b.data(:,1),b.data(:,2),'Color','k');
            title([RunArray(ridx).RunName ': ' celltype ' cell, gid ' num2str(gid)], 'Interpreter','none')
            set(gca,'xticklabel',{})
            ylabel('Potential (mV)')
            ylim([-90 0])

            subplot('Position',[0.1 1-(z-1)*hgt-hgt*.73 .85 hgt*.23])
            spike_idx = ismember(spiketrain(:,3),exc);
            plot(spiketrain(spike_idx,1), spiketrain(spike_idx,3),'LineStyle','none','Marker','.','MarkerSize',10,'Color','m')
            xlim([0 RunArray(ridx).SimDuration])
            set(gca,'xticklabel',{})
            ylabel('Excitatory Sid')

            subplot('Position',[0.1 1-(z-1)*hgt-hgt*.95 .85 hgt*.2])
            spike_idx = ismember(spiketrain(:,3),inh);
            plot(spiketrain(spike_idx,1), spiketrain(spike_idx,3),'LineStyle','none','Marker','.','MarkerSize',10,'Color','c')
            xlim([0 RunArray(ridx).SimDuration])
            ylabel('Inhibitory Sid')
        end
    end
    
    if myflag==1
        xidx=length(filenamex)+1;
        set(h,'PaperUnits','normalized','PaperPosition',[0 0 1 1],'PaperOrientation','portrait')
        print(h,'-dpdf','-r600',[mypath '/' rname '_Comparisonx_' sprintf('%02g',xidx)])
        filenamex{xidx}=[mypath '/' rname '_Comparisonx_' sprintf('%02g',xidx)];
    end
    close(h)
end

xidx=length(filenamex)+1;

filestrx='';
for r=1:length(filenamex)
    filestrx=[filestrx filenamex{r} '.pdf '];
end
cmdstr=['gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=' mypath '/' rname '_ComparisonX.pdf ' filestrx];
[st outresult]=system(cmdstr);

filenames{length(filenames)+1} = [mypath '/' rname '_ComparisonX'];


%%%%%%%%%%%%%%%%%%


filestr='';
for r=1:length(filenames)
    filestr=[filestr filenames{r} '.pdf '];
end

idxstr='';

for z=1:length(handles.curses.indices)
    idxstr = [idxstr '_' num2str(handles.curses.indices(z))];
end

cmdstr=['gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=' mypath '/' rname idxstr '_Comparison.pdf ' filestr];
[st outresult]=system(cmdstr);

system(['rm ' mypath '/' rname '_Comparison_*.pdf']);
system(['rm ' mypath '/' rname '_Comparisonx_*.pdf']);
system(['rm ' mypath '/' rname '_ComparisonX.pdf']);







function results = getfft(hObject,handles,ind)
global mypath RunArray

handles.curses.ind = ind;

spikeraster(hObject,handles);
handles=guidata(hObject);


mycells = importdata([RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName '/celltype.dat']);
mycells.data(:,4)=mycells.data(:,3)-mycells.data(:,2)+1;

for r=1:size(mycells.data,1)-1
    idx = find(handles.curses.spikerast(:,2)>=mycells.data(r+1,2) & handles.curses.spikerast(:,2)<=mycells.data(r+1,3));

    rez=10; % .1 is simulation resolution

    Fs = 1000/rez; % sampling frequency (per s)

    bins=0:rez:RunArray(ind).SimDuration;
    y=histc(handles.curses.spikerast(idx,1),bins);
    y = y-sum(y)/length(y);

    NFFT = 2^(nextpow2(length(y))+2); % Next power of 2 from length of y
    Y = fft(y,NFFT)/length(y);
    f = Fs/2*linspace(0,1,NFFT/2+1);
    fft_results = 2*abs(Y(1:NFFT/2+1));
    
    theta_range=find(f(:)>=4 & f(:)<=12);
    [~, peak_idx] = max(fft_results(theta_range));
    rel_range=find(f(:)>2);
    [~, over_idx] = max(fft_results(rel_range));
    
    celltype = char(mycells.textdata(2+r, 1));
    results.(celltype)=[];
    
    results.(celltype).f = f(rel_range);
    results.(celltype).num = mycells.data(r+1,4);
    results.(celltype).rez = rez;
    results.(celltype).fft_results = fft_results(rel_range);
    results.(celltype).theta_freq = f(theta_range(peak_idx));
    results.(celltype).theta_pow = fft_results(theta_range(peak_idx));
    results.(celltype).all_freq = f(rel_range(over_idx));
    results.(celltype).all_pow = fft_results(rel_range(over_idx)); 

    yq=histc(handles.curses.spikerast(:,2),mycells.data(r+1,2):mycells.data(r+1,3));
    results.(celltype).numspikes = length(idx);
    results.(celltype).silent = length(find(yq==0));
    results.(celltype).min = min(yq);
    results.(celltype).max = max(yq);
    results.(celltype).mean = mean(yq);
    results.(celltype).std = std(yq);
    results.(celltype).all = sum(yq);
end

idx = find(handles.curses.spikerast(:,2)>=mycells.data(2,2));

rez=10; % .1 is simulation resolution

Fs = 1000/rez; % sampling frequency (per s)

bins=0:rez:RunArray(ind).SimDuration;
y=histc(handles.curses.spikerast(idx,1),bins);
y = y-sum(y)/length(y);

NFFT = 2^(nextpow2(length(y))+2); % Next power of 2 from length of y
Y = fft(y,NFFT)/length(y);
f = Fs/2*linspace(0,1,NFFT/2+1);
fft_results = 2*abs(Y(1:NFFT/2+1));

theta_range=find(f(:)>=4 & f(:)<=12);
[~, peak_idx] = max(fft_results(theta_range));
rel_range=find(f(:)>2);
[~, over_idx] = max(fft_results(rel_range));

results.all=[];

results.all.f = f(rel_range);
results.all.rez = rez;
results.all.fft_results = fft_results(rel_range);
results.all.theta_freq = f(theta_range(peak_idx));
results.all.theta_pow = fft_results(theta_range(peak_idx));
results.all.all_freq = f(rel_range(over_idx));
results.all.all_pow = fft_results(rel_range(over_idx)); 
