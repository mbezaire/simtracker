
if exist('sl','var')==0 || isempty(sl)
    if ispc
        sl='\';
    else
        sl='/';
    end
end

for precell=1:length(handles.curses.cells)
    switch handles.curses.cells(precell).name
        case 'eccell'
            preorigin='remote';
            precat = 'excitatory';
        case 'ca3cell'
            preorigin='remote';
            precat = 'excitatory';
        case 'pyramidalcell'
            preorigin='local';
            precat = 'excitatory';
        otherwise
            preorigin='local';
            precat = 'inhibitory';
    end
    for postcell=1:length(handles.curses.cells)
        switch handles.curses.cells(precell).name
            case 'pyramidalcell'
                postorigin='local';
                postcat = 'excitatory';
            otherwise
                postorigin='local';
                postcat = 'inhibitory';
        end
        idx = find(handles.curses.numcons(:,2)==handles.curses.cells(precell).ind && handles.curses.numcons(:,3)==handles.curses.cells(postcell).ind);
        tally.(preorigin).(precat).(postorigin).(postcat).data = sum(handles.curses.numcons(idx,4));
    end
end
handles.curses.numcons

abbrev.type = {'ec3','ca3','pyr','ivy','ngf','pvb','bis','axo','olm','cck','sca'};
name.type = {'ECIII','CA3','Pyramidal','Ivy','Neurogliaform','PV+ Basket','Bistratified','Axo-axonic','O-LM','CCK+ Basket','S.C. Assoc.'};

abbrev.class = {'aff','pyr','ngf','pv','som','cck'};
name.class = {'Afferents','Pyramidal','Neuro. Family','PV+','SOM+','CCK+'};

abbrev.cat = {'exc','inh'};
name.cat = {'Excitatory','Inhibitory'};

abbrev.origin = {'remote','local'};
name.origin = {'Remote','Local'};

tally.remote.exc.local.exc.data = 0;
tally.local.exc.local.exc.data = 0;
tally.local.inh.local.exc.data = 0;

tally.remote.exc.local.inh.data = 0;
tally.local.exc.local.inh.data = 0;
tally.local.inh.local.inh.data = 0;

tally.remote.exc.local.exc.color = '#FF0000';
tally.local.exc.local.exc.color = '#FF0066';
tally.local.inh.local.exc.color = '#FF6600';

tally.remote.exc.local.inh.color = '#00GG00';
tally.local.exc.local.inh.color = '#00GG66';
tally.local.inh.local.inh.color = '#66GG00';

for c=1:length(celltype)
    origin = celltype(c).origin;
    cat = celltype(c).cat;
    for p=1:length(celltype)
        porig = celltype(p).origin;
        pcat = celltype(p).cat;
        ptype = celltype(p).type;
        if isfield(celltype(c).output,ptype)
            tally.(origin).(cat).(porig).(pcat).data = tally.(origin).(cat).(porig).(pcat).data + celltype(c).output.(ptype);
        end
    end
end
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
pathway=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
if exist(pathway,'dir')==0
    mkdir(pathway)
end

fid = fopen([pathway sl 'allsyns.txt'],'w');
ofields = fieldnames(tally);
for o=1:length(ofields)
    cfields = fieldnames(tally.(ofields{o}));
    for c=1:length(cfields)
        opfields = fieldnames(tally.(ofields{o}).(cfields{c}));
        for op=1:length(opfields)
            cpfields = fieldnames(tally.(ofields{o}).(cfields{c}).(opfields{op}));
            for cp=1:length(cpfields)
                fprintf(fid,'%s %s -> %s %s,%d,%s\n',ofields{o},cfields{c},opfields{op},cpfields{cp},tally.(ofields{o}).(cfields{c}).(opfields{op}).(cpfields{cp}).data,tally.(ofields{o}).(cfields{c}).(opfields{op}).(cpfields{cp}).color);
            end
        end
    end
end

fclose(fid);