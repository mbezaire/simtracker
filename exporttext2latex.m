function txtstruct=exporttext2latex(figh,figname)
%global disspath

%figh=gcf;
set(figh,'Units','inches')
adx=1;

bf = findall(figh,'Type','legend');
for b=1:length(bf)
    mystr=get(bf(b),'String');
    set(bf(b),'Units','inches')
    origpos=get(bf(b),'Position');
    th=origpos(4)/length(mystr);
    for m=1:length(mystr)
        txtstruct(adx).Pos=[origpos(1) origpos(2)+th*(length(mystr)-m)];
        txtstruct(adx).String=mystr{m};
        txtstruct(adx).Rotation=0;
        %tH=get(tx,'HorizontalAlignment');
        %tV=get(tx,'VerticalAlignment');
        txtstruct(adx).HVAlignment='LB';%upper([tH(1) tV(1)]);
        txtstruct(adx).Color=[0 0 0];
        adx=adx+1;
    end
    set(bf(b),'TextColor','w')
end

mm=findall(figh,'Type','Colorbar');
set(figh,'Units','inches');
fp=get(figh,'Position');
if ~isempty(mm)
    mm.Units='inches';
    %set(mm.Label,'Units','inches')
    %origpos=get(mm.Label,'Position');
    apos=mm.Position;
    scale=diff(get(mm,'Limits'))/apos(4);
    tmppos=get(mm.Label,'Position')/scale;
    txtstruct(adx).Pos=[fp(3)-.03 tmppos(2)+apos(2)];
    %txtstruct(adx).Pos=[origpos(1) origpos(2)+th*(length(mystr)-m)];
    txtstruct(adx).String=get(mm.Label,'String');
    txtstruct(adx).Rotation=get(mm.Label,'Rotation');
    tH='R';%get(mm.Label,'HorizontalAlignment');
    tV=get(mm.Label,'VerticalAlignment');
    txtstruct(adx).HVAlignment=upper([tH(1) tV(1)]);
    txtstruct(adx).Color=[0 0 0];
    adx=adx+1;
    set(mm.Label,'Color','w')

    myx=apos(1)+apos(3)+.02;
    mL=get(mm,'Limits');
    ty=mm.TickLabels;
    tyn=mm.Ticks;
    if ~isempty(ty)
        %pos=tk2fig(figh,mm,2,tyn);
        for t=1:length(ty)
            txtstruct(adx).Pos=[myx (tyn(t)-mL(1))/diff(mL)*apos(4)+apos(2)];
            txtstruct(adx).String=ty{t};
            txtstruct(adx).Rotation=0;
            tH='C';
            tV='T';
        txtstruct(adx).HVAlignment=upper([tH(1) tV(1)]);
            txtstruct(adx).Color=[0 0 0];
            adx=adx+1;
        end
    end
    set(mm,'TickLabels',{})
    sc=1;
    if ~isempty(ty) && ~isempty(regexp(ty{end},'[0-9]*','match'))
        sc=log10(tyn(end)/str2num(ty{end}));
    end
    if sc>1
        txtstruct(adx).Pos=[apos(1)+apos(3) apos(2)+apos(4)];
        txtstruct(adx).String=['x10\textsf{$^' num2str(sc) '$}'];
        txtstruct(adx).Rotation=0;
        txtstruct(adx).HVAlignment='LB';
        txtstruct(adx).Color=[0 0 0];
        adx=adx+1;
    end
end

allax = findall(figh,'Type','axes');

