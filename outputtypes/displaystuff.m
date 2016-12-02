function displaystuff(varargin) % handle, eventdata, leveldata

pt=get(gca,'currentpoint');
syns=pt(1,1);
bouts=pt(1,2);
leveldata=varargin{3};
level=varargin{4};
colorvec=varargin{5};
abbrev=varargin{6};
name=varargin{7};
bfilters=varargin{8};
sfilters=varargin{9};
mfilters=varargin{10};
margin=varargin{11};
separater=varargin{12};
type=varargin{13};

flag=0;

allboutons=sum([leveldata.(mfilters.boutons)])+separater*(sum([leveldata.(mfilters.boutons)]~=0)-1);
allsynapses=sum([leveldata.(mfilters.synapses)])+separater*(sum([leveldata.(mfilters.synapses)]~=0)-1);

dd=[];
ee=[];
cellheight = allboutons;
cellwidth = margin;

boutonidx = intersect(intersect(strmatch(bfilters.cat,{leveldata(:).cat}),strmatch(bfilters.class,{leveldata(:).class})),intersect(strmatch(bfilters.type,{leveldata(:).type}),strmatch(bfilters.origin,{leveldata(:).origin})));
synapseidx = intersect(intersect(strmatch(sfilters.cat,{leveldata(:).cat}),strmatch(sfilters.class,{leveldata(:).class})),intersect(strmatch(sfilters.type,{leveldata(:).type}),strmatch(sfilters.origin,{leveldata(:).origin})));

[postfields, ip] = intersect({leveldata(:).(level)},unique({leveldata(synapseidx).(level)}),'stable');
[prefields, ipre] = intersect({leveldata(:).(level)},unique({leveldata(boutonidx).(level)}),'stable');

if syns<margin-separater
    for r=1:length(leveldata)
        leveldata(r).tt=[];
        if ~isempty(leveldata(r).prefield) && leveldata(r).prefield(1)>bouts && leveldata(r).prefield(3)<bouts
            % highlight with yellow outline
            % dd(length(dd)+1)=rectangle('Position',[ 0 leveldata(r).prefield(2)  allsynapses+margin leveldata(r).prefield(1)-leveldata(r).prefield(2)],'EdgeColor','y','LineWidth',2);

            % postfields = fieldnames(leveldata(r).output);
            tc = strmatch(leveldata(r).(level),abbrev.(level));
            text(margin-separater*1.6, cellheight+separater/2,'%','Color',colorvec.(level)(tc,:),'FontWeight','bold','FontSize',8);

            % percent of (mfilters.boutons)
            if flag==1
                cellwidth = margin;
                for z=1:length(postfields)
                    post = postfields{z};
                    mynum=sprintf('%d',round(leveldata(r).output.(post)/leveldata(r).(mfilters.boutons)*100));
                    leveldata(r).tt(length(leveldata(r).tt)+1) = text(cellwidth-separater*.9, cellheight+separater/2,mynum,'Color',colorvec.(level)(tc,:),'FontWeight','bold','FontSize',8);
                    cellwidth = cellwidth+leveldata(ip(z)).(mfilters.synapses)+separater;
                end
            else
                % percent of (mfilters.synapses)
                cellwidth = margin;
                for z=1:length(postfields)
                    post = postfields{z};
                    tr = strmatch(leveldata(ip(z)).(level),abbrev.(level));
                    mynum=sprintf('%d',round(leveldata(r).output.(post)/leveldata(ip(z)).(mfilters.synapses)*100));
                    leveldata(r).tt(length(leveldata(r).tt)+1) = text(cellwidth-separater*.9, cellheight+separater/2,mynum,'Color',colorvec.(level)(tr,:),'FontWeight','bold','FontSize',8);
                    cellwidth = cellwidth+leveldata(ip(z)).(mfilters.synapses)+separater;
                end
            end
        end
        if leveldata(r).(mfilters.boutons)>0
            cellheight = cellheight-leveldata(r).(mfilters.boutons)-separater;
        end
    end
elseif bouts>(allboutons-separater)
    for r=1:length(leveldata)
        leveldata(r).tt=[];
        if ~isempty(leveldata(r).postfield) && leveldata(r).postfield(1)<syns && leveldata(r).postfield(3)>syns
            % disp(leveldata(r).name)
            % ee(length(ee)+1)=rectangle('Position',[leveldata(r).postfield(1) 0 leveldata(r).postfield(2)-leveldata(r).postfield(1) allboutons+margin],'EdgeColor','y','LineWidth',2);
            tc = strmatch(leveldata(r).(level),abbrev.(level));
            % text(cellwidth-separater, allboutons+separater*3/2,'%','Color',colorvec.(level)(tc,:),'FontWeight','bold','FontSize',8);

            % percent of (mfilters.boutons)
            post = postfields{r};
            if flag==0
                for z=1:length(postfields)
                    mynum=sprintf('%d',round(leveldata(ip(z)).output.(post)/leveldata(r).(mfilters.synapses)*100));
                    leveldata(r).tt(length(leveldata(r).tt)+1) = text(cellwidth-separater*.9, cellheight+separater/2,mynum,'Color',colorvec.(level)(tc,:),'FontWeight','bold','FontSize',8);
                    cellheight = cellheight-leveldata(ip(z)).(mfilters.boutons)-separater;
                end
            else
                % percent of (mfilters.synapses)
                for z=1:length(postfields)
                    tr = strmatch(leveldata(ip(z)).(level),abbrev.(level));
                    mynum=sprintf('%d',round(leveldata(ip(z)).output.(post)/leveldata(ip(z)).(mfilters.boutons)*100));
                    leveldata(r).tt(length(leveldata(r).tt)+1) = text(cellwidth-separater*.9, cellheight+separater/2,mynum,'Color',colorvec.(level)(tr,:),'FontWeight','bold','FontSize',8);
                    cellheight = cellheight-leveldata(ip(z)).(mfilters.boutons)-separater;
                end
            end
        end
        if leveldata(r).(mfilters.synapses)>0
            cellwidth = cellwidth+leveldata(r).(mfilters.synapses)+separater;
        end
    end
else
    disp(['x is ' num2str(syns) ' and y is ' num2str(bouts)])
end