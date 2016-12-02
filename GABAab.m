function h=GABAab()

%load('myGABAab.mat')
load('myGABAabNEW.mat')
% synfigdata_1188 % GABAa x3
% synfigdata_1186 % GABAab fast b
% synfigdata_1185 % GABAa
% synfigdata_1183 % GABAab
% synfigdata_1189 % GABAab faster b
% synfigdata_1190 % GABAa x10
% synfigdata_1191 % GABAa x15
% synfigdata_1192 % GABAab fastest b
% synfigdata_1193 % GABAa x30
% synfigdata_1194 % GABAab slow b

% synfigdata_1198 % GABAab
% synfigdata_1108 % GABAa
% synfigdata_1209 % GABAa x3
% synfigdata_1210 % GABAa x10
% synfigdata_1211 % GABAa x15
% synfigdata_1212 % GABAa x30
% synfigdata_1202 % GABAab fastest b
% synfigdata_1201 % GABAab faster b
% synfigdata_1200 % GABAab fast b
% synfigdata_1203 % GABAab slow b

% save('myGABAab.mat','synfigdata_1198','synfigdata_1208','synfigdata_1200','synfigdata_1201','synfigdata_1202','synfigdata_1203','synfigdata_1209','synfigdata_1210','synfigdata_1211','synfigdata_1212',...
% 'CutMor_032_Long','CutMor_032_Long_fourthGABAb','CutMor_032_Long_halfGABAb','CutMor_032_Long_noGABAb','CutMor_032_Long_3xGABAa','CutMor_032_Long_10xGABAa', ...
% 'CutMor_032_Long_eighthGABAb','CutMor_032_Long_15xGABAa','CutMor_032_Long_30xGABAa','CutMor_032_Long_slowGABAb');

%save('myGABAabNEW.mat','synfigdata_1198','synfigdata_1208','synfigdata_1200','synfigdata_1201','synfigdata_1202','synfigdata_1203','synfigdata_1209','synfigdata_1210','synfigdata_1211','synfigdata_1212',...
%    'cl1x27s_GABAb_01','cl1x27s_GABAb_02','cl1x27_GABAb_03','cl1x27_GABAb_04','cl1x27_GABAb_05','cl1x27_GABAb_06','cl1x27_GABAb_07','cl1x27_GABAb_08','cl1x27_GABAb_09','cl1x27_GABAb_10');

CutMor_032_Long_slowGABAb=cl1x27s_GABAb_01;
CutMor_032_Long=cl1x27s_GABAb_02;
CutMor_032_Long_halfGABAb=cl1x27_GABAb_03;
CutMor_032_Long_fourthGABAb=cl1x27_GABAb_04;
CutMor_032_Long_eighthGABAb=cl1x27_GABAb_05;
CutMor_032_Long_noGABAb=cl1x27_GABAb_06;
CutMor_032_Long_3xGABAa=cl1x27_GABAb_07;
CutMor_032_Long_10xGABAa=cl1x27_GABAb_08;
CutMor_032_Long_15xGABAa=cl1x27_GABAb_09;
CutMor_032_Long_30xGABAa=cl1x27_GABAb_10;

CutMor_032_Long_slowGABAb.color = [0 1 0];
CutMor_032_Long.color = [0 0 0];
CutMor_032_Long_halfGABAb.color = [0 .65 .35];
CutMor_032_Long_fourthGABAb.color = [0 .35 .65];
CutMor_032_Long_eighthGABAb.color = [.3 .2 1];
CutMor_032_Long_noGABAb.color = [.7 0 0];
CutMor_032_Long_3xGABAa.color = [1 .1 .1];
CutMor_032_Long_10xGABAa.color = [1 .5 .2];
CutMor_032_Long_15xGABAa.color = [1 .7 .2];
CutMor_032_Long_30xGABAa.color = [1  1 .2];



