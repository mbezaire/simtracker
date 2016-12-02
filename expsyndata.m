function expsyns = expsyndata(varargin)
global sl mypath

precell='axoaxoniccell';
postcell='pyramidalcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding = -70;
expsyns(1).(precell).(postcell).Reversal = 7;
expsyns(1).(precell).(postcell).Amplitude = 308.0;
expsyns(1).(precell).(postcell).Junction = 4.6;
expsyns(1).(precell).(postcell).RiseTime = 0.80;
expsyns(1).(precell).(postcell).DecayTau = 11.20;
expsyns(1).(precell).(postcell).ref = 'Maccaferri et al. 2000';
expsyns(1).(precell).(postcell).url = 'http://jp.physoc.org/content/524/1/91.short';


precell='bistratifiedcell';
postcell='pyramidalcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding = -70;
expsyns(1).(precell).(postcell).Reversal = 7;
expsyns(1).(precell).(postcell).Amplitude = 150.0;
expsyns(1).(precell).(postcell).Junction = 4.6;
expsyns(1).(precell).(postcell).RiseTime = 2.00;
expsyns(1).(precell).(postcell).DecayTau = 16.10;
expsyns(1).(precell).(postcell).ref = 'Maccaferri et al. 2000';
expsyns(1).(precell).(postcell).url = 'http://jp.physoc.org/content/524/1/91.short';

precell='cckcell';
postcell='pyramidalcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding = -70;
expsyns(1).(precell).(postcell).Reversal = -26;
expsyns(1).(precell).(postcell).Amplitude = 115.4;
expsyns(1).(precell).(postcell).Junction = 10.8;
expsyns(1).(precell).(postcell).RiseTime = 0.63;
expsyns(1).(precell).(postcell).DecayTau = 6.47;
expsyns(1).(precell).(postcell).ref = 'Lee et al. 2010';
expsyns(1).(precell).(postcell).url = 'http://www.jneurosci.org/content/30/23/7993.short';


precell='ivycell';
postcell='pyramidalcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding = -50;
expsyns(1).(precell).(postcell).Reversal = -88;
expsyns(1).(precell).(postcell).Amplitude = 8.0;
expsyns(1).(precell).(postcell).Junction = 15.0;
expsyns(1).(precell).(postcell).RiseTime = 2.80;
expsyns(1).(precell).(postcell).DecayTau = 16.05;  %(16.8 ms half-width)
expsyns(1).(precell).(postcell).ref = 'Fuentealba et al. 2008';
expsyns(1).(precell).(postcell).url = 'http://www.sciencedirect.com/science/article/pii/S0896627308001220';


precell='ivycell';
postcell='pyramidalcell';
expsyns(2).(precell).(postcell).Clamp =  'Current';
expsyns(2).(precell).(postcell).Holding =  [];
expsyns(2).(precell).(postcell).ModelCur = 0; % nA
expsyns(2).(precell).(postcell).Reversal = -70;
expsyns(2).(precell).(postcell).Amplitude = 0.8;
expsyns(2).(precell).(postcell).RiseTime = 12.5;
expsyns(2).(precell).(postcell).HalfWidth = 54.1;
expsyns(2).(precell).(postcell).ref = 'Fuentealba et al. 2008';
expsyns(2).(precell).(postcell).url = 'http://www.sciencedirect.com/science/article/pii/S0896627308001220';




precell='pyramidalcell';
postcell='ivycell';
expsyns(1).(precell).(postcell).Clamp =  'Current';
expsyns(1).(precell).(postcell).Holding = -65.8;
expsyns(1).(precell).(postcell).ModelCur = 0; % nA
expsyns(1).(precell).(postcell).Reversal = -70;
expsyns(1).(precell).(postcell).Amplitude = 2.9;
expsyns(1).(precell).(postcell).RiseTime = 1.5;
expsyns(1).(precell).(postcell).DecayTau = 11.5;
expsyns(1).(precell).(postcell).ref = 'Fuentealba et al. 2008';
expsyns(1).(precell).(postcell).url = 'http://www.sciencedirect.com/science/article/pii/S0896627308001220';



precell='olmcell';
postcell='pyramidalcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding = -70;
expsyns(1).(precell).(postcell).Reversal = 7;
expsyns(1).(precell).(postcell).Amplitude = 26.0;
expsyns(1).(precell).(postcell).Junction = 4.6;
expsyns(1).(precell).(postcell).RiseTime = 6.20;
expsyns(1).(precell).(postcell).DecayTau = 20.8;
expsyns(1).(precell).(postcell).ref = 'Maccaferri et al. 2000';
expsyns(1).(precell).(postcell).url = 'http://jp.physoc.org/content/524/1/91.short';


