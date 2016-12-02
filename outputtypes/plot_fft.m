function [h, varargout]=plot_fft(hObject,handles)
%PLOT_FFT  Plot FFT of simulation results.
%   H = PLOT_FFT(HANDLES) where HANDLES contains a field called CURSES
%   and CURSES contains a field called spikerast will plot the FFT
%   of the network's spike times, LFP, or MP overall or by cell type
%   
%       h = plot_fft(handles);
%   
%   returns the handle of the newly generated figure, h, for the plot.
%
%   H = PLOT_FFT(HANDLES) where HANDLES contains a field OPTARG where
%   handles.optarg = TYPE
%   can be used to specify which analysis to perform:
%       pwelch     - Welch's power spectral density estimate (default),
%                       with the signal divided into up to 8 sections with
%                       50% overlap
%       gram       - periodogram power spectral density estimate using a
%                       rectangular window and a default number of points
%                       in the DFT, the max of 256 and the next power of 
%                       two greater than the signal length
%       fft        - Fast Fourier Transform (FFT)
%   and what property to perform the analysis on:
%       sdf        - spike density function (using a gaussian kernel with a
%                       3 ms window) (default)
%       spikes     - spike times of all relevant cells
%       lfp        - LFP of relevant recorded cells (local field potential)
%       mp         - MP of relevant recorded cells (membrane potential)
%   and which cells to include in the analysis:
%       pyr        - FFT of all [recorded] pyramidal cells (or
%                       whichever 3-character cell type was picked)
%       type       - FFT of all [recorded] cells, by cell type
%       all        - FFT of all [recorded] cells
%       gid        - FFT of one or more [recorded] cells, identified by gid
%   and how to present the results:
%       2d         - line graph of FFT power as a function of frequency (default)
%       heatmap    - 2D plot (frequency x cell-type) with colors signifying FFT power
%       table      - Entries of frequency at which peak power is found
%                       overall, within theta, and within gamma
%   and whether to normalize the results:
%       norm         - normalize the FFT results (default is not to
%                       normalize)

%   See also PLOT_SPECTRO, PLOT_LFP, PLOT_TRACE.

%   Marianne J. Bezaire, 2015
%   marianne.bezaire@gmail.com, www.mariannebezaire.com

global mypath RunArray

tbldata={};
h=[];
ind = handles.curses.ind;
%myflag=0;

tmp=deblank(handles.optarg);

if isfield(handles,'optarg')
    tmp=lower(deblank(handles.optarg));
else
    tmp='';
end

NiceAbbrev = {'Pyr.','O-LM','Bis.','Axo.','PV+ B.','CCK+ B.','S.C.-A.','Ivy','NGF.','CA3','ECIII'};
nicekey={'pyramidalcell','olmcell','bistratifiedcell','axoaxoniccell','pvbasketcell','cckcell','scacell','ivycell','ngfcell','ca3cell','eccell'};

normflag=0;
if ~isempty(strfind(tmp,'norm'))
    normflag=1;
end

analtype='pwelch';
analtitle='Welch''s Periodogram';
if ~isempty(strfind(tmp,'gram'))
    analtype='gram';
    analtitle='Periodogram';
elseif ~isempty(strfind(tmp,'fft'))
    analtype='fft';
    analtitle='FFT';
elseif ~isempty(strfind(tmp,'pwelch'))
    analtype='pwelch';
    analtitle='Welch''s Periodogram';
end

datatype='sdf';
if ~isempty(strfind(tmp,'spikes'))
    datatype='spikes';
elseif ~isempty(strfind(tmp,'avglfp'))
    datatype='avglfp';
elseif ~isempty(strfind(tmp,'lfp'))
    datatype='lfp';
elseif ~isempty(strfind(tmp,'mp'))
    datatype='mp';
elseif ~isempty(strfind(tmp,'sdf'))
    datatype='sdf';
end

dispformat='2d';
if ~isempty(strfind(tmp,'heat')) || ~isempty(strfind(tmp,'map'))
    dispformat='heat';
elseif ~isempty(strfind(tmp,'table'))
    dispformat='table';
end

org='type';
gidstr=regexp(tmp,'[0-9]+','match');
if length(gidstr)>0
    org='gid';
elseif ~isempty(strfind(tmp,'all'))
    org='all';
else
    for r=1:length(handles.curses.cells)
        if ~isempty(strfind(tmp,handles.curses.cells(r).name(1:3)))
            org='specific';
        end
    end
end


