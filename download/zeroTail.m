function rvY = zeroTail(rvX)
% ZEROTAIL set to zero the last 3 entries of a vector
% Inputs:   - rvX: input vector of dimension >= 3
% Outputs:  - rvY: output vector

if length(rvX) < 3
    error('The input vector must have dimension >=3')
end

rvY = rvX;
rvY(end-2:end) = 0;

end