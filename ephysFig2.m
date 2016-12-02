function varargout=ephysFig2(varargin)
global mypath disspath myFontSize myFontWeight myFontName sl savepath printflag printtable
lw=1.0;
lwd=1.0;
celltypeNice={'Pyr','PV+B','CCK+B','SC-A','Axo','Bis','O-LM','Ivy','NGF'};
celltypeKey={'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'};

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);

repospath=myrepos(q).dir;
load([repospath '\cellclamp_results\website\channeldata.mat'],'chantraces','allchans','allchannels','chanephys','expephys')

if printtable
fid=fopen([savepath sl 'Channel_Activation.txt'],'w');
fprintf(fid,'');
fclose(fid);
end


    set(0,'DefaultAxesFontName','ArialMT','DefaultAxesFontSize',myFontSize)
    % ion channel
    try
    z(1) = figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Activation','Units','inches','PaperUnits','inches','Position',[.5 .5 2 1.5],'PaperPosition',[0 0 2 1.5]);
    catch
    z(1) = figure('Renderer', 'painters','Color','w','Name','Activation','Units','inches','PaperUnits','inches','Position',[.5 .5 2 1.5],'PaperPosition',[0 0 2 1.5]);
    end
    plot(chantraces.Nav.Activation.Voltage,chantraces.Nav.Activation.Response,'LineWidth',lwd,'Color','k','LineStyle','-')
    hold on
    plot(chantraces.Nav.Inactivation.Voltage,chantraces.Nav.Inactivation.Response,'LineWidth',lwd,'Color',[.5 .5 .5],'LineStyle','-')
    box off
    xlim([-120 80])
    tact=text(0,.5,'Act.','Color','k','HorizontalAlignment','left');
    tint=text(-100,.5,'Inact.','Color',[.4 .4 .4],'HorizontalAlignment','left');
%     legend({'Activation','Inactivation'},'Location','NorthOutside','EdgeColor',[1 1 1],'Color',[1 1 1])
%     legend boxoff
    formatter(gca)
    formatter(xlabel('Voltage (mV)'))
    formatter(ylabel('Norm. Conductance'))
    bf = findall(z(1),'Type','text');
    for b=1:length(bf)
        set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag 
        printeps(z(1),[disspath 'Activation']);
    else
    end
        hout(1)=z(1);

    try
    z(2) = figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Current','Units','inches','PaperUnits','inches','Position',[.5 .5 2 1.5],'PaperPosition',[0 0 2 1.5]);
    catch
    z(2) = figure('Renderer', 'painters','Color','w','Name','Current','Units','inches','PaperUnits','inches','Position',[.5 .5 2 1.5],'PaperPosition',[0 0 2 1.5]);
    end
    plot(chantraces.Nav.IVPeak.Voltage,chantraces.Nav.IVPeak.Response,'LineWidth',lwd,'Color','k','LineStyle','-')
    hold on
    plot(chantraces.Nav.IVSteady.Voltage,chantraces.Nav.IVSteady.Response,'LineWidth',lwd,'Color',[.5 .5 .5],'LineStyle','-')
    box off
    xlim([-120 80])
    tact=text(-70,-.02,'Peak','Color','k','HorizontalAlignment','left');
    tint=text(-70,.005,'Steady','Color',[.4 .4 .4],'HorizontalAlignment','left');
%     formatter(legend({'Peak','Steady State'},'Location','NorthOutside','EdgeColor',[1 1 1],'Color',[1 1 1]))
%     legend boxoff
    formatter(gca)
    formatter(xlabel('Voltage (mV)'))
    formatter(ylabel('Current (nA)'))
    bf = findall(z(2),'Type','text');
    for b=1:length(bf)
        set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
        printeps(z(2),[disspath 'Current']);
    else
    end
        hout(2)=z(2);
    varargout{1}=hout;
