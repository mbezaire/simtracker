function [pos_x, pos_y]=testy()

pos_x=0;
pos_y=0;

myvars.xmin=-50;
myvars.xmax=50;
myvars.ymin=-50;
myvars.ymax=50;
h2=figure('Color','w','Name','Plot Path','Toolbar','none','Menubar','none','Numbertitle','off','Units','inches','Position',[.5 .5 4 5],'resize','off');
mm=gca;
set(mm,'Units','normalized','Position',[.15 .05 .7 .7])
axis equal tight
xlim([myvars.xmin myvars.xmax])
ylim([myvars.ymin myvars.ymax])
title('Enclosure')
xlabel('X dimension (cm)')
ylabel('Y dimension (cm)')
hold(mm,'on')

%,'Callback', @setmap);
gtxt=uicontrol('Style', 'text','String', '1. Enter time between clicks (s) and temporal resolution of path definition (s)','HorizontalAlignment','left','BackgroundColor','w','Units','normalized','Position', [.1 .91 .7 .08]); % Directions  '1. Enter time between clicks (s) and temporal resolution of path definition (s)'
gspd=uicontrol('Style', 'edit','String', '0.5','HorizontalAlignment','right','Units','normalized','Position', [.1 .86 .1 .04],'Callback', @recalc); % edit speed
grez=uicontrol('Style', 'edit','String', '0.001','HorizontalAlignment','right','Units','normalized','Position', [.25 .86 .1 .04],'Callback', @recalc); % edit resolution
gtxt=uicontrol('Style', 'text','String', '2. Click where the animal is at each time step and push enter when done','HorizontalAlignment','left','BackgroundColor','w','Units','normalized','Position', [.1 .76 .7 .08]); % Directions  '1. Enter time between clicks (s) and temporal resolution of path definition (s)'


mylines=[];
myx=[];
myy=[];
while 1==1
    [tmyx, tmyy, button]=ginput(1);
    if isempty(tmyx) || isempty(button) || button>1
        break
    end
    
    tmyx=max(min(tmyx,myvars.xmax),myvars.xmin);
    tmyy=max(min(tmyy,myvars.ymax),myvars.ymin);
    
    if ~isempty(myx)
        mylines(length(mylines)+1)=plot([myx(end) tmyx],[myy(end) tmyy],'k','Marker','.');
    else
        mylines(length(mylines)+1)=plot(tmyx,tmyy,'k','Marker','.');
    end
    myx=[myx; tmyx];
    myy=[myy; tmyy];
end

timestep=str2num(get(gspd,'String'));
timerez=str2num(get(grez,'String'));

dist=sum((diff(myx).^2+diff(myy).^2).^(1/2));
time=(length(myx)-1)*timestep;

gtxt=uicontrol('Style', 'text','String', ['Mouse ran ' sprintf('%.1f',dist) ' cm in ' sprintf('%.1f',time) ' s at a velocity of ' sprintf('%.1f',dist/time) ' cm/s.'],'HorizontalAlignment','left','BackgroundColor','w','Units','normalized','Position', [.1 .72 .7 .04]); % Directions  '1. Enter time between clicks (s) and temporal resolution of path definition (s)'

grdo=uicontrol('Style', 'pushbutton','String', 'Redraw','HorizontalAlignment','right','Units','normalized','Position', [.45 .86 .15 .04],'Callback', @redopath); % edit resolution
gsav=uicontrol('Style', 'pushbutton','String', 'Save','HorizontalAlignment','right','Units','normalized','Position', [.65 .86 .15 .04],'Callback', @savepath); % edit resolution

uiwait(h2)
%     if abs(pos)>50
%         pos=pos - pos/abs(pos)*(abs(pos)-50);
%     end

function recalc(varargin)
    timestep=str2num(get(gspd,'String'));
    timerez=str2num(get(grez,'String'));

    dist=sum((diff(myx).^2+diff(myy).^2).^(1/2));
    time=(length(myx)-1)*timestep;

    gtxt=uicontrol('Style', 'text','String', ['Mouse ran ' sprintf('%.1f',dist) ' cm in ' sprintf('%.1f',time) ' s at a velocity of ' sprintf('%.1f',dist/time) ' cm/s.'],'HorizontalAlignment','left','BackgroundColor','w','Units','normalized','Position', [.1 .72 .7 .04]); % Directions  '1. Enter time between clicks (s) and temporal resolution of path definition (s)'
end

function redopath(varargin)
    delete(mylines)
    mylines=[];
    myx=[];
    myy=[];
    while 1==1
        [tmyx, tmyy, button]=ginput(1);
        if isempty(tmyx) || isempty(button) || button>1
            break
        end

        tmyx=max(min(tmyx,myvars.xmax),myvars.xmin);
        tmyy=max(min(tmyy,myvars.ymax),myvars.ymin);

        if ~isempty(myx)
            mylines(length(mylines)+1)=plot([myx(end) tmyx],[myy(end) tmyy],'k','Marker','.');
        else
            mylines(length(mylines)+1)=plot(tmyx,tmyy,'k','Marker','.');
        end
        myx=[myx; tmyx];
        myy=[myy; tmyy];
    end

    timestep=str2num(get(gspd,'String'));
    timerez=str2num(get(grez,'String'));

    dist=sum((diff(myx).^2+diff(myy).^2).^(1/2));
    time=(length(myx)-1)*timestep;

    set(gtxt,'String', ['Mouse ran ' sprintf('%.1f',dist) ' cm in ' sprintf('%.1f',time) ' s at a velocity of ' sprintf('%.1f',dist/time) ' cm/s.']); % Directions  '1. Enter time between clicks (s) and temporal resolution of path definition (s)'
end


function savepath(varargin)
    pos_x=myx;
    pos_y=myy;
    
    close(h2)
end
end