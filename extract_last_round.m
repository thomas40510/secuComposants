%%%%%%%
% extract traces corresponding to the last round
%%%%%%%
function [traces_last] = extract_last_round(traces)
    % extract traces corresponding to the last round
    traces_last = zeros(20000, 3200 - 2700 + 1);
    for i = 1:20000
        traces_last(i,:) = traces(i, 2700:3200);
    end
end