synfigdata_1198.total = trapz(synfigdata_1198.fig.axis.data(11).y);
synfigdata_1208.total = trapz(synfigdata_1208.fig.axis.data(11).y);
synfigdata_1200.total = trapz(synfigdata_1200.fig.axis.data(11).y);
synfigdata_1201.total = trapz(synfigdata_1201.fig.axis.data(11).y);
synfigdata_1202.total = trapz(synfigdata_1202.fig.axis.data(11).y);
synfigdata_1203.total = trapz(synfigdata_1203.fig.axis.data(11).y);
synfigdata_1209.total = trapz(synfigdata_1209.fig.axis.data(11).y);
synfigdata_1210.total = trapz(synfigdata_1210.fig.axis.data(11).y);
synfigdata_1211.total = trapz(synfigdata_1211.fig.axis.data(11).y);
synfigdata_1212.total = trapz(synfigdata_1212.fig.axis.data(11).y);



% h(1)=figure('Color','w');
% plot(CutMor_032_Long.curses.cells(7).f,CutMor_032_Long.curses.cells(7).fft_results/max(CutMor_032_Long.curses.cells(7).fft_results),'Color',CutMor_032_Long.color,'LineWidth',2)
% hold on
% plot(CutMor_032_Long_slowGABAb.curses.cells(7).f,CutMor_032_Long_slowGABAb.curses.cells(7).fft_results/max(CutMor_032_Long_slowGABAb.curses.cells(7).fft_results),'Color',CutMor_032_Long_slowGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_halfGABAb.curses.cells(7).f,CutMor_032_Long_halfGABAb.curses.cells(7).fft_results/max(CutMor_032_Long_halfGABAb.curses.cells(7).fft_results),'Color',CutMor_032_Long_halfGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_fourthGABAb.curses.cells(7).f,CutMor_032_Long_fourthGABAb.curses.cells(7).fft_results/max(CutMor_032_Long_fourthGABAb.curses.cells(7).fft_results),'Color',CutMor_032_Long_fourthGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_eighthGABAb.curses.cells(7).f,CutMor_032_Long_eighthGABAb.curses.cells(7).fft_results/max(CutMor_032_Long_eighthGABAb.curses.cells(7).fft_results),'Color',CutMor_032_Long_eighthGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_noGABAb.curses.cells(7).f,CutMor_032_Long_noGABAb.curses.cells(7).fft_results/max(CutMor_032_Long_noGABAb.curses.cells(7).fft_results),'Color',CutMor_032_Long_noGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_3xGABAa.curses.cells(7).f,CutMor_032_Long_3xGABAa.curses.cells(7).fft_results/max(CutMor_032_Long_3xGABAa.curses.cells(7).fft_results),'Color',CutMor_032_Long_3xGABAa.color,'LineWidth',2)
% plot(CutMor_032_Long_10xGABAa.curses.cells(7).f,CutMor_032_Long_10xGABAa.curses.cells(7).fft_results/max(CutMor_032_Long_10xGABAa.curses.cells(7).fft_results),'Color',CutMor_032_Long_10xGABAa.color,'LineWidth',2)
% plot(CutMor_032_Long_15xGABAa.curses.cells(7).f,CutMor_032_Long_15xGABAa.curses.cells(7).fft_results/max(CutMor_032_Long_15xGABAa.curses.cells(7).fft_results),'Color',CutMor_032_Long_15xGABAa.color,'LineWidth',2)
% plot(CutMor_032_Long_30xGABAa.curses.cells(7).f,CutMor_032_Long_30xGABAa.curses.cells(7).fft_results/max(CutMor_032_Long_30xGABAa.curses.cells(7).fft_results),'Color',CutMor_032_Long_30xGABAa.color,'LineWidth',2)
% bleg=legend({'GABA_{A,B}','GABA_{A,B,slow}','GABA_{A,B,fast}','GABA_{A,B,faster}','GABA_{A,B,fastest}','GABA_{A} only','GABA_{A} x3','GABA_{A} x10','GABA_{A} x15','GABA_{A} x30'},'Location','Best');
% formatter(bleg);
% set(bleg,'FontSize',10)
% 
% formatter(xlabel('Frequency (Hz)'))
% formatter(ylabel('Normalized Power'))
% xlim([0 20])
% ylim([0 1])
% box off
% formatter(gca)
% 
% figure('Color','w');
% plot(CutMor_032_Long.curses.cells(7).f,CutMor_032_Long.curses.cells(7).fft_results,'Color',CutMor_032_Long.color,'LineWidth',2)
% hold on
% plot(CutMor_032_Long_slowGABAb.curses.cells(7).f,CutMor_032_Long_slowGABAb.curses.cells(7).fft_results,'Color',CutMor_032_Long_slowGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_halfGABAb.curses.cells(7).f,CutMor_032_Long_halfGABAb.curses.cells(7).fft_results,'Color',CutMor_032_Long_halfGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_fourthGABAb.curses.cells(7).f,CutMor_032_Long_fourthGABAb.curses.cells(7).fft_results,'Color',CutMor_032_Long_fourthGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_eighthGABAb.curses.cells(7).f,CutMor_032_Long_eighthGABAb.curses.cells(7).fft_results,'Color',CutMor_032_Long_eighthGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_noGABAb.curses.cells(7).f,CutMor_032_Long_noGABAb.curses.cells(7).fft_results,'Color',CutMor_032_Long_noGABAb.color,'LineWidth',2)
% plot(CutMor_032_Long_3xGABAa.curses.cells(7).f,CutMor_032_Long_3xGABAa.curses.cells(7).fft_results,'Color',CutMor_032_Long_3xGABAa.color,'LineWidth',2)
% plot(CutMor_032_Long_10xGABAa.curses.cells(7).f,CutMor_032_Long_10xGABAa.curses.cells(7).fft_results,'Color',CutMor_032_Long_10xGABAa.color,'LineWidth',2)
% plot(CutMor_032_Long_15xGABAa.curses.cells(7).f,CutMor_032_Long_15xGABAa.curses.cells(7).fft_results,'Color',CutMor_032_Long_15xGABAa.color,'LineWidth',2)
% plot(CutMor_032_Long_30xGABAa.curses.cells(7).f,CutMor_032_Long_30xGABAa.curses.cells(7).fft_results,'Color',CutMor_032_Long_30xGABAa.color,'LineWidth',2)
% legend({'GABA_{A,B}','GABA_{A,B,slow}','GABA_{A,B,fast}','GABA_{A,B,faster}','GABA_{A,B,fastest}','GABA_{A} only','GABA_{A} x3','GABA_{A} x10','GABA_{A} x15','GABA_{A} x30'})
% xlabel('Frequency (Hz)')
% ylabel('Power')
% xlim([0 100])
% 

