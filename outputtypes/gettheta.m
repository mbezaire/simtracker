function nrninput = gettheta(varargin)


offsetsize=.1;

n=1;
nrninput(n).name='Pyramidal';
nrninput(n).tech='pyramidalcell';
nrninput(n).phase=20;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.0 .0 .6];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).usew=0;
nrninput(n).linestyle=':';
nrninput(n).ref=1;
nrninput(n).cite='Klausberger et al 2003';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://www.nature.com/nature/journal/v421/n6925/full/nature01374.html';
nrninput(n).gurl='';
nrninput(n).notes='est firing rate';
nrninput(n).firingrate=1;
nrninput(n).offset=[offsetsize*40 offsetsize*.1];
nrninput(n).useme = 1;
nrninput(n).usean=1;
nrninput(n).n=0;


n=n+1; % 2;
nrninput(n).name='Axo-axonic';
nrninput(n).tech='axoaxoniccell';
nrninput(n).phase=185;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [1 .0 .0];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).usew=0;
nrninput(n).linestyle=':';
nrninput(n).ref=1;
nrninput(n).cite='Klausberger et al 2003';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://www.nature.com/nature/journal/v421/n6925/full/nature01374.html';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=17.1;
nrninput(n).offset=[0 offsetsize];
nrninput(n).useme = 0;
nrninput(n).usean=1;
nrninput(n).n=2;

n=n+1; % 3;
nrninput(n).name='Bistratified';  
nrninput(n).tech='bistratifiedcell';
nrninput(n).phase=1;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.6 .4 .1];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).usew=0;
nrninput(n).linestyle=':';
nrninput(n).ref=2;
nrninput(n).cite='Klausberger et al 2004';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://www.nature.com/neuro/journal/v7/n1/full/nn1159.html';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=5.9;
nrninput(n).offset=[0 -offsetsize*1.5];
nrninput(n).useme = 0;
nrninput(n).usean=1;
nrninput(n).n=7;

n=n+1; % 4;
nrninput(n).name='CCK+ Basket';
nrninput(n).tech='cckcell';
nrninput(n).phase=174;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [1 .75 .0];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).usew=0;
nrninput(n).linestyle=':';
nrninput(n).ref=3;
nrninput(n).cite='Klausberger et al 2005';
nrninput(n).url='http://www.jneurosci.org/content/25/42/9782.long';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=9.4;
nrninput(n).offset=[-offsetsize*300 offsetsize*.6];
nrninput(n).useme = 1;
nrninput(n).usean=1;
nrninput(n).n=9;

n=n+1; % 5;
nrninput(n).name='Ivy';
nrninput(n).tech='ivycell';
nrninput(n).phase=31;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.6 .6 .6];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).usew=0;
nrninput(n).linestyle=':';
nrninput(n).ref=6;
nrninput(n).cite='Fuentealba et al 2008';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://www.sciencedirect.com/science/article/pii/S0896627308001220';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=0.7;
nrninput(n).offset=[offsetsize*40 offsetsize*.4];
nrninput(n).useme = 0;
nrninput(n).usean=1;
nrninput(n).n=4;

n=n+1; % 6;
nrninput(n).name='Ivy';
nrninput(n).tech='ivycell';
nrninput(n).phase=46;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.6 .6 .6];
nrninput(n).marker = '^';
nrninput(n).state='wf';
nrninput(n).usew=1;
nrninput(n).linestyle='--';
nrninput(n).ref=4;
nrninput(n).cite='Lapray';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://www.nature.com/neuro/journal/v15/n9/full/nn.3176.html';
nrninput(n).gurl='';
nrninput(n).notes='Fuent08 gives 2.4 but no phase';
nrninput(n).firingrate=2.8;
nrninput(n).offset=[offsetsize*40 offsetsize*.1];
nrninput(n).useme = 1;
nrninput(n).usean=0;
nrninput(n).n=0;

