function h=plotperf(hObject,handles)
global RunArray sl mypath
logflag=1;

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
myperfpath=[myrepos(q).dir sl 'Performance'];


tmpdata=get(handles.tbl_runs,'Data');
handles.curses.indices = [];
for r=1:size(handles.indices,1)
    myrow = handles.indices(r,1);
    RunName = tmpdata(myrow,1);
    handles.curses.indices(r) = find(strcmp(RunName,{RunArray.RunName})==1, 1 ); % delete min for real data
end
guidata(hObject,handles);

getruntimes(hObject,handles,handles.curses.indices)
handles = guidata(hObject);
mems=getmemory(handles,handles.curses.indices);
colorvec={'b','m','k','g','r','c','b:','m:','g:','r:','c:','k:'};
numcores = unique([RunArray(handles.curses.indices).NumProcessors]);
h(1)=figure('Color','w','Name','Run Times per Core');
h(2)=figure('Color','w','Name','Max Memory per Core');
h(3)=figure('Color','w','Name','Summed Run Times');
h(4)=figure('Color','w','Name','Summed Max Memory');
h(5)=figure('Color','w','Name','Total SUs required');
h(6)=figure('Color','w','Name','Total SUs required for full scale');
h(7)=figure('Color','w','Name','Hours per core required for full scale');
h(8)=figure('Color','w','Name','SUs required v. Memory');

for myid=1:length(handles.curses.indices)
    myi=handles.curses.indices(myid);
    bb(myid)=RunArray(myi).NumProcessors*RunArray(myi).RunTime*RunArray(myi).Scale;
    disp(num2str(bb(myid)))
end

numcorestr = cell(size(numcores));
for zz=1:length(numcores)
    fidx=find([RunArray(handles.curses.indices).NumProcessors]==numcores(zz));
    numcorestr{zz}=[num2str(numcores(zz)) ' cores'];

    actionlist={'setup','create','connect','run','write'};
    
    if isfield(handles.curses,'times')
        for a=1:length(actionlist)
           x=zeros(length(fidx),1);y=zeros(length(fidx),1);z=zeros(length(fidx),1);
           for f=1:length(fidx)
                myi = handles.curses.indices(fidx(f));
                z(f)=handles.curses.times(fidx(f)).(actionlist{a}).tot;
                y(f)=handles.curses.times(fidx(f)).(actionlist{a}).avg;
                x(f)=RunArray(myi).Scale;
                v(f)=RunArray(myi).NumProcessors;
                %lblx{f}=['1/' num2str(x(f))];
           end
            if logflag==0
                x = 1./x;
            end
            [x, sorti]=sort(x);
            y=y(sorti);
            z=z(sorti);
