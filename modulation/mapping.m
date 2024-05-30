function modulated = mapping(bits, modulation_index, varargin)

    % Функция mapping осуществляет модуляцию передаваемой битовой
    % последовательности в зависимости от количества бит на поднесущую частоту

    % modulation_index - количество бит на поднесущую частоту, принимает одно из значений 1, 2, 4, 6, 8
    
    % Выходные аргументы:
    % modulated - модулированная последовательность бит

    switch modulation_index
        case 1  % BPSK
            i_symbols = [-1; 1];
            modulated = complex(i_symbols(bits+1));

        case 2 % QPSK
            
            i_symbols = [[0; 1], [-1; 1]]; 
            q_symbols = [[0; 1], [-1; 1]];
            modulated = zeros(size(bits,1) / modulation_index, 1);
            j = 1;
            for i = 1:2:size(bits,1)
                temp_i = nonzeros(ismember(i_symbols(:,1), bits(i)) .* i_symbols(:,2));
                temp_q = nonzeros(ismember(q_symbols(:,1), bits(i+1)) .* q_symbols(:,2));
                modulated(j) = temp_i + 1i*temp_q;
                j = j + 1;
            end

            modulated = modulated * sqrt(0.5);
                
        case 4  % QAM16
            
            i_symbols = [[0; 1; 3; 2], [-3; -1; 1; 3]];
            q_symbols = [[0; 1; 3; 2], [-3; -1; 1; 3]];
            modulated = zeros(size(bits,1) / modulation_index, 1);
            j = 1;
            for i = 1:4:size(bits,1)
                temp_i = 2*bits(i) + bits(i+1);
                temp_i = nonzeros(ismember(i_symbols(:,1), temp_i) .* i_symbols(:,2));
                temp_q = 2*bits(i+2) + bits(i+3);
                temp_q = nonzeros(ismember(q_symbols(:,1), temp_q) .* q_symbols(:,2));
                modulated(j) = temp_i + 1i*temp_q;
                j = j + 1;
            end

            modulated = 1/sqrt(10) * modulated;

        case 6 % QAM64
            
            i_symbols = [[0; 1; 3; 2; 6; 7; 5; 4], [-7; -5; -3; -1; 1; 3; 5; 7]];
            q_symbols = [[0; 1; 3; 2; 6; 7; 5; 4], [-7; -5; -3; -1; 1; 3; 5; 7]];
            modulated = zeros(size(bits,1)/modulation_index, 1);

            j = 1;

            for i = 1:6:size(bits,1)

                temp_i = 4*bits(i) + 2*bits(i+1)+bits(i+2);
                temp_i = nonzeros(ismember(i_symbols(:,1), temp_i) .* i_symbols(:,2));
                temp_q = 4*bits(i+3) + 2*bits(i+4)+bits(i+5);
                temp_q = nonzeros(ismember(q_symbols(:,1), temp_q) .* q_symbols(:,2));
                modulated(j) = temp_i + 1i*temp_q;
                j = j + 1;

            end

            modulated = 1/sqrt(42) * modulated;
        
        case 8  % QAM256
            
            q_symbols = [[0; 1; 3; 2; 6; 7; 5; 4; ...
                          12; 13; 15; 14; 10; 11; 9; 8], ...
                         [-15; -13; -11; -9; -7; -5; -3; -1; ...
                            1; 3; 5; 7; 9; 11; 13; 15]];
            
            i_symbols = [[0; 1; 3; 2; 6; 7; 5; 4; ...
                          12; 13; 15; 14; 10; 11; 9; 8], ...
                        [-15; -13; -11; -9; -7; -5; -3; -1; ...
                1; 3; 5; 7; 9; 11; 13; 15]];

            modulated = zeros(size(bits,1)/modulation_index, 1);

            j = 1;
            
            for i = 1:8:size(bits,1)
                temp_i = 8*bits(i) + 4*bits(i+1) + 2*bits(i+2)+bits(i+3);
                temp_i = nonzeros(ismember(i_symbols(:,1), temp_i) .* i_symbols(:,2));
                temp_q = 8*bits(i+4) + 4*bits(i+5) + 2*bits(i+6) + bits(i+7);
                temp_q = nonzeros(ismember(q_symbols(:, 1), temp_q) .* q_symbols(:, 2));
                modulated(j) = temp_i + 1i*temp_q;
                j = j+1;
            end

            modulated = 1/sqrt(170) * modulated;

    end

    
    if nargin == 3
        phase = varargin{1};
        modulated = complex(modulated*exp(1i*phase));
    end
               
end