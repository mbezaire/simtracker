function plot_res(matf)
  if ~exist('plots','dir'), mkdir plots; end
  if ~nargin, matf = 'zap_res'; end
  load(matf) % zapf,sr,Z,F,Q,M
  n = length(Z);
  for k = 1:n
    [~,key] = fileparts(zapf{k});
    kl = strrep(key,'_','\_'); % no subscripting key label
    subplot(2,1,1);
    % plot ZAP response
    pl = sprintf('%s (%s)',kl,...
                 char(regexp(zapf{k},'[LM]EC','match')));
    plot_vm(zapf{k},pl)
    subplot(2,1,2);
    % plot impedance
    plot_imp(Z{k},sr(k),[0.5 20],M(k,:));
    xlabel('freq. (Hz)'); ylabel('Impedance (G\Omega)');
    title(sprintf('ZAP impedance, RLC model fit'));
    zl = sprintf('Fr=%g Hz Q=%g; err=%g', F(k), Q(k), rmse(k));
    lh = legend(kl,zl);
    set(lh,'FontSize',get(gca,'FontSize')-1);
    legend boxoff;
    pdf = ['plots/' key '.pdf'];
   saveas(gcf, pdf);
    png = strrep(pdf,'pdf','png');
    system(['convert -trim ' pdf ' ' png]);
    disp(png)
  end
end
