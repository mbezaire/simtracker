function h=PhaseShift_Figure(cells,Hz,a1,varargin)

NiceAbbrev = {'Pyr.','O-LM','Bis.','Axo.','PV+ B.','CCK+ B.','S.C.-A.','Ivy','NGF.'};

% load exp data, only use a subset of it
if Hz<20
    nrninput = gettheta(-1);
else
    nrninput = getgamma(-1);
end

period = 125;
Hzval = 8;
trace.data=0:.025:(period*2);
trace.data=trace.data';

excell = -sin((Hzval*(2*pi))*trace.data(:,1)/1000 + pi/2);  % -13.8/125);  %  - handles.phasepref +   -  (0.25)*Hzval*2*pi

if isempty(a1)
if Hz<20
    h=figure('Color','w','Units','inches','Name','Theta LFP','PaperUnits','inches','PaperPosition',[0 0 9 7]); % ,'FontName','Verdana','FontWeight','Bold','FontSize',16
else
    h=figure('Color','w','Units','inches','Name','Gamma LFP','PaperUnits','inches','PaperPosition',[0 0 9 7]); % ,'FontName','Verdana','FontWeight','Bold','FontSize',16
end
pos = get(h,'Position');
set(h,'Position',[.7 .7 9 7]);
set(h,'Units','Normalized');

a1=gca;
myflag=0;
else
    axes(a1);
    h=get(a1,'Parent');
    myflag=1;
end

%plotstuff(a1,trace.data,excell,Hz);
matchnames.tech = {'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'};
matchnames.nice = {'Pyramidal','PV+ Basket','CCK+ Basket','S.C.-Assoc.','Axo-axonic','Bistratified','O-LM','Ivy','Neurogliaform'};
    
for n=1:length(cells)
    try
    cells(n).start = cells(n).phase/360*period;
    cells(n).tidx(1)=find(trace.data>=cells(n).start,1,'first');
    cells(n).tidx(2)=find(trace.data>=cells(n).start+period,1,'first');
    catch
        n
    end

    x = trace.data(cells(n).tidx);
    y = excell(cells(n).tidx);
    
    midx = strmatch(matchnames.nice{strmatch(cells(n).name,matchnames.tech)},{nrninput(:).name});
    
    if ~isempty(midx) & (mod(180+cells(n).phase-nrninput(midx).phase,360)-180)~=0
        axes(a1)
        hold on
        if cells(n).phase<nrninput(midx).phase
            if nrninput(midx).phase-cells(n).phase<180
                arrowDir(n)=1;
                stIDX(n)=find(trace.data>=cells(n).phase/360*period,1,'first');
                enIDX(n)=find(trace.data>=nrninput(midx).phase/360*period,1,'first');
            else
                arrowDir(n)=-1;
                stIDX(n)=find(trace.data>=nrninput(midx).phase/360*period,1,'first');
                enIDX(n)=find(trace.data>=cells(n).phase/360*period+period,1,'first');
            end
        else
            if cells(n).phase-nrninput(midx).phase<180
                arrowDir(n)=-1;
                stIDX(n)=find(trace.data>=nrninput(midx).phase/360*period,1,'first');
                enIDX(n)=find(trace.data>=cells(n).phase/360*period,1,'first');
           else
                arrowDir(n)=1;
                stIDX(n)=find(trace.data>=cells(n).phase/360*period,1,'first');
                enIDX(n)=find(trace.data>=nrninput(midx).phase/360*period+period,1,'first');
            end
        end
        distIDX(n)=enIDX(n)-stIDX(n);
    else
        distIDX(n)=0;
        stIDX(n)=find(trace.data>=cells(n).phase/360*period,1,'first');
        enIDX(n)=find(trace.data>=cells(n).phase/360*period,1,'first');
    end
end

pt=max(trace.data);
distlist=[ ... 
         0 ...
    0.1250 ...
    0.2500 ...
    0.3750 ...
    0.5000 ...
    0.6250 ...
    0.7500 ...
    0.8750 ...
    1.0000 ...
    1.1250 ...
    1.2500 ...
    1.3750 ...
    1.5000 ...
    1.6250 ...
    1.7500 ...
    1.8750 ...
    2.0000]*125-7.8125;


mrklistEN={'>','v','<','v','>','^','<','^','>','v','<','v','>','^','<','^','>'};
mrklistST={'<','^','>','^','<','v','>','v','<','^','>','^','<','v','>','v','<'};


[~, sortI] = sort(distIDX);
spacing=.8;
for ntmp=1:length(distIDX)
    n = sortI(ntmp);
    mypos=strmatch(cells(n).name,matchnames.tech); 
    excellTMP=excell-spacing*(mypos-1);
    colvec = cells(n).color;
    plot(trace.data,excellTMP,'LineWidth',2,'Marker','none','Color',colvec);
    hold on

    n = sortI(ntmp);
    midx = strmatch(matchnames.nice{strmatch(cells(n).name,matchnames.tech)},{nrninput(:).name});
    if isempty(midx) || abs(mod(180+cells(n).phase-nrninput(midx).phase,360)-180)<.5
        mylabel = [matchnames.nice{strmatch(cells(n).name,matchnames.tech)}];
    elseif (mod(180+cells(n).phase-nrninput(midx).phase,360)-180)>0
        mylabel = [matchnames.nice{strmatch(cells(n).name,matchnames.tech)} ' (+' deblank([num2str(round(mod(180+cells(n).phase-nrninput(midx).phase,360)-180)) ')']) ];
    else
        mylabel = [matchnames.nice{strmatch(cells(n).name,matchnames.tech)} ' (' deblank([num2str(round(mod(180+cells(n).phase-nrninput(midx).phase,360)-180)) ')']) ];
    end
    gk=text(-3,min(excellTMP)+.2,mylabel);
    set(gk,'Color',colvec,'HorizontalAlignment','right','FontName','ArialMT','FontWeight','Bold','FontSize',14);
    
    colvec = 'k'; %cells(n).color;
    if distIDX(n)==0
        plot(trace.data(enIDX(n)),excellTMP(enIDX(n)),'Marker','o','MarkerEdgeColor',colvec,'MarkerFaceColor',colvec,'MarkerSize',10);
        continue;
    end
    plot(trace.data(stIDX(n):enIDX(n)),excellTMP(stIDX(n):enIDX(n)),'LineWidth',4,'Marker','none','Color',colvec);
    if arrowDir(n)==1
        lidx=find(distlist<=trace.data(enIDX(n)),1,'last');
        mrkstr=mrklistEN{lidx};
        plot(trace.data(enIDX(n)),excellTMP(enIDX(n)),'Marker',mrkstr,'MarkerEdgeColor',colvec,'MarkerFaceColor',colvec,'MarkerSize',10);
    else
        lidx=find(distlist<=trace.data(stIDX(n)),1,'last');
        mrkstr=mrklistST{lidx};
        plot(trace.data(stIDX(n)),excellTMP(stIDX(n)),'Marker',mrkstr,'MarkerEdgeColor',colvec,'MarkerFaceColor',colvec,'MarkerSize',10);
    end
end

axes(a1)
pp=get(gca,'Position')
set(gca,'Position',[.98-pp(3)*.9 pp(2) pp(3)*.9 pp(4)])
ylim([-1.1-spacing*(length(distIDX)-1) 1.1])
xlim([0 max(trace.data)])
%axis off
set(gca,'XTickLabel',{})
set(gca,'YTickLabel',{})
set(gca,'XColor','w')
set(gca,'YColor','w')



