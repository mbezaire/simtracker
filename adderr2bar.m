function mm=adderr2bar(h,mu,sigma)
b=get(h,'children');
mm=[];
if iscell(b)
    for t=1:length(b)
        z=get(b{t},'xdata');
        mm(t,:) = mean(z(2:3,:));
    end
else
    for t=1:length(b)
        z=get(b(t),'xdata');
        mm(t,:) = mean(z(2:3,:));
    end
end
errorbar(mm',mu,sigma,'.','Color','k');