%return

    load([mypath sl 'data' sl 'AllCellsData.mat']);
    b=strmatch('pyramidalcell1803',{AllCells.CellName},'exact');
    if ~isempty(b)
        try
    hz(1)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Current Sweep Simple','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    catch
    hz(1)=figure('Renderer', 'painters','Color','w','Name','Current Sweep Simple','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    end
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(b).DetailedData '.mat'],AllCells(b).DetailedData)
    eval(['DetailedData = ' AllCells(b).DetailedData ';']);

    for r=1:length(DetailedData.AxoClampData.Data)
        if DetailedData.AxoClampData.Currents(r)<0 || DetailedData.AxoClampData.Currents(r) == max(DetailedData.AxoClampData.Currents)
            plot(DetailedData.AxoClampData.Time.Data,DetailedData.AxoClampData.Data(r).RecordedVoltage,'Color','k','LineWidth',1)
            hold on
        end
    end
    bx=xlim;
    by=ylim;
    plot([bx(1) bx(1)+.1],[by(1) by(1)],'k');
    plot([bx(1) bx(1)],[by(1) by(1)+20],'k');
    formatter(text(bx(1)+.01,by(1)+7,{'20 mV','  100 ms'}));
    formatter(gca)
    axis off
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
        printeps(hz(1),[disspath 'CurrentSweepSimple']);
    else
    end
        hout(3)=hz(1);
    end
    
    %b=strmatch('pyramidalcell_1357',{AllCells.CellName},'exact');
    b=strmatch('pyramidalcell1803',{AllCells.CellName},'exact');
    if ~isempty(b)
        try
    hz(2)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Current Sweep Complex','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    catch
    hz(2)=figure('Renderer', 'painters','Color','w','Name','Current Sweep Complex','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    end
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(b).DetailedData '.mat'],AllCells(b).DetailedData)
    eval(['DetailedData = ' AllCells(b).DetailedData ';']);
    for r=1:length(DetailedData.AxoClampData.Data)
        if DetailedData.AxoClampData.Currents(r)<0 || DetailedData.AxoClampData.Currents(r) == max(DetailedData.AxoClampData.Currents)
            plot(DetailedData.AxoClampData.Time.Data,DetailedData.AxoClampData.Data(r).RecordedVoltage,'Color',[0 0 .6],'LineWidth',1)
            hold on
        end
    end
    xlim([0 max(DetailedData.AxoClampData.Time.Data)])
    %xlim([.400 1.600])
    [~, minr]=min(DetailedData.AxoClampData.Currents);
    [~, maxr]=max(DetailedData.AxoClampData.Currents);
    ylim([min(DetailedData.AxoClampData.Data(minr).RecordedVoltage) max(DetailedData.AxoClampData.Data(maxr).RecordedVoltage)])
    bx=xlim;
    by=ylim;
    ylim([by(1)-7 by(2)]);
    by=ylim;
    plot([bx(1) bx(1)+.1],[by(1) by(1)],'k','LineWidth',lwd);
    plot([bx(1) bx(1)],[by(1) by(1)+20],'k','LineWidth',lwd);
    % formatter(text(bx(1)+.01,by(1)+10,{'20 mV','  100 ms'}));
    formatter(gca,0)
    set(gca,'Position',[.1 .1 .8 .8])
    axis off
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
    printeps(hz(2),[disspath 'CurrentSweepComplex']);
    else
    end
        hout(4)=hz(2);
    end
     
    b=strmatch('pvbasketcell1861',{AllCells.CellName},'exact');
    % b=strmatch('pvbasketcell_1450',{AllCells.CellName},'exact');
    if ~isempty(b)
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(b).DetailedData '.mat'],AllCells(b).DetailedData)
    eval(['DetailedData = ' AllCells(b).DetailedData ';']);
    try
    hzr(1)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Current Sweep PVBC','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    catch
    hzr(1)=figure('Renderer', 'painters','Color','w','Name','Current Sweep PVBC','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    end
%     pos=get(hzr(1),'Position');
%     set(hzr(1),'Position',[pos(1) pos(2) pos(3)*.6 pos(4)])
    for r=1:length(DetailedData.AxoClampData.Data)
        if DetailedData.AxoClampData.Currents(r)<0 || DetailedData.AxoClampData.Currents(r) == max(DetailedData.AxoClampData.Currents)
            plot(DetailedData.AxoClampData.Time.Data,DetailedData.AxoClampData.Data(r).RecordedVoltage,'Color',[.0 .75 .65],'LineWidth',1)
            hold on
        end
    end
    xlim([0 .600])
    ylim([-125 55])
    bx=xlim;
    by=ylim;
    plot([bx(1) bx(1)+.1],[by(1) by(1)],'w','LineWidth',lwd);
    plot([bx(2) bx(2)],[by(2)-20 by(2)],'w','LineWidth',lwd);
    formatter(gca,0)
    set(gca,'Position',[.1 .1 .8 .8])
    axis off
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
    printeps(hzr(1),[disspath 'CurrentSweepPVBC']);
    else
    end
        hout(5)=hzr(1);
    end
 
    b=strmatch('cckcell1857',{AllCells.CellName},'exact');
    %b=strmatch('cckcell_1449',{AllCells.CellName},'exact');
    if ~isempty(b)
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(b).DetailedData '.mat'],AllCells(b).DetailedData)
    eval(['DetailedData = ' AllCells(b).DetailedData ';']);
    try
    hzr(2)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Current Sweep CCK','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    catch
    hzr(2)=figure('Renderer', 'painters','Color','w','Name','Current Sweep CCK','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    end
%     pos=get(hzr(2),'Position');
%     set(hzr(2),'Position',[pos(1) pos(2) pos(3)*.6 pos(4)])
    for r=1:length(DetailedData.AxoClampData.Data)
        if DetailedData.AxoClampData.Currents(r)<0 ||DetailedData.AxoClampData.Currents(r) == max(DetailedData.AxoClampData.Currents)
            plot(DetailedData.AxoClampData.Time.Data,DetailedData.AxoClampData.Data(r).RecordedVoltage,'Color',[1 .75 .0],'LineWidth',1)
            hold on
        end
    end
    xlim([0 .600])
    ylim([-125 55])
%     xlim([0 max(DetailedData.AxoClampData.Time.Data)])
%     [~, minr]=min(DetailedData.AxoClampData.Currents);
%     [~, maxr]=max(DetailedData.AxoClampData.Currents);
%     ylim([min(DetailedData.AxoClampData.Data(minr).RecordedVoltage) max(DetailedData.AxoClampData.Data(maxr).RecordedVoltage)])
    bx=xlim;
    by=ylim;
%     ylim([by(1)-7 by(2)]);
%     by=ylim;
    plot([bx(1) bx(1)+.1],[by(1) by(1)],'w','LineWidth',lwd);
    plot([bx(2) bx(2)],[by(2)-20 by(2)],'w','LineWidth',lwd);
%     %formatter(text(bx(1)+.01,by(1)+10,{'20 mV','  100 ms'}));
    formatter(gca,0)
    set(gca,'Position',[.1 .1 .8 .8])
    axis off
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
    printeps(hzr(2),[disspath 'CurrentSweepCCK']);
    else
    end
        hout(6)=hzr(2);
    end   
       
    b=strmatch('ivycell1858',{AllCells.CellName},'exact');
    % b=strmatch('ivycell_1350',{AllCells.CellName},'exact');
    if ~isempty(b)
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(b).DetailedData '.mat'],AllCells(b).DetailedData)
    eval(['DetailedData = ' AllCells(b).DetailedData ';']);
    try
    hzr(3)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Current Sweep Ivy','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    catch
    hzr(3)=figure('Renderer', 'painters','Color','w','Name','Current Sweep Ivy','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    end
%     pos=get(hzr(3),'Position');
%     set(hzr(3),'Position',[pos(1) pos(2) pos(3)*.6 pos(4)])
    for r=1:length(DetailedData.AxoClampData.Data)
        if DetailedData.AxoClampData.Currents(r)<0 ||DetailedData.AxoClampData.Currents(r) == max(DetailedData.AxoClampData.Currents)
            plot(DetailedData.AxoClampData.Time.Data,DetailedData.AxoClampData.Data(r).RecordedVoltage,'Color',[.6 .6 .6],'LineWidth',1)
            hold on
        end
    end
    xlim([0 .600])
    ylim([-125 55])
%     xlim([0 max(DetailedData.AxoClampData.Time.Data)])
%     [~, minr]=min(DetailedData.AxoClampData.Currents);
%     [~, maxr]=max(DetailedData.AxoClampData.Currents);
%     ylim([min(DetailedData.AxoClampData.Data(minr).RecordedVoltage) max(DetailedData.AxoClampData.Data(maxr).RecordedVoltage)])
    bx=xlim;
    by=ylim;
%     ylim([by(1)-7 by(2)]);
%     by=ylim;
    plot([bx(1) bx(1)+.1],[by(1) by(1)],'w','LineWidth',lwd);
    plot([bx(2) bx(2)],[by(2)-20 by(2)],'w','LineWidth',lwd);
    %formatter(text(bx(1)+.01,by(1)+10,{'20 mV','  100 ms'}));
    formatter(gca,0)
    set(gca,'Position',[.1 .1 .8 .8])
    axis off
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
    printeps(hzr(3),[disspath 'CurrentSweepIvy']);
    else
    end
        hout(7)=hzr(3);
    end   

    b=strmatch('olmcell1860',{AllCells.CellName},'exact');
    % b=strmatch('olmcell_1453',{AllCells.CellName},'exact');
    if ~isempty(b)
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(b).DetailedData '.mat'],AllCells(b).DetailedData)
    eval(['DetailedData = ' AllCells(b).DetailedData ';']);
    try
    hzr(4)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Current Sweep OLM','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    catch
    hzr(4)=figure('Renderer', 'painters','Color','w','Name','Current Sweep OLM','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    end
%     pos=get(hzr(4),'Position');
%     set(hzr(4),'Position',[pos(1) pos(2) pos(3)*.7 pos(4)])
    for r=1:length(DetailedData.AxoClampData.Data)
        if DetailedData.AxoClampData.Currents(r)<0 ||DetailedData.AxoClampData.Currents(r) == max(DetailedData.AxoClampData.Currents)
            plot(DetailedData.AxoClampData.Time.Data,DetailedData.AxoClampData.Data(r).RecordedVoltage,'Color',[.5 .0 .6],'LineWidth',1)
            hold on
        end
    end
    xlim([0 .600])
    ylim([-125 55])
%     xlim([0 max(DetailedData.AxoClampData.Time.Data)])
%     [~, minr]=min(DetailedData.AxoClampData.Currents);
%     [~, maxr]=max(DetailedData.AxoClampData.Currents);
%     ylim([min(DetailedData.AxoClampData.Data(minr).RecordedVoltage) max(DetailedData.AxoClampData.Data(maxr).RecordedVoltage)])
    bx=xlim;
    by=ylim;
%     ylim([by(1)-7 by(2)]);
%     by=ylim;
    plot([bx(1) bx(1)+.1],[by(1) by(1)],'w','LineWidth',lwd);
    plot([bx(2) bx(2)],[by(2)-20 by(2)],'w','LineWidth',lwd);
%     %formatter(text(bx(1)+.01,by(1)+10,{'20 mV','  100 ms'}));
    formatter(gca,0)
    set(gca,'Position',[.1 .1 .8 .8])
    axis off
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
    printeps(hzr(4),[disspath 'CurrentSweepOLM']);
    else
    end
        hout(8)=hzr(4);
    end   

    b=strmatch('ngfcell1859',{AllCells.CellName},'exact');
    % b=strmatch('ngfcell_1454',{AllCells.CellName},'exact');
    if ~isempty(b)
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(b).DetailedData '.mat'],AllCells(b).DetailedData)
    eval(['DetailedData = ' AllCells(b).DetailedData ';']);
    try
    hzr(4)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Current Sweep NGF','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    catch
    hzr(4)=figure('Renderer', 'painters','Color','w','Name','Current Sweep NGF','Units','inches','PaperUnits','inches','Position',[.5 .5 1.5 1.5],'PaperPosition',[0 0 1.5 1.5],'PaperSize',[1.5 1.5]);
    end