n=1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long.curses.cells(7).f,CutMor_032_Long.curses.cells(7).fft_results);
CutMor_032_Long.peaktheta = peaktheta;
CutMor_032_Long.thetapower = thetapower;
CutMor_032_Long.normpower = normpower;
CutMor_032_Long.total = synfigdata_1198.total;
CutMor_032_Long.x = synfigdata_1198.fig.axis.data(11).x;
CutMor_032_Long.y = synfigdata_1198.fig.axis.data(11).y;
chk(1).peaktheta = CutMor_032_Long.peaktheta;
chk(1).thetapower = CutMor_032_Long.thetapower;
chk(1).normpower = CutMor_032_Long.normpower;
chk(1).total = CutMor_032_Long.total;

n=n+1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long_slowGABAb.curses.cells(7).f,CutMor_032_Long_slowGABAb.curses.cells(7).fft_results);
CutMor_032_Long_slowGABAb.peaktheta = peaktheta;
CutMor_032_Long_slowGABAb.thetapower = thetapower;
CutMor_032_Long_slowGABAb.normpower = normpower;
CutMor_032_Long_slowGABAb.total = synfigdata_1203.total;
CutMor_032_Long_slowGABAb.x = synfigdata_1203.fig.axis.data(11).x;
CutMor_032_Long_slowGABAb.y = synfigdata_1203.fig.axis.data(11).y;
chk(n).peaktheta = CutMor_032_Long_slowGABAb.peaktheta;
chk(n).thetapower = CutMor_032_Long_slowGABAb.thetapower;
chk(n).normpower = CutMor_032_Long_slowGABAb.normpower;
chk(n).total = CutMor_032_Long_slowGABAb.total;

