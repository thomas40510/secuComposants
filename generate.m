%%%%% Generate possible states %%%%%
X = zeros(nb_traces, 16);
for k = 1:nb_traces
    X(k, :) = ctos(k, :);
end
gen = uint8(zeros(nb_traces, 256, 16));
gen_xor = uint8(zeros(nb_traces, 256, 16));
gen_shift = uint8(zeros(nb_traces, 256, 16));
gen_sbox = uint8(zeros(nb_traces, 256, 16));

for trace = 1:nb_traces
    for possibility = 1:256
        for val = 1:16
            gen(trace, possibility, val) = uint8(X(trace, val));
        end
    end
end

for trace = 1:nb_traces
    for possibility = 1:256
        for val = 1:16
            gen_xor(trace, possibility, val) = uint8(bitxor(gen(trace, possibility, val), uint8(possibility - 1)));
        end
    end
end

% shift rows
shiftRow = [1 6 11 16 5 10 15 4 9 14 3 8 13 2 7 12];
invShiftRow = [1 14 11 8 5 2 15 12 9 6 3 16 13 10 7 4];

for trace = 1:nb_traces
    for possibility = 1:256
        for val = 1:16
            gen_shift(trace, possibility, val) = gen_xor(trace, possibility, invShiftRow(val));
        end
    end
end

sBox = SBox();
invSBox(sBox(1:256) + 1) = 0:255;
for trace = 1:nb_traces
    for possibility = 1:256
        for val = 1:16
            gen_sbox(trace, possibility, val) = uint8(invSBox(gen_shift(trace, possibility, val) + 1));
        end
    end
end