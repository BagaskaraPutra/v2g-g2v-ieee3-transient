function fig = plot_controlGajduk(controlGajduk)
    fig = figure();
    subplot(2,1,1);
    plot(controlGajduk.Time, controlGajduk.Data(:,1), 'LineWidth', 2); grid on;
    title('Grid Frequency Deviation');
    ylabel('\Delta f_{grid} (Hz)');
    subplot(2,1,2);
    plot(controlGajduk.Time, controlGajduk.Data(:,2), 'LineWidth', 2); grid on;
    ylabel('I^{ref}_{bat} (A)');
    title('Battery Reference Current');
    xlabel('Time (seconds)');
end