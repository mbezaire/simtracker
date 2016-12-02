function phaseprefs(varargin)
% phaseprefs()
% calculates phase prefs for KS08 and CsV and graphs them

period = 125;

     
 
col=[.0 .0 .6; 
          1 .0 .0; 
          .6 .4 .1; 
          1 .75 .0; 
          .6 .6 .6; 
          .8 .8 .8;    
          .5 .0 .6; 
          .0 .75 .65; 
          1 .75 .0;]; 


colorvec=[.0 .0 .6;
          .0 .75 .65;
          1 .75 .0;
          1 .5 .3;
          1 .0 .0;
          .6 .4 .1;
          .5 .0 .6;
          .6 .6 .6;
          1 .1 1;
          1 0 0;
          0 0 1;];


% load settings/MyThetaGUI.mat originally loaded in the nrninputs, but perhaps safer to just hardcode them here:
nrninput = gettheta();
% for n=1:length(nrninput)
%     z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
%     nrninput(n).color = colorvec(z,:);
% end
% n=1;
% nrninput(n).name='Pyramidal';
% nrninput(n).tech='pyramidalcell';
% nrninput(n).phase=20;
% nrninput(n).offset=[offsetsize*20 0];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.0 .0 .6];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=1;
% 
% n=2;
% nrninput(n).name='Axo-axonic';
% nrninput(n).tech='axoaxoniccell';
% nrninput(n).phase=185;
% nrninput(n).offset=[0 offsetsize];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [1 .0 .0];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=1;
% 
% n=3;
% nrninput(n).name='Bistratified';  
% nrninput(n).tech='bistratifiedcell';
% nrninput(n).phase=1;
% nrninput(n).offset=[0 -offsetsize*1.1];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.6 .4 .1];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=2;
% 
% n=4;
% nrninput(n).name='CCK+ Basket';
% nrninput(n).tech='cckcell';
% nrninput(n).phase=174;
% nrninput(n).offset=[-offsetsize*300 offsetsize*.6];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [1 .75 .0];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=3;
% 
% n=5;
% nrninput(n).name='Ivy';
% nrninput(n).tech='ivycell';
% nrninput(n).phase=31;
% nrninput(n).offset=[offsetsize*20 0];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.6 .6 .6];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=6;
% 
% n=6;
% nrninput(n).name='Ivy';
% nrninput(n).tech='ivycell';
% nrninput(n).phase=46;
% nrninput(n).offset=[offsetsize*20 0];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.6 .6 .6];
% nrninput(n).marker = '^';
% nrninput(n).state='wf';
% nrninput(n).ref=4;
% 
% n=7;
% nrninput(n).name='Neurogliaform';
% nrninput(n).tech='ngfcell';
% nrninput(n).phase=196;
% nrninput(n).offset=[offsetsize*20 0];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.8 .8 .8];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=7;
% 
% n=8;
% nrninput(n).name='O-LM';  
% nrninput(n).tech='olmcell';
% nrninput(n).phase=19;
% nrninput(n).offset=[0 -offsetsize*.9];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.5 .0 .6];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=1;
% 
% n=9;
% nrninput(n).name='O-LM';  
% nrninput(n).tech='olmcell';
% nrninput(n).phase=346;
% nrninput(n).offset=[-offsetsize*250 0];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.5 .0 .6];
% nrninput(n).marker = 'v';
% nrninput(n).state='wr';
% nrninput(n).ref=5;
% 
% n=10;
% nrninput(n).name='PPA';
% nrninput(n).tech='ppacell';
% nrninput(n).phase=100;
% nrninput(n).offset=[-offsetsize*200 0];
% nrninput(n).color = [1 .95 .15];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=3;
% 
% n=11;
% nrninput(n).name='PV+ Basket';
% nrninput(n).tech='pvbasketcell';
% nrninput(n).phase=271;
% nrninput(n).offset=[0 offsetsize*.8];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.0 .75 .65];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=1;
% 
% n=12;
% nrninput(n).name='PV+ Basket';
% nrninput(n).tech='pvbasketcell';
% nrninput(n).phase=234;
% nrninput(n).offset=[0 offsetsize*.8];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.0 .75 .65];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=3;
% 
% n=13;
% nrninput(n).name='PV+ Basket';
% nrninput(n).tech='pvbasketcell';
% nrninput(n).phase=289;
% nrninput(n).offset=[0 offsetsize*.8];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.0 .75 .65];
% nrninput(n).marker = '^';
% nrninput(n).state='wf';
% nrninput(n).ref=4;
% 
% n=14;
% nrninput(n).name='PV+ Basket';
% nrninput(n).tech='pvbasketcell';
% nrninput(n).phase=307;
% nrninput(n).offset=[0 offsetsize*.8];
% z = strmatch(nrninput(n).tech,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
% nrninput(n).color = colorvec(z,:);
% %nrninput(n).color = [.0 .75 .65];
% nrninput(n).marker = 'v';
% nrninput(n).state='wr';
% nrninput(n).ref=5;
% 
% n=15;
% nrninput(n).name='ADI';
% nrninput(n).tech='adicell';
% nrninput(n).phase=156;
% nrninput(n).offset=[-offsetsize*200 0];
% nrninput(n).color = [1 .85 .05];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).ref=3;