for a=1:length(allax)
    if  strcmp(lower(get(allax(a),'Visible')),'on')==0
        continue
    end
    ax=allax(a);
    axes(ax)
    set(ax,'Units','inches');
    apos=get(ax,'Position');
    % Look explicitly for:
    
    % labels
    tx=get(gca,'xlabel');
    txtstruct(adx).Pos=ax2fig(figh,ax,tx);
    txtstruct(adx).String=get(tx,'String');
    txtstruct(adx).Rotation=get(tx,'Rotation');
        tH=get(tx,'HorizontalAlignment');
        tV='M';%get(tx,'VerticalAlignment');
        txtstruct(adx).HVAlignment='CM';%upper([tH(1) tV(1)]);
    txtstruct(adx).Color=get(tx,'Color');
    adx=adx+1;
    set(tx,'Color','w')
    
    ty=get(gca,'ylabel');
    txtstruct(adx).Pos=ax2fig(figh,ax,ty);
    txtstruct(adx).String=get(ty,'String');
    txtstruct(adx).Rotation=get(ty,'Rotation');
        tH=get(ty,'HorizontalAlignment');
        Hvec={'L','C','R'};
        mH=strmatch(upper(tH(1)),Hvec);
        tV=get(ty,'VerticalAlignment');
        Vvec={'T','M','B'};
        mV=strmatch(upper(tV(1)),Vvec);
        
        txtstruct(adx).HVAlignment='CM';%upper([Hvec{mV} Vvec{mH}]);
    txtstruct(adx).Color=get(ty,'Color');
    adx=adx+1;
    set(ty,'Color','w')

    % title
    ty=get(gca,'title');
    txtstruct(adx).Pos=ax2fig(figh,ax,ty);
    txtstruct(adx).String=get(ty,'String');
    txtstruct(adx).Rotation=get(ty,'Rotation');
        tH=get(ty,'HorizontalAlignment');
        tV=get(ty,'VerticalAlignment');
        txtstruct(adx).HVAlignment=upper([tH(1) tV(1)]);
    txtstruct(adx).Color=get(ty,'Color');
    adx=adx+1;
    set(ty,'Color','w')
    
    % ticklabels
    myx=apos(1)-.06;
    myy=apos(2)-.06;
    tx=get(gca,'XTickLabel');
    txn=get(gca,'XTick');
    if ~isempty(tx)
        pos=tk2fig(figh,ax,1,txn);
        for t=1:length(tx)
            txtstruct(adx).Pos=[pos(t) myy];
            txtstruct(adx).String=tx{t};
            txtstruct(adx).Rotation=0;
            tH='C';
            tV='T';
        txtstruct(adx).HVAlignment=upper([tH(1) tV(1)]);
            txtstruct(adx).Color=[0 0 0];
            adx=adx+1;
        end
    end
    set(gca,'XTickLabel',{})
    sc=1;
    if ~isempty(tx) && ~isempty(regexp(tx{end},'[0-9]*','match'))
        sc=log10(txn(end)/str2num(tx{end}));
    end
    if sc>1
        txtstruct(adx).Pos=[apos(1)+apos(3) apos(2)];
        txtstruct(adx).String=['x10\textsf{$^' num2str(sc) '$}'];
        txtstruct(adx).Rotation=0;
        txtstruct(adx).HVAlignment='LB';
        txtstruct(adx).Color=[0 0 0];
        adx=adx+1;
    end
    
    ty=get(gca,'YTickLabel');
    tyn=get(gca,'YTick');
    if ~isempty(ty)
        pos=tk2fig(figh,ax,2,tyn);
        for t=1:length(ty)
            txtstruct(adx).Pos=[myx pos(t)];
            txtstruct(adx).String=ty{t};
            txtstruct(adx).Rotation=0;
            tH='R';
            tV='M';
        txtstruct(adx).HVAlignment=upper([tH(1) tV(1)]);
            txtstruct(adx).Color=[0 0 0];
            adx=adx+1;
        end
    end
    set(gca,'YTickLabel',{})
    sc=1;
    if ~isempty(ty) && ~isempty(regexp(ty{end},'[0-9]*','match'))
        sc=log10(tyn(end)/str2num(ty{end}));
    end
    if sc>1
        txtstruct(adx).Pos=[apos(1) apos(2)+apos(4)];
        txtstruct(adx).String=['x10\textsf{$^' num2str(sc) '$}'];
        txtstruct(adx).Rotation=0;
        txtstruct(adx).HVAlignment='LB';
        txtstruct(adx).Color=[0 0 0];
        adx=adx+1;
    end
end

% Then look for all remaining text:
bf = findall(figh,'Type','text');
for b=1:length(bf)
    mystr=get(bf(b),'String');
    if ~isempty(deblank(mystr)) &&  strcmp(lower(get(bf(b),'Visible')),'on')==1
        if strcmp(get(bf(b),'Units'),'data')
            set(bf(b),'Units','inches');
            set(get(bf(b),'Parent'),'Units','inches')
            axpos=get(get(bf(b),'Parent'),'Position');
            myposData=get(bf(b),'Position');
            mypos=[myposData(1)+axpos(1) myposData(2)+axpos(2)];
        else
            set(bf(b),'Units','inches');
            mypos=get(bf(b),'Position');
            mypos=mypos(1:2);
        end
        txtstruct(adx).Pos=mypos;
        txtstruct(adx).String=mystr;
        txtstruct(adx).Rotation=get(bf(b),'Rotation');
        tH=get(bf(b),'HorizontalAlignment');
        tV=get(bf(b),'VerticalAlignment');
        txtstruct(adx).HVAlignment=upper([tH(1) tV(1)]);
        txtstruct(adx).Color=get(bf(b),'Color');
        set(bf(b),'Color','w')
       adx=adx+1;
    end
    %set(bf(b),'Color','r');%'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end

