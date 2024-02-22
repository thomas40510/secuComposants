%%%%% Extract last round (2700,3200) %%%%%
function [last_round, avg_last] = last_round(traces)
    % extract last round
    last_round = zeros(20000, 3200 - 2700 + 1);
    for i = 1:20000
        last_round(i,:) = traces(i, 2700:3200);
    end
    avg_last = mean(last_round);
end