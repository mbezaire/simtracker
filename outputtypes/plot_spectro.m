function h=plot_spectro(handles)
%PLOT_SPECTRO  Plot spectrogram of simulation results.
%   H = PLOT_SPECTRO(HANDLES) where HANDLES contains a field called CURSES
%   and CURSES contains a field called spikerast will plot the spectrogram
%   of the network's spike times, LFP, or MP overall or by cell type
%   
%       h = plot_spectro(handles);
%   
%   returns the handle of the newly generated figure, h, for the plot.
%
%   H = PLOT_SPECTRO(HANDLES) where HANDLES contains a field OPTARG where
%   handles.optarg = TYPE
%   can be used to specify what property to perform the spectrogram on:
%       spikes     - spike times of all relevant cells (default)
%       sdf        - spike density function (using a gaussian kernel with a
%                       3 ms window)
%       lfp        - LFP of relevant recorded cells (local field potential)
%       mp         - MP of relevant recorded cells (membrane potential)
%   and which cells to include in the analysis:
%       pyr        - spectrogram of all [recorded] pyramidal cells (or
%                       whichever 3-character cell type was picked)
%       type       - spectrogram of all [recorded] cells, by cell type
%       all        - spectrogram of all [recorded] cells
%       gid        - spectrogram of one or more [recorded] cells, identified by gid
%   and how to present the results:
%       2d         - line graph of spectrogram power as a function of frequency (default)
%       heatmap    - 2D plot (frequency x cell-type) with colors signifying spectrogram power
%       table      - Entries of frequency at which peak power is found
%                       overall, within theta, and within gamma

%   See also PLOT_FFT, PLOT_LFP, PLOT_TRACE.

%   Marianne J. Bezaire, 2015
%   marianne.bezaire@gmail.com, www.mariannebezaire.com

global mypath RunArray sl

addpath(['outputtypes' sl 'chronux'],['outputtypes' sl 'chronux' sl 'spectral_analysis'], ...
    ['outputtypes' sl 'chronux' sl 'spectral_analysis' sl 'continuous'],['outputtypes' sl 'chronux' sl 'spectral_analysis' sl 'hybrid'], ...
    ['outputtypes' sl 'chronux' sl 'dataio'],['outputtypes' sl 'chronux' sl 'spectral_analysis' sl 'helper'])
% addpath([mypath sl 'outputtypes' sl 'chronux'],[mypath sl 'outputtypes' sl 'chronux' sl 'spectral_analysis'], ...
%     [mypath sl 'outputtypes' sl 'chronux' sl 'spectral_analysis' sl 'continuous'],[mypath sl 'outputtypes' sl 'chronux' sl 'spectral_analysis' sl 'hybrid'], ...
%     [mypath sl 'outputtypes' sl 'chronux' sl 'dataio'],[mypath sl 'outputtypes' sl 'chronux' sl 'spectral_analysis' sl 'helper'])

h=[];
ind = handles.curses.ind;
%myflag=0;

tmp=deblank(handles.optarg);

posflag=0;
if isfield(handles.curses,'epos')
    posflag=1;
end

if isfield(handles,'optarg')
    tmp=lower(deblank(handles.optarg));
else
    tmp='';
end

NiceAbbrev = {'Pyr.','O-LM','Bis.','Axo.','PV+ B.','CCK+ B.','S.C.-A.','Ivy','NGF.','CA3','ECIII'};
nicekey={'pyramidalcell','olmcell','bistratifiedcell','axoaxoniccell','pvbasketcell','cckcell','scacell','ivycell','ngfcell','ca3cell','eccell'};

datatype='spikes';
if ~isempty(strfind(tmp,'avglfp'))
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
    %h(length(h)+1)=figure('Color','w','Name',['Spectrogram of LFP (' dispformat ')']);
    if posflag==1
        [f, fft, titlestr, h]=compspectro(handles,[],'epos',h);
    else
        [f, fft, titlestr, h]=compspectro(handles,[],'lfp',h);
    end
    title(['Spectrogram of LFP (' dispformat ')'])
    set(gcf,'Name',['Spectrogram of LFP (' dispformat ')'])
    h(length(h)+1)=gcf;
    return
end

myresults=[];

