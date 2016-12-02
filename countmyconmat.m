function conmat=countmyconmat(varargin)
global sl
% pretype posttype distance between in 10 um segments 

connsim='ca1oVgH_conn_full';
resultsfile=[myrepos(q).dir sl 'results' sl 'ca1oVgH_conn_full' sl 'connections.dat'];
    if exist(resultsfile,'file')==0
    msgbox({'Results File not found:',resultsfile})
    return
end

readsegsize=1000000;
numcol=3;
cutofftest=11;%Inf;
repsz=10;

if exist(resultsfile,'file')==0
    sprintf('Warning: connection.dat file is missing\nPath: %s', resultsfile);
    return
end

fid=fopen(resultsfile);
%textscan(fid, '%s\t%s*\t%s\n', 1); % read the header
testhead=fscanf(fid, '%s\t%s\t%s\n',3);
i=0;

inrnbkt1=0:100:21200; % lump 21300-21309 into last bucket;
pyrbkt=[21310:1000:332000]; % last bucket only contains 2000-2809;
inrnbkt2=[332810:100:338710]; % lump in 711-739 into last bucket;
stimbkt=[338740:1000:793740]; % last bucket only has from 2740 - 3439 (700)
bktarray=[inrnbkt1 pyrbkt inrnbkt2 stimbkt];
u32array=uint32(bktarray);

if ~isempty(varargin) && varargin{1}==0 && exist('conmat.mat','file')
    load conmat.mat
    linesdone=sum(conmat(:));
    tic
    r=1;
    while 10000000*r<linesdone
        fscanf(fid, '%u\t%u\t%u\n',[10000000, numcol]);
        r=r+1;
        disp(['r=' num2str(r)])
    end
    if 10000000*(r-1)<linesdone
        fscanf(fid, '%u\t%u\t%u\n',[linesdone-10000000*(r-1), numcol]);
    end     
%         r=0;
%         while r<linesdone
%             fgetl(fid);
%             r=r+1;
%         end
    i=linesdone/readsegsize;
    fprintf('Just read in %.0f * %.0f = %.0f lines and set the file position after that\n',i,readsegsize,i*readsegsize,toc)
elseif ~isempty(varargin) && varargin{1}==1 && exist('conmat.mat','file')
    load conmat.mat
    fclose(fid);
    resultsfile=[resultsfile sl 'tailcons.dat'];
    fid=fopen(resultsfile);
    %textscan(fid, '%s\t%s*\t%s\n', 1); % read the header
    testhead=fscanf(fid, '%s\t%s\t%s\n',3);
else
    conmat=zeros(length(bktarray));
end
    

    tic
while ~feof(fid) %&& i<cutofftest
    [mymat, valcount] = fscanf(fid, '%u\t%u\t%u\n',[readsegsize, numcol]);
    
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
        x=find(mymat(t,1)<u32array,1,'first')-1;
        y=find(mymat(t,2)<u32array,1,'first')-1;
        conmat(x,y)=conmat(x,y)+1;
    end
    i=i+1;
    if mod(i,repsz)==0
        save conmat.mat conmat
        fprintf('Read, calculated & printed %.0f * %.0f = %.0f in %.0f seconds\n',i,readsegsize,i*readsegsize,toc)
        tic
    end
end 
fclose(fid);
clear mymat fid valcount i ME
beep;
pause(1);
beep;
pause(1);
beep;