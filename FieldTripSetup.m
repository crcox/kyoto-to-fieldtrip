% Add FieldTrip to the environment
addpath('C:\Users\Chris\Documents\GitHub\fieldtrip');
addpath('C:\Users\Chris\Documents\GitHub\fieldtrip\fileio');
addpath('C:\Users\Chris\Documents\GitHub\fieldtrip\plotting');
addpath('C:\Users\Chris\Documents\GitHub\fieldtrip\utilities');
addpath('C:\Users\Chris\Documents\GitHub\fieldtrip\external\freesurfer');
% Add helper functions to the environment
addpath('.\m');

subjID = 'Subj-KyotoNaming-01';

% Load MNI Anatomy
anat = 'data\mni_icbm152_nlin_asym_09a_nifti\mni_icbm152_t1_tal_nlin_asym_09a.nii';
mri = ft_read_mri(anat);
mri = ft_determine_coordsys(mri);
mri.coordsys = 'mni';

% Load Kyoto ECoG Data (point it to data you already have)
% load('R:\crcox\ECoG\KyotoNaming\data\raw\Pt01\namingERP_Pt01.mat')

hdr = read_kyoto_header(namingERP_data_PtYK_Pt01, 1000, 200);

stim_order_file = 'C:\Users\Chris\Documents\GitHub\ECoG_Data_Prep\data\stimuli\picture_namingERP_order.csv';
stim_key_file = 'C:\Users\Chris\Documents\GitHub\ECoG_Data_Prep\data\stimuli\picture_namingERP_key.csv';
stim_order = readtable(stim_order_file);
stim_key = readtable(stim_key_file);
stim = join(stim_order, stim_key);
dat = read_kyoto_data( ...
    hdr, ...
    namingERP_data_PtYK_Pt01, ...
    {tag_ss01_all, tag_ss02_all, tag_ss03_all, tag_ss04_all}, ... 
    stim);

coord_file = 'C:\Users\Chris\Documents\GitHub\ECoG_Data_Prep\data\coords\MNI_basal_electrodes_Pt01_10_w_label_fixed.csv';
coords = readtable(coord_file);
xyz = [
    coords.x(strcmp(coords.subject, 'Pt01')), ...
    coords.y(strcmp(coords.subject, 'Pt01')), ...
    coords.z(strcmp(coords.subject, 'Pt01'))];

label = coords.electrode(strcmp(coords.subject, 'Pt01'));

elec = struct( ...
    'unit', 'mm', ...
    'coordsys', 'mni', ...
    'label', {label}, ...
    'elecpos', xyz, ...
    'chanpos', xyz, ...
    'tra', eye(numel(label)));

ft_plot_ortho( ...
    mri.anatomy, 'transform', ...
    mri.transform, 'style', 'intersect');

ft_plot_sens( ...
    elec, ...
    'label', 'on', ...
    'fontcolor', 'r');

% CANNOT RUN ON WINDOWS
% cfg           = [];
% cfg.method    = 'cortexhull';
% cfg.headshape = 'C:\Users\Chris\Downloads\freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0-2beb96c\freesurfer\subjects\fsaverage\surf\lh.pial';
% cfg.fshome    = 'C:\Users\Chris\Downloads\freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0-2beb96c\freesurfer'; % for instance, '/Applica
% hull_lh = ft_prepare_mesh(cfg);
%

% save('Pt01_fieldtrip.mat', 'dat', 'mri', 'elec', 'hdr');

% PREPROCESSING SEEMS TO WORK!
cfg = [];
cfg.demean         = 'yes';
cfg.baselinewindow = [-200,0];
cfg.lpfilter       = 'yes';
cfg.lpfreq         = 200;
cfg.padding        = 2;
cfg.padtype        = 'data';
cfg.bsfilter       = 'yes';
cfg.bsfiltord      = 3;
cfg.bsfreq         = [59 61; 119 121; 179 181];

data = ft_preprocessing(cfg, dat);

%   event.type      = string
%   event.sample    = expressed in samples, the first sample of a recording is 1
%   event.value     = number or string
%   event.offset    = expressed in samples
%   event.duration  = expressed in samples
%   event.timestamp = expressed in timestamp units, which vary over systems (optional)