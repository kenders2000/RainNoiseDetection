function D = mswpd_wmtsa(S,wtf,J)
% **********************************************************************
% ***************  MultiSignal Wavelet Packet Decomposition (using the WMTSA toolbox)************
% **********************************************************************
% S        :the original signals array to apply WP on (each column is a signal)
% wtf      :wavelet transform filter name or struct 
% J        : decomposition levels
%%
% By Dr. Rami Khushaba
% Visiting Fellow - Faculty of Engineering and IT
% University of Technology, Sydney.
% Email: Rami.Khushaba@uts.edu.au
% URL: www.rami-khushaba.com (Matlab Code Section)
% Last modified 19/06/2014
% First created 06/10/2011
%%
% (Kindly cite either of the following papers if you use this code)
% References:
% [1] R. N. Khushaba, A. Al-Jumaily, and A. Al-Ani, “Novel Feature Extraction Method based on Fuzzy Entropy and Wavelet Packet Transform for Myoelectric Control”, 7th International Symposium on Communications and Information Technologies ISCIT2007, Sydney, Australia, pp. 352 – 357.
% [2] R. N. Khushaba, S. Kodagoa, S. Lal, and G. Dissanayake, “Driver Drowsiness Classification Using Fuzzy Wavelet Packet Based Feature Extraction Algorithm”, IEEE Transaction on Biomedical Engineering, vol. 58, no. 1, pp. 121-131, 2011.

% Get the signals length
N = size(S,1);

% Define preliminary parameters for dwt from the wmtsa toolbox (Refer to the book for details)
boundary = 'periodic';

% Make sure you don't go wild about the number of decomposition levels
if J > floor(log2(N)*2)
    error('Too many levels.');
end

% Prepare your output structure, with first node containing the original signals
D{1,1} = S;

% For each level in the decomposition (starting with the second level).
for j = 1:J
    index = 1;
    % For each pair of elements on the j'th level.
    for k = 1:2^(j-1)
        T = D{j,k};
        opts.RetainVJ =1;
        [WJ, VJ, att, NJ] = dwt(T, wtf, 1, boundary,opts);
        % fill-in the rest of the nodes
        D{j+1,index} = cell2mat(VJ); index = index+1;
        D{j+1,index} = cell2mat(WJ); index = index+1;
    end
end