function makecellpdf(AllCells,handles,pdfpath,Props2Plot,Props2List,mycells)
global mypath DetailedData sl myFontName myFontWeight myFontSize

printtables=0;
printfigures=0;
printlatex=1;

cellabbrord={'pyr','axo','bis','cck','ivy','ngf','olm','pvb','sca'};

            colorstruct.pyramidal.color=[.0 .0 .6];
            colorstruct.pvbasket.color=[.0 .75 .65];
            colorstruct.cck.color=[1 .75 .0];
            colorstruct.sca.color=[1 .5 .3];
            colorstruct.axoaxonic.color=[1 .0 .0];
            colorstruct.bistratified.color=[.6 .4 .1];
            colorstruct.olm.color=[.5 .0 .6];
            colorstruct.ivy.color=[.6 .6 .6];
            colorstruct.ngf.color=[1 .1 1];
            colorstruct.ca3.color=[.6 .6 1];
            colorstruct.ec.color=[.3 .3 .3];
            
            colorstruct.pyramidal.pos=1;
            colorstruct.pvbasket.pos=2;
            colorstruct.cck.pos=3;
            colorstruct.sca.pos=4;
            colorstruct.axoaxonic.pos=5;
            colorstruct.bistratified.pos=6;
            colorstruct.olm.pos=7;
            colorstruct.ivy.pos=8;
            colorstruct.ngf.pos=9;
                        
            showgraphs.pyramidalcell.best2show=14;
            showgraphs.pvbasketcell.best2show=6;
            showgraphs.cckcell.best2show=1;
            showgraphs.scacell.best2show=2;
            showgraphs.axoaxoniccell.best2show=2;
            showgraphs.bistratifiedcell.best2show=2;
            showgraphs.olmcell.best2show=2;
            showgraphs.ivycell.best2show=2;
            showgraphs.ngfcell.best2show=4;

colorcycle=[0 0 0; .7 0 0;
    0 .5 0;
    .5 0 .8;
    .6 .6 .1;
    .7 .3 0;
    0 1 0;
    0 0 .6;
    1 0 0;
    .3 .3 .3;
    .3 0 .7;
    0 .5 .5;
    .2 .2 .8;
    .1  .7 .2;];
            
myFontSize=8;
myFontWeight='normal';
myFontName = 'Arial';

celltypeFullNice={'Pyramidal','PV+ Basket','CCK+ Basket','Schaffer Collateral-Associated','Axo-axonic','Bistratified','O-LM','Ivy','Neurogliaform','Proximal Afferent','Distal Afferent'};

celltypeNice={'Pyr','PV+B','CCK+B','SC-A','Axo','Bis','O-LM','Ivy','NGF','CA3','ECIII'};
findNiceidx={'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','ca3cell','eccell'};
celldesc={'Principal Cell','Fast-Spiking Somatic Inhibitor','Regular-Spiking Somatic Inhibitor','Regular-Spiking Dendritic Inhibitor','Fast-Spiking Axonic Inhibitor','Fast-Spiking Dendritic Inhibitor','Feed Back Cell','Late-spiking Cell','Late-spiking Feed Forward Cell','Proximal stimulating cell','Distal stimulating cell'};

if ispc
    sl='\';
else
    sl='/';
end

if printfigures
fired.h=figure('Name','Firing Rates','Color','w','Units','inches','PaperUnits','inches','PaperSize',[3 3],'PaperPosition',[0 0 3 3],'Position',[.5 .5 3 3]);
fired.leg=[];
fired.legstr={};

expfired.h=figure('Name','ExpFiringRates','Color','w','Units','inches','PaperUnits','inches','PaperSize',[5 3.5],'PaperPosition',[0 0 5 3.5],'Position',[.5 .5 5 3.5]);
expfired.leg=[];
expfired.legstr={};
end

if printtables
    fprop=fopen([pdfpath sl  'backup' 'ExpEphsPropTable.tex'],'w');
    
    fprintf(fprop,'\\begin{sidewaystable}[position htb]\n');
    fprintf(fprop,'\\begin{footnotesize}\n');
    fprintf(fprop,'\\begin{tabular}{|lr%s|}\n',repmat('r',1,length(Props2List)));
    fprintf(fprop,'\\hline\n\\textbf{Cell Type} & \\textbf{n}');
end
if printfigures
    for p=1:length(Props2List)
        if printtables
            fprintf(fprop,' & \\textbf{%s} ',Props2List{p});
        end
        propfig(p)=figure('Name',['ExpComp' Props2List{p}],'Color','w','Units','inches','PaperUnits','inches','PaperSize',[6 2],'PaperPosition',[0 0 6 2],'Position',[.5 .5 6 2]);
    end
end    

