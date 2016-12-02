fid = fopen('/home/casem/repos/ca1/cells/synlist.dat','r');                
syndata = textscan(fid,'%s %s %f %s\n') ;
fclose(fid);

mydend={};
precell={'ca3cell','eccell'};
postcell='pyramidalcell';
for t=1:length(precell)
    fid = fopen(['/home/casem/repos/ca1/autorig_results/079/' precell{t} '.pyramidalcell.sids.dat'],'r');                
    numlines = fscanf(fid,'%d\n',1) ;
    filedata = textscan(fid,'%f %f\n') ;
    fclose(fid);

    idx1=strmatch(precell{t},syndata{2});
    idx2=strmatch(postcell,syndata{1});
    subidx = intersect(idx1,idx2);
    for r=1:numlines
        syn = filedata{2}(r);
        idx = find(syndata{3}(subidx)==syn);
        mydend{r} = syndata{4}{subidx(idx)};
        i = strfind(mydend{r},'.');
        mydend{r}=mydend{r}(i+1:end);
    end
    fid = fopen(['/home/casem/repos/ca1/autorig_results/079/' precell{t} '.' postcell '.sids.dat'],'w');  

    % write
    fprintf(fid, '%g\n', numlines);
    for r=1:numlines
        fprintf(fid, '%g %g %s\n', filedata{1}(r), filedata{2}(r), mydend{r});
    end
    fclose(fid);
end

