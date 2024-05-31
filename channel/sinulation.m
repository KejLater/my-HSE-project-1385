


n = 1000000;   
SNR_dB = -10:10;
bits = randi([0,1],1,n); 
signal = mapping(bits, 1)';

BER = [];

for snr = SNR_dB
    %noised = rician(signal, snr, 10);
    noised = rayleigh(signal, snr);
    BER(end+1) = sum(xor(noised,bits))/n;
end

scatter(SNR_dB, BER, '*');
set(gca, 'Yscale', 'log');
hold on;
title('BER for BPSK modulation in Rayleigh channel');grid on;
xlabel('SNR (dB)');
ylabel('BER');
%legend('Rician');
