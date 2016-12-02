function h = plot_firemod(handles,varargin)
global mypath RunArray

plotexpdata=1;
refangle=20/180*pi;

if isfield(handles.curses,'spikerast')==0
    spikeraster(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end

ind = handles.curses.ind;

myHz = 8;

timehalf=12; % Remove first 1/timehalf of simulation from analysis (under the assumption that the network needed that time to stabilize)

tstop = RunArray(ind).SimDuration; %700;%

if timehalf>1
   time_idx=find(handles.curses.spikerast(:,1)>=(tstop/timehalf));
else
    time_idx=[1:size(handles.curses.spikerast,1)];
end

spikerast=handles.curses.spikerast(time_idx,:);

if ~isempty(deblank(handles.optarg)) && ~isempty(str2num(handles.optarg))
    myHz = str2num(handles.optarg);
end

thetaper=1000/myHz;

colorvec=[.0 .0 .6;
          .0 .75 .65;
          1 .75 .0;
          1 .65 .15;
          1 .0 .0;
          .6 .4 .1;
          .5 .0 .6;
          .6 .6 .6;
          1 .1 1;
          1 0 0;
          0 0 1;];
      
leg=[];
h=figure('Color','w','Name','Fire Mod');
r=strmatch('pyramidalcell',{handles.curses.cells(:).name});
zidx = find(spikerast(:,3)==handles.curses.cells(r).ind);
numcells = handles.curses.cells(r).numcells;
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

pyrangle=angle;

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

%usepyrspikes=1;
if usepyrspikes
    pyrangle_shift=pyrangle-refangle;
    disp(['Set the pyramidal cell angle to the reference angle of ' num2str(round(refangle*180/pi)) '^o based on spikes'])
else % use pyramidal intracellular peaks
    refangle=0;
    disp(['Set the pyramidal cell angle to the reference angle of ' num2str(round(refangle*180/pi)) '^o based on MP'])
    pyrangle=getpyramidalphase(handles,[myHz myHz],0);
    pyrangle_shift=pyrangle-refangle;
end

if plotexpdata==1 && exist('firingrates.mat','file')
    %load firingrates.mat firingrates
    nrninput = gettheta;
    z=1;
    leg=[];
    legstr={};
    for r=1:length(nrninput)
        if ~isempty(nrninput(r).phase) && ~isempty(nrninput(r).firingrate)
            leg(z)=plot(mod(nrninput(r).phase,720),nrninput(r).firingrate,'Marker',nrninput(r).marker,'LineStyle','none','Color',nrninput(r).color,'MarkerFaceColor',nrninput(r).color,'MarkerSize',15);
            legstr{z}=[nrninput(r).name ': ' nrninput(r).state];
            z=z+1;
            hold on
            plot(mod(nrninput(r).phase+360,720),nrninput(r).firingrate,'Marker',nrninput(r).marker,'LineStyle','none','Color',nrninput(r).color,'MarkerFaceColor',nrninput(r).color,'MarkerSize',15);
        end
%         myi=strmatch(nrninput(r).name,{firingrates(:).name});
%         if ~isempty(myi)
%             if strcmp('an',nrninput(r).state)
%                 plot(nrninput(r).phase,firingrates(myi).anesth,'Marker',nrninput(r).marker,'Color',nrninput(r).color,'MarkerFaceColor',nrninput(r).color,'MarkerSize',15);
%                 hold on
%                 plot(nrninput(r).phase+360,firingrates(myi).anesth,'Marker',nrninput(r).marker,'Color',nrninput(r).color,'MarkerFaceColor',nrninput(r).color,'MarkerSize',15);
%             else
%                 plot(nrninput(r).phase,firingrates(myi).awake,'Marker',nrninput(r).marker,'Color',nrninput(r).color,'MarkerFaceColor',nrninput(r).color,'MarkerSize',15);
%                 hold on
%                 plot(nrninput(r).phase+360,firingrates(myi).awake,'Marker',nrninput(r).marker,'Color',nrninput(r).color,'MarkerFaceColor',nrninput(r).color,'MarkerSize',15);
%             end
%         end  
    end
end
[legstr,IA, ~] = unique(legstr);
leg = leg(IA);

for r=1:length(handles.curses.cells)
    if strcmp(handles.curses.cells(r).techname(1:2),'pp')==0
        z = strmatch(handles.curses.cells(r).name,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','supercell','deepcell'});
        spiketimes = spikerast(spikerast(:,3)==handles.curses.cells(r).ind,1);

        % get phase pref
        n=length(spiketimes);
        modspiketimes = mod(spiketimes, thetaper);

        xbar = 1/n*sum(sin(modspiketimes*pi/(thetaper/2)));
        ybar = 1/n*sum(cos(modspiketimes*pi/(thetaper/2)));

        magnitude=sqrt(xbar^2+ybar^2);
        if xbar>0
            angle = acos(ybar/magnitude);
        else
            angle = 2*pi - acos(ybar/magnitude);
        end
        angle = angle-pyrangle_shift;
        pref = angle*180/pi;
        if angle<0
            pref = (angle+2*pi)*180/pi;
        end

        % get firing rate
        fr = length(spiketimes)/(handles.curses.cells(r).numcells*RunArray(ind).SimDuration/1000);

        % add to plot
        plot(mod(pref,720),fr,'MarkerFaceColor','none','MarkerEdgeColor',colorvec(z,:),'Marker','sq','MarkerSize',10,'LineWidth',3);
        hold on
        plot(mod(pref+360,720),fr,'MarkerFaceColor','none','MarkerEdgeColor',colorvec(z,:),'Marker','sq','MarkerSize',10,'LineWidth',3);
        
        for g=handles.curses.cells(r).range_st:round(handles.curses.cells(r).numcells/100):handles.curses.cells(r).range_en % min(handles.curses.cells(r).range_en,handles.curses.cells(r).range_st+20)
            %spiketimes = handles.curses.spikerast(handles.curses.spikerast(:,2)==g,1);
            spiketimes = spikerast(spikerast(:,2)==g,1);
            
            % get phase pref
            n=length(spiketimes);
            modspiketimes = mod(spiketimes, thetaper);

            xbar = 1/n*sum(sin(modspiketimes*pi/(thetaper/2)));
            ybar = 1/n*sum(cos(modspiketimes*pi/(thetaper/2)));

            magnitude=sqrt(xbar^2+ybar^2);
            if xbar>0
                angle = acos(ybar/magnitude);
            else
                angle = 2*pi - acos(ybar/magnitude);
            end
            angle = angle-pyrangle_shift;
            pref = angle*180/pi;
            if angle<0
                pref = (angle+2*pi)*180/pi;
            end

            % get firing rate
            fr = length(spiketimes)/(RunArray(ind).SimDuration/1000);
            
            % add to plot
            plot(mod(pref,720),fr,'Color',colorvec(z,:),'Marker','.','MarkerSize',10);
            hold on
            plot(mod(pref+360,720),fr,'Color',colorvec(z,:),'Marker','.','MarkerSize',10);
        end
    end
end
xlabel('Phase Preference (degrees)')
ylabel('Firing Rate (Hz)')
title('Firing Rate and Phase Preference')
legend(leg,legstr) %{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'})
