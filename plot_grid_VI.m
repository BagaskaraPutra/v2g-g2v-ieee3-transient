function fig = plot_grid_VI(grid_VI)
    fig = figure();
    subplot(2,1,1);
    plot(grid_VI.Time, grid_VI.Data(:,1:3), 'LineWidth', 2); grid on;
    title('Grid Voltage & Current');
    ylabel('Voltage (V)');
    subplot(2,1,2);
    plot(grid_VI.Time, grid_VI.Data(:,4:6), 'LineWidth', 2); grid on;
    ylabel('Current (A)');
    xlabel('Time (seconds)');
end