fid = fopen('/home/casem/repos/ca1/cells/synlist.dat','r');                
syndata = textscan(fid,'%s %s %f %s\n') ;
fclose(fid);

mydend={};
precell={'ca3cell','eccell'};
postcell='pyramidalcell';
for t=2:length(precell)
    fid = fopen(['/home/casem/repos/ca1/autorig_results/079/' precell{t} '.' postcell '.sids.dat'],'w');  

    
    rst=35;
    ren=45;
    % write
    fprintf(fid, '%g\n', ren-rst+1);
    for r=rst:ren
        fprintf(fid, '%g %g apical[%g]\n', r, r, r);
    end
    fclose(fid);
end

