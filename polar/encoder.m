

function encoded = encoder(bits, N)

K = length(bits); % число инф. бит, K<=N


%  последовательность каналов из стандарта 3GPP 38.212 
rel_seq= load('data.mat').NR_sequence;
rel_seq = rel_seq + 1;

n = log2(N);

rel_seq = rel_seq(rel_seq<=N); %  берем только нужные номера каналов


encoded = zeros(1,N);

encoded(rel_seq(N-K+1:end)) = bits;  % ставим биты сообщения на инф. каналы


Gn = get_polar_transform(n);  % polar transform матрица
encoded = mod(encoded * get_polar_transform(n), 2);  % можно сделать в 2 цикла

end


