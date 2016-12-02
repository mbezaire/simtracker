function compexp(handles)

expsyns = expsyndata();

precells = fieldnames(expsyns);
for p=1:length(precells)
    postcells = fieldnames(expsyns.(precells{p}));
    for r=1:length(postcells)
        if strcmp(expsyns.(precells{p}).(postcells{r}).Clamp,'Voltage')
            
            % set the connection type   
            nm = [precells{p} '->' postcells{p}];
            cs = get(handles.list_conn, 'String');
            set(handles.list_conn, 'Value', strmatch(nm,cs));
                        
            % set the clamp type
            set(handles.chk_connpair,'Value',1);
            set(handles.chk_currpair,'Value',0);
            
            % set the start time and duration
            set(handles.txt_pairstart,'String',num2str(15));
            set(handles.txt_pairend,'String',num2str(100));
            
            % set the holding potential
            set(handles.txt_post,'String',num2str(expsyns.(precells{p}).(postcells{r}).Holding));
            
            % set the reversal potential (and not auto)
            set(handles.radio_set,'Value',1);
            set(handles.txt_rev,'String',num2str(expsyns.(precells{p}).(postcells{r}).Reversal));
           
            % add a comment
            cm = [precells{p}{1:3} ' -> ' postcells{p}{1:3} ': ' expsyns.(precells{p}).(postcells{r}).ref];
            
            % run the code
            btn_run_Callback(handles.btn_run, [], handles,cm)
            
        else % Current
            % set(handles.txt_pre,'String',num2str(expsyns.(precells{p}).(postcells{r}).ModelCur));
        end
    end   
end
