%%%%% Plot trace nbr 1 %%%%%
plot(traces(1,:));
xlabel('Time');
ylabel('Amplitude');
title('First trace');
hold on;
xline(360, "--b", "Round 1");
xline(3510, "--b", "Dernier round");
hold off;