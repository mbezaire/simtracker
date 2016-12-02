fprintf(fid, '#!/bin/bash\n');
fprintf(fid, '#PBS -q normal\n');
fprintf(fid, '#PBS -A uci112\n');
fprintf(fid, '#PBS -l nodes=%g:ppn=%g\n',round(jobtype.cores/handles.machines(m).CoresPerNode) , handles.machines(m).CoresPerNode);
fprintf(fid, '#PBS -l walltime=%s\n', jobtype.runtime);
fprintf(fid, '#PBS -o ./jobscripts/$PBS_JOBNAME.$PBS_JOBID.o\n');
fprintf(fid, '#PBS -N %s\n', RunArray(ind).RunName);
fprintf(fid, '#PBS -V\n');

fprintf(fid, 'cd $PBS_O_WORKDIR\n');
fprintf(fid, 'mpirun -np %g -hostfile $PBS_NODEFILE nrniv -mpi ./jobscripts/%s_run.hoc\n', jobtype.cores, RunArray(ind).RunName);
fprintf(fid, 'cp ./jobscripts/$PBS_JOBNAME.$PBS_JOBID.o results/%s/\n', RunArray(ind).RunName);

fprintf(fid2, '%s\n', jobtype.options{:});
fprintf(fid2, '{load_file("./ca1.hoc")}\n');