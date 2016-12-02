function [data,zapf] = load_data(r)
if ischar(r)
  if exist(r,'file')
    c = textscan(fopen(r),'%s'); 
    zapf = c{1};
  else
    c = textscan(r,'%s','delimiter','');
    zapf = c{1};
  end
elseif iscell(r)
  if length(r) > 1
    zapf = r;
  else
    zapf = r{1};
  end
end
data=cell(size(zapf,1),1);
for k=1:length(zapf)
  try
    evalc('data{k} = abfload(zapf{k})');
  catch ME
    fprintf(2,'abfload error: cannot convert data in %s\n', zapf{k});
  end
end
