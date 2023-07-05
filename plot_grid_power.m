function fig = plot_grid_power(grid_power)
    fig = figure();
    subplot(2,1,1);
    plot(grid_power.Time, grid_power.Data(:,1), 'LineWidth', 2); grid on;
    title('Grid Active & Reactive Power');
    ylabel('Active Power P (W)');
    subplot(2,1,2);
    plot(grid_power.Time, grid_power.Data(:,2), 'LineWidth', 2); grid on;
    ylabel('Reactive Power Q (VA)');
    xlabel('Time (seconds)');
end