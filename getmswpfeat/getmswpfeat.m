% GETMSWPFEAT Gets the Multiscale Wavelet Packet feature extraction.
% feat = getmswpfeatV00(x,winsize,wininc,SF,'toolbox')
% ------------------------------------------------------------------
% The signals in x are divided into multiple windows of size
% "winsize" and the windows are spaced "wininc" apart.
% Inputs
% ------
%    x: 		columns of signals
%    winsize:	number of samples per each window we extract features from
%    wininc:	spacing of the windows, or simply the increments between windows
%    SF:        sampling frequency
%    toolbox    'matlab' if you plan to use the matlab wavelet toolbox
%               'wmtsa'  if you plan to use the wmtsa wavelet toolbox
%                        ('http://www.atmos.washington.edu/wmtsa/')
% Outputs
% -------
%    feat:     WPT features (compete tree without node selection)

% Example
% -------
% Assume a random signal
% x = rand(1024,1);
% feat = getmswpfeatV00(x,256,32,256,'matlab')
% Assuming here rand(1024,1) (this can be any one or multi dimensional signal,
% for example EEG or EMG) is a one dimensional signal sampled at 256
% for 4 seconds only. Utilizing a window size of 256 at 32 increments
% features are extracted from the wavelet packet tree.
% I assumed 7 decomposition levels (J=7) below in the code.
% For a full tree at 7 levels you should get
% Level-0= 1 features
% Level-1= 2 features
% Level-2= 4 features
% Level-3= 8 features
% Level-4= 16 features
% Level-5= 32 features
% Level-6= 64 features
% Level-7= 128 features
% ---------------------
% Total = 255 features
% and the result from the example above is feat is of size 25 x 255

% (Kindly cite either of the following papers if you use this code)
% References:
% [1] R. N. Khushaba, A. Al-Jumaily, and A. Al-Ani, “Novel Feature Extraction Method based on Fuzzy Entropy and Wavelet Packet Transform for Myoelectric Control”, 7th International Symposium on Communications and Information Technologies ISCIT2007, Sydney, Australia, pp. 352 – 357.
% [2] R. N. Khushaba, S. Kodagoa, S. Lal, and G. Dissanayake, “Driver Drowsiness Classification Using Fuzzy Wavelet Packet Based Feature Extraction Algorithm”, IEEE Transaction on Biomedical Engineering, vol. 58, no. 1, pp. 121-131, 2011.
%
% Multiscale Wavelet Packet feature extraction code by Dr. Rami Khushaba
% Research Fellow - Faculty of Engineering and IT
% University of Technology, Sydney.
% Email: Rami.Khushaba@uts.edu.au
% URL: www.rami-khushaba.com (Matlab Code Section)
% Last modified 19/06/2014
% first created 06/10/2011
%PS: original template for feature extraction inspired by the work Dr. Adrian Chan

function [Features featL feat3 L10 L50 L90] = getmswpfeat(x,winsize,wininc,J,toolbox)
%         J = round(log(size(x,1))/log(2));
% Check the inputs
if nargin <5
    if nargin < 4
        if nargin < 3
            if nargin < 2
                winsize = size(x,1);
            end
            wininc = winsize;
        end
        warning('Number of decomposition levels will be selected automatically')
        J = log(size(x,1))/log(2);
    end
    toolbox = 'matlab';
end

%% allocate memory
datasize       = size(x,1);
numwin         = floor((datasize - winsize)/wininc)+1;
Signals        = zeros(winsize,numwin);
nfCh           = (2^(J+1)-1);   % number of features per channel
Features        = zeros(numwin,nfCh*size(x,2));

%% Start the process and loop along all dimensions (channels)
for i_Sig = 1:size(x,2)
    
    %% A sliding window approach with windows starting and ending points
    st             = 1;
    en             = winsize;
    
    % Assuming that your input signal is continuous, chop it into segments of winsize length
    for i = 1:numwin
        Signals(1:winsize,i) = x(st:en,i_Sig);
        st = st + wininc;
        en = en + wininc;
    end
    
    %% Decomposition levels
    % Number of decomposition levels is set as an input
    % It can also be set using
    % J=wmaxlev(winsize,'Sym5');
    % or J=(log(Fs/2)/log(2))-1;
    
    %% Perform multisignal wabelet packet
    if strcmp(toolbox,'matlab')
        D              = mswpd('col',Signals,'db4',J);   % WPT tree, the actual WP decomposition module using matlab toolbox
    else
        D              = mswpd_wmtsa(Signals,'d4',J);     % WPT tree, the actual WP decomposition module using wmtsa toolbox
        %     The following are possible wtf filter options rather than 'd4'
        %     @wtf_haar, ...
        %     @wtf_d4, ...
        %     @wtf_d6, ...
        %     @wtf_d8, ...
        %     @wtf_d10, ...
        %     @wtf_d12, ...
        %     @wtf_d14, ...
        %     @wtf_d16, ...
        %     @wtf_d18, ...
        %     @wtf_d20, ...
        %     @wtf_la8, ...
        %     @wtf_la10, ...
        %     @wtf_la12, ...
        %     @wtf_la14, ...
        %     @wtf_la16, ...
        %     @wtf_la18, ...
        %     @wtf_la20, ...
        %     @wtf_bl14, ...
        %     @wtf_bl18, ...
        %     @wtf_bl20, ...
        %     @wtf_c6, ...
        %     @wtf_c12, ...
        %     @wtf_c18, ...
        %     @wtf_c24
    end
    Temp                                       = D{1,1};                          % get first node content
    [nSmp]                                     = size(Temp,2);clear Temp          % number of signals
    feat                                       = zeros(nSmp,2^(J+1)-1);           % allocate memory for features
    [nL,nF]                                    = size(D);                         % get size of WP tree
    index                                      = 1;
    for i=1:nL
        for j=1:nF
            if ~isempty(D{i,j})
                % This is where we extract the features (Log Root Mean Square)
                feat(1:nSmp,index)  = (sqrt(mean(D{i,j}.*D{i,j})'));
                feat2(1:nSmp,i,j)  = (sqrt(mean(D{i,j}.*D{i,j})'));

%                      h1=-10:0.01:10;
%                      pdf=hist(log(feat(:,index)),h1);
%                      cdf=cumsum(pdf/sum(pdf));[null Imin]=min(abs(cdf-0.9));L10(i,j)=h1(Imin);
%                      cdf=cumsum(pdf/sum(pdf));[null Imin]=min(abs(cdf-0.5));L50(i,j)=h1(Imin);
%                      cdf=cumsum(pdf/sum(pdf));[null Imin]=min(abs(cdf-0.1));L90(i,j)=h1(Imin);
                featL(i,j)=1;
                index               = index +1;
            end
        end
    end
    IndX                                        = sum(feat,1);
    IndX                                        = (IndX~=0);
    feat                                        = feat(:,IndX);
    nfCh                                        = size(feat,2);
    Features(:,((i_Sig-1)*(nfCh)+1):i_Sig*nfCh) = feat;
end
%% Make sure you dont have all zero features
Features=log(sqrt(mean(feat.^2)));
feat3=squeeze(log(sqrt(mean(feat2.^2,1))));
% for i=1:length(feat3
L10=[];
L90=[];
L50=[];
% 
% L10=L10( featL==1)';
% L50=L50( featL==1)';
% L90=L90( featL==1)';
% % IndX                                       = sum(Features);
% IndX                                       = (IndX~=0);
% Features                                   = Features(:,IndX);
