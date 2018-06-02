function [tfCaus,tfACaus] = causalPart(tfG)
% CAUSALPART compute the causal and strictly anti-causal part of a rational
% transfer function G(z) analytic on the unit circle.
% Input:   tfG: rational transfer function G(z)
% Outputs:  - tfCaus: causal part of tfG
%           - tfACaus: strictly anti-causal part of tfG
% SEE ALSO
% RESIDUE, TFDATA, MINREAL

% computing coprime representation
tfGmin = minreal(tfG);
% recovering numerator and denominator polynomials
[rvN,rvD] = tfdata(tfGmin,'v');

% computing residues and poles of G(z)
[cvR,cvP,rvK] = residue(rvN,rvD);
rvPolesC = [];
rvPolesAC = [];
rvResC = [];
rvResAC = [];
dKm = 0;

% extracting poles and residues of the causal (C) and anticausal part (AC)
for i = 1:length(cvP)
    if abs(cvP(i)) < 1
        rvPolesC = [rvPolesC cvP(i)];
        rvResC = [rvResC cvR(i)];
    else
        rvPolesAC = [rvPolesAC cvP(i)];
        rvResAC = [rvResAC cvR(i)];
    end
end

[Ncaus,Dcaus] = residue(rvResC,rvPolesC,0);
tfCaus = tf(Ncaus,Dcaus,-1);

% computing coefficient k_0^-
i = 1;
while i < length(rvPolesAC)+1
    iInd = find(rvPolesAC == rvPolesAC(i));
    iM = length(iInd);
    for j=1:iM
        dKm = dKm - rvResAC(i)/((-rvPolesAC(i))^j);
        i = i + 1;
    end
end

% computing coefficient k_0
dK0 = 0;
if ~isempty(rvK)
    dK0 = rvK(length(rvK));
end

% computing coefficient k_0^+
dKp = dK0-dKm;

% computing causal... 
tfCaus = minreal(tfCaus +dKp);
%...and anticausal part
tfACaus = minreal(tfG - tfCaus);

end