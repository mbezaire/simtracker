function plotsinglecell(tmp,ci,li,hif,hhyp,hhcn,cellname,myresultsfolder,repos)
%colorvec={'b','g','m','k','r','c'};

    [R G B]=meshgrid([.1:.4:1],[.1:.4:1],[.1:.4:1]);
    colorvec = [R(:) G(:) B(:)];
    colorvec = colorvec([3:2:end 2:2:end],1:3);
        colorvec2=[ 
                    1 .8 0; ...
                    1 0 1; ...
                    0 1 1; ...
                    .4 .4 .4; ...
                    1 0 0; ...
                    0 1 0; ...
                    0 0 1; ...
                    0 0 0; ...
                    1 .5 .5; ...
                    .5 0 1; ...
                     .9 .4 .1; ...
                   .8 .8 .8; ...
            ]; 

linevec={'-','--','-.',':','-','--','-.',':'};
li= floor((ci-1)/length(colorvec))+1;
ci = mod((ci-1),length(colorvec))+1;
jcnpot=14.6;
disp(['Exp. includes junction potential of ' num2str(jcnpot) ' mV'])
figure(hif)
subplot(1,2,1)
plot(tmp.ivec(tmp.posidx),tmp.max(tmp.posidx)-jcnpot,'Color',colorvec(ci,:),'LineStyle',linevec{li},'Marker','.')
logplot(repos,myresultsfolder,tmp.ivec(tmp.posidx),tmp.max(tmp.posidx)-jcnpot,cellname,'Max Depolarization','Current (pA)','Max potential (mV)',get(hif,'Name'))
subplot(1,2,2)
plot(tmp.ivec,tmp.fvec,'Color',colorvec(ci,:),'LineStyle',linevec{li},'Marker','.')
logplot(repos,myresultsfolder,tmp.ivec,tmp.fvec,cellname,'IF Curve','Current (pA)','Firing frequency (Hz)',get(hif,'Name'))


figure(hhyp)
subplot(1,2,1)
plot(tmp.ivec(tmp.negidx),tmp.min(tmp.negidx)-jcnpot,'Color',colorvec(ci,:),'LineStyle',linevec{li},'Marker','.')
logplot(repos,myresultsfolder,tmp.ivec(tmp.negidx),tmp.min(tmp.negidx)-jcnpot,cellname,'Minimum Potential','Current (pA)','Minimum potential (mV)',get(hhyp,'Name'))

subplot(1,2,2)
plot(tmp.ivec(tmp.idxes),tmp.ss(tmp.idxes)-jcnpot,'Color',colorvec(ci,:),'LineStyle',linevec{li},'Marker','.')
logplot(repos,myresultsfolder,tmp.ivec(tmp.idxes),tmp.ss(tmp.idxes)-jcnpot,cellname,'Steady State','Current (pA)','Steady state potential (mV)',get(hhyp,'Name'))

figure(hhcn)
subplot(1,2,1)
plot(tmp.ivec(tmp.negidx),tmp.diffmin(tmp.negidx),'Color',colorvec(ci,:),'LineStyle',linevec{li},'Marker','.')
logplot(repos,myresultsfolder,tmp.ivec(tmp.negidx),tmp.diffmin(tmp.negidx),cellname,'Sag Peak Amplitude','Current (pA)','Sag amplitude (mV)',get(hhcn,'Name'))

subplot(1,2,2)
plot(tmp.ivec(tmp.negidx),tmp.TimeVec(tmp.mintime(tmp.negidx)),'Color',colorvec(ci,:),'LineStyle',linevec{li},'Marker','.') % don't need to subtract mini because this mintime idx is relative to mini
logplot(repos,myresultsfolder,tmp.ivec(tmp.negidx),tmp.TimeVec(tmp.mintime(tmp.negidx)),cellname,'Sag Peak Time','Current (pA)','Sag Timing (s)',get(hhcn,'Name'))
