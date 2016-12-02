function print_website(pathway,allcells,allpscs,allchans,allephys,allconns,alltraces,allexppscs)

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
    if exist([pathway sl 'cells' sl celltype],'dir')==0
        mkdir([pathway sl 'cells' sl celltype])
    else
        system(['rm ' pathway sl 'cells' sl celltype sl '*.txt'])
    end
    
    if isfield(allephys,celltype) && strcmp(allcells.(celltype).Type,'real')==1
        %mymorph = allmorphs.(celltype);
        %chans = allchans.(celltype);
        ephys = allephys.(celltype);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % print out all cell info:

%         % % morphology (table and images of different parts on cell)
% 
%         %%% Morph Table:
%         morphfile=sprintf('cells\\%s\\morphtable.txt', celltype);
%         fmorph = fopen([pathway morphfile],'w');
% 
%         morphsections = fieldnames(mymorph); %{'All','Soma','Dendrite','Basal','Apical','Axon'};
%         for x=1:length(morphsections)
%             fprintf(fmorph,'%s,%0.1f,%0.1f,%0.2f\n',morphsections{x},mymorph.(morphsections{x}).Area,mymorph.(morphsections{x}).Length,mymorph.(morphsections{x}).Diam)
%         end
%         fclose(fmorph);
% 
%         %%% Morph Figures:
%         %///////////
%         for x=1:length(morphsections)
%             [pathway 'cells\\' celltype '\\' morphsections{x} '.png'];
%         end

        % ephys properties (table and some figures - experimentaldata things)

        %%% ephys Properties:
        %///////////
%         ephysfile=sprintf('cells\\%s\\ephystable.txt', celltype);
%         fephys = fopen([pathway sl ephysfile],'w');
% 
%         ephysprops = fieldnames(ephys); %{'RMP','Rinput','Cm','Tau','Rm'}; % % get some more from the experimentaldata, too
%         for x=1:length(ephysprops)
%             fprintf(fephys,'%s,%0.2f,%s,%s\n',ephysprops{x},ephys.(ephysprops{x}).Value,ephys.(ephysprops{x}).Units,ephys.(ephysprops{x}).Desc)
%         end
%         fclose(fephys);

        %%% ephys Figure:
        %///////////
        ephysimage = {'Current_sweep','Firing_frequency','Steady_state_potential','Sag_amplitude','Sag_timing','Max_depolarization','Max_hyperpolarization'};



        % ion channel expression levels   (table and images of expression)

        %%% Ion Channel Table:
        %///////////
        chanfile=sprintf('cells\\%s\\channeltable.txt', celltype);
        fchan = fopen([pathway sl 'cells' sl celltype sl 'channeltable.txt'],'w');

        if isfield(allchans,celltype)
        channels = fieldnames(allchans.(celltype)); %{'Nav','Kdr','CavL','HCN','leak'};
        for x=1:length(channels)
            fprintf(fchan,'%s,%0.4f,%0.0f,%s,%s\n',channels{x},allchans.(celltype).(channels{x}).Gmax,allchans.(celltype).(channels{x}).Erev,allchans.(celltype).(channels{x}).Loc,allchans.(celltype).(channels{x}).Desc)
        end
        fclose(fchan);
        end
