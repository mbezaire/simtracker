function getpdfdata(handles,pathway,repotype,varargin) % channel % phys syns % exp syns
if ispc
    sl='\';
else
    sl='/';
end

repospath = repotype.repospath;
repo = repotype.repo;
publication = repotype.publication;
publink = repotype.publink;
NumData = repotype.NumData;
ConnData = repotype.ConnData;
SynData = repotype.SynData;
RunName = repotype.RunName;

if 1==0
pictype = 'jpg';
system(['cp ' repospath sl 'results' sl RunName sl RunName '_Spike_Raster.' pictype ' ' pathway sl 'networks' sl 'output.' pictype]);
system(['cp ' repospath sl 'results' sl RunName sl RunName '_Spike_Raster.' pictype ' ' pathway sl 'networks' sl 'input.' pictype]);

fid = fopen([repospath sl 'results' sl RunName sl 'sumnumout.txt']);
for r=1:3
    eval(fgetl(fid));
end
fclose(fid);

if exist([repospath sl 'cellclamp_results' sl 'website'],'dir')==0
    mkdir([repospath sl 'cellclamp_results' sl 'website']);
end

if 1==0
if exist([repospath sl 'cellclamp_results' sl 'website' sl 'traces.mat'],'file')==0
end
if exist([repospath sl 'cellclamp_results' sl 'website' sl 'exptraces.mat'],'file')==0
end
if exist([repospath sl 'cellclamp_results' sl 'website' sl 'morph.dat'],'file')==0
    fid = fopen([repospath sl 'cellclamp_results' sl 'website' sl 'morph.dat'],'w');
    fprintf(fid,'%d\n',numlines)
    for c=1:numlines
        fprintf(fid,'%s\t%s\t%f\t%f\t%f\n', celltype, section, area, length, diam)
        % ivycell Apical 1200 10 .6
    end
    fclose(fid);
end
if exist([repospath sl 'cellclamp_results' sl 'website' sl 'ephysdata.dat'],'file')==0
    fid = fopen([repospath sl 'cellclamp_results' sl 'website' sl 'ephysdata.dat'],'w');
    fprintf(fid,'%d\n',numlines)
    for c=1:numlines
        fprintf(fid,'%s\t%s\t%f\t%f\t%s\t%s\n', celltype, prop, propval, propdev, units, propdesc)
        % pyramidalcell RMP -70 0 mV "Resting Membrane Potential"
    end
    fclose(fid);
end
if exist([repospath sl 'cellclamp_results' sl 'website' sl 'channels.dat'],'file')==0
        fid = fopen([repospath sl 'cellclamp_results' sl 'website' sl 'channels.dat'],'w');
        fprintf(fid,'%d\n',numlines)
        for c=1:numlines
            fprintf(fid,'%s\t%s\t%f\t%d\t%s\t%s\n', celltype, channame, cond, revpot, section, desc)
        end
        fclose(fid);
    % pyramidalcell	Nav	0.001	55	soma	"Voltage gated sodium channel"
end
  
end
end

