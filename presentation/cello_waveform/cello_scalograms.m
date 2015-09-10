addpath(genpath('~/MATLAB/scattering.m'));
addpath(genpath('~/MATLAB/export_fig'));

%%
target_filepath = ['~/mlsp2015/companion_T32k_phiftbysubstraction/', ...
    'Vc-scale-chr-asc_target.mat'];
firstorder_filepath = ['~/mlsp2015/companion_T32k_phiftbysubstraction/', ...
    'Vc-scale-chr-asc_summary_firstorder.mat'];
plain_filepath = ['~/mlsp2015/companion_T32k_phiftbysubstraction/', ...
    'Vc-scale-chr-asc_summary_plain.mat'];
joint_filepath = ['~/mlsp2015/companion_T32k_phigaussian/', ...
    'Vc-scale-chr-asc_summary_joint.mat'];

load(target_filepath);
load(firstorder_filepath);
load(plain_filepath);
load(joint_filepath);

summaries = {target_summary, firstorder_summary, plain_summary, joint_summary};
suffixes = {'target', 'firstorder', 'plain', 'joint'};
%%
epsilon = 1e2;
starting_gamma = 1;

nSummaries = length(summaries);
for summary_index = 1:nSummaries
    summary = summaries{summary_index};
    % Display waveform
    waveform = summary.signal;
    plot(waveform);
    drawnow();
    axis off;
    suffix = suffixes{summary_index};
    waveform_string = ['cello_waveform_', suffix, '.png'];
    export_fig(waveform_string, '-transparent');
    % Display log-scalogram
    U1 = summary.U{1+1};
    scalogram = display_scalogram(U1);
    logscalogram = log1p(scalogram(starting_gamma:end,:)/epsilon);
    imagesc(logscalogram);
    drawnow();
    colormap rev_hot;
    axis off;
    scalogram_string = ['cello_scalogram_', suffix, '.png'];
    export_fig(scalogram_string, '-transparent');
end
