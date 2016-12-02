function theta_graphic(varargin)

period = 125;

     
 
col=[.0 .0 .6; 
          1 .0 .0; 
          .6 .4 .1; 
          1 .75 .0; 
          .6 .6 .6; 
          1 .1 1;    
          .5 .0 .6; 
          .0 .75 .65; 
          1 .5 .3;]; 


% load settings/MyThetaGUI.mat originally loaded in the nrninputs, but perhaps safer to just hardcode them here:

nrninput = gettheta;



legstr={};
trace.data=0:.025:(period*2);
trace.data=trace.data';
Hzval = 8;

excell = -sin((Hzval*(2*pi))*trace.data(:,1)/1000 + pi/2);  % -13.8/125);  %  - handles.phasepref +   -  (0.25)*Hzval*2*pi
for n=1:length(nrninput)
nrninput(n).start = nrninput(n).phase/360*period;
end;
for n=1:length(nrninput)
    try
        nrninput(n).tidx(1)=find(trace.data>=nrninput(n).start,1,'first');
        nrninput(n).tidx(2)=find(trace.data>=nrninput(n).start+period,1,'first');
    catch
        nrninput(n).tidx=[NaN NaN];
    end
end
figure('Color','w')
subplot(2,1,1)
plot(trace.data,excell,'k','LineWidth',2)
hold on
mmg=xlim;
shiftme=diff(mmg)/60;
            flag=[];
if ~isempty(varargin)
    switch varargin{1}
        case 'awake'
            flag='w';
        case 'anesthetized'
            flag='a';
        case 'isolated'
            flag='i';
        case 'model'
            flag='m';
        otherwise
            flag=[];
    end
end
for n=1:length(nrninput)
    if isempty(flag) || strcmp(nrninput(n).state(1),flag)
        try
            plot(trace.data(nrninput(n).tidx),excell(nrninput(n).tidx),'MarkerFaceColor',nrninput(n).color,'MarkerEdgeColor','k','LineWidth',0.5,'Marker','o','MarkerSize',8,'LineStyle','none') % nrninput(n).marker, size 10
            if nrninput(n).phase<90 || (nrninput(n).phase>180 && nrninput(n).phase<270)
                text(trace.data(nrninput(n).tidx(1))+shiftme,excell(nrninput(n).tidx(1)),[num2str(nrninput(n).phase) '^o ' nrninput(n).name '^' num2str(nrninput(n).ref)],'Color',nrninput(n).color)
            else
                text(trace.data(nrninput(n).tidx(1))-shiftme,excell(nrninput(n).tidx(1)),[num2str(nrninput(n).phase) '^o ' nrninput(n).name '^' num2str(nrninput(n).ref)],'Color',nrninput(n).color,'HorizontalAlignment','right')
            end
%         plot(trace.data(nrninput(n).tidx),excell(nrninput(n).tidx),'MarkerFaceColor',nrninput(n).color,'MarkerEdgeColor','k','LineWidth',0.5,'Marker','o','MarkerSize',8,'LineStyle','none') % nrninput(n).marker, size 10
%         text(trace.data(nrninput(n).tidx(1)),excell(nrninput(n).tidx(1)),[num2str(nrninput(n).phase) '^o ' nrninput(n).name ' (' nrninput(n).state ')^' num2str(nrninput(n).ref)],'Color',nrninput(n).color)
        end
    end
end
mx=xlim;
my=ylim;
if ~isempty(flag)
    text(mx(1),diff(my)*.75+my(1),varargin{1})
end

ylabel('LFP')
axis off

pos=get(gcf,'Position');
set(gcf,'Position',[pos(1)-pos(3) pos(2) pos(3)*2 pos(4)*2])
pos=get(gcf,'Position');

reftext{1}='an: anesthetized with urethane + ketamine & xylazine';
reftext{2}='wr: awake, head restrained';
reftext{3}='wf: awake, head free';
reftext{4}='';
g=4;
reftext{1+g}='1. Klausberger, et al. Brain-state- and cell-type-specific firing of hippocampal interneurons in vivo. Nature, 2003.';
reftext{2+g}='2. Klausberger, et al. Spike timing of dendrite-targeting bistratified cells during hippocampal network oscillations in vivo. Nat. Neurosci., 2004.';
reftext{3+g}='3. Klausberger, et al. Complementary roles of cholecystokinin- and parvalbumin-expressing GABAergic neurons in hippocampal network oscillations. J. Neurosci., 2005.';
reftext{4+g}='4. Lapray, et al. Behavior-dependent specialization of identified hippocampal interneurons. Nat. Neurosci., 2012.';
reftext{5+g}='5. Varga, et al. Frequency-invariant temporal ordering of interneuronal discharges during hippocampal oscillations in awake mice. PNAS, 2012.';
reftext{6+g}='6. Fuentealba, et al. Ivy cells: a population of nitric-oxide-producing, slow-spiking GABAergic neurons and their involvement in hippocampal network activity. Neuron, 2008.';
reftext{7+g}='7. Fuentealba, et al. Expression of COUP-TFII nuclear receptor in restricted GABAergic neuronal populations in the adult rat hippocampus. Journal of Neuroscience, 2010.';

subplot(2,1,2)
text(0,1,reftext,'HorizontalAlignment','Left','VerticalAlignment','Top')
axis off