%     pos=get(hzr(4),'Position');
%     set(hzr(4),'Position',[pos(1) pos(2) pos(3)*.7 pos(4)])
    for r=1:length(DetailedData.AxoClampData.Data)
        if DetailedData.AxoClampData.Currents(r)<0 ||DetailedData.AxoClampData.Currents(r) == max(DetailedData.AxoClampData.Currents)
            plot(DetailedData.AxoClampData.Time.Data,DetailedData.AxoClampData.Data(r).RecordedVoltage,'Color',[1 .1 1],'LineWidth',1)
            hold on
        end
    end
    xlim([0 .600])
    ylim([-125 55])
    bx=xlim;
    by=ylim;
    plot([bx(2)-.1 bx(2)],[by(1) by(1)],'k','LineWidth',lwd);
    plot([bx(2) bx(2)],[by(1) by(1)+20],'k','LineWidth',lwd);
    plot([bx(1) bx(1)],[by(2)-20 by(2)],'w','LineWidth',lwd);
%     xlim([0 max(DetailedData.AxoClampData.Time.Data)])
%     [~, minr]=min(DetailedData.AxoClampData.Currents);
%     [~, maxr]=max(DetailedData.AxoClampData.Currents);
%     ylim([min(DetailedData.AxoClampData.Data(minr).RecordedVoltage) max(DetailedData.AxoClampData.Data(maxr).RecordedVoltage)])
%     bx=xlim;
%     by=ylim;
%     ylim([by(1)-7 by(2)]);
%     by=ylim;
%     plot([bx(1) bx(1)+.1],[by(1) by(1)],'k','LineWidth',lwd);
%     plot([bx(1) bx(1)],[by(1) by(1)+20],'k','LineWidth',lwd);
    %formatter(text(bx(1)+.01,by(1)+10,{'20 mV','  100 ms'}));
    formatter(gca,0)
    set(gca,'Position',[.1 .1 .8 .8])
    axis off
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
    printeps(hzr(4),[disspath 'CurrentSweepNGF']);
    else
    end
        hout(9)=hzr(4);
    end   
    
    try
    hz(3)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Firing Rates');
    catch
    hz(3)=figure('Renderer', 'painters','Color','w','Name','Firing Rates');
    end
   % cells2use={'pyramidalcell_1434','pvbasketcell_1345','cckcell_1348','scacell_1349','axoaxoniccell_1344','bistratifiedcell_1346','olmcell_1435','ivycell_1350','ngfcell_1342'};
    cells2use={'pyramidalcell_1803','pvbasketcell_1801','cckcell_1797','scacell_1802','axoaxoniccell_1795','bistratifiedcell_1796','olmcell_1800','ivycell_1798','ngfcell_1799'};
