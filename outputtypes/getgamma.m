function nrninput = getgamma(varargin)

offsetsize=.1;

n=1;
nrninput(n).name='Pyramidal';
nrninput(n).tech='pyramidalcell';
nrninput(n).phase=0;
nrninput(n).color = [.0 .0 .6];
nrninput(n).marker = 'o';
nrninput(n).state='wf';
nrninput(n).linestyle=':';
nrninput(n).ref=9; % buzsaki ... says there are 2 gamma phases, one was at trough
nrninput(n).notes='est firing rate';
nrninput(n).firingrate=1;
nrninput(n).offset=[offsetsize*40 offsetsize*.1];
nrninput(n).useme = 1;

n=n+1; % 2;
nrninput(n).name='Axo-axonic';
nrninput(n).tech='axoaxoniccell';
nrninput(n).phase=24;
nrninput(n).color = [1 .0 .0];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).linestyle=':';
nrninput(n).ref=10; % tukker 2007
nrninput(n).notes='';
nrninput(n).firingrate=17.1;
nrninput(n).offset=[0 offsetsize];
nrninput(n).useme = 1;

n=n+1; % 3;
nrninput(n).name='Bistratified';  
nrninput(n).tech='bistratifiedcell';
nrninput(n).phase=53;
nrninput(n).color = [.6 .4 .1];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).linestyle=':';
nrninput(n).ref=10; % tukker 2007
nrninput(n).notes='';
nrninput(n).firingrate=5.9;
nrninput(n).offset=[0 -offsetsize*1.5];
nrninput(n).useme = 1;

n=n+1; % 4;
nrninput(n).name='CCK+ Basket';
nrninput(n).tech='cckcell';
nrninput(n).phase=341;
nrninput(n).color = [1 .75 .0];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).linestyle=':';
nrninput(n).ref=10; % tukker 2007
nrninput(n).notes='';
nrninput(n).firingrate=9.4;
nrninput(n).offset=[-offsetsize*300 offsetsize*.6];
nrninput(n).useme = 1;


n=n+1; % 8;
nrninput(n).name='O-LM';  
nrninput(n).tech='olmcell';
nrninput(n).phase=349;
nrninput(n).color = [.5 .0 .6];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).linestyle=':';
nrninput(n).ref=10; % tukker 2007
nrninput(n).notes='';
nrninput(n).firingrate=4.9;
nrninput(n).offset=[0 -offsetsize*.9];
nrninput(n).useme = 0;

n=n+1; % 9;
nrninput(n).name='O-LM';  
nrninput(n).tech='olmcell';
nrninput(n).phase=143;
nrninput(n).color = [.5 .0 .6];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).linestyle='-.';
nrninput(n).ref=5;
nrninput(n).notes='';
nrninput(n).firingrate=29.8;
nrninput(n).offset=[-offsetsize*250 0];
nrninput(n).useme = 1;


n=n+1; % 11;
nrninput(n).name='PV+ Basket';
nrninput(n).tech='pvbasketcell';
nrninput(n).phase=70;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = 'o';
nrninput(n).state='an';
nrninput(n).linestyle=':';
nrninput(n).ref=10; % tukker 2007
nrninput(n).notes='';
nrninput(n).firingrate=7.3;
nrninput(n).offset=[0 offsetsize*.8];
nrninput(n).useme = 0;


n=n+1; % 14;
nrninput(n).name='PV+ Basket';
nrninput(n).tech='pvbasketcell';
nrninput(n).phase=107;
nrninput(n).color = [.0 .75 .65];
nrninput(n).marker = 'v';
nrninput(n).state='wr';
nrninput(n).linestyle='-.';
nrninput(n).ref=5;
nrninput(n).notes='';
nrninput(n).firingrate=25;
nrninput(n).offset=[0 offsetsize*.8];
nrninput(n).useme = 1;


if ~isempty(varargin)
    if length(varargin{1})==1 && varargin{1}==-1
        nrninput = nrninput([nrninput(:).useme]==1);
    else
        nrninput = nrninput(varargin{1});
    end
end
