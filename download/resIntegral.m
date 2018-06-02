function dInt = resIntegral(tfF)
% RESINTEGRAL compute the integral
%   \frac{1}{2\pi} \int_{-\pi}^\pi F(e^{j\theta}) d\theta
% of a rational transfer function F(z) analytic on the unit circle using 
% the  residue formula.
% Input:   tfF: rational transfer function F(z)
% Outputs:  dInt: integral value
% SEE ALSO
% RESIDUE, INTERSECT, UNIQUE, TFDATA, MINREAL

% computing coprime representation
tfFmin = minreal(tfF);
% recovering numerator and denominator polynomials
[rvN,rvD] = tfdata(tfFmin,'v');

% computing residues and poles of F(z)/z
[cvR,cvP,~] = residue(rvN,[rvD 0]);

% extracting the stable poles,...
cvPc = cvP(abs(cvP)<1);
% ...the corresponding indices...
[cvPc,cvIc,~] = intersect(cvP,cvPc);
% ...and the corresponding residues
cvRc = cvR(cvIc);
% finding the indices corresponding to the "one-multiplicity" residues...
[~,cvIc1,~] = unique(cvPc, 'first');
% ...and extracting their values
cvRc1 = cvRc(cvIc1);

% evaluating the integral by summing the "one-multiplicity" residues 
dInt = sum(cvRc1);
end