for h=1:length(handles.indices)
    
    celltype = strrep(AllCells(handles.indices(h)).CellType,'_model','cell'); %AllCells(handles.indices(h)).CellType
    cellabbr=celltype(1:3);
    
    best2show = showgraphs.(celltype).best2show;

 if printtables || printfigures
   load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.indices(h)).DetailedData '.mat']);
    eval(['DetailedData = ' AllCells(handles.indices(h)).DetailedData ';']);

    firetype.h=figure('Name',[cellabbr 'FiringRate'],'Color','w','Units','inches','PaperUnits','inches','PaperSize',[4 2],'PaperPosition',[0 0 4 2],'Position',[.5 .5 4 2]);
    firetype.leg=[];
    firetype.legstr={};
    
    exptype = strrep(AllCells(handles.indices(h)).CellType,'_model','');
    othercellsidx = strmatch(exptype,{AllCells(:).CellType},'exact'); % find all the indices with the exptype cell type
    
    for k=length(othercellsidx):-1:1
        if ~isempty(strfind(AllCells(othercellsidx(k)).Notes,'baseline'))
            othercellsidx(k)=[];
        end
    end
    TmpN=length(othercellsidx);
    
    if printtables
    fid=fopen([pdfpath sl celltype 'Table.tex'],'w');
    

    fprintf(fprop,'\\\\\n%s & %d', celltypeNice{strmatch(celltype,findNiceidx)},TmpN);

    
    %fprintf(fid,'\\begin{table}[position htb]\n');
    fprintf(fid,'\\begin{footnotesize}\n');
    fprintf(fid,'\\begin{tabular}{|lrr|}\n');
    %fprintf(fid,'\\begin{tabular}{|lrrr|}\n');
    
    fprintf(fid,'\\hline\n');
%     fprintf(fid,'\\textbf{%s} & \\textbf{%s} & & \\textbf{%s} \\\\ \n','','','Comp.');
%     fprintf(fid,'\\textbf{%s} & \\textbf{%s} & & \\textbf{(n=%d)} \\\\ \n','Property','Value',length(othercellsidx));

 fprintf(fid,'\\textbf{%s} & \\textbf{%s} &  \\\\ \n','Property','Value');
    fprintf(fid,'\\hline\n');
    end
    
    if printtables || printfigures
    pf=1;
    if isfield(DetailedData,'TableData') && ~isempty(DetailedData.TableData)
        for p=1:length(DetailedData.TableData)
            if strmatch(DetailedData.TableData(p).Name,Props2List,'exact')
                myvals = [];
                for z=1:length(othercellsidx)
                    load([mypath sl 'data' sl 'DetailedData' sl AllCells(othercellsidx(z)).DetailedData '.mat']);
                    eval(['otraDetailedData = ' AllCells(othercellsidx(z)).DetailedData ';']);
                    
                    try
                        myvals(z) = otraDetailedData.TableData(p).Mean;
                    catch
                        myvals(z) = NaN;
                    end
                end
                mdx=strmatch(celltype,findNiceidx);
                figure(propfig(pf))
                UnitNice{pf}=DetailedData.TableData(p).Units;
                if ~isempty(myvals) && sum(isnan(myvals))<length(myvals)
                    TmpMean = mean(myvals(~isnan(myvals)));
                    TmpStd = std(myvals(~isnan(myvals)));
                    %TmpN = length(myvals);
                    TmpDiff = 100*(DetailedData.TableData(p).Mean - TmpMean)/TmpMean;
                    % prin ino a cell of a row of able abou exp cell of his
                    % pe
                    if TmpN>1
                        fprintf(fprop,' & %.1f $\\pm$ %.1f ',TmpMean,TmpStd);
                        errorbar(mdx,TmpMean,TmpStd,'Color',colorstruct.(AllCells(othercellsidx(z)).CellType).color,'Marker','.','MarkerSize',10,'LineWidth',1.5)
                    else
                        fprintf(fprop,' & %.1f ',TmpMean);
                        plot(mdx,TmpMean,'Color',colorstruct.(AllCells(othercellsidx(z)).CellType).color,'Marker','.','MarkerSize',10,'LineWidth',1.5)
                    end
                else
                    TmpMean = NaN;
                    TmpStd = NaN;
                    TmpDiff = NaN;
                    fprintf(fprop,' &  ');
                end
                pf=pf+1;
                hold on
                plot(mdx,DetailedData.TableData(p).Mean,'Color',colorstruct.(AllCells(othercellsidx(z)).CellType).color,'Marker','o','MarkerSize',8,'LineWidth',2)
                if TmpMean<0
                    tmpbase=TmpMean-20;
                    relval=(DetailedData.TableData(p).Mean-tmpbase)/(2*(TmpMean-tmpbase));
                    actrange=[min(myvals(~isnan(myvals)))-tmpbase max(myvals(~isnan(myvals)))-tmpbase]/(2*(TmpMean-tmpbase));
                else
                    relval=DetailedData.TableData(p).Mean/(2*TmpMean);
                    actrange=[min(myvals(~isnan(myvals))) max(myvals(~isnan(myvals)))]/(2*TmpMean);
                end
                relval=num2str(max(min(relval,1.1),-.1));
                sparklinetxt='';
                if ~isnan(TmpMean)
                    if ~isnan(DetailedData.TableData(p).Mean)
                        sparklinetxt=['\begin{sparkline}{6} \sparkrectangle 0.0 0.7 \sparkdot ' relval ' 0.35 ' ...
                             ' blue \spark ' num2str(actrange(1)) ' .35 ' num2str(actrange(2)) ' .35 / \spark 0.5 .0 0.5 .7 / \end{sparkline}'];
                    else
                        sparklinetxt=['\begin{sparkline}{6} \sparkrectangle 0.0 0.7  ' ...
                             ' blue \spark ' num2str(actrange(1)) ' .35 ' num2str(actrange(2)) ' .35 /  \spark 0.5 .0 0.5 .7 /  \end{sparkline}'];
                    end
                end
                fprintf(fid,'%s & %0.1f & %s \\\\ \n',strrep(DetailedData.TableData(p).Name,' #1',''),DetailedData.TableData(p).Mean,strrep(DetailedData.TableData(p).Units,'MegaOhm','M$\Omega$'));%,DetailedData.TableData(p).Desc);
                %fprintf(fid,'%s & %0.1f & %s & %s \\\\ \n',strrep(DetailedData.TableData(p).Name,' #1',''),DetailedData.TableData(p).Mean,strrep(DetailedData.TableData(p).Units,'MegaOhm','M$\Omega$'),sparklinetxt);%,DetailedData.TableData(p).Desc);
                fprintf(fid,'\\hline\n');
            end
        end
    else
        disp(celltype)
    end
    end
    if printtables
    fprintf(fid,'\\end{tabular}\n');
        fprintf(fid,'\\end{footnotesize}\n');

