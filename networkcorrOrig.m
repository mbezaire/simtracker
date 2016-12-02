myrs=[];
for r=1:length(handles.curses.cells) % left width depends on whether part of dashboard. if yes, ; %0.3875, if no, .9
    if strcmp(handles.curses.cells(r).techname(1:2),'pp')~=1
        myrs = [myrs r];
    end
end

probflag=1;
toolong=2;
if toolong==0
    cutoff=5;
    j=1;
    h(2)=figure('Color','w');
    for typeA=1:1 %length(myrs)
        idxA=find(handles.curses.spikerast(:,3)==handles.curses.cells(myrs(typeA)).ind);
        Aspikes=handles.curses.spikerast(idxA,1);
        for typeB=1:1 %length(myrs)
            idxB=find(handles.curses.spikerast(:,3)==handles.curses.cells(myrs(typeB)).ind);
            Bspikes=handles.curses.spikerast(idxB,1);
            Amat=repmat(Aspikes,1,length(Bspikes));
            Bmat=repmat(Bspikes',length(Aspikes),1);
            diffmat=Bmat-Amat;
            sidx = find(diffmat(:)>-cutoff & diffmat(:)<cutoff);
            corrVec=diffmat(sidx);
            subplot(length(myrs),length(myrs),j)
            b=hist(corrVec,-cutoff:cutoff);
            bar(-cutoff:cutoff,b/length(corrVec))
            j=j+1;
            xlabel({[handles.curses.cells(myrs(typeB)).name ' spike times relative'],[' to ' handles.curses.cells(myrs(typeA)).name ' spike times (ms)']})
            ylabel(['Spike Prob.'])
        end
    end
elseif toolong==1
    cutoff=5;
    j=1;
    h(2)=figure('Color','w');
    for typeA=1:length(myrs)
        idxA=find(handles.curses.spikerast(:,3)==handles.curses.cells(myrs(typeA)).ind);
        Aspikes=handles.curses.spikerast(idxA,1);
        for typeB=1:length(myrs)
            idxB=find(handles.curses.spikerast(:,3)==handles.curses.cells(myrs(typeB)).ind);
            Bspikes=handles.curses.spikerast(idxB,1);
            
            diffvec=[];
            for r=1:length(Aspikes)
                diffvec = [diffvec; Bspikes((abs(Bspikes-Aspikes(r)))<cutoff)-Aspikes(r)];
            end
            %sidx = find(diffvec(:)>-cutoff & diffvec(:)<cutoff);
            corrVec=diffvec; %(sidx);
            
            subplot(length(myrs),length(myrs),j)
            b=hist(corrVec,-cutoff:cutoff);
            bar(-cutoff:cutoff,b/length(corrVec))
            j=j+1;
            xlabel({[handles.curses.cells(myrs(typeB)).name ' spike times relative'],[' to ' handles.curses.cells(myrs(typeA)).name ' spike times (ms)']})
            ylabel(['Spike Prob.'])
        end
    end
elseif toolong==2
    cutoff=15;
    for typeA=length(myrs) %1:
        %h(1+typeA)=figure('Color','w');
        h(2)=figure('Color','w');
        idxA=find(handles.curses.spikerast(:,3)==handles.curses.cells(myrs(typeA)).ind);
        oldAspikes=handles.curses.spikerast(idxA,1:2);
        Aspikes=[];
        rr=unique(oldAspikes(:,2));
        for bb=1:length(rr)
            suboldAspikes=oldAspikes((oldAspikes(:,2)==rr(bb)),1);
            if length(suboldAspikes)>1
                Aspikes=[Aspikes; suboldAspikes(1); suboldAspikes((suboldAspikes(2:end)-suboldAspikes(1:end-1))>5.5)];
            else
                Aspikes=[Aspikes; suboldAspikes];
            end
        end
        Aspikes=sort(Aspikes);
        legstr={};
        mydata=[];
        for typeB=1:length(myrs)
            if typeA~=typeB
                idxB=find(handles.curses.spikerast(:,3)==handles.curses.cells(myrs(typeB)).ind);
                Bspikes=handles.curses.spikerast(idxB,1);

                diffvec=[];
                for r=1:length(Bspikes)
                    %diffvec = [diffvec; Aspikes((abs(Aspikes-Bspikes(r)))<cutoff)-Bspikes(r)];
                    diffvec = [diffvec; Aspikes( (Aspikes-Bspikes(r))<cutoff & (Aspikes-Bspikes(r))>0)-Bspikes(r)];
                end
                %sidx = find(diffvec(:)>-cutoff & diffvec(:)<cutoff);
                corrVec=diffvec; %(sidx);
                legstr{length(legstr)+1}=handles.curses.cells(myrs(typeB)).name;
                %b=hist(corrVec,-cutoff:cutoff)/length(corrVec);
                if probflag==1
                    b=hist(corrVec,0:cutoff)/length(corrVec);
                else
                    b=hist(corrVec,0:cutoff);
                end
                mydata=[mydata b'];
            end
        end
        %subplot(length(myrs),1,typeA)
        %bar(-cutoff:cutoff,mydata)
        zzz=bar(0:cutoff,mydata);
        set(zzz(1),'FaceColor','b','EdgeColor','none')
        set(zzz(2),'FaceColor','g','EdgeColor','none')
        xlabel([handles.curses.cells(myrs(typeA)).name ' spike times relative to other cells'])
        if probflag==1
            ylabel('Spike Probability')
        else
            ylabel('# Spikes')
        end
        legend(legstr)
        title(RunArray(ind).RunComments)
    end
end