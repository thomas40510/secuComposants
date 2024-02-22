%%%%% Hamming weight attack using generated keys %%%%%
hw_vector = [0 1 1 2 1 2 2 3 1 2 2 3 2 3 3 4 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 4 5 5 6 5 6 6 7 5 6 6 7 6 7 7 8];
hamming = uint8(zeros(nb_traces, 256, 16));
traces_last = extract_last_round(traces);
for j = 1:256
    for k = 1:16
        hamming(:, j, k) = bitxor(gen_sbox(:, j, k), uint8(X(:, k))); % hamming weight of the difference between the generated ctos and the real ctos
    end
end

phi = hw_vector(hamming + 1);

best_candidate = zeros(16, 1);
lastRound = 2700:3200;
figure
sgtitle("Hamming weight correlation")
for k = 1:16
    % Iterate over values and compute correlation to identify the best candidate
    cor = mycorr(double(phi(1:nb_traces, :, shiftRow(k))), double(traces_last(1:nb_traces, :)));

    [max_cor, max_cor_index] = sort(max(abs(cor), [], 2), 'descend');
    best_candidate(k) = max_cor_index(1) - 1; % the best candidate is the one with the highest correlation
    fprintf("best candidate for byte %d is %d\n", k, best_candidate(k))

    %plot result
    subplot(4, 4, k)
    plot(lastRound, cor(:, :))
    title("k=" + num2str(k))
    xlabel('echantillon')
    ylabel('correlation')

end