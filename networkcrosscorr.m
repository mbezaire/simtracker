binsize=10;

pidx=find(handles.curses.spikerast(:,2)>=handles.curses.cells(7).range_st & handles.curses.spikerast(:,2)<=handles.curses.cells(7).range_en);
pspike=handles.curses.spikerast(pidx,:);

pcells = unique(pspike(:,2));
spmat=[];
for p=1:length(pcells)
    spmat(p,:)=histc(pspike(pspike(:,2)==pcells(p),1),[0:binsize:CutMor_032_Long.runinfo.SimDuration]);
end
    
myi=0;
for p=1:length(pcells)
    for r=1:length(pcells)
        if r<p
            myi=myi+1;
            tmp=xcorr(spmat(p,:),spmat(r,:));
            corrvec(myi)=tmp((length(tmp)-1)/2+1);
        end
    end
end

disp(['Avg corr: ' num2str(mean(corrvec)) ', std: ' num2str(std(corrvec))])