%****s* WMTSA-DWT/Structures
%
% NAME
%   WMTSA DWT Structures -- structs used in WMTSA DWT toolbox.
%
% DESCRIPTION
%   MATLAB structures used in WMTSA DWT toolbox.
%
% TOOLBOX
%    wmtsa/dwt
%
% CATEGORY
%
%
%***
%****s* Structures/wtf_s
%
% NAME
%   wtf_s -- wavelet transform filter struct.
%
% DESCRIPTION
%  wtf_s struct has fields:
%   * g         -- scaling (low-pass) filter coefficients (vector).
%   * h         -- wavelet (high-pass) filter coefficients (vector).
%   * L         -- filter length (= number of coefficients) (integer).
%   * Name      -- name of wavelet filter (character string).
%   * Class     -- class of wavelet filters (character string).
%   * Transform -- name of transform (character string).
%
%  Possible values for transform are:  DWT, MODWT.
%
% SEE ALSO
%   
%***
%****s* Structures/w_att_s
%
% NAME
%   w_att_s -- wavelet transform attributes struct.
%
% DESCRIPTION
%  w_att_s struct has fields:
%   * Transform  -- name of transform ('MODWT') (string).
%   * WTF        -- name of wavelet transform filter or a wtf_s struct (string or struct).
%   * NX         -- number of observations in original series (= length(X)) (integer).
%   * NW         -- number of wavelet coefficients (integer).
%   * J0         -- number of levels of partial decompsition (integer).
%   * NChan      -- number of channels in a multivariate dataset (integer).
%   * Boundary   -- boundary conditions applied (string).
%   * Aligned    -- Boolean flag indicating whether coefficients are aligned
%                   with original series (1 = true) or not (0 = false) (boolean).
%   * RetrainVJ -- Boolean flag indicating whether VJ scaling coefficients at all 
%                   levels have been retained (1= true) or not (0 = false) (boolean).
%
%  Possible values for transform are:  DWT, MODWT.
%
% SEE ALSO
%   
%***

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2005-03-03
%
% COPYRIGHT
%  (c) Charles R. Cornish 2005
%
% REVISION
%   $Revision: 630 $
%

%   $Id: DWT_Structures.m 630 2006-05-02 20:47:17Z ccornish $

