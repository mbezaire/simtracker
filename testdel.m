myidx=1;

rowstart=row(myidx);
rowprev=row(myidx);

resultmat=[];
mylen=size(resultmat,1)+1;
resultmat(mylen,1)=rowstart;
if length(row)==1
    resultmat(mylen,2)=rowstart;
else
    for r=2:length(row)
        if r==length(row)
            if row(r)==rowprev+1
                rowprev=row(r);
                resultmat(mylen,2)=rowprev;
            else
                resultmat(mylen,2)=rowprev;
                mylen=size(resultmat,1)+1;
                resultmat(mylen,1)=row(r);
                resultmat(mylen,2)=row(r);
            end
        elseif row(r)==rowprev+1
            rowprev=row(r);
        else
            resultmat(mylen,2)=rowprev;

            rowstart=row(r);
            rowprev=row(r);

            mylen=size(resultmat,1)+1;
            resultmat(mylen,1)=rowstart;
        end
    end
end