n=n+1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long_halfGABAb.curses.cells(7).f,CutMor_032_Long_halfGABAb.curses.cells(7).fft_results);
CutMor_032_Long_halfGABAb.peaktheta = peaktheta;
CutMor_032_Long_halfGABAb.thetapower = thetapower;
CutMor_032_Long_halfGABAb.normpower = normpower;
CutMor_032_Long_halfGABAb.total = synfigdata_1200.total;
CutMor_032_Long_halfGABAb.x = synfigdata_1200.fig.axis.data(11).x;
CutMor_032_Long_halfGABAb.y = synfigdata_1200.fig.axis.data(11).y;
chk(n).peaktheta = CutMor_032_Long_halfGABAb.peaktheta;
chk(n).thetapower = CutMor_032_Long_halfGABAb.thetapower;
chk(n).normpower = CutMor_032_Long_halfGABAb.normpower;
chk(n).total = CutMor_032_Long_halfGABAb.total;

n=n+1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long_fourthGABAb.curses.cells(7).f,CutMor_032_Long_fourthGABAb.curses.cells(7).fft_results);
CutMor_032_Long_fourthGABAb.peaktheta = peaktheta;
CutMor_032_Long_fourthGABAb.thetapower = thetapower;
CutMor_032_Long_fourthGABAb.normpower = normpower;
CutMor_032_Long_fourthGABAb.total = synfigdata_1201.total;
CutMor_032_Long_fourthGABAb.x = synfigdata_1201.fig.axis.data(11).x;
CutMor_032_Long_fourthGABAb.y = synfigdata_1201.fig.axis.data(11).y;
chk(n).peaktheta = CutMor_032_Long_fourthGABAb.peaktheta;
chk(n).thetapower = CutMor_032_Long_fourthGABAb.thetapower;
chk(n).normpower = CutMor_032_Long_fourthGABAb.normpower;
chk(n).total = CutMor_032_Long_fourthGABAb.total;

n=n+1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long_eighthGABAb.curses.cells(7).f,CutMor_032_Long_eighthGABAb.curses.cells(7).fft_results);
CutMor_032_Long_eighthGABAb.peaktheta = peaktheta;
CutMor_032_Long_eighthGABAb.thetapower = thetapower;
CutMor_032_Long_eighthGABAb.normpower = normpower;
CutMor_032_Long_eighthGABAb.total = synfigdata_1202.total;
CutMor_032_Long_eighthGABAb.x = synfigdata_1202.fig.axis.data(11).x;
CutMor_032_Long_eighthGABAb.y = synfigdata_1202.fig.axis.data(11).y;
chk(n).peaktheta = CutMor_032_Long_eighthGABAb.peaktheta;
chk(n).thetapower = CutMor_032_Long_eighthGABAb.thetapower;
chk(n).normpower = CutMor_032_Long_eighthGABAb.normpower;
chk(n).total = CutMor_032_Long_eighthGABAb.total;

n=n+1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long_noGABAb.curses.cells(7).f,CutMor_032_Long_noGABAb.curses.cells(7).fft_results);
CutMor_032_Long_noGABAb.peaktheta = peaktheta;
CutMor_032_Long_noGABAb.thetapower = thetapower;
CutMor_032_Long_noGABAb.normpower = normpower;
CutMor_032_Long_noGABAb.total = synfigdata_1208.total;
CutMor_032_Long_noGABAb.x = synfigdata_1208.fig.axis.data(11).x;
CutMor_032_Long_noGABAb.y = synfigdata_1208.fig.axis.data(11).y;
chk(n).peaktheta = CutMor_032_Long_noGABAb.peaktheta;
chk(n).thetapower = CutMor_032_Long_noGABAb.thetapower;
chk(n).normpower = CutMor_032_Long_noGABAb.normpower;
chk(n).total = CutMor_032_Long_noGABAb.total;

n=n+1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long_3xGABAa.curses.cells(7).f,CutMor_032_Long_3xGABAa.curses.cells(7).fft_results);
CutMor_032_Long_3xGABAa.peaktheta = peaktheta;
CutMor_032_Long_3xGABAa.thetapower = thetapower;
CutMor_032_Long_3xGABAa.normpower = normpower;
CutMor_032_Long_3xGABAa.total = synfigdata_1209.total;
CutMor_032_Long_3xGABAa.x = synfigdata_1209.fig.axis.data(11).x;
CutMor_032_Long_3xGABAa.y = synfigdata_1209.fig.axis.data(11).y;
chk(n).peaktheta = CutMor_032_Long_3xGABAa.peaktheta;
chk(n).thetapower = CutMor_032_Long_3xGABAa.thetapower;
chk(n).normpower = CutMor_032_Long_3xGABAa.normpower;
chk(n).total = CutMor_032_Long_3xGABAa.total;

