
%%%%%%% Spike properties
myprop={'isi','threshold','ampl','ahp','halfwidth'};
mylabel={'ISI (ms)','Threshold (mV)','AP Ampl. (mV)','AHP Ampl. (mV)','HalfWidth (ms)'};
h=zeros(1,length(myprop));
for r=1:length(myprop)
    MyName=mylabel{r}(1:findstr(mylabel{r},' ')-1);
    h(r)=figure('Color','w','Name',MyName);
end

legstr={};
myresults={'220','221','222','223','224'}; % all 100%, diff channel compositions
%myresults={'220','225','227','229','230','231'}; % same channel composition, diff max conductances

%myresults={'224','250','251'}; % Jonas channel only, diff conductances
%myresults={'220','229','231','247','248'}; % ,'250','251' Kdrfast channel only, diff conductances

%myresults={'220','247','248','224','250','251'}; % kdrfast and jonas

%myresults={'280','281','286'};
%myresults={'220','224'}; % Only Jonas or only Kdrfast, same max conductance
mycolors={'b','r','g','m','c','k'};
cellOI=1;
for z=1:length(myresults)
    eval(['gstruct=gstruct_' myresults{z} ';'])
    for r=1:length(myprop)
        mydata=[];myerr=[];
        for m=1:length(gstruct(cellOI).results.ivec)
            mydata(m)=mean(gstruct(cellOI).results.spikes(m).(myprop{r}));
            myerr(m)=std(gstruct(cellOI).results.spikes(m).(myprop{r}));
        end
        figure(h(r));
        errorbar(gstruct(cellOI).results.ivec,mydata,myerr,mycolors{z});
        hold on
    end
    legstr{length(legstr)+1}=gstruct(cellOI).desc;
end


for r=1:length(myprop)
    figure(h(r));
    title(myprop{r})
    xlabel('Current (pA)')
    ylabel(mylabel{r})
    legend(legstr)
end

%%%%%%% IF Curve
h(length(myprop)+1)=figure('Color','w','Name','IF Curve');
for z=1:length(myresults)
    eval(['gstruct=gstruct_' myresults{z} ';'])
    plot(gstruct(cellOI).results.ivec,gstruct(cellOI).results.fvec,mycolors{z});
    hold on
end
title('Firing Frequency')
xlabel('Current (pA)')
ylabel('Firing Frequency (Hz)')
legend(legstr)


%%%%%%% Steady State Potential
h(length(myprop)+2)=figure('Color','w','Name','Steady State Potential');
for z=1:length(myresults)
    eval(['gstruct=gstruct_' myresults{z} ';'])
    plot(gstruct(cellOI).results.ivec,gstruct(cellOI).results.ss,mycolors{z});
    hold on
end
title('Steady State')
xlabel('Current (pA)')
ylabel('Steady State Potential (mV)')
legend(legstr)


%%%%%%% Delay to first spike
h(length(myprop)+3)=figure('Color','w','Name','Delay to First Spike');
for z=1:length(myresults)
    eval(['gstruct=gstruct_' myresults{z} ';'])
    plot(gstruct(cellOI).results.ivec,[gstruct(cellOI).results.spikes(:).delay],mycolors{z});
    hold on
end
title('Delay to First Spike')
xlabel('Current (pA)')
ylabel('Delay (ms)')
legend(legstr)


%%%%%%% Highest Trace
h(length(myprop)+4)=figure('Color','w','Name','Max Current Injection Trace');
for z=1:length(myresults)
    eval(['gstruct=gstruct_' myresults{z} ';'])
    plot(gstruct(cellOI).results.TimeVec,gstruct(cellOI).results.betterdata(end).ResultData,mycolors{z});
    hold on
end
title(['Trace at current injection = ' num2str(max(gstruct(cellOI).results.ivec)) ' pA'])
xlabel('Time (ms)')
ylabel('Potential (mV)')
legend(legstr)