if exist('txtstruct','var')==0 || isempty(txtstruct)
    txtstruct=[];
    return
end

for adx=length(txtstruct):-1:1
    try
    if isempty(deblank(txtstruct(adx).String)) || sum(txtstruct(adx).Color)==3 || strcmp(txtstruct(adx).Color,'w')==1
        txtstruct(adx)=[];
    end
    catch
        adx
    end
end

figpos=get(figh,'Position');
newf=figure('Color','w','Units','inches','Position',figpos);
na=axes('Position',[0 0 1 1]);
set(na,'Units','inches','xLim',[0 1],'yLim',[0 1])
for adx=1:length(txtstruct)
    if iscell(txtstruct(adx).String)
        disp([txtstruct(adx).String{1} '...: ' num2str(txtstruct(adx).Pos(1)) ', ' num2str(txtstruct(adx).Pos(2))])
    else
        disp([txtstruct(adx).String ': ' num2str(txtstruct(adx).Pos(1)) ', ' num2str(txtstruct(adx).Pos(2))])
    end
    mg=text(txtstruct(adx).Pos(1)/figpos(3),txtstruct(adx).Pos(2)/figpos(4),txtstruct(adx).String,'Rotation',txtstruct(adx).Rotation,'Color',txtstruct(adx).Color,'FontName','ArialMT','FontSize',8);
    hold on
    p=get(mg,'Position');
    ex=get(mg,'Extent');
    switch txtstruct(adx).HVAlignment
        case 'CM' 
            set(mg,'Position',[p(1)-ex(3)/2 p(2)-ex(4)/2 p(3)]);
        case 'CT' 
            set(mg,'Position',[p(1)-ex(3)/2 p(2)-ex(4) p(3)]);
        case 'CB' 
            set(mg,'Position',[p(1)-ex(3)/2 p(2) p(3)]);
        case 'RM'
            set(mg,'Position',[p(1)-ex(3) p(2)-ex(4)/2 p(3)]);
        case 'RT'
            set(mg,'Position',[p(1)-ex(3) p(2)-ex(4) p(3)]);
        case 'RB'
            set(mg,'Position',[p(1)-ex(3) p(2) p(3)]);
        case 'LM'
            set(mg,'Position',[p(1) p(2)-ex(4)/2 p(3)]);
        case 'LT'
            set(mg,'Position',[p(1) p(2)-ex(4) p(3)]);
        case 'LB'
            set(mg,'Position',[p(1) p(2) p(3)]);
    end
end

fname=figname; %[disspath strrep(get(figh,'Name'),' ','')];
width=figpos(3)*72;
normht=figpos(4)/figpos(3);
fid=fopen([fname '.eps_tex'],'w');
printheading(fid,fname,width,normht)
bf = findall(newf,'Type','text');
for b=1:length(bf)
    mystr=get(bf(b),'String');
    set(bf(b),'Units','inches')
    origpos=get(bf(b),'Position');
    origrot=get(bf(b),'Rotation');
    origcol=get(bf(b),'Color');
    printline(fid,origpos(1)/figpos(3),origpos(2)/figpos(4),origcol,origrot,mystr)
end
fprintf(fid,'\t\\end{picture}%%\n');
fprintf(fid,'\\endgroup%%');
fclose(fid);

function [tpos, varargout]=ax2fig(figh,ax,obj)

set(ax,'Units','inches')
apos=get(ax,'Position');

set(figh,'Units','inches')
fpos=get(figh,'Position');

if strcmp(get(obj,'Units'),'data')
    xL=xlim;
    yL=ylim;
    opos=get(obj,'Position');
    tpos(1)=(opos(1)-xL(1))/diff(xL)*apos(3)+apos(1);
    tpos(2)=(opos(2)-yL(1))/diff(yL)*apos(4)+apos(2);    
elseif length(get(obj,'Position'))==3
    opos=get(obj,'Position');
    tpos(1)=opos(1)+apos(1);
    tpos(2)=opos(2)+apos(2);    
else
    set(obj,'Units','normalized')
    opos=get(obj,'Position');
    tpos(1)=opos(1)*apos(3)+apos(1);
    tpos(2)=opos(2)*apos(4)+apos(2);
    
    if nargout>0
        tmppos(1)=opos(3)*apos(3);
        tmppos(2)=opos(4)*apos(4);
        varargout{1}=tmppos;
    end
end

function pos=tk2fig(figh,ax,sd,txn)

set(ax,'Units','inches')
apos=get(ax,'Position');

set(figh,'Units','inches')
fpos=get(figh,'Position');