precell='pvbasketcell';
postcell='pyramidalcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding = -75;
expsyns(1).(precell).(postcell).Reversal = -25;
expsyns(1).(precell).(postcell).Amplitude = 106.8;
expsyns(1).(precell).(postcell).Junction = 10.8;
expsyns(1).(precell).(postcell).RiseTime = 0.53;
expsyns(1).(precell).(postcell).DecayTau = 6.40;
expsyns(1).(precell).(postcell).ref = 'Szabadics et al. 2007';
expsyns(1).(precell).(postcell).url = 'http://www.pnas.org/content/104/37/14831.short';

precell='pvbasketcell';
postcell='pyramidalcell';
expsyns(2).(precell).(postcell).Clamp =  'Voltage';
expsyns(2).(precell).(postcell).Holding =  -70;
expsyns(2).(precell).(postcell).ModelCur = 0; % nA
expsyns(2).(precell).(postcell).Reversal = -26;
expsyns(2).(precell).(postcell).Amplitude = 65.44;
expsyns(2).(precell).(postcell).Junction = 10.8;
expsyns(2).(precell).(postcell).RiseTime = .59;
expsyns(2).(precell).(postcell).HalfWidth = 5.35;
expsyns(2).(precell).(postcell).ref = 'Foldy et al. 2007'; % data from those cells, but not in paper
expsyns(2).(precell).(postcell).url = 'http://www.nature.com/neuro/journal/v10/n9/full/nn1952.html';



precell='scacell';
postcell='pyramidalcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding = - 70;
expsyns(1).(precell).(postcell).Reversal = -26;
expsyns(1).(precell).(postcell).Amplitude = 60.2;
expsyns(1).(precell).(postcell).Junction = 10.8;
expsyns(1).(precell).(postcell).RiseTime = 1.43;
expsyns(1).(precell).(postcell).DecayTau = 8.30;
expsyns(1).(precell).(postcell).ref = 'Lee et al. 2010';
expsyns(1).(precell).(postcell).url = 'http://www.jneurosci.org/content/30/23/7993.short';


precell='ngfcell';
postcell='pyramidalcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding = -50;
expsyns(1).(precell).(postcell).Reversal = -89; % -91
expsyns(1).(precell).(postcell).Amplitude = 4.9; % -91
expsyns(1).(precell).(postcell).Junction = 15;
expsyns(1).(precell).(postcell).Peak = 29; % 187
expsyns(1).(precell).(postcell).DecayTau = 50; % unk
expsyns(1).(precell).(postcell).ref = 'Price et al. 2008';
expsyns(1).(precell).(postcell).url = 'http://www.jneurosci.org/content/28/27/6974.short';


precell='pyramidalcell';
postcell='pyramidalcell';
expsyns(1).(precell).(postcell).Clamp =  'Current';
expsyns(1).(precell).(postcell).Holding = -67;
expsyns(1).(precell).(postcell).ModelCur = -.06; % nA
expsyns(1).(precell).(postcell).Reversal = 0;
expsyns(1).(precell).(postcell).Amplitude = 0.7;
expsyns(1).(precell).(postcell).RiseTime = 2.7;
expsyns(1).(precell).(postcell).HalfWidth = 16.8;
expsyns(1).(precell).(postcell).ref = 'Deuchars and Thomson 1996';
expsyns(1).(precell).(postcell).url = 'http://www.sciencedirect.com/science/article/pii/0306452296002515';


precell='bistratifiedcell';
postcell='pyramidalcell';
expsyns(2).(precell).(postcell).Clamp =  'Current';
expsyns(2).(precell).(postcell).Holding =  -69;
expsyns(2).(precell).(postcell).ModelCur = -.10; % nA
expsyns(2).(precell).(postcell).Reversal = -70;
expsyns(2).(precell).(postcell).Amplitude = 3.4;
expsyns(2).(precell).(postcell).RiseTime = 1.2;
expsyns(2).(precell).(postcell).HalfWidth = 7.6;
expsyns(2).(precell).(postcell).ref = 'Deuchars et al. 1998'; % http://jp.physoc.org/content/507/1/201.full
expsyns(2).(precell).(postcell).url = 'http://jp.physoc.org/content/507/1/201.full';

