function hzz=plot_graphidiv()

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
pathway=[myrepos(q).dir(1:wtmp(end)) 'figures' myrepos(q).dir(wtmp(end):end)];
if exist(pathway,'dir')==0
    mkdir(pathway)
end


celltype(1).type = 'ivy';celltype(1).class = 'ngf';celltype(1).cat = 'inh';celltype(1).origin = 'local';celltype(1).allboutons =142722000;celltype(1).inhboutons =11417760;celltype(1).excboutons =131304240;celltype(1).numcells =8810;celltype(1).inhsynapses =5314192;
celltype(2).type = 'ngf';celltype(2).class = 'ngf';celltype(2).cat = 'inh';celltype(2).origin = 'local';celltype(2).allboutons =47256000;celltype(2).inhboutons =3780480;celltype(2).excboutons =43475520;celltype(2).numcells =3580;celltype(2).inhsynapses =3021520;
celltype(3).type = 'olm';celltype(3).class = 'som';celltype(3).cat = 'inh';celltype(3).origin = 'local';celltype(3).allboutons =26846800;celltype(3).inhboutons =2953148;celltype(3).excboutons =23893652;celltype(3).numcells =1640;celltype(3).inhsynapses =2919541.35616;
celltype(4).type = 'pvb';celltype(4).class = 'pv';celltype(4).cat = 'inh';celltype(4).origin = 'local';celltype(4).allboutons =57733200;celltype(4).inhboutons =577332;celltype(4).excboutons =57155868;celltype(4).numcells =5530;celltype(4).inhsynapses =5834449.5048;
celltype(5).type = 'bis';celltype(5).class = 'pv';celltype(5).cat = 'inh';celltype(5).origin = 'local';celltype(5).allboutons =35293700;celltype(5).inhboutons =2823496;celltype(5).excboutons =32470204;celltype(5).numcells =2210;celltype(5).inhsynapses =2331669.6936;
celltype(6).type = 'axo';celltype(6).class = 'pv';celltype(6).cat = 'inh';celltype(6).origin = 'local';celltype(6).allboutons =10584000;celltype(6).inhboutons =0;celltype(6).excboutons =10584000;celltype(6).numcells =1470;celltype(6).inhsynapses =1550929.6152;
celltype(7).type = 'cck';celltype(7).class = 'cck';celltype(7).cat = 'inh';celltype(7).origin = 'local';celltype(7).allboutons =36000000;celltype(7).inhboutons =2880000;celltype(7).excboutons =33120000;celltype(7).numcells =3600;celltype(7).inhsynapses =10503471.06;
celltype(8).type = 'sca';celltype(8).class = 'cck';celltype(8).cat = 'inh';celltype(8).origin = 'local';celltype(8).allboutons =4800000;celltype(8).inhboutons =384000;celltype(8).excboutons =4416000;celltype(8).numcells =400;celltype(8).inhsynapses =1167052.34;
celltype(9).type = 'pyr';celltype(9).class = 'pyr';celltype(9).cat = 'exc';celltype(9).origin = 'local';celltype(9).allboutons =86181716;celltype(9).inhboutons =24816216;celltype(9).excboutons =61365500;celltype(9).numcells =311500;celltype(9).inhsynapses =96253500;
celltype(1).output.ivy = 2272294.36306952;celltype(1).output.ngf = 1007508;celltype(1).output.olm = 2083557;celltype(1).output.pvb = 1317929.25509013;celltype(1).output.bis = 526695.737001761;celltype(1).output.axo = 350334.7752141;celltype(1).output.cck = 3449732;celltype(1).output.sca = 409708;celltype(1).output.pyr = 131304240;
%celltype(2).output.ivy = 312637;celltype(2).output.ngf = 616028;celltype(2).output.olm = 0;celltype(2).output.pvb = 509551.471945117;celltype(2).output.bis = 203636.49912944;celltype(2).output.axo = 135450.694016037;celltype(2).output.cck = 1799805;celltype(2).output.sca = 203372;celltype(2).output.pyr = 43475520;
celltype(2).output.ivy = 0;celltype(2).output.ngf = 616028;celltype(2).output.olm = 0;celltype(2).output.pvb = 0;celltype(2).output.bis = 0;celltype(2).output.axo = 0;celltype(2).output.cck = 0;celltype(2).output.sca = 0;celltype(2).output.pyr = 43475520;
celltype(3).output.ivy = 83868;celltype(3).output.ngf = 454823;celltype(3).output.olm = 101042;celltype(3).output.pvb = 424210.994932929;celltype(3).output.bis = 169531.455827235;celltype(3).output.axo = 112764.733641596;celltype(3).output.cck = 1446217;celltype(3).output.sca = 160690;celltype(3).output.pyr = 23893652;
celltype(4).output.ivy = 70502;celltype(4).output.ngf = 0;celltype(4).output.olm = 0;celltype(4).output.pvb = 215512;celltype(4).output.bis = 86126;celltype(4).output.axo = 57288;celltype(4).output.cck = 138261;celltype(4).output.sca = 9643;celltype(4).output.pyr = 57155868;
celltype(5).output.ivy = 283762;celltype(5).output.ngf = 105566;celltype(5).output.olm = 452128;celltype(5).output.pvb = 861950;celltype(5).output.bis = 344469;celltype(5).output.axo = 229126;celltype(5).output.cck = 490265;celltype(5).output.sca = 56232;celltype(5).output.pyr = 32470204;
celltype(6).output.ivy = 0;celltype(6).output.ngf = 0;celltype(6).output.olm = 0;celltype(6).output.pvb = 0;celltype(6).output.bis = 0;celltype(6).output.axo = 0;celltype(6).output.cck = 0;celltype(6).output.sca = 0;celltype(6).output.pyr = 10584000;
celltype(7).output.ivy = 557910;celltype(7).output.ngf = 91160;celltype(7).output.olm = 263950;celltype(7).output.pvb = 519502.31113738;celltype(7).output.bis = 207613.279974481;celltype(7).output.axo = 143643.817327806;celltype(7).output.cck = 1009320;celltype(7).output.sca = 86900;celltype(7).output.pyr = 33120000;
celltype(8).output.ivy = 112653;celltype(8).output.ngf = 49771;celltype(8).output.olm = 18523;celltype(8).output.pvb = 38994.1523932664;celltype(8).output.bis = 15584.1490244665;celltype(8).output.axo = 10755.8979523848;celltype(8).output.cck = 122676;celltype(8).output.sca = 15042;celltype(8).output.pyr = 4416000;
celltype(9).output.ivy = 0;celltype(9).output.ngf = 0;celltype(9).output.olm = 0;celltype(9).output.pvb = 0;celltype(9).output.bis = 0;celltype(9).output.axo = 0;celltype(9).output.cck = 0;celltype(9).output.sca = 0;celltype(9).output.pyr = 61365500;

