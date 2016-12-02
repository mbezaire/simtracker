function kinetics = getkinetics(timevec,tracevec,steptime)
global mypath sl

            before_idx = find(timevec>steptime,1,'first');
            if abs(tracevec(before_idx)-tracevec(end))>.01
                disp('Warning: baseline not stable,');
                disp('  changes by more than 10 pA over course of sim')
                disp(['  changes by: ' num2str((tracevec(before_idx)-tracevec(end))*1000) ' pA over course of sim'])
            end
            
            mydiffs=diff(tracevec(before_idx:end));
            
            verts=find(mydiffs(1:end-1).*mydiffs(2:end)<0);
            if length(verts)<1
                verts=find(mydiffs(1:end-1).*mydiffs(2:end)<=0);
            end
            if length(verts)<1
                mydiffs = mydiffs-mode(mydiffs);
                verts=find(mydiffs(1:end-1).*mydiffs(2:end)<0);
            end
            [~, peak_idx] = max(abs(tracevec(before_idx:end)-tracevec(before_idx)));
            peak_idx = peak_idx + before_idx - 1;
            disp(['first peak calc at: ' num2str(timevec(peak_idx)) ' ms, val: ' num2str(tracevec(peak_idx))])

            peak_idx2=verts(1)+before_idx;
            disp(['second peak calc at: ' num2str(timevec(peak_idx2)) ' ms, val: ' num2str(tracevec(peak_idx2))])

            change_idx = find(abs(diff(tracevec(before_idx:end)))>.05*max(abs(diff(tracevec(before_idx:end)))),1,'first') + before_idx-1;
            
            if tracevec(peak_idx)>tracevec(before_idx)
                [~, myi]=min(tracevec(peak_idx:end));
            else
                [~, myi]=max(tracevec(peak_idx:end));
            end
            after_idx=myi+peak_idx-1; % added these two lines for case where baseline RMP just keeps rising (with PSC on top)
            
            kinetics.idxes = [change_idx peak_idx after_idx];
            kinetics.change_idx =  change_idx;
            kinetics.peak_idx = peak_idx;
            kinetics.peak = timevec(peak_idx) - timevec(change_idx);

            % 10 - 90 rise time
            compdata = tracevec - tracevec(change_idx);
            per10_val = .1*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
            per10_idx = find(abs(compdata(change_idx:peak_idx))>=abs(per10_val),1,'first')+change_idx-1;

            per90_val = .9*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
            per90_idx = find(abs(compdata(change_idx:peak_idx))>=abs(per90_val),1,'first')+change_idx-1;
            kinetics.rt_10_90 = timevec(per90_idx) - timevec(per10_idx);
            
            kinetics.amplitude=abs(tracevec(peak_idx)-tracevec(change_idx));

            % width at half amplitude
            per50_val = .5*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
            try
            halfup_idx = find(abs(compdata(before_idx:after_idx))>=abs(per50_val),1,'first')+before_idx-1;
            catch
                'r'
            end
            halfdown_idx = find(abs(compdata(before_idx:after_idx))>=abs(per50_val),1,'last')+before_idx-1;
            kinetics.halfwidth = timevec(halfdown_idx) - timevec(halfup_idx);

            % rise time constant
            erise_val = (1-1/exp(1))*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
            taurise_idx = find(abs(compdata(before_idx:after_idx))>=abs(erise_val),1,'first')+before_idx-1;
            kinetics.taurise = timevec(taurise_idx) - timevec(change_idx);

            % decay time constant
            edecay_val = (1/exp(1))*(compdata(peak_idx) - compdata(after_idx))+compdata(after_idx);
            taudecay_idx = find(abs(compdata(before_idx:after_idx))>=abs(edecay_val),1,'last')+before_idx-1;
            kinetics.taudecay = timevec(taudecay_idx) - timevec(peak_idx);
