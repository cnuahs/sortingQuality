

function [cgs, uQ, cR, isiV] = computeAllMeasures(resultsDirectory)

clusterPath = fullfile(resultsDirectory, 'cluster_groups.csv');
spikeClustersPath = fullfile(resultsDirectory,'spike_clusters.npy');
spikeTemplatesPath = fullfile(resultsDirectory,'spike_templates.npy');

if exist(clusterPath, 'file')
    [cids, cgs] = readClusterGroupsCSV(clusterPath);
elseif exist(spikeClustersPath, 'file')
    clu = readNPY(spikeClustersPath);
    cgs = 3*ones(size(unique(clu))); % all unsorted
else
    clu = readNPY(spikeTemplatesPath);
    cgs = 3*ones(size(unique(clu))); % all unsorted
end

% note: maskedClusterQuality() and isiViolations() return metrics only for
%       cluters for which spikes occur... if we're post-processing virtually
%       concatenated files then it is possible that this is only a subset
%       of all clusters.
[cids_, uQ_, cR_] = sqKilosort.maskedClusterQuality(resultsDirectory);

isiV_ = sqKilosort.isiViolations(resultsDirectory);

% pad if necessary (see note above)
uQ = zeros(size(cids))';
cR = NaN(size(cids))';
isiV = NaN(size(cids));

ix = ismember(cids+1,cids_); % +1 because id's in cluster_groups.csv start at 0
uQ(ix) = uQ_;
cR(ix) = cR_;
isiV(ix) = isiV_;