n=n+1; % 7;
nrninput(n).name='Neurogliaform';
nrninput(n).tech='ngfcell';
nrninput(n).phase=196;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [1 .1 1];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).usew=0;
nrninput(n).linestyle=':';
nrninput(n).ref=7;
nrninput(n).cite='Fuentealba et al 2010';
nrninput(n).url='http://www.jneurosci.org/content/30/5/1595.long';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=6;
nrninput(n).offset=[offsetsize*20 0];
nrninput(n).useme = 1;
nrninput(n).usean=1;
nrninput(n).n=2;

n=n+1; % 8;
nrninput(n).name='O-LM';  
nrninput(n).tech='olmcell';
nrninput(n).phase=19;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.5 .0 .6];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).usew=0;
nrninput(n).linestyle=':';
nrninput(n).ref=1;
nrninput(n).cite='Klausberger et al 2003';
nrninput(n).url='http://www.nature.com/nature/journal/v421/n6925/full/nature01374.html';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=4.9;
nrninput(n).offset=[0 -offsetsize*.9];
nrninput(n).useme = 0;
nrninput(n).usean=1;
nrninput(n).n=3;

n=n+1; % 9;
nrninput(n).name='O-LM';  
nrninput(n).tech='olmcell';
nrninput(n).phase=346;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.5 .0 .6];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).usew=1;
nrninput(n).linestyle='-.';
nrninput(n).ref=5;
nrninput(n).cite='Varga et al 2012';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://www.pnas.org/content/109/40/E2726.long';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=29.8;
nrninput(n).offset=[-offsetsize*250 0];
nrninput(n).useme = 1;
nrninput(n).usean=0;
nrninput(n).n=0;

% 
% n=n+1; % 10;
% nrninput(n).name='PPA';
% nrninput(n).tech='ppacell';
% nrninput(n).phase=100;
% nrninput(n).mod=0;
% nrninput(n).gamma=0;
% nrninput(n).gmod=0;
% nrninput(n).gref=1;
% nrninput(n).color = [1 .95 .15];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).linestyle=':';
% nrninput(n).ref=3;
% nrninput(n).cite='Klausberger et al 2005';
% nrninput(n).url='http://www.jneurosci.org/content/25/42/9782.long';
% nrninput(n).gurl='';
% nrninput(n).gcite=''; % no ref
% nrninput(n).notes='';
% nrninput(n).firingrate=5.75;
% nrninput(n).offset=[-offsetsize*200 0];
% nrninput(n).useme = 1;

n=n+1; % 11;
nrninput(n).name='PV+ Basket';
nrninput(n).tech='pvbasketcell';
nrninput(n).phase=271;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).usew=0;
nrninput(n).linestyle=':';
nrninput(n).ref=1;
nrninput(n).cite='Klausberger et al 2003';
nrninput(n).url='http://www.nature.com/nature/journal/v421/n6925/full/nature01374.html';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=7.3;
nrninput(n).offset=[0 offsetsize*.8];
nrninput(n).useme = 0;
nrninput(n).usean=1;
nrninput(n).n=5;

n=n+1; % 12;
nrninput(n).name='PV+ Basket';
nrninput(n).tech='pvbasketcell';
nrninput(n).phase=234;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).usew=0;
nrninput(n).linestyle=':';
nrninput(n).ref=3;
nrninput(n).cite='Klausberger et al 2005';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://www.jneurosci.org/content/25/42/9782.long';
nrninput(n).gurl='';
nrninput(n).notes='don''t know rate';
nrninput(n).firingrate=[];
nrninput(n).offset=[0 offsetsize*.8];
nrninput(n).useme = 0;
nrninput(n).usean=0;
nrninput(n).n=8;


n=n+1; % 13;
nrninput(n).name='PV+ Basket';
nrninput(n).tech='pvbasketcell';
nrninput(n).phase=289;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = '^';
nrninput(n).state='wf';
nrninput(n).usew=1;
nrninput(n).linestyle='--';
nrninput(n).ref=4;
nrninput(n).cite='Lapray';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://www.nature.com/neuro/journal/v15/n9/full/nn.3176.html';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=21;
nrninput(n).offset=[0 offsetsize*.8];
nrninput(n).useme = 0;
nrninput(n).usean=0;
nrninput(n).n=0;


