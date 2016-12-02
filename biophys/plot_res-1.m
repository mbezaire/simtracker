if ~exist('plots','dir'), mkdir plots; end
load zap_res
n = length(Z);
for k = 1:n
  c = regexp(zapf{k},'/(\d{4}_\d{2}_\d{2}_\d{4}|\d{8})','tokens');
  key = char(c{1});
  kl = strrep(key,'_','\_'); % no subscripting key label
  subplot(2,1,1);
  % plot ZAP response
  plot_vm(zapf{k},sprintf('%s (%s)',kl,...
                          char(regexp(zapf{k},'[LM]EC','match'))));
  subplot(2,1,2);
  % plot impedance
  plot_imp(Z{k},sr(k),M(k,:),[1 20]);
  
  %set(gca,'XLim',[0 20]); % assumed ZAP freq. range
  xlabel('freq. (Hz)'); ylabel('Impedance (G\Omega)');
  lh = legend(kl, sprintf('Fr=%g Hz Q=%g; err=%g', F(k), Q(k), rmse(k)));
  set(lh,'FontSize',get(gca,'FontSize')-1);
  legend boxoff;
  pdf = ['plots/' key '.pdf'];
  saveas(gcf, pdf);
  png = strrep(pdf,'pdf','png');
  system(['convert -trim ' pdf ' ' png]);
  disp(png)
end
