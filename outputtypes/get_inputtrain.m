function h=get_inputtrain(handles) % idx contains the column in the spikeraster that gives the cell type index
global mypath RunArray sl

substitute=1;
if substitute==1
    f=importdata('C:\Users\M\Desktop\repos\ca1\netclamp\ReserveTrestles_01\newaxoraster.dat');
    fi=find(handles.curses.spikerast(:,2)>=0 & handles.curses.spikerast(:,2)<=458);
    handles.curses.spikerast(fi,:)=[];
    handles.curses.spikerast=[handles.curses.spikerast; f];
    handles.curses.spikerast=sortrows(handles.curses.spikerast,[1 2]);
end

h=[]; %figure;
idx = handles.curses.ind;
%sl = handles.curses.sl;
d=1;

if isempty(deblank(handles.optarg))
    gidstr=inputdlg('Enter the type of cell of interest');
    mytype=gidstr{:};
else
    mytype=handles.optarg;
end

alist=dir([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'trace_' mytype '*.dat']);

if isempty(alist)
    msgbox('There are no trace available for that type.')
    return
end

for atype=1:length(alist)
    a = alist(atype);
    gidsnip = a.name(length(['trace_' mytype])+1:end-4);
    gidstr = {gidsnip};
    gid = str2num(gidsnip);
    

    mycell = a.name(7:end-4);
    x = length(gidstr{:});
    celltype = mycell(1:end-x);

    if exist([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'cell_syns.dat'], 'file')
        %cell_syns = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/cell_syns.dat']);
        [A B C]=textread([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'cell_syns.dat'],'%d\t%d\t%d\n','headerlines',1);
        cell_syns=[A B C];
    else
        %cell_syns = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/connections.dat']);
        [A B C]=textread([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'connections.dat'],'%d\t%d\t%d\n','headerlines',1);
        cell_syns=[A B C];
    end
    clear A B C
    %cell_syns=cell_syns.data;

    inputs = cell_syns(cell_syns(:,2)==gid,:);

    if isempty(inputs)
        return
    end
    %inputs = unique(inputs, 'rows');



    if isempty(handles.curses.spikerast)
        spiketrain=[];
    else
        spike_idx = ismember(handles.curses.spikerast(:,2),inputs(:,1));
        spiketrain = handles.curses.spikerast(spike_idx,:);
    end


    spiketrain=spiketrain(ismember(spiketrain(:,2),inputs(:,1)),:);
    spiking_inputs=inputs(ismember(inputs(:,1),spiketrain(:,2)),:);
    avgsyns=size(spiking_inputs,1)/length(unique(spiking_inputs(:,1)));
    myi=size(spiketrain,1);
    myistart=myi;
    spiketrain(:,4)=-1;
    spiketrain(end+1:round(myi*(avgsyns+.5)),:)=-1;

    for r=1:myistart
        id = find(spiking_inputs(:,1)==spiketrain(r,2));
        spiketrain(r,4)=spiking_inputs(id(1),3); % add the synapse id
        for k=2:length(id)
            myi=myi+1;
            spiketrain(myi,:)=[spiketrain(r,1:3) spiking_inputs(id(k),3)]; % add the synapse id
        end    
    end

    if myi<size(spiketrain,1)
        spiketrain=spiketrain(1:myi,:);
    end

    %%%%%%%%%%%%%%

    handles.prop = {'postcell','precell','weight','conns','syns'}; %, 'strength', 'numcons'};
    fid = fopen([RunArray(idx).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(idx).ConnData) '.dat']);
    numlines = textscan(fid,'%d\n',1);
    propstr=' %f %f %f';
    c = textscan(fid,['%s %s' propstr '\n'],'Delimiter',' ', 'MultipleDelimsAsOne',0);
    st = fclose(fid);

    numcon = [];
    handles.conndata=[];

    if size(c{1,1},1)>0
        for r=1:numlines{1,1}
            postcell = c{1,2}{r};
            precell = c{1,1}{r};
            if ~isfield(handles.conndata,postcell)
                handles.conndata.(postcell)=[];
            end
            if ~isfield(handles.conndata.(postcell), precell)
                handles.conndata.(postcell).(precell)=[];
            end
            try
            for z = 3:length(handles.prop)
                handles.conndata.(postcell).(precell).(handles.prop{z}) = c{1,z}(r);
            end
            catch
                z
            end
        end
    end

    %%%%%%%%%%%%%%

    handles.prop = {'precell','tau1','tau2','e','tau1a','tau2a','ea','tau1b','tau2b','eb'}; %, 'strength', 'numcons'};
    mysl=findstr(RunArray(idx).ModelDirectory,'/');
    if isempty(mysl)
        mysl='\';
    else
        mysl='/';
    end

    fid = fopen([RunArray(idx).ModelDirectory mysl 'datasets' mysl 'syndata_' num2str(RunArray(idx).SynData) '.dat']);
    numlines = textscan(fid,'%d\n',1);
    propstr=' %f %f %f %f %f %f %f %f %f';
    c = textscan(fid,['%s %s' propstr '\n'],'Delimiter',' ', 'MultipleDelimsAsOne',0);
    st = fclose(fid);

    numcon = [];
    handles.data=[];
    if size(c{1,1},1)>0
        for r=1:numlines{1,1}
            postcell = c{1,1}{r};
            precell = c{1,2}{r};
            if ~isfield(handles.data,postcell)
                handles.data.(postcell)=[];
            end
            if ~isfield(handles.data.(postcell), precell)
                handles.data.(postcell).(precell)=[];
                handles.data.(postcell).(precell).syns=[];
                n = 1;
            else
                n = length(handles.data.(postcell).(precell).syns)+1;
            end
            try
            for z = 2:length(handles.prop)
                handles.data.(postcell).(precell).syns(n).(handles.prop{z}) = c{1,z+1}(r);
            end
            catch
                z
            end
        end
    end

    mysyns=[];
    allsyns = importdata([RunArray(idx).ModelDirectory sl 'results' sl  RunArray(idx).RunName sl 'allsyns.dat']);

    for r=1:length(allsyns.data)
        if ~isfield(mysyns,allsyns.textdata{r,1})
            mysyns.(allsyns.textdata{r,1})=[];
        end
        if ~isfield(mysyns.(allsyns.textdata{r,1}),allsyns.textdata{r,2})
            mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2})=[];
        end
        mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2}).synstart = allsyns.data(r,1);
        mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2}).synend = allsyns.data(r,2);
        mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2}).numsyns = allsyns.data(r,2)-allsyns.data(r,1)+1;
    end
    post = celltype;

    mycells = importdata([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'celltype.dat']);

    u = unique(spiketrain(:,4));

    if exist([RunArray(idx).ModelDirectory sl 'netclamp' sl RunArray(idx).RunName ], 'dir')==0;
        mkdir([RunArray(idx).ModelDirectory sl 'netclamp' sl RunArray(idx).RunName ]);
    end

    myfile = [RunArray(idx).ModelDirectory sl 'netclamp' sl RunArray(idx).RunName sl celltype '_' num2str(gid) '_NetStimConns.dat'];
    fid = fopen(myfile,'w');
    mypre = fieldnames(mysyns.(post));

    fprintf(fid,'%d\t%d\n', mysyns.(post).(mypre{end}).synend+1,length(mypre));
    for r=1:length(mypre)
        b=find(strcmp(mycells.textdata(:,1),mypre{r})==1)-2;
        fprintf(fid,'%d\t%d\n', b, mysyns.(post).(mypre{r}).numsyns);
    end
    fclose(fid);

    spiketrain = sortrows(spiketrain,1);
    myfile = [RunArray(idx).ModelDirectory sl 'netclamp' sl RunArray(idx).RunName sl celltype '_' num2str(gid) '_NetStimTimes.dat'];
    fid = fopen(myfile,'w');
    fprintf(fid,'%d\n',length(spiketrain(:,4)));

    ConDelay=3;

    for z=1:length(spiketrain(:,1))
        if RunArray(idx).AxConVel~=0
            % Compute ConDelay as a function of position of pre and post cells
%             BinInfo = setBins(handles.curses.cells(myrs).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerLength);
% 
%             for z=1:size(positions2plot,1)
%                 pos = getpos(positions2plot(z,2), handles.curses.cells(myrs).range_st, BinInfo, ZHeight);
%                 positions2plot(z, 3) = pos.x;
%                 positions2plot(z, 4) = pos.y;
%                 positions2plot(z, 5) = pos.z;
%             end

        end
        fprintf(fid,'%f\t%d\n', spiketrain(z,1)+ConDelay-.5, spiketrain(z,4)+1); % .5 of an ms will always be added as the ConDelay in the hoc code. Start NetStimGids at 1
    end

    fclose(fid);
end
msgbox('Done!')