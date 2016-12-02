function write_trestlesscript(fid,fid2,jobtype,handles,m)
global RunArray
ind = handles.curses.ind;

fprintf(fid, '#!/bin/bash\n');
fprintf(fid, '#PBS -q normal\n');
fprintf(fid, '#PBS -A %s\n', jobtype.allocation);
fprintf(fid, '#PBS -l nodes=%g:ppn=%g\n',ceil(jobtype.cores/handles.machines(m).CoresPerNode) , handles.machines(m).CoresPerNode);
fprintf(fid, '#PBS -l walltime=%s\n', jobtype.runtime);
fprintf(fid, '#PBS -k oe\n');
fprintf(fid, '#PBS -e ./jobscripts/$PBS_JOBNAME.$PBS_JOBID.e\n');
fprintf(fid, '#PBS -o ./jobscripts/$PBS_JOBNAME.$PBS_JOBID.o\n');
fprintf(fid, '#PBS -N %s\n', RunArray(ind).RunName);
fprintf(fid, '#PBS -V\n');

fprintf(fid, 'cd $PBS_O_WORKDIR\n');
fprintf(fid, 'mpirun --mca btl_openib_receive_queues S,65536,128 --mca coll_sync_barrier_before 100 -np %g -hostfile $PBS_NODEFILE nrniv -mpi ./jobscripts/%s_run.hoc\n', jobtype.cores, RunArray(ind).RunName);
%fprintf(fid, 'cp %s/jobscripts/$PBS_JOBNAME.$PBS_JOBID.o %s/results/%s/\n', jobtype.repos, jobtype.repos, RunArray(ind).RunName);
%fprintf(fid, 'cp %s/jobscripts/$PBS_JOBNAME.$PBS_JOBID.e %s/results/%s/\n', jobtype.repos, jobtype.repos, RunArray(ind).RunName);

fprintf(fid2, '%s\n', jobtype.options{:});
fprintf(fid2, '{load_file("./main.hoc")}\n');
fprintf(fid, 'cp /home/case/%s* ./results/%s/\n', RunArray(ind).RunName, RunArray(ind).RunName); % Direct job output to < output_file >.
