function print_pdf(pathway,allcells,allpscs,allchans,allephys,allconns,alltraces,allexppscs)
global pdfpath sl myFontName myFontWeight myFontSize


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


celltypeFullNice={'Pyramidal','PV+ Basket','CCK+ Basket','Schaffer Collateral-Associated','Axo-axonic','Bistratified','O-LM','Ivy','Neurogliaform','Proximal Afferent','Distal Afferent'};
celltypeNice={'Pyr','PV+B','CCK+B','SC-A','Axo','Bis','O-LM','Ivy','NGF','CA3','ECIII'};
findNiceidx={'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','ca3cell','eccell'};

if ispc
sl = '\';
else
    sl='/';
    end

allcelltypes = fieldnames(allcells);
conns = allconns;
traces = alltraces;
pscs = allpscs;

skipme = 20;
realvec=[1 5:7];
% expsyns = expsyndatagen(pathway,allcelltypes,realvec,alltraces);
expsyns = expsyndata(alltraces);

if ~exist([pathway sl 'cells'],'dir')
    mkdir([pathway sl 'cells'])
end

fcells = fopen([pathway sl 'cells' sl 'allcells.txt'],'w');

for x=1:length(allcelltypes)
    fprintf(fcells,'%s,%d,%d,%d,%d,%s,%d\n',allcelltypes{x},allcells.(allcelltypes{x}).Ind,allcells.(allcelltypes{x}).Ind,allcells.(allcelltypes{x}).Ind,allcells.(allcelltypes{x}).NumCells,allcells.(allcelltypes{x}).Type,allcells.(allcelltypes{x}).Ind);
end
fclose(fcells);

for a=1:length(allcelltypes)
    celltype = allcelltypes{a};
    cellabbr=celltype(1:3);
    z = strmatch(celltype,findNiceidx);
    nicecellfull=celltypeFullNice{z};
    nicecell=celltypeNice{z};

    if exist([pathway sl 'cells' sl celltype],'dir')==0
        mkdir([pathway sl 'cells' sl celltype])
    else
        system(['rm ' pathway sl 'cells' sl celltype sl '*.txt'])
    end
    
    if isfield(allephys,celltype) && strcmp(allcells.(celltype).Type,'real')==1
        ephys = allephys.(celltype);
        ephysimage = {'Current_sweep','Firing_frequency','Steady_state_potential','Sag_amplitude','Sag_timing','Max_depolarization','Max_hyperpolarization'};
        %%% Ion Channel Table:
        %///////////

        if isfield(allchans,celltype)
            fchan=fopen([pdfpath sl celltype 'channelTable.tex'],'w');
            fprintf(fchan,'\\begin{footnotesize}\n');
%             fprintf(fchan,'\\begin{table}[position htb]\n');
%             fprintf(fchan,'\\centering\n');
            %fprintf(fchan,'\\begin{tabular}{|lrr|}\n');
            fprintf(fchan,'\\begin{tabular}{|lr|}\n');

            fprintf(fchan,'\\hline\n');
            %fprintf(fchan,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Channel','$G_{max}$');%,'$E_{Rev}$');
            fprintf(fchan,'\\textbf{%s} & \\textbf{%s} \\\\ \n','','$\boldsymbol{\mathsf{G_{max}}}$');%,'$E_{Rev}$');
            fprintf(fchan,'\\textbf{%s} & \\textbf{%s} \\\\ \n','Channel','(S/cm$^2$)');%,'$E_{Rev}$');
            fprintf(fchan,'\\hline\n');
            channels = fieldnames(allchans.(celltype)); %{'Nav','Kdr','CavL','HCN','leak'};
            for x=1:length(channels)
                if allchans.(celltype).(channels{x}).Gmax>0
                    %fprintf(fchan,'%s & %0.4f & %0.0f \\\\ \n',channels{x},allchans.(celltype).(channels{x}).Gmax,allchans.(celltype).(channels{x}).Erev)%,allchans.(celltype).(channels{x}).Loc,allchans.(celltype).(channels{x}).Desc)
                    fprintf(fchan,'%s & %0.3e \\\\ \n',channels{x},allchans.(celltype).(channels{x}).Gmax)%,allchans.(celltype).(channels{x}).Loc,allchans.(celltype).(channels{x}).Desc)
                    fprintf(fchan,'\\hline\n');
                end
            end
            fprintf(fchan,'\\end{tabular}\n');
            fprintf(fchan,'\\end{footnotesize}\n');
