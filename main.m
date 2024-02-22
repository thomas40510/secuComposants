%%%%%%%%%%%%% Main script %%%%%%%%%%%%%
%--- This script is the one to run ---%
clc;
close all;
nb_traces = 20000;
%% load traces
load_data();

%% plot first trace
fprintf(">>> Plotting first trace <<<\n")
plot_trace();
fprintf("-- done --\n")

%% plot avg
fprintf(">>> Plotting average trace <<<\n")
plot_average_trace(traces);
hold on;
xline(1123, "--b", "Round 1");
xline(3131, "--k", "Dernier round");
hold off;
fprintf("-- done --\n")

%% generate possible keys
fprintf(">>> Computing possible keys <<<\n")
generate();
fprintf("-- done --\n")

%% hamming weight attack
fprintf(">>> Hamming weight attack <<<\n")
hamming_weight_attack();
fprintf("-- done --\n")

%% key to get
fprintf("==============\n")
fprintf(">>> Attack result <<<\n")

disp("key to get is ")
key = '4C8CDF23B5C906F79057EC7184193A67';
disp(key)
key_dec = zeros(16, 1);
for i = 1:16
    key_dec(i) = hex2dec(key((2*i)-1 : 2*i));
end

w = uint8(zeros(11, 4, 4));
w(1, :, :) = reshape(key_dec, 4, 4);

for i = 1:10
    w(i+1, :, :) = key_schu(squeeze(w(i, :, :)), i);
end

key_to_get = squeeze(w(11, :, :));
disp("key to get is ")
disp(key_to_get)

disp("best candidate is ")
disp(reshape(best_candidate, 4, 4))

disp("matching values :")
disp(sum(sum(key_to_get == reshape(best_candidate, 4, 4))))