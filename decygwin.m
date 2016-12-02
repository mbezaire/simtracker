function cmdstr=decygwin(cmdstr)
cmdstr=strrep(strrep(cmdstr,'/','\'),'/cygdrive/c','C:');