%             fprintf(fchan,'\\caption[%s Cell Channels]{Ion channels in model %s cells.}\n',cellabbr, cellabbr);
%             fprintf(fchan,'\\label{tab:%sCellChan}\n',cellabbr);
%             fprintf(fchan,'\\end{table}\n');
            fclose(fchan);
        end

        fpscs=fopen([pdfpath sl cellabbr 'PhysTable.tex'],'w');
        fprintf(fpscs,'\\begin{footnotesize}\n');
        %fprintf(fpscs,'\\centering\n');
        fprintf(fpscs,'\\begin{tabular}{|l|rrrrr||rrrrr|}\n');
        pscsfields = fieldnames(pscs.(celltype));

        fprintf(fpscs,'\\hline\n');
         fprintf(fpscs,'  & \\multicolumn{5}{|c||}{Other Cell to %s} & \\multicolumn{5}{|c|}{%s to Other Cell} \\\\ \n', nicecell, nicecell);
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','','Hold','$\boldsymbol{\mathsf{E_{rev}}}$','Amp.','$\boldsymbol{\mathsf{t_{10-90}}}$','$\boldsymbol{\mathsf{\uptau_{decay}}}$','Hold','$\boldsymbol{\mathsf{E_{rev}}}$','Amp.','$\boldsymbol{\mathsf{t_{10-90}}}$','$\boldsymbol{\mathsf{\uptau_{decay}}}$');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Type','(mV)','(mV)','(pA)','(ms)','(ms)','(mV)','(mV)','(pA)','(ms)','(ms)');
        fprintf(fpscs,'\\hline\n');

        for c=1:length(allcelltypes)%convdiv
            if (isfield(pscs,allcelltypes{c}) && isfield(pscs.(allcelltypes{c}),celltype)) || isfield(pscs.(celltype),allcelltypes{c})
                z = strmatch(allcelltypes{c},findNiceidx);
                typenice=celltypeNice{z};
                fprintf(fpscs,'\\textbf{\\textcolor{%s}{%s}} ',allcelltypes{c},typenice)
                if isfield(pscs,allcelltypes{c}) && isfield(pscs.(allcelltypes{c}),celltype)
                    pretype=allcelltypes{c};
                    fprintf(fpscs,' & %.1f & %.1f & %.2f & %.2f & %.2f ',pscs.(pretype).(celltype).Holding,pscs.(pretype).(celltype).Reversal,pscs.(pretype).(celltype).Amplitude,pscs.(pretype).(celltype).RiseTime,pscs.(pretype).(celltype).DecayTau);
                else
                    fprintf(fpscs,' &  &  &  &  & ');
                end
                if isfield(pscs,celltype) && isfield(pscs.(celltype),allcelltypes{c})
                    posttype=allcelltypes{c};
                    fprintf(fpscs,' & %.1f & %.1f & %.2f & %.2f & %.2f ',pscs.(celltype).(posttype).Holding,pscs.(celltype).(posttype).Reversal,pscs.(celltype).(posttype).Amplitude,pscs.(celltype).(posttype).RiseTime,pscs.(celltype).(posttype).DecayTau);
                else
                    fprintf(fpscs,' &  &  &  &  & ');
                end
            fprintf(fpscs,' \\\\ \n \\hline\n');
            end
        end
        fprintf(fpscs,'\\end{tabular}\n');
        fprintf(fpscs,'\\end{footnotesize}\n');
%         fprintf(fpscs,'\\caption[%s Incoming Physiological Condition]{PSCs from all connections onto %s cells while voltage clamped at -50 mV.}\n',nicecell, nicecell);
%         fprintf(fpscs,'\\label{tab:%sInPhysSyn}\n',cellabbr);
%         fprintf(fpscs,'\\end{table}\n');
        fclose(fpscs);

        
        fpscs=fopen([pdfpath sl cellabbr 'InExpTable.tex'],'w');
