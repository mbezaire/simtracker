% intro
%rat=imread('/home/casem/Desktop/Dropbox/3dDG/rat.jpg');
%image(rat)
% getframe
%  82.5000   98.0000    1.5000


numcells = cells(3).range_en-cells(3).range_st+1;
stp = 10; % RunArray(ind).SimDuration

param=0;

if param==1
    tmp = (numcells/15)^.5;
    side1 = round(tmp); 
    tmp = numcells/side1;
    side2 = ceil(tmp);
else
    tmp = (numcells/6)^.5;
    side1 = round(tmp/10)*10;
    tmp = numcells/side1;
    side2 = ceil(tmp);
end

%longside=floor((numcells)/10);
x=[];
y=[];
u=[];
v=[];
ulin=[];
vlin=[];
for m=cells(3).range_st:cells(3).range_en
    if param==1
        ulin=linspace(0.5/8*pi,9/8*pi,side2);
        vlin=linspace(pi*4/2,pi*5/2,side1);
        [u, v]=meshgrid(ulin,vlin);
        c=9;
        decay=.45;
        zsteep=2;
        ztwirl=12;
        wtwo=1;
        x=(c-wtwo*sin(u)+cos(v-decay*(pi-u))).*cos(u)*.8;
        y=((c-wtwo*sin(u)+cos(v-decay*(pi-u))).*sin(u))*.8;
        z=(zsteep*sin(v-decay*(pi-u))-ztwirl*cos(u))/2;
    else
        u(m-cells(3).range_st+1) = floor((m - cells(3).range_st)/side1);
        v(m-cells(3).range_st+1) = mod(m - cells(3).range_st,side1);
        x(m-cells(3).range_st+1) = u(m-cells(3).range_st+1);
        y(m-cells(3).range_st+1) = v(m-cells(3).range_st+1);
    end
    

end

pyrcellsi=find(spikerast(:,2)>=cells(3).range_st & spikerast(:,2)<=cells(3).range_en);
pyrrast=spikerast(pyrcellsi,:);

j=1;
hf=figure('Color','w');
bins = 0:stp:1000-stp;
N = hist(pyrrast(:,1),bins+stp/2);
for t=bins
    idx = find(pyrrast(:,1)>=t & pyrrast(:,1)<(t+stp));
    mycells = unique(pyrrast(idx,2));
    
    subplot(6,1,3)
    bar(bins,N./max(N),'EdgeColor','c','FaceColor','c')
    xlim([min(bins) 1000])
    hold on
    plot([t+stp/2 t+stp/2], [0 1],'LineWidth',2,'Color','k')
    hold off
    axis off
    
    ax=subplot(2,1,2);
    if param==1
        plot3(x,y,z,'Color','b','LineStyle','none','Marker','.','MarkerSize',15)
        hold on
        plot3(x(mycells-cells(3).range_st+1),y(mycells-cells(3).range_st+1),z(mycells-cells(3).range_st+1),'Color','c','LineStyle','none','Marker','.','MarkerSize',15)
        set(ax,'PlotBoxAspectRatio',[1.51639922300083 1 1.33578171737836],...
        'DataAspectRatio',[1 1 1],...
        'CameraViewAngle',4.03008067080835);
        xlim(ax,[-8.03679539769537 7.69123738536039]);
        ylim(ax,[-3.17385699094445 7.19810346939611]);
        zlim(ax,[-6.85474293561393 6.9999322206802]);
        view(ax,[-27.5 44]);    
    else
        plot(x,y,'LineStyle','none','Marker','.','MarkerSize',25,'Color','b')
        hold on
        plot(x(mycells-cells(3).range_st+1),y(mycells-cells(3).range_st+1),'LineStyle','none','Marker','.','MarkerSize',15,'Color','y')
        xlim([-1 side2+1])
        ylim([-1 side1+1])
        axis equal
    end
    
    axis off
    mymovie(j) = getframe(hf);
    j=j+1;
end
close
h=figure('Color','w'); movie(h,mymovie,1, 4)
% movie2avi(mymovie, 'spikes.avi', 'compression', 'None','fps',4);