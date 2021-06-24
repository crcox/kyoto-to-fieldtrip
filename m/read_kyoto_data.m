function dat = read_kyoto_data(hdr, K, tags, varargin)
% READ_KYOTO_DATA Process Kyoto ECoG data to produce dat structure
%    dat = read_kyoto_data(hdr, K, tags)
%    dat = read_kyoto_data(hdr, K, tags, stim)
%
% Inputs:
%    hdr: Header object as returned by read_kyoto_header
%    K: The main data structure from the Kyoto .mat file (e.g.,
%    namingERP_data_PtYK_Pt01 for participant 1).
%    tags: A cell array containing the tag objects from the Kyoto .mat
%    file.
%    stimuli: A table with columns {Session, Trial, ItemIndex, Stimulus}
%
% Output:
%    dat.label = hdr.label;
%    dat.fsample = hdr.Fs;
%    dat.trial = cell(1, n);
%    dat.time = repmat({linspace(a,b,c)}, 1, n);
%    dat.trialinfo = stim;
%    dat.sampleinfo = sampleinfo;
    if nargin > 3
        stim = varargin{1};
    else
        stim = '';
    end
    dat.label = hdr.label;
    dat.fsample = hdr.Fs;
    ix = asColVec(tags) - 1;
    sampleinfo = [ix - hdr.nSamplesPre, ix + hdr.nSamples];
    n = numel(ix);
    X = K.DATA';
    dat.trial = cell(1, n);
    for i = 1:n
        a = sampleinfo(i,1);
        b = sampleinfo(i,2);
        dat.trial{i} = X(:, a:b);
    end
    a = -(hdr.nSamplesPre / hdr.Fs);
    b = (hdr.nSamples / hdr.Fs);
    c = (sampleinfo(i,2) - sampleinfo(i,1)) + 1;
    dat.time = repmat({linspace(a,b,c)}, 1, n);
    dat.trialinfo = stim;
    dat.sampleinfo = sampleinfo;
end

function ix = asColVec(x)
% ASCOLVEC Concatenate into single column vector
    if iscell(x)
        x_colvec = cellfun(@(y) y(:), x, 'UniformOutput', false);
        ix = cell2mat(x_colvec(:));
    else
        ix = x(:);
    end
end
