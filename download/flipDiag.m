function mY = flipDiag(mX)
% FLIPDIAG flip the diagonal of a matrix
% Inputs:   - mX: input matrix
% Outputs:  - mY: output matrix

mY = mX - diag(diag(mX)) + diag(flipud(diag(mX)));

end