%         fprintf(fpscs,'\\begin{sidewaystable}[position htb]\n');
%         fprintf(fpscs,'\\centering\n');
        fprintf(fpscs,'\\begin{footnotesize}\n');
        fprintf(fpscs,'\\begin{tabular}{|llrr|rr|rr|rr|}\n');
        pscsfields = fieldnames(allexppscs);

        fprintf(fpscs,'\\hline\n');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Pre','Exp.','Hold','$\boldsymbol{\mathsf{E_{rev}}}$','Amp.','Diff.','$\boldsymbol{\mathsf{t_{10-90}}}$','Diff.','$\boldsymbol{\mathsf{\uptau_{decay}}}$','Diff.');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Type','Ref.','(mV)','(mV)','(pA,\textcolor{purple}{mV})','\%','(ms)','\%','(ms)','\%');
        fprintf(fpscs,'\\hline\n');
        
        unusedin=1;
        for c=1:length(pscsfields)
            pretype = pscsfields{c};
            z = strmatch(pretype,findNiceidx);
            prenice=celltypeNice{z};
            if isfield(allexppscs.(pretype),celltype)
                if isfield(expsyns,pretype) && isfield(expsyns(1).(pretype),celltype)
                    if strcmp(allexppscs.(pretype).(celltype).Clamp,expsyns(1).(pretype).(celltype).Clamp)==0 && length(expsyns)>1 && isempty(expsyns(2).(pretype).(celltype))==0
                        tc=2;
                    else
                        tc=1;
                    end
                    if allexppscs.(pretype).(celltype).Holding ~= expsyns(tc).(pretype).(celltype).Holding
                        if strcmp(allexppscs.(pretype).(celltype).Clamp,'Current')==1
                            allexppscs.(pretype).(celltype).Holding = expsyns(tc).(pretype).(celltype).Holding;
                        else
                            disp(['Holding potentials for ' pretype ' -> ' celltype ' don''t match. Model: ' num2str(allexppscs.(pretype).(celltype).Holding) ', Experimental: ' num2str(expsyns(tc).(pretype).(celltype).Holding)])
                        end
                    end
                    if allexppscs.(pretype).(celltype).Reversal ~= expsyns(tc).(pretype).(celltype).Reversal
                        disp(['Reversal potentials for ' pretype ' -> ' celltype ' don''t match. Model: ' num2str(allexppscs.(pretype).(celltype).Reversal) ', Experimental: ' num2str(expsyns(tc).(pretype).(celltype).Reversal)])
                    end
                    AmpDiff = (allexppscs.(pretype).(celltype).Amplitude - expsyns(tc).(pretype).(celltype).Amplitude)/expsyns(tc).(pretype).(celltype).Amplitude*100;
                    if isfield(expsyns(tc).(pretype).(celltype),'RiseTime')
                        RiseDiff = (allexppscs.(pretype).(celltype).RiseTime - expsyns(tc).(pretype).(celltype).RiseTime)/expsyns(tc).(pretype).(celltype).RiseTime*100;
                    else
                        RiseDiff = (allexppscs.(pretype).(celltype).Peak - expsyns(tc).(pretype).(celltype).Peak)/expsyns(tc).(pretype).(celltype).Peak*100;
                    end
                    if strcmp(allexppscs.(pretype).(celltype).Clamp,'Voltage')==1 && isfield(expsyns(tc).(pretype).(celltype),'DecayTau')
                        DecayVal = allexppscs.(pretype).(celltype).DecayTau;
                        DecayDiff = (allexppscs.(pretype).(celltype).DecayTau - expsyns(tc).(pretype).(celltype).DecayTau)/expsyns(tc).(pretype).(celltype).DecayTau*100;
                    else
                        try
                        DecayVal = allexppscs.(pretype).(celltype).HalfWidth;
                        DecayDiff = (allexppscs.(pretype).(celltype).HalfWidth - expsyns(tc).(pretype).(celltype).HalfWidth)/expsyns(tc).(pretype).(celltype).HalfWidth*100;
                        catch
                            DecayVal=NaN;
                            'm'
                        end
                    end
                    if strcmp(allexppscs.(pretype).(celltype).Clamp,'Voltage')==1
                        fprintf(fpscs,'%s & %s & %.1f & %.1f & %.2f & %+.1f & %.2f & %+.1f & %.2f & %+.1f \\\\ \n',prenice,strrep(expsyns(tc).(pretype).(celltype).ref,'and','\&'),allexppscs.(pretype).(celltype).Holding,allexppscs.(pretype).(celltype).Reversal,allexppscs.(pretype).(celltype).Amplitude,AmpDiff,allexppscs.(pretype).(celltype).RiseTime,RiseDiff,DecayVal,DecayDiff);
                    else
                        fprintf(fpscs,'%s & %s & %.1f & %.1f & \\textcolor{purple}{%.2f} &  \\textcolor{purple}{%+.1f} &  \\textcolor{purple}{%.2f} &   \\textcolor{purple}{%+.1f} & \\textcolor{purple}{%.2f} &  \\textcolor{purple}{%+.1f} \\\\ \n',prenice,strrep(expsyns(1).(pretype).(celltype).ref,'and','\&'),allexppscs.(pretype).(celltype).Holding,allexppscs.(pretype).(celltype).Reversal,allexppscs.(pretype).(celltype).Amplitude,AmpDiff,allexppscs.(pretype).(celltype).RiseTime,RiseDiff,DecayVal,DecayDiff);
                    end
                    fprintf(fpscs,'\\hline\n');
                    unusedin=0;
                else                   
%                     if strcmp(allexppscs.(pretype).(celltype).Clamp,'Voltage')==1
%                         fprintf(fpscs,'%s & n/a & %.1f & %.1f & %.2f&  & %.2f & & %.2f & \\\\ \n',prenice,allexppscs.(pretype).(celltype).Holding,allexppscs.(pretype).(celltype).Reversal,allexppscs.(pretype).(celltype).Amplitude,allexppscs.(pretype).(celltype).RiseTime,allexppscs.(pretype).(celltype).DecayTau);
%                     else
%                         fprintf(fpscs,'%s & n/a & %.1f & %.1f &  & \textcolor{purple}{%.2f} &  & %.2f & \textcolor{purple}{%.2f} &  \\\\ \n',prenice,allexppscs.(pretype).(celltype).Holding,allexppscs.(pretype).(celltype).Reversal,allexppscs.(pretype).(celltype).Amplitude,allexppscs.(pretype).(celltype).RiseTime,allexppscs.(pretype).(celltype).DecayTau);
%                     end
                end
            end
        end
        fprintf(fpscs,'\\end{tabular}\n');
        fprintf(fpscs,'\\end{footnotesize}\n');
