

function noised = rician(signal, SNR_dB, k_factor)
    
    % signal - модулированный сигнал
    % SNR_dB - шум в дБ
    % k_factor - коэф. Райса (ie 10)
    
    mean = sqrt(k_factor / (k_factor+1));  
    variance = sqrt(1 / (2*(k_factor+1)));  
    Nr2 = randn(1, length(signal)) * variance + mean;
    Ni2 = randn(1, length(signal)) * variance;
    RFC = sqrt(Nr2 .^ 2 + Ni2 .^ 2);  % коэф затухания
    
    snr_linear = 10 ^ (SNR_dB/10);  % dB в "разы"
    
    
    
    noise_variance = 1 / (2 * snr_linear);

    t1=signal .* RFC + sqrt(noise_variance) * randn(size(signal)) * (1 + 1i); % s means transmitted signal
    z1=t1 ./ RFC;  % нормировка
    noised = (z1 > 0); 
end

