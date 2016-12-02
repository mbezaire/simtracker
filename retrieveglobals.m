for r_sg=1:length(g_sg)
    eval(['global ' g_sg{r_sg} ';' g_sg{r_sg} ' = savevar.(g_sg{r_sg});']);
end