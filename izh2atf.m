function izh2atf(celltype,myresults)
global mypath sl
% write out an axoclamp file

fcells = fopen([mypath sl 'cellfiles' sl celltype '.atf'],'w');

fprintf(fcells,'ATF	1.0\n8\t85\n"AcquisitionMode=Episodic Stimulation"\n"Comment="\n"YTop=200,4000"\n"YBottom=-200,-4000"\n"SyncTimeUnits=12.5"\n"SweepStartTimesMS=0.000"\n"SignalsExported=IN 1,IN 11"\n"Signals="\t"IN 1"\t"IN 11"\n');

headstring = '"Time (s)"';
matresults = myresults(1).t(:)./1000;
formatstr = '%f';

for n=1:length(myresults)
    headstring = [headstring '\t"Trace #' num2str(n) ' (mV)"\t"Trace #' num2str(n) ' (pA)"'];
    matresults = [matresults myresults(n).v(:) myresults(n).I(:)];
    formatstr = [formatstr '\t%f\t%f'];
end

fprintf(fcells,[headstring '\n']);

%eval(['fprintf(fcells,''' formatstr '\n'',' cmdstr '.'');']);
fprintf(fcells,[formatstr '\n'], matresults');

fclose(fcells);

