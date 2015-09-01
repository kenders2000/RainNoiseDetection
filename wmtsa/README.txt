WMTSA toolbox for MATLAB
------------------------

Version:  0.2.6
Date:     2006-08-23

Overview
--------

WMTSA toolbox is an implemenation for MATLAB of the wavelet methods for
time series analysis techniques presented in:

Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
   Time Series Analysis. Cambridge: Cambridge University Press.

henceforth referenced as WMTSA.

The WMTSA toolbox follows the terminology, symbology, algoritms and
presentation of WMTSA whenever possible.  

Currently only the MODWT and its inverse transform have been
fully implemented in the WMTSA toolbox.  The DWT has been implemented
but lacks plotting and analysis functions.

What's New
----------

See ChangeLog for changes for the latest release.


Installation
------------

See INSTALL file for instructions on how to install.

Platform Compability
--------------------

The WMTSA package has been developed using MATLAB 7.x on Linux
platform.  It has been compiled and tested on the following platforms:

OS                            MATLAB Version
--                            --------------
Linux (Redhat EL 3.0 WS)      7.2 (R2006a)
Linux (Redhat EL 4.0 x86_64)  7.2 (R2006a)
Windows 2000                  7.2 (R2006a)



The distributed WMTSA package does not include compiled MEX function binaries
for any platform.  Binaries will be compiled during first launch of
the wmtsa toolkit after installation.

Required MATLAB toolboxes
-------------------------

Statistics toolbox is now option.  If available, the chi2inv and
norminv functions are used; otherwise, the wmtsa/stats toolbox
funcitons QGauss and QChisq functions are used.


Directory organization
---------------------

WMTSA functions are organized in subdirectories under the 
toolbox/wmtsa root as follows:

dwt         -- Core wavelet analysis transform, ANOVA
               plotting, utiility and support functions.
odwt        -- Object-oriented version of toolkit (Experimental)
plotutils   -- Plotting utiltiy functions.
utils       -- Utility functions for application support.
stats       -- Statistical functions.
signal      -- Signal processing functions.
data        -- Example datasets.
Examples    -- Examples from WMTSA Book and other sources
               illustrating use of the toolbox.
third-party -- Functions from third-party sources.


Documentation
-------------

Each WMTSA function contains a standardized header which can be viewed
by typing: help <function>.  The standardized header describes
usage/syntax, input and output arguments, detailed description,
alorigthm description, and references.

For the current release, documentation is partial and incomplete.
Your comments/corrections/questions are welcome and will be used to
enhance the WMTSA toolbox and documentation.

Examples
--------

A set of examples illustrating the use of the WMTSA toolbox are under
toolbox/wmtsa/Examples directory.

The Figures subdirectory contains MATLAB scripts that replicate
figures contained in WMTSA.  To display a figure, type:

  figureXXX

where XXX is the figure number.

Reviewing the MATLAB scripts in the Figures directory will demonstrate
how to use the WMTSA functions in MATLAB.

The data subdirectory contains data (.dat) files used by the figure
scripts.  These data files originally from the WMTSA web site have
been formatted for loading into MATLAB.

Testing
-------

Unit tests for testing proper functionality and verifying numerical
accurarcy of the are included with toolkit and are found under the
toolbox/wmtsa/Tests directory.  There is a subdirectory for
corresponding for each toolbox under toolbox/wmtsa.

The unit tests utilize the MUnit toolbox for unit test, which is
included with this distribution.

To invoke unit tests:

1.  Add MUnit toolkit to your path:
    addpath <PATH_TO_MUNIT_DIRECOTORY/toolkit/munit/munit.
2.  Change to wmtsa/Tests/<XXX> directory (e.g. XXX = dwt)
3.  Run a test case: run_tcase(@YYY_tcase).
    For example:  
          run_tcase(@modwt_functionality_tcase).

Examining test cases illustrates the functionality of the wmtsa toolkit.