precell='pvbasketcell';
postcell='pyramidalcell';
expsyns(3).(precell).(postcell).Clamp =  'Current';
expsyns(3).(precell).(postcell).Holding =  -70;
expsyns(3).(precell).(postcell).ModelCur = -.12; % nA
expsyns(3).(precell).(postcell).Reversal = -70;
expsyns(3).(precell).(postcell).Amplitude = 1.4;
expsyns(3).(precell).(postcell).RiseTime = 0.88;
expsyns(3).(precell).(postcell).HalfWidth = 5.4;
expsyns(3).(precell).(postcell).ref = 'Deuchars et al. 1998'; % http://jp.physoc.org/content/507/1/201.full
expsyns(3).(precell).(postcell).url = 'http://jp.physoc.org/content/507/1/201.full';

precell='scacell';
postcell='scacell';
expsyns(1).(precell).(postcell).Clamp =  'Current';
expsyns(1).(precell).(postcell).Holding =  -58;
expsyns(1).(precell).(postcell).ModelCur = +.020; % nA
expsyns(1).(precell).(postcell).Reversal = -70;
expsyns(1).(precell).(postcell).Amplitude = -0.5;
expsyns(1).(precell).(postcell).RiseTime = 4;
expsyns(1).(precell).(postcell).HalfWidth = 34.3;
expsyns(1).(precell).(postcell).ref = 'Pawelzik et al. 2002'; % http://onlinelibrary.wiley.com/doi/10.1002/cne.10118/full
expsyns(1).(precell).(postcell).url = 'http://onlinelibrary.wiley.com/doi/10.1002/cne.10118/full';

expsyns(2).(precell).(postcell).Clamp =  'Current';
expsyns(2).(precell).(postcell).Holding =  -55;
expsyns(2).(precell).(postcell).ModelCur = 0.048; % nA
expsyns(2).(precell).(postcell).Reversal = -70;
expsyns(2).(precell).(postcell).Amplitude = 0.6; % .9 mV for 2nd and subsequen IPSPs
expsyns(2).(precell).(postcell).RiseTime = 7.0;
expsyns(2).(precell).(postcell).HalfWidth = 41.1;
expsyns(2).(precell).(postcell).ref = 'Ali et al. 2007'; % http://jn.physiology.org/content/98/2/861.short
expsyns(2).(precell).(postcell).url = 'http://jn.physiology.org/content/98/2/861.short';

% 
% precell='pyramidalcell';
% postcell='cckcell'; % they couldn't find pyr -> sca though
% expsyns(1).(precell).(postcell).Clamp =  'Current';
% expsyns(1).(precell).(postcell).Holding =  -67;
% expsyns(1).(precell).(postcell).ModelCur = -.05; % nA
% expsyns(1).(precell).(postcell).Reversal = 0;
% expsyns(1).(precell).(postcell).Amplitude = 2;
% expsyns(1).(precell).(postcell).RiseTime = 1.0;
% expsyns(1).(precell).(postcell).HalfWidth = 6.1;
% expsyns(1).(precell).(postcell).ref = 'Pawelzik et al. 2002'; % http://onlinelibrary.wiley.com/doi/10.1002/cne.10118/full
% expsyns(1).(precell).(postcell).url = 'http://onlinelibrary.wiley.com/doi/10.1002/cne.10118/full';

precell='pyramidalcell';
postcell='pvbasketcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding =  -60;
expsyns(1).(precell).(postcell).ModelCur = 0; % nA
expsyns(1).(precell).(postcell).Reversal = 0;
expsyns(1).(precell).(postcell).Amplitude = 46.7; % pA
expsyns(1).(precell).(postcell).RiseTime = 1.0;
expsyns(1).(precell).(postcell).HalfWidth = 4.12;
expsyns(1).(precell).(postcell).ref = 'Lee et al. 2014'; % sPC -> PVBC (since they are more likely)
expsyns(1).(precell).(postcell).url = 'http://www.sciencedirect.com/science/article/pii/S0896627314003365';

