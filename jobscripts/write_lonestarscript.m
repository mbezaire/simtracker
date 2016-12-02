function write_lonestarscript(fid,fid2,jobtype,handles,m)
global RunArray
ind = handles.curses.ind;

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
fprintf(fid, '#$ -m eas\n'); % when to send user notifications {b|e|a|s|n}
fprintf(fid, 'set -x\n'); % # Echo commands, use "set echo" with csh

%fprintf(fid, 'ibrun ./jobscripts/%s_run.sh\n', RunArray(ind).RunName); % Run the hoc program file
%fprintf(fid, 'ibrun ./jobscripts/%s_run.hoc\n', jobtype.cores, RunArray(ind).RunName);
fprintf(fid, 'ibrun tacc_affinity x86_64/special -mpi ./jobscripts/%s_run.hoc\n', RunArray(ind).RunName); % Run the hoc program file

%fprintf(fid, 'mv case.*.0 results/%s/\n', RunArray(ind).RunName);

fprintf(fid2, '%s\n', jobtype.options{:});
fprintf(fid2, '{load_file("./main.hoc")}\n');
fprintf(fid, 'cp ./jobscripts/%s* ./results/%s/\n', RunArray(ind).RunName, RunArray(ind).RunName); % Direct job output to < output_file >.