License
-------

The WMTSA toolkit for MATLAB is released under a BSD-style license
contained in LICENSE file.


Key Functions in the WMTSA Toolbox
---------------------------------

Key WMTSA functions are identified via the following function
prefaces:

modwt_        = modwt transform and analysis
imodwt_       = imdowt transform and analysis
plot_modwt_   = plot modwt transform and analysis results.
plot_imodwt_  = plot imodwt transform and analysis results.
plot_         = plot function common for plotting MODWT and DWT results.

Listed below are names, usage and brief descriptions of key WMTSA
functions for analysis and plotting.

For Analysis:
-------------

% modwt -- Compute the (partial) maximal overlap discrete wavelet transform (MODWT) of a data series.
% modwt_wvar -- Calculate wavelet variance from MODWT wavelet coefficients.
% modwt_wcov -- Compute the wavelet covariance of two MODWT wavelet coefficient matrices.
% modwt_wcor -- Compute the wavelet correlation of two MODWT wavelet coefficient matrices.

% modwt_rot_cum_wsvar -- Calculate the rotated wavelet sample variance from MODWT wavelet coefficients.
% modwt_cum_wav_svar -- Calculate cumulative sample variance of MODWT  wavelet coefficients.

% imodwt -- Calculate the inverse (partial) maximal overlap discrete wavelet transform (IMODWT).

% imodwt_mra -- Calculate multi-resolution details and smooths via inverse maximal overlap discrete wavelet transform(IMODWT).

% modwt_mra -- Calculate multi-resolution details and smooths of a time series via a single function call.


For Plotting:
-------------

% plot_modwt_coef -- Plot the MODWT wavelet and scaling coefficients and (optionally) the original time series.
% plot_wvar -- Plot the wavelet variance and (optionally) confidence intervals.
% plot_wcor -- Plot the wavelet correlation and (optionally) confidence intervals.
% plot_wcov -- Plot the wavelet covariance and (optionally) confidence intervals.
% plot_modwt_rcwsvar -- Plot the rotated cumlative sample variance of the MODWT wavelet coefficients.
% plot_modwt_clcwsvar -- Plot the cumlative level of cumulative sample variance of MODWT wavelet coefficients.
% plot_imodwt_mra -- Plot the IMODWT multiresoution analysis (detail and smooth) values and original time seies.


Workflow
--------

For analysis of a single signal:
-------------------------------

   X = vector series of observations
 
   |
   |
   V

 modwt

   |
   |
   V

[WJt, VJ0t]   --->  plot_modwt_coef

   |
   |------------->  modwt_wvar  --->  plot_wvar
   | 
   |------------->  modwt_cum_wav_svar  --->  plot_modwt_cwsvar
   | 
   |------------->  modwt_rot_cum_wav_svar.m  --->  plot_modwt_rcwsvar
   | 
   | 
   V

imodwt_mra   

   |
   |
   V

[DJt, SJ0t]   --->  plot_imodwt_mra


For analysis of a 2 signals:
----------------------------

   X            Y  
                  
   |            |  
   |            |  
   V            V  
                  
 modwt        modwt
                   
   |            |  
   |            |  
   V            V  
                   
[WJXt]       [WJYt]
   
   \           /
    \         /
     \       /
      \     /
       \   /
        \ /
         V

      modwt_wcor  --->  plot_wcor

      modwt_wcov  --->  plot_wcov


Unit Testing
------------

We have developed a unit testing framework for MATLAB (munit) to unit test the toolkit.  munit is similar to unit test frameworks developed for other languages (e.g. junit).  A copy of munit is included with the WMTSA toolkit distribution.

munit Unit test functions are located in the Test subdirectory.  Under the Test directory is TestData subdirectory containing data for testing and verifying WMTSA toolkit functions.

Note:  Implementation of munit tests is still under development.  Not all WMTSA toolkit functions have munit tests.