%     fprintf(fid,'\\caption[%s Cell Properties]{Intrinsic electrophysiological properties of model %s cells.}\n',cellabbr, cellabbr);
%     fprintf(fid,'\\label{tab:%sCellProp}\n',cellabbr);
%     fprintf(fid,'\\end{table}\n');
    fclose(fid);
    end
    
    mydata = eval(['explot_FiringRate(' num2str(handles.indices(h)) ',-1)']);
    figure(fired.h)
    hold on
    fired.leg(end+1)=plot(mydata.x,mydata.y,'color',[.1 .1 1]);%colorcycle{length(fired.leg)+1});
    fired.legstr{end+1}=celltype;
    xlabel(mydata.xheader)
    ylabel(mydata.yheader)
    
    for z=length(othercellsidx):-1:max(1,length(othercellsidx)-4)%1:min(length(othercellsidx),5);%length(colorcycle))
        newstrstuff = num2str(othercellsidx(z)) ; % not really handles.indices(h), gotta find the indices for the experimental cells of this type
        load([mypath sl 'data' sl 'DetailedData' sl AllCells(othercellsidx(z)).DetailedData '.mat']);
        eval(['DetailedData = ' AllCells(othercellsidx(z)).DetailedData ';']);
        othercells(z).data = eval(['explot_FiringRate(' newstrstuff ',-1)']);
        figure(firetype.h)
