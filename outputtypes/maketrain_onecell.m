function h = maketrain_onecell(handles)
global mypath RunArray

h=[]; %figure;
ind = handles.curses.ind;

%gidstr=inputdlg('Enter the gid of the cell to stimulation');
%gid = str2num(gidstr{:});

if isempty(deblank(handles.optarg))
    gidstr=inputdlg('Enter the gid of the cell of interest');
    gid=str2num(gidstr{:});
else
    gid=str2num(handles.optarg);
    gidstr={num2str(gid)};
end

spikeraster = importdata([RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName '/spikeraster.dat']);
spikeraster=sortrows(spikeraster,[1 2]);

celltype = importdata([RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName '/celltype.dat']);
for r=1:length(celltype.data)
    idx= spikeraster(:,2)>=celltype.data(r,2) & spikeraster(:,2)<=celltype.data(r,3);
    spikeraster(idx,3)=celltype.data(r,1);
end

connections = importdata([RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName '/connections.dat']);
presyn=find(connections.data(:,2)==gid);

[~,spike_idx,conn_idx] = intersect(spikeraster(:,2),connections.data(presyn,1));
grr=connections.data(presyn(conn_idx),[1 3]);

spiketrain=spikeraster(spike_idx,:);

for r=1:size(spiketrain,1)
    id = grr(:,1)==spiketrain(r,2);
    spiketrain(r,4)=grr(id,2);
end

syns = unique(spiketrain(:,4));
figure('Color','w','Name',['Gid: ', num2str(gid)])
plot(spiketrain(:,1),spiketrain(:,2),'LineStyle','none','Marker','.','MarkerSize',15,'Color','m')
xlabel('Time (ms)')
ylabel('Precell gid')
title(['Gid: ' num2str(gid)])

pretype = 0;
wgt = 0.025;
delay = 3;

system(['rm ' RunArray(ind).ModelDirectory '/stimulation/stimvecs/*.*']);
fid = fopen([RunArray(ind).ModelDirectory '/stimulation/stimvecs/gridconns_' num2str(gid) '.dat'],'w');
fprintf(fid, '%g\n', length(syns));

for r=1:length(syns)
    id = spiketrain(:,4)==syns(r);
    spiketrain(id,5)=r-1;
    train(r).syn = syns(r);
    fprintf(fid, '%d\t%d\t%d\t%d\t%3.5f\t%d\n', r-1, gid, pretype, syns(r), wgt, delay);
end
fclose(fid);

fid2 = fopen([RunArray(ind).ModelDirectory '/stimulation/stimvecs/gc_vec.dat'],'w');
fprintf(fid2, '%g\n', length(spiketrain));
for r=1:size(spiketrain,1)
    fprintf(fid, '%3.1f\t%d\n', spiketrain(r,1), spiketrain(r,5));
end
fclose(fid2);
