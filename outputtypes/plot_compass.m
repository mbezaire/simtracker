function [h varargout]= plot_compass(handles,varargin)
global mypath RunArray

plotexpdata=10;

myHz = 8;

ind = handles.curses.ind;

if ~isempty(deblank(handles.optarg)) && ~isempty(str2num(handles.optarg))
    myHz = str2num(handles.optarg);
end

thetaper=1000/myHz;


if thetaper<50
    refphase = 0;
else
    refphase = 20;
end

spikerast = handles.curses.spikerast;

mycells = importdata([RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName '/celltype.dat']);
numcelltypes = size(mycells.data,1);%-1;


for r=1:numcelltypes
    celltypevec{r} = mycells.textdata{r+1,1};%2,1};
    numcellsvec(r) = mycells.data(r,3) - mycells.data(r,2) + 1; %+1
end


if isempty(varargin)==0
    axes(varargin{1})
    h=gcf;
    showleg=0;
    if length(varargin)>1
        plotexpdata=varargin{2};
    end
else
    if thetaper<50
        h=figure('Color','w','Name','Gamma Compass');
    else
        h=figure('Color','w','Name','Theta Compass');
    end
    showleg=1;
end

tstop = RunArray(ind).SimDuration; %700;%

time_idx = find(spikerast(:,1)>handles.general.crop);% & spikerast(:,1)<600);

spikerast=spikerast(time_idx,:);

[x,y] = pol2cart(0,1);
h_fake=compass(x,y);
hold on

colorvec=[.0 .0 .6;
          .0 .75 .65;
          1 .75 .0;
          1 .5 .3;
          1 .0 .0;
          .6 .4 .1;
          .5 .0 .6;
          .6 .6 .6;
          1 .1 1;
          1 0 0;
          0 0 1;];

      pyrangle=0;
      
legstr={};
legh=[];
for r=1:length(celltypevec)
    celltype = celltypevec{r};
    z = strmatch(celltype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','supercell','deepcell'});
    zidx = find(spikerast(:,3)==r-1);
    numcells = numcellsvec(r);
    legstr{length(legstr)+1}=[celltype ' (' num2str(numcells) ' cells)'];
    spiketimes = spikerast(zidx,1);

    n=length(spiketimes);
    modspiketimes = mod(spiketimes, thetaper);

    xbar = 1/n*sum(sin(modspiketimes*pi/(thetaper/2)));
    ybar = 1/n*sum(cos(modspiketimes*pi/(thetaper/2)));

    magnitude(r)=sqrt(xbar^2+ybar^2);
    if xbar>0
        angle = acos(ybar/magnitude(r));
    else
        angle = 2*pi - acos(ybar/magnitude(r));
    end

    rdir(r) = angle; % * pi/180;
    if ~isempty(z) && z==1
        pyrangle=angle;
        disp(['Absolute angle of pyramidal cell (t=0 is phase=0): ' num2str(round(pyrangle*180/pi))])
    end
% http://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics/content/circ_rtest.m
    if ~isempty(modspiketimes)
        [pval zval] = circ_rtest(modspiketimes*pi/(thetaper/2));
        disp([celltype ': pval of ' num2str(pval) '. z statistic of ' num2str(zval) ', my r: ' num2str(magnitude(r))])
    else
        disp([celltype ' had no spikes to analyze'])
    end
end

nrninput = gettheta(-2);
if isdeployed
    usepyrspikes=0;
else
    myvers=ver;
    g=strcmp({myvers(:).Name},'Signal Processing Toolbox');
    if sum(g)>0
        usepyrspikes=0;
    else
        usepyrspikes=1;
    end
end
usepyrspikes=1;
if usepyrspikes
    refangle=refphase/180*pi;
    pyrangle_shift=pyrangle-refangle;
    disp('Set the pyramidal cell angle to the reference angle of 20^o')
else % use pyramidal intracellular peaks
    refangle=0;
    pyrangle=getpyramidalphase(handles,[myHz myHz],0);
    pyrangle_shift=pyrangle-refangle;
end
zz=1;
for r=1:length(celltypevec)
    rdir(r) = rdir(r)-pyrangle_shift;
    [x,y] = pol2cart(rdir(r),magnitude(r));
    k=compass(x,y);
    legh(length(legh)+1)=k;
    celltype = celltypevec{r};
    z = strmatch(celltype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','supercell','deepcell'});
    if isempty(z)
        set(k,'Color','k','LineWidth',4);
    else
        final_angle(z) = rdir(r)*180/pi;
        if rdir(r)<0
            final_angle(z) = (rdir(r)+2*pi)*180/pi;
        elseif isnan(rdir(r))
            final_angle(z) = 0;
        end
        set(k,'Color',colorvec(z,:),'LineWidth',4);
        % disp([celltype ': ' num2str(final_angle(z))])
        cellsdata(zz).name = celltype;
        cellsdata(zz).phase = mod(rdir(r),2*pi)*180/pi;
        if isnan(cellsdata(zz).phase)
            cellsdata(zz).phase=0;
        end
        cellsdata(zz).offset = [0 0];
        cellsdata(zz).color = colorvec(z,:);
        zz=zz+1;
    end
end


h(2)=MiniPhaseShift_Figure(cellsdata,myHz,[]);
h(3)=MiniPhaseShift_Exp(cellsdata,myHz,[]);
if nargout>1
    varargout{1}=final_angle;
    varargout{2}={'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','supercell','deepcell'};
    varargout{3}=cellsdata;
    varargout{4}=pyrangle;
end
if exist('h','var')
    figure(h(1));
end

if plotexpdata==1
    for r=1:length(nrninput)
        disp([nrninput(r).name '_' nrninput(r).state ': ' num2str(nrninput(r).phase)])
        [x,y] = pol2cart(nrninput(r).phase*pi/180,1);
        k=compass(x,y);
        set(k,'Color','k','LineStyle',nrninput(r).linestyle,'Color',nrninput(r).color,'LineWidth',3);
    end  
end
set(h_fake,'Visible','off');

if showleg
    legend(legh,legstr,'Location','BestOutside')

    if handles.general.crop>0
        title({[RunArray(ind).RunName ' theta preferred firing phase distribution'],['and strength of modulation at ' num2str(1000/thetaper) ' Hz'],[' (first ' num2str(handles.general.crop) ' ms removed from analysis)']},'Interpreter','none')
    else
        title({[RunArray(ind).RunName ' theta preferred firing phase distribution'],['and strength of modulation at ' num2str(1000/thetaper) ' Hz']},'Interpreter','none')
    end
else
    h = final_angle;
end
