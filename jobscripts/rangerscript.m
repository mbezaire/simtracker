fprintf(fid, '#!/bin/bash\n');
fprintf(fid, '#$-V\n'); % Inherit the submission environment
fprintf(fid, '#$-cwd\n'); % Use current working directory as the job's directory
fprintf(fid, '#$-N %s\n', RunArray(ind).RunName);
fprintf(fid, '#$-j y\n');
fprintf(fid, '#$ -o ./jobscripts/$JOB_NAME.$JOB_ID.o\n'); % Direct job output to < output_file >.
fprintf(fid, '#$ -%s %gway %g\n', 'pe', handles.machines(m).CoresPerNode, jobtype.cores);
fprintf(fid, '#$ -q %s\n', jobtype.queue);
fprintf(fid, '#$ -l h_rt=%s\n', jobtype.runtime);
fprintf(fid, '#$ -M %s\n', jobtype.email);
fprintf(fid, '#$ -m easn\n'); % when to send user notifications {b|e|a|s|n}
fprintf(fid, 'set -x\n'); % # Echo commands, use "set echo" with csh
fprintf(fid, 'module load beta > /dev/null 2>/dev/null\n'); % must load the beta module to access mercurial
fprintf(fid, 'module load mercurial > /dev/null 2>/dev/null\n'); % must load the mercurial module to check the code version during run
fprintf(fid, 'module unload python > /dev/null 2>/dev/null\n'); % must load the mercurial module to check the code version during run

fprintf(fid, 'module load ipm\n');
fprintf(fid, 'export LD_PRELOAD=$TACC_IPM_LIB/libipm.so\n');
fprintf(fid, 'export IPM_REPORT=full\n');
fprintf(fid, 'ibrun ./jobscripts/%s_run.sh\n', RunArray(ind).RunName); % Run the hoc program file
fprintf(fid, 'mv case.*.0 results/%s/\n', RunArray(ind).RunName);

fprintf(fid2, '#!/bin/csh\n')
fprintf(fid2, 'x86_64/special -mpi -c ''strdef RunName'' -c ''RunName="%s"'' %s %s.hoc\n', RunArray(ind).RunName, jobtype.options, jobtype.program); % Run the hoc program file