n=n+1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long_10xGABAa.curses.cells(7).f,CutMor_032_Long_10xGABAa.curses.cells(7).fft_results);
CutMor_032_Long_10xGABAa.peaktheta = peaktheta;
CutMor_032_Long_10xGABAa.thetapower = thetapower;
CutMor_032_Long_10xGABAa.normpower = normpower;
CutMor_032_Long_10xGABAa.total = synfigdata_1210.total;
CutMor_032_Long_10xGABAa.x = synfigdata_1210.fig.axis.data(11).x;
CutMor_032_Long_10xGABAa.y = synfigdata_1210.fig.axis.data(11).y;
chk(n).peaktheta = CutMor_032_Long_10xGABAa.peaktheta;
chk(n).thetapower = CutMor_032_Long_10xGABAa.thetapower;
chk(n).normpower = CutMor_032_Long_10xGABAa.normpower;
chk(n).total = CutMor_032_Long_10xGABAa.total;


n=n+1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long_15xGABAa.curses.cells(7).f,CutMor_032_Long_15xGABAa.curses.cells(7).fft_results);
CutMor_032_Long_15xGABAa.peaktheta = peaktheta;
CutMor_032_Long_15xGABAa.thetapower = thetapower;
CutMor_032_Long_15xGABAa.normpower = normpower;
CutMor_032_Long_15xGABAa.total = synfigdata_1211.total;
CutMor_032_Long_15xGABAa.x = synfigdata_1211.fig.axis.data(11).x;
CutMor_032_Long_15xGABAa.y = synfigdata_1211.fig.axis.data(11).y;
chk(n).peaktheta = CutMor_032_Long_15xGABAa.peaktheta;
chk(n).thetapower = CutMor_032_Long_15xGABAa.thetapower;
chk(n).normpower = CutMor_032_Long_15xGABAa.normpower;
chk(n).total = CutMor_032_Long_15xGABAa.total;

n=n+1;
[peaktheta thetapower normpower]=gettheta(CutMor_032_Long_30xGABAa.curses.cells(7).f,CutMor_032_Long_30xGABAa.curses.cells(7).fft_results);
CutMor_032_Long_30xGABAa.peaktheta = peaktheta;
CutMor_032_Long_30xGABAa.thetapower = thetapower;
CutMor_032_Long_30xGABAa.normpower = normpower;
CutMor_032_Long_30xGABAa.total = synfigdata_1212.total;
CutMor_032_Long_30xGABAa.x = synfigdata_1212.fig.axis.data(11).x;
CutMor_032_Long_30xGABAa.y = synfigdata_1212.fig.axis.data(11).y;
chk(n).peaktheta = CutMor_032_Long_30xGABAa.peaktheta;
chk(n).thetapower = CutMor_032_Long_30xGABAa.thetapower;
chk(n).normpower = CutMor_032_Long_30xGABAa.normpower;
chk(n).total = CutMor_032_Long_30xGABAa.total;

