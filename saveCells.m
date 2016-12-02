 function saveCells(handles,varargin)
global mypath AllCells DetailedData

if ~isempty(handles.viewother)
    return
end

if ispc
    sl='\';
else
    sl='/';
end
if handles.ind>length(AllCells)
    handles.ind=length(AllCells);
end
if 1==0
    if ~isempty(handles.ind) && ~isempty(DetailedData)
        eval([AllCells(handles.ind).DetailedData ' = DetailedData;'])
        save([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.ind).DetailedData '.mat'],AllCells(handles.ind).DetailedData,'-v7.3')
    end
end

%handles.viewother='';
if ~isempty(AllCells)
    if ~isempty(varargin)
        if length(varargin)>1
            ArchivedCells=AllCells(varargin{2});
            save(varargin{1}, 'ArchivedCells', '-v7.3');
            for m=1:length(ArchivedCells)
                load([mypath sl 'data' sl 'DetailedData' sl ArchivedCells(m).DetailedData '.mat'],ArchivedCells(m).DetailedData)
                save(varargin{1}, ArchivedCells(m).DetailedData, '-append')
            end
        else
            save(varargin{1}, 'AllCells', '-v7.3');
            for m=1:length(AllCells)
                load([mypath sl 'data' sl 'DetailedData' sl AllCells(m).DetailedData '.mat'],AllCells(m).DetailedData)
                save(varargin{1}, AllCells(m).DetailedData, '-append')
            end
        end
    elseif ~isempty(handles.viewother)
        save(handles.viewother, 'AllCells', '-v7.3');
    else
        save([mypath sl 'data' sl 'AllCellsData.mat'], 'AllCells', '-v7.3');
    end
%     tmp=load(['AllCellsData.mat']);
% 
%     if ~isa(tmp.AllCells,'ExpCell')
%         msgbox({'THE FILE WAS NOT SAVED PROPERLY',' ','    AllCellsData.mat',})
%     end
end

