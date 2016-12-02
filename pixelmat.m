function pixelmat(handles,varargin)
global disspath sl
% A.S. did mysum and avgmat calculations (ashcherbina@ucsd.edu), available
% on the web
if isempty(sl)
    if ispc
sl='\';
    else
        sl='/';
    end
end


wgtflag=1;

if isempty(handles)
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
    handles.curses.runinfo.ModelDirectory=myrepos(q).dir;
    handles.curses.runinfo.RunName='ca1_olmVar_gH_30_03';
    wgtflag=0;
end

if exist([handles.curses.runinfo.ModelDirectory sl handles.curses.runinfo.RunName],'dir')==0
    msgbox({'This simulation is not in repository:',handles.curses.runinfo.RunName})
end

sclnum=50; %20;
dummydata=0;

if nargin>2
    dummydata=varargin{2};
    sclnum=varargin{1};
elseif nargin>1
    sclnum=varargin{1};
end

maxpre=793437;
maxpost=350000;

connum=5e9;
readsegsize=5e7;

if dummydata
    avgmat=zeros([ceil((maxpre+1)/sclnum),ceil((maxpost+1)/sclnum)]);
    mk=0;
    while mk<connum
        makechunk=min(readsegsize,connum-mk);
        presyn=randi(maxpre-1,makechunk,1);
        postsyn=randi(maxpost-1,makechunk,1);
        wgts=loadwgts(handles,makechunk,wgtflag);
        mk=mk+makechunk;
        avgmat=avgmat+getavgmat(presyn,postsyn,wgts,sclnum,maxpre,maxpost);
    end
else
    if exist([handles.curses.runinfo.ModelDirectory sl 'results' sl handles.curses.runinfo.RunName sl 'cell_syns.dat'], 'file')
        filename=[handles.curses.runinfo.ModelDirectory sl 'results' sl handles.curses.runinfo.RunName sl 'cell_syns.dat'];
        shortfile=1;
    else
        filename=[handles.curses.runinfo.ModelDirectory sl 'results' sl handles.curses.runinfo.RunName sl 'connections.dat'];
    end

    if exist(filename,'file')==0
        sprintf('Warning: connection.dat file is missing\nPath: %s', filename);
        return
    end
    
    if shortfile==1
        [presyn, postsyn]=textread(filename,'%d\t%d\t%*d\n','headerlines',1);
        connum=length(presyn);
        wgts=loadwgts(handles,connum,wgtflag);
        avgmat=getavgmat(presyn,postsyn,wgts,sclnum,maxpre,maxpost);
    else
        fid=fopen(filename);
        textscan(fid, '%s\t%s\t%s\n', 1); % read the header
        i=0;
        avgmat=zeros([ceil((maxpre+1)/sclnum),ceil((maxpost+1)/sclnum)]);
        while ~feof(fid)
            [connections, i]=readfile(fid,readsegsize,i);
            connum=size(connections,1);
            wgts=loadwgts(handles,connum,wgtflag);
            avgmat=avgmat+getavgmat(connections(:,1),connections(:,2),wgts,sclnum,maxpre,maxpost);
        end 
        fclose(fid);
    end
end

figure('Color','w')
imagesc(avgmat)
ylabel('Presynaptic')
xlabel('Postsynaptic')
colormap jet
colorbar
axis equal
axis tight
set(gca,'YTickLabel',strcat(cellstr(num2str(get(gca,'YTick')'*sclnum/1000)),'K'))
set(gca,'XTickLabel',strcat(cellstr(num2str(get(gca,'XTick')'*sclnum/1000)),'K'))
printeps(gcf,[disspath 'PixelMat'])
clear avgmat


% typerange=[0 21309; 21310 332809; 332810 338739; 338740 793439];
% types={'Inrn 1','Pyr','Inrn 2','Aff'};
% figure('Color','w')
% myscale=12;
% for tr=1:length(types)-1
%     for tc=1:length(types)
%         ylabel(['Presynaptic ' types{tc}])
%         xlabel(['Postsynaptic ' types{tr}])
%         imagesc(avgmat)
%         xlim(typerange(tr,:))
%         ylim(typerange(tc,:))
%         axis tight equal
%         colormap jet
%         colorbar
%         set(gcf,'PaperUnits','inches','Units','inches','Position',[.5 .5 diff(xlim)*myscale/793439+2 diff(ylim)*myscale/793439+2],'PaperPosition',[0 0 diff(xlim)*myscale/793439+2 diff(ylim)*myscale/793439+2],'PaperSize',[diff(xlim)*myscale/793439+2 diff(ylim)*myscale/793439+2])
%         set(gca,'Units','inches','Position',[1 1 diff(xlim)*myscale/793439 diff(ylim)*myscale/793439])
%         set(gca,'YTickLabel',strcat(cellstr(num2str(get(gca,'YTick')'*sclnum/1000)),'K'))
%         set(gca,'XTickLabel',strcat(cellstr(num2str(get(gca,'XTick')'*sclnum/1000)),'K'))
%         printeps(gcf,[disspath 'PixelMat_' num2str(tr) '_' num2str(tc)])
%         set(gca,'YTickLabelMode','auto')
%         set(gca,'YTickMode','auto')
%         set(gca,'XTickLabelMode','auto')
%         set(gca,'XTickMode','auto')
%     end
% end
% 
% clear avgmat

function wgts=loadwgts(handles,connum,wgtflag)

if wgtflag==1
    wgts=NaN;
    for c=1:length(handles.curses.cells)
    end
elseif wgtflag==-1
    wgts=rand(connum,1);
else
    wgts=ones(connum,1);
end

%


function avgmat=getavgmat(presyn,postsyn,wgts,sclnum,maxpre,maxpost)
% bin gids
pre=ceil(double(presyn+1)/sclnum);
clear presyn
post=ceil(double(postsyn+1)/sclnum);
clear postsyn

% bin weights
linearInd = sub2ind([ceil((maxpre+1)/sclnum),ceil((maxpost+1)/sclnum)], pre, post);
mysum=full(sparse(linearInd,ones(size(linearInd)),wgts));
clear wgts

% shape matrix and plot it
avgmat=reshape(sum([mysum;zeros(prod([ceil((maxpre+1)/sclnum),ceil((maxpost+1)/sclnum)])-length(mysum),1)*nan],2,'omitnan'),[ceil((maxpre+1)/sclnum),ceil((maxpost+1)/sclnum)]);



function [connections, i]=readfile(fid,readsegsize,i)
[mymat valcount] = fscanf(fid, '%u\t%u\t%*u\n',[readsegsize, 2]);
if valcount==readsegsize*2
    try
        connections(1+i*readsegsize:(i+1)*readsegsize,1:2) = reshape(uint32(mymat),2,[])';
    catch ME
        disp(['could not fill conns ' num2str(1+i*readsegsize) ':' num2str((i+1)*readsegsize)])
        disp(['specific error: ' ME.message]);
        disp(['in ' ME.stack.file ' line ' ME.stack.line]);
        return
    end
else
    try
        connections(1+i*readsegsize:valcount/2+i*readsegsize,1:2) = reshape(uint32(mymat(1:valcount)),2,[])';
        connections(valcount/2+i*readsegsize+1:end,:) = [];
    catch ME
        disp(['could not fill last conns ' num2str(1+i*readsegsize) ':' num2str(valcount/2+i*readsegsize)])
        disp(['specific error: ' ME.message]);
        disp(['in ' ME.stack.file ' line ' ME.stack.line]);
        return
    end
end
i=i+1;
clear mymat valcount ME