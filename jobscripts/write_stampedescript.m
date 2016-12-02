function write_stampedescript(fid,fid2,jobtype,handles,m)
global RunArray
ind = handles.curses.ind;

fprintf(fid, '#!/bin/bash\n');
%fprintf(fid, '#SBATCH-V\n'); % Inherit the submission environment
%fprintf(fid, '#SBATCH-cwd\n'); % Use current working directory as the job's directory
fprintf(fid, '#SBATCH -J %s\n', RunArray(ind).RunName);
if ~isempty(jobtype.allocation), fprintf(fid, '#SBATCH -A %s\n', jobtype.allocation); end
%fprintf(fid, '#SBATCH-j y\n'); % Join stderr output with the file specified by the -o option. (Don't also use the -e option.)
fprintf(fid, '#SBATCH -o ./jobscripts/%s.%%j.o\n', RunArray(ind).RunName); % Direct job output to < output_file >.
fprintf(fid, '#SBATCH -n %g\n', jobtype.cores);
%fprintf(fid, '#SBATCH -%s %gway %g\n', 'pe', handles.machines(m).CoresPerNode, jobtype.cores);
if ~isempty(jobtype.queue), fprintf(fid, '#SBATCH -p %s\n', jobtype.queue); end
fprintf(fid, '#SBATCH -t %s\n', jobtype.runtime); % hh:mm:ss
if ~isempty(jobtype.email), fprintf(fid, '#SBATCH --mail-user=%s\n', jobtype.email); end
fprintf(fid, '#SBATCH --mail-type=END\n'); % when to send user notifications {BEGIN|END|FAIL|ALL}
fprintf(fid, '#SBATCH --mail-type=BEGIN\n'); % when to send user notifications {BEGIN|END|FAIL|ALL}
fprintf(fid, 'set -x\n'); % # Echo commands, use "set echo" with csh

%fprintf(fid, 'ibrun tacc_affinity ./jobscripts/%s_run.sh\n', RunArray(ind).RunName); % Run the hoc program file
fprintf(fid, 'ibrun tacc_affinity x86_64/special -mpi ./jobscripts/%s_run.hoc\n', RunArray(ind).RunName); % Run the hoc program file


%fprintf(fid2, '#!/bin/csh\n')
%fprintf(fid2, 'x86_64/special -mpi -c ''strdef RunName'' -c ''RunName="%s"'' %s %s.hoc\n', RunArray(ind).RunName, jobtype.options, jobtype.program); % Run the hoc program file

fprintf(fid2, '%s\n', jobtype.options{:});
fprintf(fid2, '{load_file("./main.hoc")}\n');
fprintf(fid, 'cp ./jobscripts/%s* ./results/%s/\n', RunArray(ind).RunName, RunArray(ind).RunName); % Direct job output to < output_file >.
