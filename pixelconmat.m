function pixelconmat(conmat)

inrnbkt1=0:100:21200; % lump 21300-21309 into last bucket;
pyrbkt=[21310:1000:332000]; % last bucket only contains 2000-2809;
inrnbkt2=[332810:100:338710]; % lump in 711-739 into last bucket;
stimbkt=[338740:1000:793740]; % last bucket only has from 2740 - 3439 (700)
bktarray=[inrnbkt1 pyrbkt inrnbkt2 stimbkt];

inrnIND=[1:length(inrnbkt1) (length(inrnbkt1)+length(pyrbkt)+1):(length(inrnbkt1)+length(pyrbkt)+length(inrnbkt2))];
pyrIND=[(length(inrnbkt1)+1):(length(inrnbkt1)+length(pyrbkt))];
stimIND=[(length(inrnbkt1)+length(pyrbkt)+length(inrnbkt2)+1):length(bktarray)];


myind(1).inds = inrnIND;
myind(2).inds = pyrIND;
myind(3).inds = stimIND;

mylbl={'Inrn','Pyr','Stim'};

figure('Color','w')

for pre=1:3
    for post=1:2
        subplot(2,3,(post-1)*3+pre)
        imagesc(conmat(myind(pre).inds,myind(post).inds))
        ylabel(['Pre' mylbl{pre}])
        xlabel(['Post' mylbl{post}])
        colormap jet
        colorbar
        axis equal
        axis tight
        set(gca,'Ydir','normal')
    end
end