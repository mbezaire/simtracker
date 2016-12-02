
function cmdstr=cygwin(cmdstr)

cmdstr=strrep(strrep(cmdstr,'\','/'),'C:','/cygdrive/c');
% if ispc
%     system(strrep(strrep(cmdstr,'\','/'),'C:','/cygdrive/c'));
% else
%     system(cmdstr);
% end