scalefl=0;
            %handles.curses.times(myi).setup.std
            figure(h(1))
            subplot(2,3,a)

            if scalefl
                plot(x,y,colorvec{zz},'Marker','.','MarkerSize',15)
            else
                plot(v,y,colorvec{zz},'Marker','.','MarkerSize',15)
            end
            %set(gca,'XTickLabel',lblx);
            hold on
            ylabel('Real time (s)')
            if scalefl
                xlabel('Scale')
            else
                xlabel('Cores')
            end
            if logflag==1
                setaxes(gca)
            end
            title([actionlist{a} ' time'])

            figure(h(3))
            subplot(2,3,a)
            if scalefl
                plot(x,z,colorvec{zz},'Marker','.','MarkerSize',15)
            else
                plot(v,z,colorvec{zz},'Marker','.','MarkerSize',15)
            end
            hold on
            ylabel('Summed real time (s)')
            if scalefl
                xlabel('Scale')
            else
                xlabel('Cores')
            end
            if logflag==1
                setaxes(gca)
            end
            title([actionlist{a} ' time'])

        end
    end    
    % all
    x=zeros(length(fidx),1);y=zeros(length(fidx),1);z=zeros(length(fidx),1);
    for f=1:length(fidx)
        myi = handles.curses.indices(fidx(f));
        z(f)=RunArray(myi).RunTime*RunArray(myi).NumProcessors;
        y(f)=RunArray(myi).RunTime;
        x(f)=RunArray(myi).Scale;
        v(f)=RunArray(myi).NumProcessors;
    end
    if logflag==0
        x = 1./x;
    end
    [x, sorti]=sort(x);
    y=y(sorti);
    z=z(sorti);
    
    figure(h(1))
    subplot(2,3,6)

            if scalefl
    plot(x,y,colorvec{zz},'Marker','.','MarkerSize',15)
            else
    plot(v,y,colorvec{zz},'Marker','.','MarkerSize',15)
            end
    hold on
    ylabel('Real time (s)')
            if scalefl
                xlabel('Scale')
            else
                xlabel('Cores')
            end
            if logflag==1
                setaxes(gca)
            end
    title('Total time')

    figure(h(3))
    subplot(2,3,6)
            if scalefl
    plot(x,z,colorvec{zz},'Marker','.','MarkerSize',15)
            else
     plot(v,z,colorvec{zz},'Marker','.','MarkerSize',15)
           end
    hold on
    ylabel('Real time (s)')
            if scalefl
                xlabel('Scale')
            else
                xlabel('Cores')
            end
            if logflag==1
                setaxes(gca)
            end
    title('Total time')
    
    figure(h(5))
    plot(x,z/3600,colorvec{zz},'Marker','.')
    hold on
    ylabel('SUs')
    xlabel('Scale of model (Scale:1 real:model cells)')
            if logflag==1
                setaxes(gca)
            end
    title('Total SUs required per job')
    set(gca,'FontSize',14)
    xlhand = get(gca,'xlabel');
    set(xlhand,'fontsize',14) 
    xlhand = get(gca,'ylabel');
    set(xlhand,'fontsize',14) 
    xlhand = get(gca,'title');
    set(xlhand,'fontsize',14)    

    memlist={'VIRT','RES','SHR'}; % mallinfo
    DivBy=1024*1024; % GB

    for a=1:length(memlist)
        x=zeros(length(fidx),1);y=zeros(length(fidx),1);z=zeros(length(fidx),1);
       for f=1:length(fidx)
            myi = handles.curses.indices(fidx(f));
            try
            y(f)=max([mems(fidx(f)).memstruct(:).(memlist{a})])/DivBy;
            catch me
                me
            end
            z(f)=y(f)*RunArray(myi).NumProcessors;
            x(f)=RunArray(myi).Scale;
       end
    if logflag==0
        x = 1./x;
    end
    [x, sorti]=sort(x);
        y=y(sorti);
        z=z(sorti);
        
        figure(h(2))
        subplot(2,2,a)

        plot(x,y,colorvec{zz},'Marker','.')
        hold on
        ylabel('Memory (GB)')
        xlabel('Scale')
            if logflag==1
                setaxes(gca)
            end
        title([memlist{a} ' memory'])
        
        figure(h(4))
        subplot(2,2,a)
        plot(x,z,colorvec{zz},'Marker','.')
        hold on
        ylabel('Memory (GB)')
        xlabel('Scale')
            if logflag==1
                setaxes(gca)
            end
        title([memlist{a} ' memory'])
    end

    % mallstruct(:).mallinfo
    x=zeros(length(fidx),1);y=zeros(length(fidx),1);z=zeros(length(fidx),1);
    for f=1:length(fidx)
        myi = handles.curses.indices(fidx(f));
        y(f)=max([mems(fidx(f)).mallstruct(:).mallinfo])/DivBy;
        z(f)=y(f)*RunArray(myi).NumProcessors;
        x(f)=RunArray(myi).Scale;
    end
    if logflag==0
        x = 1./x;
    end
    [x, sorti]=sort(x);
    y=y(sorti);
    z=z(sorti);

    figure(h(2))
    subplot(2,2,4)
    plot(x,y,colorvec{zz},'Marker','.')
    hold on
    ylabel('Memory (GB)')
    xlabel('Scale')
            if logflag==1
                setaxes(gca)
            end
    title('Mallinfo memory')

    figure(h(4))
    subplot(2,2,4)
    plot(x,z,colorvec{zz},'Marker','.')
    hold on
    ylabel('Memory (GB)')
    xlabel('Scale')
            if logflag==1
                setaxes(gca)
            end
    title('Mallinfo memory')
end
figure(h(1))
subplot(2,3,6)
legend(numcorestr)

figure(h(3))
subplot(2,3,6)
legend(numcorestr)

figure(h(2))
subplot(2,2,4)
legend(numcorestr)

figure(h(4))
subplot(2,2,4)
legend(numcorestr)

figure(h(5))
legend(numcorestr)


uniqscaletmp=unique([RunArray(handles.curses.indices).Scale]);

uniqscale=uniqscaletmp(uniqscaletmp>100 & uniqscaletmp<=150);
legstr={};
figure(h(8))
for u=1:length(uniqscale)
    fidx = find([RunArray(handles.curses.indices).Scale]==uniqscale(u));
    for f=1:length(fidx)
        myi = handles.curses.indices(fidx(f));
        mvirt(f) = max([mems(fidx(f)).memstruct(:).VIRT])/DivBy;
        mres(f) = max([mems(fidx(f)).memstruct(:).RES])/DivBy;
        z(f) = RunArray(myi).NumProcessors*RunArray(myi).RunTime*RunArray(myi).Scale;
    end
    hl(u)=plot(mvirt,z/3600,colorvec{u},'Marker','.','LineStyle','none','MarkerSize',24);
    hold on
    %hl(length(uniqscale)+1)=plot(mres,z/3600,colorvec{u},'Marker','o','LineStyle','none','MarkerSize',10);
    legstr{length(legstr)+1} = ['Scale: ' num2str(uniqscale(u))];
