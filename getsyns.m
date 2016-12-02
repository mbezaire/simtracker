function mysyns=getsyns(handles,colorstruct)
global sl mypath savepath disspath myFontSize myFontWeight myFontName printflag printtable

if isempty(disspath)
    disspath=[savepath sl];
end

lw=1.0;

relflag=0;
percell=1;

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);

mycons=zeros(11);
filename = [myrepos(q).dir sl 'results' sl 'ca1oVgH_bench_01' sl 'numcons.dat'];
handles.curses.numcons=[];
numcons = importdata(filename); % host pretype posttype #conns
handles.curses.numcons=numcons.data(:,1:4);

for r=1:size(handles.curses.numcons,1)
mycons(handles.curses.numcons(r,2)+1,handles.curses.numcons(r,3)+1)=mycons(handles.curses.numcons(r,2)+1,handles.curses.numcons(r,3)+1)+handles.curses.numcons(r,4);
end

if percell==1
    for c=1:size(mycons,2)
        mycons(:,c)=mycons(:,c)/handles.curses.cells(c).numcells;
    end
end

if handles.runinfo.ConnData==501
    fid = fopen([myrepos(q).dir sl 'datasets' sl 'conndata_430.dat' ],'r');    
else
    fid = fopen([myrepos(q).dir sl 'datasets' sl 'conndata_' num2str(handles.runinfo.ConnData) '.dat' ],'r');    
end
numlines = fscanf(fid,'%d\n',1) ;
conndata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);


mysyns=zeros(11);
mylabel={};
for r=1:size(mysyns,1)
    rtype=handles.curses.cells(r).name;
    for c=1:size(mysyns,2)
        ctype=handles.curses.cells(c).name;
        A = strcmp(conndata{1},rtype);
        B = strcmp(conndata{2},ctype);
        idx=find(A==1 & B==1);
        if ~isempty(idx) && conndata{3}(idx)>0
            mysyns(r,c)=mycons(r,c)*conndata{5}(idx);
        end
    end
end


cidx=1;
inrnIdx=[1:6 8:9];
pyrIdx=7;
affIdx=10:11;
myinputs=[];
myLocalinputs=[];
myExcinputs=[];
myInhinputs=[];
cols=[];
celltypeNice={'Pyr','PV+B','CCK+B','SC-A','Axo','Bis','O-LM','Ivy','NGF','CA3','ECIII'};

