function fig = plot_battery_VDC(battery, VDC)
    fig = figure();
    subplot(2,2,1);
    plot(battery.SOC____.Time, battery.SOC____.Data); grid on;
    title('Battery SOC');
    ylabel('SOC (%)');
    subplot(2,2,2);
    plot(battery.Current__A_.Time, battery.Current__A_.Data); grid on;
    ylabel('I_{batt} (A)');
    title('Battery Current');
    subplot(2,2,3);
    plot(battery.Voltage__V_.Time, battery.Voltage__V_.Data); grid on;
    ylabel('V_{batt} (V)');
    title('Battery Voltage');
    xlabel('Time (seconds)');
    subplot(2,2,4);
    plot(VDC.Time, VDC.Data); grid on;
    ylabel('V_{DC} (V)');
    title('DC Link Voltage');
    xlabel('Time (seconds)');
end