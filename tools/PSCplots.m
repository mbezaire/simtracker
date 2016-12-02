function PSCplots(mystruct)

inh=1;
exc=0;

startidx=100;

if exc==1
    figure('Color','w')
    tmpidx=find(strcmp('pyramidalcellpyramidalcell',{mystruct(:).name})==1);
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[1 .75 .0],'LineWidth',3)
    hold on
    tmpidx=find(strcmp('ca3cellpyramidalcell',{mystruct(:).name})==1);
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[.0 .75 .65],'LineWidth',3)
    tmpidx=find(strcmp('eccellpyramidalcell',{mystruct(:).name})==1);
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[1 .0 .0],'LineWidth',3)
    legend({'Local Collateral','CA3','Entorhinal Cortical'})
    %xlim([0.05 100])
    title('Excitatory synapses')
    xlabel('Time (ms)')
    ylabel('Current (nA)')
end

if inh==1
    figure('Color','w')
    tmpidx=find(strcmp('cckcellpyramidalcell',{mystruct(:).name})==1);
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[1 .75 .0],'LineWidth',3)
    hold on
    tmpidx=find(strcmp('pvbasketcellpyramidalcell',{mystruct(:).name})==1);
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[.0 .75 .65],'LineWidth',3)
    tmpidx=find(strcmp('axoaxoniccellpyramidalcell',{mystruct(:).name})==1);
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[1 .0 .0],'LineWidth',3)
    legend({'CCK Basket','PV Basket','Axo-axonic'})
    %xlim([0.05 100])
    title('Perisomatic synapses')
    xlabel('Time (ms)')
    ylabel('Current (nA)')

    figure('Color','w')
    tmpidx=find(strcmp('scacellpyramidalcell',{mystruct(:).name})==1); %scacellpyramidalcell_o
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[1 .75 .0],'LineWidth',3)
    hold on
    tmpidx=find(strcmp('bistratifiedcellpyramidalcell',{mystruct(:).name})==1); % bistratifiedcellpyramidalcell_o
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[.6 .4 .1],'LineWidth',3)
    tmpidx=find(strcmp('ivycellpyramidalcell',{mystruct(:).name})==1); % ivycellpyramidalcell_ab
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[.6 .6 .6],'LineWidth',3)
    legend({'SCA','Bistratified','Ivy'})
    %xlim([0.05 100])
    title('Proximal dendritic synapses')
    xlabel('Time (ms)')
    ylabel('Current (nA)')
    %set(gca,'FontWeight','bold','FontSize',12)

    figure('Color','w')
    tmpidx=find(strcmp('olmcellpyramidalcell',{mystruct(:).name})==1); %olmcellpyramidalcell_o
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[.5 .0 .6],'LineWidth',3)
    hold on
    tmpidx=find(strcmp('ngfcellpyramidalcell',{mystruct(:).name})==1); %ngfcellpyramidalcell_ab
    plot(mystruct(tmpidx).time(startidx:end),mystruct(tmpidx).meantrance(startidx:end)-mystruct(tmpidx).meantrance(startidx),'Color',[.8 .8 .8],'LineWidth',3)
    legend({'O-LM','Neurogliaform'})
    %xlim([0.05 100])
    title('Distal dendritic synapses')
    xlabel('Time (ms)')
    ylabel('Current (nA)')
end
