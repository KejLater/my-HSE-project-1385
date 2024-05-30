clc
clear

modulation_degree = 4;  % Кол-во битов на 1 символ
num_of_bits = 24;       % Кол-во битов
EbN0_dB = -4:1:0;        % Eb/No (dB)

ber_measured = zeros(size(EbN0_dB)); % Инициализация вектора результатов


for i = 1:length(EbN0_dB)
    
    disp(['==============  ',num2str(EbN0_dB(i)),'  ==============']); 
    
    EbN0_linear_i = 10^(EbN0_dB(i)/10);
    
    SNR = modulation_degree * EbN0_linear_i;

    noise_variance = 1 / (2 * SNR);

    % счетчик ошибок и битов
    Nerrs = 0;
    Nbits = 0;


    while Nerrs < 2000 && Nbits < 10e6
        
        msg = randi([0,1], num_of_bits, 1); % Генерация рандомных двоичных данных


        modulated = mapping(msg, modulation_degree); % модуляция
        
        % Прохождение через канал AWGN
        noised = modulated + sqrt(noise_variance) * randn(size(modulated)) * (1 + 1i);
        
        % Демодуляция зашумленного сигнала ('viterbi', 'hard', 'llr')
        demodulated = demap(noised, modulation_degree, noise_variance, 'hard');
        
        
        % Принятие жесткого решения для перевода LLR в биты
        LLR = llr_to_bit(demodulated);

        % Подсчет количества битовых ошибок
        Nerrors = sum(msg~=LLR);
        

        % Счетчики ошибок и битов
        Nerrs = Nerrs + Nerrors;
        Nbits = Nbits + num_of_bits;
        
    end

    % вычисление BER
    ber_measured(i) = Nerrs / Nbits;

end

% теор. BER при помощи berawgn 
ber_theoretical = berawgn(EbN0_dB, 'qam', 2^modulation_degree);


semilogy(EbN0_dB, ber_measured, '*')
hold on
semilogy(EbN0_dB, ber_theoretical)

grid
legend('Estimated BER', 'Theoretical BER')
title('BER comparison, BPSK-Viterbi, L=24')
xlabel('Eb/N0 (dB)')
ylabel('Bit Error Rate')