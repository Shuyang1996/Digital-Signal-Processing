function y = srconvert(x)
%function to convert sampling rate of audio file from
%11025 to 24000 Hz
%ma is a variable available which contains the number
%of multiplies and adds if you are interested


%upsample stages
ups = [4 4 4 5];
%downsample stages
downs = [7 7 3];

%multiplies and adds
ma = [0 0];

working = x';

for i = 1:length(ups)
    [working, ma] = polyup(working,ups(i),ma);
end
for i = 1:length(downs)
    [working, ma] = polydown(working,downs(i),ma);
end

y = working;
