in = audioread('Wagner.wav');
% in = [1; zeros(3000, 1)];
temp = in;

% %% No Multi-staging or Poly-phasing
% temp = upsample(in, 320);
% h1 = designfilt('lowpassfir','PassbandFrequency',(1/320),'StopbandFrequency',(1.2)*(1/320),'PassbandRipple',.1,'StopbandAttenuation',70,'DesignMethod','kaiserwin');
% temp = fftfilt(h1, temp);
% out = downsample(temp, 147);

% Multistage
h2 = lowpassfilter(0.5, 0.6);
h3 = lowpassfilter(1/3, 0.4);
h5 = lowpassfilter(1/5, 0.24);
h7 = lowpassfilter(1/7, 1.2/7);

% Polyphase
E2 = poly1(h2.Numerator,2);
E3 = poly1(h3.Numerator,3);
E5 = poly1(h5.Numerator,5);
E7 = poly1(h7.Numerator,7);


% filter then upsample(temp, 2) six times
for i = 1:6
    temp = upsample(filter(E2(1,:), 1, temp), 2) + upsample(filter(E2(2,:), 1, temp), 2, 1);
end


% filter then upsample(temp, 5)
temptemp = upsample(filter(E5(1,:), 1, temp), 5);

for i = 2:5
    temptemp = temptemp + upsample(filter(E5(i,:), 1, temp), 5, i-1);
end

temp = temptemp;


% downsample(temp, 7) twice then filter
for i = 1:2
    temp = [temp; zeros(ceil(length(temp)/7)*7-length(temp), 1)];
    x = temp(1:7:end);
    temptemp = filter(E7(1,:), 1, x);
    
    for j = 2:7
        x = temp(j:7:end);
        temptemp = temptemp + filter(E7(j,:), 1, x);
    end
    
    temp = temptemp;
end


% downsample(temp, 3) then filter
temp = [temp; zeros(ceil(length(temp)/3)*3-length(temp), 1)];
x = temp(1:3:end);
temptemp = filter(E3(1,:), 1, x);

for j = 2:3
    x = temp(j:3:end);
    temptemp = temptemp + filter(E3(j,:), 1, x);
end

temp = temptemp;


% finalizing out
out = temp;
%audiowrite('blah.wav', out, 24000)