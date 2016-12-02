function BinInfo = setBins(numCells,LongitudinalLength,TransverseLength,LayerLength)	% Defines the proc setBins,
														%  which takes the arguments
														%  for the length of the 
														%  brain region in X, Y, and Z,
														%  and determines how far apart
														%  the cells should be in each
														%  dimension to be evenly spaced

    BinNumZ=max(floor((numCells*(LayerLength)^2/(TransverseLength*LongitudinalLength))^(1/3)),1);
    % Given the relative length of
    %  the Z dimension compared to
    %  the X and Y dimensions, solve
    %  for how many cells should be 
    %  spaced along the z dimension 

    % Make sure the Z dimension is at least one cell wide

    BinNumY=max(floor((TransverseLength/LayerLength)*(numCells*(LayerLength)^2/(TransverseLength*LongitudinalLength))^(1/3)),1);
    % Given the relative
    %  length for Y...

    % Make sure the Y dimension is at least one cell wide

    BinNumX=max(floor((LongitudinalLength/LayerLength)*(numCells*(LayerLength)^2/(TransverseLength*LongitudinalLength))^(1/3)),1);
    % Given the relative
    %  length for X...

    % Make sure the Z dimension is at least one cell wide

    % The above code may result in there being slightly too few or too many positions
    %  set aside for cells. To make the final spacing along each dimension most closely,
    %  match the total number of cells of this type, we may either increase or decrease
    %  the number of cells assigned along each edge as follows

    % Find the largest dimension (which is the ideal dimension to change if the number
    %  of cell assignments is too large or too small) 								
    if (LayerLength >= TransverseLength && LayerLength >= LongitudinalLength)
        strtomax='BinNumZ';
        numtomin=BinNumX*BinNumY;
    elseif (TransverseLength >= LayerLength && TransverseLength >= LongitudinalLength)
        strtomax='dentateYBins';
        numtomin=BinNumX*BinNumZ;
    else
        strtomax='BinNumX';
        numtomin=BinNumY*BinNumZ;
    end

    while (BinNumX*BinNumY*BinNumZ < numCells)	% If not enough cell
                                                                %  positions are allotted
        eval([strtomax '=' strtomax '+1;'])
        % Add another slot to
        %  the largest dimension
    end


    toohigh=BinNumX*BinNumY*BinNumZ-numtomin;

    while (toohigh >= numCells)				
        % If too many cell positions were allotted
        % Remove one from the largest dimension

        eval([strtomax '=' strtomax '-1;'])

        toohigh=BinNumX*BinNumY*BinNumZ-numtomin;
    end

    BinInfo.binSizeZ = floor(LayerLength/BinNumZ);	% Length of each cell's 'personal space' (along Z dimension) in microns

    BinInfo.binSizeY = floor(TransverseLength/BinNumY);	% Length of each cell's 'personal space' (along Y dimension) in microns

    BinInfo.binSizeX = floor(LongitudinalLength/BinNumX);	% Length of each cell's 'personal space' (along X dimension) in microns

    BinInfo.BinNumX = BinNumX;
    BinInfo.BinNumY = BinNumY;
    BinInfo.BinNumZ = BinNumZ;
    

