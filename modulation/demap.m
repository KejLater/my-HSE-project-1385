function demapped = demap(modulated, modulation_degree, noise, method)


%  modulated - модулированные символы
%  modulation_degree - порядок модуляции (1 - BPSK, 2 - QPSK, 4 - QAM16, 6 - QAM64, 8 - QAM256)
%  method - метод вычисления: 
%  "hard" - жесткое решение,
%  "viterbi" - алгоритм Витерби, 
%  "llr" - логарифмическое отношение правдоподобия без аппроксимации


    demapped = zeros(length(modulated) * modulation_degree, 1);
    switch modulation_degree
        case 1
            data = load('modulation.mat').BPSK;
            first = load('modulation.mat').S0_BPSK;
            second = load('modulation.mat').S1_BPSK;

        case 2
            data = load('modulation.mat').QPSK;
            first = load('modulation.mat').S0_QPSK;
            second = load('modulation.mat').S1_QPSK;

        case 4
            data = load('modulation.mat').QAM16;
            first = load('modulation.mat').S0_16QAM;
            second = load('modulation.mat').S1_16QAM;

        case 6
            data = load('modulation.mat').QAM64;
            first = load('modulation.mat').S0_64QAM;
            second = load('modulation.mat').S1_64QAM;

        case 8
            data = load('modulation.mat').QAM256;
            first = load('modulation.mat').S0_256QAM;
            second = load('modulation.mat').S1_256QAM;

    end

    switch lower(method)
        case 'hard'
            for i = 1 : length(modulated)
              for q = 1 : modulation_degree
                p0 = min( abs(modulated(i) - data(first(q,:))).^2 );
                p1 = min( abs(modulated(i) - data(second(q,:))).^2 );
                if p0 > p1
                  demapped(modulation_degree*i-q+1) = - 1/noise;
                else
                  demapped(modulation_degree*i-q+1) = 1/noise;
                end
              end
            end

        case 'viterbi'
            for i = 1 : length(modulated)
              for q = 1 : modulation_degree
                p0 = min( abs(modulated(i) - data(first(q,:))).^2 );
                p1 = min( abs(modulated(i) - data(second(q,:))).^2 );
                demapped(modulation_degree*i-q+1) = -1 * (1 / noise) *  (p0 - p1);
              end
            end

        case 'llr'
            for i = 1 : length(modulated)
                for q = 1 : modulation_degree
                    p0 = sum( exp(-abs(modulated(i) - data(first(q,:))).^2 / noise) );
                    p1 = sum( exp(-abs(modulated(i) - data(second(q,:))).^2 / noise) );
                    demapped(modulation_degree*i-q+1) = check_log(p0) - check_log(p1);
                end
            end
    end
end