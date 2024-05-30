N = 16;
K = 8;
n = log2(N);
EbN0_dB = -3:0.2:3 ;
Rate = K/N;
EbN0 = 10.^( EbN0_dB / 10);
sigmas = sqrt(1./(2*Rate*EbN0));

berEst = [];

Nbits = 0;
Errors = [];

for sigma = sigmas
    disp(['==============  ',num2str(sigma),'  ==============']); 

    numErrs = 0;
    numBits = 0;
    
    while numErrs < 2000 && numBits < 10e6
        bits = randi([0 1],1,K);
        encoded = encoder(bits, N);  % кодируем последовательность
        s = 1 - 2 * encoded;  % BPSK
        noisy = s + sigma * randn(1,N);  % AWGN
        decoded = SC_decoder(noisy, K);
        
        nErrors = biterr(bits, decoded);

        numErrs = numErrs + nErrors;
        numBits = numBits + N;

    end

    berEst(end+1) = numErrs/numBits;

end

scatter(EbN0_dB, berEst)
set(gca,'yscale','log')
grid
legend('Estimated BER')
title('BPSK, N=16 K=8')
xlabel('Eb/N0 (dB)')
ylabel('Bit Error Rate')