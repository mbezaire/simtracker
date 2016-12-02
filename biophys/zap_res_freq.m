function [fr, zr, pr, M] = zap_res_freq(f, Z, zf)
% give freq. vector, impedance row array, and ZAP max. freq
% returns peak (frequency, impedance) and curvefit params for each signal
  a = intersect(find(f>.1),find(f<=zf));
  [M pr] = imp_fit(pi*f(a)/f(end), Z(:,a));
  [zr k] = max(M');  % peak of resonance curve fit
  fr = f(k+a(1)-1);
end

function [M, p] = imp_fit(W, Z)
  p = rlc_impedance_model(W,Z);
  M = zeros(size(Z));
  for k = 1:size(Z,1)
    M(k,:) = rlc_impedance_curve(p(k,:), W);
  end
end
