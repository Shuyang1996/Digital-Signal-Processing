% Single Stage
% Tom Koch, Mateen Nemati, Shuyang Yu

% y is the sampled data, Fs is the sampled rate
y = [];
Fs = 0;
% variable l is the computation for multiplies
% variable a is the computation for additions

[y, Fs] = audioread('Wagner.wav');
% sound(y,Fs)

 %% after first upsample
 y = upsample(y, 320);
 
 % w cutoff frequency 
 w = (1 /320);
 d1 = designfilt('lowpassfir','PassbandFrequency',w, ...
         'StopbandFrequency',1.2*w,'PassbandRipple',0.1, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');

 % fvtool(d1);  
 
 %after the first filter
 y = filter(d1, y);
 l = length(d1)*320;
 a = length(d1)*320-1
 
 w = (1/147);
 d2 = designfilt('lowpassfir','PassbandFrequency',w, ...
         'StopbandFrequency',1.2*w,'PassbandRipple',0.1, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');
 
 % after second filter
 y = filter(d2, y);

 l = l + (length(d2)/147);
 a = a + (length(d2)-1)

 y = downsample(y, 147);
 
 
 soundsc(y, 24000);
 
 
 
 
 
 
 