function varargout=conndist(conmat,handles,varargin)
global RunArray sl

if isempty(varargin)
    for pretype=1:length(handles.curses.cells)
        for posttype=1:length(handles.curses.cells)
            mypre(pretype).mypost(posttype).dists = [];
        end
    end
else
    mypre=varargin{1};
end

if length(varargin)>1
    BinInfo=varargin{2};
    ZHeight=varargin{3};
else
    ind = handles.curses.ind;

    layers=regexp(RunArray(ind).LayerHeights,';','split');
    LayerVec=str2double(layers(2:end-1));
    dd=importdata([RunArray(ind).ModelDirectory sl 'datasets' sl 'cellnumbers_' num2str(RunArray(ind).NumData) '.dat'],' ',1);
    layind=dd.data(:,2)+1;
    ZHeight=zeros(1,length(handles.curses.cells));
    for r=1:length(handles.curses.cells)
        BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerVec(layind(r)));
        ZHeight(r) = sum(LayerVec(1:layind(r)-1));
    end
end
        
postgid=-1;

while size(conmat,1)>0
    pregid=conmat(1,1);
    pretype = find(pregid>=[handles.curses.cells.range_st],1,'last');
    prepos = getpos(pregid, handles.curses.cells(pretype).range_st, BinInfo(pretype), ZHeight(pretype));

    if (postgid~=conmat(1,2))
        postgid=conmat(1,2);
        posttype = find(postgid>=[handles.curses.cells.range_st],1,'last');
        postpos = getpos(postgid, handles.curses.cells(posttype).range_st, BinInfo(posttype), ZHeight(posttype));
    end

    idxes=find(conmat(:,1)==pregid & conmat(:,2)==postgid);
    nextidx=size(mypre(pretype).mypost(posttype).dists,1)+1;
    mypre(pretype).mypost(posttype).dists(nextidx,:)=[length(idxes) sqrt((prepos.x - postpos.x).^2 + (prepos.y - postpos.y).^2)];
    conmat(idxes,:)=[];
end 

if nargout>0
    varargout{1}=mypre;
    if nargout>1
        varargout{2}=BinInfo;
        if nargout>2
            varargout{3}=ZHeight;
        end
    end
end

return

% preORpost
if length(unique(conmat(:,1)))==1
    % pre
    gid = conmat(1,1);
    otraidx=2;
elseif length(unique(conmat(:,2)))==1
    % post
    gid = conmat(1,2);
    otraidx=1;
else
    gid = [];
    if isempty(varargin)
        for pretype=1:length(handles.curses.cells)
            for posttype=1:length(handles.curses.cells)
                mypre(pretype).mypost(posttype).dists = [];
            end
        end
    else
        mypre=varargin{1};
    end
    % this is gonna be big
end

if isempty(varargin)
    for celltype=1:length(handles.curses.cells)
        mydists(celltype).dists = [];
    end
else
    mydists = varargin{1};
end

if ~isempty(gid)
    reftype = find(gid>=[handles.curses.cells.range_st],1,'last');
    refpos = getpos(gid, handles.curses.cells(reftype).range_st, BinInfo(reftype), ZHeight(reftype));
    
    while size(conmat,1)>0
        otragid=conmat(1,otraidx);
        idxes=find(conmat(:,otraidx)==otragid);
        otratype = find(otragid>=[handles.curses.cells.range_st],1,'last');
        otrapos = getpos(otragid, handles.curses.cells(otratype).range_st, BinInfo(otratype), ZHeight(otratype));
        nextidx=size(mydists(otratype).dists,1)+1;
        mydists(otratype).dists(nextidx,1)=length(idxes);
        mydists(otratype).dists(nextidx,2)=sqrt((otrapos.x - refpos.x).^2 + (otrapos.y - refpos.y).^2);
        conmat(idxes,:)=[];
    end 
    myresults=mydists;
else
    while size(conmat,1)>0
        pregid=conmat(1,1);
        pretype = find(pregid>=[handles.curses.cells.range_st],1,'last');
        prepos = getpos(pregid, handles.curses.cells(pretype).range_st, BinInfo(pretype), ZHeight(pretype));
        
        if (postgid~=conmat(1,2))
            postgid=conmat(1,2);
            posttype = find(postgid>=[handles.curses.cells.range_st],1,'last');
            postpos = getpos(postgid, handles.curses.cells(posttype).range_st, BinInfo(posttype), ZHeight(posttype));
        end
        
        idxes=find(conmat(:,1)==pregid && conmat(:,2)==postgid);
        nextidx=size(mydists(pretype).dists,1)+1;
        mypre(pretype).mypost(postpos).dists(nextidx,:)=[length(idxes) sqrt((prepos.x - postpos.x).^2 + (prepos.y - postpos.y).^2)];
        conmat(idxes,:)=[];
    end 
    myresults=mypre;
end