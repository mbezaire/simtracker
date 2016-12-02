function h=Website_Phases_Figure(cells,Hz,mystr,runname)
global sl

% load exp data, only use a subset of it
if Hz<20
    nrninput = gettheta(-1);
else
    nrninput = getgamma(-1);
end

period = 125;
Hzval = 8;
trace.data=0:.025:(period*2);
trace.data=trace.data';

excell = -sin((Hzval*(2*pi))*trace.data(:,1)/1000 + pi/2);  % -13.8/125);  %  - handles.phasepref +   -  (0.25)*Hzval*2*pi

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
websitepath=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
if exist(websitepath,'dir')==0
    mkdir(websitepath)
end

fidout2=fopen([websitepath sl 'results' sl 'sinwave.dat'],'w');

xstring = sprintf('%f,',trace.data/250*720); % concatenate times together, separated by commas
ystring = sprintf('%f,',excell); % concatenate PSP values together, separated by commas
fprintf(fidout2,'%s,%s\n','Theta Phase',xstring(1:end-1));
fprintf(fidout2,'%s,%s\n','LFP',ystring(1:end-1));
fclose(fidout2);

matchnames.tech = {'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'};
matchnames.nice = {'Pyramidal','PV+ Basket','CCK+ Basket','Schaff. Coll.-Assoc.','Axo-axonic','Bistratified','O-LM','Ivy','Neurogliaform'};

fidout2=fopen([websitepath sl 'results' sl  runname sl 'lfp_' mystr '_exp.dat'],'w');

% 'Experimental'
for n=1:length(nrninput)
    nrninput(n).start = nrninput(n).phase/360*period;
    nrninput(n).tidx(1)=find(trace.data>=nrninput(n).start,1,'first');
    nrninput(n).tidx(2)=find(trace.data>=nrninput(n).start+period,1,'first');

    x = trace.data(nrninput(n).tidx)/250*720;
    y = excell(nrninput(n).tidx);

    if ~isempty(strmatch(nrninput(n).tech,matchnames.tech))
        fprintf(fidout2,'%s,%f,%f\n',nrninput(n).tech,x(1),x(2));
        fprintf(fidout2,'%s,%f,%f\n',nrninput(n).tech,y(1),y(2));
    end

    % nrninput(n).state
end
fclose(fidout2);


% 'Model'
fidout2=fopen([websitepath sl 'results' sl  runname sl 'lfp_' mystr '_model.dat'],'w');

for n=1:length(cells)
    if isempty(cells(n).phase) || isnan(cells(n).phase)
        continue;
    end
    cells(n).start = cells(n).phase/360*period;
    try
    cells(n).tidx(1)=find(trace.data>=cells(n).start,1,'first');
    cells(n).tidx(2)=find(trace.data>=cells(n).start+period,1,'first');
    catch me
        me
    end

    x = trace.data(cells(n).tidx)/250*720;
    y = excell(cells(n).tidx);
    colvec = cells(n).color;
    % cells(n).name
    % cells(n).phase

    fprintf(fidout2,'%s,%f,%f\n',cells(n).name,x(1),x(2));
    fprintf(fidout2,'%s,%f,%f\n',cells(n).name,y(1),y(2));
end
fclose(fidout2);

disp('Phase differences:')
tol=80;
% match which exp with which model
for n=1:length(cells)
    cells(n).myi = strmatch(matchnames.nice{strmatch(cells(n).name,matchnames.tech)},{nrninput(:).name});
    if isempty(cells(n).myi)
        if Hz>20
            cells(n).myi = NaN; %strmatch('Pyramidal',{nrninput(:).name});
        else
            cells(n).myi = strmatch('PPA',{nrninput(:).name});
        end
    end
    if isnan(cells(n).myi)
        cells(n).phasediff = 0;
        cells(n).shiftme = 0;
    else
        cells(n).phasediff = mod(cells(n).phase - nrninput(cells(n).myi).phase,360);
        if abs(cells(n).phasediff)>tol && abs(cells(n).phasediff)<(360-tol)
            cells(n).shiftme = 1;
        else
            cells(n).shiftme = 0;
        end
    end
    disp([matchnames.nice{strmatch(cells(n).name,matchnames.tech)} ': ' num2str(cells(n).phasediff) '. shiftme = ' num2str(cells(n).shiftme)])
