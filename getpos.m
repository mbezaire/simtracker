function pos = getpos(gid, gmin, BinInfo, ZHeight)

    BinInfo.BinNumYZ = BinInfo.BinNumY*BinInfo.BinNumZ;
    
    CellNum = gid - gmin+1;
	tmp = floor((CellNum-1)/BinInfo.BinNumYZ);
	pos.x =  mod(tmp,BinInfo.BinNumX)*BinInfo.binSizeX+BinInfo.binSizeX/2.0;

	tmp = floor((CellNum-1)/BinInfo.BinNumZ);
	pos.y =  mod(tmp,BinInfo.BinNumY)*BinInfo.binSizeY+BinInfo.binSizeY/2.0;

    pos.z = mod((CellNum-1),BinInfo.BinNumZ)*BinInfo.binSizeZ+BinInfo.binSizeZ/2+ZHeight;
