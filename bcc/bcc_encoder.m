function encoded = bcc_encoder(bits, rate)



    g1 = int8([1 0 1 1 0 1 1]);
    g2 = int8([1 1 1 1 0 0 1]);
    
    register = cast(zeros(1, 7), 'int8');
    
    encoded = cast(zeros(size(bits, 1)*2, size(bits, 2)), 'int8');
    
    for j = 1:size(bits, 2)
        temp = [];
        for p = 1:size(bits, 1)
            register = [bits(p, j) register(1:6)];
            first_sum = mod(sum(register .* g1), 2);
            second_sum = mod(sum(register .* g2), 2);
            temp = [temp first_sum second_sum];
        end
        encoded(:, j) = temp;
    end
    
    % выкалывание
    switch rate
        case 1/2
            puncture = 0;

        case 2/3
            puncture = [1 1 1 0]';

        case 3/4
            puncture = [1 1 1 0 0 1]';

        case 5/6
            puncture = [1 1 1 0 0 1 1 0 0 1]';
    end
    
    
    seq = zeros(0, 1);
    j = 0;

    if rate ~= 1/2
        for k = 1:size(encoded, 2)
            for p = 1:size(encoded, 1)
                j = j + 1;
                if puncture(j, 1) == 1
                    seq = [seq; encoded(p, k)];
                end

                if j == length(puncture)
                    j = 0;
                end
            end
        end
        encoded = seq;
    end
end