%         if z>length(colorcycle)
%             firetype.leg(end+1)=plot(othercells(z).data.x,othercells(z).data.y,'Color',colorcycle(mod(z,length(colorcycle)),:));
%         else
            firetype.leg(end+1)=plot(othercells(z).data.x,othercells(z).data.y,'Color',colorcycle(mod(z-1,length(colorcycle))+1,:));%colorcycle(z,:));
 %       end
         firetype.legstr{end+1}=AllCells(othercellsidx(z)).CellName;
        hold on
        figure(expfired.h)
        zmpz1=plot(othercells(z).data.x,othercells(z).data.y,'Color',colorstruct.(AllCells(othercellsidx(z)).CellType).color);%colorcycle(z,:));
        if z==length(othercellsidx)
            expfired.leg(end+1)=zmpz1;
            expfired.legstr{end+1}=celltypeNice{strmatch(celltype,findNiceidx)}; %AllCells(othercellsidx(z)).CellType;
        end
        hold on
    end
    figure(firetype.h)
    firetype.leg(end+1)=plot(mydata.x,mydata.y,'color',[.1 .1 1],'LineWidth',2);%colorcycle{length(fired.leg)+1});
    firetype.legstr{end+1}='Model';
    xlabel(mydata.xheader)
    ylabel(mydata.yheader)
    
    for c=1:length(Props2Plot)
        plotType = Props2Plot{c};
        if strcmp(plotType,'Sweep')
            modhigh=0;
            if ~exist('plotinfo','var') || isstruct(plotinfo) || length(plotinfo)<c
                plotinfo(c).h=figure('Color','w','Name',[cellabbr 'ModelCurrentSweep'],'Units','inches','PaperUnits','inches','PaperSize',[2 2],'PaperPosition',[0 0 2 2],'Position',[.5 .5 2 2]);
            else
                plotinfo(c).h(end+1)=figure('Color','w','Name',[cellabbr 'ModelCurrentSweep'],'Units','inches','PaperUnits','inches','PaperSize',[2 2],'PaperPosition',[0 0 2 2],'Position',[.5 .5 2 2]);
            end
            try
                load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.indices(h)).DetailedData '.mat']);
                eval(['DetailedData = ' AllCells(handles.indices(h)).DetailedData ';']);
                mydata = eval(['explot_' plotType(isspace(plotType)==0) '(' num2str(handles.indices(h)) ',-1)']);
                %myidx = isnan(mydata.y)==0;
               % plot(mydata.x(myidx),mydata.y(myidx),'Color',[.1 .1 1]);
                plot(mydata.x,mydata.y,'Color',[.1 .1 1]);
                xlabel(mydata.xheader)
                ylabel(mydata.yheader)
                title('Model Cell')
                box off
                modhigh=max(DetailedData.AxoClampData.Currents);
                modelspks=DetailedData.SpikeData(end).NumSpikes;
            end
            comparesteps=[];
            for z=1:length(othercellsidx)
                plotinfo(c).h(end+1)=figure('Color','w','Name',[cellabbr num2str(z) 'ExpCurrentSweep'],'Units','inches','PaperUnits','inches','PaperSize',[2 2],'PaperPosition',[0 0 2 2],'Position',[.5 .5 2 2]);
                newstrstuff = num2str(othercellsidx(z)) ; % not really handles.indices(h), gotta find the indices for the experimental cells of this type
                load([mypath sl 'data' sl 'DetailedData' sl AllCells(othercellsidx(z)).DetailedData '.mat']);
                eval(['DetailedData = ' AllCells(othercellsidx(z)).DetailedData ';']);
                [~, totry]=min(abs([DetailedData.AxoClampData.Currents]-modhigh));
                comparesteps(z)=DetailedData.SpikeData(totry).NumSpikes;
                othercells(z).data = eval(['explot_' plotType(isspace(plotType)==0) '(' newstrstuff ',-1,', num2str(modhigh) ,')']);
                %myidx = isnan(othercells(z).data.y)==0;
                if z>length(colorcycle)
                plot(othercells(z).data.x,othercells(z).data.y,'Color',colorcycle(mod(z,length(colorcycle)),:));
                %plot(othercells(z).data.x(myidx),othercells(z).data.y(myidx),'Color',colorcycle(mod(z,length(colorcycle)),:));
                else
                plot(othercells(z).data.x,othercells(z).data.y,'Color',colorcycle(z,:));
                %plot(othercells(z).data.x(myidx),othercells(z).data.y(myidx),'Color',colorcycle(z,:));
                end
                xlabel(mydata.xheader)
                ylabel(mydata.yheader)
                title('Experimental Cell')
                box off
                set(gca,'Color','none')
            end
            if length(comparesteps)>5
                [~, best2show]=min(abs(comparesteps(end-4:end)-modelspks));
                best2show=best2show+length(comparesteps)-5;
            else
                [~, best2show]=min(abs(comparesteps-modelspks));
            end
            if strcmp(cellabbr,'ngf')
                best2show=best2show+2;
            end
        else
            if ~exist('plotinfo','var') || isstruct(plotinfo) || length(plotinfo)<c
                plotinfo(c).h=figure('Color','w','Name',[cellabbr strrep(plotType,' ','')],'Units','inches','PaperUnits','inches','PaperSize',[4 2],'PaperPosition',[0 0 4 2],'Position',[.5 .5 4 2]);
                plotinfo(c).leg=[];
                plotinfo(c).legstr={};
            else
                figure(plotinfo(c).h)
            end
            hold on
            try
                mydata = eval(['explot_' plotType(isspace(plotType)==0) '(' num2str(handles.indices(h)) ',-1)']);
                myidx = isnan(mydata.y)==0;
                plotinfo(c).leg(end+1)=plot(mydata.x(myidx),mydata.y(myidx));
                plotinfo(c).legstr{end+1}='Model';
                xlabel(mydata.xheader)
                ylabel(mydata.yheader)
                % Find experimental cells and print them too
                for z=1:length(othercellsidx)
                    newstrstuff = num2str(othercellsidx(z)) ; % not really handles.indices(h), gotta find the indices for the experimental cells of this type
                    othercells(z).data = eval(['explot_' plotType(isspace(plotType)==0) '(' newstrstuff ',-1)']);
                    myidx = isnan(othercells(z).data.y)==0;
                    otherdata.x = sprintf('%0.4f,', othercells(z).data.x(myidx));
                    otherdata.y = sprintf('%0.4f,', othercells(z).data.y(myidx));
                    plotinfo(c).leg(end+1)=plot(othercells(z).data.x(myidx),othercells(z).data.y(myidx));
                    plotinfo(c).legstr{end+1}=AllCells(othercellsidx(z)).CellName;
                end
            catch ME
                msgbox(ME.message)
            end
        end
    end
    figure(firetype.h);
    pos=get(gca,'Position');
    set(gca,'Position',[pos(1) pos(2) pos(3)/2 pos(4)]);
    [ughleg, icns]=legend(firetype.leg([end 1:end-1]),firetype.legstr([end 1:end-1]),'Position',[pos(1)+pos(3)/2 pos(2) pos(3)/2 pos(4)],'Color','w','EdgeColor','w','Interpreter','none');
    for t=1:length(icns)
    if strcmp(icns(t).Type,'text')
        icns(t).String=strrep(strrep(strrep(strrep(icns(t).String,'intrinsic properties',''),'intrinsic propeties',''),'_raw',''),'Marienne','');