n=n+1; % 14;
nrninput(n).name='PV+ Basket';
nrninput(n).tech='pvbasketcell';
nrninput(n).phase=307;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).usew=0;
nrninput(n).linestyle='-.';
nrninput(n).ref=5;
nrninput(n).cite='Varga et al 2012';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://www.pnas.org/content/109/40/E2726.long';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=25;
nrninput(n).offset=[0 offsetsize*.8];
nrninput(n).useme = 1;
nrninput(n).usean=0;
nrninput(n).n=0;

% 
% n=n+1; % 15;
% nrninput(n).name='ADI';
% nrninput(n).tech='adicell';
% nrninput(n).phase=156;
% nrninput(n).mod=0;
% nrninput(n).gamma=0;
% nrninput(n).gmod=0;
% nrninput(n).gref=1;
% nrninput(n).color = [1 .85 .05];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).linestyle=':';
% nrninput(n).ref=3;
% nrninput(n).cite='Klausberger et al 2005';
% nrninput(n).gcite=''; % no ref
% nrninput(n).url='http://www.jneurosci.org/content/25/42/9782.long';
% nrninput(n).gurl='';
% nrninput(n).notes='';
% nrninput(n).firingrate=8.6;
% nrninput(n).offset=[-offsetsize*200 0];
% nrninput(n).useme = 1;

% n=n+1; % 16
% nrninput(n).name='Trilaminar';
% nrninput(n).tech='trilaminarcell';
% nrninput(n).phase=0;
% nrninput(n).mod=0;
% nrninput(n).gamma=0;
% nrninput(n).gmod=0;
% nrninput(n).gref=1;
% nrninput(n).color = [.9 .9 .9];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).linestyle=':';
% nrninput(n).ref=10; % Ferraguti 2005
% nrninput(n).cite='Ferraguti 2005';
% nrninput(n).url='http://www.jneurosci.org/content/25/45/10520.short';
% nrninput(n).gurl='';
% nrninput(n).gcite=''; % no ref
% nrninput(n).notes='approximately at the trough, or 0';
% nrninput(n).firingrate=0.2;
% nrninput(n).offset=[0 0];
% 
% n=n+1; % 17;
% nrninput(n).name='Double Proj.';
% nrninput(n).tech='dblprojcell';
% nrninput(n).phase=27;
% nrninput(n).mod=0;
% nrninput(n).gamma=0;
% nrninput(n).gmod=0;
% nrninput(n).gref=1;
% nrninput(n).color = [.9 .9 .9];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).linestyle=':';
% nrninput(n).ref=9; % Jinno 2007
% nrninput(n).cite='Jinno 2007';
% nrninput(n).gcite=''; % no ref
% nrninput(n).url='http://www.jneurosci.org/content/27/33/8790.short';
% nrninput(n).gurl='';
% nrninput(n).notes='';
% nrninput(n).firingrate=0.9;
% nrninput(n).offset=[0 0];
% 
% n=n+1; % 18;
% nrninput(n).name='Oriens Retro.';
% nrninput(n).tech='oriensretcell';
% nrninput(n).phase=53;
% nrninput(n).mod=0;
% nrninput(n).gamma=0;
% nrninput(n).gmod=0;
% nrninput(n).gref=1;
% nrninput(n).color = [.9 .9 .9];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).linestyle=':';
% nrninput(n).ref=9; % Jinno 2007
% nrninput(n).cite='Jinno 2007';
% nrninput(n).gcite=''; % no ref
% nrninput(n).url='http://www.jneurosci.org/content/27/33/8790.short';
% nrninput(n).gurl='';
% nrninput(n).notes='';
% nrninput(n).firingrate=0.53;
% nrninput(n).offset=[0 0];
% 
% n=n+1; % 19;
% nrninput(n).name='Radiatum Retro.';
% nrninput(n).tech='radretcell';
% nrninput(n).phase=298;
% nrninput(n).mod=0;
% nrninput(n).gamma=0;
% nrninput(n).gmod=0;
% nrninput(n).gref=1;
% nrninput(n).color = [.9 .9 .9];
% nrninput(n).marker = 'o';
% nrninput(n).state='an';
% nrninput(n).linestyle=':';
% nrninput(n).ref=9; % Jinno 2007
% nrninput(n).cite='Jinno 2007';
% nrninput(n).gcite=''; % no ref
% nrninput(n).url='http://www.jneurosci.org/content/27/33/8790.short';
% nrninput(n).gurl='';
% nrninput(n).notes='';
% nrninput(n).firingrate=5.15;
% nrninput(n).offset=[0 0];

