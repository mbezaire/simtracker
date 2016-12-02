function decaytau(handles,resultsfolder,channel,repos,useconductance,gmax,fitwindow,poi)
global mypath nmod sl

if useconductance
    wi=3;
else
    wi=2;
end
ki=4;
dt = handles.mydt;
starttime=nmod.hold_duration1+2;

startidx = round((starttime+dt)/dt);

A=gmax;

calcI = @(A,t,tau) A*(exp(-t./tau)); % nA

files = dir([repos sl 'cellclamp_results' sl resultsfolder sl 'clamp' sl channel sl 'deact*']);
figure('Color','w','Name',['Deactivation Kinetics for ' channel ' (' resultsfolder ')' ],'units','normalized','outerposition',[0 0 1 1]);
xlabel('Time (ms)')
ylabel('Potential (mV)')
subplot(1,3,1)

tau=zeros(length(files),1);
pot=zeros(length(files),1);
newtau=zeros(length(files),1);
newA=zeros(length(files),1);

for r=1:length(files)    
    b=length('deact_');
    pot(r)=str2double(files(r).name(b+1:end-4));
    t = importdata([repos sl 'cellclamp_results' sl resultsfolder sl 'clamp' sl channel sl files(r).name]);
    datamax = max(t.data(:,wi));
    datamin = min(t.data(:,wi));
    t.data(:,ki)=t.data(:,wi); %sgolayfilt(t.data(:,wi),4,55);
    t.data(:,ki)=min(t.data(:,ki),datamax);
    t.data(:,ki)=max(t.data(:,ki),datamin);
    
    newA(r)=mean(t.data(startidx-2/dt:startidx,ki));
    ss=min(t.data(end,ki));
    amp=t.data(startidx,ki)-ss;
    if amp<=0
        tau(r)=NaN;
        idx=1;
        disp(['We have a problem. pot: ' num2str(pot(r)) ', peak: ' num2str(t.data(startidx,ki)) ', amp: ' num2str(amp) ', ss: ' num2str(ss) ', decaycheck: ' num2str(((1/(exp(1)))*amp+ss)) ])
    else
        idx=find(t.data(startidx:end,ki)<=((1/(exp(1)))*amp+ss),1,'first');
        tau(r)=t.data(idx+startidx-1,1)-t.data(startidx,1);
    end
    if tau(r)>fitwindow
        tau(r)=NaN;
    end
    if pot(r)==poi
        plot(t.data(:,1),t.data(:,ki),'r')
    else
        plot(t.data(:,1),t.data(:,ki),'b')
    end
    hold on
    if pot(r)==poi
        lh(1)=plot(t.data(idx+startidx-1,1),t.data(idx+startidx-1,ki),'r','Marker','.','MarkerSize',10);
    else
        plot(t.data(idx+startidx-1,1),t.data(idx+startidx-1,ki),'b','Marker','.','MarkerSize',10)
    end
    
    myt = t.data(startidx:startidx+fitwindow/dt,1);
    if amp<0
        taunew=1;
        minval=0;
    else
        [taunew, minval]=fit_tau(myt-myt(1),t.data(startidx:startidx+fitwindow/dt,ki),calcI,newA(r)); 
    end
    myI = calcI(newA(r),myt-myt(1),taunew);
    if pot(r)==poi
        lh(2)=plot(myt,myI,'LineStyle',':','Color','g');
        saveminval = minval;
    end
    %disp(['pot: ' num2str(pot(r)) ', tau: ' num2str(tau(r)), ', err: ' num2str(minval) ])
    newtau(r)=taunew;
end

if exist('t','var')==0 || isempty(t)
    return;
end
xlim([t.data(startidx,1)-5 t.data(startidx,1)+fitwindow])
title({'Traces for voltage steps',[resultsfolder ': ' channel]})
xlabel('Time (ms)')
legend(lh,{[num2str(poi) ' mV'],['Fit line (' num2str(saveminval) ' SS)']},'Location','SouthWest')

if useconductance==0
    ylabel('Current (nA)')
else
    ylabel('Conductance (uS)')
end

[pot sorti]=sort(pot);
idx=find(pot==poi);
tau=tau(sorti);
newtau=newtau(sorti);
subplot(1,3,2)
plot(pot,tau)
hold on
plot(pot(idx),tau(idx),'Marker','.','MarkerSize',10,'Color','r')
text(pot(idx),tau(idx),[' ' num2str(tau(idx)) ' ms'])
xlabel('Step Potential (mV)')
ylabel('Decay tau (ms)')
title({'Decay Time Constant',['Time to reach ' sprintf('%3.1f',(1/exp(1))*100) '% of (peak - steady state) value']})

subplot(1,3,3)
ax=plotyy(pot,newtau,pot(~isnan(newtau)),newA(~isnan(newtau)));
set(ax(2),'ylim',[0 A],'YTickMode','auto')
hold on
plot(pot(idx),newtau(idx),'Marker','.','MarkerSize',10,'Color','r')
text(pot(idx),newtau(idx),[' ' num2str(newtau(idx)) ' ms'])
xlabel('Step Potential (mV)')
ylabel(ax(1),'Deactivation tau (ms)')
ylabel(ax(2),'A')
title({'Deactivation Time Constant',[func2str(calcI) ' A=' num2str(newA(idx))]},'Interpreter','None')


function [tau, minval]=fit_tau(t,I,calcI,A)

try
    geterr  = @(tau) trapz(t,(I - calcI(A,t,tau)).^2);
    [tau minval] = fminsearch(geterr,1);
catch %#ok<CTCH>
    tau=NaN;
    minval=0;
end
if tau>t(end)
    tau=NaN;
end