if strcmp(datatype,'lfp')
    if normflag
        h(length(h)+1)=figure('Color','w','Name',['Normalized ' analtitle ' of LFP (' dispformat ')']);
    else
        h(length(h)+1)=figure('Color','w','Name',[analtitle ' of LFP (' dispformat ')']);
    end
    [f, fft, titlestr, h]=compfft(handles,[],['lfp,' analtype],h);
    switch dispformat
        case 'table'
            r=1;
            tbldata={};
            theta_range=find(f(:)>=5 & f(:)<=10);
            [~, peak_idx] = max(fft(theta_range));
            rel_range=find(f(:)>2 & f(:)<=100);
            [~, over_idx] = max(fft(rel_range));
            tbldata{r,1}='LFP';
            tbldata{r,2}=f(theta_range(peak_idx));
            tbldata{r,3}=fft(theta_range(peak_idx));
            tbldata{r,4}=f(rel_range(over_idx));
            tbldata{r,5}=fft(rel_range(over_idx));
            maketbl(h(end),tbldata,[analtitle ' LFP'])
        otherwise
            if normflag
                plot(f,fft/max(fft))
                title(['Normalized ' analtitle ' of LFP'])
            else
                plot(f,fft)
                title([analtitle ' of LFP'])
            end
            xlabel('Frequency (Hz)')
            ylabel('Power')
            xlim([0 100])
    end
    return
end

myresults=[];

switch org
    case 'type'
        for r=1:length(handles.curses.cells)
            gids = handles.curses.cells(r).range_st:handles.curses.cells(r).range_en;
            [f, fft, titlestr,h]=compfft(handles,gids,[datatype ',' analtype],h);
            k=strmatch(handles.curses.cells(r).name,nicekey,'exact');
            myresults(r).name=NiceAbbrev{k};
            myresults(r).f=f;
            myresults(r).fft=fft;
        end
    case 'all'
        gids = handles.curses.cells(1).range_st:handles.curses.cells(end).range_en;
        [f, fft, titlestr,h]=compfft(handles,gids,[datatype ',' analtype],h);
    case 'specific'
        ridx=0;
        for r=1:length(handles.curses.cells)
            if ~isempty(strfind(tmp,handles.curses.cells(r).name(1:3)))
                gids = handles.curses.cells(r).range_st:handles.curses.cells(r).range_en;
                [f, fft, titlestr,h]=compfft(handles,gids,[datatype ',' analtype],h);
                k=strmatch(handles.curses.cells(r).name,nicekey,'exact');
                ridx=ridx+1;
                myresults(ridx).name=NiceAbbrev{k};
                myresults(ridx).f=f;
                myresults(ridx).fft=fft;
            end
        end
    case 'gid'
        ridx=0;
        gidstr=regexp(tmp,'[0-9]+','match');
        if length(gidstr)>0
            gids=[];
            for g=1:length(gidstr)
                gids(g)=str2num(gidstr{g});
                [f, fft, titlestr,h]=compfft(handles,gids(g),[datatype ',' analtype],h);
                ridx=ridx+1;
                myresults(ridx).name=gidstr{g};
                myresults(ridx).f=f;
                myresults(ridx).fft=fft;
            end
        end
end