fid = fopen([repospath sl 'datasets' sl 'cellnumbers_' num2str(NumData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);

allcelltypes = filedata{1};
allrealtypes=allcelltypes(filedata{5}==0);

usedchans={};
for ac=1:length(filedata{2})
    [r, s]=system(['grep -o  "insert[[:space:]]ch_[a-zA-Z0-9]\+" ' repospath sl 'cells' sl 'class_' filedata{2}{ac} '.hoc']);
    tmpchans=regexp(strtrim(s),'\n','split');
    for t=1:length(tmpchans)
        tmpchans{t}=strtrim(strrep(strrep(tmpchans{t},'insert',''),'ch_',''));
    end
    if (~isempty(tmpchans) && iscell(tmpchans)==0) || (~isempty(tmpchans{1}))
        try
            usedchans=[usedchans; tmpchans];
        catch ME
            usedchans=[usedchans(:); tmpchans(:)];
        end
    end
end
%if 1==0
%if ~isempty(varargin)
    %if ~isempty(varargin{1})
        % d = dir([repospath '\ch_*.mod']);
        
        if 1==0 && exist([repospath sl 'cellclamp_results' sl 'website' sl 'channeldata.mat'],'file')
            load([repospath sl 'cellclamp_results' sl 'website' sl 'channeldata.mat']);
        end

%        allchanresults = varargin{1}; % eval(['[' varargin{1} ']']); % {'425','426','427'};
%         for acr = 1:length(allchanresults)
%             mychanresults = allchanresults{acr};
%             dchan = dir([repospath sl 'cellclamp_results' sl mychanresults sl 'clamp']);
%             dchan = {dchan([dchan(:).isdir]==1).name};
%             dchan = dchan(3:end);
%             
%             dchan = sort(dchan);
%             dchan=intersect(usedchans,dchan);
% 
%             for z=1:length(dchan)
%                 chan = dchan{z}; % d(z).name(4:end-4);
% 
%                 load([repospath sl 'cellclamp_results' sl mychanresults sl 'clamp' sl chan sl 'results.mat']);
% 
%                 chantraces.(chan).Activation.Voltage = results.act.x;
%                 chantraces.(chan).Activation.Response = results.act.y;
%                 chantraces.(chan).Activation.Label = results.act.ylabel;
% 
%                 chantraces.(chan).Inactivation.Voltage = results.inact.x;
%                 chantraces.(chan).Inactivation.Response = results.inact.y;
%                 chantraces.(chan).Inactivation.Label = results.inact.ylabel;
% 
%                 chantraces.(chan).IVPeak.Voltage = results.ivpeak.x;
%                 chantraces.(chan).IVPeak.Response = results.ivpeak.y;
%                 chantraces.(chan).IVPeak.Label = results.ivpeak.ylabel;
% 
%                 chantraces.(chan).IVSteady.Voltage = results.ivsteady.x;
%                 chantraces.(chan).IVSteady.Response = results.ivsteady.y;
%                 chantraces.(chan).IVSteady.Label = results.ivsteady.ylabel;
% 
%                 allchannels.(chan).FileName = ['ch_' dchan{z} '.mod'];
%                 allchannels.(chan).Description = 'Description';
%                 allchannels.(chan).Ind = z;
% 
%                 idd = find(chantraces.(chan).Activation.Response>=.5,1,'first');
% 
%                 n=1;
%                 chanephys.(chan)(n).Prop = 'Half Activation';
%                 chanephys.(chan)(n).Value = chantraces.(chan).Activation.Voltage(idd);
%                 chanephys.(chan)(n).Units = 'mV';
%                 chanephys.(chan)(n).Desc = 'Voltage at which conductance is half of the maximum';
% 
%                 n=1;
%                 expephys.(chan)(n).Prop = 'Gmax';
%                 expephys.(chan)(n).Value = results.gmax;
%                 expephys.(chan)(n).Units = 'S/cm^2';
%                 expephys.(chan)(n).Desc = 'Density of ion channel expression';
% 
%                 n=n+1;
%                 expephys.(chan)(n).Prop = 'Soma Diameter';
%                 expephys.(chan)(n).Value = results.dim;
%                 expephys.(chan)(n).Units = 'um';
%                 expephys.(chan)(n).Desc = 'Diameter and length of the cylindrical compartment';
% 
%                 n=n+1;
%                 expephys.(chan)(n).Prop = 'Erev';
%                 expephys.(chan)(n).Value = results.erev;
%                 expephys.(chan)(n).Units = 'mV';
%                 expephys.(chan)(n).Desc = 'Reversal potential of the channel';
% 
%                 n=n+1;
%                 expephys.(chan)(n).Prop = 'Temperature';
%                 expephys.(chan)(n).Value = results.temp;
%                 expephys.(chan)(n).Units = '^o C';
%                 expephys.(chan)(n).Desc = 'Temperature in celsius at which model simulation was conducted';
% 
%                 n=n+1;
%                 expephys.(chan)(n).Prop = 'Axial Resistance';
%                 expephys.(chan)(n).Value = results.ra;
%                 expephys.(chan)(n).Units = 'ohm*cm';
%                 expephys.(chan)(n).Desc = 'Resistance of the cytoplasm';
% 
%                 n=n+1;
%                 expephys.(chan)(n).Prop = 'Membrane Capacitance';
%                 expephys.(chan)(n).Value = results.cm;
%                 expephys.(chan)(n).Units = 'uF/cm^2';
%                 expephys.(chan)(n).Desc = 'Capacitance of the membrane';
% 
%                 n=n+1;
%                 expephys.(chan)(n).Prop = 'Calcium concentration';
%                 expephys.(chan)(n).Value = results.Ca;
%                 expephys.(chan)(n).Units = '[Ca2+]_i (mM)';
%                 expephys.(chan)(n).Desc = 'Intracellular calcium concentration';
%             end
%         end
        if exist([repospath sl 'cellclamp_results' sl 'website' sl 'channels.dat'],'file')==0
            % run NEURON code to regenerate this file...
            fid = fopen([repospath sl 'setupfiles' sl 'clamp' sl 'icell.dat'], 'w');

            % write the number of cells
            fprintf(fid, '%g\n', length(allrealtypes));
            % write each cell on its own line
            fprintf(fid, '%s\n', allrealtypes{:});
            % close the file
            fclose(fid);

            mysl=sl;
            excmdstr=['cd ' repospath handles.dl ...
                ' ' handles.general.neuron ' -c mytstop=1100 -c duration=1000 -c starttime=50 -c cellmechs=1 '];
            insertstring='';
            if ispc
                insertstring=[insertstring ' -c "strdef resultspath" -c resultspath="\"' 'cellclamp_results' strrep(strrep([sl 'website'],'\','/'),'C:','/cygdrive/c') '\""'];
            else
                insertstring=[insertstring ' -c "strdef resultspath" -c resultspath="\"' 'cellclamp_results' sl 'website' '\""'];
            end
            insertstring=[insertstring ' -c NumData=' num2str(NumData) ' -c ConnData=' num2str(ConnData) ' -c SynData=' num2str(SynData) ' '];
            if ispc
                insertstring=[insertstring ' -c "strdef toolpath" -c toolpath="\"' strrep(strrep([mypath sl],'\','/'),'C:','/cygdrive/c') 'tools\""'];
            else
                insertstring=[insertstring ' -c "strdef toolpath" -c toolpath="\"' mypath sl 'tools\""'];
            end
            if ispc
                insertstring=[insertstring ' -c "strdef relpath" -c relpath="\"' strrep(strrep(repospath,'\','/'),'C:','/cygdrive/c') '\"" -c "strdef sl" -c sl="\"' strrep(strrep(mysl,'\','/'),'C:','/cygdrive/c') ' \"" '];
            else
                insertstring=[insertstring ' -c "strdef relpath" -c relpath="\"' repospath '\"" -c "strdef sl" -c sl="\"/ \"" '];
            end
            cmdstr=[ excmdstr insertstring  ' .' strrep(mysl,'\','/') 'setupfiles' strrep(mysl,'\','/') 'clamp' strrep(mysl,'\','/') 'electrophys.hoc -c "quit()"' ];



            system(cmdstr);
        end
        
        mychans={};
        myvals=[];
        indc=1;
        for a=1:length(allrealtypes)
            grr=importdata([repospath sl 'cellclamp_results' sl 'website' sl 'celldata_' allrealtypes{a} '.dat']);
            for g=2:size(grr.textdata,2)
                if length(grr.textdata{1,g})>5 && strcmp(grr.textdata{1,g}(1:8),'gmax_ch_')
                    mychans{indc}=grr.textdata{1,g}(9:end); % channel
                    myvals(indc)=max(grr.data(:,g-1)); % gmax
                    allchans.(allrealtypes{a}).(mychans{indc}).Gmax = myvals(indc);
                    indc=indc+1;
                end
            end
        end
        
        if 1==0
        fid = fopen([repospath sl 'cellclamp_results' sl 'website' sl 'channels.dat'],'r');
        numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
        chanfiledata = textscan(fid,'%s\t%s\t%f\t%f\t%s\t%q\n') ; % celltype channel gmax erev loc desc
        fclose(fid);

        for x=1:length(chanfiledata{1})
            allchans.(chanfiledata{1}{x}).(chanfiledata{2}{x}).Gmax = chanfiledata{3}(x);
            allchans.(chanfiledata{1}{x}).(chanfiledata{2}{x}).Erev = chanfiledata{4}(x);
            allchans.(chanfiledata{1}{x}).(chanfiledata{2}{x}).Loc = strrep(chanfiledata{5}{x},',',';');
            allchans.(chanfiledata{1}{x}).(chanfiledata{2}{x}).Desc = chanfiledata{6}{x};
        end
        end
        
%         print_channels(pathway,allchannels,chanephys,chantraces,allchans,expephys);
% 
%         save([repospath sl 'cellclamp_results' sl 'website' sl 'channeldata.mat'],'chantraces','allchans','allchannels','chanephys','expephys','-v7.3')
%         
%         allchantypes = fieldnames(allchannels);
% 
%         for ac = 1:length(allchantypes)
%             fid = fopen([repospath sl 'ch_' allchantypes{ac} '.mod'],'r');
%             tt = 1;
%             zidx=[];
%             try
%                 while 1
%                     tmptt = fgetl(fid);
%                     if ~ischar(tmptt), break, end
%                     tline{tt} = tmptt;
%                     if ~isempty(strfind(tline{tt},'COMMENT'))
%                         zidx = [zidx tt];
%                     end
%                     tt = tt + 1;
%                 end
%                 fclose(fid);
%             catch
%                 disp(['channel ' allchantypes{ac} ' is gone'])
%             end
% 
%             if isempty(zidx) || length(zidx)<2 || (zidx(2)-zidx(1))<2
%                 continue
%             end
%             fcells = fopen([pathway sl 'channels' sl allchantypes{ac} sl 'ref.txt'],'w');
%             for tt=zidx(1)+1:zidx(2)-1
%                 fprintf(fcells,'%s\n',tline{tt});
%             end
%             fclose(fcells);
%        end    
    %end
    if length(varargin)>1 && ~isempty(varargin{2})
        make_syn_website(repospath,[repospath sl 'cellclamp_results'],varargin{2}); %[repospath]);
    end
    if length(varargin)>2 && ~isempty(varargin{3})
        make_expsyn_website(repospath,[repospath sl 'cellclamp_results'],varargin{3});
    end
%end    
%end   

load([repospath sl 'cellclamp_results' sl 'website' sl 'traces.mat'],'alltraces')
load([repospath sl 'cellclamp_results' sl 'website' sl 'exptraces.mat'],'allexptraces')

%print_repos_id(repotype,NumConnections,allcelltypes,usedchans);

typestr={'real','art'};
for x=1:length(allcelltypes)
    allcells.(allcelltypes{x}).Ind = x-1;
    allcells.(allcelltypes{x}).TechType = filedata{2}{x};
    allcells.(allcelltypes{x}).NumCells = filedata{3}(x);
    allcells.(allcelltypes{x}).Layer = filedata{4}(x);
    allcells.(allcelltypes{x}).Type = typestr{filedata{5}(x)+1}; % 'art'
end

fid = fopen([repospath sl 'datasets' sl 'conndata_' num2str(ConnData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
connfiledata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);

fid = fopen([repospath sl 'datasets' sl 'syndata_' num2str(SynData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
if SynData>119 || strcmp(repotype.repo,'ca1')~=1
%synfiledata = textscan(fid,'%s %s %s %s %s %s %s %f %f %f %f %f %f %f %f %f\n') ;
synfiledata = textscan(fid,'%s %s %s %s %s %s %f %f %f %f %f %f %f %f %f\n') ;
else
synfiledata = textscan(fid,'%s %s %s %s %s %f %f %f %f %f %f %f %f %f\n') ;
end
fclose(fid);

% ephysprops = {'RMP','Rinput','Cm','Tau','Rm'}; % % get some more from the experimentaldata, too
fid = fopen([repospath sl 'cellclamp_results' sl 'website' sl 'ephysdata.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
ephysfiledata = textscan(fid,'%s %s %f %f %s %q\n') ; % celltype prop value std units desc
fclose(fid);



% fid = fopen([repospath '\cellclamp_results\website\morph.dat'],'r');                
% numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
% morphfiledata = textscan(fid,'%s %s %f %f %f\n') ; % celltype part area length diam
% fclose(fid);
% morphsections = {'All','Soma','Dendrite','Basal','Apical','Axon'};

for x=1:length(ephysfiledata{1})
    allephys.(ephysfiledata{1}{x}).(ephysfiledata{2}{x}).Value = ephysfiledata{3}(x);
    allephys.(ephysfiledata{1}{x}).(ephysfiledata{2}{x}).Units = ephysfiledata{5}{x};
    allephys.(ephysfiledata{1}{x}).(ephysfiledata{2}{x}).Desc = ephysfiledata{6}{x};
end


allexppscs = struct([]);
allpscs = struct([]);
allconns = struct([]);

% whatsinhere=load('../../repos/entocort/cellclamp_results/133/synfigdata.mat');
% andhere=load('../../repos/entocort/cellclamp_results/133/GUIvalues.mat');
% andalso=load('../../repos/entocort/cellclamp_results/133/rundata.mat');


for a=1:length(allcelltypes)
    celltype = allcelltypes{a};

%     A = strcmp(morphfiledata{1},celltype);
% 
%     for x=1:length(morphsections)
%         B = strcmp(morphfiledata{2},morphsections{x});
%         idx=find(A==1 & B==1);
%         allmorphs.(celltype).(morphsections{x}).Area = morphfiledata{3}(idx);
%         allmorphs.(celltype).(morphsections{x}).Length = morphfiledata{4}(idx);
%         allmorphs.(celltype).(morphsections{x}).Diam = morphfiledata{5}(idx);
%     end

    for p=1:length(allcelltypes)
        pretype = celltype;
        posttype = allcelltypes{p};

        A = strcmp(connfiledata{1},pretype);
        B = strcmp(connfiledata{2},posttype);
        idx=find(A==1 & B==1);
        if length(idx)>1
            idx = idx(1);
        end
        
        A = strcmp(synfiledata{1},posttype);
        B = strcmp(synfiledata{2},pretype);
        synidx=find(A==1 & B==1);
        if length(synidx)>1
            synidx = synidx(1);
        end
        if SynData>119 || strcmp(repotype.repo,'ca1')~=1
            staidx = 9;
        else
            staidx = 7;
        end
        % Physiological
        if ~isempty(idx) && ~isempty(synidx) && isfield(alltraces, pretype) && isfield(alltraces.(pretype), posttype)
            if ~isfield(allpscs,pretype)
                allpscs(1).(pretype)=[];
            end
            if ~isfield(allpscs.(pretype),posttype)
                allpscs(1).(pretype).(posttype)=[];
            end

%             for mtidx=1:length(whatsinhere.cellfigdata.fig.axis)
%                 whatsinhere.cellfigdata.fig.axis(mtidx).name
%                 testy=regexp(whatsinhere.cellfigdata.fig.axis(mtidx).name,'([a-zA-Z]+)\s->\s([a-zA-Z]+)','tokens');
%                 pretype=testy{1}{1};
%                 posttype=testy{1}{2};
%                 allpscs.(pretype).(posttype).Holding = andalso.iclamp.holding; %andhere.GUIvalues.txt_post.value;
%                 whatsinhere.cellfigdata.fig.axis(mtidx).data(end).x
%                 whatsinhere.cellfigdata.fig.axis(mtidx).data(end).y
%             end
% 
% 
%             % verify that set to natural rev
%             if andhere.GUIvalues.radio_auto.value==1 % andalso.iclamp.revflag==0
%             else % or if not, what is the rev?
%                 revpot=str2num(andhere.GUIvalues.txt_rev.value); % andalso.iclamp.revpot
%             end

            allpscs.(pretype).(posttype).Holding = alltraces.(pretype).(posttype).Holding;  %%% placeholder
            if ischar(alltraces.(pretype).(posttype).Reversal) && strcmp(alltraces.(pretype).(posttype).Reversal,'auto')
                if isnan(synfiledata{staidx}(synidx(1)))
                    allpscs.(pretype).(posttype).Reversal = [synfiledata{staidx+3}(synidx(1))]; % synfiledata{14}(synidx(1))]; % will need to update this when adding all poss synapse types... and mult reversal potentials
                else
                    allpscs.(pretype).(posttype).Reversal = synfiledata{staidx}(synidx(1)); % will need to update this when adding all poss synapse types
                end
            else
                allpscs.(pretype).(posttype).Reversal = alltraces.(pretype).(posttype).Reversal;
            end
            allpscs.(pretype).(posttype).Amplitude = alltraces.(pretype).(posttype).Amplitude; %%% placeholder
            allpscs.(pretype).(posttype).RiseTime = alltraces.(pretype).(posttype).RiseTime; %%% placeholder
            allpscs.(pretype).(posttype).DecayTau = alltraces.(pretype).(posttype).DecayTau; %%% placeholder

            if ~isfield(allconns,pretype)
                allconns(1).(pretype)=[];
            end
            if ~isfield(allconns.(pretype),posttype)
                allconns(1).(pretype).(posttype)=[];
            end
            allconns.(pretype).(posttype).Weight = connfiledata{3}(idx);
            allconns.(pretype).(posttype).Conns = connfiledata{4}(idx);
            allconns.(pretype).(posttype).SynsPerConn = connfiledata{5}(idx);
            allconns.(pretype).(posttype).Syns = allconns.(pretype).(posttype).Conns*allconns.(pretype).(posttype).SynsPerConn;
            
            if SynData>119 || strcmp(repotype.repo,'ca1')~=1
                allconns.(pretype).(posttype).Location = synfiledata{4}{synidx};  %%% placeholder
                staidx = 2;
            else
                allconns.(pretype).(posttype).Location = synfiledata{3}{synidx};  %%% placeholder
                staidx = 0;
            end
            
            if iscell(synfiledata{6+staidx}(synidx))
                disp('oops, it seems the syndata file structure has changed. Exiting...')
                return;
            end
            if isnan(synfiledata{6+staidx}(synidx))
                allconns.(pretype).(posttype).Tau1 = synfiledata{8+staidx}(synidx);
                allconns.(pretype).(posttype).Tau2 = synfiledata{9+staidx}(synidx);
                allconns.(pretype).(posttype).Reversal = synfiledata{10+staidx}(synidx);
                allconns.(pretype).(posttype).Tau3 = synfiledata{11+staidx}(synidx);
                allconns.(pretype).(posttype).Tau4 = synfiledata{12+staidx}(synidx);
                allconns.(pretype).(posttype).Reversal2 = synfiledata{13+staidx}(synidx);
            else
                allconns.(pretype).(posttype).Tau1 = synfiledata{5+staidx}(synidx);
                allconns.(pretype).(posttype).Tau2 = synfiledata{6+staidx}(synidx);
                allconns.(pretype).(posttype).Reversal = synfiledata{7+staidx}(synidx);
            end
        end
        
        % Experimental
        if ~isempty(idx) && ~isempty(synidx) && isfield(allexptraces, pretype) && isfield(allexptraces.(pretype), posttype)
            if ~isfield(allexppscs,pretype)
                allexppscs(1).(pretype)=[];
            end
            if ~isfield(allexppscs.(pretype),posttype)
                allexppscs(1).(pretype).(posttype)=[];
            end
            allexppscs.(pretype).(posttype).Holding = allexptraces.(pretype).(posttype).Holding;  %%% placeholder
            if ischar(allexptraces.(pretype).(posttype).Reversal) && strcmp(allexptraces.(pretype).(posttype).Reversal,'auto')
                if isnan(synfiledata{10}(synidx(1)))
                    allexppscs.(pretype).(posttype).Reversal = [synfiledata{12}(synidx(1))]; % synfiledata{14}(synidx(1))]; % will need to update this when adding all poss synapse types... and mult reversal potentials
                else
                    allexppscs.(pretype).(posttype).Reversal = synfiledata{9}(synidx(1)); % synfiledata{7}(synidx(1)); % will need to update this when adding all poss synapse types
                end
            else
                allexppscs.(pretype).(posttype).Reversal = allexptraces.(pretype).(posttype).Reversal;
            end
            allexppscs.(pretype).(posttype).Amplitude = allexptraces.(pretype).(posttype).Amplitude; %%% placeholder
            allexppscs.(pretype).(posttype).RiseTime = allexptraces.(pretype).(posttype).RiseTime; %%% placeholder
            allexppscs.(pretype).(posttype).DecayTau = allexptraces.(pretype).(posttype).DecayTau; %%% placeholder
            allexppscs.(pretype).(posttype).HalfWidth = allexptraces.(pretype).(posttype).HalfWidth; %%% placeholder
            allexppscs.(pretype).(posttype).Clamp = allexptraces.(pretype).(posttype).Clamp; %%% placeholder
            allexppscs.(pretype).(posttype).Peak = allexptraces.(pretype).(posttype).Peak; %%% placeholder
        end       
    end
end

if exist('allchans','var')==0
    allchans={};
end
print_pdf(pathway,allcells,allpscs,allchans,allephys,allconns,alltraces,allexppscs)
%print_website(allcells,allmorphs,allpscs,allchans,allephys,allconns,alltraces)