end

tolvec = 0:10:360;
for n=1:length(cells)
    cells(n).myi = strmatch(matchnames.nice{strmatch(cells(n).name,matchnames.tech)},{nrninput(:).name});
    if isempty(cells(n).myi)
        if Hz>20
            cells(n).myi = NaN; %strmatch('Pyramidal',{nrninput(:).name});
        else
            cells(n).myi = strmatch('PPA',{nrninput(:).name});
        end
        if isnan(cells(n).myi)
            cells(n).phasediff = 0;
            cells(n).shiftme = zeros(size(tolvec));
        else
            cells(n).phasediff = mod(cells(n).phase - nrninput(cells(n).myi).phase,360);
        end
    end
end


for tt = 1:length(tolvec)
    tol = tolvec(tt);
    for n=1:length(cells)
        if ~isnan(cells(n).myi) && abs(cells(n).phasediff)>tol && abs(cells(n).phasediff)<(360-tol)
            cells(n).shiftme(tt) = 1;
        else
            cells(n).shiftme(tt) = 0;
        end
    end
end


% compute shifts
shift = zeros(size(tolvec));
shifttmp=[];
for tt = 1:length(tolvec)    
    for ss=1:length(cells)
        shifttmp(ss)=cells(ss).shiftme(tt);
    end
    shift(tt) = -mean([cells(shifttmp== 1).phasediff]);
    if isempty(shift(tt)) || isnan(shift(tt))
        shift(tt)=0;
    end
end

for tt = 1:length(tolvec)    
    for n=1:length(cells)
        if cells(n).shiftme(tt) == 1
            cells(n).shiftedphase(tt) = mod(cells(n).phase + shift(tt),360);
        else
            cells(n).shiftedphase(tt) = cells(n).phase;
        end
        try
            cells(n).newphasediff(tt) = mod(cells(n).shiftedphase(tt) - nrninput(cells(n).myi).phase+180,360)-180;
        catch ME
            cells(n).newphasediff(tt) = 0;
        end
        %disp([matchnames.nice{strmatch(cells(n).name,matchnames.tech)} ': ' num2str(cells(n).phasediff) '. shiftme = ' num2str(cells(n).shiftme) ', shifted phase = ' num2str(cells(n).shiftedphase)])
    end
end

for tt = 1:length(tolvec) 
    mySSE(tt)=0;
    for n=1:length(cells)
        mySSE(tt) = mySSE(tt) + (cells(n).newphasediff(tt))^2;
    end
end

[minvalSSE mini]=min(mySSE);

ttval=mini;

% 'Shifted'
fidout2=fopen([websitepath sl 'results' sl  runname sl 'lfp_' mystr '_shift.dat'],'w');

for n=1:length(cells)
    if isempty(cells(n).phase) || isnan(cells(n).phase)
        continue;
    end
    
    cells(n).start = cells(n).shiftedphase(ttval)/360*period;
    try
    cells(n).tidx(1)=find(trace.data>=cells(n).start,1,'first');
    cells(n).tidx(2)=find(trace.data>=cells(n).start+period,1,'first');
    catch me
        me
    end

    x = trace.data(cells(n).tidx)/250*720;
    y = excell(cells(n).tidx);
    colvec = cells(n).color;
    
    % cells(n).name
    % cells(n).shiftedphase(ttval)

    % cells(n).shiftme(ttval) == 1
    fprintf(fidout2,'%s,%f,%f\n',cells(n).name,x(1),x(2));
    fprintf(fidout2,'%s,%f,%f\n',cells(n).name,y(1),y(2));
end
fclose(fidout2);
h=mySSE(end);
