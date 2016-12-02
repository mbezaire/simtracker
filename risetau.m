function risetau(handles,resultsfolder,channel,repos,useconductance,gmax,fitwindow,poi)
global nmod sl

if useconductance
    wi=3;
else
    wi=2;
end
ki=4;

dt = handles.mydt;
starttime=nmod.stepto_duration1;

startidx = round((starttime+dt)/dt);

A=gmax;

calcI = @(A,t,tau) A*(1-exp(-t./tau)).^4;

files = dir([repos sl 'cellclamp_results' sl resultsfolder sl 'clamp' sl channel sl 'stepto*']);
figure('Color','w','Name',['Activation Kinetics for ' channel ' (' resultsfolder ')' ],'units','normalized','outerposition',[0 0 1 1]);
xlabel('Time (ms)')
ylabel('Potential (mV)')
subplot(1,3,1)

tau=zeros(length(files),1);
pot=zeros(length(files),1);
newtau=zeros(length(files),1);
newA=zeros(length(files),1);

for r=1:length(files)    
    b=length('stepto_');
    pot(r)=str2double(files(r).name(b+1:end-4));
    t = importdata([repos sl 'cellclamp_results' sl resultsfolder sl 'clamp' sl channel sl files(r).name]);
    datamax = max(t.data(:,wi));
    datamin = min(t.data(:,wi));
    t.data(:,ki)=t.data(:,wi); %sgolayfilt(t.data(:,wi),4,55);
    t.data(:,ki)=min(t.data(:,ki),datamax);
    t.data(:,ki)=max(t.data(:,ki),datamin);
    if pot(r)==poi
        plot(t.data(:,1),t.data(:,ki),'r')
    else
        plot(t.data(:,1),t.data(:,ki),'b')
    end
    hold on

    newA(r)=max(t.data(startidx:end,ki));
    ss=max(t.data(startidx:end,ki));
    idx=find(t.data(startidx:end,ki)>=(1-1/(exp(1)))*ss,1,'first');
    if pot(r)==poi
        lh(1)=plot(t.data(idx+startidx-1,1),t.data(idx+startidx-1,ki),'r','Marker','.','MarkerSize',10);
    else
        plot(t.data(idx+startidx-1,1),t.data(idx+startidx-1,ki),'b','Marker','.','MarkerSize',10)
    end
    try
        tau(r)=t.data(idx+startidx-1,1)-t.data(startidx,1);
        if tau(r)>fitwindow
            tau(r)=NaN;
        end
    catch
        tau(r)=NaN;
    end
    
    myt = t.data(startidx:startidx+fitwindow/dt,1);
    [taunew, minval]=fit_tau(myt-myt(1),t.data(startidx:startidx+fitwindow/dt,ki),calcI,newA(r)); 

    myI = calcI(newA(r),myt-myt(1),taunew);
    if pot(r)==poi
        lh(2)=plot(myt,myI,'LineStyle',':','Color','g');
        saveminval = minval;
    end
    
    newtau(r)=taunew;
end
xlim([starttime starttime+fitwindow])
title({'Traces for voltage steps',[resultsfolder ': ' channel]})
xlabel('Time (ms)')
legend(lh,{[num2str(poi) ' mV'],['Fit line (' num2str(saveminval) ' SS)']},'Location','NorthEast')

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
ylabel('Rise tau (ms)')
title({'Rise Time Constant',['Time to reach ' sprintf('%3.1f',(1-1/exp(1))*100) '% of steady state value']})

subplot(1,3,3)
ax=plotyy(pot,newtau,pot(~isnan(newtau)),newA(~isnan(newtau)));
set(ax(2),'ylim',[0 A],'YTickMode','auto')
hold on
plot(pot(idx),newtau(idx),'Marker','.','MarkerSize',10,'Color','r')
text(pot(idx),newtau(idx),[' ' num2str(newtau(idx)) ' ms'])
xlabel('Step Potential (mV)')
ylabel(ax(1),'Activation tau (ms)')
ylabel(ax(2),'A')
title({'Activation Time Constant',[func2str(calcI) ' A=' num2str(newA(idx))]},'Interpreter','None')

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