function fig = plot_controlFault(controlFault, Vfault_thresh)
    fig = figure();
    subplot(2,1,1);
    plot(controlFault.Time, controlFault.Data(:,1), 'LineWidth', 2); grid on;
    hold on;
    plot(controlFault.Time, Vfault_thresh*ones(length(controlFault.Time),1), '--','LineWidth', 2);
    title('Moving RMS Voltage');
    ylabel('Voltage (V)');
    legend('Measured','Threshold');
    subplot(2,1,2);
    plot(controlFault.Time, controlFault.Data(:,2), 'LineWidth', 2); grid on;
    ylabel('I^{ref}_{bat} (A)');
    title('Battery Reference Current');
    xlabel('Time (seconds)');
end