%         if length(icns(t).String)>14
%             icns(t).String={icns(t).String(1:floor(length(icns(t).String)/2)),icns(t).String(floor(length(icns(t).String)/2)+1:end)};
%         end
    end
    end
    for t=1:length(icns)
    if strcmp(icns(t).Type,'line') && length(icns(t).XData)==2
    icns(t).XData=[icns(t).XData(2)-.07 icns(t).XData(2)];
    end
    end
    set(ughleg,'Position',[.50 .1 .45 .8],'Color','none','EdgeColor','none')
    bf = findall(firetype.h,'Type','text');
    for b=1:length(bf)
        set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
    
    figure(firetype.h)
    mm=get(firetype.h,'Children');
    mll=get(mm(2),'Children');
    xlim([ 0 max(max([mll.XData]))])
    printeps(firetype.h,[pdfpath sl get(firetype.h,'Name') 'ord']);
    for c=1:length(plotinfo)
        if ~isempty(plotinfo(c).h)
            for k=1:length(plotinfo(c).h)
                figure(plotinfo(c).h(k));
                if c>1
                    pos=get(gca,'Position');
                    set(gca,'Position',[pos(1) pos(2) pos(3)/2 pos(4)]);
                    legend(plotinfo(c).leg,plotinfo(c).legstr,'Position',[pos(1)+pos(3)/2 pos(2) pos(3)/2 pos(4)],'Color','w','EdgeColor','w')
                end
                bf = findall(plotinfo(c).h(k),'Type','text');
                for b=1:length(bf)
                    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
                end
                printeps(plotinfo(c).h(k),[pdfpath sl get(plotinfo(c).h(k),'Name')]);
            end
        end
    end
 end
 
 if printlatex
    z = strmatch(strrep(celltype,'model','cell'),findNiceidx);
    nicecell=celltypeNice{z};
    nicefullcell=celltypeFullNice{z};
    

    textdesc=celldesc{z}; %'Stratum Oriens-Lacunosum-Moleculare Feedback Cell';
    
    z = strmatch(strrep(celltype,'model','cell'),{mycells.name});
    cellnum=mycells(z).numcells;
    % Layout of page:
    fid=fopen([pdfpath sl cellabbr 'Page.tex'],'w');
    fprintf(fid,'\\clearpage\n')
    fprintf(fid,'\\newpage\n')
    fprintf(fid,'\\subsection*{%s Cell: %s (%d Cells)\\label{ref:%spage}}\n',nicefullcell,textdesc,cellnum, cellabbr)
    fprintf(fid,'\\subsubsection*{Model and Experimental Electrophysiology}\n')
    fprintf(fid,'\\begin{figure}[htb]\n')
    fprintf(fid,'\\centering\n')
    fprintf(fid,'\\begin{subfigure}[t]{1.9in}%3.46\n')
		    fprintf(fid,'\\caption{}\n')
	     fprintf(fid,'\\label{fig:%spage:mod}\n', cellabbr)
			    fprintf(fid,'\\includegraphics[clip,width=1.9in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sModelCurrentSweep.eps}%\n', cellabbr)
    fprintf(fid,'\\end{subfigure}\\hspace{1em}%\n')
    fprintf(fid,'\\begin{subfigure}[t]{1.9in}%3.46\n')
		    fprintf(fid,'\\caption{}\n')
	     fprintf(fid,'\\label{fig:%spage:exp}\n', cellabbr)
			    fprintf(fid,'\\includegraphics[clip,width=1.9in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%s%dExpCurrentSweep.eps}%\n', cellabbr, best2show)
			    fprintf(fid,'\\end{subfigure}\\\\%\n')
    fprintf(fid,'\\begin{subfigure}[t]{3.8in}%3.46\n')
		    fprintf(fid,'\\caption{}\n')
	     fprintf(fid,'\\label{fig:%spage:firing}\n', cellabbr)
			    fprintf(fid,'\\includegraphics[clip,width=3.8in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sFiringRateord.eps}%\n', cellabbr)
			    fprintf(fid,'\\end{subfigure}%\n')
      fprintf(fid,'\\caption[]{\\internallinenumbers  %s \\psubref{fig:%spage:mod} model and \\psubref{fig:%spage:exp} experimental current sweep. \\psubref{fig:%spage:firing} Firing rates of model and experimental cells.}\n', nicefullcell, cellabbr, cellabbr, cellabbr)
    fprintf(fid,'\\label{fig:%spage}\n', cellabbr)
    fprintf(fid,'\\end{figure}			\n')
			
    fprintf(fid,'\\begin{minipage}[t]{2.8in}%3.46\n')
			%\begin{table}[htb]
			    fprintf(fid,'\\centering\n')
				    fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sTable}\n',strrep(celltype,'model','cell'))
				    fprintf(fid,'\\captionof{table}{Model %s cell electrophysiological properties.}\n',nicefullcell)
    fprintf(fid,'\\end{minipage}\\hspace{1em}\n')
    fprintf(fid,'\\begin{minipage}[t]{2.8in}%3.46\n')
			%\begin{table}[htb]
			    fprintf(fid,'\\centering\n')
				    fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%schannelTable}\n',strrep(celltype,'model','cell'))
				    fprintf(fid,'\\captionof{table}{Model %s cell ion channels and conductance at highest density location in cell.}\n',nicefullcell)
    fprintf(fid,'\\end{minipage}\n')
			
    fprintf(fid,'\\FloatBarrier\n')
    fprintf(fid,'\\subsubsection*{Model and Experimental Connectivity}\n')

			
			    fprintf(fid,'\\begin{table}[htb]\n')
			    fprintf(fid,'\\centering\n')
				    fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sConvDivTable}\n', cellabbr)
				    fprintf(fid,'\\caption{Structural connection parameters for %s cells, based on \\citet{Bezaire2013}.}\n',nicefullcell)
				    fprintf(fid,'\\label{tab:%spage:anatconn}\n', cellabbr)
			    fprintf(fid,'\\end{table}\n')
    fprintf(fid,'\\FloatBarrier\n')
    fprintf(fid,'\\subsubsection*{Experimental Connection Constraints}\n')

			    fprintf(fid,'\\begin{table}[htb]\n')
			    fprintf(fid,'\\centering\n')
				    fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sInExpTable}\n', cellabbr)
				    fprintf(fid,'\\caption{  Experimental constraints for incoming connections onto %s cells (clamp: black=voltage; purple=current).}\n',nicefullcell)
				    fprintf(fid,'\\label{tab:%spage:expin}\n', cellabbr)
			    fprintf(fid,'\\end{table}\n')
			
						    fprintf(fid,'\\begin{table}[htb]\n')
			    fprintf(fid,'\\centering\n')
				    fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sOutExpTable}\n', cellabbr)
				    fprintf(fid,'\\caption{Experimental constraints for outcoming connections onto %s cells (clamp: black=voltage; purple=current).}\n',nicefullcell)
				    fprintf(fid,'\\label{tab:%spage:expout}\n', cellabbr)
			    fprintf(fid,'\\end{table}\n')

    fprintf(fid,'\\FloatBarrier\n')
    fprintf(fid,'\\subsubsection*{Model Synapse Parameters}\n')
			
						    fprintf(fid,'\\begin{table}[htb]\n')
			    fprintf(fid,'\\centering\n')
				    fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sModelSynTable}\n', cellabbr)
				    fprintf(fid,'\\caption{Model synaptic parameters for  %s cells in the control network.}\n',nicefullcell)
				    fprintf(fid,'\\label{tab:%spage:syn}\n', cellabbr)
			    fprintf(fid,'\\end{table}\n')
    fprintf(fid,'\\FloatBarrier\n')
    fprintf(fid,'\\subsubsection*{Physiological Characterization of Model Connections}\n')
						    fprintf(fid,'\\begin{table}[htb]\n')
			    fprintf(fid,'\\centering\n')
				    fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sPhysTable}\n', cellabbr)
				    fprintf(fid,'\\caption{Model synaptic properties under voltage clamp at -50 mV with physiological reversal potentials}\n')
				    fprintf(fid,'\\label{tab:%spage:physconn}\n', cellabbr)
			    fprintf(fid,'\\end{table}\n')


    fprintf(fid,'\\begin{figure}[htb]\n')
    fprintf(fid,'\\centering\n')
    fprintf(fid,'\\begin{subfigure}[t]{3in}%3.46\n')
		    fprintf(fid,'\\caption{}\n')
	     fprintf(fid,'\\label{fig:%sconnpage:in}\n', cellabbr)
			    fprintf(fid,'\\includegraphics[clip,width=3in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sInPhysGraph.eps}%\n', cellabbr)
			    fprintf(fid,'\\end{subfigure}\\hspace{1em}%\n')
    fprintf(fid,'\\begin{subfigure}[t]{3in}%3.46\n')
		    fprintf(fid,'\\caption{}\n')
	     fprintf(fid,'\\label{fig:%sconnpage:out}\n', cellabbr)
			    fprintf(fid,'\\includegraphics[clip,width=3in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sOutPhysGraph.eps}%\n', cellabbr)
			    fprintf(fid,'\\end{subfigure}\\hspace{1em}%\n')
      fprintf(fid,'\\caption[]{\\internallinenumbers  Connections onto \\psubref{fig:%spage:mod} and \\psubref{fig:%spage:exp} from model %s cells, under voltage clamp at -50 mV with physiological reversal potentials.}\n', cellabbr, cellabbr,nicefullcell)
    fprintf(fid,'\\label{fig:%sconnpage}\n', cellabbr)
    fprintf(fid,'\\end{figure}\n')
