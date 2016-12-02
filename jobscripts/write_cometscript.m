function write_stampedescript(fid,fid2,jobtype,handles,m)
global RunArray
ind = handles.curses.ind;

fprintf(fid, '#!/bin/bash\n');
fprintf(fid, '#SBATCH --job-name="%s"\n', RunArray(ind).RunName);
fprintf(fid, '#SBATCH --output="./jobscripts/%s.%%N.o"\n', RunArray(ind).RunName); % Direct job output to < output_file >.
fprintf(fid, '#SBATCH --partition=%s\n', jobtype.queue);
fprintf(fid, '#SBATCH --nodes %g\n', jobtype.nodes);
fprintf(fid, '#SBATCH --ntasks-per-node=%g\n',handles.machines(m).CoresPerNode);
fprintf(fid, '#SBATCH --export=ALL\n');
fprintf(fid, '#SBATCH -t %s\n', jobtype.runtime); % hh:mm:ss
fprintf(fid, 'set -x\n'); % # Echo commands, use "set echo" with csh

%fprintf(fid, 'ibrun tacc_affinity x86_64/special -mpi ./jobscripts/%s_run.hoc\n', RunArray(ind).RunName); % Run the hoc program file
fprintf(fid, 'ibrun -v x86_64/special -mpi ./jobscripts/%s_run.hoc\n', RunArray(ind).RunName); % Run the hoc program file


%fprintf(fid2, '#!/bin/csh\n')
%fprintf(fid2, 'x86_64/special -mpi -c ''strdef RunName'' -c ''RunName="%s"'' %s %s.hoc\n', RunArray(ind).RunName, jobtype.options, jobtype.program); % Run the hoc program file

fprintf(fid2, '%s\n', jobtype.options{:});
fprintf(fid2, '{load_file("./main.hoc")}\n');
fprintf(fid, 'cp ./jobscripts/%s* ./results/%s/\n', RunArray(ind).RunName, RunArray(ind).RunName); % Direct job output to < output_file >.
