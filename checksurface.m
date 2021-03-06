function checksurface(num)
global mypath tline myresults nums

nums=num2str(num);
fid=fopen(['C:\Users\M\Desktop\repos\pvtiming\cellclamp_results\pleasework_' nums '\runme.sh'],'w');
%fprintf(fid,'export N=C:\nrn73\nmknrndll');
fprintf(fid,['export N=/cygdrive/c/nrn73\nmknrndll ch_Kv3p1bDET' nums '.mod ']); %iconc_CaZ.mod
fclose(fid);

myresults=['C:\Users\M\Desktop\repos\pvtiming\cellclamp_results\pleasework_' nums '\'];
tline={};
%Change some values in the mod file
fid=fopen(['C:\Users\M\Desktop\repos\pvtiming\ch_Kv3p1bDET' nums '.mod'],'r');
while 1
    tline{length(tline)+1} = fgetl(fid); %#ok<AGROW>
    if ~ischar(tline{end}), break, end
end
fclose(fid);
tline=tline(1:end-1);

if 1==1 % do all
    a_range=-0.1:.05:0.05;
    b_range=.2:.2:1.4;
    xa_range=-10:15:65;
    ya_range=-10:10:30;
    yb_range=5:10:45;
    xb_range=-10:15:20;
end
numruns = length(a_range)*length(xa_range)*length(ya_range)*length(b_range)*length(xb_range)*length(yb_range);
disp(['Going to do this many runs: ' num2str(numruns)]);
k=0;
tic
for a=a_range
    for b=b_range
        for xa=xa_range
            for ya=ya_range
                for xb=xb_range
                    for yb=yb_range
                        %tic
                        k=k+1;
                        st=runsim(a,xa,ya,b,xb,yb);
                        if k==1
                            resultstruct=st;
                        else
                            resultstruct(k) = st;
                        end
                        %toc
                    end
                    save([myresults 'resultstruct' nums '.mat'],'resultstruct','-v7.3');
                end
            end
            save([myresults 'resultstruct' nums '.mat'],'resultstruct','-v7.3')
            disp(['Finished xa=' num2str(xa) ' run: ' num2str(k)])
        end
    end
    save([myresults 'resultstruct' nums '.mat'],'resultstruct','-v7.3')
    disp(['Finished a=' num2str(a) ' run: ' num2str(k)])
end
toc
%compare the activation curve to the g, mV data
%compare the time constants to the data


function resultstruct=runsim(a,xa,ya,b,xb,yb)
global mypath tline  myresults nums



%Change some values in the mod file
tline{89}=sprintf('alpha = %7.5f*vtrap((v + %5.2f),%5.2f) : MATLAB fitter', a, xa, ya);
tline{90}=sprintf('beta = %7.5f/exp((v + %5.2f)/%5.2f) : MATLAB fitter', b, xb, yb);
fid=fopen(['C:\Users\M\Desktop\repos\pvtiming\ch_Kv3p1bDET' nums '.mod'],'w'); %#ok<*MCABF>
fprintf(fid,'%s\n',tline{:});
fclose(fid);

%mknrndll
%[~, ~]=
[~, ~]=system(['cd C:\Users\M\Desktop\repos\pvtiming\ &  sh C:\Users\M\Desktop\repos\pvtiming\cellclamp_results\pleasework_' nums '\runme.sh']);

        
%run the cellclamp
[~, ~]=system(['cd C:\Users\M\Desktop\repos\pvtiming & C:\nrn73\bin\nrniv  .\cellclamp_results\pleasework_' nums '\runphys.hoc']);
% record the activation curve 
di=2;
dt=.01;

d_step=dir([ myresults 'stepto_*.dat']);
    
for i=1:length(d_step)
    d_step(i).v = str2double(d_step(i).name(8:end-4));
end

[~, I]=sort([d_step.v]);
d_step=d_step(I);

firstdur=50;
idx=firstdur/dt+2;

for i=length(d_step):-1:1
    data=importdata([ myresults 'stepto_' num2str(d_step(i).v) '.dat']);
    d_step(i).data=data.data;

    try
        d_step(i).inflection=d_step(i).data(idx-2,di);
    catch ME
         disp(['failed: d_step(i).inflection=d_step(i).data(idx-2,di); i=' num2str(i) ', idx=' num2str(idx)])
         d_step(i).inflection=0;
         disp(ME.message)
    end
end

if sum([d_step(:).inflection])==0
    for i=length(d_step):-1:1
        d_step(i).inflection = d_step(i).data(end,di);
    end
end    

infl = [d_step(:).inflection];
volt = [d_step(:).v];
[maxval maxind]=max(abs(infl));
maxval=maxval*(maxval/infl(maxind));
gfrac=infl/maxval;
    
    
% record the time constants and A values
fitwindow=25;
wi=2;
ki=3;

% Rise
A=.001; %#ok<NASGU> %gmax;
calcI = @(A,t,tau) A*(1-exp(-t./tau)).^4;
starttime=50;

startidx = (starttime+dt)/dt;

t.data=d_step([d_step(:).v]==30).data;
datamax = max(t.data(:,wi));
datamin = min(t.data(:,wi));
t.data(:,ki)=sgolayfilt(t.data(:,wi),4,55);
t.data(:,ki)=min(t.data(:,ki),datamax);
t.data(:,ki)=max(t.data(:,ki),datamin);

act_newA=max(t.data(startidx:end,ki));
ss=max(t.data(startidx:end,ki));
idx=find(t.data(startidx:end,ki)>=(1-1/(exp(1)))*ss,1,'first');

act_tau=t.data(idx+startidx-1,1)-t.data(startidx,1);
if act_tau>fitwindow
    act_tau=NaN;
end

myt = t.data(startidx:startidx+fitwindow/dt,1);
[act_newtau, act_minval]=fit_tau(myt-myt(1),t.data(startidx:startidx+fitwindow/dt,ki),calcI,act_newA); 

% Decay
A=.001; %#ok<NASGU> %gmax;
calcI = @(A,t,tau) A*(exp(-t./tau)); % nA
starttime=50+2;
startidx = (starttime+dt)/dt;

t = importdata([myresults 'deact_-60.dat']);

datamax = max(t.data(:,wi));
datamin = min(t.data(:,wi));
t.data(:,ki)=sgolayfilt(t.data(:,wi),4,55);
t.data(:,ki)=min(t.data(:,ki),datamax);
t.data(:,ki)=max(t.data(:,ki),datamin);

dec_newA=mean(t.data(startidx-2/dt:startidx,ki));
ss=min(t.data(end,ki));
amp=t.data(startidx,ki)-ss;
if amp<=0
    dec_tau=NaN;
else
    idx=find(t.data(startidx:end,ki)<=((1/(exp(1)))*amp+ss),1,'first');
    dec_tau=t.data(idx+startidx-1,1)-t.data(startidx,1);
end
if dec_tau>fitwindow
    dec_tau=NaN;
end

myt = t.data(startidx:startidx+fitwindow/dt,1);
if amp<0
    dec_newtau=1;
    dec_minval=0;
else
    [dec_newtau, dec_minval]=fit_tau(myt-myt(1),t.data(startidx:startidx+fitwindow/dt,ki),calcI,dec_newA); 
end


resultstruct.volt = volt;
resultstruct.gfrac = gfrac;

resultstruct.act_newtau = act_newtau;
resultstruct.act_tau = act_tau;
resultstruct.act_newA = act_newA;
resultstruct.act_minval = act_minval;

resultstruct.dec_newtau = dec_newtau;
resultstruct.dec_tau = dec_tau;
resultstruct.dec_newA = dec_newA;
resultstruct.dec_minval = dec_minval;
resultstruct.a=a;
resultstruct.xa=xa;
resultstruct.ya=ya;
resultstruct.b=b;
resultstruct.xb=xb;
resultstruct.yb=yb;

% delete the result files



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