legstr={};
trace.data=0:.025:(period*2);
trace.data=trace.data';
Hzval = 8;

excell = -sin((Hzval*(2*pi))*trace.data(:,1)/1000 + pi/2);  % -13.8/125);  %  - handles.phasepref +   -  (0.25)*Hzval*2*pi
for n=1:length(nrninput)
nrninput(n).start = nrninput(n).phase/360*period;
end;

try
for n=1:length(nrninput)
    if isnan(nrninput(n).start)
        nrninput(n).tidx(1)=NaN;
        nrninput(n).tidx(2)=NaN;
    else
        nrninput(n).tidx(1)=find(trace.data>=nrninput(n).start,1,'first');
        nrninput(n).tidx(2)=find(trace.data>=nrninput(n).start+period,1,'first');
    end
end
catch me
    n
    me
end
if isempty(varargin)
    figure('Color','w','Name','Oscillation')
    subplot(2,1,1)
    plot(trace.data,excell,'k')
    hold on
    for n=1:length(nrninput)
        plot(trace.data(nrninput(n).tidx),excell(nrninput(n).tidx),'MarkerFaceColor',nrninput(n).color,'MarkerEdgeColor',nrninput(n).color,'Marker',nrninput(n).marker,'MarkerSize',10,'LineStyle','none')
        text(trace.data(nrninput(n).tidx(1))+nrninput(n).offset(1),excell(nrninput(n).tidx(1))+nrninput(n).offset(2),[num2str(nrninput(n).phase) '^o ' nrninput(n).name ' (' nrninput(n).state ')^' num2str(nrninput(n).ref)])
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
    reftext{1+g}='1. Klausberger, et al. Brain-state- and cell-type-specific firing of hippocampal interneurons in vivo. Nature, 421:844–848, 2003.';
    reftext{2+g}='2. Klausberger, et al. Spike timing of dendrite-targeting bistratified cells during hippocampal network oscillations in vivo. Nat. Neurosci., 7:41–47, 2004.';
    reftext{3+g}='3. Klausberger, et al. Complementary roles of cholecystokinin- and parvalbumin-expressing GABAergic neurons in hippocampal network oscillations. J. Neurosci., 25:9782–9793, 2005.';
    reftext{4+g}='4. Lapray, et al. Behavior-dependent specialization of identified hippocampal interneurons. Nat. Neurosci., ?:?, 2012.';
    reftext{5+g}='5. Varga, et al. Frequency-invariant temporal ordering of interneuronal discharges during hippocampal oscillations in awake mice. PNAS, ?:?, 2012.';
    reftext{6+g}='6. Fuentealba, et al. Ivy cells: a population of nitric-oxide-producing, slow-spiking GABAergic neurons and their involvement in hippocampal network activity. Neuron, 57:917–929, 2008.';
    reftext{7+g}='7. Fuentealba, et al. Expression of COUP-TFII nuclear receptor in restricted GABAergic neuronal populations in the adult rat hippocampus. Journal of Neuroscience, 30:1595–609, 2010.';
    reftext{8+g}='8. Varga, et al., in prep.';
    reftext{9+g}='9. Jinno, 2007';
    reftext{10+g}='10. Ferraguti, 2005';

    subplot(2,1,2)
    text(0,1,reftext,'HorizontalAlignment','Left','VerticalAlignment','Top')
    axis off
