function [cvXhat,mP] = predKalman(sys,cvY0,cvX0,mP0)
% PREDKALMAN Compute the Kalman one-step predictor and the prediction error
% covariance of a system with unit-variance uncorrelated process and 
% measurement noises
% Inputs:   - sys: discrete-time state-space system
%           - cvY: measurement vector
%           - cVX0: current state vector
%           - mP0: current error prediction covariance matrix
% Outputs:  - cvXHat: one-step Kalman predictor
%           - mP: prediction error covariance
% SEE ALSO
% SSDATA

[mA,mB,mC,mD] = ssdata(sys); 

% computing Q and R (recall that v(t),w(t) are assumed to be uncorrelated 
% and of unit-variance)
mQ = mB*mB';
mR = mD*mD';

mLambda = mC*mP0*mC'+ mR; % innovations process variance
mL = mP0*mC'*mLambda^-1; % predictor gain
mK = mA*mL; % Kalman gain
mGamma = mA-mK*mC; % closed-loop matrix

cvXhat = mA*cvX0 + mK*(cvY0-mC*cvX0); % Kalman predictor
mP = mGamma*mP0*mGamma' + mK*mR*mK' + mQ; % prediction error covariance