for c=1:size(mysyns,2)
    if sum(mysyns(:,c))>0 && (sum(mysyns(:,c))<3e8 || relflag==1)
        ctype=handles.curses.cells(c).name;
        z = strmatch(ctype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
        mylabel{cidx}=celltypeNice{z}; %ctype(1:3);
        cols(cidx,1:3)=colorstruct.(ctype(1:end-4)).color;
        if relflag==1
            myinputs(1,cidx)=sum(mysyns([affIdx pyrIdx],c))/sum(mysyns([affIdx pyrIdx inrnIdx],c));
            myinputs(2,cidx)=sum(mysyns(inrnIdx,c))/sum(mysyns([affIdx pyrIdx inrnIdx],c));
            myExcinputs(1,cidx)=sum(mysyns(affIdx,c))/sum(mysyns([affIdx pyrIdx],c));
            myExcinputs(2,cidx)=sum(mysyns(pyrIdx,c))/sum(mysyns([affIdx pyrIdx],c));
            myLocalinputs(1,cidx)=sum(mysyns(pyrIdx,c))/sum(mysyns([inrnIdx pyrIdx],c));
            myLocalinputs(2,cidx)=sum(mysyns(inrnIdx,c))/sum(mysyns([inrnIdx pyrIdx],c));

            for i=1:length(inrnIdx)
                myInhinputs(i,cidx)=mysyns(inrnIdx(i),c)/sum(mysyns(inrnIdx,c));
            end
        else
            myinputs(1,cidx)=sum(mysyns([affIdx pyrIdx],c));
            myinputs(2,cidx)=sum(mysyns(inrnIdx,c));
            myExcinputs(1,cidx)=sum(mysyns(affIdx,c));
            myExcinputs(2,cidx)=sum(mysyns(pyrIdx,c));
            myLocalinputs(1,cidx)=sum(mysyns(pyrIdx,c));
            myLocalinputs(2,cidx)=sum(mysyns(inrnIdx,c));

            for i=1:length(inrnIdx)
                myInhinputs(i,cidx)=mysyns(inrnIdx(i),c);
            end
        end
        cidx=cidx+1;
    end
end

if printtable
fid=fopen([disspath '..' sl 'Tables' sl 'Table_ConMat.tex'],'w');
fprintf(fid,'\\begin{landscape}\n');
fprintf(fid,'\\begin{table}[position htb]\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{|lrrrrrrrrr|} \n');
fprintf(fid,'\\hline\n');
sortee=[];
for ee=1:9 %1:length(ephys)
    sortee(ee) = strmatch(handles.curses.cells(ee).name,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','ca3cell','eccell'});
end
fprintf(fid,'\\textbf{Pre/Post} & \\textbf{%s} &\\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} &\\textbf{%s} & \\textbf{%s} & \\textbf{%s}  & \\textbf{%s}\\\\ \n',celltypeNice{sortee});
fprintf(fid,'\\hline\n');
ephys={'Axo.','Bistrat.','CCK+ B.','Ivy','NGF','O-LM','Pyr.','PV+ B.','S.C.-A'};
cellnumvec=[handles.curses.cells(1:9).numcells];
for ee=1:size(mysyns,1) %1:length(ephys)
    z = strmatch(handles.curses.cells(ee).name,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell','ca3cell','eccell'});
    %fprintf(fid,'%s & %.0f & %.0f & %.0f & %.0f & %.0f & %.0f & %.0f & %.0f & %.0f \\\\ \n', celltypeNice{z},  mysyns(ee,1:9).*cellnumvec); 
    fprintf(fid,'%s & %.2e & %.2e & %.2e & %.2e & %.2e & %.2e & %.2e & %.2e & %.2e  \\\\ \n', celltypeNice{z},  mysyns(ee,1:9).*cellnumvec); 
    fprintf(fid,'\\hline\n');
end
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\caption[Connectivity Matrix]{Number of synapses between each cell type.}\n');
fprintf(fid,'\\label{tab:conmat}\n');
fprintf(fid,'\\end{table}\n');
fprintf(fid,'\\end{landscape}\n');
fclose(fid);
end

stpos=.06;
difpos=0.95-stpos-.03;
mycol=[0 0 .8; 1 .4 0];
mycol2=[0 .5 .5; 1 0 .4];
mm(1)=figure('Color','w','PaperUnits','inches','Units','inches','PaperSize',[6 3.5],'Position',[.5 .5 6 3.5],'PaperPosition',[0 0 6 3.5]);
%subplot(2,1,1)
subplot('Position',[0.1300    stpos+difpos*.84    0.840    difpos*.22])
hh=bar(myinputs','Stacked');
for h=1:length(hh)
    set(hh(h),'EdgeColor',mycol(h,:),'FaceColor',mycol(h,:))
end
ylabel({'Input','Synapses'})
set(gca,'XTickLabel',mylabel,'LineWidth',lw,'YTickLabel',{'0','10000','20000'})
xlim([0 12])
legend(hh(end:-1:1),{'Inhibitory','Excitatory'},'Position',[0.79    0.6476+difpos*.25    0.1910    0.0792],'EdgeColor','none','Color','none')
box off

subplot('Position',[0.1300    stpos+difpos*.5    0.840    difpos*.22])
hh=bar(myExcinputs','Stacked');
for h=1:length(hh)
    set(hh(h),'EdgeColor',mycol2(h,:),'FaceColor',mycol2(h,:))
end
ylabel({'Exc. Input','Synapses'})
set(gca,'XTickLabel',mylabel,'LineWidth',lw,'YTickLabel',{'0','10000','20000'})
xlim([0 12])
legend(hh(end:-1:1),{'Pyramidal','Afferent'},'Position',[0.79    0.6195    0.1910    0.0792],'EdgeColor','none','Color','none')
box off

subplot('Position',[0.1300    stpos    0.840    difpos*.4])
hh=bar(myInhinputs','Stacked');
ylabel({'Inh. Input','Synapses'})
set(gca,'XTickLabel',mylabel,'LineWidth',lw)
for h=1:length(hh)
    set(hh(h),'EdgeColor',cols(inrnIdx(h),:),'FaceColor',cols(inrnIdx(h),:))
end
xlim([0 12])
legend(hh(end:-1:1),mylabel(inrnIdx(end:-1:1)),'Position',[0.79    0.1103    0.1910    0.2875],'EdgeColor','none','Color','none')
box off

for m=1:length(mm)
    bf = findall(mm(m),'Type','text');
    for b=1:length(bf)
        set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
    bf = findall(mm(m),'Type','axes');
    for b=1:length(bf)
        set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
    if printflag
    printeps(mm(m),[disspath 'ConnBar' num2str(m)])
    end
end