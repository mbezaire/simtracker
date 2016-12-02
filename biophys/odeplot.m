function status = odeplot(t,y,flag,varargin)
%ODEPLOT  Time series ODE output function.
%   When the function odeplot is passed to an ODE solver as the 'OutputFcn'
%   property, i.e. options = odeset('OutputFcn',@odeplot), the solver calls 
%   ODEPLOT(T,Y,'') after every timestep.  The ODEPLOT function plots all 
%   components of the solution it is passed as it is computed, adapting
%   the axis limits of the plot dynamically.  To plot only particular
%   components, specify their indices in the 'OutputSel' property passed to
%   the ODE solver.  ODEPLOT is the default output function of the
%   solvers when they are called with no output arguments.
%   
%   At the start of integration, a solver calls ODEPLOT(TSPAN,Y0,'init') to
%   initialize the output function.  After each integration step to new time
%   point T with solution vector Y the solver calls STATUS = ODEPLOT(T,Y,'').
%   If the solver's 'Refine' property is greater than one (see ODESET), then
%   T is a column vector containing all new output times and Y is an array
%   comprised of corresponding column vectors.  The STATUS return value is 1
%   if the STOP button has been pressed and 0 otherwise.  When the
%   integration is complete, the solver calls ODEPLOT([],[],'done').
%
%   See also ODEPHAS2, ODEPHAS3, ODEPRINT, ODE45, ODE15S, ODESET.

%   Mark W. Reichelt and Lawrence F. Shampine, 3-24-94
%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 1.25.4.5 $  $Date: 2006/10/02 16:32:26 $

persistent TARGET_FIGURE TARGET_AXIS

status = 0;                             % Assume stop button wasn't pushed.
chunk = 128;                            % Memory is allocated in chunks.

if nargin < 3 || isempty(flag) % odeplot(t,y) [v5 syntax] or odeplot(t,y,'')
                               
    if (isempty(TARGET_FIGURE) || isempty(TARGET_AXIS))
        
        error('MATLAB:odeplot:NotCalledWithInit', ...
              'ODEPLOT has not been initialized. Use syntax ODEPLOT(tspan,y0,''init'').');
        
    elseif (ishandle(TARGET_FIGURE) && ishandle(TARGET_AXIS))  % figure still open
        
        try 
            ud = get(TARGET_FIGURE,'UserData');
            % Append t and y to ud.t and ud.y, allocating if necessary.
            nt = length(t);
            chunk = max(chunk,nt);
            [rows,cols] = size(ud.y);
            oldi = ud.i;
            newi = oldi + nt;
            if newi > rows
                ud.t = [ud.t; zeros(chunk,1)];
                ud.y = [ud.y; zeros(chunk,cols)];
            end
            ud.t(oldi+1:newi) = t;
            ud.y(oldi+1:newi,:) = y.';
            ud.i = newi;
            set(TARGET_FIGURE,'UserData',ud);
            
            if ud.stop == 1                       % Has stop button been pushed?
                status = 1;
            else
                % Rather than redraw all of the data every timestep, we will simply move
                % the line segments for the new data, not erasing.  But if the data has
                % moved out of the axis range, we redraw everything.         
                ylim = get(TARGET_AXIS,'ylim');    
                
                % Replot everything if out of axis range or if just initialized.
                if (oldi == 1) || (min(y(:)) < ylim(1)) || (ylim(2) < max(y(:)))
                    for j = 1:cols
                        set(ud.lines(j),'Xdata',ud.t(1:newi),'Ydata',ud.y(1:newi,j));
                    end
                else
                    % Plot only the new data.
                    for j = 1:cols
                        set(ud.line(j),'Xdata',ud.t(oldi:newi),'Ydata',ud.y(oldi:newi,j));
                    end
                end
            end
            
        catch
            err = lasterror();
            error('MATLAB:odeplot:ErrorUpdatingWindow',...
                  'Error updating the ODEPLOT window. solution data may have been corrupted. %s',...
                  err.message);
        end
    end   
  
else
    
    switch(flag)
      case 'init'                           % odeplot(tspan,y0,'init')        
        ud = [];
        cols = length(y);
        ud.t = zeros(chunk,1);
        ud.y = zeros(chunk,cols);
        ud.i = 1;
        ud.t(1) = t(1);
        ud.y(1,:) = y.';
        
        % Rather than redraw all data at every timestep, we will simply move
        % the last line segment along, not erasing it.
        f = figure(gcf);
        
        TARGET_FIGURE = f;
        TARGET_AXIS = gca;
        
        if ~ishold
            ud.lines = plot(ud.t(1),ud.y(1,:),'-');
            hold on
            ud.line = plot(ud.t(1),ud.y(1,:),'-','EraseMode','none');
            hold off
            set(TARGET_AXIS,'XLim',[min(t) max(t)]);            
        else
            ud.lines = plot(ud.t(1),ud.y(1,:),'-','EraseMode','none');
            ud.line = plot(ud.t(1),ud.y(1,:),'-','EraseMode','none');
        end
        
        % The STOP button.
        h = findobj(f,'Tag','stop');
        if isempty(h)
            ud.stop = 0;
            pos = get(0,'DefaultUicontrolPosition');
            pos(1) = pos(1) - 15;            
            pos(2) = pos(2) - 15;            
            uicontrol( ...
                'Style','pushbutton', ...
                'String','Stop', ...
                'Position',pos, ...
                'Callback',@StopButtonCallback, ...
                'Tag','stop');
        else
            set(h,'Visible','on');            % make sure it's visible
            if ishold
                oud = get(f,'UserData');
                ud.stop = oud.stop;             % don't change old ud.stop status
            else
                ud.stop = 0;
            end
        end
        set(f,'UserData',ud);
        
      case 'done'                           % odeplot([],[],'done')
        
        f = TARGET_FIGURE;
        TARGET_FIGURE = [];
        ta = TARGET_AXIS;
        TARGET_AXIS = [];
        
        if ishandle(f)
            ud = get(f,'UserData');
            ud.t = ud.t(1:ud.i);
            ud.y = ud.y(1:ud.i,:);
            set(f,'UserData',ud);
            cols = size(ud.y,2);
            for j = 1:cols
                set(ud.lines(j),'Xdata',ud.t,'Ydata',ud.y(:,j));
            end
            if ~ishold
                set(findobj(f,'Tag','stop'),'Visible','off');
                
                if ishandle(ta)
                    set(TARGET_AXIS,'XLimMode','auto');
                end
                
                refresh;                          % redraw figure to remove marker frags
            end
        end
        
    end
end

drawnow;

end  % odeplot


% --------------------------------------------------------------------------
% Sub-function
%

function StopButtonCallback(src,eventdata)
    ud = get(gcbf,'UserData'); 
    ud.stop = 1; 
    set(gcbf,'UserData',ud);    
end  % StopButtonCallback

% --------------------------------------------------------------------------
