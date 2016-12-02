function mycell = readinWChapCells(PathToFile,handles,varargin)
global mypath sl 

myfilepath= PathToFile;

handles.Analysis.ThresholdCalc=1;
handles.Analysis.ThreshCheck=-50;
varargin=[];

if ~isempty(varargin)
    defCellType=varargin{1};
    CellRegion=varargin{2};
else
    defCellType='?';
    CellRegion='??';
end

dtmp=dir(PathToFile);

pickedfolder = 0; % = 1 if atf or abf files directly in folder
pickedparentfolder = 0; % = 1 if directories within folder
pickedmatfile = 0; % = 1 if a file with extension .mat was picked

if sum([dtmp.isdir])>0
    mm=find([dtmp.isdir]==0 & strcmp({dtmp.name},'.DS_Store')==0);
    if ~isempty(mm) && strcmp(dtmp(mm).name,'SL.mat')  % strcmp(dtmp(mm).name(end-4:end),'.mat')
        pickedmatfile=1;
    else
        pickedparentfolder = 1; % = 1 if directories within folder        
    end
elseif length(dtmp)>0 && sum([dtmp.isdir])==0
    pickedfolder=1;
else
    msgbox('Unsure of folder contents')
    return
end

if pickedfolder  
% Pick a folder
    folder = myfilepath;

    tmpname=regexp(folder,'/','split');
    filename=tmpname{end};

elseif pickedparentfolder
    % OR go through all folders in parent folder
    allfolderstmp=dir(myfilepath);
    allfolders=allfolderstmp([allfolderstmp.dir]==1);

    for sli=1:length(allfolders)
        disp(['starting on ' num2str(sli) '/' num2str(length(allfolders))])
        FileName=allfolders(sli).name;

        if ~isempty(searchRuns('FileName',FileName,0,'=='))
            msgbox(['File ' filestr ' was already uploaded. Skipping...'])
            continue;
        end

        folder = [myfilepath sl FileName];

        CellType=defCellType;

        % tmpname=regexp(folder,'/','split');
        % filename=tmpname{end};
        grr=regexprep(FileName,{'Cell','-','\.','Slice','Stellate'},{'C','_','p','Sl','Stell'});
        tmpfind=strfind(grr,'_');
        grr(tmpfind(2:end))='';
        cellname = grr;

        d=dir([folder '/*.mat']);
        for di=1:length(d)
            testcell=load([folder '/' d(di).name]);
            tmpdata(di).time=testcell.ts;
            tmpdata(di).voltage=testcell.d(:,1);
            tmpdata(di).current=testcell.d(:,2);
        end
        AxoClampData=getAxoDatafromMAT(tmpdata,allfolders(sli)); % getAxoDatafromMATfiles
        
        chkflg=1;

        for n=1:AxoClampData.NumberSweeps
            checkme=AxoClampData.Data(n).CurrentInjection;
            mystdvals(n) = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
        end

        for n=1:AxoClampData.NumberSweeps
            zerocase=0;
            sqwv=0;
            checkme=AxoClampData.Data(n).CurrentInjection;
            tmpstd = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
            if tmpstd==min(mystdvals) && mystdvals(n)<(mean(mystdvals)-std(mystdvals))
                zerocase=1;
            end

            minme=min(checkme);
            maxme=max(checkme);
            testidx=find(checkme>(minme+.005) & checkme<(maxme-.005));
            if length(testidx)/length(checkme)<.3
                %checkme = (checkme - minme)/(maxme - minme);
                sqwv=1;
            end

            if sum([sqwv zerocase])==0
                chkflg=0;
                break;
            end
        end


        MethodSet=0;
        PathToFile = myfilepath;
        mycell(sli) = ExpCell([],MethodSet,PathToFile,FileName,CellType);
        if chkflg==1 %'standard';
            mycell(sli).CurrentRange = [num2str(AxoClampData.Currents(1)) ':' num2str(AxoClampData.CurrentStepSize) ':' num2str(AxoClampData.Currents(end))];
        else %'nonstandard';
            mycell(sli).Notes='Non standard current injection';
        end        

        mycell(sli).Region = CellRegion;
        mycell(sli).Experimenter = SL(sli).owner;
        mycell(sli).CellName = cellname;

        eval([mycell(sli).DetailedData '.AxoClampData=AxoClampData;'])
        mycell(sli).ThresholdType = handles.Analysis.ThresholdCalc;
        mycell(sli).ThreshCheck = handles.Analysis.ThreshCheck;

        save([mypath sl 'data' sl 'DetailedData' sl mycell(sli).DetailedData '.mat'],mycell(sli).DetailedData,'-v7.3')
    end
        
