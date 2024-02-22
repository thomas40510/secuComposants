%%%%% Compute and plot average of traces %%%%%
function plot_average_trace(traces)
    avg = mean(traces);
    plot(avg);
    xlabel('Time');
    ylabel('Amplitude');
    title('Average trace');
end