% 
% 
% 
%         %%% Ion Channel Images:
%         %///////////
%         for x=1:length(channels)
%             [pathway 'cells\\' celltype '\\' channels{x} '.png'];
%         end

        % incoming connectivity

        % % PSCs  (table and figure)

        %%% PSC Table:
        % Model Synapses, Physiological Conditions
        % Presynaptic cell, holding potential, reversal potential, amplitude, rise time, decay tau

        pscsfile=sprintf('cells%s%s%sinephys.txt', sl, celltype, sl);
        fpscs = fopen([pathway sl pscsfile],'w');
        pscsfields = fieldnames(pscs);

        for c=1:length(pscsfields)
            pretype = pscsfields{c};
            if isfield(pscs.(pretype),celltype)
                fprintf(fpscs,'%s,%.1f,%.1f,%.2f,%.2f,%.2f\n',pretype,pscs.(pretype).(celltype).Holding,pscs.(pretype).(celltype).Reversal,pscs.(pretype).(celltype).Amplitude,pscs.(pretype).(celltype).RiseTime,pscs.(pretype).(celltype).DecayTau);
            end
        end
        fclose(fpscs);

        pscsfile=sprintf('cells%s%s%sinephyscomp.txt', sl, celltype, sl);
        fpscs = fopen([pathway sl pscsfile],'w');
        pscsfields = fieldnames(allexppscs);

        for c=1:length(pscsfields)
            pretype = pscsfields{c};
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
                    if strcmp(allexppscs.(pretype).(celltype).Clamp,'Voltage')==1
                        DecayDiff = (allexppscs.(pretype).(celltype).DecayTau - expsyns(tc).(pretype).(celltype).DecayTau)/expsyns(tc).(pretype).(celltype).DecayTau*100;
                    else
                        try
                        DecayDiff = (allexppscs.(pretype).(celltype).HalfWidth - expsyns(tc).(pretype).(celltype).HalfWidth)/expsyns(tc).(pretype).(celltype).HalfWidth*100;
                        catch
                            'm'
                        end
                    end
                    if strcmp(allexppscs.(pretype).(celltype).Clamp,'Voltage')==1
                        fprintf(fpscs,'%s,%s,%.1f,%.1f,%.2f (%+.1f%%),%.2f (%+.1f%%),%.2f (%+.1f%%)\n',pretype,expsyns(tc).(pretype).(celltype).ref,allexppscs.(pretype).(celltype).Holding,allexppscs.(pretype).(celltype).Reversal,allexppscs.(pretype).(celltype).Amplitude,AmpDiff,allexppscs.(pretype).(celltype).RiseTime,RiseDiff,allexppscs.(pretype).(celltype).DecayTau,DecayDiff);
                    else
                        fprintf(fpscs,'%s,%s,%.1f,%.1f,<span style="color: purple;">%.2f (%+.1f%%)</span>,%.2f (%+.1f%%),<span style="color: purple;">%.2f (%+.1f%%)</span>\n',pretype,expsyns(1).(pretype).(celltype).ref,allexppscs.(pretype).(celltype).Holding,allexppscs.(pretype).(celltype).Reversal,allexppscs.(pretype).(celltype).Amplitude,AmpDiff,allexppscs.(pretype).(celltype).RiseTime,RiseDiff,allexppscs.(pretype).(celltype).DecayTau,DecayDiff);
                    end
                else                   
                    if strcmp(allexppscs.(pretype).(celltype).Clamp,'Voltage')==1
                        fprintf(fpscs,'%s,n/a,%.1f,%.1f,%.2f,%.2f,%.2f\n',pretype,allexppscs.(pretype).(celltype).Holding,allexppscs.(pretype).(celltype).Reversal,allexppscs.(pretype).(celltype).Amplitude,allexppscs.(pretype).(celltype).RiseTime,allexppscs.(pretype).(celltype).DecayTau);
                    else
                        fprintf(fpscs,'%s,n/a,%.1f,%.1f,<span style="color: purple;">%.2f</span>,%.2f,<span style="color: purple;">%.2f</span>\n',pretype,allexppscs.(pretype).(celltype).Holding,allexppscs.(pretype).(celltype).Reversal,allexppscs.(pretype).(celltype).Amplitude,allexppscs.(pretype).(celltype).RiseTime,allexppscs.(pretype).(celltype).DecayTau);
                    end
                end
            end
        end
        fclose(fpscs);

        pscsfile=sprintf('cells%s%s%sinephysprop.txt', sl, celltype, sl);
        fpscs = fopen([pathway sl pscsfile],'w');
        pscsfields = fieldnames(allconns);

        for c=1:length(pscsfields)
            pretype = pscsfields{c};
            if isfield(pscs.(pretype),celltype)
                try
                fprintf(fpscs,'%s,%s,%.1f,%.3e,%.2f,%.2f\n',pretype,allconns.(pretype).(celltype).Location,allconns.(pretype).(celltype).Reversal,allconns.(pretype).(celltype).Weight,allconns.(pretype).(celltype).Tau1,allconns.(pretype).(celltype).Tau2);
                catch me
                fprintf(fpscs,'%s,%s,%.1f,%.3e,%.2f,%.2f\n',pretype,allconns.(pretype).(celltype).Location,allconns.(pretype).(celltype).Reversal,allconns.(pretype).(celltype).Weight,allconns.(pretype).(celltype).Tau1{:},allconns.(pretype).(celltype).Tau2);
                end
            end
        end
        fclose(fpscs);
        
        

        %%% PSC Figure:
        %///////////
        tracefile=sprintf('cells%s%s%stestEphysIn.txt', sl, celltype, sl);
        ftrace = fopen([pathway sl tracefile],'w');
        tracefields = fieldnames(traces);

        for c=1:length(tracefields)
            pretype = tracefields{c};
            if isfield(traces.(pretype), celltype)
                xstring = sprintf('%0.5f,',traces.(pretype).(celltype).Time(1:skipme:end)); % concatenate times together, separated by commas
                ystring = sprintf('%0.5f,',traces.(pretype).(celltype).Trace(1:skipme:end)); % concatenate PSP values together, separated by commas
                fprintf(ftrace,'%s,%s\n',pretype,xstring(1:end-1));
                fprintf(ftrace,'%s,%s\n',pretype,ystring(1:end-1));
            end
        end

        fclose(ftrace);


        % % convergence  (table and figure)

        %%% Conv Table:
        convfile=sprintf('cells%s%s%sconvergence.txt', sl, celltype, sl);
        fconv = fopen([pathway sl convfile],'w');
        connsfields = fieldnames(conns);

        for c=1:length(connsfields)
            pretype = connsfields{c};
            if isfield(conns.(pretype),celltype)
                fprintf(fconv,'%s,%d,%d,%d,%s\n',pretype,conns.(pretype).(celltype).Conns,conns.(pretype).(celltype).SynsPerConn,conns.(pretype).(celltype).Syns,conns.(pretype).(celltype).Location);
            end
        end
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
        pscsfile=sprintf('cells%s%s%soutephys.txt', sl, celltype, sl);
        fpscs = fopen([pathway sl pscsfile],'w');
        pscsfields = fieldnames(pscs.(celltype));

        for c=1:length(pscsfields)
            posttype = pscsfields{c};
            fprintf(fpscs,'%s,%.1f,%.1f,%.2f,%.2f,%.2f\n',posttype,pscs.(celltype).(posttype).Holding,pscs.(celltype).(posttype).Reversal,pscs.(celltype).(posttype).Amplitude,pscs.(celltype).(posttype).RiseTime,pscs.(celltype).(posttype).DecayTau);
        end
        fclose(fpscs);

        pscsfile=sprintf('cells%s%s%soutephyscomp.txt', sl, celltype, sl);
        fpscs = fopen([pathway sl pscsfile],'w');
        if isfield(allexppscs,celltype)
            pscsfields = fieldnames(allexppscs.(celltype));

            for c=1:length(pscsfields)
                posttype = pscsfields{c};
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
                        fprintf(fpscs,'%s,%s,%.1f,%.1f,%.2f (%+.1f%%),%.2f (%+.1f%%),%.2f (%+.1f%%)\n',posttype,expsyns(tc).(celltype).(posttype).ref,allexppscs.(celltype).(posttype).Holding,allexppscs.(celltype).(posttype).Reversal,allexppscs.(celltype).(posttype).Amplitude,AmpDiff,allexppscs.(celltype).(posttype).RiseTime,RiseDiff,allexppscs.(celltype).(posttype).DecayTau,DecayDiff);
                    else
                        fprintf(fpscs,'%s,%s,%.1f,%.1f,<span style="color: purple;">%.2f (%+.1f%%)</span>,%.2f (%+.1f%%),<span style="color: purple;">%.2f (%+.1f%%)</span>\n',posttype,expsyns(tc).(celltype).(posttype).ref,allexppscs.(celltype).(posttype).Holding,allexppscs.(celltype).(posttype).Reversal,allexppscs.(celltype).(posttype).Amplitude,AmpDiff,allexppscs.(celltype).(posttype).RiseTime,RiseDiff,allexppscs.(celltype).(posttype).DecayTau,DecayDiff);
                    end
                else
                    if strcmp(allexppscs.(celltype).(posttype).Clamp,'Voltage')==1
                        fprintf(fpscs,'%s,n/a,%.1f,%.1f,%.2f,%.2f,%.2f\n',posttype,allexppscs.(celltype).(posttype).Holding,allexppscs.(celltype).(posttype).Reversal,allexppscs.(celltype).(posttype).Amplitude,allexppscs.(celltype).(posttype).RiseTime,allexppscs.(celltype).(posttype).DecayTau);
                    else
                        fprintf(fpscs,'%s,n/a,%.1f,%.1f,<span style="color: purple;">%.2f</span>,%.2f,<span style="color: purple;">%.2f</span>\n',posttype,allexppscs.(celltype).(posttype).Holding,allexppscs.(celltype).(posttype).Reversal,allexppscs.(celltype).(posttype).Amplitude,allexppscs.(celltype).(posttype).RiseTime,allexppscs.(celltype).(posttype).DecayTau);
                    end
                end
            end
        end
        fclose(fpscs);

        pscsfile=sprintf('cells%s%s%soutephysprop.txt', sl, celltype, sl);
        fpscs = fopen([pathway sl pscsfile],'w');
        pscsfields = fieldnames(allconns.(celltype));

        for c=1:length(pscsfields)
            posttype = pscsfields{c};
            try
            fprintf(fpscs,'%s,%s,%.1f,%.3e,%.2f,%.2f\n',posttype,allconns.(celltype).(posttype).Location,allconns.(celltype).(posttype).Reversal,allconns.(celltype).(posttype).Weight,allconns.(celltype).(posttype).Tau1,allconns.(celltype).(posttype).Tau2);
            catch
            fprintf(fpscs,'%s,%s,%.1f,%.3e,%.2f,%.2f\n',posttype,allconns.(celltype).(posttype).Location,allconns.(celltype).(posttype).Reversal,allconns.(celltype).(posttype).Weight,allconns.(celltype).(posttype).Tau1{:},allconns.(celltype).(posttype).Tau2);
            end
        end
        fclose(fpscs);

        %%% PSC Figure:
        %///////////
        tracefile=sprintf('cells%s%s%stestEphysOut.txt', sl , celltype, sl);
        ftrace = fopen([pathway sl tracefile],'w');
        tracefields = fieldnames(traces.(celltype));

        for c=1:length(pscsfields) %tracefields used to be here - why??
            posttype = pscsfields{c};
            if isfield(traces.(celltype), posttype)
                xstring = sprintf('%0.5f,',traces.(celltype).(posttype).Time(1:skipme:end)); % concatenate times together, separated by commas
                ystring = sprintf('%0.5f,',traces.(celltype).(posttype).Trace(1:skipme:end)); % concatenate PSP values together, separated by commas
                fprintf(ftrace,'%s,%s\n',posttype,xstring(1:end-1));
                fprintf(ftrace,'%s,%s\n',posttype,ystring(1:end-1));
            end
        end

        fclose(ftrace);

        % % divergence  (table and figure)

        %%% Div Table:
        divfile=sprintf('cells%s%s%sdivergence.txt', sl , celltype, sl);
        fdiv = fopen([pathway sl divfile],'w');
        connsfields = fieldnames(conns.(celltype));

        for c=1:length(connsfields)
            posttype = connsfields{c};
            tmpconns=round(conns.(celltype).(posttype).Conns*allcells.(posttype).NumCells/allcells.(celltype).NumCells);
            fprintf(fdiv,'%s,%d,%d,%d,%s\n',posttype,tmpconns,conns.(celltype).(posttype).SynsPerConn,floor(conns.(celltype).(posttype).Syns*allcells.(posttype).NumCells/allcells.(celltype).NumCells),conns.(celltype).(posttype).Location);
        end
        fclose(fdiv);
    end
    %%% Div Figure:
    % maybe don't need anything extra for this
end