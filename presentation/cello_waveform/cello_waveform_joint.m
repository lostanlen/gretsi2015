addpath(genpath('~/MATLAB/scattering.m'));
addpath(genpath('~/MATLAB/export_fig'));
filename = 'Vc-scale-chr-asc_joint.wav';

[full_waveform, sample_rate] = audioread_compat(filename);


siglength = 2^16;
waveform = full_waveform(1:siglength);

%%
plot(waveform);
axis off;
export_fig cello_waveform_joint.png -transparent