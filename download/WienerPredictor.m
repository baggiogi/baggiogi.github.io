function [cvYhat,dVar] = WienerPredictor(tfPhi,cvY,iK)
% WIENERPREDICTOR compute the k-step ahead Wiener prediction of an output 
% measurement vector using the polynomial division method
% Inputs:   tfPhi: rational scalar spectral density of 
%          cvY: column vector of output measurments
%          iK: prediction step
% Outputs:  cvYhat: column vector of predictions
%           dVar: variance of the prediction error
% SEE ALSO
% SPECTRALFACTOR, MINREAL, LSIM

tfW = spectralFactor(tfPhi);
[rvC,rvA] = tfdata(tfW,'v');

[rvQ,rvR] = deconv([rvC zeros(1,iK)], [rvA 0]);

dVar = sum(rvQ.^2);

tfWienerPredictor = minreal(tf(rvR,rvC));

cvT = (0:length(cvY)-1)';
cvYhat = lsim(tfWienerPredictor,cvY,cvT);