% Multi stage
% Tom Koch, Mateen Nemati, Shuyang Yu

% y is the sampled data, Fs is the sampled rate
y = [];
Fs = 0;

[y, Fs] = audioread('Wagner.wav');
% sound(y,Fs)

 % 24000/ 11025 = 320 / 147
 % split 320 into 8, 4, 10;  split 147 into 7, 7, 3.
 % variable l is the computation for multiplies
 % variable a is the computation for additions

 %% Three stages for upsampling

 % First upsample by 8
 y = upsample(y, 8);
 
 % create first digital filter, (w: cutoff frequency)
 w = (1/8);
 uf1 = designfilt('lowpassfir','PassbandFrequency',w, ...
         'StopbandFrequency',1.2*w,'PassbandRipple',0.1, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');

 %after the first filter
 y = filter(uf1, y);
 
 
 % l is multiplies
 l = length(uf1)*8
 % a is additions
 a = length(uf1)*8 -1
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %Second upsample y 4
 y = upsample(y,4);
 
 % create second digital filter, (w: cutoff frequency)
 w = (1/4);
 uf2 = designfilt('lowpassfir','PassbandFrequency',w, ...
         'StopbandFrequency',1.2*w,'PassbandRipple',0.1, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');

 %after the second filter
 y = filter(uf2, y);
 l = l + length(uf2)* 4
 a = a + length(uf2)*4-1
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %Third upsample y 10
 y = upsample(y,10);
 
 % create second digital filter, (w: cutoff frequency)
 w = (1/10);
 uf3 = designfilt('lowpassfir','PassbandFrequency',w, ...
         'StopbandFrequency',1.2*w,'PassbandRipple',0.1, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');

 %after the second filter
 y = filter(uf3, y);
 l = l + length(uf3)*10
 a = a + length(uf3)*10-1
%% Three stages for downsampling, filter signal before downsample
% create first filter
w = (1/7);
df1 = designfilt('lowpassfir','PassbandFrequency',w, ...
         'StopbandFrequency',1.2*w,'PassbandRipple',0.1, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');

% after first filter
y = filter(df1, y);
l = l+(length(df1)/7)
a = a+ (length(df1)-1)

% now downsample by 7
y = downsample(y,7);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create second filter
w = (1/7);
df2 = designfilt('lowpassfir','PassbandFrequency',w, ...
         'StopbandFrequency',1.2*w,'PassbandRipple',0.1, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');

% after second filter
y = filter(df2, y);

l = l+(length(df2)/7)
a = a+ (length(df2)-1)

% now downsample by 7
y = downsample(y,7);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create third filter
w = (1/3);
df3 = designfilt('lowpassfir','PassbandFrequency',w, ...
         'StopbandFrequency',1.2*w,'PassbandRipple',0.1, ...
         'StopbandAttenuation',70,'DesignMethod','kaiserwin');

% after third filter
y = filter(df3, y);
l = l+(length(df3)/3)
a = a+ (length(df3)-1)

% now downsample by 3
y = downsample(y,3);

soundsc(y,24000);
