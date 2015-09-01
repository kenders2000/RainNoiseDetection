#include "mex.h"

/* mex -v -f /usr/tuelocal/matlab-5.2/bin/mexopts.sh dwt.c */
/* $Id: dwtj.c 355 2004-06-14 21:00:50Z ccornish $ */

/* To compile manually, type:
     mex -v -f $MATLAB/bin/mexopts.sh dwtj.c
 */

void dwtj(double *Vin, int M, int L, 
	 double *h, double *g, 
         double *Wout, double *Vout)
{

  long n, t, u;

  for (t = 0; t < M/2; t++) {
    u = 2 * t + 1;
    Wout[t] = h[0] * Vin[u];
    Vout[t] = g[0] * Vin[u];
    for (n = 1; n < L; n++) {
      u -= 1;
      if (u < 0) u = M - 1;
      Wout[t] += h[n] * Vin[u];
      Vout[t] += g[n] * Vin[u];
    } 
  }
}

void mexFunction(int nlhs, mxArray *plhs[], 
		 int nrhs, const mxArray *prhs[])
{

  int i;

  /* Inputs */
  int M;
  int L;
  double *Vin;
  double *h;
  double *g;
  int mrows;
  int ncols;

  /* Outputs */
  double *Wout;
  double *Vout;
  
  /* Check for proper number of arguments */
  if (nrhs != 3) {
    mexErrMsgTxt("dwtj requires three input arguments.");
  } else if (nlhs > 2) {
    mexErrMsgTxt("dwtj requires two output arguments.");
  }
  
  /* Ascertain that inputs are noncomplex double vectors. */


  for (i = 0; i < 3; i++) {
    mrows = mxGetM(prhs[i]);
    ncols = mxGetN(prhs[i]);


    if (!mxIsDouble(prhs[i]) ||
	mxIsComplex(prhs[i]) ||
	!((mrows == 1 && ncols  > 1) ||
	  (mrows > 1  && ncols == 1))) {
      mexPrintf("Input Argument  %d\n", i);
      mexPrintf("mrows = %d\n", mrows);
      mexPrintf("ncols = %d\n", ncols);
      mexErrMsgTxt("dwtj: Inputs must be noncomplex double vectors.");
    }
  }

  mrows = mxGetM(prhs[0]);
  ncols = mxGetN(prhs[0]);

  Vin = mxGetPr(prhs[0]);
  h = mxGetPr(prhs[1]);
  g = mxGetPr(prhs[2]);

  
  /* Create matrices for the return arguments */

  if (mrows == 1) {
    plhs[0] = mxCreateDoubleMatrix(mrows, ncols/2, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(mrows, ncols/2, mxREAL);
  }
  else {
    plhs[0] = mxCreateDoubleMatrix(mrows/2, ncols, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(mrows/2, ncols, mxREAL);
  }
  
  /* Assign pointers to the various parameters */
  
  Wout = mxGetPr(plhs[0]);
  Vout = mxGetPr(plhs[1]);
  
  M = mxGetNumberOfElements(prhs[0]);
  L = mxGetNumberOfElements(prhs[1]);
  
  /* Do the actual computations in a subroutine */
  
  dwtj(Vin, M, L, h, g, Wout, Vout);

  return;
}

