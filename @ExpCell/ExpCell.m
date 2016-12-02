classdef ExpCell < handle
   properties % (Hidden) (SetAccess = private)
       % displayed in list view and form view
       % we may need to move the initializations to the constructor fcn
       % (but keep the list of properties in here, obviously)
        CellType = 'none' % Name of simulation run
        CellName = 'none' % Name of simulation run
        DetailedData = ''
        FileName = 'none'
        PathToFile = ''
        MethodSet = 0
        AxoClampData = []
        SpikeData = []
        OtherData = []
        TableData = []
        NSACData = []
        Region = ''
        Experimenter = ''
        Date = []
        DataVerified = 0
        ThresholdType = 0
        ThreshCheck = -20
        ThresholdsVerified = 0
        ManuallyChanged = 0
        Analyzed = 0
        Notes = ''
        AnalysisSettings = []
        JPStatus = 0 % 0 = unknown, 1 = known
        JunctionPotential = 0
        JPCorrected = -1
        CurrentRange = ''

    end
   methods
      function BA = ExpCell(AxoClampData,MethodSet,PathToFile,FileName,CellType)
          global AllCells
         if nargin < 5
            error('ExpCell:InvalidInitialization',...
               'You must provide all 5 arguments: AxoClampData,MethodSet,PathToFile,FileName,CellType')
         end
         if exist('AllCells')==0 || strcmp(class(AllCells),'double') % double happens when the variable didn't exist and was then declared global
            AllCells=BA;
         else
            if sum(strcmp({AllCells(:).FileName},BA.FileName))>1
                newname=inputdlg('It appears that you already loaded this file.');
                BA=[];
                return;
            end
            AllCells(length(AllCells)+1)=BA;
         end
         BA.AxoClampData  = AxoClampData;
         BA.MethodSet = MethodSet;
         BA.PathToFile = PathToFile;
         BA.FileName = FileName;
         BA.CellName = strrep(strrep(strrep(strrep(FileName,'.atf',''),'.','p'),'-','m'),'_','');
         BA.CellType = CellType;
         BA.DetailedData = ['t' strrep(strrep(strrep(BA.CellName,' ',''),'(',''),')','')];
      end % ExpCell
   end % methods
end % classdef