switch org
    case 'type'
        for r=1:length(handles.curses.cells)
            if posflag==1
                gids = handles.curses.cells(r).mygids;
            else
                gids = handles.curses.cells(r).range_st:handles.curses.cells(r).range_en;
            end
            [f, fft, titlestr,h]=compspectro(handles,gids,datatype,h);
            k=strmatch(handles.curses.cells(r).name,nicekey,'exact');
                if isempty(k)
                    myresults(r).name=handles.curses.cells(r).name;
                else
                    myresults(r).name=NiceAbbrev{k};
                end
            myresults(r).f=f;
            myresults(r).fft=fft;
            title(['Spectrogram of ' datatype ' of ' myresults(r).name])
            set(gcf,'Name',['Spectrogram of ' datatype ' of ' myresults(r).name])
        end
    case 'all'
        if posflag==1
            gids=[];
            for r=1:length(handles.curses.cells)
                gids = [gids handles.curses.cells(r).mygids];
            end
        else
            gids = handles.curses.cells(1).range_st:handles.curses.cells(end).range_en;
        end
        [f, fft, titlestr,h]=compspectro(handles,gids,datatype,h);
            title(['Spectrogram of ' datatype ' of all cells'])
            set(gcf,'Name',['Spectrogram of ' datatype ' of all cells'])
    case 'specific'
        ridx=0;
        for r=1:length(handles.curses.cells)
            if ~isempty(strfind(tmp,handles.curses.cells(r).name(1:3)))
                if posflag==1
                    gids = handles.curses.cells(r).mygids;
                else
                    gids = handles.curses.cells(r).range_st:handles.curses.cells(r).range_en;
                end
                [f, fft, titlestr,h]=compspectro(handles,gids,datatype,h);
                k=strmatch(handles.curses.cells(r).name,nicekey,'exact');
                ridx=ridx+1;
                if isempty(k)
                    myresults(ridx).name=handles.curses.cells(r).name;
                else
                    myresults(ridx).name=NiceAbbrev{k};
                end
                myresults(ridx).f=f;
                myresults(ridx).fft=fft;
                title(['Spectrogram of ' datatype ' of ' myresults(r).name])
                set(gcf,'Name',['Spectrogram of ' datatype ' of ' myresults(ridx).name])
            end
        end
    case 'gid'
        ridx=0;
        gidstr=regexp(tmp,'[0-9]+','match');
        if length(gidstr)>0
            gids=[];
            for g=1:length(gidstr)
                gids(g)=str2num(gidstr{g});
                [f, fft, titlestr,h]=compspectro(handles,gids(g),datatype,h);
                ridx=ridx+1;
                myresults(ridx).name=gidstr{g};
                myresults(ridx).f=f;
                myresults(ridx).fft=fft;
                title(['Spectrogram of ' datatype ' of ' gidstr{g}])
                set(gcf,'Name',['Spectrogram of ' datatype ' of ' gidstr{g}])
            end
        end
end
colormap(jet)
colorbar

