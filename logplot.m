function logplot(repos,myresultsfolder,x,y,legendentry,axistitle,xlabelstr,ylabelstr,figname)
global sl cellfigdata

r=1;
k=1;
m=1;
if ~isempty(cellfigdata) %exist('cellfigdata','var')
    [r, newflag]=geti({cellfigdata.fig(:).name},figname);
    if ~newflag
        [k, newflag]=geti({cellfigdata.fig(r).axis(:).name},axistitle);
        if ~newflag
            [m, ~]=geti({cellfigdata.fig(r).axis(k).data(:).name},legendentry);
        end
    end
end

if size(x,2)>1
    x=x';
end
if size(y,2)>1
    y=y';
end

%cellfigdata.fig.axis.data

cellfigdata.fig(r).name = figname;
cellfigdata.fig(r).axis(k).name = axistitle;
cellfigdata.fig(r).axis(k).xlabel = xlabelstr;
cellfigdata.fig(r).axis(k).ylabel = ylabelstr;
cellfigdata.fig(r).axis(k).data(m).name = legendentry;
cellfigdata.fig(r).axis(k).data(m).x = x;
cellfigdata.fig(r).axis(k).data(m).y = y;



function [myi newflag]=geti(allnames,myname)
b=find(strcmp(allnames,myname)==1);
if isempty(b)
    myi = length(allnames)+1;
    newflag=1;
else
    myi=b;
    newflag=0;
end
