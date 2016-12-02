function [hf, myFaces, distavail]=Diagram3Dmodel(handles,colorstruct)
global mypath RunArray myFontSize myFontWeight myFontName sl


load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
disspath=[myrepos(q).dir(1:wtmp(end)) 'figures' myrepos(q).dir(wtmp(end):end)];
if exist(disspath,'dir')==0
    mkdir(disspath)
end

mrr=ver;
if datenum(mrr(1).Date)<735749 %|| olderflag==1
        hf=figure('Name','ModelShape3D','Renderer', 'painters','Visible','on','Color','w','Units','inches','PaperUnits','inches','PaperSize',[3.8 3],'PaperPosition',[0 0 3.8 3],'Position',[.5 .5 3.8 3]);
    else
        hf=figure('Name','ModelShape3D','GraphicsSmoothing','off', 'Renderer', 'painters','Visible','on','Color','w','Units','inches','PaperUnits','inches','PaperSize',[3.8 3],'PaperPosition',[0 0 3.8 3],'Position',[.5 .5 3.8 3]);
    end

ind=handles.curses.ind;

colorvec(1,:)=colorstruct.olm.color;
colorvec(2,:)=min(sum([colorstruct.pvbasket.color; colorstruct.pyramidal.color]),[1 1 1]);%mean([colorstruct.pvbasket.color; colorstruct.pyramidal.color]);
colorvec(3,:)=colorstruct.cck.color;
colorvec(4,:)=colorstruct.ngf.color;

%colorvec = [.5 0 .8; 0 .2 1; .9 .3 0; 1 0 .6];
layerstrings={'Oriens','Pyramidale','Radiatum','Lacunosum-Moleculare'};

Long = RunArray(ind).LongitudinalLength;
Trans = RunArray(ind).TransverseLength;
mylayers=regexp(RunArray(ind).LayerHeights,';','split');
for ml=2:length(mylayers)-1
    layers(ml-1) = str2num(mylayers{ml});
end
CumHeight = 0;

bottomleftstart=[1000 100 10];

for l=1:length(layers)
Height = layers(l);
BottomLeft = bottomleftstart;
BottomLeft(3)=BottomLeft(3)+CumHeight;
BottomRight= [BottomLeft(1)+Long BottomLeft(2) BottomLeft(3)];

TopLeft = [BottomLeft(1) BottomLeft(2) BottomLeft(3)+Height];
TopRight = [BottomRight(1) BottomRight(2) BottomRight(3)+Height];

BackBottomLeft = BottomLeft;
BackBottomRight = BottomRight;
BackTopLeft = TopLeft;
BackTopRight = TopRight;

BackBottomLeft(2) = BackBottomLeft(2) + Trans;
BackBottomRight(2) = BackBottomRight(2) + Trans;
BackTopLeft(2) = BackTopLeft(2) + Trans;
BackTopRight(2) = BackTopRight(2) + Trans;

mydims={'X','Y','Z'};

myFaces(1).AllVerts = [ ...
    BottomLeft;
    BottomRight;
    TopRight;
    TopLeft;
    BottomLeft;];

myFaces(2).AllVerts = [ ...   
    BottomLeft;
    BackBottomLeft;
    BackTopLeft;
    TopLeft;
    BottomLeft;    
];

myFaces(3).AllVerts = [ ...   
    TopLeft;
    TopRight;
    BackTopRight;
    BackTopLeft;
    TopLeft;
];

myFaces(4).AllVerts = [ ...  
    BackTopLeft;
    BackBottomLeft;
    BackBottomRight;
    BackTopRight;
    BackTopLeft;
];

myFaces(5).AllVerts = [ ...  
    BackTopRight;
    TopRight;
    BottomRight;
    BackBottomRight;
    BackTopRight;
];

myFaces(6).AllVerts = [ ...  
    BottomRight;   
    BottomLeft;
    BackBottomLeft;
    BackBottomRight;
    BottomRight;   
];

for x=1:length(myFaces)
    clear mystruct
    for m=1:size(myFaces(x).AllVerts,1)
        for r=1:length(mydims)
            mystruct(m).(mydims{r}) = myFaces(x).AllVerts(m,r);
        end
    end
    hfill(x)=fill3([mystruct.X],[mystruct.Y],[mystruct.Z],colorvec(l,:));
    hleg(l)=hfill(x);
    hold on
