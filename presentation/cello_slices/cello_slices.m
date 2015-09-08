addpath(genpath('~/MATLAB/scattering.m'));
addpath(genpath('~/MATLAB/export_fig'));

epsilon = 1e-3;

folder_path = '~/mlsp2015/dataset22k';
file_infos = dir(folder_path);
cello_index = 28; % the cello scale is the 28th file in the dataset22k
first_character = char('.');
while first_character==char('.')
    file_index = file_index + 1;
    file_name = file_infos(file_index).name;
    first_character = char(file_name(1));
end
cello_info = file_infos(cello_index);

sample_rate = 22050;
N = 65536;
file_name = cello_info.name;
file_path = fullfile(folder_path, file_name);
[original_waveform,sample_rate] = audioread_compat(file_path);
waveform = original_waveform(1:N);

%%
T = N/4;
opts{1}.time.size = N;
opts{1}.time.T = T;
opts{1}.time.max_Q = 16;
opts{1}.time.nFilters_per_octave = 16;
opts{1}.time.has_duals = true;
opts{1}.time.gamma_bounds = [1 128];

opts{2}.time.T = T;
opts{2}.time.max_scale = Inf;
opts{2}.time.handle = @morlet_1d;
opts{2}.time.sibling_mask_factor = Inf;
opts{2}.time.max_Q = 1;
opts{2}.time.U_log2_oversampling = 1;

archs = sc_setup(opts);

%%
[S, U] = sc_propagate(waveform,archs);
U_unchunked = sc_unchunk(U);

%% Show plain scattering slices
j2s = [5, 8, 11];
nSlices = length(j2s);
slices = cell(1, nSlices);
epsilons = [1e-5, 1e-4, 1e-2]; 

for slice_index = 1:nSlices
    j2 = j2s(slice_index);
    scattergram = U_unchunked{3}.data{j2}.';
    epsilon = epsilons(slice_index);
    slices{slice_index} = log1p(max(scattergram,0)/epsilon);
    
end

hold on;
for slice_index = 1:nSlices
    C = slices{slice_index};
    C = C(end:-1:1,1:(size(C,2)/128):end);
    [X, Y] = meshgrid(1:size(C,2), 1:size(C,1));
    Z = - slice_index * ones(size(C)).';
    h = surface(X,Y,Z,C);
    set(h, 'LineStyle', 'none');
    colormap rev_hot;
    box off;
    set(gca,'Visible','off');
end
export_fig('raw_cello_slices','-transparent');
view([-15, 28]);
%% Show averaged slices
epsilons = [1e-2, 1e-2, 1e-1];

avg_slices = cell(1,nSlices);
for slice_index = 1:nSlices
    j2 = j2s(slice_index);
    scattergram = abs(S{3}.data{j2}.');
    epsilon = epsilons(slice_index);
    avg_slices{slice_index} = log1p(max(scattergram,0)/epsilon); 
end

hold on;
for slice_index = 1:nSlices
    C = flipud(avg_slices{slice_index});
    [X, Y] = meshgrid(1:size(C,2), 1:size(C,1));
    Z = - slice_index * ones(size(C));
    h = surface(X,Y,Z,C);
    set(h, 'LineStyle', 'none');
    colormap rev_hot;
    box off;
    set(gca,'Visible','off');
end
export_fig('raw_cello_avgslices','-transparent');
view([-30, 28]);