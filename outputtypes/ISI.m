for r=[1 3:length(cells)];
% idx=find(spikerast(:,2)>=cells(r).range_st & spikerast(:,2)<=cells(r).range_en);
% typerast=spikerast(idx,:);
% typerast=sortrows(typerast,[1 2]);
% ISI=diff(typerast(:,1));
% figure;
% subplot(2,1,1);
% hist(ISI);title(cells(r).name)

    myISI=[];
    for k=cells(r).range_st:cells(r).range_en
        idx=find(spikerast(:,2)==k);
        typerast=spikerast(idx,:);
        typerast=sortrows(typerast,[1 2]);
        ISItmp=diff(typerast(:,1));
        myISI=[myISI; ISItmp];
    end
    figure;hist(myISI,[0:50:max(myISI)]);title(cells(r).name) 
end   
    