else
    axes(varargin{1})
    plot(trace.data,excell,'k')
    hold on
    if length(varargin)<4
        plotexp=1;
    else
        plotexp=varargin{4};
    end
    if plotexp==1;
        for n=1:length(nrninput)
            plot(trace.data(nrninput(n).tidx),excell(nrninput(n).tidx),'MarkerFaceColor',nrninput(n).color,'MarkerEdgeColor',nrninput(n).color,'Marker',nrninput(n).marker,'MarkerSize',10,'LineStyle','none')
            text(trace.data(nrninput(n).tidx(1))+nrninput(n).offset(1),excell(nrninput(n).tidx(1))+nrninput(n).offset(2),[num2str(nrninput(n).phase) '^o ' nrninput(n).name ' (' nrninput(n).state ')^' num2str(nrninput(n).ref)])
        end
        
        g=8;
        reftext{g-7}='LEGEND';
        reftext{g-6}='All text notes above refer to experimental results (no model results have text)';
        reftext{g-5}='squares with black outlines: model data (colors correspond to same cell types as on left)';
        reftext{g-4}='';
        reftext{g-3}='an: anesthetized with urethane + ketamine & xylazine (...)';
        reftext{g-2}='wr: awake, head restrained (_._._)';
        reftext{g-1}='wf: awake, head free (_ _ _)';
        reftext{g}='';
        reftext{1+g}='1. Klausberger, et al. Nature 2003. Brain-state- and cell-type-specific firing of hippocampal interneurons in vivo.';
        reftext{2+g}='2. Klausberger, et al. Nat. Neurosci. 2004. Spike timing of dendrite-targeting bistratified cells during hippocampal...';
        reftext{3+g}='3. Klausberger, et al. J. Neurosci. 2005. Complementary roles of cholecystokinin- and parvalbumin-expressing...';
        reftext{4+g}='4. Lapray, et al. Nat. Neurosci. 2012. Behavior-dependent specialization of identified hippocampal interneurons.';
        reftext{5+g}='5. Varga, et al. PNAS 2012. Frequency-invariant temporal ordering of interneuronal discharges during hippocampal...';
        reftext{6+g}='6. Fuentealba, et al. Neuron 2008. Ivy cells: a population of nitric-oxide-producing, slow-spiking GABAergic ...';
        reftext{7+g}='7. Fuentealba, et al. J. Neurosci. 2010. Expression of COUP-TFII nuclear receptor in restricted GABAergic neuronal...';
        reftext{8+g}='8. Varga, et al., in prep.';
        reftext{9+g}='9. Jinno, 2007';
        reftext{10+g}='10. Ferraguti, 2005';
    else
        reftext{1}='LEGEND';
        reftext{2}='squares with black outlines: model data (colors correspond to same cell types as on left)';
    end
    
    if length(varargin)>2
        for z=1:length(varargin{3})
            idx=[];
            myadd = 0;
            if varargin{3}(z)>360
                myadd = -360;
            end
            try
            idx(1)=find(trace.data>=varargin{3}(z)/360*period+myadd,1,'first');
            catch
                z
            end
            idx(2)=find(trace.data>=varargin{3}(z)/360*period+period+myadd,1,'first');
            plot(trace.data(idx),excell(idx),'MarkerFaceColor',colorvec(z,:),'MarkerEdgeColor',colorvec(z,:),'Marker','o','MarkerSize',10,'LineWidth',2,'LineStyle','none')
            % plot(trace.data(idx),excell(idx),'MarkerFaceColor',colorvec(z,:),'MarkerEdgeColor','k','Marker','sq','MarkerSize',8,'LineWidth',2,'LineStyle','none')
        end
    end
    ylabel('LFP')
    axis off
    
    axes(varargin{2})
    text(0,1,reftext,'HorizontalAlignment','Left','VerticalAlignment','Top','Interpreter','none')
    axis off
end

