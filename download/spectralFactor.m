function tfW = spectralFactor(tfPhi)
% SPECTRALFACTOR compute the minimum-phase spectral factor of a given 
% rational scalar discrete-time spectral density
% Input:   tfPhi: rational scalar spectral density
% Output:  tfW: minimum-phase spectral factor of tfPhi
% SEE ALSO
% MINREAL, ZPKDATA

[cvZ,cvP,dK] = zpkdata(minreal(tfPhi),'v');
z = tf('z');
tfW = 1;

cvZ=round(cvZ,3);
cvP=round(cvP,3);

dRelDeg=0;

for i=1:length(cvZ)
    if abs(cvZ(i))<1 && (cvZ(i)~=0)
        tfW = tfW*(z-cvZ(i));
        dRelDeg=dRelDeg-1;
        dK=-dK/cvZ(i);
    elseif abs(cvZ(i))==1 && (cvZ(i)~=0)
        if mod(sum(cvZ(i:end)==cvZ(i)),2)==1
            tfW = tfW*(z-cvZ(i));
            dRelDeg=dRelDeg-1;
            dK=-dK/cvZ(i);
        end
    end
end

for i=1:length(cvP)
    if abs(cvP(i))<1 && (cvP(i)~=0)
        tfW=tfW/(z-cvP(i));
        dRelDeg=dRelDeg+1;
        dK=-dK*cvP(i);
    end
end

tfW=sqrt(dK)*tfW*z^(dRelDeg);