% pyramidalcell_1357
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
      nicenames={'Pyramidal','PV+ Basket','CCK+ Basket','S.C.-Assoc.','Axo-axonic','Bistratified','O-LM','Ivy','Neurogliaform'};
      b=[];
    for c=1:length(cells2use)
        try
        b(c)=strmatch(cells2use{c},{AllCells.CellName},'exact');
        catch ME
        b(c)=strmatch(strrep(cells2use{c},'_',''),{AllCells.CellName},'exact');
        end
        load([mypath sl 'data' sl 'DetailedData' sl AllCells(b(c)).DetailedData '.mat'],AllCells(b(c)).DetailedData)
        eval(['DetailedData(c).AxoClampData = ' AllCells(b(c)).DetailedData '.AxoClampData;']);
        eval(['DetailedData(c).SpikeData = ' AllCells(b(c)).DetailedData '.SpikeData;']);
        eval(['DetailedData(c).TableData = ' AllCells(b(c)).DetailedData '.TableData;']);
        pidx=find([DetailedData(c).AxoClampData.Currents]>=0);
        plot([DetailedData(c).AxoClampData.Currents(pidx)],[DetailedData(c).SpikeData(pidx).NumSpikes],'LineWidth',lwd,'Color',colorvec(c,:))
        hold on
    end
    formatter(xlabel('Current Injection (pA)'))
    formatter(ylabel('Firing Rate (Hz)'))
    formatter(legend(nicenames,'Location','BestOutside','EdgeColor',[1 1 1],'Color',[1 1 1]))
    legend boxoff
    box off
    formatter(gca)
    bf = findall(hz(3),'Type','text');
    for b=1:length(bf)
        set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
    printeps(hz(3),[disspath 'FiringRates']);
    close(hz(3));
    else
    end
        hout(10)=hz(3);
    
    try
    hz(4)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Ephys Props IR','Units','inches','PaperUnits','inches','PaperSize',[4 1],'Position',[.5 .5 4 1],'PaperPosition',[0 0 4 1]);
    catch
    hz(4)=figure('Renderer', 'painters','Color','w','Name','Ephys Props IR','Units','inches','PaperUnits','inches','PaperSize',[4 1],'Position',[.5 .5 4 1],'PaperPosition',[0 0 4 1]);
    end
    gidx=strmatch('Input Resistance #1',{DetailedData(2).TableData(:).Name},'exact');
    brr=axes('Position',[0.1505    0.1800    0.8245    0.78]);%subplot(3,1,1);
    H = arrayfun(@(x) x.TableData(gidx).Mean, DetailedData);
    H(1)= DetailedData(1).TableData(gidx).Mean;
    N = numel(H);
    for i=1:N
      h = bar(i, H(i));
      if i == 1, hold on, end
      set(h, 'FaceColor', colorvec(i,:),'EdgeColor',[1 1 1]) 
    end   
