function calculateSNR(x, samplingRate)
    figure;
    snr(x, samplingRate, 10);
    
    figure;
    H = fft(x);
    Hone = zeros(1, length(H)/2+1);
    Hone(1) = H(1);
    Hone(2:end) = 2 * H(2:length(H)/2+1);
    w = 0:(length(x)/2);
    w = w .* 2 * pi / (length(x)/2);
    P = 10*log10(abs(Hone .* Hone));
    
    plot(w, P)
end

