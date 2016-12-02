function Vm = get_Vm(r)
% load each simulation results file, save membrane potential vector
  if ~nargin, r = read_sims; end
  assert(isstruct(r),...
         'argument must be struct array containing vector field y');
  n = length(r);
  m = length(r(1).y);
  Vm = zeros(n, m);
  for k = 1:n
    v = r(k).y(:,1)';
    m0 = length(v);
    if m0 < m, v = [v v(end)*ones(1,m - m0)]; end
    Vm(k,:) = v;
  end
end
