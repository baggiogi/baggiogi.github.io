function [cvE,mV] = distrMMSE(cvY1,cvY2,mP,mR1,mR2,mH1,mH2)
% DISTRMMSE compute the "distributed" version of the MMSE best linear
% estimator 

mV1 = (mP^-1+mH1'*mR1^-1*mH1)^-1;
mV2 = (mP^-1+mH2'*mR2^-1*mH2)^-1;

cvE1 = mV1*mH1'*mR1^-1*cvY1;
cvE2 = mV2*mH2'*mR2^-1*cvY2;

mV = (mV1^-1+mV2^-1-mP^-1)^-1;
cvE = mV^-1*(mV1^-1*cvE1 + mV2^-1*cvE2);

end