elseif pickedmatfile
    % OR go through SL mat in parent folder

    load([myfilepath sl 'SL.mat'])

    for sli=1:length(SL)
        disp(['starting on ' num2str(sli) '/' num2str(length(SL))])
        tmpdir=regexp(SL(sli).runs(1).fname,'/','split');
        FileName=tmpdir{end-1};

        if ~isempty(searchRuns('FileName',FileName,0,'=='))
            msgbox(['File ' filestr ' was already uploaded. Skipping...'])
            continue;
        end

        folder = [myfilepath sl FileName];

        % then load in all cell data for that one
        if SL(sli).stellate==1
            CellType='stellate';
        else
            CellType=defCellType;
        end

        % tmpname=regexp(folder,'/','split');
        % filename=tmpname{end};
        grr=regexprep(FileName,{'Cell','-','\.','Slice','Stellate'},{'C','_','p','Sl','Stell'});
        tmpfind=strfind(grr,'_');
        grr(tmpfind(2:end))='';
        cellname = grr;

        d=dir([folder '/*.mat']);
        for di=1:length(d)
            testcell=load([folder '/' d(di).name]);
            tmpdata(di).time=testcell.ts;
            tmpdata(di).voltage=testcell.d(:,1);
            tmpdata(di).current=testcell.d(:,2);
        end
        AxoClampData=getAxoDatafromMAT(tmpdata,SL(sli));

        chkflg=1;

        for n=1:AxoClampData.NumberSweeps
            checkme=AxoClampData.Data(n).CurrentInjection;
            mystdvals(n) = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
        end

        for n=1:AxoClampData.NumberSweeps
            zerocase=0;
            sqwv=0;
            checkme=AxoClampData.Data(n).CurrentInjection;
            tmpstd = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
            if tmpstd==min(mystdvals) && mystdvals(n)<(mean(mystdvals)-std(mystdvals))
                zerocase=1;
            end

            minme=min(checkme);
            maxme=max(checkme);
            testidx=find(checkme>(minme+.005) & checkme<(maxme-.005));
            if length(testidx)/length(checkme)<.3
                %checkme = (checkme - minme)/(maxme - minme);
                sqwv=1;
            end

            if sum([sqwv zerocase])==0
                chkflg=0;
                break;
            end
        end


        MethodSet=0;
        PathToFile = myfilepath;
        
        mycell(sli) = ExpCell([],MethodSet,PathToFile,FileName,CellType);
        if chkflg==1 %'standard';
            mycell(sli).CurrentRange = [num2str(AxoClampData.Currents(1)) ':' num2str(AxoClampData.CurrentStepSize) ':' num2str(AxoClampData.Currents(end))];
        else %'nonstandard';
            mycell(sli).Notes='Non standard current injection';
        end         
        
        mycell(sli).Region = CellRegion;
        mycell(sli).Experimenter = SL(sli).owner;
        mycell(sli).CellName = cellname;

        eval([mycell(sli).DetailedData '.AxoClampData=AxoClampData;'])
        mycell(sli).ThresholdType = handles.Analysis.ThresholdCalc;
        mycell(sli).ThreshCheck = handles.Analysis.ThreshCheck;

        save([mypath sl 'data' sl 'DetailedData' sl mycell(sli).DetailedData '.mat'],mycell(sli).DetailedData,'-v7.3')
    end
