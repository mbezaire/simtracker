function customizeraster(varargin)
% customizeraster(h,Line_width)
% h (optional): handle of raster figure to be customized
% Line_width (optional): thickness of lines to use (right now not used)
%
% This function contains a handy plot reference table at the bottom

Line_width=[];
if isempty(varargin)==0
    h=varargin{1};
    if length(varargin)>1
        Line_width=varargin{2};
    end
else
    h=gcf;
end
h_axes=get(h, 'Children');

% BACKGROUND COLOR of figure
set(h,'Color',[1 1 1])

   % AXES settings
for r=1:length(h_axes)
    set(h_axes(r),'FontWeight','bold',...   'PlotBoxAspectRatio', [1 1 1],  
...% AXES line settings
...%    'LineWidth',1, 'LineStyle',':',...
...% GRID LINE settings    
    'GridLineStyle',     ':',   'XGrid',     'on', 'YGrid',     'on', 'ZGrid',     'off',...
    'MinorGridLineStyle','-',   'XMinorGrid','off','YMinorGrid','off','ZMinorGrid','off',...
...% TICK settings
    'TickDir','out',...
    'XMinorTick','off','YMinorTick','off','ZMinorTick','off')

   % LABEL settings    
    set(get(h_axes(r),'XLabel'),'FontWeight','bold')
    set(get(h_axes(r),'YLabel'),'FontWeight','bold')
    set(get(h_axes(r),'Title'),'FontWeight','bold')
    
    h_axes(r);
    msgbox('This may not work right anymore: findobj line')
    h_line=findobj('Type','line');
    for k=1:length(h_line)
        
   % PLOT LINE settings        
        %set(h_line(k))%,... 'LineWidth',2,... 'Color',[1 .3 .3],...
...% PLOT MARKER settings        
%         'Marker','none','MarkerSize',6,'MarkerEdgeColor',[1 .3 .3],'MarkerFaceColor',[1 1 0])
    if isempty(Line_width)==0
%         set(h_line(k),'LineWidth',Line_width)
    end
    end
end
grid off

figure(h);
% PLOT REFERENCE SHEET:
% 
%            b     blue          .     point              -     solid
%            g     green         o     circle             :     dotted
%            r     red           x     x-mark             -.    dashdot 
%            c     cyan          +     plus               --    dashed   
%            m     magenta       *     star
%            y     yellow        s     square
%            k     black         d     diamond
%                                v     triangle (down)
%           or vector:           ^     triangle (up)
%           [r g b]              <     triangle (left)
%           where r/g/b          >     triangle (right)
%           are from 0-1         p     pentagram
%                                h     hexagram
%                                none  no marker
%
% http://www.mathworks.com/access/helpdesk/help/techdoc/ref/text_props.html