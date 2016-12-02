function print_channels(pathway,allchannels,allephys,alltraces,allchans,expephys)

if ispc
sl = '\';
else
    sl='/';
end

allchantypes = sort(fieldnames(allchannels));

skipme = 20;

fcells = fopen([pathway sl 'channels' sl 'allchans.txt'],'w');

for x=1:length(allchantypes)
    fprintf(fcells,'%s,%d,%d,%d,%d,%s,%d\n',allchantypes{x},allchannels.(allchantypes{x}).Ind,allchannels.(allchantypes{x}).Ind,allchannels.(allchantypes{x}).Ind,allchannels.(allchantypes{x}).Ind,allchannels.(allchantypes{x}).Description,allchannels.(allchantypes{x}).Ind)
end
fclose(fcells);

for a=1:length(allchantypes)
    chantype = allchantypes{a};
    if exist([pathway sl 'channels' sl chantype],'dir')==0
        mkdir([pathway sl 'channels' sl chantype])
    else
        system(['rm ' pathway sl 'channels' sl chantype sl '*'])
    end

    ephys = allephys.(chantype);

    %%% Ephys Table:
    ephysfile=sprintf('channels%s%s%sephystable.txt', sl, chantype, sl);
    fephys = fopen([pathway sl ephysfile],'w');

    for x=1:length(ephys)
        fprintf(fephys,'%s,%0.2f,%s,%s\n',ephys(x).Prop,ephys(x).Value,ephys(x).Units,ephys(x).Desc)
    end
    fclose(fephys);
    
    %%% Ephys Setup Table:    
    expset = expephys.(chantype);
    ephysfile=sprintf('channels%s%s%ssetuptable.txt', sl, chantype, sl);
    fephys = fopen([pathway sl ephysfile],'w');

    for x=1:length(expset)
        fprintf(fephys,'%s,%f,%s,%s\n',expset(x).Prop,expset(x).Value,expset(x).Units,expset(x).Desc)
    end
    fclose(fephys);
    
    

    %%% Cells Table:
    ephysfile=sprintf('channels%s%s%scelltable2.txt',sl, chantype, sl);
    fephys = fopen([pathway sl ephysfile],'w');

    cellfields = fieldnames(allchans);
    for y=1:length(cellfields)
        chanfields = fieldnames(allchans.(cellfields{y}));
        mych = strmatch(chantype,chanfields,'exact');
        if ~isempty(mych)
            fprintf(fephys,'%s,%0.0f,%.2e,%s\n',cellfields{y},allchans.(cellfields{y}).(chanfields{mych}).Erev,allchans.(cellfields{y}).(chanfields{mych}).Gmax,allchans.(cellfields{y}).(chanfields{mych}).Loc);
        end
    end
    fclose(fephys);

    %%% Ephys Figure:
    %///////////
    tracefile=sprintf('channels%s%s%sActInact_Curve.txt',sl, chantype, sl);
    ftrace = fopen([pathway sl tracefile],'w');
    traces = alltraces.(chantype);
    tracefields = fieldnames(traces);

    for c=1:2 % Activation, Inactivation
        xstring = sprintf('%0.5f,',traces.(tracefields{c}).Voltage); % concatenate times together, separated by commas
        ystring = sprintf('%0.5f,',traces.(tracefields{c}).Response); % concatenate PSP values together, separated by commas
        fprintf(ftrace,'%s,%s\n',tracefields{c},xstring(1:end-1))
        fprintf(ftrace,'%s,%s\n',traces.(tracefields{c}).Label,ystring(1:end-1))
    end

    fclose(ftrace);
    
    tracefile=sprintf('channels%s%s%sIV_Curve.txt', sl, chantype, sl);
    ftrace = fopen([pathway sl tracefile],'w');
    traces = alltraces.(chantype);
    tracefields = fieldnames(traces);

    for c=3:4 % IV Curve
        xstring = sprintf('%0.5f,',traces.(tracefields{c}).Voltage); % concatenate times together, separated by commas
        ystring = sprintf('%0.5f,',traces.(tracefields{c}).Response); % concatenate PSP values together, separated by commas
        fprintf(ftrace,'%s,%s\n',tracefields{c},xstring(1:end-1))
        fprintf(ftrace,'%s,%s\n',traces.(tracefields{c}).Label,ystring(1:end-1))
    end

    fclose(ftrace);
    
    hgg = figure('Color','w');
    plot(traces.(tracefields{3}).Voltage,traces.(tracefields{3}).Response,'k','LineWidth',4);
    
    box off
    bb = get(gca,'XTick');
    
    idxe=find(bb==0);
    
    if idxe>1 && idxe<length(bb)
        set(gca,'XTick',bb([1 idxe end]))
    else
        set(gca,'XTick',bb([1 end]))
    end
    
    bb = get(gca,'YTick');
    idxe=find(bb==0);
    if isempty(idxe)==0 && idxe>1 && idxe<length(bb)
        set(gca,'YTick',bb([1 idxe end]))
    else
        set(gca,'YTick',bb([1 end]))
    end
    set(gca,'LineWidth',3,'TickDir','out')    
    set(gca,'FontSize',36,'FontWeight','bold')
    p = get(gca,'Position');
    set(gca,'Position',[p(1)+.075 p(2)+.075 p(3)-.15 p(4)-.15])
    
    imgfile=sprintf('channels%s%s%sivcurve.png', sl, chantype, sl);
    if exist([pathway sl 'channels' sl chantype],'dir')==0
        mkdir([pathway sl 'channels' sl chantype])
    end
    
    print(gcf, '-dpng', [pathway sl imgfile]);
    close(hgg)
    
    % IV curve
    %  cell types found in ...
end