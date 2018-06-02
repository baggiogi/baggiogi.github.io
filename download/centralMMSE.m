function [cvE,mV] = centralMMSE(cvY,mP,mR,mH)
% CENTRALMMSE compute the "centralized" version of the MMSE best linear
% estimator 

mV = (mP^-1+mH'*mR^-1*mH)^-1;
cvE = mV^-1*mH'*mR^-1*cvY;

end