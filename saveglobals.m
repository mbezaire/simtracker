g_sg=who('global');
for r_sg=1:length(g_sg)
    if exist(g_sg{r_sg},'var')==0
        eval(['global ' g_sg{r_sg}]);
    end
    eval(['savevar.(g_sg{r_sg}) = ' g_sg{r_sg} ';']);
end