precell='pyramidalcell';
postcell='pvbasketcell';
expsyns(2).(precell).(postcell).Clamp =  'Current';
expsyns(2).(precell).(postcell).Holding =  -67;
expsyns(2).(precell).(postcell).ModelCur = -.025; % nA
expsyns(2).(precell).(postcell).Reversal = 0;
expsyns(2).(precell).(postcell).Amplitude = 3.51;
expsyns(2).(precell).(postcell).RiseTime = 1.0;
expsyns(2).(precell).(postcell).HalfWidth = 5.74;
expsyns(2).(precell).(postcell).ref = 'Pawelzik et al. 2002'; % http://onlinelibrary.wiley.com/doi/10.1002/cne.10118/full
expsyns(2).(precell).(postcell).url = 'http://onlinelibrary.wiley.com/doi/10.1002/cne.10118/full';

precell='pyramidalcell';
postcell='bistratifiedcell';
expsyns(1).(precell).(postcell).Clamp =  'Current';
expsyns(1).(precell).(postcell).Holding =  -66;
expsyns(1).(precell).(postcell).ModelCur = +.02; % nA
expsyns(1).(precell).(postcell).Reversal = 0;
expsyns(1).(precell).(postcell).Amplitude = .96;
expsyns(1).(precell).(postcell).RiseTime = 1.2;
expsyns(1).(precell).(postcell).HalfWidth = 10.4;
expsyns(1).(precell).(postcell).ref = 'Pawelzik et al. 2002'; % http://onlinelibrary.wiley.com/doi/10.1002/cne.10118/full
expsyns(1).(precell).(postcell).url = 'http://onlinelibrary.wiley.com/doi/10.1002/cne.10118/full';


% 'Karson et al. 2009'; % http://www.jneurosci.org/content/29/13/4140.short
% make CCK -> PV and CCK -> CCK about half the amplitude of CCK -> Pyr

precell='pvbasketcell';
postcell='bistratifiedcell';
expsyns(1).(precell).(postcell).Clamp =  'Current';
expsyns(1).(precell).(postcell).Holding =  -55;
expsyns(1).(precell).(postcell).ModelCur = +.12; % nA
expsyns(1).(precell).(postcell).Reversal = -70;
expsyns(1).(precell).(postcell).Amplitude = .37;
expsyns(1).(precell).(postcell).RiseTime = 1.0;
expsyns(1).(precell).(postcell).HalfWidth = 5.6;
expsyns(1).(precell).(postcell).ref = 'Cobb et al. 1997'; % http://www.sciencedirect.com/science/article/pii/S0306452297000559
expsyns(1).(precell).(postcell).url = 'http://www.sciencedirect.com/science/article/pii/S0306452297000559';

precell='pvbasketcell';
postcell='pvbasketcell';
expsyns(1).(precell).(postcell).Clamp =  'Current';
expsyns(1).(precell).(postcell).Holding =  -59;
expsyns(1).(precell).(postcell).ModelCur = +.12; % nA
expsyns(1).(precell).(postcell).Reversal = -70;
expsyns(1).(precell).(postcell).Amplitude = .25;
expsyns(1).(precell).(postcell).RiseTime = 1.3;
expsyns(1).(precell).(postcell).HalfWidth = 27;
expsyns(1).(precell).(postcell).ref = 'Cobb et al. 1997'; % http://www.sciencedirect.com/science/article/pii/S0306452297000559
expsyns(1).(precell).(postcell).url = 'http://www.sciencedirect.com/science/article/pii/S0306452297000559';


precell='olmcell';
postcell='scacell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding =  -50;
expsyns(1).(precell).(postcell).Reversal = -70;
expsyns(1).(precell).(postcell).Amplitude = 19.5;
expsyns(1).(precell).(postcell).RiseTime = 1.9;
expsyns(1).(precell).(postcell).DecayTau = 31.2;
expsyns(1).(precell).(postcell).ref = 'Elfant et al. 2008'; % http://onlinelibrary.wiley.com/doi/10.1111/j.1460-9568.2007.06001.x/full
expsyns(1).(precell).(postcell).url = 'http://onlinelibrary.wiley.com/doi/10.1111/j.1460-9568.2007.06001.x/full';