% z = strmatch(ctype,celltypeKey);
% celltypeNice{z}
    set(gca, 'XTickLabel', {})  
    ypos = min(get(brr,'ylim'))-diff(get(brr,'ylim'))/10;% -max(ylim)/10;
    text(1:N,repmat(ypos,N,1),celltypeNice','horizontalalignment','Center','FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName);
    formatter(gca)
    box off
    formatter(ylabel({'Input Resist.','(M\Omega)'},'Interpreter','Tex'))
    xlim([0.5 N+.5])
%     mypos=get(gca,'Position');
%     axes('Position',[0.1505    0.1100    0.8245    0.8545])
    
try
    hz(5)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Ephys Props Tau','Units','inches','PaperUnits','inches','PaperSize',[4 1],'Position',[.5 .5 4 1],'PaperPosition',[0 0 4 1]);
    catch
    hz(5)=figure('Renderer', 'painters','Color','w','Name','Ephys Props Tau','Units','inches','PaperUnits','inches','PaperSize',[4 1],'Position',[.5 .5 4 1],'PaperPosition',[0 0 4 1]);
    end
    gidx=strmatch('Membrane Tau',{DetailedData(2).TableData(:).Name},'exact');
    brr=axes('Position',[0.1505    0.1800    0.8245    0.78]);%subplot(3,1,2);
    H = arrayfun(@(x) x.TableData(gidx).Mean, DetailedData);
    H(1)= DetailedData(1).TableData(gidx).Mean;
    N = numel(H);
    for i=1:N
      h = bar(i, H(i));
      if i == 1, hold on, end
      set(h, 'FaceColor', colorvec(i,:),'EdgeColor',[1 1 1]) 
    end   
    set(gca, 'XTickLabel', {})  
    ypos = min(get(brr,'ylim'))-diff(get(brr,'ylim'))/10;% -max(ylim)/10;
    text(1:N,repmat(ypos,N,1),celltypeNice','horizontalalignment','Center','FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName);
    formatter(gca)
    box off
    formatter(ylabel({'Membrane','Tau (ms)'}))
    xlim([0.5 N+.5])
    mypos=get(gca,'Position');
    set(gca,'Position',[0.1505    mypos(2)    0.8245    mypos(4)])

    try
    hz(6)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Ephys Props Thresh','Units','inches','PaperUnits','inches','PaperSize',[4 1],'Position',[.5 .5 4 1],'PaperPosition',[0 0 4 1]);
    catch
    hz(6)=figure('Renderer', 'painters','Color','w','Name','Ephys Props Thresh','Units','inches','PaperUnits','inches','PaperSize',[4 1],'Position',[.5 .5 4 1],'PaperPosition',[0 0 4 1]);
    end
    gidx=strmatch('Threshold',{DetailedData(2).TableData(:).Name},'exact');
    brr=axes('Position',[0.1505    0.1800    0.8245    0.78]);%subplot(3,1,3);
    H = arrayfun(@(x) x.TableData(gidx).Mean, DetailedData)+100;
    %H(1)= DetailedData(1).TableData(22).Mean+100;
    N = numel(H);
    for i=1:N
      h = bar(i, H(i));
      if i == 1, hold on, end
      set(h, 'FaceColor', colorvec(i,:),'EdgeColor',[1 1 1]) 
    end   
    set(brr, 'XTickLabel', {})  
    formatter(gca)
    box off
    formatter(ylabel({'Threshold','(mV)'}))
    ylim([40 80])
    set(gca,'ytick',[40 60 80],'yticklabel',{'-60','-40','-20'})
    ypos = min(get(brr,'ylim'))-diff(get(brr,'ylim'))/10;% -max(ylim)/10;
    text(1:N,repmat(ypos,N,1),celltypeNice','horizontalalignment','Center','FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName);
    mypos=get(gca,'Position');
    set(gca,'Position',[0.1505    mypos(2)    0.8245    mypos(4)])
    xlim([0.5 N+.5])

    for myz=4:6
        bf = findall(hz(myz),'Type','text');
        for b=1:length(bf)
            set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
        end
        if ~isempty(varargin) && varargin{1}>735749 %&& printflag
            printeps(hz(myz),[disspath strrep(get(hz(myz),'Name'),' ','')]);
        else
        end
        hout(end+1)=hz(myz);
    end