end
%legstr{length(legstr)+1} = 'RES memory';
if length(uniqscale)>0
legend(hl,legstr)
end
ylabel('SUs*Scale')
xlabel('Virtual memory per core (GB)')
title('Total SUs required for small jobs')
set(gca,'FontSize',14)
xlhand = get(gca,'xlabel');
set(xlhand,'fontsize',14) 
xlhand = get(gca,'ylabel');
set(xlhand,'fontsize',14) 
xlhand = get(gca,'title');
set(xlhand,'fontsize',14) 


fidx=find([RunArray(handles.curses.indices).Scale]==1);
x=zeros(length(fidx),1);y=zeros(length(fidx),1);z=zeros(length(fidx),1);
for f=1:length(fidx)
    myi = handles.curses.indices(fidx(f));
    z(f)=RunArray(myi).RunTime*RunArray(myi).NumProcessors;
    y(f)=RunArray(myi).RunTime;
    x(f)=RunArray(myi).NumProcessors;
end
figure(h(6))
plot(x,z/3600,'b','Marker','.','LineStyle','none','MarkerSize',24)
ylabel('SUs')
xlabel('Cores')
title('Total SUs required for a full-scale job')
set(gca,'FontSize',14)
xlhand = get(gca,'xlabel');
set(xlhand,'fontsize',14) 
xlhand = get(gca,'ylabel');
set(xlhand,'fontsize',14) 
xlhand = get(gca,'title');
set(xlhand,'fontsize',14) 

figure(h(7))
plot(x,y/3600,'b','Marker','.','LineStyle','none','MarkerSize',24)
ylabel('Real hours')
xlabel('Cores')
title('Hours required per core for a full-scale job')
set(gca,'FontSize',14)
xlhand = get(gca,'xlabel');
set(xlhand,'fontsize',14) 
xlhand = get(gca,'ylabel');
set(xlhand,'fontsize',14) 
xlhand = get(gca,'title');
set(xlhand,'fontsize',14) 


if logflag==0
    figure(h(1))
    set(gcf,'units','normalized','OuterPosition',[0 0 1 1])
    for r=1:6
        subplot(2,3,r)
        myx=get(gca,'XTick');
        myxd=round([1./myx]);
        lblx={};
        for w=1:length(myxd)
            lblx{w}=['1/' num2str(myxd(w))];
        end
        set(gca,'XTickLabel',lblx)
    end

    figure(h(3))
    set(gcf,'units','normalized','OuterPosition',[0 0 1 1])
    for r=1:6
        subplot(2,3,r)
        myx=get(gca,'XTick');
        myxd=round([1./myx]);
        lblx={};
        for w=1:length(myxd)
            lblx{w}=['1/' num2str(myxd(w))];
        end
        set(gca,'XTickLabel',lblx)
    end

    figure(h(2))
    set(gcf,'units','normalized','OuterPosition',[0 0 1 1])
    for r=1:4
        subplot(2,2,r)
        myx=get(gca,'XTick');
        myxd=round([1./myx]);
        lblx={};
        for w=1:length(myxd)
            lblx{w}=['1/' num2str(myxd(w))];
        end
        set(gca,'XTickLabel',lblx)
    end

    figure(h(4))
    set(gcf,'units','normalized','OuterPosition',[0 0 1 1])
    for r=1:4
        subplot(2,2,r)
        myx=get(gca,'XTick');
        myxd=round([1./myx]);
        lblx={};
        for w=1:length(myxd)
            lblx{w}=['1/' num2str(myxd(w))];
        end
        set(gca,'XTickLabel',lblx)
    end
end

if exist(myperfpath,'dir')==0
    mkdir(myperfpath)
end
for r=1:length(h) % 8
    figure(h(r));
    myname = get(figure(h(r)),'Name');
    savefig(h(r),[myperfpath '\' 'Performance_' strrep(strrep(myname,' ','_'),'.','_')])
    print(h(r),'-dbmp','-r300',[myperfpath '\' 'Performance_' strrep(strrep(myname,' ','_'),'.','_')])
end


function setaxes(myaxis)
set(myaxis,'XScale','log')
set(myaxis,'YScale','log')
