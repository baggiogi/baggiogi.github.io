function [bS,bMP] = checkTFStability(tfG)
% CHECKTFSTABILITY check if a causal rationa scalar discrete-time transfer 
% function  is stable and minimum-phase
% Input:   tfG: transfer function
% Outputs:  - bS: boolean variable set to 'true' if (a coprime representation)
%            of tfG is stable and to 'false' otherwise
%           - bMP: boolean variable set to 'true' if minimum-phase and to
%           'false' otherwise
% SEE ALSO
% MINREAL, TFDATA, ROOTS

% computing coprime representation of tfG
tfGmin = minreal(tfG);
[rvN,rvD] = tfdata(tfGmin,'v');

% checking stability
if any(abs(roots(rvD)) >= 1)
    bS = false;
else
    bS = true;
end

% checking minimum-phase condition
if bS == false || any(abs(roots(rvN)) >= 1)
    bMP = false;
else
    bMP = true;
end

end