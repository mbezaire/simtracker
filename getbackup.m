function backupfolder = getbackup(mydir)
global sl

idx=findstr(mydir,sl);
rootfolder=mydir(1:idx(end)-1);

if exist([rootfolder sl 'backup'],'dir')==0
    mkdir([rootfolder sl 'backup'])
end
backupfolder=[rootfolder sl 'backup'];