n=n+1; % 20;
nrninput(n).name='Axo-axonic';
nrninput(n).tech='axoaxoniccell';
nrninput(n).phase=251;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [1 .0 .0];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).usew=1;
nrninput(n).linestyle='-.';
nrninput(n).ref=8; %csaba unpublished
nrninput(n).cite='Varga et al 2014';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://elifesciences.org/content/3/e04006.abstract';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=27;
nrninput(n).offset=[0 0];
nrninput(n).useme = 1;
nrninput(n).usean=0;
nrninput(n).n=0;


n=n+1; % 21;
nrninput(n).name='Bistratified';  
nrninput(n).tech='bistratifiedcell';
nrninput(n).phase=0;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.6 .4 .1];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).usew=1;
nrninput(n).linestyle='-.';
nrninput(n).ref=8; %csaba unpublished
nrninput(n).cite='Varga et al 2014';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://elifesciences.org/content/3/e04006.abstract';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=34;
nrninput(n).offset=[0 0];
nrninput(n).offset=[0 -offsetsize*2.8];
nrninput(n).useme = 1;
nrninput(n).usean=0;
nrninput(n).n=0;

n=n+1; % 22;
nrninput(n).name='PV+ Basket';  
nrninput(n).tech='pvbasketcell';
nrninput(n).phase=310;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).usew=1;
nrninput(n).linestyle='-.';
nrninput(n).ref=8; %csaba unpublished
nrninput(n).cite='Varga et al 2014';
nrninput(n).gcite=''; % no ref
nrninput(n).url='http://elifesciences.org/content/3/e04006.abstract';
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=28;
nrninput(n).offset=[0 0];
nrninput(n).usean=0;
nrninput(n).n=0;

n=n+1; % 23;
nrninput(n).name='S.C. Assoc.';  
nrninput(n).tech='scacell';
nrninput(n).phase=NaN;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).usew=0;
nrninput(n).linestyle='-.';
nrninput(n).ref=0; % no ref
nrninput(n).cite=''; % no ref
nrninput(n).gcite=''; % no ref
nrninput(n).url=''; % no ref
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=28;
nrninput(n).offset=[0 0];
nrninput(n).usean=0;
nrninput(n).n=0;

n=n+1; % 24;
nrninput(n).name='CA3';  
nrninput(n).tech='ca3cell';
nrninput(n).phase=NaN;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).usew=0;
nrninput(n).linestyle='-.';
nrninput(n).ref=0; % no ref
nrninput(n).cite=''; % no ref
nrninput(n).gcite=''; % no ref
nrninput(n).url=''; % no ref
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=28;
nrninput(n).offset=[0 0];
nrninput(n).usean=0;
nrninput(n).n=0;

n=n+1; % 24;
nrninput(n).name='EC';  
nrninput(n).tech='eccell';
nrninput(n).phase=NaN;
nrninput(n).mod=0;
nrninput(n).gamma=0;
nrninput(n).gmod=0;
nrninput(n).gref=1;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).usew=0;
nrninput(n).linestyle='-.';
nrninput(n).ref=0; %csaba unpublished
nrninput(n).cite=''; % no ref
nrninput(n).gcite=''; % no ref
nrninput(n).url=''; % no ref
nrninput(n).gurl='';
nrninput(n).notes='';
nrninput(n).firingrate=28;
nrninput(n).offset=[0 0];
nrninput(n).usean=0;
nrninput(n).n=0;

if ~isempty(varargin)
    if length(varargin{1})==1 && varargin{1}==-1
        nrninput = nrninput([nrninput(:).useme]==1);
    elseif length(varargin{1})==1 && varargin{1}==-2
        nrninput = nrninput([nrninput(:).usean]==1);
    elseif length(varargin{1})==1 && varargin{1}==0
        nrninput = nrninput([nrninput(:).usew]==1);
    else
        nrninput = nrninput(varargin{1});
    end
end
