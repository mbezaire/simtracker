function [tmp hif hhyp getinput]=readsinglecell(filestr,filename,getinput,varargin) % hif, hhyp, hhcn, ci, li

APthreshold=-20; %mV

if isempty(varargin)
    ci=1;
    li=1;
    hif=figure('Color','w');
    subplot(1,2,1)
    hold on
    xlabel('Current (pA)')
    ylabel('Max potential (mV)')
    subplot(1,2,2)
    hold on
    xlabel('Current (pA)')
    ylabel('Firing frequency (Hz)')

    hhyp=figure('Color','w');
    subplot(1,2,1)
    hold on
    xlabel('Current (pA)')
    ylabel('Minimum potential (mV)')
    subplot(1,2,2)
    hold on
    xlabel('Current (pA)')
    ylabel('Steady state potential (mV)')
    
    hhcn=figure('Color','w');
    subplot(1,2,1)
    hold on
    xlabel('Current (pA)')
    ylabel('Sag amplitude (mV)')
    
    subplot(1,2,2)
    hold on
    xlabel('Current (pA)')
    ylabel('Sag Timing (s)')
    
else
    hif=varargin{1};
    hhyp=varargin{2};
    hhcn=varargin{3};
    ci=varargin{4};
    li=varargin{5};
end

tmp=importdata(filestr, '\t', 11); %
tmp=tmp;

for z=1:length(tmp.colheaders)
    myt=regexp(tmp.colheaders{z},'"([a-zA-Z]+)\s*#?([0-9]+)?\s*\(([a-zA-Z]+)\)"','tokens');
    tmp.headers(z).Type=myt{1}{1};
    tmp.headers(z).Num=str2double(myt{1}{2});
    tmp.headers(z).Units=myt{1}{3};
end

if length(unique({tmp.headers(2:end).Units}))==1
    ResultUnits=unique({tmp.headers(2:end).Units});
    numtraces=length(unique([tmp.headers(2:end).Num]));
    tmp.TimeVec=tmp.data(:,1);
    tmp.TimeUnits=tmp.headers(1).Units;
    tmp.TimeLabel=tmp.headers(1).Type;
    tmp.ResultUnits = ResultUnits{end}; %ResultUnits{:};
    extradata=[];
    while length(extradata)~=(size(tmp.data,2)-1)
        switch tmp.ResultUnits(end)
            case 'V'
                InputLabel='Current injection';
            case 'A'
                InputLabel='Holding potential';
        end
        getinput=inputdlg({[InputLabel ' data ( vector with ' num2str(numtraces) ' entries)'],'This data is given in units of:',['Length of ' tmp.TimeLabel ' input was applied, in units of ' tmp.headers(1).Units]},[filename ': provide ' InputLabel ' data'],1,getinput);
        if isempty(getinput)
            tmp=[];
            return
        end
        eval(['extradata=' getinput{1} ';']);
    end
    InputUnits=getinput{2};
    testdur=str2num(getinput{3});
    rez = tmp.TimeVec(2) - tmp.TimeVec(1);
    testlength = testdur/rez;
    totlength = length(tmp.TimeVec);
    
    tmp.InputUnits = InputUnits;
    
    for z=2:length(tmp.headers)
        tmp.betterdata(z-1).Label = tmp.headers(z).Type;
        tmp.betterdata(z-1).Num = tmp.headers(z).Num;
        tmp.betterdata(z-1).ResultData = tmp.data(:,z);
        mydiff=diff(tmp.betterdata(z-1).ResultData);
        %find(abs(mydiff)>1.1*mean(abs(mydiff)),1,'first')
        %[~, mystart]=max(abs(mydiff));  % [1 : initpt], [initpt + 1 : testdur*rez + initpt + 1], [testdur*rez + initpt + 2 : end]
        tmp.betterdata(z-1).TestStart=find(abs(mydiff(50:end))>.8*max(abs(mydiff(50:end))),1,'first')-1+50;
        tmp.betterdata(z-1).TestEnd=find(abs(mydiff(50:end))>.8*max(abs(mydiff(50:end))),1,'last')-1+50;
        %tmp.betterdata(z-1).TestStart = mystart+1;
        finlength = totlength - tmp.betterdata(z-1).TestStart + 1 - testlength;
        tmp.betterdata(z-1).InputData = [zeros(tmp.betterdata(z-1).TestStart-1,1); repmat(extradata(z-1),testlength,1); zeros(finlength,1)];
    end