% h(2)=figure('Color','w');
% %subplot(3,1,1)
% plot(CutMor_032_Long.total,CutMor_032_Long.peaktheta,'Color',CutMor_032_Long.color,'LineStyle','none','Marker','.','MarkerSize',30)
% hold on
% plot(CutMor_032_Long_slowGABAb.total,CutMor_032_Long_slowGABAb.peaktheta,'Color',CutMor_032_Long_slowGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_halfGABAb.total,CutMor_032_Long_halfGABAb.peaktheta,'Color',CutMor_032_Long_halfGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_fourthGABAb.total,CutMor_032_Long_fourthGABAb.peaktheta,'Color',CutMor_032_Long_fourthGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_eighthGABAb.total,CutMor_032_Long_eighthGABAb.peaktheta,'Color',CutMor_032_Long_eighthGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_noGABAb.total,CutMor_032_Long_noGABAb.peaktheta,'Color',CutMor_032_Long_noGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_3xGABAa.total,CutMor_032_Long_3xGABAa.peaktheta,'Color',CutMor_032_Long_3xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_10xGABAa.total,CutMor_032_Long_10xGABAa.peaktheta,'Color',CutMor_032_Long_10xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_15xGABAa.total,CutMor_032_Long_15xGABAa.peaktheta,'Color',CutMor_032_Long_15xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_30xGABAa.total,CutMor_032_Long_30xGABAa.peaktheta,'Color',CutMor_032_Long_30xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
% xlabel('Charge transferred')
% ylabel('Theta (Hz)')
% box off


% figure('Color','w');
% %subplot(3,1,2)
% plot(CutMor_032_Long.total,CutMor_032_Long.thetapower,'Color',CutMor_032_Long.color,'LineStyle','none','Marker','.','MarkerSize',30)
% hold on
% plot(CutMor_032_Long_slowGABAb.total,CutMor_032_Long_slowGABAb.thetapower,'Color',CutMor_032_Long_slowGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_halfGABAb.total,CutMor_032_Long_halfGABAb.thetapower,'Color',CutMor_032_Long_halfGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_fourthGABAb.total,CutMor_032_Long_fourthGABAb.thetapower,'Color',CutMor_032_Long_fourthGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_eighthGABAb.total,CutMor_032_Long_eighthGABAb.thetapower,'Color',CutMor_032_Long_eighthGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_noGABAb.total,CutMor_032_Long_noGABAb.thetapower,'Color',CutMor_032_Long_noGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_3xGABAa.total,CutMor_032_Long_3xGABAa.thetapower,'Color',CutMor_032_Long_3xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_10xGABAa.total,CutMor_032_Long_10xGABAa.thetapower,'Color',CutMor_032_Long_10xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_15xGABAa.total,CutMor_032_Long_15xGABAa.thetapower,'Color',CutMor_032_Long_15xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
% plot(CutMor_032_Long_30xGABAa.total,CutMor_032_Long_30xGABAa.thetapower,'Color',CutMor_032_Long_30xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
% xlabel('Charge transferred')
% ylabel('Power (|Y|)')
 
  
h(1)=figure('Color','w','Units','inches','Position',[1 1 8 4]);
%subplot(3,1,3)
set(gca,'Position',[.1 .15 .5 .8]);
x1=[CutMor_032_Long.total CutMor_032_Long_slowGABAb.total CutMor_032_Long_halfGABAb.total CutMor_032_Long_fourthGABAb.total CutMor_032_Long_eighthGABAb.total];
y1=[CutMor_032_Long.normpower CutMor_032_Long_slowGABAb.normpower CutMor_032_Long_halfGABAb.normpower CutMor_032_Long_fourthGABAb.normpower CutMor_032_Long_eighthGABAb.normpower];
[x1, sortI]=sort(x1);
y1=y1(sortI);

x2=[CutMor_032_Long_noGABAb.total CutMor_032_Long_3xGABAa.total CutMor_032_Long_10xGABAa.total CutMor_032_Long_15xGABAa.total CutMor_032_Long_30xGABAa.total];
y2=[CutMor_032_Long_noGABAb.normpower CutMor_032_Long_3xGABAa.normpower CutMor_032_Long_10xGABAa.normpower CutMor_032_Long_15xGABAa.normpower CutMor_032_Long_30xGABAa.normpower];
[x2, sortI]=sort(x2);
y2=y2(sortI);

plot(x1,y1,'k','LineWidth',3)
hold on

plot(x2,y2,'Color',[.5 .5 .5],'LineWidth',3)

plot(CutMor_032_Long_slowGABAb.total,CutMor_032_Long_slowGABAb.normpower,'Color',CutMor_032_Long_slowGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long.total,CutMor_032_Long.normpower,'Color',CutMor_032_Long.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_halfGABAb.total,CutMor_032_Long_halfGABAb.normpower,'Color',CutMor_032_Long_halfGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_fourthGABAb.total,CutMor_032_Long_fourthGABAb.normpower,'Color',CutMor_032_Long_fourthGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_eighthGABAb.total,CutMor_032_Long_eighthGABAb.normpower,'Color',CutMor_032_Long_eighthGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_noGABAb.total,CutMor_032_Long_noGABAb.normpower,'Color',CutMor_032_Long_noGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_3xGABAa.total,CutMor_032_Long_3xGABAa.normpower,'Color',CutMor_032_Long_3xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_10xGABAa.total,CutMor_032_Long_10xGABAa.normpower,'Color',CutMor_032_Long_10xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_15xGABAa.total,CutMor_032_Long_15xGABAa.normpower,'Color',CutMor_032_Long_15xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_30xGABAa.total,CutMor_032_Long_30xGABAa.normpower,'Color',CutMor_032_Long_30xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)

ylim([0 1.05])
box off

formatter(xlabel('Total Charge Transfer per Connection (nC)'))
formatter(ylabel('Normalized Theta Power'))
formatter(gca)
bleg=legend({'Altered B kinetics','A component only, variable amp.','Slower kinetics','Control','Fast kinetics','Faster kinetics','Fastest kinetics','A only','A x3','A x10','A x15','A x30'},'Location','Best');
%bleg=legend({'Altered GABA_{B} kinetics','GABA_{A} only, variable amp.','GABA_{A,B,slower}','GABA_{A,B}','GABA_{A,B,fast}','GABA_{A,B,faster}','GABA_{A,B,fastest}','GABA_{A} only','GABA_{A} x3','GABA_{A} x10','GABA_{A} x15','GABA_{A} x30'},'Location','Best');
formatter(bleg);
set(bleg,'FontSize',10,'Position',[.65 .37 .3 .5],'EdgeColor',[1 1 1])

bgak=axes('Position',[.4 .2 .4 .4]);
plot(CutMor_032_Long.x,CutMor_032_Long.y*1000,'Color',CutMor_032_Long.color,'LineWidth',2)
hold on
plot(CutMor_032_Long_slowGABAb.x,CutMor_032_Long_slowGABAb.y*1000,'Color',CutMor_032_Long_slowGABAb.color,'LineWidth',2)
plot(CutMor_032_Long_halfGABAb.x,CutMor_032_Long_halfGABAb.y*1000,'Color',CutMor_032_Long_halfGABAb.color,'LineWidth',2)
plot(CutMor_032_Long_fourthGABAb.x,CutMor_032_Long_fourthGABAb.y*1000,'Color',CutMor_032_Long_fourthGABAb.color,'LineWidth',2)
plot(CutMor_032_Long_eighthGABAb.x,CutMor_032_Long_eighthGABAb.y*1000,'Color',CutMor_032_Long_eighthGABAb.color,'LineWidth',2)
plot(CutMor_032_Long_noGABAb.x,CutMor_032_Long_noGABAb.y*1000,'Color',CutMor_032_Long_noGABAb.color,'LineWidth',2)
plot(CutMor_032_Long_3xGABAa.x,CutMor_032_Long_3xGABAa.y*1000,'Color',CutMor_032_Long_3xGABAa.color,'LineWidth',2)
plot(CutMor_032_Long_10xGABAa.x,CutMor_032_Long_10xGABAa.y*1000,'Color',CutMor_032_Long_10xGABAa.color,'LineWidth',2)
plot(CutMor_032_Long_15xGABAa.x,CutMor_032_Long_15xGABAa.y*1000,'Color',CutMor_032_Long_15xGABAa.color,'LineWidth',2)
plot(CutMor_032_Long_30xGABAa.x,CutMor_032_Long_30xGABAa.y*1000,'Color',CutMor_032_Long_30xGABAa.color,'LineWidth',2)
plot([200 300],[4 4],'k','LineWidth',2)
plot([200 200],[4 6],'k','LineWidth',2)
text(195,5,'2 pA','HorizontalAlignment','right','FontName','ArialMT','FontWeight','bold')
text(200,3.5,'100 ms','HorizontalAlignment','left','FontName','ArialMT','FontWeight','bold')
plot([0 1000],[0 0],'k')

%bleg=legend({'GABA_{A,B}','GABA_{A,B,slow}','GABA_{A,B,fast}','GABA_{A,B,faster}','GABA_{A,B,fastest}','GABA_{A} only','GABA_{A} x3','GABA_{A} x10','GABA_{A} x15','GABA_{A} x30'},'Location','Best');
%formatter(bleg);
% bx=xlabel('Time (ms)');
% formatter(bx);set(bx,'FontSize',10);
% by=ylabel('Current (pA)');
% formatter(by);set(by,'FontSize',10);
%formatter(gca)
box off
axis off
set(gca,'Color','none');
set(gca,'XTickLabel',{})
set(gca,'XTick',[])
set(gca,'YTickLabel',{})
set(gca,'YTick',[])



h(2)=figure('Color','w','Units','inches','Position',[1 1 8 4]);
%subplot(3,1,3)
set(gca,'Position',[.1 .15 .5 .8]);
x1=[CutMor_032_Long.total CutMor_032_Long_slowGABAb.total CutMor_032_Long_halfGABAb.total CutMor_032_Long_fourthGABAb.total CutMor_032_Long_eighthGABAb.total];
y1=[CutMor_032_Long.peaktheta CutMor_032_Long_slowGABAb.peaktheta CutMor_032_Long_halfGABAb.peaktheta CutMor_032_Long_fourthGABAb.peaktheta CutMor_032_Long_eighthGABAb.peaktheta];
[x1, sortI]=sort(x1);
y1=y1(sortI);

x2=[CutMor_032_Long_noGABAb.total CutMor_032_Long_3xGABAa.total CutMor_032_Long_10xGABAa.total CutMor_032_Long_15xGABAa.total CutMor_032_Long_30xGABAa.total];
y2=[CutMor_032_Long_noGABAb.peaktheta CutMor_032_Long_3xGABAa.peaktheta CutMor_032_Long_10xGABAa.peaktheta CutMor_032_Long_15xGABAa.peaktheta CutMor_032_Long_30xGABAa.peaktheta];
[x2, sortI]=sort(x2);
y2=y2(sortI);

plot(x1,y1,'k','LineWidth',3)
hold on

plot(x2,y2,'Color',[.5 .5 .5],'LineWidth',3)

plot(CutMor_032_Long_slowGABAb.total,CutMor_032_Long_slowGABAb.peaktheta,'Color',CutMor_032_Long_slowGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long.total,CutMor_032_Long.peaktheta,'Color',CutMor_032_Long.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_halfGABAb.total,CutMor_032_Long_halfGABAb.peaktheta,'Color',CutMor_032_Long_halfGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_fourthGABAb.total,CutMor_032_Long_fourthGABAb.peaktheta,'Color',CutMor_032_Long_fourthGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_eighthGABAb.total,CutMor_032_Long_eighthGABAb.peaktheta,'Color',CutMor_032_Long_eighthGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_noGABAb.total,CutMor_032_Long_noGABAb.peaktheta,'Color',CutMor_032_Long_noGABAb.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_3xGABAa.total,CutMor_032_Long_3xGABAa.peaktheta,'Color',CutMor_032_Long_3xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_10xGABAa.total,CutMor_032_Long_10xGABAa.peaktheta,'Color',CutMor_032_Long_10xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_15xGABAa.total,CutMor_032_Long_15xGABAa.peaktheta,'Color',CutMor_032_Long_15xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)
plot(CutMor_032_Long_30xGABAa.total,CutMor_032_Long_30xGABAa.peaktheta,'Color',CutMor_032_Long_30xGABAa.color,'LineStyle','none','Marker','.','MarkerSize',30)

ylabel('Theta Frequency (Hz)')

function [peaktheta thetapower normpower]=gettheta(f,fft_results)
    theta_range=find(f(:)>=4 & f(:)<=12);%1:length(f);%
    [~, peak_idx] = max(fft_results(theta_range));
    peaktheta = f(theta_range(peak_idx));
    thetapower = fft_results(theta_range(peak_idx));
    normpower = thetapower/max(fft_results);
    

function formatter(ax,varargin)

if isempty(varargin)
    set(ax,'LineWidth',2,'FontName','ArialMT','FontWeight','bold','FontSize',14)  
elseif varargin{1}==0
    set(ax,'FontName','ArialMT','FontWeight','bold','FontSize',14)  
else
    set(ax,'FontName','ArialMT','FontWeight','bold','FontSize',14)  
end
box off