end
CumHeight = CumHeight + Height;
end
legend(flip(hleg),flip(layerstrings),'Position',[0.5402    0.6178    0.4685    0.2338],'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
legend BOXOFF
chunksize = [50 80 50];
BottomLeft = [bottomleftstart(1)+Long bottomleftstart(2)+Trans+50 bottomleftstart(3)+layers(1)];
BottomRight= [BottomLeft(1)+chunksize(1) BottomLeft(2) BottomLeft(3)];

TopLeft = [BottomLeft(1) BottomLeft(2) BottomLeft(3)+chunksize(3)];
TopRight = [BottomRight(1) BottomRight(2) BottomRight(3)+chunksize(3)];

BackBottomLeft = BottomLeft;
BackBottomRight = BottomRight;
BackTopLeft = TopLeft;
BackTopRight = TopRight;

BackBottomLeft(2) = BackBottomLeft(2) + chunksize(2);
BackBottomRight(2) = BackBottomRight(2) + chunksize(2);
BackTopLeft(2) = BackTopLeft(2) + chunksize(2);
BackTopRight(2) = BackTopRight(2) + chunksize(2);


mydims={'X','Y','Z'};

myFaces(1).AllVerts = [ ...
    BottomLeft;
    BottomRight;
    TopRight;
    TopLeft;
    BottomLeft;];

myFaces(2).AllVerts = [ ...   
    BottomLeft;
    BackBottomLeft;
    BackTopLeft;
    TopLeft;
    BottomLeft;    
];

myFaces(3).AllVerts = [ ...   
    TopLeft;
    TopRight;
    BackTopRight;
    BackTopLeft;
    TopLeft;
];

myFaces(4).AllVerts = [ ...  
    BackTopLeft;
    BackBottomLeft;
    BackBottomRight;
    BackTopRight;
    BackTopLeft;
];

myFaces(5).AllVerts = [ ...  
    BackTopRight;
    TopRight;
    BottomRight;
    BackBottomRight;
    BackTopRight;
];

myFaces(6).AllVerts = [ ...  
    BottomRight;   
    BottomLeft;
    BackBottomLeft;
    BackBottomRight;
    BottomRight;   
];

for x=1:length(myFaces)
    clear mystruct
    for m=1:size(myFaces(x).AllVerts,1)
        for r=1:length(mydims)
            mystruct(m).(mydims{r}) = myFaces(x).AllVerts(m,r);
        end
    end
    fill3([mystruct.X],[mystruct.Y],[mystruct.Z],colorvec(2,:));
end

axis equal
%camlight
camproj('perspective')
view(50.5,30)

set(gca,'XTick',[],'YTick',[],'ZTick',[])
xlabel(['Longitudinal (' num2str(Long) ' \mum)'])
ylabel(['Transverse (' num2str(Trans) ' \mum)'])
zlabel(['Height (' num2str(sum(layers)) ' \mum)'])

bf = findall(hf(1),'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
bf = findall(hf(1),'Type','axis');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
set(gca,'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)


addpath('Tools for Axis Label Alignment in 3D Plot')
align_axislabels(gca)


% add zoom lines
graphX = [.9 .99];
graphY1 =  [.32 .3];
graphY2 =  [.335 .6];
annotation('line',graphX,graphY1)
annotation('line',graphX,graphY2)

if 1==0
printeps(hf(1),[disspath get(hf(1),'Name')])
end

% add another figure with the cell soma dots

layerstr=regexp(RunArray(ind).LayerHeights,';','split');
LayerVec=str2double(layerstr(2:end-1));
dd=importdata([RunArray(ind).ModelDirectory sl 'datasets' sl 'cellnumbers_' num2str(RunArray(ind).NumData) '.dat'],' ',1);
layind=dd.data(:,2)+1;
ZHeight=zeros(1,length(handles.curses.cells));
for r=1:length(handles.curses.cells)
    BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerVec(layind(r)));
    ZHeight(r) = sum(LayerVec(1:layind(r)-1));
end

if datenum(mrr(1).Date)<735749 %|| olderflag==1
    hf(2)=figure('Name','ModelShapeZoom','Renderer', 'painters','Visible','on','Color','w','Units','inches','PaperUnits','inches','PaperSize',[2 3],'PaperPosition',[0 0 2 3],'Position',[4.5 .5 2 3]);
else
    hf(2)=figure('Name','ModelShapeZoom','GraphicsSmoothing','off', 'Renderer', 'painters','Visible','on','Color','w','Units','inches','PaperUnits','inches','PaperSize',[2 3],'PaperPosition',[0 0 2 3],'Position',[4.5 .5 2 3]);
end

chunksize = [50 80 50];
BottomLeft=[100 100 100];
BottomRight= [BottomLeft(1)+chunksize(1) BottomLeft(2) BottomLeft(3)];

TopLeft = [BottomLeft(1) BottomLeft(2) BottomLeft(3)+chunksize(3)];
TopRight = [BottomRight(1) BottomRight(2) BottomRight(3)+chunksize(3)];

BackBottomLeft = BottomLeft;
BackBottomRight = BottomRight;
BackTopLeft = TopLeft;
BackTopRight = TopRight;

BackBottomLeft(2) = BackBottomLeft(2) + chunksize(2);
BackBottomRight(2) = BackBottomRight(2) + chunksize(2);
BackTopLeft(2) = BackTopLeft(2) + chunksize(2);
BackTopRight(2) = BackTopRight(2) + chunksize(2);


mydims={'X','Y','Z'};

myFaces(1).AllVerts = [ ...
    BottomLeft;
    BottomRight;
    TopRight;
    TopLeft;
    BottomLeft;];

myFaces(2).AllVerts = [ ...   
    BottomLeft;
    BackBottomLeft;
    BackTopLeft;
    TopLeft;
    BottomLeft;    
];

myFaces(3).AllVerts = [ ...   
    TopLeft;
    TopRight;
    BackTopRight;
    BackTopLeft;
    TopLeft;
];

myFaces(4).AllVerts = [ ...  
    BackTopLeft;
    BackBottomLeft;
    BackBottomRight;
    BackTopRight;
    BackTopLeft;
];

myFaces(5).AllVerts = [ ...  
    BackTopRight;
    TopRight;
    BottomRight;
    BackBottomRight;
    BackTopRight;
];

myFaces(6).AllVerts = [ ...  
    BottomRight;   
    BottomLeft;
    BackBottomLeft;
    BackBottomRight;
    BottomRight;   
];


for postype=[7 8 4 3 2 1];
    gid=handles.curses.cells(postype).range_st:handles.curses.cells(postype).range_en;
    pos = getpos(gid, handles.curses.cells(postype).range_st, BinInfo(postype), ZHeight(postype));
    pidx=find(pos.x>BottomLeft(1) & pos.x<(BottomLeft(1)+chunksize(1)) & pos.y>BottomLeft(2) & pos.y<(BottomLeft(2)+chunksize(2)));
    mypos = [pos.x(pidx)' pos.y(pidx)' pos.z(pidx)'];
    if handles.curses.cells(postype).numcells>10000
        mysz=10;
    else
        mysz=20;
    end
    if length(unique(mypos(:,3)))>2 && 1==0
        posvec=unique(mypos(:,3));
        for py=1:length(posvec)
            newidx=find(mypos(:,3)==posvec(length(posvec)-py+1));
            mycol=colorstruct.(handles.curses.cells(postype).name(1:end-4)).color;
            changeby=([1 1 1]-mycol)./10;
            plot3(mypos(newidx,1),mypos(newidx,2),mypos(newidx,3),'LineStyle','none','Marker','.','MarkerSize',mysz,'Color',min(sum([mycol; py*changeby]),[1 1 1]))
            hold on
        end
    else
        plot3(mypos(:,1)-BottomLeft(1),mypos(:,2)-BottomLeft(2),mypos(:,3)-BottomLeft(3),'LineStyle','none','Marker','.','MarkerSize',mysz,'Color',colorstruct.(handles.curses.cells(postype).name(1:end-4)).color)
    end
    disp([handles.curses.cells(postype).name ': ' num2str(size(mypos,1))])
    hold on
end
% 
% for x=1:length(myFaces)
%     clear mystruct
%     for m=1:size(myFaces(x).AllVerts,1)
%         for r=1:length(mydims)
%             mystruct(m).(mydims{r}) = myFaces(x).AllVerts(m,r);
%         end
%     end
%     patch([mystruct.X],[mystruct.Y],[mystruct.Z],'FaceColor','none','EdgeColor','k');
%     hold on
% end

axis equal
box on
xlim([0 chunksize(1)])
ylim([0 chunksize(2)])
zlim([0 chunksize(3)])

xlabel({'Longitudinal',['(' num2str(chunksize(1)) ' \mum)']})
ylabel({'Transverse',['(' num2str(chunksize(2)) ' \mum)']})
zlabel(['Height (' num2str(chunksize(3)) ' \mum)'])

set(gca,'XTick',[],'YTick',[],'ZTick',[])
camlight
camproj('perspective')
view(50.5,30)

bf = findall(hf(2),'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
bf = findall(hf(2),'Type','axis');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
set(gca,'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)

align_axislabels(gca)

if 1==0
printeps(hf(2),[disspath get(hf(2),'Name')])
end


% now add axonal distributions
% to put in context, perhaps add the gaussian equation that was used
% and also a line indicating the total possible connections at each
% distance
mm=whos;
mm = mm([mm.global mypath]==0);
C = setdiff({mm.name},{'handles','colorstruct','BinInfo','ZHeight','hf','myFaces', 'distavail'});
for r=1:length(C)
    clear(C{r});  
end

maxdist=5000;
rez=10;

% initialize the counter
for pre=1:length(handles.curses.cells)
    for post=1:length(handles.curses.cells)
        prename=handles.curses.cells(pre).name(1:3);
        postname=handles.curses.cells(post).name(1:3);
        distavail.(prename).(postname).dists=zeros(maxdist/rez+1,1);
    end
end

for pr=1:length(handles.curses.cells)-2
    prepos=getpos([handles.curses.cells(pr).range_st:handles.curses.cells(pr).range_en], handles.curses.cells(pr).range_st, BinInfo(pr), ZHeight(pr));
    for po=1:length(handles.curses.cells)-2
        postpos=getpos([handles.curses.cells(po).range_st:handles.curses.cells(po).range_en], handles.curses.cells(po).range_st, BinInfo(po), ZHeight(po)); 
        
        if length(prepos.x)*length(postpos.x)>264775000
            disp(['Starting ' handles.curses.cells(pr).name ' x ' handles.curses.cells(po).name]);
            pridx=1:10000:length(prepos.x)+9999;
            poidx=1:10000:length(postpos.x)+9999;
            pridx(end)=length(prepos.x);
            poidx(end)=length(postpos.x);
            summe=zeros(1,maxdist/rez+1);
            for m=1:length(pridx)-1
                for n=1:length(poidx)-1
                    prematX=repmat([prepos.x(pridx(m):pridx(m+1))],length([postpos.x(poidx(n):poidx(n+1))]),1);
                    postmatX=repmat([postpos.x(poidx(n):poidx(n+1))]',1,length([prepos.x(pridx(m):pridx(m+1))]));

                    prematY=repmat([prepos.y(pridx(m):pridx(m+1))],length([postpos.y(poidx(n):poidx(n+1))]),1);
                    postmatY=repmat([postpos.y(poidx(n):poidx(n+1))]',1,length([prepos.y(pridx(m):pridx(m+1))]));

                    tmpmat=sqrt((prematX-postmatX).^2+(prematY-postmatY).^2);

                    if pr==po
                        tmpmat(eye(size(tmpmat))~=0)=NaN;
                        tmpmat = tmpmat(~isnan(tmpmat));
                    end
                    summe=sum([summe; histc(tmpmat(:),0:rez:maxdist)']);
                    disp(['... did ' num2str(m) '/' num2str(length(pridx)-1) ' x ' num2str(n) '/' num2str(length(poidx)-1)]);
                end
           end
            distavail.(handles.curses.cells(pr).name).(handles.curses.cells(po).name).dists = summe;
        else
            prematX=repmat([prepos.x],length([postpos.x]),1);
            postmatX=repmat([postpos.x]',1,length([prepos.x]));

            prematY=repmat([prepos.y],length([postpos.y]),1);
            postmatY=repmat([postpos.y]',1,length([prepos.y]));

            newmat=sqrt((prematX-postmatX).^2+(prematY-postmatY).^2);

            if pr==po
                newmat(eye(size(newmat))~=0)=NaN;
                newmat = newmat(~isnan(newmat));
            end
            distavail.(handles.curses.cells(pr).name).(handles.curses.cells(po).name).dists = histc(newmat(:),0:rez:maxdist);
        end
        disp(['Just finished ' handles.curses.cells(pr).name ' x ' handles.curses.cells(po).name]);
        save distavail.mat distavail
    end
end

%h= distcounts();


