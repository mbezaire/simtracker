% import celltype data as cells
% import connections as data

for r=1:length(cells)
    pre=find(data(:,1)>=cells(r,2) & data(:,1)<=cells(r,3));
    data(pre,4)=r;
    post=find(data(:,2)>=cells(r,2) & data(:,2)<=cells(r,3));
    data(post,5)=r;
end

for r=1:length(cells)
    tmp_inputs = [];
    tmp_outputs = [];
    for k=cells(r,2):cells(r,3)
        % inputs
        postcell = find(data(:,2)==k);
        inputs = data(postcell,4);
        num_in=histc(inputs,1:length(cells));
        tmp_inputs(size(tmp_inputs,1)+1,:)=num_in';

        
        
        % outputs        
        precell = find(data(:,1)==k);
        outputs = data(precell,5);
        num_out=histc(outputs,1:length(cells));
        tmp_outputs(size(tmp_outputs,1)+1,:)=num_out';
    end

    disp(['--  ' textdata{1+r,1} ' inputs  --' ])
    for z=1:length(cells)
        disp([textdata{1+z,1} ' mean: ' num2str(mean(tmp_inputs(:,z))) ' +/- ' num2str(std(tmp_inputs(:,z)))])
    end
    disp(['               -' ])

    disp(['--  ' textdata{1+r,1} ' outputs  --' ])
    for z=1:length(cells)
        disp([textdata{1+z,1} ' mean: ' num2str(mean(tmp_outputs(:,z))) ' +/- ' num2str(std(tmp_outputs(:,z)))])
    end
    disp(['               -' ])
end