%         fprintf(fpscs,'\\caption[%s Incoming Experimental Comparison]{Where experimental data exist for connections onto %s cells, compare the experimental and model connections under the same conditions.}\n',nicecell, nicecell);
%         fprintf(fpscs,'\\label{tab:%sInExpComp}\n',cellabbr);
%         fprintf(fpscs,'\\end{sidewaystable}\n');
        fclose(fpscs);
        if unusedin
            fpscs=fopen([pdfpath sl cellabbr 'InExpTable.tex'],'w');
            fprintf(fpscs,'\\noindent \\textit{ Note: No experimental constraints available for incoming synapses to %s cells.} \\\\\n',nicecellfull);
            fclose(fpscs);
        end

        fpscs=fopen([pdfpath sl cellabbr 'InSynTable.tex'],'w');
        fprintf(fpscs,'\\begin{table}[position htb]\n');
        fprintf(fpscs,'\\centering\n');
        fprintf(fpscs,'\\begin{tabular}{|lrrrr|}\n');

        fprintf(fpscs,'\\hline\n');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Pre','$\boldsymbol{\mathsf{E_{rev}}}$','$\boldsymbol{\mathsf{G_{max}}}$','$\boldsymbol{\mathsf{\uptau_{rise}}}$','$\boldsymbol{\mathsf{\uptau_{decay}}}$');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Type','(mV)','(nS)','(ms)','(ms)');
        fprintf(fpscs,'\\hline\n');
        pscsfields = fieldnames(allconns);

        for c=1:length(pscsfields)
            pretype = pscsfields{c};
            z = strmatch(pretype,findNiceidx);
            prenice=celltypeNice{z};
            if isfield(pscs.(pretype),celltype)
                try
                fprintf(fpscs,'%s & %.1f & %.3e & %.2f & %.2f \\\\ \n',prenice,allconns.(pretype).(celltype).Reversal,allconns.(pretype).(celltype).Weight,allconns.(pretype).(celltype).Tau1,allconns.(pretype).(celltype).Tau2);
                catch
                fprintf(fpscs,'%s & %.1f & %.3e & %.2f & %.2f\\\\ \n',prenice,allconns.(pretype).(celltype).Reversal,allconns.(pretype).(celltype).Weight,allconns.(pretype).(celltype).Tau1{:},allconns.(pretype).(celltype).Tau2);
                end
                fprintf(fpscs,'\\hline\n');
            end
        end
        fprintf(fpscs,'\\end{tabular}\n');
        fprintf(fpscs,'\\caption[%s Incoming Synapses]{Properties of synapses made by other cells onto %s cells.}\n',nicecell, nicecell);
        fprintf(fpscs,'\\label{tab:%sInSynProp}\n',cellabbr);
        fprintf(fpscs,'\\end{table}\n');
        fclose(fpscs);
        
        fpscs=fopen([pdfpath sl cellabbr 'ModelSynTable.tex'],'w');
        fprintf(fpscs,'\\begin{footnotesize}\n');
        fprintf(fpscs,'\\begin{tabular}{|l|rrrr||rrrr|}\n');

        fprintf(fpscs,'\\hline\n');
         fprintf(fpscs,'  & \\multicolumn{4}{|c||}{Other Cell to %s} & \\multicolumn{4}{|c|}{%s to Other Cell} \\\\ \n', nicecell, nicecell);
       fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','','$\boldsymbol{\mathsf{E_{rev}}}$','$\boldsymbol{\mathsf{G_{max}}}$','$\boldsymbol{\mathsf{\uptau_{rise}}}$','$\boldsymbol{\mathsf{\uptau_{decay}}}$','$\boldsymbol{\mathsf{E_{rev}}}$','$\boldsymbol{\mathsf{G_{max}}}$','$\boldsymbol{\mathsf{\uptau_{rise}}}$','$\boldsymbol{\mathsf{\uptau_{decay}}}$');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Type','(mV)','(nS)','(ms)','(ms)','(mV)','(nS)','(ms)','(ms)');
        fprintf(fpscs,'\\hline\n');

        for c=1:length(allcelltypes) %convdiv
            if (isfield(allconns,allcelltypes{c}) && isfield(allconns.(allcelltypes{c}),celltype)) || isfield(allconns.(celltype),allcelltypes{c})
                z = strmatch(allcelltypes{c},findNiceidx);
                typenice=celltypeNice{z};
                fprintf(fpscs,'\\textbf{\\textcolor{%s}{%s}} ',allcelltypes{c},typenice)
                if isfield(allconns,allcelltypes{c}) && isfield(allconns.(allcelltypes{c}),celltype)
                    pretype=allcelltypes{c};
                    try
                        fprintf(fpscs,' & %.1f & %.3e & %.2f & %.2f ',allconns.(pretype).(celltype).Reversal,allconns.(pretype).(celltype).Weight,allconns.(pretype).(celltype).Tau1,allconns.(pretype).(celltype).Tau2);
                    catch
                        fprintf(fpscs,' & %.1f & %.3e & %.2f & %.2f',allconns.(pretype).(celltype).Reversal,allconns.(pretype).(celltype).Weight,allconns.(pretype).(celltype).Tau1{:},allconns.(pretype).(celltype).Tau2);
                    end
                else
                    fprintf(fpscs,' &  &  & & ');
                end
                if isfield(allconns.(celltype),allcelltypes{c})
                    posttype=allcelltypes{c};
                    try
                        fprintf(fpscs,' & %.1f & %.3e & %.2f & %.2f ',allconns.(celltype).(posttype).Reversal,allconns.(celltype).(posttype).Weight,allconns.(celltype).(posttype).Tau1,allconns.(celltype).(posttype).Tau2);
                    catch
                        fprintf(fpscs,' & %.1f & %.3e & %.2f & %.2f',allconns.(celltype).(posttype).Reversal,allconns.(celltype).(posttype).Weight,allconns.(celltype).(posttype).Tau1{:},allconns.(celltype).(posttype).Tau2);
                    end
                else
                    fprintf(fpscs,' &  &  & & ');
                end
                fprintf(fpscs,'\\\\ \n\\hline\n');
            end
        end
        fprintf(fpscs,'\\end{tabular}\n');
        fprintf(fpscs,'\\end{footnotesize}\n');
        fclose(fpscs);
        
        

        %%% PSC Figure:
        %///////////
        figure('Color','w','Units','inches','PaperUnits','inches','PaperSize',[3 3],'PaperPosition',[.5 .5 3 3],'Position',[.5 .5 3 3])
        tracefields = fieldnames(traces);
        for c=1:length(tracefields)
            pretype = tracefields{c};
            if isfield(traces.(pretype), celltype)
                plot(traces.(pretype).(celltype).Time,traces.(pretype).(celltype).Trace*1000,'Color',colorstruct.(pretype(1:end-4)).color,'LineWidth',2)
                hold on
            end
        end
        xlabel('Time (ms)')
        ylabel('Postsynaptic Current (pA)')
        title([ 'Other Cells'' Connections onto ' nicecell])
        bf = findall(gcf,'Type','text');
        for b=1:length(bf)
            set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
        end
        bf = findall(gcf,'Type','axis');
        for b=1:length(bf)
            set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
        end