%    fprintf(fid,'\\label{sec:supp:%s}\n', cellabbr)

%     fprintf(fid,'\\noindent\\textbf{%s Cell:\\label{ref:%s}} %s (%d Cells)\\\\\n',nicefullcell,[cellabbr 'page'],textdesc,cellnum)
%     fprintf(fid,'\\small{\\textcolor{lightblue}{\\textbf{Model and Experimental Electrophysiology}}}\\\\\n')    
%     fprintf(fid,'\\adjustbox{valign=t}{\\begin{minipage}[t]{3.9in}\n')
%     fprintf(fid,'\\begin{overpic}[clip,width=1.9in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sModelCurrentSweep.eps}\n\\put (0,93) {A}\n\\end{overpic}\n',cellabbr)
%     fprintf(fid,'\\begin{overpic}[clip,width=1.9in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%s%dExpCurrentSweep.eps}\\put (0,93) {B}\n\\end{overpic}\n\\\\ \n',cellabbr, best2show)
%     %fprintf(fid,'\\label{fig:%s:FiringRate}\n',cellabbr)
%     fprintf(fid,'\\begin{overpic}[clip,width=3.8in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sFiringRateord.eps}\\put (0,50) {D}\n\\end{overpic}%%\n',cellabbr)
%     fprintf(fid,'\\end{minipage}}\\hspace{1em}%%\n')
%     fprintf(fid,'\\adjustbox{valign=t}{\\begin{minipage}[t]{1.9in}\n')
%     fprintf(fid,'C\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sTable}\\\\\n',strrep(celltype,'model','cell'))
%     fprintf(fid,'\\vertspacecap%%\n')
%     fprintf(fid,'\\vertspacecap%%\n')
%     fprintf(fid,'E\\\\ \\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%schannelTable}\n',strrep(celltype,'model','cell'))
%     fprintf(fid,'\\end{minipage}}\\\\\n')
%     fprintf(fid,'\\vertspacecap%%\n')
%     fprintf(fid,'\\begin{minipage}[b]{6in}\n')
%     fprintf(fid,'\\noindent F \\small{\\textcolor{lightblue}{\\textbf{Model Structural Connection Parameters}}}\\\\\n')    
%     fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sConvDivTable}%%\n',cellabbr)
%     fprintf(fid,'\\end{minipage}\\\\\n')
%     fprintf(fid,'\\vertspacecap%%\n')
%     fprintf(fid,'\\adjustbox{valign=b}{\\begin{minipage}[b]{6in}\n')
%     fprintf(fid,'\\small{\\textcolor{lightblue}{\\textbf{Experimental Connection Constraints}}}\\\\\n')    
%     fprintf(fid,'G\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sInExpTable}%%\n',cellabbr)
%     fprintf(fid,'H\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sOutExpTable}%%\n',cellabbr)
%     fprintf(fid,'\\end{minipage}}%%\\\\\n')
% 
%     fprintf(fid,'\\newpage\n')
%     fprintf(fid,'\\noindent I \\small\\textcolor{lightblue}{\\textbf{Model Synapse Parameters}}\\\\\n')    
%     fprintf(fid,'\\adjustbox{valign=b}{\\begin{minipage}[b]{6in}\n')
%     fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sModelSynTable}\\\\%%\n',cellabbr)
%     fprintf(fid,'\\vertspacecap%%\n')
%     fprintf(fid,'\\noindent J \\small{\\textcolor{lightblue}{\\textbf{Physiological Characterization of Model Connections}}}\\\\\n')    
%     fprintf(fid,'\\input{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sPhysTable}%%\n',cellabbr)
%     fprintf(fid,'\\vertspacecap%%\n')
%     fprintf(fid,'\\end{minipage}}\\\\\n')
%     fprintf(fid,'\\vertspacecap%%\n')
%     fprintf(fid,'\\begin{minipage}[b]{6in}\n')
%     fprintf(fid,'\\begin{overpic}[clip,width=3in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sInPhysGraph.eps}\\put (0,95) {K}\n\\end{overpic}\n',cellabbr)
%     fprintf(fid,'\\begin{overpic}[clip,width=3in]{C:/Users/maria_000/Documents/repos/papers/ca1/testy/%sOutPhysGraph.eps}\\put (0,95) {L}\n\\end{overpic}\n',cellabbr)
%     mh=strmatch(cellabbr,cellabbrord);
%     fprintf(fid,'\\captionof{figure}{\\footnotesize %s. %s }\n\\label{sec:supp:%s}',nicefullcell,  ...
%         ['Current injections for (A) model and (B) a sample experimental cell. ' ...
%         '(C) Model cell properties. ' ...
%         '(D) Firing rates of model and some experimental cells. (E) Ion channels in model and their conductance density at densest location. ' ...
%         '(F) Incoming and outgoing synapses and connections for model cells, based on \citet{Bezaire2013}.' ...
%         ' Experimental constraints (black: voltage clamp, purple: current clamp) and fits for (G) incoming  and (H) outgoing connections.' ...
%         '(I) Model synaptic parameters for control network. (J) Model synaptic properties under voltage clamp at -50 mV with physiological reversal potentials.'...
%         'Connections (K) onto ' nicecell ' cells and (L) from ' nicecell ' cells to other cell types, under same conditions as I and J.'],cellabbr);
%     fprintf(fid,'\\end{minipage}\n')
    fclose(fid);
 end
