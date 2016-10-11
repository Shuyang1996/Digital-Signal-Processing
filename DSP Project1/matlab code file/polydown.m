function [y,ma] = polydown(x,M,ma)

d = designfilt('lowpassfir','PassbandFrequency',1 / M, ...
         'StopbandFrequency',1.2 / M,'PassbandRipple',.01, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');

E = poly1(impz(d)',M); %polyphase the coefficients

n = length(x);
tmp = downsample(x,M);
%vector for catching output
y = zeros(1,length(tmp) + size(E,2) - 1);
for i = 1:M
    %delay it
    tmp = x(i:n); 
    tmp = [tmp zeros(1,n - length(tmp))];
    %downsample it
    tmp = downsample(tmp,M);
    %filter it
    y = y + conv(E(i,:),tmp);
end
%mults
ma(1) = ma(1) + (length(impz(d))) / M;
%adds
ma(2) = ma(2) + (length(impz(d)) / M) + M - 2;