else
    tmp.TimeVec=tmp.data(:,1);
    tmp.TimeUnits=tmp.headers(1).Units;
    tmp.TimeLabel=tmp.headers(1).Type;

    datatypes4one=find([tmp.headers(2:end).Num]==1);
    ResultUnits={tmp.headers(1+datatypes4one).Units};
    mystr='';
    for r=1:length(ResultUnits)
        mystr=[mystr ResultUnits{r} ' '];
    end
    if length(ResultUnits)>2
        getinput=inputdlg({['This is the order of your data in file ' filename ' is: ' mystr 'The current injection column is:'],'The recorded membrane potential column is:'});
        inpidx=str2num(getinput{1});
        recidx=str2num(getinput{2});
    else
        inpidx=find(strcmp('pA',ResultUnits)==1);
        recidx=find(strcmp('mV',ResultUnits)==1);
    end
    mydiffidx=recidx-inpidx;
    
    rez = tmp.TimeVec(2) - tmp.TimeVec(1);
    
    tmp.InputUnits = ResultUnits{inpidx};
    tmp.ResultUnits = ResultUnits{recidx};
    
    myidx=1;
    for z=(1+inpidx):length(ResultUnits):length(tmp.headers)
        tmp.betterdata(myidx).Label = tmp.headers(z).Type;
        tmp.betterdata(myidx).Num = tmp.headers(z).Num;
        tmp.betterdata(myidx).ResultData = tmp.data(:,z+mydiffidx);
        tmp.betterdata(myidx).RawInputData = tmp.data(:,z);
        mydiff=diff(tmp.betterdata(myidx).RawInputData);
        
        tmp.betterdata(myidx).TestStart=find(abs(mydiff(50:end))>.8*max(abs(mydiff(50:end))),1,'first')-1+50;
        tmp.betterdata(myidx).TestEnd=find(abs(mydiff(50:end))>.8*max(abs(mydiff(50:end))),1,'last')-1+50;
        baseline = mean([tmp.betterdata(myidx).RawInputData(51:(tmp.betterdata(myidx).TestStart-1))]);
        
        tmp.betterdata(myidx).InputData = tmp.data(:,z)-baseline;
        %tmp.betterdata(myidx).TestStart
        %tmp.betterdata(myidx).TestEnd
        myidx=myidx+1;
    end
    maxi=mode([tmp.betterdata(:).TestEnd]);
    mini=mode([tmp.betterdata(:).TestStart]);
    
    testdur=tmp.TimeVec(maxi) - tmp.TimeVec(mini);
    testlength = testdur/rez;
    totlength = length(tmp.TimeVec);
end

% tmp.data;
% [maxval maxi]=max(diff(tmp.data(:,3)));
% [minval mini]=min(diff(tmp.data(:,3)));
% timedur=abs(tmp.data(maxi,1)-tmp.data(mini,1));
%maxi = testlength + tmp.betterdata(1).TestStart; % + 1;
tmp.idxes=[];
tmp.negidx=[];
tmp.posidx=[];
maxi=mode([tmp.betterdata(:).TestEnd]);
mini=mode([tmp.betterdata(:).TestStart]);
for r=1:length(tmp.betterdata)
    %mini = tmp.betterdata(r).TestStart; % + 1;
    %maxi = tmp.betterdata(r).TestEnd; % + 1;
    tmp.ivec(r)=tmp.betterdata(r).InputData(tmp.betterdata(r).TestStart+2);
    tmp.fvec(r)=length(find(tmp.betterdata(r).ResultData(mini:maxi-1)<=APthreshold & tmp.betterdata(r).ResultData(mini+1:maxi)>=APthreshold))/testdur;
    if tmp.fvec(r)==0
        tmp.ss(r)=tmp.betterdata(r).ResultData(maxi);
        if tmp.ivec(r)<0
            [tmp.min(r) tmp.mintime(r)]=min(tmp.betterdata(r).ResultData(mini:maxi));
            tmp.diffmin(r)=tmp.min(r)-tmp.ss(r); % sag
            tmp.negidx=[tmp.negidx r];
        else
            tmp.min(r)=NaN;
            tmp.diffmin(r)=NaN; % sag
            tmp.mintime(r)=NaN;
        end
        if tmp.ivec(r)>0
            tmp.max(r)=max(tmp.betterdata(r).ResultData(mini:maxi));
            tmp.diffmax(r)=tmp.max(r)-tmp.ss(r);
            tmp.posidx=[tmp.posidx r];
        else
            tmp.max(r)=NaN;
            tmp.diffmax(r)=NaN;
        end
        tmp.idxes=[tmp.idxes r];
    else
        tmp.min(r)=NaN;
        tmp.max(r)=NaN;
        tmp.ss(r)=NaN;
        tmp.diffmin(r)=NaN; % sag
        tmp.diffmax(r)=NaN;
        tmp.mintime(r)=NaN;
    end
end

% for r=1:(size(tmp.data,2)-1)/2
%     tmp.ivec(r)=tmp.data(10000,r*2+1);
%     tmp.fvec(r)=length(find(tmp.data(mini:maxi-1,r*2)<=0 & tmp.data(mini+1:maxi,r*2)>=0))/timedur;
%     tmp.min(r)=min(tmp.data(mini:maxi,r*2));
% end
[repos, ~, ~]=fileparts(filestr);
plotsinglecell(tmp,ci,li,hif,hhyp,hhcn,filename,'000',repos)