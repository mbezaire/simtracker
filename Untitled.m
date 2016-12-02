figure('Color','w','Name','Normalized Power v. Modulation');
for r=1:9
    z = strmatch(myRuns(1).Cells(r).name,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
    x=arrayfun(@(x) x.Cells(r).theta.norm, myRuns);
    y=arrayfun(@(x) x.Cells(r).theta.mag, myRuns);
    y = y(~isnan(x));
    x = x(~isnan(x));
    x = x(~isnan(y));
    y = y(~isnan(y));
    plot(x,y,'LineStyle','none','Marker','.','MarkerSize',10,'Color',colorvec(z,:))
    hold on
    p = polyfit(x,y,1);
    yfit = polyval(p,[0:.1:1]);
    hold on
    %plot([0:.1:1],yfit,'Color',colorvec(z,:))
end
xlabel('Normalized FFT Theta Power')
ylabel('Magnitude of Theta Modulation')
title('Per Cell Type FFT Power v. Modulation')

for r=1:9
    for z=1:9
        x=arrayfun(@(x) x.Cells(r).theta.mag, myRuns);
        y=arrayfun(@(x) x.Cells(z).theta.mag, myRuns);
        y = y(~isnan(x));
        x = x(~isnan(x));
        x = x(~isnan(y));
        y = y(~isnan(y));

        p = polyfit(x,y,1);
        yfit = polyval(p,x);
        yresid = y - yfit;
        SSresid = sum(yresid.^2);
        SStotal = (length(y)-1) * var(y);
        rsq(r,z) = 1 - SSresid/SStotal;
        if rsq(r,z)>.4 & r~=z
            disp([myRuns(1).Cells(r).name ' x ' myRuns(1).Cells(z).name]);
        end
    end
end

for r=1:9
    for z=1:9
        x=arrayfun(@(x) x.Cells(r).theta.phase, myRuns);
        y=arrayfun(@(x) x.Cells(z).theta.phase, myRuns);
        y = y(~isnan(x));
        x = x(~isnan(x));
        x = x(~isnan(y));
        y = y(~isnan(y));

        [R,P]=corrcoef(x,y);
        RR(r,z)=R(2);
        PP(r,z)=P(2);
        if RR(r,z)>.4 & r~=z & PP(r,z)<.05
            disp(['High R: ' myRuns(1).Cells(r).name ' x ' myRuns(1).Cells(z).name]);
        end
    end
end

%     'axoaxoniccell'
%     'bistratifiedcell'
%     'cckcell'
%     'ivycell'
%     'ngfcell'
%     'olmcell'
%     'pyramidalcell'
%     'pvbasketcell'
%     'scacell'
%     'ca3cell'
%     'eccell'
    
% Phases
% High R: axoaxoniccell x scacell  1 x 9
% High R: cckcell x scacell  3 x 9

newvec=[1 .1 .1;.1 1 .1; .1 .1 1; .5 .5 .5];

tryR=[1 3];
tryG=[9 9];

myl=[];
legstr={};
figure('Color','w','Name','Phase Correlation');
for b=1:length(tryR)
    r=tryR(b);
    g=tryG(b);
    z = strmatch(myRuns(1).Cells(r).name,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
    x=arrayfun(@(x) x.Cells(r).theta.phase, myRuns);
    y=arrayfun(@(x) x.Cells(g).theta.phase, myRuns);
    y = y(~isnan(x));
    x = x(~isnan(x));
    x = x(~isnan(y));
    y = y(~isnan(y));
    myl(b)=plot(x,y,'LineStyle','none','Marker','.','MarkerSize',10,'Color',newvec(b,:))
    hold on
    p = polyfit(x,y,1);
    yfit = polyval(p,[0:10:360]);
    hold on
    %plot([0:10:360],yfit,'Color',newvec(b,:))
    legstr{b}=[myRuns(1).Cells(r).name ' x ' myRuns(1).Cells(g).name ': R^2=' num2str(RR(r,g)) ',  Pval=' num2str(PP(r,g))];
end
legend(myl,legstr)
xlabel('Phase')
ylabel('Phase')
title('Phase Correlation')


% Magnitude
% bistratifiedcell x pyramidalcell  2 x 7
% bistratifiedcell x pvbasketcell  2 x 8
% olmcell x pyramidalcell  6 x 7
% pyramidalcell x pvbasketcell  7 x 8

myl=[];
legstr={};
tryR=[2 2 6 7];
tryG=[7 8 7 8];
figure('Color','w','Name','Modulation Correlation');
for b=1:length(tryR)
    r=tryR(b);
    g=tryG(b);
    z = strmatch(myRuns(1).Cells(r).name,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
    x=arrayfun(@(x) x.Cells(r).theta.mag, myRuns);
    y=arrayfun(@(x) x.Cells(g).theta.mag, myRuns);
    y = y(~isnan(x));
    x = x(~isnan(x));
    x = x(~isnan(y));
    y = y(~isnan(y));
    myl(b)=plot(x,y,'LineStyle','none','Marker','.','MarkerSize',10,'Color',newvec(b,:));
    hold on
    p = polyfit(x,y,1);
    yfit = polyval(p,[0:.1:1]);
    hold on
    %plot([0:.1:1],yfit,'Color',newvec(b,:))
    legstr{b}=[myRuns(1).Cells(r).name ' x ' myRuns(1).Cells(g).name ': R^2=' num2str(rsq(r,g))];
end
legend(myl,legstr)
xlabel('Modulation')
ylabel('Modulation')
title('Modulation Correlation')