end

function filecontents=getAxoDatafromMATfiles(d,SLentry)

filecontents = [];

function filecontents=getAxoDatafromMAT(tmpdata,SLentry)


for n=1:length(tmpdata)

    if abs(tmpdata(n).time(2)-SLentry.runs(1).h.si*10^-6)<10^-12
        filecontents.Time(n).Units='s';
    else
        filecontents.Time(n).Units='?';
    end
    filecontents.Time(n).Data = tmpdata(n).time;
    filecontents.Time(n).Res = tmpdata(n).time(2) - tmpdata(n).time(1);
end

ResultUnits=SLentry.runs(1).h.recChUnits;
uniqueUnits = unique(ResultUnits);
g=strfind(uniqueUnits,'A');
for r=1:length(g)
    if ~isempty(g{r})
        if length(uniqueUnits)==1
            filecontents.CurrentUnits = uniqueUnits{1};
        else
            filecontents.CurrentUnits = uniqueUnits{r};
        end
    end
end
g=strfind(uniqueUnits,'V');
for r=1:length(g)
    if ~isempty(g{r})
        if length(uniqueUnits)==1
            filecontents.VoltageUnits = uniqueUnits{1};
        else
            filecontents.VoltageUnits = uniqueUnits{r};
        end
    end
end
filecontents.ColumnsPerSweep = length(SLentry.runs(1).h.recChUnits);
   
switch filecontents.ColumnsPerSweep
    case 1
        filecontents.Style='VoltageOnly'; %|'VoltageAndCurrent'|'ExtraChannels';
        filecontents.CurrentColumn=0;
        filecontents.VoltageColumn=1;
        filecontents.CurrentUnits = 'pA';
    case 2
        filecontents.Style='VoltageAndCurrent'; %|'ExtraChannels';
        filecontents.CurrentColumn=find(strcmp(filecontents.CurrentUnits,ResultUnits)==1);
        filecontents.VoltageColumn=find(strcmp(filecontents.VoltageUnits,ResultUnits)==1);
    otherwise
        filecontents.Style='ExtraChannels';
        getinput=inputdlg({['The order of ' FileName ' (' CellType ') data for each current injection is: ' sprintf('%s ',ResultUnits{:}) '. The current injection column is:'],'The recorded membrane potential column is:'});
        filecontents.CurrentColumn=str2num(getinput{1});
        filecontents.VoltageColumn=str2num(getinput{2});
        if isempty(strfind(ResultUnits{filecontents.CurrentColumn},'A')) || isempty(strfind(ResultUnits{filecontents.VoltageColumn},'V'))
            msgbox('Something is not right about your selection')
        end
end

