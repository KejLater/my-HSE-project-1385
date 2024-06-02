clc

rate = 1/2;
bits = [ 1 0 0 1 1 1 0 1 0]';

encoded = double(bcc_encoder(bits, rate)');

decoded = bcc_viterbi_decoder(encoded);
sum(decoded~=bits')