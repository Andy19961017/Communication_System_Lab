function [S, f, t] = STFT(x, window, Noverlap, Nfft, fs)
    if size(x,2)==1;
        x=x';
    end
    scale=fs/2;
    T=1/fs;
    len=size(x,2);
    f=linspace(-scale, scale, Nfft);
    stride=window-Noverlap;
    NtimeStep=floor((len-window)/stride)+1;
    t=linspace(0, len/fs, NtimeStep);
    for i=1:NtimeStep
        signal=zeros(1,Nfft);
        signal(1:window)=x(1+(i-1)*stride:(i-1)*stride+window);
        ctft=T*fftshift(fft(signal,Nfft));
        S(:,i)=ctft;
    end
end