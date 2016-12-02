
n=2;

grr=load([mypath sl 'data' sl 'DetailedData' sl mycell(n).DetailedData '.mat']);

for f=1:length(grr.(mycell(n).DetailedData).AxoClampData.Time)
    figure('Name',['Cell # ' num2str(n) ', Trace # ' num2str(f)]);
    subplot(2,1,1);
    plot(grr.(mycell(n).DetailedData).AxoClampData.Time(f).Data,grr.(mycell(n).DetailedData).AxoClampData.Data(f).RecordedVoltage)
    title('Voltage')

    subplot(2,1,2);
    plot(grr.(mycell(n).DetailedData).AxoClampData.Time(f).Data,grr.(mycell(n).DetailedData).AxoClampData.Data(f).CurrentInjection)
    title('Current')
end