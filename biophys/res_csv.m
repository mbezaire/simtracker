function res_csv(matf)
  if ~nargin, matf = 'zap_res'; end
  matf = strrep(matf,'.mat','');
  load(matf);
  fid=fopen([matf '.csv'],'w');
  for k=1:length(F); 
    [~,key] = fileparts(zapf{k});
    fprintf(fid,'%s,%.5g,%.5g,%.5g,%.5g\n',key,Zr(k),F(k),Q(k),rmse(k));
  end
end