xL = xlim;
yL = ylim;
lowlim=[xL(1) yL(1)];
highlim=[xL(2) yL(2)];

for t=1:length(txn)
    pos(t) = (txn(t)-lowlim(sd))/(highlim(sd)-lowlim(sd))*apos(sd+2)+apos(sd);
end


function printheading(fid,fname,width,normht)
fprintf(fid,'%%%% Creator: Inkscape 0.91_64bit, www.inkscape.org\n');
fprintf(fid,'%%%% PDF/EPS/PS + LaTeX output extension by Johan Engelen, 2010\n');
fprintf(fid,'%%%% Accompanies image file of similar name (pdf, eps, ps)\n');
fprintf(fid,'%%%%\n');
fprintf(fid,'%%%% Marianne Bezaire copied this template to use with MATLAB\n');
fprintf(fid,'%%%%\n');
fprintf(fid,'\\begingroup%%\n');
fprintf(fid,'\t\\makeatletter%%\n');
fprintf(fid,'\t\\providecommand\\color[2][]{%%\n');
fprintf(fid,'\t\\errmessage{(Inkscape) Color is used for the text in Inkscape, but the package ''color.sty'' is not loaded}%%\n');
fprintf(fid,'\t\\renewcommand\\color[2][]{}%%\n');
fprintf(fid,'}%%\n');
fprintf(fid,'\t\\providecommand\\transparent[1]{%%\n');
fprintf(fid,'\t\\errmessage{(Inkscape) Transparency is used (non-zero) for the text in Inkscape, but the package ''transparent.sty'' is not loaded}%%\n');
fprintf(fid,'\t\\renewcommand\\transparent[1]{}%%\n');
fprintf(fid,'}%%\n');
fprintf(fid,'\t\\providecommand\\rotatebox[2]{#2}%%\n');
fprintf(fid,'\t\\ifx\\svgwidth\\undefined%%\n');
fprintf(fid,'\t\\setlength{\\unitlength}{%fbp}%%\n',width);
fprintf(fid,'\t\\ifx\\svgscale\\undefined%%\n');
fprintf(fid,'\t\\relax%%\n');
fprintf(fid,'\t\\else%%\n');
fprintf(fid,'\t\\setlength{\\unitlength}{\\unitlength * \\real{\\svgscale}}%%\n');
fprintf(fid,'\t\\fi%%\n');
fprintf(fid,'\\else%%\n');
fprintf(fid,'\t\\setlength{\\unitlength}{\\svgwidth}%%\n');
fprintf(fid,'\\fi%%\n');
fprintf(fid,'\t\\global\\let\\svgwidth\\undefined%%\n');
fprintf(fid,'\t\\global\\let\\svgscale\\undefined%%\n');
fprintf(fid,'\\makeatother%%\n');
fprintf(fid,'\\begin{picture}(1,%f)%%\n',normht);
fprintf(fid,'\t\\put(0,0){\\includegraphics[width=\\unitlength]{%s.eps}}%%\n',strrep(fname,'\','/'));

function printline(fid,x,y,color,rotation,text)
if iscell(text)
    for i=1:length(text)
        printealine(fid,x+sin(rotation/180*pi)*.125*(i-1),y-cos(rotation/180*pi)*.125*(i-1),color,rotation,text{i})
    end
else
    printealine(fid,x,y,color,rotation,text)
end

function printealine(fid,x,y,color,rotation,text)
text=strrep(text,'^o','\textsf{$^o$}');
text=strrep(text,'_B','\textsf{$_B$}');
text=strrep(text,'#','\#');
text=strrep(text,'&','\&');
try
if sum(color)==0 && rotation==0
    fprintf(fid,'\t\\put(%f,%f){\\makebox(0,0)[lb]{\\smash{%s}}}%%\n', x, y, text);
elseif sum(color)==0 && rotation~=0
    fprintf(fid,'\t\\put(%f,%f){\\rotatebox{%d}{\\makebox(0,0)[lb]{\\smash{%s}}}}%%\n', x, y, rotation, text);
elseif sum(color)>0 && rotation~=0
    fprintf(fid,'\t\\put(%f,%f){\\color[rgb]{%f,%f,%f}\\rotatebox{%d}{\\makebox(0,0)[lb]{\\smash{%s}}}}%%\n', x, y, color(1), color(2), color(3), rotation, text);
elseif sum(color)>0 && rotation==0
    fprintf(fid,'\t\\put(%f,%f){\\color[rgb]{%f,%f,%f}\\makebox(0,0)[lb]{\\smash{%s}}}%%\n', x, y, color(1), color(2), color(3), text);
end
catch me
    text;
end