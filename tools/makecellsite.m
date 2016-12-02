
function makecellsite(AllCells,handles,websitepath)
global mypath DetailedData sl
if ispc
    sl='\';
else
    sl='/';
end

fired = fopen([websitepath sl 'FiringRates.txt'],'w');
for h=1:length(handles.indices)
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.indices(h)).DetailedData '.mat']);
    eval(['DetailedData = ' AllCells(handles.indices(h)).DetailedData ';']);

    celltype = strrep(AllCells(handles.indices(h)).CellType,'_model','cell'); %AllCells(handles.indices(h)).CellType

    exptype = strrep(AllCells(handles.indices(h)).CellType,'_model','');
    othercellsidx = strmatch(exptype,{AllCells(:).CellType},'exact'); % find all the indices with the exptype cell type

    if exist([websitepath sl 'cells'],'dir')==0
        mkdir([websitepath sl 'cells']);
    end
    if exist([websitepath sl 'cells' sl celltype],'dir')==0
        mkdir([websitepath sl 'cells' sl celltype]);
    end
    
    fid = fopen([websitepath sl 'cells' sl celltype sl 'expcelltable.txt'],'w');
    fid2 = fopen([websitepath sl 'cells' sl celltype sl 'ephystable.txt'],'w'); 
    if isfield(DetailedData,'TableData') && ~isempty(DetailedData.TableData)
        for p=1:length(DetailedData.TableData)
            myvals = [];
            for z=1:length(othercellsidx)
                load([mypath sl 'data' sl 'DetailedData' sl AllCells(othercellsidx(z)).DetailedData '.mat']);
                eval(['otraDetailedData = ' AllCells(othercellsidx(z)).DetailedData ';']);
                
                try
                    myvals(z) = otraDetailedData.TableData(p).Mean;
    %                 myvals(z) = AllCells(othercellsidx(z)).TableData(p).Mean;
                catch
                    myvals(z) = NaN;
                end
            end
            if ~isempty(myvals) && sum(isnan(myvals))<length(myvals)
                TmpMean = mean(myvals(~isnan(myvals)));
                TmpStd = std(myvals(~isnan(myvals)));
                TmpDiff = 100*(DetailedData.TableData(p).Mean - TmpMean)/TmpMean;
            else
                TmpMean = NaN;
                TmpStd = NaN;
                TmpDiff = NaN;
            end
            fprintf(fid,'%s,%0.1f%s%0.1f,%s,%s\n',DetailedData.TableData(p).Name,TmpMean,'&plusmn;',TmpStd,DetailedData.TableData(p).Units,DetailedData.TableData(p).Desc);
            fprintf(fid2,'%s,%0.1f,%+.1f%%,%s,%s\n',DetailedData.TableData(p).Name,DetailedData.TableData(p).Mean,TmpDiff,DetailedData.TableData(p).Units,DetailedData.TableData(p).Desc);
        end
    else
        disp(celltype)
    end
    fclose(fid);
    fclose(fid2);

    mydata = eval(['explot_FiringRate(' num2str(handles.indices(h)) ',-1)']);
    xdata = sprintf('%0.4f,',mydata.x);
    ydata = sprintf('%0.4f,',mydata.y);
    fprintf(fired,'%s,%s\n%s,%s\n',celltype, xdata(1:end-1) , celltype, ydata(1:end-1));
    for c=2:length(handles.cellproperties)
        plotType = handles.cellproperties{c};
        try
            mydata = eval(['explot_' plotType(isspace(plotType)==0) '(' num2str(handles.indices(h)) ',-1)']);
            fid = fopen([websitepath sl 'cells' sl celltype sl strrep(plotType,' ','_') '.dat'],'w');
            myidx = isnan(mydata.y)==0;
            xdata = sprintf('%0.4f,',mydata.x(myidx));
            ydata = sprintf('%0.4f,',mydata.y(myidx));
            fprintf(fid,'%s,%s\n%s,%s\n',mydata.xheader, xdata(1:end-1) , mydata.yheader, ydata(1:end-1));
            % Find experimental cells and print them too

            for z=1:length(othercellsidx)
                newstrstuff = num2str(othercellsidx(z)) ; % not really handles.indices(h), gotta find the indices for the experimental cells of this type
                othercells(z).data = eval(['explot_' plotType(isspace(plotType)==0) '(' newstrstuff ',-1)']);
                myidx = isnan(othercells(z).data.y)==0;
                otherdata.x = sprintf('%0.4f,', othercells(z).data.x(myidx));
                otherdata.y = sprintf('%0.4f,', othercells(z).data.y(myidx));
                fprintf(fid,'%s,%s\n%s,%s\n',AllCells(othercellsidx(z)).CellName, otherdata.x(1:end-1),AllCells(othercellsidx(z)).CellName, otherdata.y(1:end-1));
            end
            % end
            fclose(fid);
        catch ME
            msgbox(ME.message)
        end
    end
end
fclose(fired);