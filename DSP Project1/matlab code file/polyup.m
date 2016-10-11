function [y,ma] =polyup(x,L,ma)

d = designfilt('lowpassfir','PassbandFrequency',1 / L, ...
         'StopbandFrequency',1.2 / L,'PassbandRipple',.01, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');

E = poly1(impz(d)',L); %polyphase the coefficients
     
upsampled = zeros(1,(length(x) + size(E,2) - 1) * L);
for i=1:L
   %filter it
   tmp = conv(E(i,:),x);
   %upsample it
   tmp = upsample(tmp,L);
   %delay it
   n = length(tmp);
   tmp = tmp(i:n);
   tmp = [tmp zeros(1,n - length(tmp))];
   %sum it
   upsampled = upsampled +  tmp;
end
%multiplies
ma(1) = ma(1) + length(impz(d));
%adds
ma(2) = ma(1) + length(impz(d)) - 1;

y = upsampled;