switch dispformat
    case '2d'
        if normflag
            h(length(h)+1)=figure('Color','w','Name',['Normalized ' analtitle ' of ' datatype]);
        else
            h(length(h)+1)=figure('Color','w','Name',[analtitle ' of ' datatype]);
        end
        for r=1:length(myresults)
            if normflag
                plot(myresults(r).f,myresults(r).fft/max(myresults(r).fft))
            else
                plot(myresults(r).f,myresults(r).fft)
            end
            hold on
        end
        legend({myresults(:).name})
        xlabel('Frequency (Hz)')
        ylabel('Power')
        xlim([0 100])
        if normflag
            title(['Normalized ' analtitle ' of ' datatype])
        else
            title([analtitle ' of ' datatype])
        end
    case 'heat'
        if normflag
            h(length(h)+1)=figure('Color','w','Name',['Normalized ' analtitle ' heat map of ' datatype]);
        else
            h(length(h)+1)=figure('Color','w','Name',[analtitle ' heat map of ' datatype]);
        end
        sety={};
        celldata.yy=[];
        celldata.zz=[];
        legstr={};
        celldata.xx=myresults(1).f;
        for r=1:length(myresults)
            celldata.yy=[celldata.yy ; ones(size(myresults(r).f))*r];
            if normflag
                celldata.zz=[celldata.zz ;  myresults(r).fft'./max(myresults(r).fft)];
            else
                celldata.zz=[celldata.zz ;  myresults(r).fft'];
            end
            legstr{length(legstr)+1}=myresults(r).name;            
            sety{r} = myresults(r).name;
        end
        z=imagesc(celldata.xx,[1:3],flipud(celldata.zz));
        colormap(jet)
        colorbar
        set(gca,'yticklabel',fliplr(sety))

        xlabel('Frequency (Hz)')
        xlim([0 100])
    case 'table'
        h(length(h)+1)=figure('Color','w','Name',[analtitle ' table of ' datatype]);
        for r=1:length(myresults)
            theta_range=find(myresults(r).f(:)>=5 & myresults(r).f(:)<=10);
            [~, peak_idx] = max(myresults(r).fft(theta_range));
            rel_range=find(myresults(r).f(:)>2 & myresults(r).f(:)<=100);
            [~, over_idx] = max(myresults(r).fft(rel_range));
            tbldata{r,1}=myresults(r).name;
            tbldata{r,2}=myresults(r).f(theta_range(peak_idx));
            tbldata{r,3}=myresults(r).fft(theta_range(peak_idx));
            tbldata{r,4}=myresults(r).f(rel_range(over_idx));
            tbldata{r,5}=myresults(r).fft(rel_range(over_idx));
        end
        maketbl(h(end),tbldata,[analtitle ' ' datatype])
end

if nargout>1
    varargout{1}=tbldata;
    close(h);
    h=[];
end

function maketbl(h,tbldata,tblstr)
global mypath  tableh

for r=1:size(tbldata,1)
    for c=2:size(tbldata,2)
        tbldata{r,c}=str2double(sprintf('%.2f',tbldata{r,c}));
    end
end
myzfunc=@context_copymytable_Callback;
mycontextmenuz=uicontextmenu('Tag','menu_copy1','Parent',h);
uimenu(mycontextmenuz,'Label','Copy Table','Tag','context_copytable1','Callback',myzfunc);

tableh = uitable(h, 'Data', tbldata,'ColumnFormat',{'char','bank','bank','bank','bank'},'ColumnName',{[tblstr ': Name'],'Theta (Hz)','Theta Power','Peak (Hz)','Peak Power'},'Units','inches', 'UIContextMenu',mycontextmenuz);
ex=get(tableh,'Extent');
set(h,'Units','inches');
pos=get(h,'Position');
set(h,'Position',[pos(1) pos(2) ex(3)+.05 ex(4)+.05])
set(tableh,'Units','normalized','Position',[0 0 1 1])


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



function [f, fft_results, titlestr, h]=compfft(handles,gids,tmp,h)
global mypath RunArray sl

titlestr='';
ind = handles.curses.ind;
% what metric are we analyzing
if ~isempty(strfind(tmp,'sdf')) || isempty(tmp) || (isempty(strfind(tmp,'spike')) && isempty(strfind(tmp,'lfp')) && isempty(strfind(tmp,'mp')))
    titlestr=' SDF (Gaussian, 3 ms window)';

    idx = find(ismember(handles.curses.spikerast(:,2),gids)==1);
    idt = find(handles.curses.spikerast(idx,1)>handles.general.crop);
    
    binned= histc(handles.curses.spikerast(idx(idt),1),[handles.general.crop:1:RunArray(ind).SimDuration]); % binned by 1 ms
    window=3; % ms
    kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
    sdf = conv(binned,kernel,'same');
    sdf=sdf-sum(sdf)/length(sdf);
 
    if ~isempty(strfind(tmp,'fft'))
        [f, fft_results]=mycontfft([handles.general.crop:1:RunArray(ind).SimDuration],sdf);
    elseif ~isempty(strfind(tmp,'gram'))
        [fft_results, f]=periodogram(sdf,[],[],1000,'onesided','power');
    else
        [fft_results, f]=pwelch(sdf,[],[],[],1000,'onesided','power');
    end
end
if ~isempty(strfind(tmp,'spike'))
    titlestr=' Spike Times';

    idx = find(ismember(handles.curses.spikerast(:,2),gids)==1);
    idt = find(handles.curses.spikerast(idx,1)>handles.general.crop);
    spikes=handles.curses.spikerast(idx(idt),1);
 
    rez=1;
    if ~isempty(strfind(tmp,'fft'))
        [f, fft_results]=myfft(spikes,RunArray(ind).SimDuration,rez);
    elseif ~isempty(strfind(tmp,'gram'))
        Fs = 1000/rez; % sampling frequency (per s)
        bins=[0:rez:RunArray(ind).SimDuration];
        y=histc(spikes,bins);
        y = y-sum(y)/length(y);
        [fft_results, f]=periodogram(y,[],[],Fs,'onesided','power');
    else
        Fs = 1000/rez; % sampling frequency (per s)
        bins=[0:rez:RunArray(ind).SimDuration];
        y=histc(spikes,bins);
        y = y-sum(y)/length(y);
        [fft_results, f]=pwelch(y,[],[],[],Fs,'onesided','power');
    end
end
if ~isempty(strfind(tmp,'avglfp'))
    gidx=0;
    mystr='';
    testy=[];
    for g=1:length(gids)
        thefile=[RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'lfptrace_' num2str(gids(g)) '.dat'];
        if exist(thefile,'file')
            gidx=gidx+1;
            mydata(gidx).data=importdata(thefile);
            if gidx==1
                testy=mydata(gidx).data(:,2)';
                mystr=[num2str(gids(g)) ','];
            else
                testy=[testy;mydata(gidx).data(:,2)'];
                mystr=[mystr num2str(gids(g)) ','];
            end
        end
    end
    if gidx>1
        avglfp=mean(testy);
    else
        avglfp=testy;
    end
    if isempty(avglfp)
        f=[];fft_results=[];
        return
    end
    avglfp=avglfp-sum(avglfp)/length(avglfp);
    if ~isempty(strfind(tmp,'fft'))
        [f, fft_results]=mycontfft([0 RunArray(ind).lfp_dt],avglfp);
    elseif ~isempty(strfind(tmp,'gram'))
        [fft_results, f]=periodogram(avglfp,[],[],1000/RunArray(ind).lfp_dt,'onesided','power');
    else
        [fft_results, f]=pwelch(avglfp,[],[],[],1000/RunArray(ind).lfp_dt,'onesided','power');
    end
    titlestr=[' Average LFP of gids ' mystr(1:end-1)];
elseif ~isempty(strfind(tmp,'lfp'))
    lfp=handles.curses.lfp(:,2)-sum(handles.curses.lfp(:,2))/length(handles.curses.lfp(:,2));
    if ~isempty(strfind(tmp,'fft'))
        [f, fft_results]=mycontfft([0 RunArray(ind).lfp_dt],lfp);
    elseif ~isempty(strfind(tmp,'gram'))
        [fft_results, f]=periodogram(lfp,[],[],1000/RunArray(ind).lfp_dt,'onesided','power');
    else
        [fft_results, f]=pwelch(lfp,[],[],[],1000/RunArray(ind).lfp_dt,'onesided','power');
    end
    titlestr=' LFP';
end
if ~isempty(strfind(tmp,'mp'))
    gidx=0;
    mystr='';
    testy=[];
    for g=1:length(gids)
        tmpfile=[RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'trace_*cell' num2str(gids(g)) '.dat'];
        d=dir(tmpfile);
        if ~isempty(d)
            thefile=[RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d.name];
            gidx=gidx+1;
            mydata(gidx).data=importdata(thefile);
            if gidx==1
                testy=mydata(gidx).data.data(:,2)';
                mystr=[num2str(gids(g)) ','];
            else
                testy=[testy;mydata(gidx).data.data(:,2)'];
                mystr=[mystr num2str(gids(g)) ','];
            end
        end
    end
    if gidx>1
        avgmp=mean(testy);
    else
        avgmp=testy;
    end
    avgmp=avgmp-sum(avgmp)/length(avgmp);
    if ~isempty(strfind(tmp,'fft'))
        [f, fft_results]=mycontfft([0 mydata(1).data.data(2,1)],avgmp);
    elseif ~isempty(strfind(tmp,'gram'))
        [fft_results, f]=periodogram(avgmp,[],[],1000/mydata(1).data.data(2,1),'onesided','power');
    else
        [fft_results, f]=pwelch(avgmp,[],[],[],1000/mydata(1).data.data(2,1),'onesided','power');
    end
    titlestr=[' Average MP of gids ' mystr(1:end-1)];
end

function plotperiodogram(x,y,varargin)

Fs=1000/x(2);
N = length(y);
xdft = fft(y);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;

if ~isempty(varargin)
    plot(freq,10*log10(psdx),varargin{:})
else
    plot(freq,10*log10(psdx))
end
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