% switch dispformat
%     case '2d'
%         h(length(h)+1)=figure('Color','w','Name',['Spectrogram of ' datatype]);
%         for r=1:length(myresults)
%             plot(myresults(r).f,myresults(r).fft)
%             hold on
%         end
%         legend({myresults(:).name})
%         xlabel('Frequency (Hz)')
%         ylabel('Power')
%         xlim([0 100])
%         title(['Spectrogram of ' datatype])
%     case 'heat'
%         h(length(h)+1)=figure('Color','w','Name',['Normalized Spectrogram heat map of ' datatype]);
%         sety={};
%         celldata.yy=[];
%         celldata.zz=[];
%         legstr={};
%         celldata.xx=myresults(1).f;
%         for r=1:length(myresults)
%             celldata.yy=[celldata.yy ; ones(size(myresults(r).f))*r];
%             celldata.zz=[celldata.zz ;  myresults(r).fft'./max(myresults(r).fft)];
%             legstr{length(legstr)+1}=myresults(r).name;            
%             sety{r} = myresults(r).name;
%         end
%         z=imagesc(celldata.xx,[1:3],flipud(celldata.zz));
%         colormap(jet)
%         colorbar
%         set(gca,'yticklabel',fliplr(sety))
% 
%         xlabel('Frequency (Hz)')
%         xlim([0 100])
%     case 'table'
%         h(length(h)+1)=figure('Color','w','Name',['Spectrogram table of ' datatype]);
%         for r=1:length(myresults)
%             theta_range=find(myresults(r).f(:)>=4 & myresults(r).f(:)<=12);
%             [~, peak_idx] = max(myresults(r).fft(theta_range));
%             rel_range=find(myresults(r).f(:)>2 & myresults(r).f(:)<=100);
%             [~, over_idx] = max(myresults(r).fft(rel_range));
%             tbldata{r,1}=myresults(r).name;
%             tbldata{r,2}=myresults(r).f(peak_idx);
%             tbldata{r,3}=myresults(r).fft(peak_idx);
%             tbldata{r,4}=myresults(r).f(over_idx);
%             tbldata{r,5}=myresults(r).fft(over_idx);
%         end
%         maketbl(h(end),tbldata)
% end

function maketbl(h,tbldata)
global mypath  tableh

for r=1:size(tbldata,1)
    for c=2:size(tbldata,2)
        tbldata{r,c}=str2double(sprintf('%.2f',tbldata{r,c}));
    end
end
myzfunc=@context_copymytable_Callback;
mycontextmenuz=uicontextmenu('Tag','menu_copy1','Parent',h);
uimenu(mycontextmenuz,'Label','Copy Table','Tag','context_copytable1','Callback',myzfunc);

tableh = uitable(h, 'Data', tbldata,'ColumnFormat',{'char','bank','bank','bank','bank'},'ColumnName',{'Name','Theta (Hz)','Theta Power','Peak (Hz)','Peak Power'},'Units','inches', 'UIContextMenu',mycontextmenuz);
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



function [f, fft_results, titlestr, h]=compspectro(handles,gids,tmp,h)
global mypath RunArray sl

f=[];
fft_results=[];
titlestr='';
ind = handles.curses.ind;
% what metric are we analyzing
if ~isempty(strfind(tmp,'spike')) || isempty(tmp) || (isempty(strfind(tmp,'lfp')) && isempty(strfind(tmp,'epos')) && isempty(strfind(tmp,'mp')) && isempty(strfind(tmp,'sdf')))
    titlestr=' Spike Times';

    idx = find(ismember(handles.curses.spikerast(:,2),gids)==1);
    idt = find(handles.curses.spikerast(idx,1)>handles.general.crop);
 
    rez=.5;
    Fs = 1000/rez; % sampling frequency (per s)

    bins=[0:rez:RunArray(ind).SimDuration];
    y=histc(handles.curses.spikerast(idx(idt),1),bins);
    y = y-sum(y)/length(y);

    hw=plot_spectrogram(y,1000/rez,RunArray(ind).SimDuration);
    %[f, fft_results]=myfft(handles.curses.spikerast(idx(idt),1),RunArray(ind).SimDuration,rez);
end
if ~isempty(strfind(tmp,'sdf'))
    titlestr=' SDF (Gaussian, 3 ms window)';

    idx = find(ismember(handles.curses.spikerast(:,2),gids)==1);
    idt = find(handles.curses.spikerast(idx,1)>handles.general.crop);
    
    binned= histc(handles.curses.spikerast(idx(idt),1),[handles.general.crop:1:RunArray(ind).SimDuration]); % binned by 1 ms
    window=3; % ms
    kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
    sdf = conv(binned,kernel,'same');
    y = sdf-sum(sdf)/length(sdf);
 
    hw=plot_spectrogram(y,1000,RunArray(ind).SimDuration); % binned 1 ms
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
    hw=plot_spectrogram(avglfp,1000/RunArray(ind).lfp_dt,RunArray(ind).SimDuration);
    titlestr=[' Average LFP of gids ' mystr(1:end-1)];
elseif ~isempty(strfind(tmp,'lfp'))
    hw=plot_spectrogram(handles.curses.lfp(:,2),1000/RunArray(ind).lfp_dt,RunArray(ind).SimDuration);
    titlestr=' LFP';
elseif ~isempty(strfind(tmp,'epos'))
    hw=plot_spectrogram(handles.curses.epos.lfp,1000/RunArray(ind).lfp_dt,RunArray(ind).SimDuration);
    titlestr=' position LFP';
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
    hw=plot_spectrogram(avgmp,1000/mydata(1).data.data(2,1),RunArray(ind).SimDuration);
    titlestr=[' Average MP of gids ' mystr(1:end-1)];
end

if exist('hObject','var') && ~isempty(hObject)
    try
        guidata(handles.btn_generate, handles)
    catch me
        guidata(hObject, handles)
    end
end
