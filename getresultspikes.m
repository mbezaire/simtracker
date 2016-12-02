for r=1:10
    stimval(r).stim=r*5;
    for z={'Super','Deep'}
        eval(['mySTRUCT=Stim' z{:} '_' sprintf('%02.0f',r) ';']);
        stimval(r).(z{:}).superspikes=mySTRUCT.spikerast(mySTRUCT.spikerast(:,3)==0,1:2);
        stimval(r).(z{:}).deepspikes=mySTRUCT.spikerast(mySTRUCT.spikerast(:,3)==1,1:2);
        stimval(r).(z{:}).pvbcspikes=mySTRUCT.spikerast(mySTRUCT.spikerast(:,3)==2,1:2);
    end
end

for r=1:10
    eval(['mySTRUCT=StimSuper_' sprintf('%02.0f',r) ';']);
    Super(r).superspikes=length(find(mySTRUCT.spikerast(:,3)==0));
    Super(r).deepspikes=length(find(mySTRUCT.spikerast(:,3)==1));
    Super(r).pvbcspikes=length(find(mySTRUCT.spikerast(:,3)==2));
    
    eval(['mySTRUCT=StimDeep_' sprintf('%02.0f',r) ';']);
    Deep(r).superspikes=length(find(mySTRUCT.spikerast(:,3)==0));
    Deep(r).deepspikes=length(find(mySTRUCT.spikerast(:,3)==1));
    Deep(r).pvbcspikes=length(find(mySTRUCT.spikerast(:,3)==2));
end