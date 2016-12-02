fprintf(fid, '#!/bin/bash\n');
fprintf(fid, '#\n');
fprintf(fid, '#$ -q %s\n', jobtype.queue);
fprintf(fid, '#$ -pe openmp %g\n', jobtype.cores);
fprintf(fid, '#$ -cwd\n'); % Use current working directory as the job's directory
fprintf(fid, '#$ -j y\n');
fprintf(fid, '#$ -S /bin/bash\n');
fprintf(fid, '#$ -N %s\n', RunArray(ind).RunName);
fprintf(fid, '#$ -o ./jobscripts/%s.$JOB_ID.o\n', RunArray(ind).RunName); % Direct job output to < output_file >.
fprintf(fid, '#$ -M %s\n', jobtype.email);
fprintf(fid, '#$ -m eas\n'); % jobtype.notifications
fprintf(fid, '#$ -R y\n\n'); % reserve job nodes
fprintf(fid, 'module load neuron/7.3\n'); % This will also load mpi
fprintf(fid, 'mpiexec -np %g nrniv -mpi -nobanner -nogui ./jobscripts/%s_run.hoc\n', jobtype.cores, RunArray(ind).RunName); % Run the hoc program file
fprintf(fid, 'cp ./jobscripts/%s.$JOB_ID.o results/%s/\n', RunArray(ind).RunName, RunArray(ind).RunName);

fprintf(fid2, '%s\n', jobtype.options{:});
fprintf(fid2, '{load_file("./ca1.hoc")}\n');