filecontents.Sweeps=cellstr([repmat('# ',length(tmpdata),1) num2str([1:length(tmpdata)]')]);
filecontents.NumberSweeps=length(tmpdata);


for n=1:filecontents.NumberSweeps
    nn=1;
    nno=1;

    nnoff=1;
    nnooff=1;
    lookIdx = find(filecontents.Time(n).Data>.02,1,'first'); % assume the current injection never starts more than .02 s into the trace

    ResultIdx = 1+filecontents.ColumnsPerSweep*(n-1)+filecontents.VoltageColumn;
    filecontents.Data(n).RecordedVoltage = tmpdata(n).voltage;
    filecontents.Data(n).Sweep = filecontents.Sweeps(n);

    mydiff=diff(filecontents.Data(n).RecordedVoltage);
    otherdiff = diff(tmpdata(n).current);
    register=.75;
    filecontents.Injection(n).OnIdx = find(abs(otherdiff(lookIdx:end))>register*max(abs(otherdiff(lookIdx:end))),1,'first')-1+lookIdx;

    if (filecontents.Injection(n).OnIdx*filecontents.Time(n).Res<0.05) %.1)
        htm=figure('Color','w');
        plot(filecontents.Time(n).Data,filecontents.Data(n).RecordedVoltage)
%         hold on
%         plot(filecontents.Time(n).Data,filecontents.Data(end).RecordedVoltage)
        title('Please click where the current injection starts:');
        [x,y]=ginput(1);
        close(htm);
        filecontents.Injection(n).OnIdx = find(filecontents.Time(n).Data>=x,1,'first');
    end
    filecontents.Injection(n).OffIdx = round(filecontents.Injection(n).OnIdx+1/filecontents.Time(n).Res); % mode([filecontents.Data(:).EstimatedOffIdx]);
    if filecontents.Injection(n).OffIdx>length(filecontents.Time(n).Data)
        filecontents.Injection(n).OffIdx=length(filecontents.Time(n).Data)-1;
    end
    filecontents.Injection(n).Duration = filecontents.Time(n).Data(filecontents.Injection(n).OffIdx) - filecontents.Time(n).Data(filecontents.Injection(n).OnIdx);
end

% for n=1:filecontents.NumberSweeps
%     ResultIdx = 1+filecontents.ColumnsPerSweep*(n-1)+filecontents.VoltageColumn;
%     filecontents.Data(n).RecordedVoltage = tmpdata(n).voltage;
%     filecontents.Data(n).Sweep = filecontents.Sweeps(n);
% 
%     mydiff=diff(filecontents.Data(n).RecordedVoltage);
%     otherdiff = diff(tmpdata(n).current);
%     register=.75;
%     tmpnnoff = find(abs(mydiff(filecontents.Injection(n).OnIdx:end))>register*max(abs(mydiff(filecontents.Injection(n).OnIdx:end))),1,'first')-1+filecontents.Injection(n).OnIdx;
%     tmpnnooff = find(abs(otherdiff(filecontents.Injection(n).OnIdx:end))>register*max(abs(otherdiff(filecontents.Injection(n).OnIdx:end))),1,'first')-1+filecontents.Injection(n).OnIdx;
%     if ~isempty(tmpnnoff)
%         estimatedOffIdx(nn) = tmpnnoff;
%         nnoff=nnoff+1;
%     end
%     if ~isempty(tmpnnooff)
%         estimatedOffIdxO(nno) = tmpnnooff;
%         nnooff=nnooff+1;
%     end
% end
% 
% if mode(estimatedOffIdx) > (mean(estimatedOffIdx) + mystd(estimatedOffIdx)) || mode(estimatedOffIdx) < (mean(estimatedOffIdx) - mystd(estimatedOffIdx)) || (std(estimatedOnIdx) - mystd(estimatedOnIdxO)) > 10000
%     [filecontents.Injection(n).OffIdx, numtimes] = mode(estimatedOffIdxO);
%     % numtimes=0;
% else
%     [filecontents.Injection(n).OffIdx, numtimes] = mode(estimatedOffIdx);
% end
% if numtimes==1
%     grr=sort(estimatedOffIdx);
%     [~, bidx] = min(diff(grr));
%     filecontents.Injection(n).OffIdx = grr(bidx+1);
% end


filecontents.HoldingVoltage = [];
filecontents.BaselineCurrent = 0;%[]; 

switch filecontents.Style
    case 'VoltageOnly'
        % find the zero current injection
        for n=1:filecontents.NumberSweeps
            mystd(n) = mystd(filecontents.Data(n).RecordedVoltage); % DetailedData.AxoClampData.Data(n).RecordedVoltage
        end
        [~, n] = min(mystd);
        if mystd(n)>=(mean(mystd)-std(mystd))
            getinput=inputdlg({['Give the current sweep step size and either the most hyperpolarized or most depolarized current injection used during the sweep. Current sweep step size in ' filecontents.CurrentUnits ':'],['Most hyperpolarized injection in ' filecontents.CurrentUnits ':'],['Most depolarized injection in ' filecontents.CurrentUnits ':']});
            if isempty(getinput)
                return
            end
        else
            getinput=inputdlg(['Give the current sweep step size in ' filecontents.CurrentUnits ':']);
            if isempty(getinput)
                return
            end
        end
        
        if ~isempty(getinput{1})
            filecontents.CurrentStepSize = str2num(getinput{1});
        else
            msgbox('Current step size is required.')
            return;
        end
        if length(getinput)>1 && ~isempty(getinput{2})
            filecontents.Currents = [str2num(getinput{2}):filecontents.CurrentStepSize:(filecontents.NumberSweeps-1)*filecontents.CurrentStepSize+str2num(getinput{2})];
            if ~isempty(getinput{3})
                if filecontents.Currents(end)~=str2num(getinput{3})
                    msgbox('The three numbers you entered are incompatible.')
                    return
                end
            end
        elseif length(getinput)>1 && ~isempty(getinput{3})
            filecontents.Currents = [(str2num(getinput{3}) - (filecontents.NumberSweeps-1)*filecontents.CurrentStepSize):filecontents.CurrentStepSize:str2num(getinput{3})];
        elseif length(getinput)>1
            msgbox('You needed to enter either the max hyper or depol step')
            return;
        else
            filecontents.Currents = [-filecontents.CurrentStepSize*(n-1):filecontents.CurrentStepSize:filecontents.CurrentStepSize*(filecontents.NumberSweeps-n)];
        end
        
        for n=1:filecontents.NumberSweeps
            if ~isempty(filecontents.BaselineCurrent)
                filecontents.Data(n).BaselineCurrent = filecontents.BaselineCurrent;
            else
                filecontents.Data(n).BaselineCurrent = 0;
            end

            filecontents.Data(n).CurrentInjection = [zeros(filecontents.Injection(n).OnIdx-1,1); repmat(filecontents.Currents(n),filecontents.Injection(n).OffIdx-filecontents.Injection(n).OnIdx+1,1); zeros(length(filecontents.Time(n).Data)-filecontents.Injection(n).OffIdx,1)];
        end
    otherwise % 'ExtraChannels' || 'VoltageAndCurrent'
        for n=1:filecontents.NumberSweeps
            ResultIdx = 1+filecontents.ColumnsPerSweep*(n-1)+filecontents.CurrentColumn;

            if ~isempty(filecontents.BaselineCurrent)
                filecontents.Data(n).BaselineCurrent = filecontents.BaselineCurrent;
                filecontents.Data(n).CurrentInjection = tmpdata(n).current-filecontents.Data(n).BaselineCurrent; % relative to baseline
                try
                filecontents.Currents(n) = round(mean(filecontents.Data(n).CurrentInjection(filecontents.Injection(n).OnIdx:filecontents.Injection(n).OffIdx-1))/10)*10;
                catch
                    n
                end
                else
                filecontents.Data(n).BaselineCurrent = mymean(tmpdata(n).current((lookIdx+1):(filecontents.Injection(n).OnIdx-1)));
                filecontents.Data(n).CurrentInjection = tmpdata(n).current-filecontents.Data(n).BaselineCurrent; % relative to baseline
                filecontents.Currents(n) = round(mean(filecontents.Data(n).CurrentInjection(filecontents.Injection(n).OnIdx:filecontents.Injection(n).OffIdx-1))/10)*10;
            end
        end
        if length(filecontents.Currents)>1
            filecontents.CurrentStepSize = filecontents.Currents(2) - filecontents.Currents(1);
        else
            filecontents.CurrentStepSize = NaN;
        end
        
        if isempty(filecontents.BaselineCurrent)
            filecontents.BaselineCurrent=mymean([filecontents.Data(:).BaselineCurrent]);
        end
end

allcurrents = sprintf('%d, ',filecontents.Currents);


function m=mymean(myvec)
myvec(isnan(myvec))=[];
m=mean(myvec);

function s=mystd(myvec)
myvec(isnan(myvec))=[];
s=std(myvec);
