function Thresh = getThreshold(Data,spkidx,previdx,rez,type,threshparams)

switch type
    case 1
        % change in dV/dt (Atherton and Bevan 2005)
        % take the dV/dt of the voltage trace, and take the SD of the dV/dt for 50 ms before the AP
        % The threshold is reached once the dV/dt reaches: mean(dV/dt)
        % +2*SD(dV/dt)  in units of V/s (or mV/ms)
        previdx = max(spkidx - round(50/rez),previdx);
        [~, mini] = min(Data(previdx:spkidx));
        stidx = previdx + mini-1;
        dVdt = diff(Data(stidx:spkidx))/rez;
        grr=0;
        Thresh=[];
        %while isempty(Thresh)
            Thresh = find(dVdt>=(mean(dVdt)+(threshparams(1)-grr)*std(dVdt)),1,'first')+ stidx - 1;
        %    grr = grr + .1;
        %end
%         if grr>0
%             disp(['For Thresh #1, used a std multiplier of ' num2str(2-grr)])
%         end
    case 2
        % dV/dt threshold (Cooper et al. 2003; Metz et al. 2005)
        % set a cutoff point of the dV/dt, such as 30 mV/ms, as the AP threshold (Fig. 2A, dotted line)
        previdx = max(spkidx - round(50/rez),previdx);
        [~, mini] = min(Data(previdx:spkidx));
        stidx = previdx + mini-1;
        dVdt = diff(Data(stidx:spkidx))/rez;
        Thresh=[];
        %while isempty(Thresh)
            cutoff = threshparams(2);
            tmpT=find(dVdt>=cutoff,1,'first');
            if isempty(tmpT)
                Thresh=[];
            elseif tmpT==1
                    Thresh = tmpT+ stidx - 1;
            else
                % dVdt is in between two points, so check which side cut-off is
                % closer to
                if cutoff-dVdt(tmpT-1)<dVdt(tmpT)-cutoff
                    Thresh = tmpT+ stidx - 2;
                else
                    Thresh = tmpT+ stidx - 1;
                end
            end
        %    grr = grr + 1;
        %end
%         if grr>0
%             disp(['For Thresh #2, used a cutoff of ' num2str(cutoff)])
%         end
    case 3
        % maximum of second derivative (Mainen et al. 1995)
        % take the maximum of the second derivative of the voltage trace with respect to time (Fig. 2A, gray line)
        previdx = max(spkidx - round(50/rez),previdx);
        [~, mini] = min(Data(previdx:spkidx));
        stidx = previdx + mini-1;
        dV2d2t = diff(diff(Data(stidx:spkidx)));
        [~, maxi] = max(dV2d2t);
        Thresh = maxi + stidx;
        
%     case 1
%         Thresh = find(diff(Data(previdx:spkidx))>=.5*max(diff(Data(previdx:spkidx))),1,'first') + previdx - 2; % .22
%     case 2
%         [~, mini] = min(Data(previdx:spkidx));
%         b = find(Data(previdx+mini+10:spkidx)<=-15,1,'last') + mini + previdx + 9;
%         newmini = round((mini + previdx + 9 + b)/2);
%         mydiff = Data(newmini:spkidx); %diff(Data(newmini:spkidx));
%         mysz = 3;
%         for z = (mysz+1):length(mydiff)-mysz
%             laterpart(z-mysz) = mean(mydiff(z:(z+mysz-1)));
%             earlypart(z-mysz) = mean(mydiff((z-mysz):(z-1)));
%             mydiff(z-mysz) = mean(mydiff(z:(z+mysz-1))) - mean(mydiff((z-mysz):(z-1)));
%         end
%         [~, tmp] = max(mydiff);
%         Thresh = tmp + newmini + mysz; %9;
%     case 3
%         [~, mini] = min(Data(previdx:spkidx));
%         b = find(Data(previdx+mini+10:spkidx)<=-15,1,'last') + mini + previdx + 9;
%         newmini = round((mini + previdx + 9 + b)/2);
%         mydiff = Data(newmini:spkidx); %diff(Data(newmini:spkidx));
%         mysz = 3;
%         for z = (mysz+1):length(mydiff)-mysz
%             laterpart(z-mysz) = mean(mydiff(z:(z+mysz-1)));
%             earlypart(z-mysz) = mean(mydiff((z-mysz):(z-1)));
%             mydiff(z-mysz) = mean(mydiff(z:(z+mysz-1))) - mean(mydiff((z-mysz):(z-1)));
%         end
%         tmp = find(mydiff>.5*max(mydiff),1,'first');
%         Thresh = tmp + newmini + mysz; %9;
%     case 4
%         [~, mini] = min(Data(previdx:spkidx));
%         [~, maxi] = max(diff(diff(Data((mini+previdx):spkidx))));
%         Thresh = maxi + previdx + mini - 1;
%     case 5
%         [~, mini] = min(Data(previdx:spkidx));
%         [~, maxi] = max(diff(diff(Data((mini+previdx):spkidx))));
%         Thresh = maxi + previdx + mini - 2;
%     case 6
%         [~, mini] = min(Data(previdx:spkidx));
%         b = find(Data(previdx+mini+10:spkidx)<=-15,1,'last') + mini + previdx + 9;
%         newmini = round((mini + previdx + 9 + b)/2);
%         diffvec = diff(Data(newmini:b));
%         meandiff = cummean(diffvec);
%         Thresh = [];
%         w=0;
%         while isempty(Thresh)
%             Thresh = find([diffvec(6:end-1)>(4-w)*meandiff(5:end-2) & diffvec(7:end)>(4-w)*meandiff(5:end-2)],1,'first') + newmini-1+5;
%             w = w + .5;
%         end
%     case 7
%         [~, mini] = min(Data(previdx:spkidx));
%         b = find(Data(previdx+mini+10:spkidx)<=-15,1,'last') + mini + previdx + 9;
%         newmini = round((mini + previdx + 9 + b)/2);
%         diffvec = diff(Data(newmini:b));
%         meandiff = diffvec; %cummean(diffvec);
%         Thresh = [];
%         w=0;
%         while isempty(Thresh)
%             Thresh = find([diffvec(6:end-1)>(7-w)*meandiff(5:end-2) & diffvec(7:end)>(7-w)*meandiff(5:end-2)],1,'first') + newmini-1+5;
%             w = w + .5;
%         end
%         %if isempty(Thresh), Thresh = spkidx; end %find((diffvec(6:end)-meandiff(5:end-1))./meandiff(5:end-1)>2.7,1,'first') + newmini-1+5; end
%     case 8
%         [~, mini] = min(Data(previdx:spkidx));
%         b = find(Data(previdx+mini+10:spkidx)<=-15,1,'last') + mini + previdx + 9;
%         newmini = round((mini + previdx + 9 + b)/2);
%         diffvec = diff(Data(newmini:b));
%         meandiff = diffvec; %cummean(diffvec);
%         Thresh = [];
%         w=0;
%         while isempty(Thresh)
%             Thresh = find([(4-w)*meandiff(5:end-2)<diffvec(6:end-1) & (4-w)*meandiff(5:end-2)<diffvec(7:end)],1,'last') + newmini-1+5;
%             w = w + .5;
%         end
end
if Data(Thresh)>-15
    Thresh
end