function distcounts=countmyconns(handles)
% pretype posttype distancebetween in 10 um segments 

maxdist=5000;
rez=10;
resultsfile='C:\Users\maria_000\Documents\repos\ca1\results\ca1oVgH_conn_full\connections.dat';
readsegsize=100000;
numcol=3;
cutofftest=2;%Inf;

myrange=[handles.curses.cells.range_st handles.curses.cells(end).range_en+1];

LayerLength = 50;
LayerVec=[100 50 200 100];
layind=[2 2 2 2 4 1 2 2 3 3 4];
LongitudinalLength=4000;
TransverseLength=1000;
for r=1:length(handles.curses.cells)
    BinInfo(r) = setBins(handles.curses.cells(r).numcells,LongitudinalLength,TransverseLength,LayerVec(layind(r)));
    ZHeight(r) = sum(LayerVec(1:layind(r)-1));
end


% initialize the counter
for pre=1:length(handles.curses.cells)
    for post=1:length(handles.curses.cells)
        prename=handles.curses.cells(pre).name(1:3);
        postname=handles.curses.cells(post).name(1:3);
        distcounts.(prename).(postname).syncount=zeros(maxdist/rez+1,1);
    end
end

if exist(resultsfile,'file')==0
    sprintf('Warning: connection.dat file is missing\nPath: %s', resultsfile);
    return
end

fid=fopen(resultsfile);
%textscan(fid, '%s\t%s*\t%s\n', 1); % read the header
testhead=fscanf(fid, '%s\t%s\t%s\n',3);
i=0;
pregid=-1;
postgid=-1;
prename='';
postname='';
sind=-1;

while ~feof(fid) %&& i<cutofftest
    tic
    [mymat valcount] = fscanf(fid, '%u\t%u\t%u\n',[readsegsize, numcol]);
    
    if valcount~=readsegsize*numcol
        try
            mymat = reshape(uint32(mymat(1:valcount)),numcol,[])';
        catch ME
            disp(['could not fill last conns ' num2str(1+i*readsegsize) ':' num2str(valcount/numcol+i*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    else
        mymat = reshape(uint32(mymat),numcol,[])';
    end
    for t=1:size(mymat,1)
        %if ~isequal(mymat(t,1:2),[pregid postgid])
        if mymat(t,1)~=pregid || mymat(t,2)~=postgid
            pregid=mymat(t,1);
            postgid=mymat(t,2);

            pre=find(pregid<myrange,1,'first')-1;
            post=find(postgid<myrange,1,'first')-1;
            
            prename=handles.curses.cells(pre).name(1:3);
            postname=handles.curses.cells(post).name(1:3);

            prepos=getpos(double(mymat(t,1)), handles.curses.cells(pre).range_st, BinInfo(pre), ZHeight(pre));
            postpos=getpos(double(mymat(t,2)), handles.curses.cells(post).range_st, BinInfo(post), ZHeight(post));
            sind=floor(sqrt((prepos.x-postpos.x).^2+(prepos.y-postpos.y).^2)/rez)+1;
        end
        distcounts.(prename).(postname).syncount(sind) = distcounts.(prename).(postname).syncount(sind) + 1;
    end
    i=i+1;
    clear tmp
    if mod(i,1)==0
        fprintf('Read %.0f * %.0f = %.0f in %.0f seconds\n',i,readsegsize,i*readsegsize,toc)
    end
end 
fclose(fid);
clear mymat fid valcount i ME
beep;
pause(1);
beep;
pause(1);
beep;