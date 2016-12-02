normdata <- read.table("C:/Users/M/Desktop/repos/superdeep/results/Elf_01/normrates.txt", header = T)
aov.norm.celltype.cond <- aov(subrate ~ celltype*condition, data=normdata)
mynormbars <- TukeyHSD(aov.norm.celltype.cond)
write.table(mynormbars$"celltype:condition", file="C:/Users/M/Desktop/repos/superdeep/results/Elf_01/myRoutput.txt", append=FALSE, sep="\t", col.names=F)

pvbcdata <- read.table("C:/Users/M/Desktop/repos/superdeep/results/Elf_01/normratesPVBC.txt", header = T)
pvbcdata$condition <- factor(pvbcdata$condition)
aov.pvbc.celltype.cond <- aov(subrate ~ celltype*condition, data=pvbcdata)
mypvbcbars <- TukeyHSD(aov.pvbc.celltype.cond)
write.table(mypvbcbars$"celltype:condition", file="C:/Users/M/Desktop/repos/superdeep/results/Elf_01/myRoutputpvbc.txt", append=FALSE, sep="\t", col.names=F)