%         if strcmp('ngfcell',celltype)
%             xlim([100 200])
%         else
            xlim([113 152])
%         end
        printeps(gcf,[pdfpath sl cellabbr 'InPhysGraph'])

        % % convergence  (table and figure)

        %%% Conv Table:
        fconv=fopen([pdfpath sl cellabbr 'ConvergenceTable.tex'],'w');
        fprintf(fconv,'\\begin{table}[position htb]\n');
        fprintf(fconv,'\\centering\n');
        fprintf(fconv,'\\begin{tabular}{|lrrrl|}\n');

        fprintf(fconv,'\\hline\n');
        fprintf(fconv,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Pre Type','\# Conn.s','Syn.s/Conn.','\# Syn.s','Location');
        fprintf(fconv,'\\hline\n');
        connsfields = fieldnames(conns);

        for c=1:length(connsfields)
            pretype = connsfields{c};
            z = strmatch(pretype,findNiceidx);
            prenice=celltypeNice{z};
            if isfield(conns.(pretype),celltype)
                fprintf(fconv,'%s & %d & %d & %d & %s \\\\ \n',prenice,conns.(pretype).(celltype).Conns,conns.(pretype).(celltype).SynsPerConn,conns.(pretype).(celltype).Syns,getloc(conns.(pretype).(celltype).Location));
                fprintf(fconv,'\\hline\n');
            end
        end
        fprintf(fconv,'\\end{tabular}\n');
        fprintf(fconv,'\\caption[%s Cell Convergence]{Convergence of connections made from other cells onto %s cells.}\n',nicecell, nicecell);
        fprintf(fconv,'\\label{tab:%sCellConv}\n',cellabbr);
        fprintf(fconv,'\\end{table}\n');
        fclose(fconv);

        %%% Conv Figure:
        % maybe don't need anything extra for this
    else
        system(['cp ' pathway sl 'artcell.png ' pathway sl 'cells' sl celltype sl 'all.png']);
    end

    % outgoing connectivity

    % % PSCs  (table and figure)
    %%% PSC Table:
    % Model Synapses, Physiological Conditions
    % Presynaptic cell, holding potential, reversal potential, amplitude, rise time, decay tau

    if isfield(pscs, celltype) && isfield(traces, celltype) && isfield(conns, celltype)
        fpscs=fopen([pdfpath sl cellabbr 'OutPhysTable.tex'],'w');
        fprintf(fpscs,'\\begin{table}[position htb]\n');
        fprintf(fpscs,'\\centering\n');
        fprintf(fpscs,'\\begin{tabular}{|lrrrrr|}\n');
        pscsfields = fieldnames(pscs.(celltype));

        fprintf(fpscs,'\\hline\n');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Post','Hold','$\boldsymbol{\mathsf{E_{rev}}}$','Amp.','$\boldsymbol{\mathsf{t_{10-90}}}$','$\boldsymbol{\mathsf{\uptau_{decay}}}$');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Type','(mV)','(mV)','(pA)','(ms)','(ms)');
        fprintf(fpscs,'\\hline\n');

        for c=1:length(pscsfields)
            posttype = pscsfields{c};
            z = strmatch(posttype,findNiceidx);
            postnice=celltypeNice{z};
            fprintf(fpscs,'%s & %.1f & %.1f & %.2f & %.2f & %.2f \\\\ \n',postnice,pscs.(celltype).(posttype).Holding,pscs.(celltype).(posttype).Reversal,pscs.(celltype).(posttype).Amplitude,pscs.(celltype).(posttype).RiseTime,pscs.(celltype).(posttype).DecayTau);
            fprintf(fpscs,'\\hline\n');
        end
        fprintf(fpscs,'\\end{tabular}\n');
        fprintf(fpscs,'\\caption[%s Outgoing Physiological Condition]{PSCs from all cells that receive input from %s cells, while voltage clamped at -50 mV.}\n',nicecell, nicecell);
        fprintf(fpscs,'\\label{tab:%sOutPhysSyn}\n',cellabbr);
        fprintf(fpscs,'\\end{table}\n');
        fclose(fpscs);

        fpscs=fopen([pdfpath sl cellabbr 'OutExpTable.tex'],'w');
        %fprintf(fpscs,'\\begin{sidewaystable}[position htb]\n');
        %fprintf(fpscs,'\\centering\n');
        fprintf(fpscs,'\\begin{footnotesize}\n');
        fprintf(fpscs,'\\begin{tabular}{|llrr|rr|rr|rr|}\n');

        fprintf(fpscs,'\\hline\n');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Post','Exp.','Hold','$\boldsymbol{\mathsf{E_{rev}}}$','Amp.','Diff.','$\boldsymbol{\mathsf{t_{10-90}}}$','Diff.','$\boldsymbol{\mathsf{\uptau_{decay}}}$','Diff.');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Type','Ref.','(mV)','(mV)','(pA,\textcolor{purple}{mV})','\%','(ms)','\%','(ms)','\%');
        fprintf(fpscs,'\\hline\n');
        unusedout=1;
        if isfield(allexppscs,celltype)
            pscsfields = fieldnames(allexppscs.(celltype));

            for c=1:length(pscsfields)
                posttype = pscsfields{c};
                z = strmatch(posttype,findNiceidx);
                postnice=celltypeNice{z};
                if isfield(expsyns,celltype) && isfield(expsyns(1).(celltype),posttype)
                    if strcmp(allexppscs.(celltype).(posttype).Clamp,expsyns(1).(celltype).(posttype).Clamp)==0 && length(expsyns)>1 && isempty(expsyns(2).(celltype).(posttype))==0
                        tc=2;
                    else
                        tc=1;
                    end
                    
                    if allexppscs.(celltype).(posttype).Holding ~= expsyns(tc).(celltype).(posttype).Holding
                        if strcmp(allexppscs.(celltype).(posttype).Clamp,'Current')==1
                            allexppscs.(celltype).(posttype).Holding = expsyns(tc).(celltype).(posttype).Holding;
                        else
                            disp(['Holding potentials for ' pretype ' -> ' celltype ' don''t match. Model: ' num2str(allexppscs.(celltype).(posttype).Holding) ', Experimental: ' num2str(expsyns(tc).(celltype).(posttype).Holding)])
                        end
                    end
                    if allexppscs.(celltype).(posttype).Reversal ~= expsyns(tc).(celltype).(posttype).Reversal
                        disp(['Reversal potentials for ' pretype ' -> ' celltype ' don''t match. Model: ' num2str(allexppscs.(celltype).(posttype).Reversal) ', Experimental: ' num2str(expsyns(tc).(celltype).(posttype).Reversal)])
                    end
                    try
                    AmpDiff = (allexppscs.(celltype).(posttype).Amplitude - expsyns(tc).(celltype).(posttype).Amplitude)/expsyns(tc).(celltype).(posttype).Amplitude*100;
                    if isfield(expsyns(1).(celltype).(posttype),'RiseTime')
                        RiseDiff = (allexppscs.(celltype).(posttype).RiseTime - expsyns(tc).(celltype).(posttype).RiseTime)/expsyns(tc).(celltype).(posttype).RiseTime*100;
                    else
                        RiseDiff = (allexppscs.(celltype).(posttype).Peak - expsyns(tc).(celltype).(posttype).Peak)/expsyns(tc).(celltype).(posttype).Peak*100;
                    end
                    if strcmp(allexppscs.(celltype).(posttype).Clamp,'Voltage')==1
                        DecayDiff = (allexppscs.(celltype).(posttype).DecayTau - expsyns(tc).(celltype).(posttype).DecayTau)/expsyns(tc).(celltype).(posttype).DecayTau*100;
                    else
                        DecayDiff = (allexppscs.(celltype).(posttype).HalfWidth - expsyns(tc).(celltype).(posttype).HalfWidth)/expsyns(tc).(celltype).(posttype).HalfWidth*100;
                    end
                    catch ME
                        ME
                    end
                    if strcmp(allexppscs.(celltype).(posttype).Clamp,'Voltage')==1
                        fprintf(fpscs,'%s & %s & %.1f & %.1f & %.2f & %+.1f & %.2f & %+.1f & %.2f & %+.1f \\\\ \n',postnice,strrep(expsyns(tc).(celltype).(posttype).ref,'and','\&'),allexppscs.(celltype).(posttype).Holding,allexppscs.(celltype).(posttype).Reversal,allexppscs.(celltype).(posttype).Amplitude,AmpDiff,allexppscs.(celltype).(posttype).RiseTime,RiseDiff,allexppscs.(celltype).(posttype).DecayTau,DecayDiff);
                    else
                        fprintf(fpscs,'%s & %s & %.1f & %.1f & \\textcolor{purple}{%.2f} &  \\textcolor{purple}{%+.1f} & \\textcolor{purple}{%.2f} & \\textcolor{purple}{%+.1f} & \\textcolor{purple}{%.2f} & \\textcolor{purple}{%+.1f} \\\\ \n',postnice,strrep(expsyns(tc).(celltype).(posttype).ref,'and','\&'),allexppscs.(celltype).(posttype).Holding,allexppscs.(celltype).(posttype).Reversal,allexppscs.(celltype).(posttype).Amplitude,AmpDiff,allexppscs.(celltype).(posttype).RiseTime,RiseDiff,allexppscs.(celltype).(posttype).DecayTau,DecayDiff);
                    end
                    fprintf(fpscs,'\\hline\n');
                    unusedout=0;
                else
