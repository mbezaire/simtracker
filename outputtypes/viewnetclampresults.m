celltype = 'pyramidalcell';

figure('Color','w')
a = dir(['C:\Users\M\Desktop\repos\ca1\netclamp\ReserveTrestles_01\' celltype '_*_NetStimConns.dat']);
cv={'k','b','c','g','m','r'};
for cellfile=1:length(a)
    cellnum = str2num(a(cellfile).name((length(celltype)+2):end-17));
    for cond=[0 11]
        spks = importdata(['C:\Users\M\Desktop\repos\ca1\netclamp\ReserveTrestles_01\' celltype '_' num2str(cellnum) '\spikeraster_' sprintf('%03.0f', cond) '.dat']);
        % read in spikeraster
        % count the number of spikes from gid 0
        numspikes = length(find(spks(:,2)==0));
        cvnum = min(numspikes + 1,length(cv));
        plot(cellnum,cond,'Color',cv{cvnum},'Marker','.','MarkerSize',15)
        hold on
    end
end

xlabel('Cell Num')
ylabel('Condition')

cond=11;
figure('Color','w')
for cellfile=1:length(a)
    cellnum = str2num(a(cellfile).name((length(celltype)+2):end-17));
    trace = importdata(['C:\Users\M\Desktop\repos\ca1\netclamp\ReserveTrestles_01\' celltype '_' num2str(cellnum) '\' celltype '__' num2str(cellnum) '_soma_trace_' sprintf('%03.0f', cond) '.dat']);
    plot(trace.data(:,1),trace.data(:,2),cv{mod((cellfile-1),length(cv))+1})
    hold on
end

title(num2str(cond))
xlabel('Time (ms)')
ylabel('Potential (mV)')

if 1==0
fid = fopen('C:\Users\M\Desktop\repos\ca1\netclamp\ReserveTrestles_01\newaxoraster.dat','w');
%fillin
for r=0:458
    if exist(['C:\Users\M\Desktop\repos\ca1\netclamp\ReserveTrestles_01\axoaxoniccell_' num2str(r) '\spikeraster_' sprintf('%03.0f', cond) '.dat'])
        z=r;
    else
        z=(randi(40)-1)*11;
    end
    spks = importdata(['C:\Users\M\Desktop\repos\ca1\netclamp\ReserveTrestles_01\axoaxoniccell_' num2str(z) '\spikeraster_' sprintf('%03.0f', cond) '.dat']);
    idx = find(spks(:,2)==0);
    for d=1:length(idx)
        fprintf(fid,'%f\t%d\t0\n', spks(idx(d),1), z);
    end
end
fclose(fid)
end