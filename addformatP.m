function handles=addformatP(handles,varargin)
% handles=addformatP(handles,varargin)
% add a formatP field (struct) to the handles struct
% if a second argument is present (the GUI handle)
% then update the handles structure associated with it

    handles.formatP.textwidth=15;
    handles.formatP.plottextwidth=.1;
    handles.formatP.marg=.03/2;
    handles.formatP.st=2;
    handles.formatP.left = .065;
    handles.formatP.bottom=.065;
    handles.formatP.hmar=-.03;
    handles.formatP.colorvec={'m','k','b','r','g','y','c'};
    handles.formatP.sizevec={5,5,5,5,5,5,5,5};
    handles.formatP.figs=[];
    if ispc
        handles.curses.sl='\';
    else
        handles.curses.sl='/';
    end
    if ~isempty(varargin)
        guidata(varargin{1},handles);
    end