try
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
    q=find([myrepos.current]==1);

    %make_syn_website([myrepos(q).dir sl 'cellclamp_results'],{'1313'}); %[repospath]);
end
    load([repospath sl 'cellclamp_results' sl 'website' sl 'traces.mat'],'alltraces')
    
    try
    hz(7)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','In Synapses','Units','inches','PaperUnits','inches','Position',[.5 .5 2 1.5],'PaperPosition',[0 0 2 1.5]);
    catch
    hz(7)=figure('Renderer', 'painters','Color','w','Name','In Synapses','Units','inches','PaperUnits','inches','Position',[.5 .5 2 1.5],'PaperPosition',[0 0 2 1.5]);
    end
    for c=1:length(cells2use)
        pretype=cells2use{c};
        st=strfind(pretype,'_');
        pretype=pretype(1:st-1);
        if isfield(alltraces.(pretype),'pyramidalcell')
            plot(alltraces.(pretype).pyramidalcell.Time-14,alltraces.(pretype).pyramidalcell.Trace,'Color',colorvec(c,:),'LineWidth',lwd)
            hold on
        end
    end
    xlim([100 150-14])
    %xlim([0 60])
    formatter(gca)
    formatter(xlabel('Time (ms)'))
    formatter(ylabel('Current (nA)'))
    title('Interneuron -> Pyramidal Cell')
    box off
    bf = findall(hz(7),'Type','text');
    for b=1:length(bf)
        set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
    if ~isempty(varargin) && varargin{1}>735749 % && printflag
    printeps(hz(7),[disspath 'InSyns']);
    else
    end
        hout(end+1)=hz(7);
    
    try
    hz(8)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','Out Synapses','Units','inches','PaperUnits','inches','Position',[.5 .5 2 1.5],'PaperPosition',[0 0 2 1.5]);
    catch
    hz(8)=figure('Renderer', 'painters','Color','w','Name','Out Synapses','Units','inches','PaperUnits','inches','Position',[.5 .5 2 1.5],'PaperPosition',[0 0 2 1.5]);
    end
    for c=1:length(cells2use)
        posttype=cells2use{c};
        st=strfind(posttype,'_');
        posttype=posttype(1:st-1);
        if isfield(alltraces.pyramidalcell, posttype)
            plot(alltraces.pyramidalcell.(posttype).Time-14.5,alltraces.pyramidalcell.(posttype).Trace,'Color',colorvec(c,:),'LineWidth',lwd)
        end
        hold on
    end
    xlim([100 130-14.5]);ylim([-.08 .01])
    %xlim([0 60])
    formatter(gca)
    formatter(xlabel('Time (ms)'))
    formatter(ylabel('Current (nA)'))
    title('Pyramidal Cell -> Interneuron')
    box off
    bf = findall(hz(8),'Type','text');
    for b=1:length(bf)
        set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
    if ~isempty(varargin) && varargin{1}>735749 %&& printflag
    printeps(hz(8),[disspath 'OutSyns']);
    end
    hout(end+1)=hz(8);
    
    chandens=[];
    colorvec={'b','c','m','g','r','k'};
    if exist('channelimage.mat','file')
        load('channelimage.mat','chandens');
    end
    if isempty(chandens) && exist([myrepos(q).dir sl 'cellclamp_results' sl '1341' sl 'celldata_pyramidalcell.dat'],'file')
        bb=1;
        t=importdata([myrepos(q).dir sl 'cellclamp_results' sl '1341' sl 'celldata_pyramidalcell.dat']);
    
    
    b=strfind(t.textdata(:,1),'axon');
    for r=length(b):-1:1
        if ~isempty(b{r})
            t.textdata(r,:)=[];
            t.data(r-1,:)=[];
        end
    end
    
    bidx=find(t.data(:,2)<0); % apical, sideways cell means check x column (2) not y column (3)
    t.data(bidx,5)=-t.data(bidx,5);
    chandens.pos = unique(t.data(:,5));
    for r=1:size(t.data,2)
        if sum(t.data(:,r))>0 && length(t.textdata{1,r+1})>4 && strcmp('gmax',t.textdata{1,r+1}(1:4))==1
            chan = t.textdata{1,r+1}(9:end);
            for f=1:length(chandens.pos)
                fidx = find(chandens.pos(f)==t.data(:,5));
                chandens.(chan).gmax(f) = mean(t.data(fidx,r));
            end
        figure;plot(chandens.pos(chandens.(chan).gmax>0),chandens.(chan).gmax(chandens.(chan).gmax>0));title(chan)
        drawnow;
        chandens.(chan).mymarks = ginput();
        chandens.(chan).mymarks([1 end],2)=0;
        patch(chandens.(chan).mymarks(:,1),chandens.(chan).mymarks(:,2),colorvec{bb},'EdgeColor',[1 1 1])
        bb=bb+1;
        end
    end  
        save('channelimage.mat','chandens','-v7.3');
    end
    
    hz(7)=figure('Color','w','Name','Ion Channels','Units','inches','PaperUnits','inches','Position',[.5 .5 2 2],'PaperPosition',[0 0 2 2],'PaperSize',[2 2]);
    myfields=fieldnames(chandens);
    startpt=0;
    for m=2:length(myfields)
        chan=myfields{m};
        patch(chandens.(chan).mymarks(:,1),chandens.(chan).mymarks(:,2)+startpt,colorvec{m-1},'EdgeColor',[1 1 1])
        startpt = startpt+max(chandens.(chan).mymarks(:,2))+.01;
    end
    xlim([-200 600]);
    hold on
    plot([-200 -200],[0 .01],'k','LineWidth',2)
    plot([-200 -100],[0 0],'k','LineWidth',2)
    %formatter(text(-195,0.01,'.01 \mu F/cm^2'))
    pos=get(gcf,'Position');
    %set(gcf,'Position',[pos(1) pos(2) pos(3)*2 pos(4)])
    %legend(myfields(2:end),'Location','BestOutside','EdgeColor','w','Color',[1 1 1])
    axis off
    mytextpos=[];
    if exist('channelimage.mat','file')
        load('channelimage.mat','mytextpos');
    end
    if isempty(mytextpos)
        drawnow;
        mytextpos=ginput(5);
        save('channelimage.mat','mytextpos','-append');
    end
    chanarray={'HCNp','Kdrp','KvAdistp','KvAproxp','Navp'};
    nicechan={'HCN','K_{dr}','K_{v,A,dist.}','K_{v,A,prox.}','Na_{v}'};
    for g=1:length(mytextpos)
        chan=myfields{g+1};
        chani=strmatch(chan,chanarray,'exact');
        if isempty(chani)
            chanstr=chan;
        else
            chanstr=nicechan{chani};
        end
        text(mytextpos(1,1),mytextpos(g,2),chanstr,'Color',colorvec{g},'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName);
    end
    if ~isempty(varargin) && varargin{1}>735749 && printflag
    printeps(hz(7),[disspath 'NewIonChans']);
    else
        hout(end+1)=hz(7);
    end

if printtable
fid=fopen([disspath '..' sl 'Tables' sl 'Table_Ephys.tex'],'w');
fprintf(fid,'\\begin{landscape}\n');
fprintf(fid,'\\begin{table}[position htb]\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{|lrrrrrrrrr|} \n');
fprintf(fid,'\\hline\n');
fprintf(fid,'\\textbf{Condition} & \\textbf{%s} &\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} &\\textbf{%s} & \\textbf{%s} & \\textbf{%s}  & \\textbf{%s}\\\\ \n', celltypeNice{:});
fprintf(fid,'\\hline\n');
lookup={'RMP','Input Resistance #1','Membrane Tau','Rheobase','Threshold','Delay to 1st Spike','Half-Width'};%,'Fast AHP Amplitude','Sag Amplitude'};
ephys={'Resting Membrane Potential (mV)','Input Resistance (M$\Omega$)','Membrane Tau (ms)','Rheobase (pA)','Threshold (mV)','Delay to 1st Spike (ms)','Half-Width (ms)'};%,'Fast AHP Amplitude (mV)','Sag Amplitude (mV)'};
for ee=1:length(ephys)
    gidx=strmatch(lookup{ee},{DetailedData(2).TableData(:).Name},'exact');
    fprintf(fid,'%s & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f \\\\ \n', ephys{ee}, arrayfun(@(x) x.TableData(gidx).Mean, DetailedData)); 
    fprintf(fid,'\\hline\n');