end
if printtables
fprintf(fprop,'\\end{tabular}\n');
fprintf(fprop,'\\end{footnotesize}\n');

    fprintf(fprop,'\\caption[Exp. Cell Properties]{Intrinsic electrophysiological properties of exp. cells.}\n');
    fprintf(fprop,'\\label{tab:cellExpProps}\n');
    fprintf(fprop,'\\end{sidewaystable}\n');
fclose(fprop);
end
if printfigures
figure(expfired.h)
box off
legend(expfired.leg,expfired.legstr,'EdgeColor','none','Color','none')
xlabel('Current Injection (pA)')
ylabel('Firing Rate (Hz)')
xlim([0 1000])
bf = findall(expfired.h,'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end

printeps(expfired.h,[pdfpath sl get(expfired.h,'Name')]);

for p=1:length(Props2List)
    figure(propfig(p))
    box off
    set(get(propfig(p),'Children'),'xtick',1:9,'xticklabel',celltypeNice(1:9))
    set(get(propfig(p),'Children'),'position',[.12 .15 .85 .82])
     xlim([0.7 9.3])
    ylabel([Props2List{p} ' (' UnitNice{p} ')'])
    bf = findall(propfig(p),'Type','text');
    for b=1:length(bf)
        set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end

    printeps(propfig(p),[pdfpath sl strrep(strrep(get(propfig(p),'Name'),'#1',''),' ','')]);
end
end

if 1==0
    fid=fopen([pdfpath sl 'CellSupplement.tex'],'w');
    fprintf(fid,'\\documentclass [12pt]{article}\n')
    fprintf(fid,'\\usepackage[textwidth=7in,textheight=10in]{geometry}\n')
    %fprintf(fid,'\\usepackage[heightadjust=all]{floatrow}\n')
    fprintf(fid,'\\usepackage[authoryear,semicolon]{natbib}\n')
    fprintf(fid,'\\usepackage[T1]{fontenc}\n')
    fprintf(fid,'\\usepackage[percent]{overpic}\n')
    fprintf(fid,'\\usepackage{uarial}\n')
    fprintf(fid,'\\usepackage{bm}\n')
    fprintf(fid,'\\renewcommand{\\familydefault}{\\sfdefault}\n')
    fprintf(fid,'\\usepackage{caption}\n')
    fprintf(fid,'\\usepackage[skip=0pt,justification=raggedright,singlelinecheck=false]{subcaption}\n')
    fprintf(fid,'\\usepackage{graphicx}\n')
    fprintf(fid,'\\usepackage{upgreek}\n')
    fprintf(fid,'\\usepackage[pagewise, mathlines]{lineno}\n')
    fprintf(fid,'\\usepackage{rotating}\n')
    fprintf(fid,'\\usepackage{adjustbox}\n')
    fprintf(fid,'\\usepackage[usenames, dvipsnames]{color}\n')
    fprintf(fid,'\\definecolor{purple}{rgb}{.3, 0, .7}\n')
    fprintf(fid,'\\definecolor{lightblue}{rgb}{0.300000,0.300000, 1.00000}\n')
    for c=1:length(mycells)
        fprintf(fid,'\\definecolor{%s}{rgb}{%f,%f, %f}\n',mycells(c).name,colorstruct.(mycells(c).name(1:end-4)).color(1),colorstruct.(mycells(c).name(1:end-4)).color(2),colorstruct.(mycells(c).name(1:end-4)).color(3))
    end
    fprintf(fid,'\\usepackage{sparklines}\n')
    fprintf(fid,'\\newcommand\\psubref[1]{(\\subref{#1})}\n')
    fprintf(fid,'\\newcommand\\vertspacecap{\\vspace*{1mm}\\ }\n')
    fprintf(fid,'\\begin{document}\n')
    fprintf(fid,'\\section*{Supplemental Model Cell Characterization}\n')
    fprintf(fid,'\\begin{minipage}[t]{4in}\n\\flushleft\n')
    fprintf(fid,'\\textbf{Cell type}\\\\ \n',c*2)
    for c=1:length(cellabbrord)
        niceone=celltypeNice{strmatch(cellabbrord{c},findNiceidx)};
        %nn=30-length(niceone);
        %fprintf(fid,'%s %s Page %d\\\\ \n',niceone,repmat('.',1,nn),c*2)
        fprintf(fid,'%s (%s)\\\\ \n',celltypeFullNice{strmatch(cellabbrord{c},findNiceidx)},niceone)
    end
    fprintf(fid,'\\textbf{Ion Channels}\\\\\n')
    fprintf(fid,'\\textbf{Inhibitory Connectivity}\\\\\n')

    fprintf(fid,'\\end{minipage}\n\\hfill\n')
    fprintf(fid,'\\begin{minipage}[t]{2in}\n\\flushright\n')
    fprintf(fid,'\\textbf{Page}\\\\ \n',c*2)
    for c=1:length(cellabbrord)
        fprintf(fid,'%d\\\\ \n',c*2)
    end
    fprintf(fid,'20\\\\\n')
    fprintf(fid,'25\\\\\n') %    ionchpages=20+numpages;
    fprintf(fid,'\\end{minipage}\n')
    for c=1:length(cellabbrord)
        fprintf(fid,'\\newpage\n')
        fprintf(fid,'\\input{%sPage}\n',cellabbrord{c})
    end
    fprintf(fid,'\\newpage\n')
    fprintf(fid,'\\input{inrncalcs}\n')
    fprintf(fid,'\\clearpage\n')
    fprintf(fid,'\\bibliographystyle{plainnat}\n')
    fprintf(fid,'\\bibliography{C:/Users/maria_000/Documents/TeXnicCenterDocs/NewCA1Paper/newbibfile}\n')
    fprintf(fid,'\\end{document}\n')
    fclose(fid)
end
