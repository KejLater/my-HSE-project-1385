
function noised = rayleigh(signal, SNR_dB)

    n = length(signal);  % длина сообщения
    
    snr_linear = 10 ^ (SNR_dB/10);
    noise_variance = 1 / (2 * snr_linear);

   
    h = 1/sqrt(2) * [randn(1,n) + 1i*randn(1,n)];  % Rayleigh channel
    y = h.*signal +  + sqrt(noise_variance) * randn(size(signal)) * (1 + 1i);  % канал Релея
    yHat = y./h;  % нормализация
    noised = real(yHat)>0;  % полученные значения, жесткие решения
    

end