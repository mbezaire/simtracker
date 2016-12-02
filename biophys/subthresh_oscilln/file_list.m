function c = file_list(typ)
  if nargin < 1, typ = 'abf'; end
  p = ['*.' typ];
  a = textscan(ls('-1',p),'%s','delimiter','');
  c = a{1};