precell='olmcell';
postcell='ngfcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding =  -50;
expsyns(1).(precell).(postcell).Reversal = -70;
expsyns(1).(precell).(postcell).Amplitude = 19.2;
expsyns(1).(precell).(postcell).RiseTime = 2.2;
expsyns(1).(precell).(postcell).DecayTau = 10.8;
expsyns(1).(precell).(postcell).ref = 'Elfant et al. 2008'; % http://onlinelibrary.wiley.com/doi/10.1111/j.1460-9568.2007.06001.x/full
expsyns(1).(precell).(postcell).url = 'http://onlinelibrary.wiley.com/doi/10.1111/j.1460-9568.2007.06001.x/full';
% no clear if cckcell...
% precell='olmcell';
% postcell='cckcell'; % bistratifiedcell
% expsyns(1).(precell).(postcell).Clamp =  'Voltage';
% expsyns(1).(precell).(postcell).Holding =  -50;
% expsyns(1).(precell).(postcell).Reversal = -70;
% expsyns(1).(precell).(postcell).Amplitude = 11.7;
% expsyns(1).(precell).(postcell).RiseTime = 2.6;
% expsyns(1).(precell).(postcell).DecayTau = 16.5;
% expsyns(1).(precell).(postcell).ref = 'Elfant et al. 2008'; % http://onlinelibrary.wiley.com/doi/10.1111/j.1460-9568.2007.06001.x/full
% expsyns(1).(precell).(postcell).url = 'http://onlinelibrary.wiley.com/doi/10.1111/j.1460-9568.2007.06001.x/full';

precell='olmcell';
postcell='ndcell'; % n.d. in paper
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding =  -50;
expsyns(1).(precell).(postcell).Reversal = -70;
expsyns(1).(precell).(postcell).Amplitude = 11.4;
expsyns(1).(precell).(postcell).RiseTime = 3.2;
expsyns(1).(precell).(postcell).DecayTau = 20.7;
expsyns(1).(precell).(postcell).ref = 'Elfant et al. 2008'; % http://onlinelibrary.wiley.com/doi/10.1111/j.1460-9568.2007.06001.x/full
expsyns(1).(precell).(postcell).url = 'http://onlinelibrary.wiley.com/doi/10.1111/j.1460-9568.2007.06001.x/full';

precell='ngfcell';
postcell='ngfcell';
expsyns(1).(precell).(postcell).Clamp =  'Voltage';
expsyns(1).(precell).(postcell).Holding =  -65;
expsyns(1).(precell).(postcell).Reversal = -11;
expsyns(1).(precell).(postcell).Amplitude = 85.3;
expsyns(1).(precell).(postcell).RiseTime = 3.69*1.33; % est 10-90 rise time from 20–80 rise time
expsyns(1).(precell).(postcell).DecayTau = 60.3;
expsyns(1).(precell).(postcell).ref = 'Karayannis et al. 2010'; 
expsyns(1).(precell).(postcell).url = 'http://www.jneurosci.org/content/30/29/9898.full';


precells={'axoaxoniccell','bistratifiedcell','ca3cell','cckcell','eccell','ivycell','ngfcell','olmcell','pyramidalcell','pvbasketcell','scacell'};
postcells={'axoaxoniccell','bistratifiedcell','cckcell','ivycell','ngfcell','olmcell','pyramidalcell','pvbasketcell','scacell'};

for pr=1:length(precells)
    for po=1:length(postcells)
        if isfield(expsyns(1),precells{pr}) && isfield(expsyns(1).(precells{pr}),postcells{po})
            tableconmatref{pr,po} = ['<a href="' expsyns(1).(precells{pr}).(postcells{po}).url '" target="_blank">' expsyns(1).(precells{pr}).(postcells{po}).ref ' (' expsyns(1).(precells{pr}).(postcells{po}).Clamp ' Clamp)</a>'];
        else
            if isempty(varargin)
                tableconmatref{pr,po} = '';
            elseif isfield(varargin{1},precells{pr}) && isfield(varargin{1}.(precells{pr}),postcells{po})
                tableconmatref{pr,po} = '<span style="color: gray;">Guessed</span>';
            else
                tableconmatref{pr,po} = 'X';
            end
        end
    end
end

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
websitepath=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
if exist(websitepath,'dir')==0
    mkdir(websitepath)
end

if ~exist([websitepath sl 'synapses'],'dir')
    mkdir([websitepath sl 'synapses'])
end

fid = fopen([websitepath sl 'synapses' sl 'tableconmatref.txt'],'w');
prelist = sprintf('%s,',precells{:});
postlist = sprintf('%s,',postcells{:});
fprintf(fid,'%s\n%s\n',prelist(1:end-1),postlist(1:end-1));
for pr=1:length(precells)
    for po=1:length(postcells)-1
        fprintf(fid,'%s,',tableconmatref{pr,po});
    end
    fprintf(fid,'%s\n',tableconmatref{pr,length(postcells)});
end
fclose(fid);