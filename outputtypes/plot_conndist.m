function h=plot_conndist(handles) % distidx = the column of the connection matrix that gives the distance between the connections
global mypath RunArray

distidx=6;
preidx=4;
postidx=5;

getdetailedconns(handles.btn_generate,handles,preidx,postidx); % precell type column (4), postcelltype column (5)
handles=guidata(handles.btn_generate);



% This fcn is only available if the detailed conmat was printed

ind = handles.curses.ind;
step=100; %um
longlength = RunArray(ind).LongitudinalLength;
LayerLength = 50;
    % addfig('ConnLengthDist',visstr); % make a new figure and add it to a
    % list of figures:
    h=figure('Visible','off');
    
    for r=1:length(handles.curses.cells)
        BinInfo(r) = setBins(handles.curses.cells(r).numcells,RunArray(ind).LongitudinalLength,RunArray(ind).TransverseLength,LayerLength);
        ZHeight(r) = 50;
    end
    for k=1:size(handles.curses.connections,1)
        try
            pretype=find([handles.curses.cells(:).range_st]<=handles.curses.connections(k,1),1,'last');
            posttype=find([handles.curses.cells(:).range_st]<=handles.curses.connections(k,2),1,'last');

            prepos = getpos(handles.curses.connections(k,1), handles.curses.cells(pretype).range_st, BinInfo(pretype), ZHeight(pretype));
            postpos = getpos(handles.curses.connections(k,2), handles.curses.cells(posttype).range_st, BinInfo(posttype), ZHeight(posttype));

            handles.curses.connections(k,distidx) = sqrt((prepos.x - postpos.x).^2 + (prepos.y - postpos.y).^2 + (prepos.z - postpos.z).^2);
        catch ME
%             if strcmp('Matrix dimensions must agree.',ME.message)==0
%                 disp(['specific error: ' ME.message]);
%                 disp(['k: ' num2str(k) ' precell: ' num2str(handles.curses.connections(k,1)) ' postcell: ' num2str(handles.curses.connections(k,2))]);
%             end
            handles.curses.connections(k,distidx)=NaN;
        end
    end
        
    for r=1:RunArray(ind).NumCellTypes % here's one where we may want to leave out the artificial cells - at least as postsynaptic targets
       for w=1:RunArray(ind).NumCellTypes
           subplot(RunArray(ind).NumCellTypes,RunArray(ind).NumCellTypes,(r-1)*RunArray(ind).NumCellTypes+w) % this identifies the # of subplots needed and which one is this one
           
           outind=find(handles.curses.connections(:,preidx)==handles.curses.cells(r).ind & ...
                        handles.curses.connections(:,postidx)==handles.curses.cells(w).ind);
           if ~isempty(outind)
                hist(double(handles.curses.connections(outind,distidx)),0:step:longlength);
                histdata=length(outind)^(.5);
           else
                histdata=1;
           end
           hold on
           
           if exist([RunArray(ind).ModelDirectory '/cells/dist_' handles.curses.cells(r).name '.hoc'],'file')~=2
               a=1; b=0; c=1;
               disp(['no dist coeffs defined for pre-cell type ' handles.curses.cells(r).name]);
           else
               dist=importdata([RunArray(ind).ModelDirectory '/cells/dist_' handles.curses.cells(r).name '.hoc']);
               a=dist(1);
               b=dist(2);
               c=dist(3);
           end
           
           disteq=(1/a)*exp(-(((0:step:longlength)-b)/c).^2);
           plot(0:step:longlength,disteq*histdata,'r')
           hold off
           title([handles.curses.cells(r).name ' to ' handles.curses.cells(w).name])
           xlim([0 longlength])
       end
    end