%                     if strcmp(allexppscs.(celltype).(posttype).Clamp,'Voltage')==1
%                         fprintf(fpscs,'%s & n/a & %.1f & %.1f & %.2f &  & %.2f &  & %.2f &  \\\\ \n',postnice,allexppscs.(celltype).(posttype).Holding,allexppscs.(celltype).(posttype).Reversal,allexppscs.(celltype).(posttype).Amplitude,allexppscs.(celltype).(posttype).RiseTime,allexppscs.(celltype).(posttype).DecayTau);
%                     else
%                         fprintf(fpscs,'%s & n/a & %.1f & %.1f &  & \textcolor{purple}{%.2f} &  & %.2f & \textcolor{purple}{%.2f} &  \\\\ \n',postnice,allexppscs.(celltype).(posttype).Holding,allexppscs.(celltype).(posttype).Reversal,allexppscs.(celltype).(posttype).Amplitude,allexppscs.(celltype).(posttype).RiseTime,allexppscs.(celltype).(posttype).DecayTau);
%                     end
                end
            end
        end
        fprintf(fpscs,'\\end{tabular}\n');
%         fprintf(fpscs,'\\caption[%s Outgoing Experimental Comparison]{Where experimental data exist for connections from %s cells, compare the experimental and model connections under the same conditions.}\n',nicecell, nicecell);
%         fprintf(fpscs,'\\label{tab:%sOutExpComp}\n',cellabbr);
%         fprintf(fpscs,'\\end{sidewaystable}\n');
        fprintf(fpscs,'\\end{footnotesize}\n');
        fclose(fpscs);
        if unusedout
            fpscs=fopen([pdfpath sl cellabbr 'OutExpTable.tex'],'w');
            fprintf(fpscs,'\\noindent \\textit{ Note: No experimental constraints available for outgoing synapses from %s cells to other cells.}\\\\\n',nicecellfull);
            fclose(fpscs);
        end

        fpscs=fopen([pdfpath sl cellabbr 'OutSynTable.tex'],'w');
        fprintf(fpscs,'\\begin{table}[position htb]\n');
        fprintf(fpscs,'\\centering\n');
        fprintf(fpscs,'\\begin{tabular}{|lrrrr|}\n');

        fprintf(fpscs,'\\hline\n');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Post','$\boldsymbol{\mathsf{E_{rev}}}$','$\boldsymbol{\mathsf{G_{max}}}$','$\boldsymbol{\mathsf{\uptau_{rise}}}$','$\boldsymbol{\mathsf{\uptau_{decay}}}$');
        fprintf(fpscs,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Type','(mV)','(nS)','(ms)','(ms)');
        fprintf(fpscs,'\\hline\n');

        pscsfields = fieldnames(allconns.(celltype));

        for c=1:length(pscsfields)
            posttype = pscsfields{c};
            z = strmatch(posttype,findNiceidx);
            postnice=celltypeNice{z};
            try
            fprintf(fpscs,'%s & %.1f & %.3e & %.2f & %.2f\\\\ \n',postnice,allconns.(celltype).(posttype).Reversal,allconns.(celltype).(posttype).Weight,allconns.(celltype).(posttype).Tau1,allconns.(celltype).(posttype).Tau2);
            catch
            fprintf(fpscs,'%s & %.1f & %.3e & %.2f & %.2f\\\\ \n',postnice,allconns.(celltype).(posttype).Reversal,allconns.(celltype).(posttype).Weight,allconns.(celltype).(posttype).Tau1{:},allconns.(celltype).(posttype).Tau2);
            end
            fprintf(fpscs,'\\hline\n');
        end
        fprintf(fpscs,'\\end{tabular}\n');
        fprintf(fpscs,'\\caption[%s Outgoing Synapses]{Properties of synapses made by %s cells onto other cells.}\n',nicecell, nicecell);
        fprintf(fpscs,'\\label{tab:%sOutSynProp}\n',cellabbr);
        fprintf(fpscs,'\\end{table}\n');
        fclose(fpscs);

        %%% PSC Figure:
        %///////////
        %printeps(gcf,[pdfpath sl cellabbr 'InPhysGraph.eps'])
        figure('Color','w','Units','inches','PaperUnits','inches','PaperSize',[3 3],'PaperPosition',[.5 .5 3 3],'Position',[.5 .5 3 3])
        for c=1:length(pscsfields) %tracefields used to be here - why??
            posttype = pscsfields{c};
            if isfield(traces.(celltype), posttype)
                plot(traces.(celltype).(posttype).Time,traces.(celltype).(posttype).Trace*1000,'Color',colorstruct.(posttype(1:end-4)).color,'LineWidth',2)
                hold on
            end
        end
        xlabel('Time (ms)')
        ylabel('Postsynaptic Current (pA)')
        title([nicecell ' Connections onto Other Cells'])
        bf = findall(gcf,'Type','text');
        for b=1:length(bf)
            set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
        end
        bf = findall(gcf,'Type','axis');
        for b=1:length(bf)
            set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
        end
        if strcmp('ngfcell',celltype)
            xlim([100 200])
        else
            xlim([113 152])
        end
        printeps(gcf,[pdfpath sl cellabbr 'OutPhysGraph'])

        % divergence  (table and figure)

        
        %%% Combined Conv and Div figure:
        fdiv=fopen([pdfpath sl cellabbr 'ConvDivTable.tex'],'w');
        fprintf(fpscs,'\\begin{footnotesize}\n');
        fprintf(fdiv,'\\begin{tabular}{|l|rrrl||rrrl|}\n');

        fprintf(fdiv,'\\hline\n');
        fprintf(fdiv,'  & \\multicolumn{4}{|c||}{Other Cell to %s} & \\multicolumn{4}{|c|}{%s to Other Cell} \\\\ \n', nicecell, nicecell);
        fprintf(fdiv,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Other','\#','Syn.s','\#','Post','\#','Syn.s','\#','Post');
        fprintf(fdiv,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Type','Conn.s','/Conn.','\#','Loc.','Conn.s','/Conn.','\#','Loc.');
        fprintf(fdiv,'\\hline\n');
           
        for c=1:length(allcelltypes)
            if (isfield(conns,allcelltypes{c}) && isfield(conns.(allcelltypes{c}),celltype)) || isfield(conns.(celltype),allcelltypes{c})
                z = strmatch(allcelltypes{c},findNiceidx);
                typenice=celltypeNice{z};
                fprintf(fdiv,'\\textbf{%s} & ',typenice)
                if isfield(conns,allcelltypes{c}) && isfield(conns.(allcelltypes{c}),celltype)
                    pretype=allcelltypes{c};
                    fprintf(fdiv,'%d & %d & %d & %s & ',conns.(pretype).(celltype).Conns,conns.(pretype).(celltype).SynsPerConn,conns.(pretype).(celltype).Syns,getloc(conns.(pretype).(celltype).Location));
                else
                    fprintf(fdiv,' &  &  &  & ');
                end
                if isfield(conns.(celltype),allcelltypes{c})
                    posttype=allcelltypes{c};
                    tmpconns=round(conns.(celltype).(posttype).Conns*allcells.(posttype).NumCells/allcells.(celltype).NumCells);
                    fprintf(fdiv,'%d & %d & %d & %s \\\\ \n',tmpconns,conns.(celltype).(posttype).SynsPerConn,floor(conns.(celltype).(posttype).Syns*allcells.(posttype).NumCells/allcells.(celltype).NumCells),getloc(conns.(celltype).(posttype).Location));
                else
                    fprintf(fdiv,' &  &  & \\\\ \n');
                end
                fprintf(fdiv,'\\hline\n');
            end
        end
        fprintf(fdiv,'\\end{tabular}\n');
        fprintf(fdiv,'\\end{footnotesize}\n');
        fclose(fdiv);
        
        %%% Div Table:
        fdiv=fopen([pdfpath sl cellabbr 'DivergenceTable.tex'],'w');
        fprintf(fdiv,'\\begin{table}[position htb]\n');
        fprintf(fdiv,'\\centering\n');
        fprintf(fdiv,'\\begin{tabular}{|lrrrl|}\n');

        fprintf(fdiv,'\\hline\n');
        fprintf(fdiv,'\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n','Post Type','\# Conn.s','Syn.s/Conn.','\# Syn.s','Location');
        fprintf(fdiv,'\\hline\n');
    
        connsfields = fieldnames(conns.(celltype));

        for c=1:length(connsfields)
            posttype = connsfields{c};
            z = strmatch(posttype,findNiceidx);
            postnice=celltypeNice{z};
            tmpconns=round(conns.(celltype).(posttype).Conns*allcells.(posttype).NumCells/allcells.(celltype).NumCells);
            fprintf(fdiv,'%s & %d & %d & %d & %s \\\\ \n',postnice,tmpconns,conns.(celltype).(posttype).SynsPerConn,floor(conns.(celltype).(posttype).Syns*allcells.(posttype).NumCells/allcells.(celltype).NumCells),getloc(conns.(celltype).(posttype).Location));
            fprintf(fdiv,'\\hline\n');
        end
    fprintf(fdiv,'\\end{tabular}\n');
    fprintf(fdiv,'\\caption[%s Divergence]{Divergence of %s cell connections onto other cells.}\n',nicecell, nicecell);
    fprintf(fdiv,'\\label{tab:%sCellDiv}\n',cellabbr);
    fprintf(fdiv,'\\end{table}\n');
    fclose(fdiv);
    end
    %%% Div Figure:
    % maybe don't need anything extra for this
end

function betloc=getloc(location)

switch lower(location)
    case 'dendrite_list'
        betloc='any dendrite';
    case 'apical_list'
        betloc='apical dendrite';
    case 'basal_list'
        betloc='basal dendrite';
    case 'axon_list'
        betloc='axon';
    case 'soma_list'
        betloc='soma';
    otherwise
        betloc=strrep(location,'_','\_');
end