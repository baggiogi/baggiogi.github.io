function [cvXhatSS,mPSS] = predKalmanSS(sys,cvY0,cvX0)
% PREDKALMAN Compute the steady-state Kalman one-step predictor and the 
% steady-state prediction error covariance of a system with unit-variance
% uncorrelated process and measurement noises
% Inputs:   - sys: discrete-time state-space system
%           - cvY: measurement vector
%           - cVX0: current state vector
% Outputs:  - cvXHatSS: one-step Kalman predictor
%           - mPSS: prediction error covariance
% SEE ALSO
% CHECKREACHSTAB, CHECKOBSDETEC, SSDATA, DARE

% recovering state space matrices
[mA,mB,mC,mD] = ssdata(sys); 

% checking stabilizability and detectability
[~,bStab] = checkReachStab(mA,mB,'discrete');
[~,bDetec] = checkObsDetec(mA,mC,'discrete');

if bStab==false || bDetec==false
    cvXhatSS = [];
    mPSS = [];
    error('System not stabilizable and/or not detectable')
end

% computing Q and R (recall that v(t),w(t) are assumed to be uncorrelated 
% and of unit-variance)
mQ = mB*mB';
mR = mD*mD';

mPSS = dare(mA',mC',mQ,mR); % steady-state prediction error covariance

mLambda = mC*mPSS*mC'+ mR; % innovations process variance
mL = mPSS*mC'*mLambda^-1; % steady-state predictor gain
mK = mA*mL; % steady-state Kalman gain

cvXhatSS = mA*cvX0 + mK*(cvY0-mC*cvX0); % Kalman steady-state prediction