levellist={'origin','cat','class','type'};

for lm=1:length(levellist)
    hzz(lm)=figure('Color','w','Name',['Div' levellist{lm}]);

    level=levellist{lm}; %'class';
    org='div';

    bfilters.type = '';
    bfilters.class = '';
    bfilters.cat = 'inh'; % inh
    bfilters.origin = 'local'; % local

    sfilters.type = '';
    sfilters.cat = 'inh'; % 
    sfilters.class = '';
    sfilters.origin = 'local'; % 

    mfilters.boutons = 'inhboutons'; % (mfilters.boutons), excboutons, allboutons
    mfilters.synapses = 'inhsynapses'; % (mfilters.synapses), excsynapses, allsynapses

    boutonidx = intersect(intersect(strmatch(bfilters.cat,{celltype(:).cat}),strmatch(bfilters.class,{celltype(:).class})),intersect(strmatch(bfilters.type,{celltype(:).type}),strmatch(bfilters.origin,{celltype(:).origin})));
    synapseidx = intersect(intersect(strmatch(sfilters.cat,{celltype(:).cat}),strmatch(sfilters.class,{celltype(:).class})),intersect(strmatch(sfilters.type,{celltype(:).type}),strmatch(sfilters.origin,{celltype(:).origin})));


    colorvec.type=[.3  .3 1;
              .7  .2 .7;
              .0 .0 .6;
              .6 .6 .6;
              1 .1 1;
              .0 .75 .65;
              .6 .4 .1;
              1 .0 .0;
              .5 .0 .6;
              1 .75 .0;
              1 .5 .3;
              1 0 0;
              0 0 1;];

    colorvec.cat = [.1 .1 1;
                   1 .1 1;];

    colorvec.class = [.5 .25 .85;
                .0 .0 .6;
                1 .1 1;
                .0 .75 .65;
                .5 .0 .6;
                1 .75 .0;];

    colorvec.origin = [.1 1 .1;
                       .2 .2 .2;];


    % category: exc inh
    % exc class: aff pyr
    % inh class: ngf pv cck som
    % inh leveldata: 'pvb','cck','sca','axo','bis','olm','ivy','ngf'
    % exc leveldata: ca3 ec3 pyr

    abbrev.type = {'ec3','ca3','pyr','ivy','ngf','pvb','bis','axo','olm','cck','sca'};
    name.type = {'ECIII','CA3','Pyramidal','Ivy','Neurogliaform','PV+ Basket','Bistratified','Axo-axonic','O-LM','CCK+ Basket','S.C. Assoc.'};

    abbrev.class = {'aff','pyr','ngf','pv','som','cck'};
    name.class = {'Afferents','Pyramidal','Neuro. Family','PV+','SOM+','CCK+'};

    abbrev.cat = {'exc','inh'};
    name.cat = {'Excitatory','Inhibitory'};

    abbrev.origin = {'remote','local'};
    name.origin = {'Remote','Local'};

    postfieldstmp = {celltype(synapseidx).type};

    % for z=1:length(celltype)
    %     celltype(z).inhboutons = celltype(z).inhboutons/celltype(z).numcells;
    %     celltype(z).excboutons = celltype(z).excboutons/celltype(z).numcells;
    %     celltype(z).allboutons = celltype(z).allboutons/celltype(z).numcells;
    %     %celltype(z).inhsynapses = celltype(z).inhsynapses/celltype(z).numcells;
    %     postfields = fieldnames(celltype(z).output);
    %     for m=1:length(postfields)
    %         post = postfields{m};
    %         if isfield(celltype(z),'output') && isfield(celltype(z).output, post)
    %             celltype(z).output.(post) = celltype(z).output.(post)/celltype(z).numcells;
    %         end
    %     end
    % end

    % consolidate celltype by level
    leveldata=[];
    z=1;
    for ztmp=1:length(abbrev.(level))
        zidx = strmatch(abbrev.(level){ztmp},{celltype(boutonidx).(level)});
        widx = strmatch(abbrev.(level){ztmp},{celltype(synapseidx).(level)});
        if isempty(zidx)
            continue
        end
        try
            leveldata(z).inhboutons = sum([celltype(boutonidx(zidx)).inhboutons]);
            leveldata(z).excboutons = sum([celltype(boutonidx(zidx)).excboutons]);
            leveldata(z).allboutons = sum([celltype(boutonidx(zidx)).allboutons]);
        catch
            'k'
        end
        leveldata(z).inhsynapses = sum([celltype(synapseidx(widx)).inhsynapses]);

        for zi=1:length(abbrev.(level))
            if ~isempty(strmatch(abbrev.(level){zi},{celltype(boutonidx).(level)}))
                leveldata(z).output.(abbrev.(level){zi}) = 0;
            end
        end

        leveldata(z).type = {};
        leveldata(z).class = {};
        leveldata(z).cat = {};
        leveldata(z).origin = {};

        for q=1:length(zidx)
            leveldata(z).type = unique({celltype(boutonidx(zidx(q))).type,leveldata(z).type{:}});
            leveldata(z).class = unique({celltype(boutonidx(zidx(q))).class,leveldata(z).class{:}});
            leveldata(z).cat = unique({celltype(boutonidx(zidx(q))).cat,leveldata(z).cat{:}});
            leveldata(z).origin = unique({celltype(boutonidx(zidx(q))).origin,leveldata(z).origin{:}});
            pf = fieldnames(celltype(boutonidx(zidx(q))).output);
            pf = intersect(pf,postfieldstmp,'stable');
            for p=1:length(pf)
                pidx = strmatch(pf{p},{celltype(:).type});
                newfieldname = celltype(pidx).(level); % celltype(pidx).(level);
                if isfield(leveldata(z),'output') && isfield(leveldata(z).output, newfieldname)
                    leveldata(z).output.(newfieldname) = leveldata(z).output.(newfieldname) + celltype(boutonidx(zidx(q))).output.(pf{pidx});
                else
                    leveldata(z).output.(newfieldname) = celltype(boutonidx(zidx(q))).output.(newfieldname);
                end
            end
        end
        leveldata(z).type = [leveldata(z).type{:}];
        leveldata(z).class = [leveldata(z).class{:}];
        leveldata(z).cat = [leveldata(z).cat{:}];
        leveldata(z).origin = [leveldata(z).origin{:}];
        z=z+1;
    end

    margin = round(max(sum([leveldata.(mfilters.synapses)]),sum([leveldata.(mfilters.boutons)]))*.42);
    separater = round(max(sum([leveldata.(mfilters.synapses)]),sum([leveldata.(mfilters.boutons)]))*.06);

    allboutons=sum([leveldata.(mfilters.boutons)])+separater*(sum([leveldata.(mfilters.boutons)]~=0)-1);
    allsynapses=sum([leveldata.(mfilters.synapses)])+separater*(sum([leveldata.(mfilters.synapses)]~=0)-1);

    cellheight = allboutons;

    [postfields, ip] = intersect({leveldata(:).(level)},unique({celltype(synapseidx).(level)}),'stable');

    for r=1:length(leveldata)
        tc = strmatch(leveldata(r).(level),abbrev.(level));

        start = 0;
        hi = 1;
        if leveldata(r).(mfilters.boutons)==0
            continue
        end

        remainingbouts = leveldata(r).(mfilters.boutons);
        cellheight = cellheight-leveldata(r).(mfilters.boutons);
        synwidth = margin;
        synheight = 0;
        cellwidth = 0;
        leveldata(r).prefield = [cellheight+remainingbouts+separater cellheight+remainingbouts cellheight];
        for z=1:length(postfields)
            post = postfields{z};

            synwidth = margin;
            for b=1:r-1
                synwidth = synwidth + leveldata(b).output.(post);
                %synheight = synheight + leveldata(r).output.(postfields{b});
            end
            if remainingbouts>0 % sideways
                leveldata(r).h(hi) = rectangle('Position',[start cellheight cellwidth+synwidth-start remainingbouts],'EdgeColor',colorvec.(level)(tc,:),'FaceColor',colorvec.(level)(tc,:));
            end
            if isfield(leveldata(r).output,post) && leveldata(r).output.(post)>0 && ((strcmp(mfilters.synapses(1:3),'all')) || (strcmp(mfilters.synapses(1:3),leveldata(r).cat))) % reaching up
                leveldata(r).h(hi+1) = rectangle('Position',[cellwidth+synwidth cellheight leveldata(r).output.(post) allboutons+margin-cellheight],'EdgeColor',colorvec.(level)(tc,:),'FaceColor',colorvec.(level)(tc,:));
                remainingbouts = remainingbouts-leveldata(r).output.(post);
            end

            start = cellwidth + synwidth;
            if tc==length(abbrev.(level)) %r==length(leveldata)
                rectangle('Position',[start+leveldata(r).output.(post) allboutons+separater sum([leveldata(ip(1:z)).(mfilters.synapses)])-leveldata(r).output.(post)+margin+separater*(z-1)-start margin-separater],'EdgeColor','none','FaceColor',[0 0 0]); % [.8 1 .8]
            end
            cellwidth = cellwidth + leveldata(ip(z)).(mfilters.synapses)+separater;
            hi = hi + 2;

        end
        cellheight = cellheight-separater;
    end

    cellheight = allboutons;
    cellwidth = margin;
    line([0 allsynapses+margin],[cellheight+separater cellheight+separater],'LineStyle','-','Color','k')
    line([cellwidth-separater cellwidth-separater],[0 allboutons+margin],'LineStyle','-','Color','k')

    lw = 1; % 2
    for r=1:length(leveldata)
        tc = strmatch(leveldata(r).(level),abbrev.(level));
        myname = name.(level){tc};

        if r==length(leveldata)
            lw=1;
        end

        if leveldata(r).(mfilters.boutons)>0
            leveldata(r).t(1) = text(separater/4, cellheight+separater/2,myname,'Color',colorvec.(level)(tc,:),'FontWeight','bold');
            line([0 allsynapses+margin],[cellheight cellheight],'LineStyle',':','Color','k')
            line([0 allsynapses+margin],[cellheight-leveldata(r).(mfilters.boutons) cellheight-leveldata(r).(mfilters.boutons)],'LineStyle','-','Color','k')
            cellheight = cellheight-leveldata(r).(mfilters.boutons)-separater;
        end

        if leveldata(r).(mfilters.synapses)>0
            leveldata(r).postfield = [cellwidth-separater cellwidth cellwidth+leveldata(r).(mfilters.synapses)];
            % rectangle('Position',[leveldata(r).postfield(1) allboutons+separater leveldata(r).postfield(2)-leveldata(r).postfield(1) margin-separater],'EdgeColor','none','FaceColor',[0 0 0]); % [.8 1 .8]
            leveldata(r).t(2) = text(cellwidth-separater/2, allboutons+separater*5/4,myname,'Color',colorvec.(level)(tc,:),'FontWeight','bold','Rotation',90);
            line([cellwidth cellwidth],[0 allboutons+margin],'LineStyle',':','Color','k')
            line([cellwidth+leveldata(r).(mfilters.synapses) cellwidth+leveldata(r).(mfilters.synapses)],[0 allboutons+separater],'LineStyle','-','Color','k')
            line([cellwidth+leveldata(r).(mfilters.synapses) cellwidth+leveldata(r).(mfilters.synapses)],[allboutons+separater allboutons+margin],'LineStyle','-','Color','k','LineWidth',lw)
            cellwidth = cellwidth+leveldata(r).(mfilters.synapses)+separater;
        end
    end

    axis equal
    xlim([0 allsynapses+margin]);
    ylim([0 allboutons+margin]);
    axis off

    pos=get(gca,'Position'); % [left bottom width height]
    yaxpos = [pos(1) pos(2)+pos(4)*.1 pos(3)*.01 pos(4)*.01];
    xaxpos=[pos(1)+pos(3)*.75 pos(2)+pos(4)*1.05 pos(3)*.02 pos(4)*.02]
    annotation('textarrow','Position',yaxpos,'String','Interneuron-Innervating Boutons','Color',[1 1 1],'TextColor',[0 0 0],'TextEdgeColor',[1 1 1],'FontName','ArialMT','TextRotation',90,'HorizontalAlignment','left','VerticalAlignment','bottom')
    annotation('textarrow','Position',xaxpos,'String','Inhibitory Input Synapses','Color',[1 1 1],'TextColor',[0 0 0],'TextEdgeColor',[1 1 1],'FontName','ArialMT','VerticalAlignment','middle','HorizontalAlignment','right')

    set(gcf,'ButtonDownFcn',{@displaystuff, leveldata, level,colorvec,abbrev,name,bfilters,sfilters,mfilters,margin,separater,'div'})
    ch=get(gcf,'Children');
    for c=1:length(ch)
        set(ch(c),'ButtonDownFcn',{@displaystuff, leveldata, level,colorvec,abbrev,name,bfilters,sfilters,mfilters,margin,separater,'div'})
        ch2=get(ch(c),'Children');
        for h=1:length(ch2)
            set(ch2(h),'ButtonDownFcn',{@displaystuff, leveldata, level,colorvec,abbrev,name,bfilters,sfilters,mfilters,margin,separater,'div'})
        end
    end
    print([pathway 'div' levellist{lm} '.png'],'-dpng')
    print([pathway 'div' levellist{lm} '.eps'],'-depsc')
end