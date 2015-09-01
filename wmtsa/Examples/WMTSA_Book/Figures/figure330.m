% figure330 - Compare 'octave band' PSD (SDF) estimates for vertical
% shear measurements via periodogram, multitaper PSD, 
% Haar and D6 wavelet variance estimates.
% 
% Usage:
%   run figure330
%

% $Id: figure330.m 569 2005-09-12 19:37:21Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('msp');

base_depth = 350.0;
delta_depth = 0.1;

depth = base_depth + delta_depth * ([0:1:length(X)-1]);
depth = depth(:);

% Extract meausurments between depths of 489.5 to 899.0 meters
indices = find(depth >= 489.5 & depth <= 899.0);
X = X(indices);
depth = depth(indices);

J0_haar = 12;
J0_d6 = 9;

Tau_j = 2.^([1:12]-1);
Tau_j = Tau_j(:);
depth_Tau_j = Tau_j * delta_depth;

boundary = 'periodic';

% Calculate MODWT using different filters
[WJt_haar, VJt_haar, w_att_haar] = modwt(X, 'haar', 12, boundary);
[WJt_d6, VJt_d6, w_att_d6] = modwt(X, 'd6', 9, boundary);

% Calculate wavelet variances
[wvar_haar, CI_wvar_haar] = modwt_wvar(WJt_haar, '', 'unbiased', 'haar');
[wvar_d6, CI_wvar_d6] = modwt_wvar(WJt_d6, '', 'unbiased', 'd6');

% Calculate PSD estimates from wavelet variance
[CJ_haar, f_haar, CI_CJ_haar, f_band_haar] = ...
    modwt_wvar_psd(wvar_haar, delta_depth, CI_wvar_haar);
[CJ_d6, f_d6, CI_CJ_d6, f_band_d6] = ...
    modwt_wvar_psd(wvar_d6, delta_depth, CI_wvar_d6);


% Plot CJ as staircase over frequency octave bands
haxes = plot_wvar_psd(f_haar, CJ_haar, f_band_haar, '', 'staircase', 'r-');
hold on;
haxes = plot_wvar_psd(f_d6, CJ_d6, f_band_d6, '', 'staircase', 'b--');

XLim = [10^-3, 10^1];
YLim = [10^-5, 10^3];
set(haxes, 'XLim', XLim);
set(haxes, 'YLim', YLim);

fs = 1 / delta_depth;  % sampling rate

% Compute and plot PSD via periodogram
[PSD_pdgm, f_pdgm] = periodogram(X,[],[],fs);

% Throw away the DC component (f=0)
nf = length(f_pdgm);
f_pdgm = f_pdgm(2:nf);
PSD_pdgm = PSD_pdgm(2:nf);

% Normalize PSD
PSD_pdgm = PSD_pdgm / 2;

% Bin the PSD
num_pdgm_avg = 13;
f_pdgm_avg = zeros(num_pdgm_avg, 1);
PSD_pdgm_avg = zeros(num_pdgm_avg, 1);

f_pdgm_avg(1:4) = f_pdgm(1:4, 1);
PSD_pdgm_avg(1:4) = PSD_pdgm(1:4, 1);

% Note:  wvar_psd is order by j level, i.e. highest to lowest f
% Sort and order lowest to highest
[f_haar_asc, haar_asc_indx] = sort(f_haar);
f_band_haar_asc = f_band_haar(haar_asc_indx, :);
nf_haar_asc = length(f_band_haar_asc);

for (j = 4:nf_haar_asc)
  indices = find(f_pdgm > f_band_haar_asc(j, 1) & f_pdgm <= f_band_haar_asc(j, 2));
  f_pdgm_avg(j+1,1) = mean(f_pdgm(indices));
  PSD_pdgm_avg(j+1,1) = mean(PSD_pdgm(indices));
end

loglog(f_pdgm_avg, PSD_pdgm_avg, 'ko');


% Compute and plot PSD via multitaper
[PSD_mtpr, f_mtpr] = pmtm(X, 7/2, [], fs);

% Normalize PSD
PSD_mtpr = PSD_mtpr / 2;

% Throw away the DC component (f=0)
nf = length(f_mtpr);
f_mtpr = f_mtpr(2:nf);
PSD_mtpr = PSD_mtpr(2:nf);

% Bin the PSD
num_mtpr_avg = 13;
f_mtpr_avg = zeros(num_mtpr_avg, 1);
PSD_mtpr_avg = zeros(num_mtpr_avg, 1);

f_mtpr_avg(1:4) = f_mtpr(1:4);
PSD_mtpr_avg(1:4) = PSD_mtpr(1:4);

% Note:  wvar_psd is order by j level, i.e. highest to lowest f
% Sort and order lowest to highest
[f_haar_asc, haar_asc_indx] = sort(f_haar);
f_band_haar_asc = f_band_haar(haar_asc_indx, :);
nf_haar_asc = length(f_band_haar_asc);

for (j = 4:nf_haar_asc)
  indices = find(f_mtpr > f_band_haar_asc(j, 1) & f_mtpr <= f_band_haar_asc(j, 2));
  f_mtpr_avg(j+1) = mean(f_mtpr(indices));
  PSD_mtpr_avg(j+1) = mean(PSD_mtpr(indices));
end

loglog(f_mtpr_avg, PSD_mtpr_avg, 'g*');


xlabel('\itf\rm  (cycles/meter)');

title_str = ...
    {['Figure 330.'], ...
     ['Comparison of ''octave band'' PSD estimates'], ...
     ['for vertical shear measurements']};

suptitle(title_str);

figure_datestamp(mfilename, gcf);

legend(haxes, {'Haar', 'D6', 'Periodogram', 'Multitaper'});
