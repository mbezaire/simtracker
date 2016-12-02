function write_bluewscript(fid,fid2,jobtype,handles,m)
global RunArray
ind = handles.curses.ind;

fprintf(fid, '#!/bin/bash\n');
fprintf(fid, '### set the number of nodes and the number of PEs per node\n');                               
fprintf(fid, '#PBS -q %s\n', jobtype.queue);
fprintf(fid, '#PBS -l nodes=%g:ppn=%g:xe\n', jobtype.nodes, handles.machines(m).CoresPerNode);                                                              
fprintf(fid, '### set the wallclock time\n');                                                               
fprintf(fid, '#PBS -l walltime=%s\n', jobtype.runtime);                                                                
fprintf(fid, '### set the job name\n');                                                                     
fprintf(fid, '#PBS -N %s\n', RunArray(ind).RunName);
fprintf(fid, '### set the job stdout and stderr\n');                                                        
fprintf(fid, '#PBS -e ./results/$PBS_JOBID.err\n');                                                         
fprintf(fid, '#PBS -o ./results/$PBS_JOBID.out\n');                                                         
fprintf(fid, '### set email notification\n');                                                               
fprintf(fid, '##PBS -m bea\n');                                                                             
fprintf(fid, '### Set umask so users in my group can read job stdout and stderr files\n');                  
fprintf(fid, '#PBS -W umask=0027\n');                                                                       

fprintf(fid, 'module swap PrgEnv-cray PrgEnv-intel\n');

fprintf(fid, 'set -x\n');
fprintf(fid, '## go to directory from where job script was launched\n');
fprintf(fid, 'cd $PBS_O_WORKDIR\n');

fprintf(fid, 'aprun -n %g ./x86_64/special -mpi jobscripts/%s_run.hoc -c "quit()"\n', jobtype.cores, RunArray(ind).RunName);

fprintf(fid2, '%s\n', jobtype.options{:});
fprintf(fid2, '{load_file("./main.hoc")}\n');
fprintf(fid, 'cp ./jobscripts/%s* ./results/%s/\n', RunArray(ind).RunName, RunArray(ind).RunName); % Direct job output to < output_file >.
