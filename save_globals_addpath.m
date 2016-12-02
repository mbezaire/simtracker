function save_globals_addpath(varargin)

g=who('global');
for r=1:length(g)
    if exist(g{r},'var')==0
        eval(['global ' g{r}]);
    end
    eval(['savevar.(g{r}) = ' g{r} ';']);
end

javaaddpath(varargin)

for r=1:length(g)
    eval(['global ' g{r} ';' g{r} ' = savevar.(g{r});']);
end