end
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\caption[Model Electrophysiology]{\internallinenumbers Electrophysiological characteristics of \\textcolor{blue}{each model cell type}. For more information about model electrophysiology, see the Supplementary Material.}\n');
fprintf(fid,'\\label{tab:ephys}\n');
fprintf(fid,'\\end{table}\n');
fprintf(fid,'\\end{landscape}\n');
fclose(fid);
end

% fid=fopen([disspath '..' sl 'Tables' sl 'Table_CurrentSweeps.tex'],'w');
% fprintf(fid,'\\begin{table}[position htb]\n');
% fprintf(fid,'\\centering\n');
% fprintf(fid,'\\begin{tabular}{|lrrr|} \n');
% fprintf(fid,'\\hline\n');
% fprintf(fid,'\\textbf{Cell Type} & \\textbf{Hyper. (pA)} &\\textbf{Step Size (pA)} & \\textbf{Depol. (pA)} \\\\ \n');
% fprintf(fid,'\\hline\n');
% ephys={'PV+ B.','CCK+ B.','O-LM','NGF'};
% for ee=1:length(ephys)
%     fprintf(fid,'%s & %.1f & %.1f & %.1f  \\\\ \n', ephys{ee}, 0, 0, 0); 
%     fprintf(fid,'\\hline\n');
% end
% fprintf(fid,'\\end{tabular}\n');
% fprintf(fid,'\\caption[Current Injection Sweeps]{Current injection levels used to characterize interneuron current sweeps in Figure \ref{fig:ephys:sweepPVBC}-\ref{fig:ephys:sweepNGF}.}\n');
% fprintf(fid,'\\label{tab:currentsweeps}\n');
% fprintf(fid,'\\end{table}\n');
% fclose(fid);

if nargout>0
    varargout{1}=hout;
end

    
function formatter(ax,varargin)
global mypath myFontSize
if isempty(varargin)
    set(ax,'LineWidth',1.0,'FontName','ArialMT','FontWeight','normal','FontSize',myFontSize)  
elseif varargin{1}==0
    set(ax,'FontName','ArialMT','FontWeight','normal','FontSize',myFontSize)  
else
    set(ax,'FontName','ArialMT','FontWeight','normal','FontSize',myFontSize)  
end
box off
